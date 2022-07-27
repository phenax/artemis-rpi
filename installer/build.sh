#!/usr/bin/env bash

cd /build;
mkdir -p ./output;

make build-native && \
  cp -rf -L result/* ./output/;

ls -la result;
