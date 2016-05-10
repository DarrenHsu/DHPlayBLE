//
//  DHPeripheralManager.h
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DHPeripheralManager : NSObject

+ (instancetype) shardInstance;

- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID message:(NSString *) message;
- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID;

- (void) changeMessage:(NSString *) message sender:(NSString *) sender time:(NSString *) time;

- (void) start;
- (void) stop;

@end