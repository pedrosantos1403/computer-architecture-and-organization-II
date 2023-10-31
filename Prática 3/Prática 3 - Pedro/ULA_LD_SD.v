// ULA de Instruções do Tipo I
module ULA_LD_SD(

	input clock,
   
	// Operandos
	input [15:0] RY_data,
	input [3:0] imediate,
	
	// Registrador de Destino
	input [2:0] reg_dest,
	
	// Operação
   input [2:0] ULA_op,
	
	// Posição da instrução na RS
	input [1:0] RS_position,
	
	// Sinal que indica se os dois operandos estão prontos para a operação
	input operands_ready,
	
	// cdb[15:15] -> R0_in (Registrador Destino R0)
	// cdb[14:14] -> R1_in (Registrador Destino R1)
	// cdb[13:13] -> R2_in (Registrador Destino R2)
	// cdb[12:11] -> Posição da Instrução na RS
	// cdb[10:10] -> Indica qual ULA escreveu no cdb (1 -> ULA , 0 -> ULA_ld_sd)
	// cdb[9:0]   -> Dado
   output reg [15:0] ULA_output
	
);

reg [9:0] data;
reg ULA;

initial begin

	// Inicializando as saídas da ULA com sendo 16'b1 -> Saída Inválida
	ULA_output = 16'b1111111111111111;
	
end

always @(posedge clock) begin

	// Resetando Variáveis
	data = 16'b0000000000000000;
	ULA_output = 16'b1111111111111111;

	if (operands_ready) begin
		
		// Calculando Endereço de Memória
		data = RY_data + imediate;

		// Montando Sinal de Saída
		if (reg_dest == 3'b000 /*R0*/) begin
			ULA_output = {3'b100/*R0*/,2'b00/*RS[0]*/,1'b0/*ULA_ldsd*/,data};
		end
		else if (reg_dest == 3'b001 /*R1*/) begin
			ULA_output = {3'b010/*R1*/,2'b01/*RS[1]*/,1'b0/*ULA_ldsd*/,data};
		end
		else if (reg_dest == 3'b010 /*R2*/) begin
			ULA_output = {3'b001/*R2*/,2'b10/*RS[2]*/,1'b0/*ULA_ldsd*/,data};
		end
		
	end
	
end
  
endmodule
