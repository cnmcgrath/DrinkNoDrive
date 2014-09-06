//
//  DNDAppDelegate.h
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "DNDParseDownloadController.h"


@interface DNDAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) DNDParseDownloadController *data;
@property (strong, nonatomic) NSArray *arrayOfDrinkObjects;
@end
