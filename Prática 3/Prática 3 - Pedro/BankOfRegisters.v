module BankOfRegisters(
	input clock,
	input reset,
		
	// cdb[15:15] -> R0_in (Registrador Destino R0)
	// cdb[14:14] -> R1_in (Registrador Destino R1)
	// cdb[13:13] -> R2_in (Registrador Destino R2)
	// cdb[12:11] -> Posição da Instrução na RS
	// cdb[10:10] -> Indica qual ULA escreveu no cdb
	// cdb[9:0]   -> Dado
	input[15:0] cdb,
	
	output [9:0] R0_output,
	output [9:0] R1_output,
	output [9:0] R2_output
);

// TODO
// Montar lógica de reset

// cdb[15:15] -> R0_in
// cdb[14:14] -> R1_in
// cdb[13:13] -> R2_in

// Instanciar os Registradores
//Register R0 (clock, cdb[15:15], cdb[9:0], R0_output);
//Register R1 (clock, cdb[14:14], cdb[9:0], R1_output);
//Register R2 (clock, cdb[13:13], cdb[9:0], R2_output);

// Instanciar os Registradores para teste
Reg0 R0 (clock, cdb[15:15], cdb[9:0], R0_output); // 0
Reg1 R1 (clock, cdb[14:14], cdb[9:0], R1_output); // 10
Reg2 R2 (clock, cdb[13:13], cdb[9:0], R2_output); // 5

endmodule

// Registrador 0
module Reg0(
   input clock,
	input wren,
   input [9:0] data,
   output reg[9:0] R_output
);  

initial begin
	R_output = 10'b0000000000;
end
	
always @(posedge clock) begin
	if(wren) begin
		R_output = data;
	end
end

endmodule

// Registrador 1
module Reg1(
   input clock,
	input wren,
   input [9:0] data,
   output reg[9:0] R_output
);  

initial begin
	R_output = 10'b0000001010;
end
	
always @(posedge clock) begin
	if(wren) begin
		R_output = data;
	end
end

endmodule

// Registrador 2
module Reg2(
   input clock,
	input wren,
   input [9:0] data,
   output reg[9:0] R_output
);  

initial begin
	R_output = 10'b0000000101;
end
	
always @(posedge clock) begin
	if(wren) begin
		R_output = data;
	end
end

endmodule
