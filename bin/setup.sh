#!/bin/bash

printf -v day "%02d" $1

mkdir 2021/$day
cp template.rb 2021/$day/program.rb
sed -i "s/#DAY#/$day/g" 2021/$day/program.rb

touch 2021/$day/input.txt

bundle exec ruby 2021/$day/program.rb

exit 0