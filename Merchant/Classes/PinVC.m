//
//  PinVC.m
//  Merchant
//
//  Created by Alex on 6/13/17.
//  Copyright © 2017 Alex. All rights reserved.
//

#import "PinVC.h"

@interface PinVC () < UITextFieldDelegate > {

    
    IBOutlet UITextField *inputFld;
    IBOutlet UILabel *label;
    
    int isFullNum;
    NSString *pinStr;
    int pinNum;
}

@end

@implementation PinVC
@synthesize type;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [inputFld becomeFirstResponder];
    [inputFld addTarget:self
               action:@selector(textFieldDidChange:)
     forControlEvents:UIControlEventEditingChanged];
    
    for (int i = 1; i <=6; i++) {
        UIView *view = [self.view viewWithTag:i];
        [Utils RoundViewWithWhite:view];
    }
    
    isFullNum = 0;
    pinNum = 0;
}

- (IBAction)cancelBtnAction:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)textFieldDidChange :(UITextField *)theTextField{
    NSUInteger length = [theTextField.text length];
    NSLog(@"length:%lu", (unsigned long)length);
    NSLog(@"Str:%@", theTextField.text);
    pinNum = length % 6;
    if (pinNum == 0) {
        pinNum = 6;
    }
    
    UIView *view = [self.view viewWithTag:pinNum];
    [view setBackgroundColor:[UIColor whiteColor]];
    
    if (pinNum == 6) {
        if ([type isEqualToString:TYPE_NEW]) {
            if (isFullNum == 0) {
                pinStr = inputFld.text;
                inputFld.text = @"";
                label.text = NSLocalizedString(@"pin.entry.re_enter_passcode", nil);
                [self clearPinViews];
                isFullNum += 1;
            } else {
                if ([theTextField.text isEqualToString:pinStr]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PIN object:pinStr userInfo:nil];
                    }];
                } else {
                    isFullNum = 0;
                    inputFld.text = @"";
                    label.text = NSLocalizedString(@"pin.info.pin", nil);
                    [self clearPinViews];
                }
            }
        } else if ([type isEqualToString:TYPE_RESET]) {
            if (isFullNum == 0) {
                NSString *myPin = [Utils getObjectFromUserDefaultsForKey:KEY_PIN];
                if ([inputFld.text isEqualToString:myPin]) {
                    isFullNum += 1;
                    label.text = NSLocalizedString(@"pin.entry.enter_new_passcode", nil);
                } else {
                    label.text = NSLocalizedString(@"pin.entry.re_enter_passcode", nil);
                }
                inputFld.text = @"";
                [self clearPinViews];
                
            } else if (isFullNum == 1) {
                pinStr = inputFld.text;
                inputFld.text = @"";
                label.text = NSLocalizedString(@"pin.entry.re_enter_passcode", nil);
                [self clearPinViews];
                isFullNum += 1;
            } else {
                if ([theTextField.text isEqualToString:pinStr]) {
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PIN object:pinStr userInfo:nil];
                    }];
                } else {
                    isFullNum = 1;
                    inputFld.text = @"";
                    label.text = NSLocalizedString(@"pin.entry.enter_new_passcode", nil);
                    [self clearPinViews];
                }
            }
        } else if ([type isEqualToString:TYPE_COMFIRM]) {
            pinStr = theTextField.text;
            [self dismissViewControllerAnimated:YES completion:^{
                [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_PIN object:pinStr userInfo:nil];
            }];
        }
    }
}

-(void)clearPinViews {
    for (int i = 1; i <=6; i++) {
        UIView *view = [self.view viewWithTag:i];
        [view setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITextField Delegate Methods

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    return YES;
}

@end
