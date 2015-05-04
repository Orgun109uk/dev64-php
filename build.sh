#!/bin/bash

if [ ! -f packer/packer.exe ]; then
  echo "Unable to find the packer tools in ./packer."
  echo "Download them from https://packer.io/downloads.html and extract the relevant package in to a 'packer' subdirectory, so that we can reach the packer.exe from ./packer/packer.exe"
else
  vagrant destroy --force
  vagrant box remove dev64-php --force

  echo "Building ubuntu box..."
  packer/packer build package.json
fi
