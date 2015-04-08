#
# Be sure to run `pod lib lint PXQLinkedIn.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PXQLinkedIn"
  s.version          = "0.2"
  s.summary          = "PXQLinkedIn is a tiny iOS library for LinkedIn integration based on the LIALinkedIn library."
  s.description      = <<-DESC
                       The PXQLinkedIn library provides for a more extensive customation of the LinkedIn authorization views.
                       It also decouples the UI from the business logic associated with LinkedIn authorization.
                       DESC
  s.homepage         = "https://github.com/saorsa/saorsa.PXQLinkedIn"
  s.license          = 'MIT'
  s.author           = { "Atanas Dragolov" => "atanas.dragolov@saorsa.bg" }
  s.source           = { :git => "https://github.com/saorsa/saorsa.PXQLinkedIn.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/adragolov'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'PXQLinkedIn' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'AFNetworking', '~> 2.3'
end
