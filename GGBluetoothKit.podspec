
Pod::Spec.new do |spec|

  spec.name         = "GGBluetoothKit"
  spec.version      = "0.0.2"
  spec.summary      = "基于<CoreBluetooth>封装的轻量级BLE框架。支持函数式语法糖，让你的代码更简练。\GGBluetoothKit is a small framework based on <CoreBluetooth>. Support functional syntactic sugar to make your code more concise."

  spec.description  = <<-DESC
                    This is a framework to BLE.
                   DESC

  spec.homepage     = "https://github.com/itmarsung/GGBluetoothKit"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "marsung" => "itmarsung@163.com" }

  spec.platform     = :ios, "7.0"

  spec.requires_arc    = true

  spec.source       = { :git => "https://github.com/itmarsung/GGBluetoothKit.git", :tag => spec.version }

  spec.source_files = 'GGBluetoothKit/GGBluetoothKit.h,GGBluetoothKit/Manager/*.{h,m},GGBluetoothKit/Header/*.{h,m},GGBluetoothKit/Options/*.{h,m},GGBluetoothKit/Utils/*.{h,m},'

end
