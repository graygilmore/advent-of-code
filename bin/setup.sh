#!/bin/bash

printf -v day "%02d" $1

mkdir 2022/$day
cp template.rb 2022/$day/program.rb
sed -i "s/#DAY#/$day/g" 2022/$day/program.rb

touch 2022/$day/input.txt

bundle exec ruby 2022/$day/program.rb

exit 0
