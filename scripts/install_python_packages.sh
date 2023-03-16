#!/usr/bin/bash
echo =======================
echo Install python packges
echo =======================
packages=("$@")
for package in "${packages[@]}"; do
  echo "package: \"$package\""
  /usr/bin/python3 -m pip install "$package"
done
