//
//  DNDFirstViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDMainViewController.h"
#import "DNDParseDownloadController.h"

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
    DNDParseDownloadController* app = [[DNDParseDownloadController alloc] init];
    [app calculateBACOfCurrentUser:^(float BAC, NSError *err) {
        if (!err) {
            bac = BAC;
            [self.tableView reloadData];
        }else{
            
        }
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
        if (bac > 0.06) {
            bacCell.driveIndicatorLabel.text = @"DO NOT DRIVE";
            bacCell.driveIndicatorLabel.textColor = [UIColor redColor];
        }else{
            bacCell.driveIndicatorLabel.text = @"You're okay still";
            bacCell.driveIndicatorLabel.textColor = [UIColor whiteColor];
        }
        return bacCell;
    }else if (indexPath.section == 1){
        lastCell.bacLevelLabel.text = [NSString stringWithFormat:@"%.3f",bac];
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
        [self.tabBarController setSelectedIndex:2];
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else{
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}

@end
