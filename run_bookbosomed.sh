#!/bin/bash

cd src
bundle install

RUBYOPT='-W:no-deprecated -W:no-experimental' ruby menu.rb