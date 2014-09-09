//
//  DNDParseDownloadController.h
//  DrinkNoDrive
//
//  Created by Chris McGrath on 9/5/14.
//  Copyright (c) 2014 Chris McGrath. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface DNDParseDownloadController : NSObject

- (void)downloadAllDrinksCompletionBlock:(void (^)(NSArray *drinks, NSError *err))block;
- (void)calculateBACOfCurrentUser:(void (^)(float BAC, NSError *err))block;

-(void)getUberInformationWith:(NSString *)home :(NSString*)Longititude :(NSString*)Latitude :(void(^)(NSString *uber_time, NSString*price, NSError *err))block;




@end
