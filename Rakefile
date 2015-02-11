# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/osx'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.

  app.name                        = 'blottrx'
  app.identifier                  = 'com.yourcompany.blottrx'

  # app.name                        = 'blottrx'
  # app.identifier                  = 'com.yourcompany.blottrx'

  app.info_plist[ 'LSUIElement' ] = true

  app.frameworks += [ 'Carbon' ]

  app.vendor_project 'vendor/DDHotKey', :static, :cflags => '-fobjc-arc'


  app.icon                           = 'Icon.icns'
  app.info_plist['CFBundleIconFile'] = 'Icon.icns'
end

task :"build:simulator" => :"schema:build"
