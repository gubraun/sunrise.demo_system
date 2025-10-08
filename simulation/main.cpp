// Copyright 2025 Robert Bosch GmbH
//
// Licensed under the Apache License, Version 2.0 (the "License");
// you may not use this file except in compliance with the License.
// You may obtain a copy of the License at
//
//     http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing, software
// distributed under the License is distributed on an "AS IS" BASIS,
// WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
// See the License for the specific language governing permissions and
// limitations under the License.

#include <iostream>
#include <systemc.h>

SC_MODULE(Counter) {
    sc_in<bool> clk;
    sc_out<int> count;
    int count_value;

    SC_CTOR(Counter) {
        count_value = 0;
        SC_METHOD(increment);
        sensitive << clk.pos();
    }

    void increment() {
        count_value++;
        count.write(count_value);
    }
};

SC_MODULE(Demo) {
    sc_signal<bool> clk_signal;
    sc_signal<int> count_signal;
    Counter* counter;
    double clock_period;

    SC_CTOR(Demo, double period) : clock_period(period) {
        counter = new Counter("Counter");
        counter->clk(clk_signal);
        counter->count(count_signal);
        SC_THREAD(generate_clock);
    }

    void generate_clock() {
        while (true) {
            std::cout << sc_time_stamp() << ": Clock rises" << std::endl;
            clk_signal.write(true);
            wait(clock_period / 2, SC_NS);
            std::cout << sc_time_stamp() << ": Clock falls" << std::endl;
            clk_signal.write(false);
            wait(clock_period / 2, SC_NS);
        }
    }
};

int sc_main(int argc, char* argv[]) {
    std::cout << "Starting sc_main..." << std::endl;
    if (argc != 2) {
        std::cerr << "Usage: " << argv[0] << " <clock_frequency_in_Hz>" << std::endl;
        return 1;
    }

    double frequency = std::stod(argv[1]);
    double clock_period = 1.0 / frequency * 1e9; // Convert to nanoseconds
    Demo top("demo_top_level", clock_period);

    std::cout << "Using clock period " << clock_period << " ns" << std::endl;

#ifdef ENABLE_VCD
    sc_trace_file* tf = sc_create_vcd_trace_file("counter_trace");
    std::cout << "Signal tracing is enabled " << std::endl;
    sc_trace(tf, top.clk_signal, "clk");
    sc_trace(tf, top.count_signal, "count");
#endif
    sc_start(1, SC_MS);
#ifdef ENABLE_VCD
    sc_close_vcd_trace_file(tf);
#endif
    std::cout << "sc_main finished." << std::endl;
    return 0;
}
