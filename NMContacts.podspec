Pod::Spec.new do |s|
  s.name             = 'NMContacts'
  s.version          = '0.0.2'
  s.summary          = 'Easily load iOS Contacts'
  s.description      = <<-DESC
Easier API to access Contacts on iOS
                       DESC

  s.homepage         = 'https://github.com/NicolasMahe/NMContacts'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Nicolas Mahé' => 'nicolas@mahe.me' }
  s.source           = { :git => 'https://github.com/NicolasMahe/NMContacts.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'NMContacts/**/*.swift'

  s.frameworks = 'UIKit', 'Contacts'
  s.dependency 'PromiseKit', '~> 4.1'
end
