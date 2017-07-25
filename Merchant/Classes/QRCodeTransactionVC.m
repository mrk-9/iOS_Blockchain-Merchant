//
//  QRCodeTransactionVC.m
//  Merchant
//
//  Created by Alex on 6/14/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "QRCodeTransactionVC.h"

#import "SRWebSocket.h"
#import <CoreBitcoin/CoreBitcoin.h>
#import <AudioToolbox/AudioToolbox.h>

static NSString *const kBlockChainWebSocketSubscribeAddressFormat = @"{\"op\":\"addr_sub\",\"addr\":\"%@\"}";

@interface QRCodeTransactionVC () <SRWebSocketDelegate> {
    IBOutlet UILabel *currencyPriceLbl;
    IBOutlet UILabel *bitcoinPriceLbl;
    IBOutlet UIImageView *qrCodeImageView;
    IBOutlet UILabel *infoLbl;
    
    NSString *totalValueStr;
    NSString *btcValueStr;
    
    NSUInteger retryCount;
    BOOL successfulTransaction;
}

@property (strong, nonatomic) BCMNetworking *networking;
@property (strong, nonatomic) SRWebSocket *transactionSocket;

@end

@implementation QRCodeTransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.networking = [BCMNetworking sharedInstance];
    
    totalValueStr = [self.dic objectForKey:KEY_TOTAL];
    btcValueStr = [self.dic objectForKey:KEY_BTC];
    
    [self setActiveTransaction];
}

- (IBAction)cancelBtnAction:(id)sender {
    [self postFormatNofitication];
    
    [self closeSocketAndGoBack];
}

- (IBAction)backBtnAction:(id)sender {
    [self closeSocketAndGoBack];
}

-(void)postFormatNofitication {
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_QR_CANCEL object:@"cancel" userInfo:nil];
}

-(void)closeSocketAndGoBack {
    successfulTransaction = YES;
    AudioServicesPlaySystemSound(1112);
    [self.transactionSocket close];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setActiveTransaction
{
    currencyPriceLbl.text = [NSString stringWithFormat:@"$%@", totalValueStr];
    bitcoinPriceLbl.text = [NSString stringWithFormat:@"%@ BTC", btcValueStr];
    infoLbl.text = NSLocalizedString(@"qr.trasnasction.info.waiting", nil);
    
    // Need to set bitcoin price
    NSString *merchantAddress = [Utils getObjectFromUserDefaultsForKey:KEY_WALLET];//[BCMMerchantManager sharedInstance].activeMerchant.walletAddress;
    merchantAddress = [merchantAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *qrEncodeString = [NSString stringWithFormat:@"bitcoin://%@?amount=%@", merchantAddress, btcValueStr];
    qrCodeImageView.image = [BTCQRCode imageForString:qrEncodeString size:qrCodeImageView.frame.size scale:[[UIScreen mainScreen] scale]];
    successfulTransaction = NO;
    
    if (!self.transactionSocket || self.transactionSocket.readyState == SOCKET_STATE_CLOSING || self.transactionSocket.readyState == SOCKET_STATE_CLOSED) {
        [self openSocket];
    }
}

- (void)openSocket
{
    NSString *urlString = WEB_SOCKET_URL;
    self.transactionSocket = [[SRWebSocket alloc] initWithURL:[NSURL URLWithString:urlString]];
    self.transactionSocket.delegate = self;
    [self.transactionSocket open];
}

- (void)retryOpenSocket
{
    // Something caused this socket to close, we'll retry up to three times
    if (retryCount < 3) {
        [self openSocket];
        retryCount++;
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.Oops", nil) message:NSLocalizedString(@"alert.transaction.problem", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

- (void)webSocketDidOpen:(SRWebSocket *)webSocket
{
    NSString *merchantAddress = [Utils getObjectFromUserDefaultsForKey:KEY_WALLET];
    merchantAddress = [merchantAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *subscribeToAddress = [NSString stringWithFormat:kBlockChainWebSocketSubscribeAddressFormat,merchantAddress];
    [self.transactionSocket send:subscribeToAddress];
}

- (void)webSocket:(SRWebSocket *)webSocket didFailWithError:(NSError *)error
{
    [self retryOpenSocket];
}

- (void)webSocket:(SRWebSocket *)webSocket didCloseWithCode:(NSInteger)code reason:(NSString *)reason wasClean:(BOOL)wasClean
{
    if (!successfulTransaction) {
        [self retryOpenSocket];
    }
}

- (void)webSocket:(SRWebSocket *)webSocket didReceiveMessage:(id)message
{
    NSString *jsonResponse = (NSString *)message;
    NSData *jsonData = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
    
    NSLog(@"===1===");
    NSLog(@"message:%@", message);
    // Check to see if we have new transaction
    NSString *operationType = [jsonDict safeObjectForKey:@"op"];
    if ([operationType isEqualToString:@"utx"]) {
        NSDictionary *transtionDict = [jsonDict safeObjectForKey:@"x"];
        NSString *transactionHash = [transtionDict safeObjectForKey:@"hash"];
        NSString *merchantAddress = [Utils getObjectFromUserDefaultsForKey:KEY_WALLET];
        [self.networking lookUpTransactionResultWithHash:transactionHash address:merchantAddress completion:^(NSData *data, NSURLResponse *response, NSError *error) {
            if (error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"general.Oops", nil) message:NSLocalizedString(@"alert.transaction.problem", nil) preferredStyle:UIAlertControllerStyleAlert];
                    
                    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
                    [alertController addAction:ok];
                    
                    [self presentViewController:alertController animated:YES completion:nil];
                });
                return;
            }
            
            NSLog(@"===2===");
            NSDecimalNumber *btcNum = [NSDecimalNumber decimalNumberWithString:btcValueStr];
            
            uint64_t amountRequested = [[btcNum decimalNumberByMultiplyingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:SATOSHI]] longLongValue];
            uint64_t amountReceived = [[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding] longLongValue];
            
            uint64_t toconvertAmountForCurrency = (uint64_t)amountReceived * 0.97;
            NSString *currency = [Utils getObjectFromUserDefaultsForKey:KEY_CURRENCY];
            
            [self.networking convertToCurrency:[currency uppercaseString] fromAmount:toconvertAmountForCurrency success:^(NSURLRequest *request, NSDictionary *dict) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSLog(@"===3===");
                    NSLog(@"dict:%@", dict);
                    NSString *amountReceivedFiat = [dict safeObjectForKey:@"fiatValue"];
                    
                    if (amountReceived >= amountRequested) {
                        successfulTransaction = YES; //this is overried for overpaid payment
                        infoLbl.text = NSLocalizedString(@"qr.trasnasction.info.received", nil);//this is as well.
                        AudioServicesPlaySystemSound(1111);
                        
                        if (amountReceived > amountRequested) {
                            NSLog(@"===11===");
                            NSDecimalNumber *amountReceivedDecimal = [(NSDecimalNumber *)[NSDecimalNumber numberWithLongLong:amountReceived] decimalNumberByDividingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:SATOSHI]];
                            
                            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"qr.overpaid.title", @"") message:[NSString stringWithFormat:NSLocalizedString(@"qr.overpaid.message", @""), amountReceivedDecimal, btcNum] preferredStyle:UIAlertControllerStyleAlert];
                            
                            UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                                 [self transactionCompleted];
                            }];
                            [alertController addAction:ok];
                            
                            [self presentViewController:alertController animated:YES completion:nil];
                            
                            //Overpaid
                            [self saveTransaction:amountReceivedFiat BTC:amountReceivedDecimal withFlag:@"O"];
                            
                        } else {
                            //normal paid
                            NSLog(@"===12===");
                            [self saveTransaction:amountReceivedFiat BTC:btcNum withFlag:@"N"];
                             [self transactionCompleted];
                        }
                       
                    } else {
                        AudioServicesPlaySystemSound(1112);
                        NSLog(@"Insufficient payment: requested %lld, received %lld", amountRequested, amountReceived);
                        successfulTransaction = NO;
                        [self resetQRCodeAfterPartialPayment:amountReceived fiat:amountReceivedFiat];
                    }
                });
            } error:^(NSURLRequest *request, NSError *error) {
                // Display alert to prevent the user from continuing
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"network.problem.title", nil) message:NSLocalizedString(@"network.problem.detail", nil) preferredStyle:UIAlertControllerStyleAlert];
                
                UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
                [alertController addAction:ok];
                
                [self presentViewController:alertController animated:YES completion:nil];
                
            }];
        }];
    }
}

- (void)resetQRCodeAfterPartialPayment:(uint64_t)partialPayment fiat:(NSString *)amountReceivedFiat
{
    NSDecimalNumber *convertedAmountReceived = [(NSDecimalNumber*)[NSDecimalNumber numberWithLongLong:partialPayment] decimalNumberByDividingBy:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:SATOSHI]];
    NSDecimalNumber *btcNum = [NSDecimalNumber decimalNumberWithString:btcValueStr];
    NSDecimalNumber *amountLeftToPay = [btcNum decimalNumberBySubtracting:convertedAmountReceived];
    uint64_t amountLeftToPayConverted = [([amountLeftToPay decimalNumberByMultiplyingBy:(NSDecimalNumber*)[NSDecimalNumber numberWithDouble:SATOSHI]]) longLongValue];
    
    [self saveTransaction:amountReceivedFiat BTC:convertedAmountReceived withFlag:@"I"];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"qr.insufficient.payment.title", @"") message:[NSString stringWithFormat:NSLocalizedString(@"qr.insufficient.payment.message", @""), bitcoinPriceLbl.text, convertedAmountReceived] preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", @"") style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    NSString *bitcoinAmountString = [[(NSDecimalNumber *)[NSDecimalNumber numberWithLongLong:amountLeftToPayConverted] decimalNumberByDividingBy:(NSDecimalNumber *)[NSDecimalNumber numberWithDouble:SATOSHI]] stringValue];
    NSDecimalNumber *amountLeftToPayFiat = [[NSDecimalNumber decimalNumberWithString:totalValueStr] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:amountReceivedFiat]];
    
    totalValueStr = [NSString stringWithFormat:@"%@", amountLeftToPayFiat];
    btcValueStr = bitcoinAmountString;
    
    [self setActiveTransaction];
    
}

-(void)saveTransaction:(NSString*)receivedAmount BTC:(NSDecimalNumber*)receivedBTC withFlag:(NSString*)status {
    NSLog(@"Save Transaction: %@, %@", receivedAmount, receivedBTC);
    NSLog(@"Status:%@", status);
    
    NSString *total = receivedAmount;
    NSString *btc = [NSString stringWithFormat:@"%@", receivedBTC];
    NSString *tip = [self.dic objectForKey:KEY_TIP];
    NSDecimalNumber *amountSubtotal= [[NSDecimalNumber decimalNumberWithString:total] decimalNumberBySubtracting:[NSDecimalNumber decimalNumberWithString:tip]];
    NSString *subtotal = [NSString stringWithFormat:@"%@", amountSubtotal];
    NSString *currency = [Utils getObjectFromUserDefaultsForKey:KEY_CURRENCY];
    
    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:subtotal, KEY_SUBTOTAL, tip, KEY_TIP, total, KEY_TOTAL, btc, KEY_BTC, currency, KEY_CURRENCY, status, KEY_TYPE, [NSDate date], KEY_DATE, @"", KEY_SENDER, [Utils getObjectFromUserDefaultsForKey:KEY_WALLET], KEY_WALLET, nil];
    
    [[DataManager sharedInstance] saveTransaction:dict];
    
    /* // This is old code using NSUserDefault. Now this is replaced with CoreData
    Payment *pObj = [[Payment alloc] initWithDict:dict];
    
    NSArray *ary = [Utils getObjectFromUserDefaultsForKey:KEY_PAYMENT];
    NSMutableArray *pAry;
    if (ary == nil) {
        pAry = [[NSMutableArray alloc] initWithObjects:pObj, nil];
    } else {
        pAry = [[NSMutableArray alloc] init];
        [pAry addObjectsFromArray:ary];
        [pAry addObject:pObj];
    }
    
    NSMutableArray *archiveArray = [NSMutableArray arrayWithCapacity:pAry.count];
    for (Payment *pObject in pAry) {
        NSData *pEncodedObject = [NSKeyedArchiver archivedDataWithRootObject:pObject];
        [archiveArray addObject:pEncodedObject];
    }
    [Utils setObjectToUserDefaults:archiveArray inUserDefaultsForKey:KEY_PAYMENT];
    */
    
    
}

- (void)transactionCompleted
{
    successfulTransaction = YES;
    infoLbl.text = NSLocalizedString(@"qr.trasnasction.info.received", nil);
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:NSLocalizedString(@"qr.trasnasction.info.received", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self postFormatNofitication];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
