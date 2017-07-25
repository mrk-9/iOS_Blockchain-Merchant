//
//  ATMsVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "ATMsVC.h"
#import "ATMCell.h"
#import "LocationVC.h"
#import <CoreLocation/CoreLocation.h>

@interface ATMsVC ()< UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate > {
    NSArray *locationAry;
    NSArray *addressAry;
    NSArray *timeAry;
    NSInteger selectedIndex;
    
    CLLocationManager *locationManager;
}

@property (strong, nonatomic) IBOutlet UITableView *tableview;
@end

@implementation ATMsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationAry = @[@"Chomedey INN",
                    @"Dépanneur 7 Jours Mirage",
                    @"Dépanneur Servo Soir",
                    @"Gaiters",
                    @"New Mondo"
                    ];
    addressAry = @[@"590 Boul Curé-Labelle, Laval, QC, H7V 2T6",
                    @"836 Boulevard Provencher, Brossard, QC, J4W 1Y6",
                    @"3893 Rue Ontario E, Montréal, QC, H1W 1S7",
                    @"978 Boulevard Curé-Labelle, Laval, QC H7V 2V5",
                    @"9258 Boulevard de l'Acadie, Montréal, QC, H4N 3C5"
                    ];
    timeAry     = @[@"Hours	24H",
                    @"Hours	8AM to 11PM",
                    @"Hours	24H",
                    @"Hours	8am to 3am",
                    @"Hours	11AM to 3AM"
                    ];
    
    locationManager = [[CLLocationManager alloc]init];
    locationManager.delegate = self;
    [locationManager requestAlwaysAuthorization];
    
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
    return [locationAry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ATMCell * cell = [tableView dequeueReusableCellWithIdentifier:@"atmCell" forIndexPath:indexPath];
    
    cell.img.image = [UIImage imageNamed:[NSString stringWithFormat:@"img_atm%ld.png", (long)indexPath.row + 1]];
    cell.locationLbl.text = locationAry[indexPath.row];
    cell.addressLbl.text = addressAry[indexPath.row];
    cell.timeLbl.text = timeAry[indexPath.row];
    cell.tagLbl.text = @"Buy & Sell";
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    selectedIndex = indexPath.row;
    [self performSegueWithIdentifier:@"toLocationSegue" sender:self];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"toLocationSegue"])
    {
        LocationVC *vc = (LocationVC *) [segue destinationViewController];
        vc.index = selectedIndex;
        vc.place = locationAry[selectedIndex];
        vc.address = addressAry[selectedIndex];
    }
}


@end
