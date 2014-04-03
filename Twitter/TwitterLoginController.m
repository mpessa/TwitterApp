//
//  TwitterDetailViewController.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "TwitterLoginController.h"
#import "TwitterAppDelegate.h"
#import "AFHTTPSessionManager.h"

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

@interface TwitterLoginController (){
    AFHTTPSessionManager *manager;
    TwitterAppDelegate *appDelegate;
}
- (void)configureView;
@end

@implementation TwitterLoginController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.detailDescriptionLabel.text = [self.detailItem description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelLogin:)];
    self.navigationItem.leftBarButtonItem = cancel;
    
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    appDelegate = [[UIApplication sharedApplication] delegate];
    if (appDelegate.loggedIn) {
        [self.loginButton setTitle:@"Logout" forState:UIControlStateNormal];
    }
    else{
        [self.loginButton setTitle:@"Login" forState:UIControlStateNormal];
    }
    
    [self configureView];
}

-(void)cancelLogin:(id)sender{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)loginButtonPressed:(UIButton *)sender {
    NSLog(@"logging in");
    NSString *username = self.nameField.text;
    NSString *password = self.passwordField.text;
    NSString *action;
    if (appDelegate.loggedIn) {
        action = @"logout";
    }
    else{
        action = @"login";
    }
    NSDictionary *parameters = @{@"username" : username, @"password" : password, @"action" : action};
    
    [manager POST:@"login.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              if ([[responseObject objectForKey:@"session_token"] isEqualToString:@"0"]){
                  [self.nameField setText:@""];
                  [self.passwordField setText:@""];
                  UIAlertView *logout = [[UIAlertView alloc] initWithTitle:@"Logout"
                                                                    message:@"You have successfully logged out"
                                                                  delegate:self
                                                         cancelButtonTitle:@"OK"
                                                         otherButtonTitles:nil, nil];
                  [logout show];
              }
              else{
                  appDelegate.loggedIn = YES;
                  appDelegate.user = username;
                  appDelegate.token = [responseObject objectForKey:@"session_token"];
                  [self dismissViewControllerAnimated:YES completion:nil];
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
                                                                message:@"Username and password must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 401) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"Unauthorized Acess"
                                                                message:@"The password that you entered probably doesn't match"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 404) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"User does not exist"
                                                                message:@"Please register before attempting to log in"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

- (IBAction)registerButtonPressed:(UIButton *)sender {
    NSLog(@"attempting to register");
    NSString *username = self.nameField.text;
    NSString *password = self.passwordField.text;
    NSDictionary *parameters = @{@"username" : username, @"password" : password};
    
    [manager POST:@"register.cgi"
       parameters:parameters
          success: ^(NSURLSessionDataTask *task, id responseObject) {
              // Enter success stuff here
              if ([responseObject objectForKey:@"session_token"] != nil){
                  UIAlertView *reg = [[UIAlertView alloc] initWithTitle:@"Success!"
                                                                message:@"You have successfully registered\nPlease log in to continure"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [reg show];
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
                                                                message:@"Username and password must be entered"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
              if (statuscode == 409) {
                  UIAlertView *err = [[UIAlertView alloc] initWithTitle:@"User already exists"
                                                                message:@"The username already exists\nPlease try a different username"
                                                               delegate:self
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil, nil];
                  [err show];
              }
          }];
}

#define kOFFSET_FOR_KEYBOARD 50.0

-(void)keyboardWillShow {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)keyboardWillHide {
    if (self.view.frame.origin.y >= 0)
    {
        [self setViewMovedUp:YES];
    }
    else if (self.view.frame.origin.y < 0)
    {
        [self setViewMovedUp:NO];
    }
}

-(void)setViewMovedUp:(BOOL)movedUp
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3];
    
    CGRect rect = self.view.frame;
    if (movedUp)
    {
        rect.origin.y -= kOFFSET_FOR_KEYBOARD;
        rect.size.height += kOFFSET_FOR_KEYBOARD;
    }
    else
    {
        rect.origin.y += kOFFSET_FOR_KEYBOARD;
        rect.size.height -= kOFFSET_FOR_KEYBOARD;
    }
    self.view.frame = rect;
    
    [UIView commitAnimations];
}


- (void)viewWillAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillShowNotification
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self
                                                    name:UIKeyboardWillHideNotification
                                                  object:nil];
}

@end
