#!/bin/bash

git clone https://github.com/awslabs/aws-lambda-cpp.git
cd aws-lambda-cpp && mkdir -p build && cd build && cmake .. -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=../../lambda-install && make && make install && cd ../..

git clone --recurse-submodules https://github.com/aws/aws-sdk-cpp.git && cd aws-sdk-cpp && mkdir build && cd build && cmake  .. -DBUILD_ONLY="s3;dynamodb" -DBUILD_SHARED_LIBS=OFF -DENABLE_UNITY_BUILD=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(pwd)/../../lambda-install && make -j8 && make install

cd src
