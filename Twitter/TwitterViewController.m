//
//  TwitterViewController.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "TwitterViewController.h"
#import "TwitterAppDelegate.h"

@interface TwitterViewController ()

@end

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
}

-(void)cancelTweet:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)sendTweet:(id)sender{
    if (self.appDelegate.loggedIn) {
        // Send tweet to server
        // Popup alert if error
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
