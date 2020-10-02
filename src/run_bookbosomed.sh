#!/bin/bash

# cd src
gem install bundler
bundle install
clear

RUBYOPT='-W:no-deprecated -W:no-experimental' ruby menu.rb