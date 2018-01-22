Pod::Spec.new do |s|

  s.name = "FloatingLabel"
  s.version = "0.2.7"
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

  s.source_files = "FloatingLabel/src", "FloatingLabel/src/**/*.{swift}", "FloatingLabel/src/helpers", "FloatingLabel/src/helpers/**/*.{h,m}", "FloatingLabel/src/basic field", "FloatingLabel/src/basic field/**/*.{swift}", "FloatingLabel/src/input", "FloatingLabel/src/input/**/*.{swift}", "FloatingLabel/src/fields", "FloatingLabel/src/fields/**/*.{swift}", "FloatingLabel/src/tableView:collectionView", "FloatingLabel/src/tableView:collectionView/**/*.{swift}"

  s.resource_bundles = { 'FloatingLabel' => ['FloatingLabel/Resources/**/*.png'] }
  s.dependency "DropDown"
  s.dependency "SZTextView"
  s.requires_arc = true

end