//
//  LanguageVC.m
//  Merchant
//
//  Created by Alex on 6/10/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "LanguageVC.h"

@interface LanguageVC ()< UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate >{

    IBOutlet UITextField *languageFld;
    
    UIPickerView *m_pickerView;
    NSArray *pickerDataSourceArray;
    UIToolbar *m_toolBar;
}

@end

@implementation LanguageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    pickerDataSourceArray = @[@"English", @"French"];
    
    m_pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    m_pickerView.delegate = self;
    m_pickerView.dataSource = self;
    languageFld.inputView = m_pickerView;
    
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
    languageFld.inputAccessoryView = m_toolBar;
    
    languageFld.text = pickerDataSourceArray[0];
    
}

- (void)btnSelectClick:(id)sender{
    [languageFld resignFirstResponder];
}

- (IBAction)menuBtnAction:(id)sender {
    [self.menuContainerViewController toggleLeftSideMenuCompletion:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    
    if ([textField isEqual:languageFld]) {
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
    languageFld.text = pickerDataSourceArray[row];
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
