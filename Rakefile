# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project'

Motion::Project::App.setup do |app|
  app.name = 'DJ Mon'
  app.version = '1.0'
  app.deployment_target = '5.1'
  app.frameworks += [ 'CoreData' ]
  app.identifier = 'cc.akshay.djmon'
  app.codesign_certificate = "iPhone Distribution: Akshay Rawat"
  app.provisioning_profile = "/Users/akshayrawat/Library/MobileDevice/Provisioning\ Profiles/E7D49722-7C4D-4C08-8A0C-BD0C0251136E.mobileprovision"
  app.interface_orientations = [:portrait]
  app.prerendered_icon = true
  app.icons = %w{Icon-57.png Icon-72.png Icon-114.png Icon-512.png Icon-1024.png}
  app.info_plist['CFBundleURLTypes'] = [
    { 'CFBundleURLName' => 'cc.akshay.dj-mon',
    'CFBundleURLSchemes' => ['dj-mon'] }
  ]
end
