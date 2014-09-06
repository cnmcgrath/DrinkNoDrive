//
//  DNDSignUpViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDSignUpViewController.h"
#import "UIColor+DNDColor.h"
#import "Parse/Parse.h"

@interface DNDSignUpViewController () <UITextFieldDelegate, UIScrollViewDelegate>
{
    PFUser *user;
}
@property (weak, nonatomic) UITextField *activeTextField;


@end

@implementation DNDSignUpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    NSLayoutConstraint *leftConstraint =[NSLayoutConstraint
                                         constraintWithItem:self.contentView
                                         attribute:NSLayoutAttributeLeading
                                         relatedBy:0
                                         toItem:self.view
                                         attribute:NSLayoutAttributeLeft
                                         multiplier:1.0
                                         constant:0];
    [self.view addConstraint:leftConstraint];
    
    NSLayoutConstraint *rightConstraint =[NSLayoutConstraint
                                          constraintWithItem:self.contentView
                                          attribute:NSLayoutAttributeTrailing
                                          relatedBy:0
                                          toItem:self.view
                                          attribute:NSLayoutAttributeRight
                                          multiplier:1.0
                                          constant:0];
    [self.view addConstraint:rightConstraint];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    user = [PFUser user];
    
    //Dirty way to get the textfields to respond.. Ehhh it works
    for(id x in [self.contentView subviews]){
        if([x isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField*)x;
            if ([textField.text isEqualToString:@""]) {
                textField.delegate = self;
            }
        }
    }
    self.scrollView.delegate = self;
    self.scrollView.scrollEnabled = YES;
}
- (void)keyboardWasShown:(NSNotification *)notification
{
    NSDictionary *info = [notification userInfo];
    CGSize kbSize = [[info objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    UIEdgeInsets contentInsets = UIEdgeInsetsMake(0.0, 0.0, kbSize.height, 0);
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;

}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    self.activeTextField = textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    self.activeTextField = nil;
}

- (void) keyboardWillHide:(NSNotification *)notification {
    
    UIEdgeInsets contentInsets = UIEdgeInsetsZero;
    self.scrollView.contentInset = contentInsets;
    self.scrollView.scrollIndicatorInsets = contentInsets;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    return YES;
}

- (BOOL)isFormValidated
{
    //Check to see that all fields are full
    for(id x in [self.contentView subviews]){
        if([x isKindOfClass:[UITextField class]]){
            UITextField *textField = (UITextField*)x;
            if ([textField.text isEqualToString:@""]) {
                textField.backgroundColor = [UIColor redBackground];
                return NO;
            }else{
                textField.backgroundColor = [UIColor clearColor];
            }
        }
    }
    
    //Check to see if passwords match
    if ([_passwordField.text isEqualToString:_rePasswordField.text] && ![_passwordField.text isEqualToString:@""]) {
        //Awesome no fat fingering
    }else{
        _passwordField.text = @"";
        _rePasswordField.text = @"";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Oops"
                                                        message:@"Passwords don't match"
                                                        delegate:self
                                              cancelButtonTitle:@"Okay :(" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    }
    
    return YES;
}



- (IBAction)doneButtonTappedField:(id)sender {
    if ([self isFormValidated] == YES) {
        //Login
        NSLog(@"Signing Up");
        user.username = _emailAddressField.text;
        user.password = _passwordField.text;
        user.email = _emailAddressField.text;
        
        user[@"Height_feet"] = [NSNumber numberWithInt:_heightField.text.intValue];
        user[@"Weight_Pounds"] = [NSNumber numberWithInt:_weightField.text.intValue];
        user[@"HomeAddress"] = _homeAddressField.text;
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                // Hooray! Let them use the app now.
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                NSString *errorString = [error userInfo][@"error"];
                NSLog(@"%@",errorString);
                // Show the errorString somewhere and let the user try again.
            }
        }];
    }
}
@end
