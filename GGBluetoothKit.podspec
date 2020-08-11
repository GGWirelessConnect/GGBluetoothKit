
Pod::Spec.new do |spec|

  spec.name         = "GGBluetoothKit"
  spec.version      = "0.0.3"
  spec.summary      = "基于<CoreBluetooth>封装的轻量级BLE框架。支持函数式语法糖，让你的代码更简练。GGBluetoothKit is lightweight and easy to use, support for CoreBluetooth"

  spec.description  = <<-DESC
                   GGBluetoothKit is lightweight and easy to use, support for CoreBluetooth.
                   DESC

  spec.homepage     = "https://github.com/itmarsung/GGBluetoothKit"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "marsung" => "itmarsung@163.com" }

  spec.platform     = :ios, "7.0"

  spec.requires_arc    = true

  spec.source       = { :git => "https://github.com/itmarsung/GGBluetoothKit.git", :tag => spec.version }

  spec.source_files = 'GGBluetoothKit/**.{h,m}'

end
