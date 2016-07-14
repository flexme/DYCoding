Pod::Spec.new do |s|
  s.name         = "DYCoding"
  s.version      = "1.0"
  s.summary      = "An objective-c library to dynamically encode/decode objects."
  s.description  = 'Have you got tried of implementing methods initWithCoder: and encodeWithCoder: by yourself? ' \
                   'With DYCoding, you don\'t need to implement those anymore, the encoding/decoding works dynamically in the runtime.' \
                   'Although the encoding/decoding happens dynamically, it\'s performance should be as fast as the precompiled code ' \
                   'due to the optimizations we have done.'
  s.homepage     = "https://github.com/flexme/DYCoding"
  s.license      = "MIT"
  s.author             = { "Kun Chen" => "cs.kunchen@gmail.com" }
  s.source       = { :git => "https://github.com/flexme/DYCoding.git", :tag => s.version.to_s }

  s.ios.deployment_target = "5.0"
  s.osx.deployment_target = "10.7"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"

  s.watchos.frameworks = 'UIKit', 'CoreGraphics'

  s.source_files  = "DYCoding/**/*.{h,m,mm}"

  s.requires_arc = true
end
