//
//  DHPeripheralManager.m
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

@import CoreBluetooth;

#import "DHPeripheralManager.h"

#define NOTIFY_MTU 20

static DHPeripheralManager *_manager = nil;

@interface DHPeripheralManager () <CBPeripheralManagerDelegate>

@property (nonatomic, strong) NSMutableArray            *msgArray;
@property (nonatomic, strong) NSString                  *message;
@property (nonatomic, strong) NSString                  *cUUID;
@property (nonatomic, strong) NSString                  *sUUID;
@property (nonatomic, strong) CBPeripheralManager       *peripheralManager;
@property (nonatomic, strong) CBMutableCharacteristic   *transferCharacteristic;
@property (nonatomic, strong) NSData                    *dataToSend;
@property (nonatomic, readwrite) NSInteger              sendDataIndex;
@property (nonatomic, assign) BOOL                      sendingEOM;

@end

@implementation DHPeripheralManager

+ (instancetype) shardInstance {
    @synchronized (_manager) {
        if (!_manager) {
            _manager = [DHPeripheralManager new];
        }
    }
    return _manager;
}

- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID message:(NSString *) message {
    _sUUID = sUUID;
    _cUUID = cUUID;
    _message = message;
    _sendingEOM = NO;

    if (!_peripheralManager)
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:nil];
}

- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID {
    [self createManagerWithServiceId:sUUID characteristicId:cUUID message:nil];
}

- (void) changeMessage:(NSString *) message; {
    if (!_msgArray)
        _msgArray = [NSMutableArray new];

    NSDate *key = [NSDate new];

    NSDictionary *dict = @{[NSString stringWithFormat:@"%@",key] : message};

    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];

    _message = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

- (void) start {
    [_peripheralManager startAdvertising:@{ CBAdvertisementDataServiceUUIDsKey : @[[CBUUID UUIDWithString:_sUUID]] }];
}

- (void) stop {
    _sendingEOM = NO;
    
    [_peripheralManager stopAdvertising];
}

- (void) sendData {
    if (_sendingEOM) {
        if ([_peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil]) {
            _sendingEOM = NO;
            NSLog(@"Sent: EOM");
        }
        return;
    }

    if (_sendDataIndex >= _dataToSend.length)
        return;

    BOOL didSend = YES;
    while (didSend) {
        NSInteger amountToSend = self.dataToSend.length - self.sendDataIndex;
        if (amountToSend > NOTIFY_MTU)
            amountToSend = NOTIFY_MTU;

        NSData *chunk = [NSData dataWithBytes:_dataToSend.bytes + _sendDataIndex length:amountToSend];

        didSend = [_peripheralManager updateValue:chunk forCharacteristic:_transferCharacteristic onSubscribedCentrals:nil];
        if (!didSend)
            return;

        NSString *stringFromData = [[NSString alloc] initWithData:chunk encoding:NSUTF8StringEncoding];
        NSLog(@"Sent: %@", stringFromData);

        _sendDataIndex += amountToSend;

        if (_sendDataIndex >= _dataToSend.length) {
            _sendingEOM = YES;
            BOOL eomSent = [_peripheralManager updateValue:[@"EOM" dataUsingEncoding:NSUTF8StringEncoding] forCharacteristic:_transferCharacteristic onSubscribedCentrals:nil];
            if (eomSent) {
                _sendingEOM = NO;
                NSLog(@"Sent: EOM");
            }
            return;
        }
    }
}

#pragma mark - CBPeripheralManagerDelegate Methods
- (void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

    if (peripheral.state != CBPeripheralManagerStatePoweredOn) {
        return;
    }

    _transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:[CBUUID UUIDWithString:_cUUID]
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];

    CBMutableService *transferService = [[CBMutableService alloc] initWithType:[CBUUID UUIDWithString:_sUUID]
                                                                       primary:YES];

    transferService.characteristics = @[_transferCharacteristic];

    [_peripheralManager addService:transferService];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManagerDidStartAdvertising:(CBPeripheralManager *)peripheral error:(nullable NSError *)error {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didAddService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didSubscribeToCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

    _dataToSend = [_message dataUsingEncoding:NSUTF8StringEncoding];

    _sendDataIndex = 0;

    [self sendData];
}

- (void)peripheralManager:(CBPeripheralManager *)peripheral central:(CBCentral *)central didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveReadRequest:(CBATTRequest *)request {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManager:(CBPeripheralManager *)peripheral didReceiveWriteRequests:(NSArray<CBATTRequest *> *)requests {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

}

- (void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral {
    NSLog(@"<BLE periphera> %@", NSStringFromSelector(_cmd));

    [self sendData];
}

@end