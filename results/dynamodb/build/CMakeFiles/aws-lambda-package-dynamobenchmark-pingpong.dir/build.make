# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.16

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/bin/cmake

# The command to remove a file.
RM = /usr/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build

# Utility rule file for aws-lambda-package-dynamobenchmark-pingpong.

# Include the progress variables for this target.
include CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/progress.make

CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong: dynamobenchmark-pingpong
	/work/serverless/2022/collectives/dependencies/install/lib/aws-lambda-runtime/cmake/packager /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build/dynamobenchmark-pingpong

aws-lambda-package-dynamobenchmark-pingpong: CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong
aws-lambda-package-dynamobenchmark-pingpong: CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/build.make

.PHONY : aws-lambda-package-dynamobenchmark-pingpong

# Rule to build all files generated by this target.
CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/build: aws-lambda-package-dynamobenchmark-pingpong

.PHONY : CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/build

CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/cmake_clean.cmake
.PHONY : CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/clean

CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/depend:
	cd /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build /work/serverless/2022/collectives/LambdaCommBenchmarks/dynamodb/build/CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/aws-lambda-package-dynamobenchmark-pingpong.dir/depend

