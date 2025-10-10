# Demonstrator System for SUNRISE
[![License](https://img.shields.io/badge/License-Apache_2.0-blue.svg)](https://opensource.org/licenses/Apache-2.0)

This repository provides a minimal _system_ implementation intended for use within the [SUNRISE Infrastructure Demonstrator](https://github.com/boschresearch/sunrise.demonstrator) (_**S**calable **Un**ified **R**ESTful **I**nfrastructure for **S**ystem **E**valuation_).


## Getting Started
This repository uses a minimalistic SystemC simulation platform, designed to be executed inside a container.
As a prerequisite, you need to have [Docker](https://docs.docker.com/get-docker/) installed and running.

### Creating the Docker Image
The included [Dockerfile](Dockerfile) is used to create a Docker image with all dependencies required for the simulation.
The SUNRISE _Runtime Manager_ expects that the Docker image is already built and available on a Docker registry.

To build the image named _sunrise-demo-system:latest_, call from the repository root directory:
```sh
docker build -t sunrise-demo-system .
```

### Manual Run for Testing
To **start the container** interactively from the repository root directory to verify everything works as expected, run:
```sh
# start the container with an interactive shell
docker run --rm -it -v ./simulation:/work --workdir=/work sunrise-demo-system:latest
```
Inside the containers shell you can **build and run the simulation**:
```sh
# build the simulation
cmake -B build && cmake --build build

# run the simulation
build/demo_sim 5000

# expected output
#   > Frequency value from Syscfg: 5000
#   >   {SystemC Header}
#   > Starting sc_main...
#   > Using clock period 200000 ns
#   > Signal tracing is enabled
#   > 0 s: Clock rises
#   > 100 us: Clock falls
#   > 200 us: Clock rises
#   >   ...
#   > sc_main finished.
```

### SysAPI Integration for SUNRISE Runtime Manager
The System API (SysAPI) implementation is defined with the [System Definition JSON file](sysdef.json).
As defined there, the SysAPI _action steps_ are implemented with shell scripts for simulation build and run. They will be called by the Runtime Manager as:
```sh
# the build step
docker run --rm -v .:/sysapi --workdir=/sysapi sunrise-demo-system:latest ./build_sim.sh demo/syscfg.json

# the run step
docker run --rm -v .:/sysapi --workdir=/sysapi sunrise-demo-system:latest ./run_sim.sh demo/syscfg.json
```


## Contributing
A core goal of SUNRISE is to connect parties in the industry to improve efficiency in the domain of simulation.
Therefore, we strongly encourage anyone interested to bring input to the project, preferably through code contributions.

Questions and requests can be raised via **GitHub issues**.
Please see the [contribution guide](CONTRIBUTING.md) for further information on how to get involved.


## License
This work is published under the [Apache License 2.0](LICENSE).


## Acknowledgments
This work was initiated as a research project by [Robert Bosch GmbH](https://www.bosch.com/research/).
