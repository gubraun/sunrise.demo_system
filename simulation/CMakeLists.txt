# Copyright 2025 Robert Bosch GmbH
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

cmake_minimum_required(VERSION 3.10)

project("Sunrise Demo System" LANGUAGES CXX)
find_package(SystemCLanguage REQUIRED)
option(ENABLE_VCD "Enable VCD tracing" OFF)
add_executable(demo_sim main.cpp)
target_link_libraries(demo_sim SystemC::systemc)
if(ENABLE_VCD)
    target_compile_definitions(demo_sim PRIVATE ENABLE_VCD)
endif()
