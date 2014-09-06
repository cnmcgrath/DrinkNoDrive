//
//  DNDDrinkListTableViewController.h
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/6/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DNDDrinkListTableViewController : UIViewController

@property (strong, nonatomic)NSString *filterString;

@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end
