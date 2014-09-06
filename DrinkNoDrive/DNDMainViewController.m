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


@interface DNDMainViewController () <UITableViewDelegate,UITableViewDataSource>

@end

@implementation DNDMainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor appBackground];
    self.tableView.backgroundColor = [UIColor appBackground];
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
