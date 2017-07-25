//
//  MenuVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "MenuVC.h"
#import "HomeVC.h"
#import "TransactionVC.h"
#import "ATMsVC.h"
#import "SettingVC.h"
#import "LanguageVC.h"
#import "ContactVC.h"
#import "AboutVC.h"
#import "NewsVC.h"
#import "MenuCell.h"

@interface MenuVC ()< UITableViewDelegate, UITableViewDataSource > {
    NSArray *titleAry;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;

@end


@implementation MenuVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    titleAry =@[NSLocalizedString(@"menu.charge", nil),
                NSLocalizedString(@"menu.transactions", nil),
                NSLocalizedString(@"menu.atms", nil),
                NSLocalizedString(@"menu.news", nil),
                NSLocalizedString(@"menu.contact", nil),
                NSLocalizedString(@"menu.about", nil),
                NSLocalizedString(@"menu.setting", nil)];//, @"Language"
    
    UIImageView *logoView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"logo.png"]];
    logoView.frame = CGRectMake((self.view.bounds.size.width-117) / 2, 0, 117, 37);
    [logoView setContentMode:UIViewContentModeScaleAspectFit];
    [self.navigationController.navigationBar addSubview:logoView];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(pinSetted:) name:NOTIFICATION_PIN object:nil];
}

- (void) viewWillDisappear:(BOOL)animated {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)pinSetted:(NSNotification *)notification{
    NSString *pinStr = notification.object;
    //TODO
    NSLog(@"pinStr:%@", pinStr);
    NSString *myPin = [Utils getObjectFromUserDefaultsForKey:KEY_PIN];
    NSLog(@"myPin:%@", myPin);
    if ([pinStr isEqualToString:myPin]) {
        [self goSettingVC];
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"action.error", nil) message:NSLocalizedString(@"alert.invalid.passcode", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
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

- (UITableViewCell *)tableView:(UITableView *)tb cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * strId = @"menuCell";
    MenuCell * cell = [tb dequeueReusableCellWithIdentifier:strId forIndexPath:indexPath];
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"ic_menu%ld.png", (long)indexPath.row]];
    cell.titleLbl.text = [titleAry objectAtIndex:(long)indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil] ;
    
    if (indexPath.row == 0) {
        HomeVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"homeVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 1) {
        TransactionVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"transactionVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 2) {
        ATMsVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"ATMsVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 6) {
        PinVC *pinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pinVC"];
        pinVC.type = TYPE_COMFIRM;
        [self presentViewController:pinVC animated:YES completion:nil];
    } else if (indexPath.row == 7) { //removed in this version
        LanguageVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"languageVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 4) {
        ContactVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"contactVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 3) {
        NewsVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"newsVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    } else if (indexPath.row == 5) {
        AboutVC* vc = [storyboard  instantiateViewControllerWithIdentifier:@"aboutVC"];
        UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
        NSArray *controllers = [NSArray arrayWithObject:vc];
        navigationController.viewControllers = controllers;
        [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
    }
    
    [self.tableview deselectRowAtIndexPath:indexPath animated:YES];
}

-(void) goSettingVC {
    SettingVC* vc = [self.storyboard  instantiateViewControllerWithIdentifier:@"settingsVC"];
    UINavigationController *navigationController = self.menuContainerViewController.centerViewController;
    NSArray *controllers = [NSArray arrayWithObject:vc];
    navigationController.viewControllers = controllers;
    [self.menuContainerViewController setMenuState:MFSideMenuStateClosed];
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
