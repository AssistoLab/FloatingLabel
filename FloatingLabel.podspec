Pod::Spec.new do |s|

  s.name = "FloatingLabel"
  s.version = "0.1.0"
  s.summary = "An implementation of a UX pattern \"Float Label Pattern\""

  s.description  = <<-DESC
  					A collection of UI component that are implementing the "Float Label Pattern"
  					like TextField, TextView and more.
                   DESC

  s.homepage = "https://github.com/kevin-hirsch/FloatingLabel"
  s.license = { :type => "MIT", :file => "LICENSE" }

  s.author = { "kevin-hirsch" => "kevin.hirsch.be@gmail.com" }
  s.social_media_url = "http://twitter.com/kevinh6113"

  s.platform = :ios, '8.0'
  s.source = { 
  	:git => "https://github.com/kevin-hirsch/FloatingLabel.git", 
  	:tag => s.version.to_s 
  }

  s.source_files = "FloatingLabel/src", "FloatingLabel/src/**/*.{h,m}", "FloatingLabel/src/helpers", "FloatingLabel/src/helpers/**/*.{h,m}"

  s.dependency "DropDown"
  s.requires_arc = true

end