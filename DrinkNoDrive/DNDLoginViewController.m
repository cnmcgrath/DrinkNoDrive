//
//  DNDLoginViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDLoginViewController.h"
#import "UIColor+DNDColor.h"
#import "Parse/Parse.h"


@interface DNDLoginViewController ()
{
    NSUserDefaults *defaults;
}

@end

@implementation DNDLoginViewController

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
    defaults = [NSUserDefaults standardUserDefaults];
    _emailTextField.text = [defaults objectForKey:@"email"];
    self.view.backgroundColor = [UIColor appBackground];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    [segue destinationViewController];
    // Pass the selected object to the new view controller.
}


- (IBAction)performLoginWithParse:(id)sender {
    [PFUser logInWithUsernameInBackground:_emailTextField.text password:_passwordTextField.text block:^(PFUser *user, NSError *error) {
        if (user) {
            // Do stuff after successful login.
            [defaults setObject:_emailTextField.text forKey:@"email"];
            [defaults synchronize];
            [self performSegueWithIdentifier:@"loginSegue" sender:self];
        } else {
            // The login failed. Check error to see why.
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed"
                                                            message:[error userInfo][@"error"]
                                                           delegate:self
                                                  cancelButtonTitle:@"Awww..."
                                                  otherButtonTitles:nil, nil];
            [alert show];
        }
    }];
}

- (IBAction)performSighUp:(id)sender {
    [self performSegueWithIdentifier:@"signUpSegue" sender:self];
}
@end
