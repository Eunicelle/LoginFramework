Pod::Spec.new do |s|
  s.name             = "LoginFramework"
  s.version          = "0.1.0"
  s.summary          = "Just Testing."
  s.description      = <<-DESC
                       Testing Private Podspec.
 
                       * Markdown format.
                       * Don't worry about the indent, we strip it!

                       DESC

  s.homepage         = "https://github.com/Eunicelle/LoginFramework"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "王海晨" => "wanghc0000@gmail.com" }
  s.source           = { :git => "https://github.com/Eunicelle/LoginFramework.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'LoginFramework' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'Ruler'
end
