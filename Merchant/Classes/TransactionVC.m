//
//  TransactionVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "TransactionVC.h"
#import "TransactionCell.h"
#import "NSDate+Utilities.h"
#import "TransactionDetail.h"

@interface TransactionVC ()< UITableViewDelegate, UITableViewDataSource > {
    NSArray *transactionAry;
    NSInteger selectedIndex;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation TransactionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    transactionAry = [Utils getObjectFromUserDefaultsForKey:KEY_PAYMENT];
    transactionAry = [[DataManager sharedInstance] getTransaction];
    
    if (transactionAry != nil && transactionAry.count > 0) {
        [self.tableview reloadData];
    }
    
    
    
}

- (IBAction)menuBtnAction:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tb
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tb numberOfRowsInSection:(NSInteger)section
{
    return [transactionAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TransactionCell * cell = [tableView dequeueReusableCellWithIdentifier:@"transactionCell" forIndexPath:indexPath];
    
    
//    NSData *notesData = transactionAry[indexPath.row];
//    Payment * payment = (Payment*)[NSKeyedUnarchiver unarchiveObjectWithData:notesData];
    Transaction *payment = transactionAry[indexPath.row];
    
    cell.amountLbl.text = [NSString stringWithFormat:@"%@ %@", payment.total, payment.currency];
    
    NSDate *transactionDate = payment.date;
    NSTimeInterval secondsBeforeNow = [[NSDate date] timeIntervalSinceDate:transactionDate];
    
    NSString *timeUnit = nil;
    NSString *timeValue = nil;
    
    if (secondsBeforeNow < 60) {
        timeUnit = NSLocalizedString(@"transaction.detail.seconds", nil);
        timeValue = [NSString stringWithFormat:@"%.0f %@ ago", (float)secondsBeforeNow, timeUnit];
    } else if (secondsBeforeNow >= 60 && secondsBeforeNow < 3600) {
        timeUnit = NSLocalizedString(@"transaction.detail.minutes", nil);
        timeValue = [NSString stringWithFormat:NSLocalizedString(@"transaction.detail.time.ago", nil), ceilf(secondsBeforeNow / 60), timeUnit];
    } else {
        timeUnit = @"";
        timeValue = [transactionDate shortDateString];
    }
    cell.timeLbl.text = timeValue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"toTransactionDetailSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toTransactionDetailSegue"])
    {
        TransactionDetail *vc = (TransactionDetail *) [segue destinationViewController];
        vc.payment = transactionAry[selectedIndex];
    }
}


@end
