Pod::Spec.new do |s|
  s.name             = 'FMDBUtils'
  s.version          = '1.1.0'
  s.summary          = 'FMDB二次封装'

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/lypcliuli/FMDBUtils'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'lypcliuli' => 'lypcliuli@163.com' }
  s.source           = { :git => 'https://github.com/lypcliuli/FMDBUtils.git', :tag => s.version.to_s }

  s.ios.deployment_target = '8.0'

  s.source_files = 'FMDBUtils/Classes/**/*'
  s.dependency 'FMDB'

end
