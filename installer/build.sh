#!/usr/bin/env bash

mkdir -p ./output;

make build-native && \
  cp -rf -L result/* ./output/;

ls -la result;
