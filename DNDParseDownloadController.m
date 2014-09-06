//
//  DNDParseDownloadController.m
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import "DNDParseDownloadController.h"

@implementation DNDParseDownloadController

- (void)downloadAllDrinksCompletionBlock:(void (^)(NSArray *drinks, NSError *err))block;
{
    //Check to see if we already downloaded the conference rooms
    PFQuery *query = [PFQuery queryWithClassName:@"DrinkMenu"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            block(objects,error);
        }else{
            NSLog(@"Error %@",error);
        }
    }];
}

@end
