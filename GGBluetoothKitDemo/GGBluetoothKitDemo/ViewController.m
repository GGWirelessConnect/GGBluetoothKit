//
//  ViewController.m
//  GGBluetoothKitDemo
//
//  Created by marsung on 2020/8/10.
//  Copyright © 2020 marsung. All rights reserved.
//

#import "ViewController.h"
#import "GGBluetoothKit.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    GGBluetooth *bleMgr = [GGBluetooth manager];
    GGCentralOptions *centralOptions = [[GGCentralOptions alloc] init];
    centralOptions.bleName = @"bleName";
    centralOptions.configOptions = @{
        @"serviceUUID1":[GGCentralCharacterUUID setWithUUIDString:@"FO11" type:GGUUIDsTypeReadAndNotify]
    };
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().commit();
    
    [bleMgr setUpdateValueForCharacteristicCallback:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
    
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().commitWithDidUpdateValueForCharacteristicCallback(^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        NSLog(@"%@",characteristic);
    });
    
    bleMgr.automator(NO,centralOptions,^(BOOL success,CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        
    });
    
    
}


@end
