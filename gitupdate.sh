#!/bin/bash

# sudo apt-get install cloc

time=$(date "+%Y-%m-%d %H:%M:%S")


git config --global user.name "senliontec"
git config --global user.email "senliontec@163.com"

git add .

git commit -m "${time}"

git branch -M main

git push -u origin main


