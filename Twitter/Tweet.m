//
//  Tweet.m
//  Twitter
//
//  Created by Matthew Steven Pessa on 3/31/14.
//  Copyright (c) 2014 Amnesiacs. All rights reserved.
//

#import "Tweet.h"

@implementation Tweet

-(id)init{
    if (self = [super init]) {
        self.tweet_id = 0;
        self.username = @"";
        self.isDeleted = NO;
        self.tweet = @"";
        self.date = [NSDate date];
        self.tweetAttributedString = nil;
    }
    return self;
}

#define kTweetIDKey @"tweet_id"
#define kUserNameKey @"username"
#define kIsDeletedKey @"isdeleted"
#define kTweetKey @"tweet"
#define kDateKey @"date"
#define kTweetAttributedStringKey @"tweetAttributedString"

-(id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super init]) {
        self.tweet_id = [aDecoder decodeObjectForKey:kTweetIDKey];
        self.username = [aDecoder decodeObjectForKey:kUserNameKey];
        self.isDeleted = [aDecoder decodeBoolForKey:kIsDeletedKey];
        self.tweet = [aDecoder decodeObjectForKey:kTweetKey];
        self.date = [aDecoder decodeObjectForKey:kDateKey];
        self.tweetAttributedString = [aDecoder decodeObjectForKey:kTweetAttributedStringKey];
    }
    return self;
}

-(void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:self.tweet_id forKey:kTweetIDKey];
    [aCoder encodeObject:self.username forKey:kUserNameKey];
    [aCoder encodeBool:self.isDeleted forKey:kIsDeletedKey];
    [aCoder encodeObject:self.tweet forKey:kTweetKey];
    [aCoder encodeObject:self.date forKey:kDateKey];
    [aCoder encodeObject:self.tweetAttributedString forKey:kTweetAttributedStringKey];
}

-(id)copyWithZone:(NSZone *)zone{
    Tweet *clone = [[[self class] alloc] init];
    clone.tweet_id = self.tweet_id;
    clone.username = self.username;
    clone.isDeleted = self.isDeleted;
    clone.tweet = self.tweet;
    clone.date = self.date;
    clone.tweetAttributedString = self.tweetAttributedString;
    
    return clone;
}

@end
