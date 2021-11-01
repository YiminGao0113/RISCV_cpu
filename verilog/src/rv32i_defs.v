// define a unique 32-bit code for each function
// with valid func7, func3, opcode and last two digits "11"
// and all other digits goes to 0

// define a masking macro setting valid bits to "1"s for each function

// U type instructions
`define RV32I_U_MASK             32'h7f
`define RV32I_LUI                32'b000000000110111
`define RV32I_AUIPC              32'b000000000010111

// J type instructions
`define RV32I_J_MASK             32'h7f
`define RV32I_JAL                32'b1101111

`define RV32I_JALR               32'b1101111 // This is I type instruction

// B type instructions
`define RV32I_B_MASK             32'h707f
`define RV32I_BEQ                32'b1100011
`define RV32I_BNE                32'b001000001100011
`define RV32I_BLT                32'b100000001100011
`define RV32I_BGE                32'b101000001100011
`define RV32I_BLTU               32'b110000001100011
`define RV32I_BGEU               32'b111000001100011

// I type instructions -- Load
`define RV32I_I_MASK             32'h707f
`define RV32I_LB                 32'b11
`define RV32I_LH                 32'b001000000000011
`define RV32I_LW                 32'b010000000000011
`define RV32I_LBU                32'b100000000000011
`define RV32I_LHU                32'b101000000000011

// S type instructions
`define RV32I_S_MASK             32'h707f
`define RV32I_SB                 32'b000000000100011
`define RV32I_SH                 32'b001000000100011
`define RV32I_SW                 32'b010000000100011

// I type instructions -- ALUI
`define RV32I_ADDI               32'b000000000010011
`define RV32I_SLTI               32'b010000000010011
`define RV32I_SLTIU              32'b011000000010011
`define RV32I_XORI               32'b100000000010011
`define RV32I_ORI                32'b110000000010011
`define RV32I_ANDI               32'b111000000010011

// R type instructions
`define RV32I_R_MASK             32'hFE00707F

`define RV32I_SLLI               32'b001000000010011
`define RV32I_SRLI               32'b101000000010011
`define RV32I_SRAI               32'b10000000000000000101000000010011

`define RV32I_ADDr               32'b000000000110011
`define RV32I_SUBr               32'b10000000000000000000000000110011
`define RV32I_SLLr               32'b001000000110011
`define RV32I_SLTr               32'b010000000110011
`define RV32I_SLTUr              32'b011000000110011
`define RV32I_XORr               32'b100000000110011
`define RV32I_SRLr               32'b00000000000000000101000000110011
`define RV32I_SRAr               32'b10000000000000000101000000110011
`define RV32I_ORr                32'b110000000110011
`define RV32I_ANDr               32'b111000000110011



// enumerated type functions

`define LUI           6'd0
`define AUIPC         6'd1
`define JAL           6'd2
`define JALR          6'd3
`define BEQ           6'd4
`define BNE           6'd5
`define BLT           6'd6
`define BGE           6'd7
`define BLTU          6'd8
`define BGEU          6'd9
`define LB            6'd10
`define LH            6'd11
`define LW            6'd12
`define LBU           6'd13
`define LHU           6'd14
`define SB            6'd15
`define SH            6'd16
`define SW            6'd17
`define ADDI          6'd18
`define SLTI          6'd19
`define SLTIU         6'd20
`define XORI          6'd21
`define ORI           6'd22
`define ANDI          6'd23
`define SLLI          6'd24
`define SRLI          6'd25
`define SRAI          6'd26
`define ADDr          6'd27
`define SUBr          6'd28
`define SLLr          6'd29
`define SLTr          6'd30
`define SLTUr         6'd31
`define XORr          6'd32
`define SRLr          6'd33
`define SRAr          6'd34
`define ORr           6'd35
`define ANDr          6'd36
`define NOP           6'd37
`define BAD           6'd38
