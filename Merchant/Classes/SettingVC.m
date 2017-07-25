//
//  SettingVC.m
//  Merchant
//
//  Created by Alex on 6/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "SettingVC.h"
#import "QRCodeReaderDelegate.h"
#import "QRCodeReaderViewController.h"
#import "QRCodeReader.h"

@interface SettingVC () < UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate, QRCodeReaderDelegate >{

    IBOutlet UITextField *nameFld;
    IBOutlet UITextField *addressFld;
    IBOutlet UITextField *cityFld;
    IBOutlet UITextField *provinceFld;
    IBOutlet UITextField *zipcodeFld;
    IBOutlet UITextField *phoneFld;
    IBOutlet UITextField *noteFld;
    IBOutlet UITextField *walletFld;
    IBOutlet UITextField *currencyFld;
    IBOutlet UILabel *pinLbl;
    
    UIPickerView *m_pickerView;
    NSArray *pickerDataSourceArray;
    UIToolbar *m_toolBar;
}

@end

@implementation SettingVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [Utils CustomViewWithGrey:nameFld];
    [Utils CustomViewWithGrey:addressFld];
    [Utils CustomViewWithGrey:cityFld];
    [Utils CustomViewWithGrey:provinceFld];
    [Utils CustomViewWithGrey:zipcodeFld];
    [Utils CustomViewWithGrey:phoneFld];
    [Utils CustomViewWithGrey:currencyFld];
    [Utils CustomViewWithGrey:walletFld];
    [Utils CustomViewWithGrey:noteFld];
    [Utils CustomViewWithGrey:pinLbl];
    
    pickerDataSourceArray = @[@"BTC", @"CAD", @"USD"];
    
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
    
    [self fillAvailableFields];
    
}

-(void)fillAvailableFields {
    nameFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_NAME];
    currencyFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_CURRENCY];
    walletFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_WALLET];
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_ADDRESS] isEqualToString:@""]) {
        addressFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_ADDRESS];
    }
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_CITY] isEqualToString:@""]) {
        cityFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_CITY];
    }
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_PROVINCY] isEqualToString:@""]) {
        provinceFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_PROVINCY];
    }
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_PHONE] isEqualToString:@""]) {
        phoneFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_PHONE];
    }
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_NOTE] isEqualToString:@""]) {
        noteFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_NOTE];
    }
    
    if (![[Utils getObjectFromUserDefaultsForKey:KEY_ZIPCODE] isEqualToString:@""]) {
        zipcodeFld.text = [Utils getObjectFromUserDefaultsForKey:KEY_ZIPCODE];
    }
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
    [Utils setObjectToUserDefaults:pinStr inUserDefaultsForKey:KEY_PIN];
}

- (void)btnSelectClick:(id)sender{
    [currencyFld resignFirstResponder];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (IBAction)saveBtnAction:(id)sender {
    [Utils setObjectToUserDefaults:nameFld.text inUserDefaultsForKey:KEY_NAME];
    [Utils setObjectToUserDefaults:currencyFld.text inUserDefaultsForKey:KEY_CURRENCY];
    [Utils setObjectToUserDefaults:walletFld.text inUserDefaultsForKey:KEY_WALLET];
    [Utils setObjectToUserDefaults:addressFld.text inUserDefaultsForKey:KEY_ADDRESS];
    [Utils setObjectToUserDefaults:cityFld.text inUserDefaultsForKey:KEY_CITY];
    [Utils setObjectToUserDefaults:provinceFld.text inUserDefaultsForKey:KEY_PROVINCY];
    [Utils setObjectToUserDefaults:phoneFld.text inUserDefaultsForKey:KEY_PHONE];
    [Utils setObjectToUserDefaults:noteFld.text inUserDefaultsForKey:KEY_NOTE];
    [Utils setObjectToUserDefaults:zipcodeFld.text inUserDefaultsForKey:KEY_ZIPCODE];
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"" message:NSLocalizedString(@"alert.save.success", nil) preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* ok = [UIAlertAction actionWithTitle:NSLocalizedString(@"alert.ok", nil) style:UIAlertActionStyleDefault handler:nil];
    [alertController addAction:ok];
    
    [self presentViewController:alertController animated:YES completion:nil];
}

- (IBAction)walletBtnAction:(id)sender {
    if ([QRCodeReader supportsMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]]) {
        static QRCodeReaderViewController *vc = nil;
        static dispatch_once_t onceToken;
        
        dispatch_once(&onceToken, ^{
            QRCodeReader *reader = [QRCodeReader readerWithMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
            vc                   = [QRCodeReaderViewController readerWithCancelButtonTitle:NSLocalizedString(@"action.cancel", nil) codeReader:reader startScanningAtLoad:YES showSwitchCameraButton:YES showTorchButton:YES];
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
- (IBAction)tapPinLabelAction:(id)sender {
    PinVC *pinVC = [self.storyboard instantiateViewControllerWithIdentifier:@"pinVC"];
    pinVC.type = TYPE_RESET;
    [self presentViewController:pinVC animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if ([textField isEqual:nameFld]) {
        [addressFld becomeFirstResponder];
    } else if ([textField isEqual:addressFld]) {
        [cityFld becomeFirstResponder];
    } else if ([textField isEqual:cityFld]) {
        [provinceFld becomeFirstResponder];
    } else if ([textField isEqual:provinceFld]) {
        [zipcodeFld becomeFirstResponder];
    } else if ([textField isEqual:zipcodeFld]) {
        [phoneFld becomeFirstResponder];
    } else if ([textField isEqual:phoneFld]) {
        [noteFld becomeFirstResponder];
    }
    
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
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    //check bitcoin
    if ([result containsString:@"bitcoin:"]) {
        NSArray *listItems = [result componentsSeparatedByString:@":"];
        NSString *str1 = listItems[1];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 0;
}

@end
