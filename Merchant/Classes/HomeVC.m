//
//  HomeVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "HomeVC.h"
#import "QRCodeTransactionVC.h"
#import <AudioToolbox/AudioToolbox.h>

#define SEGUE_GO_QRTRANS @"goQRTranSegue"

@interface HomeVC () < UITextFieldDelegate >{

    IBOutlet UIView *subTotalBox;
    IBOutlet UIView *tipBox;
    IBOutlet UIView *totalBox;
    IBOutlet UITextField *subTotalFld;
    IBOutlet UILabel *subTotalUnit;
    IBOutlet UITextField *tipFld;
    IBOutlet UILabel *totalLbl;
    IBOutlet UIView *tipView;
    IBOutlet UIView *totalView;
    
    UIToolbar *m_toolBar;
    UIBarButtonItem *barButtonDone;
    NSString *btcValue;
    IBOutlet NSLayoutConstraint *infoLblHeightConst;
}

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    btcValue = @"0";
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.frame = CGRectMake((self.view.bounds.size.width-117) / 2, 0, 117, 37);
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationController.navigationBar addSubview:logoView];
    
//    self.navigationItem.titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]];
//    self.navigationItem.rightBarButtonItem.enabled = false;
    
    [Utils CustomViewWithBlack:subTotalBox];
    [Utils CustomViewWithBlack:tipBox];
    [Utils CustomViewWithBlack:totalBox];
    
    m_toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [m_toolBar setBarStyle:UIBarStyleDefault];
    [m_toolBar setBackgroundImage:[UIImage new]
                  forToolbarPosition:UIToolbarPositionAny
                          barMetrics:UIBarMetricsDefault];
    [m_toolBar setBackgroundColor:COLOR_GREEN];
    
    UIBarButtonItem *barButtonCancel = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"action.cancel", nil) style:UIBarButtonItemStylePlain target:self action:@selector(cancelAction:)];
    barButtonDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIBarButtonItemStylePlain target:self action:@selector(payAction:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    m_toolBar.items = [[NSArray alloc] initWithObjects:barButtonCancel, flexibleItem, barButtonDone, nil];
    barButtonCancel.tintColor = [UIColor whiteColor];
    barButtonDone.tintColor = [UIColor whiteColor];
    subTotalFld.inputAccessoryView = m_toolBar;
    
    [self hiddenTipAndTotalViews];
    [subTotalFld becomeFirstResponder];
    
    [tipFld addTarget:self
                  action:@selector(textFieldDidChange:)
        forControlEvents:UIControlEventEditingChanged];
    [subTotalFld addTarget:self
               action:@selector(textFieldDidChange:)
     forControlEvents:UIControlEventEditingChanged];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(paymentCancelled:) name:NOTIFICATION_QR_CANCEL object:nil];
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    if (self.view.frame.size.height <= 568) {
        //iPhone 5s
        infoLblHeightConst.constant = 10;
        [self.view layoutIfNeeded];
    }
    
}
//- (void) viewWillDisappear:(BOOL)animated {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)paymentCancelled:(NSNotification *)notification{
    [self cancelAmounts];
}

-(void) hiddenTipAndTotalViews {
    [tipView setHidden:YES];
    [totalView setHidden:YES];
}

-(void) showTipAndTotalViews {
    [tipView setHidden:NO];
    [totalView setHidden:NO];
}

-(void)disableOKButton {
    subTotalFld.enabled = NO;
    [barButtonDone setTitle:NSLocalizedString(@"action.pay", nil)];
}

-(void)enableOKButton {
    subTotalFld.enabled = YES;
    [barButtonDone setTitle:NSLocalizedString(@"alert.ok", nil)];
}

- (IBAction)menuBtnAction:(id)sender {
    
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

-(void)cancelAction:(id)sender {
    AudioServicesPlaySystemSound(1112);//confirm:1111
    
    [self cancelAmounts];
    
    //This is templete code for CoreData test
//    NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:@"1.0", KEY_SUBTOTAL, @"0.2", KEY_TIP, @"1.2", KEY_TOTAL, @"0.00003045", KEY_BTC, @"CAD", KEY_CURRENCY, @"N", KEY_TYPE, [NSDate date], KEY_DATE, @"", KEY_SENDER, [Utils getObjectFromUserDefaultsForKey:KEY_WALLET], KEY_WALLET, nil];
//    
//    [[DataManager sharedInstance] saveTransaction:dict];
    
    
}

-(void)cancelAmounts {
    [self hiddenTipAndTotalViews];
    [self enableOKButton];
    
    subTotalFld.text = @"";
    tipFld.text = @"";
    [subTotalFld becomeFirstResponder];
}

-(void)payAction:(id)sender {
    
    if ([barButtonDone.title isEqualToString:NSLocalizedString(@"alert.ok", nil)]) {
        [self showTipAndTotalViews];
        [self disableOKButton];
        [tipFld becomeFirstResponder];
    } else {
        AudioServicesPlaySystemSound(1111);
        [self requestMerchant];
    }
    
}

-(void)requestMerchant {
    [self performSegueWithIdentifier:SEGUE_GO_QRTRANS sender:self];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField.text containsString:@","]) {
        NSArray *listItems = [textField.text componentsSeparatedByString:@","];
        NSString *str1 = listItems[1];
        if ([str1 length] >= 2) {
            return NO;
        } else return YES;
    } else return YES;
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    textField.inputAccessoryView = m_toolBar;
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
//    [textField resignFirstResponder];
    
    return YES;
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    float subtotal = [self changeStrToFloat:subTotalFld.text];
    float tip = [self changeStrToFloat:tipFld.text];
    float total = subtotal + tip;
    totalLbl.text = [NSString stringWithFormat:@"%.2f", total];
    [self updateBitcoinAmountLabel:totalLbl.text];
}

-(float)changeStrToFloat:(NSString*)str{
    str = [str stringByReplacingOccurrencesOfString:@","
                                         withString:@"."];
    return [str floatValue];
}

- (void)updateBitcoinAmountLabel:(NSString *)convertedText
{
    NSCharacterSet *whiteSpaceSet = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    
    if ([convertedText isEqualToString:@""] || [[convertedText stringByTrimmingCharactersInSet:whiteSpaceSet] length] == 0) {
        convertedText = @"0";
    }
    
    NSString *currency = [Utils getObjectFromUserDefaultsForKey:KEY_CURRENCY];
    
    NSDecimalNumber *currencyAmount = [NSDecimalNumber decimalNumberWithString:convertedText];
    currencyAmount = (NSDecimalNumber *)[currencyAmount decimalNumberByDividingBy:[[NSDecimalNumber alloc] initWithFloat:0.97f]];
    
    [[BCMNetworking sharedInstance] convertToBitcoinFromAmount:currencyAmount fromCurrency:[currency uppercaseString] success:^(NSURLRequest *request, NSDictionary *dict) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Dict:%@", dict);
            float bitcoinValue = [[dict safeObjectForKey:@"btcValue"] floatValue];
            
//            bitcoinValue = bitcoinValue / 0.97;
            
            btcValue = [NSString stringWithFormat:@"%f", bitcoinValue];
            
            NSLog(@"bitValue:%@", btcValue);
        });
    } error:^(NSURLRequest *request, NSError *error) {
        // Display alert to prevent the user from continuing
        dispatch_async(dispatch_get_main_queue(), ^{
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"network.problem.title", nil) message:NSLocalizedString(@"network.problem.detail", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        });
    }];
}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if([segue.identifier isEqualToString:SEGUE_GO_QRTRANS])
    {
        QRCodeTransactionVC *vc = (QRCodeTransactionVC *) [segue destinationViewController];
        NSString *tipAmount = tipFld.text;
        if ([tipAmount isEqualToString:@""]) {
            tipAmount = @"0";
        }
        NSDictionary *dict = [[NSDictionary alloc] initWithObjectsAndKeys:subTotalFld.text, KEY_SUBTOTAL, tipAmount, KEY_TIP, totalLbl.text, KEY_TOTAL, btcValue, KEY_BTC,nil];
        vc.dic = dict;     
    }
}


@end
