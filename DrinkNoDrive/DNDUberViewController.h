//
//  DNDSecondViewController.h
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

#import "DNDParseDownloadController.h"

@interface DNDUberViewController : UIViewController <CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *currentLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *homeLocationLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *waitLabel;

@property (strong, nonatomic)DNDParseDownloadController *downloader;

- (IBAction)openUberApp:(id)sender;

@end
