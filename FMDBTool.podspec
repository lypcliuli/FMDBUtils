
Pod::Spec.new do |s|
  s.name             = 'FMDBTool'
  s.version          = '1.0.1'
  s.summary          = 'FMDB二次封装'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lypcliuli/FMDBTool'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lypcliuli' => 'lypcliuli@163.com' }
  s.source           = { :git => 'https://github.com/lypcliuli/FMDBTool.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FMDBTool/Classes/**/*'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.dependency 'FMDB'
end
