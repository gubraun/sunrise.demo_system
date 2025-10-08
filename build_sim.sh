#!/bin/bash
#
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

if [ "$#" -ne 1 ]; then
    echo "ERROR: You need to pass the path to a SysCfg file to this script"
    exit 1
fi

syscfg_file="$1"

if [ ! -f "$syscfg_file" ]; then
    echo "ERROR: File $syscfg_file does not exist"
    exit 1
fi

tracing=$(jq '.build_parameters.tracing' "$syscfg_file")
if [ -z "$tracing" ]; then
    echo "Tracing value not found in the SysCfg"
    exit 1
else
    echo "Tracing switch from Syscfg: $tracing"
fi

cd simulation
rm -rf build
if [ "$tracing" == "true" ]; then
    cmake -B build -DENABLE_VCD=ON
else
    cmake -B build -DENABLE_VCD=OFF
fi
cmake --build build
