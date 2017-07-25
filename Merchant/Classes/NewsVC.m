//
//  NewsVC.m
//  Merchant
//
//  Created by Alex on 6/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "NewsVC.h"
#import "NewsCell.h"
#import "Notify.h"
#import "NSDate+Utilities.h"

@interface NewsVC ()< UITableViewDelegate, UITableViewDataSource > {
    NSArray *newsAry;
    NSInteger selectedIndex;
    float newHeight;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation NewsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.frame = CGRectMake((self.view.bounds.size.width-117) / 2, 0, 117, 37);
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationController.navigationBar addSubview:logoView];
    
    [self getNotificationsFromOneSignal];
    
    newHeight = 80;
    selectedIndex = 9999999;
}

- (IBAction)menuBtnAction:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)getNotificationsFromOneSignal {
//    [ProgressHUD show:@"loading..."];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSString * urlString = [NSString stringWithFormat:@"https://onesignal.com/api/v1/notifications?app_id=%@", ONE_APP_ID];
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", ONE_REST_KEY];
    sessionConfiguration.HTTPAdditionalHeaders = @{@"Authorization": authValue};
    sessionConfiguration.requestCachePolicy = NSURLRequestReloadIgnoringCacheData;
    
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:urlString]];
    
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        [ProgressHUD dismiss];
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        if (!error) {
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
            if (httpResponse.statusCode == 200){
                NSDictionary *jsonData = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers|NSJSONReadingAllowFragments error:nil];
                newsAry = [jsonData objectForKey:@"notifications"];
                NSLog(@"push notification:%@", newsAry);
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableview reloadData];
                });
            }
        }
        
    }];
    
    [task resume];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tb
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tb numberOfRowsInSection:(NSInteger)section
{
    return [newsAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NewsCell * cell = [tableView dequeueReusableCellWithIdentifier:@"newsCell" forIndexPath:indexPath];
    
    
    NSDictionary *noti = newsAry[indexPath.row];
    
    NSDictionary *contentDic = [noti objectForKey:@"contents"];
    cell.detailLbl.text = [NSString stringWithFormat:@"%@", [contentDic objectForKey:@"en"]];
    
//    NSString *dateStr = [noti objectForKey:@"delivery_time_of_day"];
//    cell.timeLbl.text = dateStr;
    
    NSNumber *startTime = [noti objectForKey:@"queued_at"];
    NSDate *pushDate = [NSDate dateWithTimeIntervalSince1970:[startTime doubleValue]];
    NSLog(@"Date: %@", [Utils dateToString:pushDate format:@"yyyy-MM-dd HH:mm" timezone:@"UTC"]);
    NSTimeInterval secondsBeforeNow = [[NSDate date] timeIntervalSinceDate:pushDate];
    
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
        timeValue = [pushDate shortDateString];
    }
    cell.timeLbl.text = timeValue;
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    selectedIndex = indexPath.row;
    
    NSDictionary *noti = newsAry[selectedIndex];
    NSDictionary *contentDic = [noti objectForKey:@"contents"];
    NSString * description = [NSString stringWithFormat:@"%@", [contentDic objectForKey:@"en"]];
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:16]};
    CGRect rect = [description boundingRectWithSize:CGSizeMake(self.view.frame.size.width - 40, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil];
    newHeight = rect.size.height + 31;
    if (newHeight < 80) {
        newHeight = 80;
    }
    
    [self.tableview beginUpdates];
    [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
    [self.tableview endUpdates];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath.row == selectedIndex ? newHeight : 80;
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
