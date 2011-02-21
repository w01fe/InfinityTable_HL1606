#!/bin/bash

git submodule init
git submodule update
cd lib
wget http://www.arduino.cc/playground/uploads/Code/Time.zip 
unzip -u Time.zip

mkdir -p ~/Documents/Arduino/libraries
ln -s `pwd`/Time ~/Documents/Arduino/libraries/Time
ln -s `pwd`/HL1606 ~/Documents/Arduino/libraries/HL1606
cd ..
ln -s `pwd` ~/Documents/Arduino/InfinityTable