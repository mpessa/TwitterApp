//
//  Tweet.h
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/31/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Tweet : NSObject <NSCopying, NSCoding>

@property (weak, nonatomic) NSNumber *tweet_id;
@property (copy, nonatomic) NSString *username;
@property BOOL isDeleted;
@property (copy, nonatomic) NSString *tweet;
@property (weak, nonatomic) NSDate *date;
@property (copy, nonatomic) NSAttributedString *tweetAttributedString;

-(id)init;
-(id)initWithCoder:(NSCoder *)aDecoder;
-(void)encodeWithCoder:(NSCoder *)aCoder;
-(id)copyWithZone:(NSZone *)zone;

@end
