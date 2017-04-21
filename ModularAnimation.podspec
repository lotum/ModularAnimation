Pod::Spec.new do |s|

  s.name         = "ModularAnimation"
  s.version      = "0.7"
  s.summary      = "A small framework that seperates the playback and the animation description from the (UIView-)animation itself"

  s.description  = <<-DESC
    UIView.animate() has some drawbacks:
    - It starts the animation immediately when called.
    - Chaining several animations looks messy.
    - The overall structure of the animation (or its description) cannot be reused.
    ModularAnimation provides a few simple classes to compose UIView animations that can be played back if you call play().
    And it provides an enum to describe complex animations that can be reused on different views.
    All in all your animation code will be a lot easier to understand.
                   DESC

  s.homepage     = "https://github.com/LOTUM/ModularAnimation"
  s.license      = "Apache License, Version 2.0"

  s.author             = { "Martin" => "reichard@lotum.de" }

  s.source       = { :git => "https://github.com/LOTUM/ModularAnimation.git", :tag => "#{s.version}" }

  s.source_files  = "ModularAnimation/**/*.{h,swift}"

  s.ios.deployment_target = "9.0"

end
