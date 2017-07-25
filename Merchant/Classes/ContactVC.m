//
//  ContactVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ContactVC.h"
#import "MenuCell.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactVC () < UITableViewDelegate, UITableViewDataSource, MFMailComposeViewControllerDelegate > {
    NSArray *titleAry;
    NSInteger selectedIndex;
}
@property (strong, nonatomic) IBOutlet UITableView *tableview;

@end

@implementation ContactVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    titleAry =@[NSLocalizedString(@"contact.website", nil),
                NSLocalizedString(@"contact.email", nil),
                NSLocalizedString(@"contact.phone", nil),
                NSLocalizedString(@"contact.facebook", nil),
                NSLocalizedString(@"contact.twitter", nil),
                NSLocalizedString(@"contact.google", nil),
                NSLocalizedString(@"contact.youtube", nil)];
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
    return titleAry.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCell * cell = [tableView dequeueReusableCellWithIdentifier:@"contactCell" forIndexPath:indexPath];
    
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"icons8-%ld.png", (long)indexPath.row]];
    cell.titleLbl.text = [titleAry objectAtIndex:(long)indexPath.row];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    
    if (indexPath.row == 1) {
        //email
        if([MFMailComposeViewController canSendMail]) {
            MFMailComposeViewController *mailCont = [[MFMailComposeViewController alloc] init];
            mailCont.mailComposeDelegate = self;
            
            [mailCont setSubject:@"From Bolckchain Merchant App"];
            [mailCont setToRecipients:[NSArray arrayWithObject:CONTACT_EMAIL]];
            [mailCont setMessageBody:@" " isHTML:NO];
            
            [self presentViewController:mailCont animated:YES completion:nil];
        }
    } else if(indexPath.row == 2) {
        //phone call
        NSURL *phoneUrl = [NSURL URLWithString:[NSString  stringWithFormat:@"telprompt:%@",CONTACT_PHONE]];
        
        if ([[UIApplication sharedApplication] canOpenURL:phoneUrl]) {
            [[UIApplication sharedApplication] openURL:phoneUrl];
        } else
        {
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"action.error", nil) message:NSLocalizedString(@"alert.invalid.phonecall", nil) preferredStyle:UIAlertControllerStyleAlert];
            
            UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
            [alertController addAction:ok];
            
            [self presentViewController:alertController animated:YES completion:nil];
        }
    } else {
        if (indexPath.row == 0) {
            //website
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WEB_SITE]];
        } else if (indexPath.row == 3) {
            //facebook
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CONTACT_FACEBOOK]];
        } else if (indexPath.row == 4) {
            //twitter
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CONTACT_TWITTER]];
        } else if (indexPath.row == 5) {
            //google
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CONTACT_GOOGLE]];
        } else if (indexPath.row == 6) {
            //youtube
            [ProgressHUD showError:@"Pending"];
//            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:CONTACT_YOUTUBE]];
        }
    }
}

#pragma mark - Message Delegate Method

- (void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error {
    [self dismissViewControllerAnimated:YES completion:nil];
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
