//
//  DNDMenuViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "DNDMenuViewController.h"
#import "DNDDrinkListTableViewController.h"
#import "UIColor+DNDColor.h"


@interface DNDMenuViewController ()
{
    NSString *drinkType;
}

@end

@implementation DNDMenuViewController

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
    drinkType = [[NSString alloc] init];

    self.view.backgroundColor = [UIColor appBackground];
    
    for (id x in [self.view subviews]) {
        if([x isKindOfClass:[UIButton class]]){
            UIButton *button = (UIButton*)x;
            button.layer.cornerRadius = 15;
            button.clipsToBounds = YES;
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)beerButtonTapped:(id)sender {
    drinkType = @"Beer";
    [self performSegueWithIdentifier:@"drank" sender:self];
}

- (IBAction)cocktailButtonTapped:(id)sender {
    drinkType = @"Mix";
    [self performSegueWithIdentifier:@"drank" sender:self];
}

- (IBAction)wineButtonTapped:(id)sender {
    drinkType = @"Wine";
    [self performSegueWithIdentifier:@"drank" sender:self];
}

- (IBAction)liquorButtonTapped:(id)sender {
    drinkType = @"Liquor";
    [self performSegueWithIdentifier:@"drank" sender:self];
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    DNDDrinkListTableViewController *dl = (DNDDrinkListTableViewController*)[segue destinationViewController];
    dl.filterString = drinkType;
}
@end
