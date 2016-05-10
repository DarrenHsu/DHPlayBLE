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
#import "DHManager.h"

@interface ViewController () <UITextViewDelegate> {
    CGRect _orignalRect;
}

@property (nonatomic, weak) IBOutlet UIView *baseView;
@property (nonatomic, weak) IBOutlet UITextView *receiverTextView;
@property (nonatomic, weak) IBOutlet UITextView *sendTextView;

@property (nonatomic, strong) DHManager *manager;

@property (nonatomic, strong) DHCentralManager *centralManager;
@property (nonatomic, strong) DHPeripheralManager *peripheralManager;

@end

@implementation ViewController

#define TRANSFER_SERVICE_UUID           @"E20A39F4-73F5-4BC4-A12F-17D1AD07A961"
#define TRANSFER_CHARACTERISTIC_UUID    @"08590F7E-DB05-467E-8757-72F6FAEB13D4"

- (IBAction) sendMessage:(id)sender {
    [_peripheralManager changeMessage:_sendTextView.text sender:[_manager getSender] time:[_manager getTimeKey]];
    [_peripheralManager start];

    _sendTextView.text = nil;

    _receiverTextView.text = _manager.message;
    _receiverTextView.font = [UIFont boldSystemFontOfSize:14];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    _manager = [DHManager shardInstance];

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
        _receiverTextView.font = [UIFont boldSystemFontOfSize:14];
    }];

    /* 偵測鍵盤是否出現 */
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

- (void) viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    _orignalRect = _receiverTextView.frame;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) keyboardWillShow:(NSNotification *)note {
    NSDictionary *userInfo = [note userInfo];
    CGRect krect = [[userInfo objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];

    CGFloat height = self.view.frame.size.height - krect.origin.y;

    CGRect frame = self.view.frame;
    frame.origin.y = -height;

    CGRect rrect = _orignalRect;

    rrect.origin.y += height;
    rrect.size.height -= height;

    [UIView animateWithDuration:0.28 animations:^{
        _receiverTextView.frame = rrect;
        self.view.frame = frame;
    }];
}

- (void) keyboardDidHide:(NSNotification *)note {
    CGRect frame = self.view.frame;
    frame.origin.y = 0;

    [UIView animateWithDuration:0.28 animations:^{
        _receiverTextView.frame = _orignalRect;
        self.view.frame = frame;
    }];
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