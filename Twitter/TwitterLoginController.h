//
//  TwitterDetailViewController.h
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterLoginController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;

- (IBAction)loginButtonPressed:(UIButton *)sender;
- (IBAction)registerButtonPressed:(UIButton *)sender;

@end
