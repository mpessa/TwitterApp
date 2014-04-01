//
//  TwitterAppDelegate.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "TwitterAppDelegate.h"
#import "Tweet.h"

#define kTweetsKey @"tweets"

@implementation TwitterAppDelegate

-(NSString*)pathToArchive{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docDir = [paths objectAtIndex:0];
    return [docDir stringByAppendingPathComponent:@"tweets.archive"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    NSString *archivePath = [self pathToArchive];
    if ([[NSFileManager defaultManager] fileExistsAtPath:archivePath]) {
        NSData *data = [[NSData alloc] initWithContentsOfFile:archivePath];
        NSKeyedUnarchiver *decoder = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
        NSArray *a = [decoder decodeObjectForKey:kTweetsKey];
        [decoder finishDecoding];
        self.tweets = [a mutableCopy];
    }
    else{
        // Update later. Need to figure this part out.
        self.tweets = [[NSMutableArray alloc] init];
    }
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    
    NSMutableData *data = [[NSMutableData alloc] init];
    NSKeyedArchiver *coder = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [coder encodeObject:self.tweets forKey:kTweetsKey];
    [coder finishEncoding];
    NSString *archivePath = [self pathToArchive];
    [data writeToFile:archivePath atomically:YES];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(NSDate *)lastTweetDate{
    if (self.tweets.count > 0) {
        Tweet *tweet = self.tweets[0];
        return tweet.date;
    }
    else{
        NSDate *date;
        NSDateComponents *comps = [[NSDateComponents alloc] init];
        [comps setMonth:1];
        [comps setDay:1];
        [comps setYear:2014];
        [comps setHour:1];
        [comps setMinute:0];
        [comps setSecond:0];
        NSCalendar *norm = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
        date = [norm dateFromComponents:comps];
        return date;        
    }
}

@end
