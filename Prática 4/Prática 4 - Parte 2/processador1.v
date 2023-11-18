module processador1(
	
	input clock,
	input reset,
	
	// Instrução
	input[1:0] proc,
	input[1:0] opcode,
	input[3:0] tag,
	input[7:0] data,
	
	// Dado da memória
	input[7:0] data_mem,
	// Bus
	input[15:0] bus,
	
	// Saídas
	// Busca de tag na memória
	// Bus
	
	// Registrador para salvar que a execução da instrução foi finalizada pelo processador
	output reg done;

	
	
	
);

// Registradores para salvar instrução anterior
reg[15:0] inst_aux;

// Registrador para salvar que a execução da instrução foi finalizada pelo processador
reg done;

// Inicializar Variáveis
initial begin

	// Inicializar Cache L1 de P1
	// Inicializar demais variáveis
	done = 1'b0;
	inst_aux = 16'b1111111111111111;
	
end

always @(posedge clock) begin

// Checar se a instrução atual é uma instrução nova
if ({proc,opcode,tag,data} != inst_aux) begin
	done = 1'b0;
end

// Checar qual processador executa a instrução e checar se a instrução já foi executada
if (proc == 2'b01 /*P1*/ && done == 1'b0) begin
	// Emissor
	// Checar qual instrução está sendo executada antes de olhar o estado
	// Checar em qual estado da execução o processador está
	// Executar instrução para este processador
end

else if (proc != 2'b01 /*P1*/ && done == 1'b0) begin
	// Ouvinte
	// Executar instrução para este processador
end

// Instrução já foi executada por esse processador
else begin
	// Fazer nada
end

// Salvar instrução executada
inst_aux = {proc,opcode,tag,data};

end

endmodule
