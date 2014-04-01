//
//  TwitterMasterViewController.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/27/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "TwitterMasterViewController.h"

#import "TwitterLoginController.h"
#import "TwitterViewController.h"
#import "Tweet.h"
#import "TwitterAppDelegate.h"
#import "AFHTTPSessionManager.h"

#define BaseURLString @"https://bend.encs.vancouver.wsu.edu/~wcochran/cgi-bin/"

#define kTweetIDKey @"tweet_id"
#define kUserNameKey @"username"
#define kIsDeletedKey @"isdeleted"
#define kTweetKey @"tweet"
#define kDateKey @"date"
#define kTweetAttributedStringKey @"tweetAttributedString"

@interface TwitterMasterViewController () {
    NSMutableArray *_objects;
    TwitterAppDelegate *appDelegate;
    AFHTTPSessionManager *manager;
}
@end

@implementation TwitterMasterViewController

- (void)awakeFromNib
{
    [super awakeFromNib];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.leftBarButtonItem = self.editButtonItem;

    UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(insertNewObject:)];
    self.navigationItem.rightBarButtonItem = addButton;
    
    NSURL *baseURL = [NSURL URLWithString:BaseURLString];
    manager = [[AFHTTPSessionManager alloc] initWithBaseURL:baseURL];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    appDelegate = [[UIApplication sharedApplication] delegate];
    //[self refreshTweets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)insertNewObject:(id)sender
{
//    if (!_objects) {
//        _objects = [[NSMutableArray alloc] init];
//    }
//    [_objects insertObject:[NSDate date] atIndex:0];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
//    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [appDelegate.tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TwitterCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier
                                                            forIndexPath:indexPath];
    //TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = appDelegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    cell.textLabel.numberOfLines = 0; // multi-line label
    cell.textLabel.attributedText = tweetAttributedString;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    //TwitterAppDelegate *appDelegate = [[UIApplication sharedApplication] delegate];
    Tweet *tweet = appDelegate.tweets[indexPath.row];
    NSAttributedString *tweetAttributedString =
    [self tweetAttributedStringFromTweet:tweet];
    CGRect tweetRect =
    [tweetAttributedString
     boundingRectWithSize:CGSizeMake(self.tableView.bounds.size.width,1000.0)
     options:NSStringDrawingUsesLineFragmentOrigin
     context:nil];
    return ceilf(tweetRect.size.height) + 1 + 20; // add marginal space
}

-(NSAttributedString*)tweetAttributedStringFromTweet:(Tweet*)tweet {
    if (tweet.tweetAttributedString == nil) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.dateStyle = NSDateFormatterShortStyle;
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        NSString *dateString = [dateFormatter stringFromDate:tweet.date];
        NSString *title = [NSString stringWithFormat:@"%@ - %@\n", tweet.username, dateString];
        NSDictionary *titleAttributes =@{NSFontAttributeName : [UIFont systemFontOfSize:14],
                                         NSForegroundColorAttributeName: [UIColor blueColor]};
        NSMutableAttributedString *tweetWithAttributes = [[NSMutableAttributedString alloc] initWithString:title
                                               attributes:titleAttributes];
        NSMutableParagraphStyle *textStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        textStyle.lineBreakMode = NSLineBreakByWordWrapping;
        textStyle.alignment = NSTextAlignmentLeft;
        NSDictionary *bodyAttributes = @{NSFontAttributeName : [UIFont systemFontOfSize:17],
                                         NSForegroundColorAttributeName: [UIColor blackColor],
                                         NSParagraphStyleAttributeName : textStyle};
        NSAttributedString *bodyWithAttributes = [[NSAttributedString alloc] initWithString:tweet.tweet
                                                                                 attributes:bodyAttributes];
        [tweetWithAttributes appendAttributedString:bodyWithAttributes];
        tweet.tweetAttributedString = tweetWithAttributes;
    }
    return tweet.tweetAttributedString;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return NO;
}

//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        NSDictionary *item = [[NSDictionary alloc] initWithDictionary:[_objects objectAtIndex:indexPath.row]];
//        
//        [_objects removeObjectAtIndex:indexPath.row];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view.
//    }
//}

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(void)refreshTweets{
    
    NSLog(@"refreshing");
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = @"yyyy-MM-dd HH:mm:ss";
    dateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"PST"];
    NSDate *lastTweetDate = [appDelegate lastTweetDate];
    NSString *dateStr = [dateFormatter stringFromDate:lastTweetDate];
    NSDictionary *parameters = @{@"date" : dateStr};

    [manager GET:@"get-tweets.cgi"
      parameters:parameters
         success: ^(NSURLSessionDataTask *task, id responseObject) {
             NSMutableArray *arrayOfDicts = [responseObject objectForKey:@"tweets"];
             //
             // Add new (sorted) tweets to head of appDelegate.tweets array.
             // If implementing delete, some older tweets may be purged.
             // Invoke [self.tableView reloadData] if any changes.
             //
             // I'm assuming that they come in sorted order(newest at front). I'll fix this if not.
             for (int i = arrayOfDicts.count-1; i >= 0; i--) {
                 Tweet *tweet = [[Tweet alloc] init];
                 tweet.tweet_id = [arrayOfDicts[i] objectForKey:kTweetIDKey];
                 tweet.username = [arrayOfDicts[i] objectForKey:kUserNameKey];
                 tweet.isDeleted = [arrayOfDicts[i] objectForKey:kIsDeletedKey];
                 tweet.tweet = [arrayOfDicts[i] objectForKey:kTweetKey];
                 tweet.date = [arrayOfDicts[i] objectForKey:kDateKey];
                 tweet.tweetAttributedString = [arrayOfDicts[i] objectForKey:kTweetAttributedStringKey];
                 [appDelegate.tweets insertObject:tweet atIndex:0];
             }
             if (arrayOfDicts.count > 0) {
                 NSLog(@"need to reloadData");
                 [self.tableView reloadData];
             }
             [self.refreshControl endRefreshing];
         } failure:^(NSURLSessionDataTask *task, NSError *error) {
             NSLog(@"in failure");
             NSHTTPURLResponse *response = (NSHTTPURLResponse *)task.response;
             const int statuscode = response.statusCode;
             //
             // Display AlertView with appropriate error message.
             //
             if (statuscode == 503) {
                 
             }
             [self.refreshControl endRefreshing];
         }];
}

- (IBAction)refreshControlValueChanged:(UIRefreshControl *)sender{
    [self refreshTweets];
}

-(void)didAddTweet{
    [self.refreshControl beginRefreshing];
    [self refreshTweets];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showDetail"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        NSDate *object = _objects[indexPath.row];
        [[segue destinationViewController] setDetailItem:object];
    }
}

@end
