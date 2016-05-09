//
//  ViewController.m
//  DHPlayBLE
//
//  Created by Dareen Hsu on 5/6/16.
//  Copyright © 2016 D.H. All rights reserved.
//

#import "ViewController.h"
#import "DHCentralManager.h"
#import "DHPeripheralManager.h"

@interface ViewController ()

@property (nonatomic, weak) IBOutlet UITextView *receiverTextView;
@property (nonatomic, weak) IBOutlet UITextView *sendTextView;

@property (nonatomic, strong) DHCentralManager *centralManager;
@property (nonatomic, strong) DHPeripheralManager *peripheralManager;

@end

@implementation ViewController

#define TRANSFER_SERVICE_UUID           @"E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
#define TRANSFER_CHARACTERISTIC_UUID    @"08590F7E-DB05-467E-8757-72F6FAEB13D4"

- (IBAction) sendMessage:(id)sender {
    [_sendTextView resignFirstResponder];

    [_peripheralManager changeMessage:_sendTextView.text];
    [_peripheralManager start];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognizer:)];
    [self.view addGestureRecognizer:tapRecognizer];

    _peripheralManager = [DHPeripheralManager shardInstance];
    [_peripheralManager createManagerWithServiceId:TRANSFER_SERVICE_UUID
                                  characteristicId:TRANSFER_CHARACTERISTIC_UUID];

    _centralManager = [DHCentralManager shardInstance];
    [_centralManager createManagerWithServiceId:TRANSFER_SERVICE_UUID
                               characteristicId:TRANSFER_CHARACTERISTIC_UUID];

    [_centralManager start:^(NSString *message) {
        _receiverTextView.text = message;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) tapRecognizer:(UITapGestureRecognizer *) recognizer {
    [_sendTextView resignFirstResponder];
    [_receiverTextView resignFirstResponder];
}

#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView {
    [_peripheralManager stop];
}

@end