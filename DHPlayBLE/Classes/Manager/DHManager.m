//
//  DHManager.m
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/10/16.
//  Copyright © 2016 D.H. All rights reserved.
//

#import "DHManager.h"
#import "NSDate+Today.h"

NSString *const DHMessageSenderKey = @"sender";
NSString *const DHMessageTimeKey = @"time";
NSString *const DHMessageKey = @"msg";

static DHManager *_manager = nil;

@interface DHManager ()

@property (nonatomic, strong) NSMutableDictionary *mappingDict;

@end

@implementation DHManager

+ (instancetype) shardInstance {
    @synchronized (_manager) {
        if (!_manager) {
            _manager = [DHManager new];
            _manager.mappingDict = [NSMutableDictionary new];
            _manager.message = [NSMutableString new];
        }
    }
    return _manager;
}

- (NSString *) getTimeKey {
    NSDate *date = [NSDate new];
    NSString *key = [date getStringWithFormat:@"HH:mm:ss"];
    return key;
}

- (NSString *) getSender {
    return [[UIDevice currentDevice] name];
}

- (NSString *) createMessage:(NSString *)msg time:(NSString *)time sender:(NSString *)sender {
    if (!sender || !time) return nil;

    NSDictionary *dict = @{DHMessageSenderKey : sender,
                           DHMessageTimeKey : time,
                           DHMessageKey : !msg ? @"" : msg};

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    [self appendMessageDict:dict];

    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (NSString *) appendMessageData:(NSData *)data {
    NSError *error;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];

    return [self appendMessageDict:dict];
}

- (NSString *) appendMessageDict:(NSDictionary *) dict {
    if (!dict) return nil;

    NSString *key = [NSString stringWithFormat:@"%@_%@",dict[DHMessageSenderKey],dict[DHMessageTimeKey]];
    if (![_mappingDict objectForKey:key]) {
        NSString *time = dict[DHMessageTimeKey];
        NSString *sender = dict[DHMessageSenderKey];
        NSString *msg = dict[DHMessageKey];
        [_message appendFormat:_message.length > 0 ? @"\n%@    %@ : %@" : @"%@    %@ : %@",time,sender,msg];

        [_mappingDict setObject:dict forKey:key];

        return _message;
    }
    return nil;
}

@end