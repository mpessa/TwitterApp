//
//  TwitterMasterViewController.h
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AddTweetDelegate <NSObject>
@optional
-(void)didCancelAddTweet;
-(void)didAddTweet;
@end

@interface TwitterMasterViewController : UITableViewController <AddTweetDelegate>

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender;
@end
