module tomasulo(
	
	input clock,
	input reset

);

// Sinais Instruction Queue
wire stall;
wire [2:0] ULA_op;
wire [2:0] RX, RY, RZ;
wire [3:0] immediate;

// Sinais ULA Soma/Subtração
wire[15:0] operand1_sumsub, operand2_sumsub;
wire[2:0] Opcode_sumsub;
wire[2:0] Reg_dest_sumsub;
wire operands_ready_sumsub;
wire[1:0] sumsub_position;
wire[15:0] ULA_output;

// Sinais ULA Load/Store
wire[15:0] operand1_ldsd, operand2_ldsd;
wire[2:0] Opcode_ldsd;
wire[2:0] Reg_dest_ldsd;
wire operands_ready_ldsd;
wire[1:0] ldsd_position;
wire[15:0] ULA_ld_sd_output;

// Sinais de saída do Banco de Registradores
wire[9:0] R0_output, R1_output, R2_output;

// Sinal de sáida da Memória RAM
wire [15:0] mem_output;

// CDB
wire[15:0] cdb;

// Acesso à memória
wire[4:0] address;
wire wren;
wire[15:0] data_in_mem;

// Instanciar Memória de Dados
ram mem_ram (address/*Address*/, clock, data_in_mem/*Data In Mem*/, wren/*Wren*/, mem_output);

// Instanciar Banco de Registradores
BankOfRegisters bank_of_registers (clock, reset, cdb, R0_output, R1_output, R2_output);

// Instanciar uma Instruction Queue
InstructionQueue instruction_queue (clock, reset, stall, ULA_op, RX, RY, RZ, immediate);

// Instanciar a Reservation Station
ReservationStation reservation_station (/*Entradas*/    			clock, reset, RX, RY, RZ, ULA_op, immediate, cdb, R0_output, R1_output, R2_output, 
													 /*Saídas ULA*/ 			operand1_sumsub, operand2_sumsub, Opcode_sumsub, Reg_dest_sumsub, operands_ready_sumsub, sumsub_position,
													 /*Saídas ULA_ld_sd*/ 	operand1_ldsd, operand2_ldsd, Opcode_ldsd, Reg_dest_ldsd, operands_ready_ldsd, ldsd_position,
													 /*Endereço Memória*/   address,
													 /*Escrita na memória*/	wren, data_in_mem,
													 /*Sinal de Stall*/     stall);

// Instanciar a ULA Soma/Subtração
ULA ula (clock, operand1_sumsub, operand2_sumsub, Reg_dest_sumsub, Opcode_sumsub, sumsub_position, operands_ready_sumsub, ULA_output);

// Instanciar a ULA de Load e Store
ULA_LD_SD ula_ld_sd (clock, operand1_ldsd, operand2_ldsd, Reg_dest_ldsd, Opcode_ldsd, ldsd_position, operands_ready_ldsd, ULA_ld_sd_output);

// Instanciar o CDB Arbiter
CDBArbiter cdb_arbiter (clock, reset, ULA_output, ULA_ld_sd_output, mem_output, cdb);

endmodule


