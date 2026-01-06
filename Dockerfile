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

FROM ubuntu:24.04
RUN apt-get update && apt-get -y upgrade
RUN echo "Europe/Berlin" > /etc/timezone && apt-get install -y tzdata && dpkg-reconfigure --frontend noninteractive tzdata
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /work

# Install Zscaler stuff
COPY zscaler-certs.crt /usr/local/share/ca-certificates/zscaler-certs.crt
RUN apt-get install -y ca-certificates && update-ca-certificates
ENV REQUESTS_CA_BUNDLE=/etc/ssl/certs/ca-certificates.crt

# Install packages for c++ build
RUN apt-get install -y build-essential g++ cmake python3 python3-pip

# Set up SystemC with Conan
RUN pip3 install conan --break-system-packages
RUN conan profile detect
RUN conan install --requires systemc/3.0.1 --build missing

# Additional packages
RUN apt-get install -y jq
