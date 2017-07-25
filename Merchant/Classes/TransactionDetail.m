//
//  TransactionDetail.m
//  Merchant
//
//  Created by Alex on 6/19/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TransactionDetail.h"
#import "NSDate+Utilities.h"

@interface TransactionDetail () {

    IBOutlet UILabel *currencyLbl;
    IBOutlet UILabel *btcLbl;
    IBOutlet UILabel *subtotalLbl;
    IBOutlet UILabel *tipLbl;
    IBOutlet UILabel *totalLbl;
    IBOutlet UILabel *dateLbl;
}

@end

@implementation TransactionDetail
@synthesize payment;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    currencyLbl.text = [NSString stringWithFormat:@"%@ %@", payment.total, payment.currency];
    btcLbl.text =  [NSString stringWithFormat:@"%@ BTC", payment.bitcoin];
    subtotalLbl.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"transaction.subtotal", nil), payment.subtotal];
    tipLbl.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"transaction.tip", nil), payment.tip];
    totalLbl.text = [NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"transaction.total", nil), payment.total];
    
    NSString *status = @"";
    if ([payment.type isEqualToString:@"O"]) {
        status = NSLocalizedString(@"qr.overpaid.title", nil);
    } else if ([payment.type isEqualToString:@"I"]) {
        status = NSLocalizedString(@"qr.insufficient.payment.title", nil);
    } else {
        status = @"";
    }
    
    dateLbl.text = status;
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
