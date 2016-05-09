//
//  DHCentralManager.h
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHCentralManager : NSObject

@property (nonatomic, strong) NSMutableString *message;

+ (instancetype) shardInstance;

- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID;

- (void) start:(void(^)(NSString *message)) receiverMessage;
- (void) start;
- (void) stop;

@end
