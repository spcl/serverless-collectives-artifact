

AWS SDK version 1.9.225

GCC version 9.5

The first flag is needed on Ubuntu with GCC >= 9.3 - assembly bug.

cmake  .. -DUSE_CPU_EXTENSIONS=OFF -DCMAKE_CXX_FLAGS="-Wno-error=deprecated-declarations" -DENABLE_TESTING=OFF -DBUILD_ONLY="s3;dynamodb" -DBUILD_SHARED_LIBS=OFF -DENABLE_UNITY_BUILD=ON -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=$(pwd)/../../install_new

cmake -DCMAKE_CXX_COMPILER=g++-9 -DCMAKE_C_COMPILER=gcc-9 -DCMAKE_PREFIX_PATH="$(pwd)/../../../dependencies/install_new/lib/cmake/AWSSDK;$(pwd)/../../../dependencies/install_new/" ../src
