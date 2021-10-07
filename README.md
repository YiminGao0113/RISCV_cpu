# RISC-V-Processor
😛 A RISC-V processor for use in FPGA designs.


This is a project of a 32-bit risc-v processor. The processor can run machine language (including jump, branch instructions) using a text file MemoryDivide.txt reprensenting data stored in memory system.

## Introduction
The project is written in both VHDL and verilog. For the vhdl version, the RV32I_Processor_Structure.vhd is the highest hierachy synthesizable design entity that includes almost all the other components in the repository. It is a processor ported to a memory system. The ProcessorWithMemSys_Structure.vhd is the design entity for testing the processor performance with sequential machine code (MemoryDivide.txt) read by the memory system(MemorySystem_Behavior.vhd). The sequential machine code is a division operation that includes several conditional loops. Since the Memory system entity unit is not synthesizable, the ProcessorWithMemSys is not synthesizable as well. There is also a python assembler to convert assembly to machine code as txt files.

## Clone the project to your local system


Open the Terminal window and type in the following command:


git clone https://github.com/YiminGao0113/riscv_cpu

## Meta

Yimin Gao – yg9bq@virginia.edu

Distributed under the MIT license. See ``LICENSE`` for more information.

[https://github.com/YiminGao0113/RISC-V-Processor/blob/master/LICENSE.txt](https://github.com/YiminGao0113/RISC-V-Processor/blob/master/LICENSE.txt)

## Contributing

1. Fork it (<https://github.com/YiminGao0113/RISC-V-Processor/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request

<!-- Markdown link & img dfn's -->
[npm-image]: https://img.shields.io/npm/v/datadog-metrics.svg?style=flat-square
[npm-url]: https://npmjs.org/package/datadog-metrics
[npm-downloads]: https://img.shields.io/npm/dm/datadog-metrics.svg?style=flat-square
[travis-image]: https://img.shields.io/travis/dbader/node-datadog-metrics/master.svg?style=flat-square
[travis-url]: https://travis-ci.org/dbader/node-datadog-metrics
[wiki]: https://github.com/yourname/yourproject/wiki
