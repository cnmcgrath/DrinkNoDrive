//
//  DNDDrinkListTableViewController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/6/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//


#import <Parse/Parse.h>

#import "DNDDrinkListTableViewController.h"
#import "DNDParseDownloadController.h"
#import "DNDAppDelegate.h"

@interface DNDDrinkListTableViewController ()
{
    NSMutableArray *arrayOfDrinksForCat;
}

@end

@implementation DNDDrinkListTableViewController

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Custom initialization
        arrayOfDrinksForCat = [NSMutableArray new];
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self canIHazParseDatas:^{}];
}
- (void)canIHazParseDatas:(void(^)())block
{
    [arrayOfDrinksForCat removeAllObjects];
    //Filter results
    DNDAppDelegate* app = (DNDAppDelegate *)[[UIApplication sharedApplication] delegate];
    for (PFObject *obj in app.arrayOfDrinkObjects) {
        if ([obj[@"Drink_Type"] isEqualToString:_filterString]) {
            [arrayOfDrinksForCat addObject:obj];
        }
    }
    [self.tableView reloadData];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [arrayOfDrinksForCat count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"drinkCell" forIndexPath:indexPath];
    cell.textLabel.text = [[arrayOfDrinksForCat objectAtIndex:indexPath.row] objectForKey:@"Drink_Name"];
    cell.detailTextLabel.text = [[[arrayOfDrinksForCat objectAtIndex:indexPath.row] objectForKey:@"alcohol_content"] stringValue];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

    PFObject *drinkObject = [PFObject objectWithClassName:@"DrinkHistory"];
    drinkObject[@"Drink"] = [arrayOfDrinksForCat objectAtIndex:indexPath.row];
    drinkObject[@"Customer"] = [PFUser currentUser];
    [drinkObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        }else{
            NSLog(@"%@",error);
        }
    }];

}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
