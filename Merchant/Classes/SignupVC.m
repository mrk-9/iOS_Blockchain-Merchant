//
//  SignupVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SignupVC.h"
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"
#import "AppDelegate.h"

@interface SignupVC () < UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, QRCodeReaderDelegate >{

    IBOutlet UITextField *nameFld;
    IBOutlet UITextField *currencyFld;
    IBOutlet UITextField *walletFld;
    IBOutlet UILabel *pinLbl;
    
    UIPickerView *m_pickerView;
    NSArray *pickerDataSourceArray;
    UIToolbar *m_toolBar;
    IBOutlet UIBarButtonItem *saveBtnItem;
    NSString *pinStr;
}

@end

@implementation SignupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerDataSourceArray = @[@"BTC", @"CAD", @"USD"];
    
    [Utils CustomViewWithGrey:nameFld];
    [Utils CustomViewWithGrey:currencyFld];
    [Utils CustomViewWithGrey:walletFld];
    [Utils CustomViewWithGrey:pinLbl];
    
    m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    m_pickerView.delegate = self;
    m_pickerView.dataSource = self;
    currencyFld.inputView = m_pickerView;
    
    m_toolBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 44)];
    [m_toolBar setBarStyle:UIBarStyleDefault];
    [m_toolBar setBackgroundImage:[UIImage new]
               forToolbarPosition:UIToolbarPositionAny
                       barMetrics:UIBarMetricsDefault];
    [m_toolBar setBackgroundColor:COLOR_GREEN];
    
    UIBarButtonItem *barButtonDone = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"general.done", nil) style:UIBarButtonItemStylePlain target:self action:@selector(btnSelectClick:)];
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    m_toolBar.items = [[NSArray alloc] initWithObjects:flexibleItem, barButtonDone, nil];
    barButtonDone.tintColor = [UIColor whiteColor];
    currencyFld.inputAccessoryView = m_toolBar;
    
    currencyFld.text = pickerDataSourceArray[1];
    
    pinStr = @"";
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
    pinStr = notification.object;
    NSLog(@"pinStr:%@", pinStr);
    pinLbl.text = [NSString stringWithFormat:@"Pin: %@", pinStr];
    
}

- (void)btnSelectClick:(id)sender{
    [currencyFld resignFirstResponder];
//    currencyFld.text = pickerDataSourceArray[[m_pickerView selectedRowInComponent:0]];
}

- (IBAction)tapPinLabel:(id)sender {
    PinVC *pinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pinVC"];
    pinVC.type = TYPE_NEW;
    [self presentViewController:pinVC animated:YES completion:nil];
}

- (IBAction)cancelBtnClicked:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)saveBtnClicked:(id)sender {
    if ([nameFld.text isEqualToString:@""] || [currencyFld.text isEqualToString:@""] || [walletFld.text isEqualToString:@""]) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"signup.alert.title", nil) message:NSLocalizedString(@"signup.warning", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    
    NSLog(@"myPin:%@", pinStr);
    if ([pinStr length] < 6) {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"signup.alert.title", nil) message:NSLocalizedString(@"signup.warning", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
        
        return;
    }
    
    //save
    [Utils setObjectToUserDefaults:pinStr inUserDefaultsForKey:KEY_PIN];
    [Utils setObjectToUserDefaults:nameFld.text inUserDefaultsForKey:KEY_NAME];
    [Utils setObjectToUserDefaults:currencyFld.text inUserDefaultsForKey:KEY_CURRENCY];
    [Utils setObjectToUserDefaults:walletFld.text inUserDefaultsForKey:KEY_WALLET];
    [Utils setObjectToUserDefaults:@"YES" inUserDefaultsForKey:KEY_ISREGISTER];
    
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_ADDRESS];
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_CITY];
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_PROVINCY];
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_PHONE];
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_NOTE];
    [Utils setObjectToUserDefaults:@"" inUserDefaultsForKey:KEY_ZIPCODE];
    
    AppDelegate *del = (AppDelegate *)[UIApplication sharedApplication].delegate;
    UIViewController *homevc = [self.storyboard instantiateViewControllerWithIdentifier:@"homeVC1"];
    UIViewController *leftSideMenuViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"menuVC"];
    
    MFSideMenuContainerViewController *container = [MFSideMenuContainerViewController
                                                    containerWithCenterViewController:homevc
                                                    leftMenuViewController:leftSideMenuViewController
                                                    rightMenuViewController:nil];
    del.window.rootViewController = container;
}

- (IBAction)qrScanBtnClicked:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:@"Cancel" codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
            vc.modalPresentationStyle = UIModalPresentationFormSheet;
        });
        vc.delegate = self;
        
        [vc setCompletionWithBlock:^(NSString *resultAsString) {
            NSLog(@"Completion with result: %@", resultAsString);
        }];
        
        [self presentViewController:vc animated:YES completion:NULL];
    }
    else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"qr.scanning.permission.title", nil) message:NSLocalizedString(@"qr.scanning.permission.detail", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
   
    if ([textField isEqual:currencyFld]) {
        [m_pickerView reloadAllComponents];
        [m_pickerView selectRow:0 inComponent:0 animated:YES];
    }
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    
    return YES;
}

#pragma mark - UIPickerView
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return pickerDataSourceArray.count;
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return pickerDataSourceArray[row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    currencyFld.text = pickerDataSourceArray[row];
}

#pragma mark - QRCodeReader Delegate Methods

- (void)reader:(QRCodeReaderViewController *)reader didScanResult:(NSString *)result
{
    [reader stopScanning];
    NSLog(@"QRCode:%@", result);
    [self dismissViewControllerAnimated:YES completion:^{
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"QRCodeReader" message:result delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
//        [alert show];
    }];
    
    //check bitcoin
    if ([result containsString:@"bitcoin:"]) {
        NSString *str1;
        str1 = [result stringByReplacingOccurrencesOfString:@"bitcoin://" withString:@""];
        str1 = [result stringByReplacingOccurrencesOfString:@"bitcoin:" withString:@""];
        NSArray *listItems2 = [str1 componentsSeparatedByString:@"?"];
        NSString *bitcoinStr = listItems2[0];
        walletFld.text = bitcoinStr;
    } else {
        UIAlertController *alertController = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"action.error", nil) message:NSLocalizedString(@"qr.invalid", nil) preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:ok];
        
        [self presentViewController:alertController animated:YES completion:nil];
    }
    
}

- (void)readerDidCancel:(QRCodeReaderViewController *)reader
{
    [self dismissViewControllerAnimated:YES completion:NULL];
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
