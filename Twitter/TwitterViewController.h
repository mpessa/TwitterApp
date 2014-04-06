//
//  TwitterViewController.h
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TwitterAppDelegate.h"

@protocol AddTweetDelegate <NSObject>
@optional
-(void)didCancelAddTweet;
-(void)didAddTweet;
@end

@interface TwitterViewController : UIViewController <UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UITextView *tweetText;
@property (strong, nonatomic) TwitterAppDelegate *appDelegate;
@property (strong, nonatomic) IBOutlet UILabel *textLength;
@property (weak) id <AddTweetDelegate> tweetDelegate;

@end
