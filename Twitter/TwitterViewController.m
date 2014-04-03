//
//  TwitterViewController.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterAppDelegate.h"
#import "AFHTTPSessionManager.h"

@interface TwitterViewController (){
    AFHTTPSessionManager *manager;
}
@end

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

@implementation TwitterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelTweet:)];
    self.navigationItem.leftBarButtonItem = cancel;
    UIBarButtonItem *tweet = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(sendTweet:)];
    self.navigationItem.rightBarButtonItem = tweet;
    self.appDelegate = [[UIApplication sharedApplication] delegate];
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
}

-(void)cancelTweet:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendTweet:(id)sender{
    if (self.appDelegate.loggedIn) {
        NSString *message = self.tweetText.text;
        // Send tweet to server
        NSDictionary *parameters = @{@"username" : self.appDelegate.user, @"session_token" : self.appDelegate.token, @"tweet" : message};
        
        [manager POST:@"add-tweet.cgi"
           parameters:parameters
              success: ^(NSURLSessionDataTask *task, id responseObject) {
                  // Enter success stuff here
                  if ([[responseObject objectForKey:@"tweet"] isEqualToString:message]){
                      // Send message to addTweetDelegate
                      [self.tweetDelegate didAddTweet]; // Not quite sure what is wrong yet.
                  }
              } failure:^(NSURLSessionDataTask *task, NSError *error) {
                  NSLog(@"in failure");
                  NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
                  const int statuscode = response.statusCode;
                  //
                  // Display AlertView with appropriate error message.
                  //
                  if (statuscode == 500) {
                      UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Something stranged happened....."
                                                                    message:@"There was an issue logging in\nPlease try again later"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                      [err show];
                  }
                  if (statuscode == 400) {
                      UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Missing Fields"
                                                                    message:@"All fields must be entered"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                      [err show];
                  }
                  if (statuscode == 401) {
                      UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Unauthorized Acess"
                                                                    message:@"User is not currently logged in\nPlease log in and try again"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                      [err show];
                  }
                  if (statuscode == 404) {
                      UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"User does not exist"
                                                                    message:@"Please register before attempting to add a tweet"
                                                                   delegate:self
                                                          cancelButtonTitle:@"OK"
                                                          otherButtonTitles:nil, nil];
                      [err show];
                  }
              }];
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else{
        [self performSegueWithIdentifier:@"loginToAddTweet" sender:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
