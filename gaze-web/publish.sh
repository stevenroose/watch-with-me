#!/usr/bin/env bash

pub build
ssh-add
cd build/web
git init
git remote add origin git@github.com:stevenroose/watchwithme.rocks.git
git fetch origin
git add ./*
git commit -a -m"New version"
git checkout gh-pages
git merge master --commit -m"Merged new version" -X theirs
git push origin gh-pages