//
//  DHCentralManager.m
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

@import CoreBluetooth;

#import "DHCentralManager.h"

static DHCentralManager *_manager = nil;

@interface DHCentralManager () <CBCentralManagerDelegate,CBPeripheralDelegate>

@property (nonatomic, strong) NSString              *currentKey;

@property (nonatomic, strong) NSString              *sUUID;
@property (nonatomic, strong) NSString              *cUUID;

@property (nonatomic, strong) CBCentralManager      *centralManager;
@property (strong, nonatomic) CBPeripheral          *discoveredPeripheral;
@property (strong, nonatomic) NSMutableData         *data;

@property (copy) void (^receiverMessage)(NSString *message);

@end

@implementation DHCentralManager

+ (instancetype) shardInstance {
    @synchronized (_manager) {
        if (!_manager) {
            _manager = [DHCentralManager new];
            _manager.message = [NSMutableString new];
        }
    }
    return _manager;
}

- (void) createManagerWithServiceId:(NSString *) sUUID characteristicId:(NSString *) cUUID {
    _sUUID = sUUID;
    _cUUID = cUUID;

    _data = [NSMutableData new];

    if (!_centralManager)
        _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];

}

- (void) start {
    [_centralManager scanForPeripheralsWithServices:@[ [CBUUID UUIDWithString:_sUUID] ]
                                            options:@{ CBCentralManagerScanOptionAllowDuplicatesKey : @YES }];
}

- (void) start:(void(^)(NSString *message)) receiverMessage {
    _receiverMessage = receiverMessage;
    [self start];
}

- (void) stop {
    [self cleanup];
}

- (void)cleanup {
    if (_discoveredPeripheral.state != CBPeripheralStateConnected) {
        return;
    }

    if (_discoveredPeripheral.services != nil) {
        for (CBService *service in _discoveredPeripheral.services) {
            if (service.characteristics != nil) {
                for (CBCharacteristic *characteristic in service.characteristics) {
                    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:_cUUID]]) {
                        if (characteristic.isNotifying) {
                            [_discoveredPeripheral setNotifyValue:NO forCharacteristic:characteristic];
                            return;
                        }
                    }
                }
            }
        }
    }

    [_centralManager cancelPeripheralConnection:_discoveredPeripheral];
}


#pragma mark - CBCentralManagerDelegate Methods
- (void)centralManagerDidUpdateState:(CBCentralManager *)central {
    NSLog(@"<BLE central> %@",NSStringFromSelector(_cmd));

    if (central.state != CBCentralManagerStatePoweredOn)
        return;

    [self start];
}

- (void)centralManager:(CBCentralManager *)central willRestoreState:(NSDictionary<NSString *, id> *)dict {
    NSLog(@"<BLE central> %@",NSStringFromSelector(_cmd));

}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary<NSString *, id> *)advertisementData RSSI:(NSNumber *)RSSI {
    NSLog(@"Discovered %@ at %@", peripheral.name, RSSI);

    if (_discoveredPeripheral != peripheral) {
        _discoveredPeripheral = peripheral;

        [_centralManager connectPeripheral:peripheral options:nil];
    }
}

- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    NSLog(@"<BLE central> %@",NSStringFromSelector(_cmd));
    NSLog(@"Peripheral connected %@",peripheral.name);

    [_centralManager stopScan];

    NSLog(@"Scanning stopped");

    // Clear the data that we may already have
    [self.data setLength:0];

    peripheral.delegate = self;

    [peripheral discoverServices:@[[CBUUID UUIDWithString:_sUUID]]];
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"<BLE central> %@",NSStringFromSelector(_cmd));

    [self cleanup];
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"<BLE central> %@",NSStringFromSelector(_cmd));

    _discoveredPeripheral = nil;

    [self start];
}

#pragma mark - CBPeripheralDelegate Methods
- (void)peripheralDidUpdateName:(CBPeripheral *)peripheral {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray<CBService *> *)invalidatedServices {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheralDidUpdateRSSI:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didReadRSSI:(NSNumber *)RSSI error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

    if (error) {
        NSLog(@"Error discovering services: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }

    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:@[[CBUUID UUIDWithString:_cUUID]] forService:service];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverIncludedServicesForService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        [self cleanup];
        return;
    }

    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:_cUUID]]) {
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }

    NSString *stringFromData = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];
    if ([stringFromData isEqualToString:@"EOM"]) {
        [peripheral setNotifyValue:NO forCharacteristic:characteristic];
        [self.centralManager cancelPeripheralConnection:peripheral];

        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:_data options:kNilOptions error:&error];
        NSString *key = [dictionary allKeys][0];
        if (![key isEqualToString:_currentKey]) {
            _currentKey = key;
            NSString *msg = [dictionary allValues][0];
            [_message appendFormat:_message.length > 0 ? @"\n%@    %@" : @"%@    %@",key,msg];

            if (_receiverMessage)
                _receiverMessage(_message);

            NSLog(@"_message %@",_message);
        }
    }

    [self.data appendData:characteristic.value];

    NSLog(@"Received: %@", stringFromData);
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateNotificationStateForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

    if (error) {
        NSLog(@"Error changing notification state: %@", error.localizedDescription);
    }

    if (![characteristic.UUID isEqual:[CBUUID UUIDWithString:_cUUID]]) {
        return;
    }

    if (characteristic.isNotifying) {
        NSLog(@"Notification began on %@", characteristic);
    } else {
        NSLog(@"Notification stopped on %@.  Disconnecting", characteristic);
        [self.centralManager cancelPeripheralConnection:peripheral];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverDescriptorsForCharacteristic:(CBCharacteristic *)characteristic error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));

}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForDescriptor:(CBDescriptor *)descriptor error:(nullable NSError *)error {
    NSLog(@"<BLE peripheral> %@",NSStringFromSelector(_cmd));
    
}

@end