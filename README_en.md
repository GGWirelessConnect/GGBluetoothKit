# GGBluetooth  【[Chinese](https://github.com/itmarsung/GGBluetoothKit) | [English](https://github.com/itmarsung/GGBluetoothKit/blob/master/README_en.md) 】

#### A lightweight Bluetooth framework based on encapsulation that supports functional syntactic sugar.

## Install
 
 1）CocoaPods support
 	
 	pod 'GGBluetooth', '~> 0.0.1'
 
 2）Carthage support
 coming soon
 
 3)Manual installation You can also download the [framework](https://github.com/itmarsung/GGBluetoothKit/tree/master/GGBluetoothKit) and import it directly into the project.

## How to use？

### 1.Central Mode

#### 1）Init
  
    #import "GGBluetoothKit.h"
    
    GGBluetooth *bleMgr = [GGBluetooth manager];
    
    GGCentralOptions *centralOptions = [[GGCentralOptions alloc] init];
    centralOptions.bleName = @"bleName";
    centralOptions.configOptions = @{
        @"serviceUUID1":[GGCentralCharacterUUID setWithUUIDString:@"FO11" type:GGUUIDsTypeReadAndNotiy]
    };
#### 2）Call function

  a)example 1
  
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().discoverDesciptors().readValueForDescriptors().commit();
    // delegate setting 
    [bleMgr setUpdateValueForCharacteristicCallback:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
  b)example 2
   
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().discoverDesciptors().readValueForDescriptors().commitWithDidUpdateValueForCharacteristicCallback(^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        NSLog(@"%@",characteristic);
    });
    
 c) example 3 (automated operation) automatically connect peripherals and discover services, peripheral characteristics, and read peripheral information.
    
    bleMgr.automator(NO,centralOptions,^(BOOL success,CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        
    });
    
    
### 2.Peripheral Mode

    // init
    GGBluetooth *bleMgr = [GGBluetooth manager];
    // fillter setting 
    GGPeripheralOptions *opts = [[GGPeripheralOptions alloc] init];
    opts.localName = @"localName";
    opts.configOptions = @{
        @"F010" :@[[GGPeripheralCharacteristic setWithUUIDString:@"F011" properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyRead data:nil permissions:CBAttributePermissionsReadable strsForDescriptor:@"descriptor"]],
    };
    // call function
    bleMgr.openPeripheralService(NO,opts)
    .startAdvertising()
    .sendDataWithRespond([@"hello world" dataUsingEncoding:NSUTF8StringEncoding],@"F010",^(CBATTRequest *respond,NSError *error){
        
    });


tips:[Here](https://github.com/itmarsung/GGBluetoothKit/blob/master/Snippets.zip) is Snippet, you can download and import it into your project.



## License

GGBluetooth is released under the MIT license. See [LICENSE]((https://github.com/itmarsung/GGBluetoothKit/blob/master/LICENSE) for details.

## issues and star

If you find bugs, please [issus](https://github.com/itmarsung/GGBluetoothKit/issues), thank you!

Expectation of your Star ⭐⭐⭐【Star】【Star】【Star】
