//
//  LocationVC.m
//  Merchant
//
//  Created by Alex on 6/16/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LocationVC.h"
#import <MapKit/MapKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <CoreLocation/CoreLocation.h>

#define METERS_PER_MILE 1609.344

@interface LocationVC () <MKMapViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate> {
    CLLocationCoordinate2D currentCentre;
    NSArray *locationAry;
}

@property (strong, nonatomic) IBOutlet MKMapView *map;
@end

@implementation LocationVC
@synthesize map;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    locationAry = @[
                    @{
                        @"Latitude" : @(45.536984),
                        @"Longitude" : @(-73.740935)
                        },
                    @{
                        @"Latitude" : @(45.472894),
                        @"Longitude" : @(-73.488371)
                        },
                    @{
                        @"Latitude" : @(45.548278),
                        @"Longitude" : @(-73.543014)
                        },
                    @{
                        @"Latitude" : @(45.542927),
                        @"Longitude" : @(-73.750681)
                        },
                    @{
                        @"Latitude" : @(45.532562),
                        @"Longitude" : @(-73.656129)
                        }
                    ];
    
    // show map
    currentCentre.latitude = [[locationAry[self.index] objectForKey:@"Latitude"] doubleValue];
    currentCentre.longitude= [[locationAry[self.index] objectForKey:@"Longitude"] doubleValue];
    
//    map.mapType = MKMapTypeSatellite;
    map.showsUserLocation = YES;
//    [map setCenterCoordinate:map.userLocation.location.coordinate animated:YES];
    
    NSLog(@"location: %f, %f", currentCentre.latitude, currentCentre.longitude);
    NSLog(@"User Location: %f, %f", map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude);
    
    //set pin
    MKPointAnnotation *atmPoint=[[MKPointAnnotation alloc]init];
    atmPoint.coordinate=currentCentre;
    atmPoint.title = self.place;
//    atmPoint.subtitle = self.address;
    [map addAnnotation:atmPoint];
    
    MKCoordinateRegion viewRegion = MKCoordinateRegionMakeWithDistance(currentCentre, 0.3*METERS_PER_MILE, 0.3*METERS_PER_MILE);
    [map setRegion:viewRegion animated:YES];
    
}

-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    [self openChooseOption];
    /*
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:currentCentre addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    if([destination respondsToSelector:@selector(openInMapsWithLaunchOptions:)])
    {
        //using iOS6 native maps app
        [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    } else{
        //using iOS 5 which has the Google Maps application
        NSString* url = [NSString stringWithFormat: @"http://maps.google.com/maps?saddr=Current+Location&daddr=%f,%f", currentCentre.latitude, currentCentre.longitude];
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: url]];
    } */
}

- (void)openChooseOption {
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Choose application for direction"
                                  message:nil
                                  preferredStyle:UIAlertControllerStyleActionSheet];
    
    UIAlertAction* mapButton = [UIAlertAction
                                   actionWithTitle:@"Maps"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action)
                                   {
                                       [self openMaps];
                                   }];
    UIAlertAction* cancelButton = [UIAlertAction
                                   actionWithTitle:@"Cancel"
                                   style:UIAlertActionStyleCancel
                                   handler:^(UIAlertAction * action)
                                   {
                                       
                                   }];
    [alert addAction:mapButton];
    [alert addAction:cancelButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

-(void)openMaps {
    NSString* directionsURL = [NSString stringWithFormat:@"http://maps.apple.com/?saddr=%f,%f&daddr=%f,%f",map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude, currentCentre.latitude, currentCentre.longitude];
    NSLog(@"User Location: %f, %f", map.userLocation.coordinate.latitude, map.userLocation.coordinate.longitude);
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: directionsURL]];
}

- (IBAction)backBtnAction:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
