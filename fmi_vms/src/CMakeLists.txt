cmake_minimum_required(VERSION 3.5)
set(CMAKE_CXX_STANDARD 14)
project(fmibenchmark LANGUAGES CXX)

add_subdirectory(${PROJECT_SOURCE_DIR}/../../FMI/ fmi)

add_executable(fmi_benchmark fmi_benchmark.cpp)
target_include_directories(fmi_benchmark PRIVATE ${FMI_INCLUDE_DIRS})
target_link_libraries(fmi_benchmark PUBLIC FMI)
