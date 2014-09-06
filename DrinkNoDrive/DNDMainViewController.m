//
//  DNDFirstViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDMainViewController.h"

//Table View Cells
#import "DNDbacCellTableViewCell.h"
#import "DNDLastDrinkTableViewCell.h"
#import "DNDGoHomeTableViewCell.h"

#import "UIColor+DNDColor.h"

#import <Parse/Parse.h>


@interface DNDMainViewController () <UITableViewDelegate,UITableViewDataSource>
{
    float bac;
}

@end

@implementation DNDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.tableView.backgroundColor = [UIColor appBackground];
    

}

- (void)viewWillAppear:(BOOL)animated
{
    PFQuery *query = [PFQuery queryWithClassName:@"DrinkHistory"];
    [query whereKey:@"Customer" equalTo:[PFUser currentUser]];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"Number of drinks??? %d",[objects count]);
        [[PFUser query] getFirstObjectInBackgroundWithBlock:^(PFObject *object, NSError *error) {
            //start calulating BAC
            if ([objects count] != 0) {
                float weight = [object[@"Weight_Pounds"] floatValue];
                float gender = [object[@"gender"] floatValue];
                float newBAC = (((0.6*[objects count])*5.14)/((weight)*(gender)))-(.015 * (1));
                bac = newBAC;
                [self.tableView reloadData];
            }else{
                bac = 0.0;
                [self.tableView reloadData];
            }
            
        }];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section depending on the conference rooms if we have them
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    DNDbacCellTableViewCell *bacCell = [tableView dequeueReusableCellWithIdentifier:@"bacCell"];
    DNDLastDrinkTableViewCell *lastCell = [tableView dequeueReusableCellWithIdentifier:@"lastCell"];
    DNDGoHomeTableViewCell *homeCell = [tableView dequeueReusableCellWithIdentifier:@"homeCell"];
    

    
    

    if (indexPath.section == 0) {
        bacCell.bacTextLabel.text = [NSString stringWithFormat:@"%.3f",bac];
        return bacCell;
    }else if (indexPath.section == 1){
        return lastCell;
    }else if (indexPath.section == 2){
        return homeCell;
    }else{
        return cell;
    }

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 2) {
        // Launch uber
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
