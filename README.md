# GGBluetoothKit  【[Chinese](https://github.com/itmarsung/GGBluetoothKit) | [English](https://github.com/itmarsung/GGBluetoothKit/blob/master/README_en.md) 】

#### 基于<CoreBluetooth>封装的轻量级蓝牙框架，支持函数式语法糖。 

## 一、安装
 
 1）CocoaPods支持
 	
 	pod 'GGBluetoothKit', '~> 0.0.1'
 
 2）Carthage支持
 coming soon
 
 
 当然你也可以下载[framework](https://github.com/itmarsung/GGBluetoothKit/tree/master/GGBluetoothKit)文件直接导入的项目中。


## 二、怎样使用？

### 1.中心模式

#### 1）初始化
  
    #import "GGBluetoothKit"
    
    GGBluetooth *bleMgr = [GGBluetooth manager];
    
    GGCentralOptions *centralOptions = [[GGCentralOptions alloc] init];
    centralOptions.bleName = @"bleName";
    centralOptions.configOptions = @{
        @"serviceUUID1":[GGCentralCharacterUUID setWithUUIDString:@"FO11" type:GGUUIDsTypeReadAndNotiy]
    };
#### 2）调用

  a)方式1
  
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().discoverDesciptors().readValueForDescriptors().commit();
    // 设置代理
    [bleMgr setUpdateValueForCharacteristicCallback:^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error) {
        
    }];
    
  b)方式2（自带回调）
   
    bleMgr.setup(NO,centralOptions).scan().discoverServices().discoverCharacteristics().readValue().notifyValue().discoverDesciptors().readValueForDescriptors().commitWithDidUpdateValueForCharacteristicCallback(^(CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){
        NSLog(@"%@",characteristic);
    });
    
 c) 方式3（自动化操作）自动连接外设并发现服务，外设特征，读取外设信息。
    
    bleMgr.automator(NO,centralOptions,^(BOOL success,CBPeripheral *peripheral, CBCharacteristic *characteristic, NSError *error){

    });
    
    
### 2.外设模式

    GGBluetooth *bleMgr = [GGBluetooth manager];
    GGPeripheralOptions *opts = [[GGPeripheralOptions alloc] init];
    opts.localName = @"localName";
    opts.configOptions = @{
        @"F010" :@[[GGPeripheralCharacteristic setWithUUIDString:@"F011" properties:CBCharacteristicPropertyWrite|CBCharacteristicPropertyRead data:nil permissions:CBAttributePermissionsReadable strsForDescriptor:@"descriptor"]],
    };
    
    bleMgr.openPeripheralService(NO,opts)
    .startAdvertising()
    .sendDataWithRespond([@"hello world" dataUsingEncoding:NSUTF8StringEncoding],@"F010",^(CBATTRequest *respond,NSError *error){
        
    });



tips:由于ObjC的函数式语法糖实际上采用block调用方式实现，实质上并不是方法调用。书写时Xcode不会有提示。这里我采用了Snippets方式，[这里](https://github.com/itmarsung/GGBluetoothKit/blob/master/Snippets.zip)是下载链接,导入到你的Xcode资源路径/users/[你自己的用户]/Library/Developer/Xcode/UserData/CodeSnippets就可以享用了。


## License

GGMutipeer 支持[MIT](https://github.com/itmarsung/GGBluetoothKit/blob/master/LICENSE)开源协议.

## issues and star

在使用过程中，若有问题，欢迎[issus](https://github.com/itmarsung/GGBluetoothKit/issues)

当然也期待你给我个小 ⭐⭐⭐【Star】【Star】【Star】



