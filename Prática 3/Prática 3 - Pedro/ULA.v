// ULA de Instruções do Tipo R
module ULA(

	input clock,

	// Operandos
   input [15:0] RY_data,
	input [15:0] RZ_data,
	
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

// TODO
// Adicionar contador para atrasar exec da ula

initial begin

	// Inicializando as saídas da ULA com sendo 16'b1 -> Saída Inválida
	ULA_output = 16'b1111111111111111;
	
end

always @(posedge clock) begin

	// Resetando Variáveis
	data = 16'b0000000000000000;
	
	// ULA_output = 16'b1111111111111111;
	// Resetar a saída da ULA a cada ciclo faz com que o Arbiter sempre recebeba a saída errada, pois o Arbiter só recebe a saída da ULA 1 ciclo depois que ela é setada aqui
	
	if (operands_ready) begin
		case(ULA_op)
		
			// ADD
			3'b000: begin
			
				// Calculando Dado
				data = RY_data + RZ_data;
				
				// Montando Sinal de Saída
				if (reg_dest == 3'b000 /*R0*/) begin
					ULA_output = {3'b100/*R0*/,2'b00/*RS[0]*/,1'b1/*ULA*/,data};
				end
				else if (reg_dest == 3'b001 /*R1*/) begin
					ULA_output = {3'b010/*R1*/,2'b01/*RS[1]*/,1'b1/*ULA*/,data};
				end
				else if (reg_dest == 3'b010 /*R2*/) begin
					ULA_output = {3'b001/*R2*/,2'b10/*RS[2]*/,1'b1/*ULA*/,data};
				end
				
			end
			
			// SUB
			3'b001: begin
			
				// Calculando Dado
				data = RY_data - RZ_data;
				
				// Montando Sinal de Saída
				if (reg_dest == 3'b000 /*R0*/) begin
					ULA_output = {3'b100/*R0*/,2'b00/*RS[0]*/,1'b1/*ULA*/,data};
				end
				else if (reg_dest == 3'b001 /*R1*/) begin
					ULA_output = {3'b010/*R1*/,2'b01/*RS[1]*/,1'b1/*ULA*/,data};
				end
				else if (reg_dest == 3'b010 /*R2*/) begin
					ULA_output = {3'b001/*R2*/,2'b10/*RS[2]*/,1'b1/*ULA*/,data};
				end
				
			end
			
		endcase
	end
end
  
endmodule
