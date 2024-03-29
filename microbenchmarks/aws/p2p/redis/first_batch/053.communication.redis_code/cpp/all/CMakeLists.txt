
cmake_minimum_required(VERSION 3.9)
set(CMAKE_CXX_STANDARD 11)
project(benchmark LANGUAGES CXX)
add_executable(
    ${PROJECT_NAME} "handler.cpp" "key-value.cpp"
    "storage.cpp" "redis.cpp" "tcp.cpp" "utils.cpp" "main.cpp"
)
target_include_directories(${PROJECT_NAME} PRIVATE ".")

target_compile_features(${PROJECT_NAME} PRIVATE "cxx_std_11")
target_compile_options(${PROJECT_NAME} PRIVATE "-Wall" "-Wextra")

find_package(aws-lambda-runtime)
target_link_libraries(${PROJECT_NAME} PRIVATE AWS::aws-lambda-runtime)

find_package(Boost REQUIRED)
target_include_directories(${PROJECT_NAME} PRIVATE ${Boost_INCLUDE_DIRS})
target_link_libraries(${PROJECT_NAME} PRIVATE ${Boost_LIBRARIES})

find_package(AWSSDK COMPONENTS s3 dynamodb core)
target_link_libraries(${PROJECT_NAME} PUBLIC ${AWSSDK_LINK_LIBRARIES})

find_package(PkgConfig REQUIRED)
set(ENV{PKG_CONFIG_PATH} "/opt/lib/pkgconfig")
pkg_check_modules(HIREDIS REQUIRED IMPORTED_TARGET hiredis)

target_include_directories(${PROJECT_NAME} PUBLIC PkgConfig::HIREDIS)
target_link_libraries(${PROJECT_NAME} PUBLIC PkgConfig::HIREDIS)

find_package(tcpunch)
target_link_libraries(${PROJECT_NAME} PUBLIC tcpunch::tcpunch)

# this line creates a target that packages your binary and zips it up
aws_lambda_package_target(${PROJECT_NAME})
