
Pod::Spec.new do |spec|

  spec.name         = "GGBluetooth"
  spec.version      = "0.0.1"
  spec.summary      = "GGBluetooth<CoreBluetooth>封装的轻量级BLE框架。支持函数式语法糖，让你的代码更简练。\GGBluetooth is a small framework based on <CoreBluetooth>. Support functional syntactic sugar to make your code more concise."

  spec.description  = <<-DESC
                    This is a framework to mutipeer, supported on iOS.
                   DESC

  spec.homepage     = "https://github.com/itmarsung/GGBluetooth"

  spec.license      = { :type => "MIT", :file => "LICENSE" }

  spec.author             = { "marsung" => "itmarsung@163.com" }

  spec.platform     = :ios, "7.0"

  spec.requires_arc    = true

  spec.source       = { :git => "https://github.com/itmarsung/GGBluetooth.git", :tag => spec.version }

  spec.source_files = 'GGBluetooth/framework/*.{h,m}'

end
