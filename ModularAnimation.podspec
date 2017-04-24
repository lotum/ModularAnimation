Pod::Spec.new do |s|

  s.name         = "ModularAnimation"
  s.version      = "0.7"
  s.summary      = "A small framework that seperates the playback and the animation description from the (UIView-)animation itself"

  s.description  = <<-DESC
    A small framework that seperates the playback and the animation description from the (UIView-)animation itself.
    ModularAnimation gets rid of the drawbacks of UIView.animate():
    - Your animation code will be easy to understand
    - You will be able to reuse your animation description on different views
                   DESC

  s.homepage     = "https://github.com/LOTUM/ModularAnimation"
  s.license      = "Apache License, Version 2.0"

  s.author             = { "Martin" => "reichard@lotum.de" }

  s.source       = { :git => "https://github.com/LOTUM/ModularAnimation.git", :tag => "#{s.version}" }

  s.source_files  = "ModularAnimation/**/*.{h,swift}"

  s.ios.deployment_target = "9.0"

end
