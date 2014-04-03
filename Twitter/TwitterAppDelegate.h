//
//  TwitterAppDelegate.h
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) NSMutableArray *tweets;
@property BOOL loggedIn;

-(NSDate *)lastTweetDate;

@end
