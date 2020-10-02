#!/bin/bash

cd src
bundle install
clear

RUBYOPT='-W:no-deprecated -W:no-experimental' ruby menu.rb