//
//  DHManager.h
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/10/16.
//  Copyright © 2016 D.H. All rights reserved.
//

#import <UIKit/UIKit.h> 

extern NSString *const DHMessageSenderKey;
extern NSString *const DHMessageTimeKey;
extern NSString *const DHMessageKey;

@interface DHManager : NSObject

@property (nonatomic, strong) NSMutableString *message;

+ (instancetype) shardInstance;

- (NSString *) getTimeKey;
- (NSString *) getSender;

- (NSString *) createMessage:(NSString *) msg time:(NSString *) time sender:(NSString *) sender;
- (NSString *) appendMessageData:(NSData *) data;

@end