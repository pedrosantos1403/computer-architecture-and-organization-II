module CDBArbiter(

	input clock,
	input reset,
	
	// Dados das ULA's
	input[15:0] ULA_output,
	input[15:0] ULA_ld_sd_output,
	
	// Saídas
	// cdb[15:15] -> R0_in (Registrador Destino R0)
	// cdb[14:14] -> R1_in (Registrador Destino R1)
	// cdb[13:13] -> R2_in (Registrador Destino R2)
	// cdb[12:11] -> Posição da Instrução na RS
	// cdb[10:10] -> Indica qual ULA escreveu no cdb (1 -> ULA , 0 -> ULA_ld_sd)
	// cdb[9:0]   -> Dado
	output reg[15:0] cdb
	
	
);

// Fila de Prioridade do CDB Arbiter
reg[15:0] PriorityQueue[4:0];

// Sinal que registra quando a instrução de maior prioridade é escrita no CDB
reg Done;

// Sinal para controlar Loop
reg break_loop;

// Sinais que salvam a ocorrência e uma entrada na Fila de Prioridade
reg input1_already_in;
reg input2_already_in;

// O arbiter também avalia se o que está no CDB é um dado que será salvo no registrador ou um endereço de load e store
// Adicionar Lógica de calculo de endereco e bloqueamento do cdb

// O cdb Arbiter pode atuar como uma fila de prioridade, sempre que uma instrução sai do cdb o cdb fica com dados inválidos, e ai
// ele pode receber um novo dado, isso garante que enquanto o load está executando o cdb não recebe mais nada

// Saída da ULA igual à 16'b1 significa uma saída inválida

// Fila de prioridade de instruções -> Salvar todas as instruções que estão sendo executadas na fila de prioridade, assim que um dado produzido por uma
// instrução for adquirido, esse dado será adicionado no cdb arbiter junto com a instrução. A cada clock será checado qual instrução dessa fila já está pronta
// para executar, a primeira instrução pronta manda os dados para o cdb e guarda nos registradores. Sendo assim, no caso de um Load, quando o dado for retornado
// da memória ele será mandado direto para o cdb arbiter onde a instrução de Load está instanciada, logo, quando o cdb arbiter receber o dado da memória ele
// manda esse dado direto para o banco de registradores.

initial begin
	
	// Inicializando o cdb com um valor inválido
	cdb = 16'b0000000000000000;
	
	// Inicializando Fila de Prioridade
	PriorityQueue[0] = 16'b1111111111111111;
	PriorityQueue[1] = 16'b1111111111111111;
	PriorityQueue[2] = 16'b1111111111111111;
	PriorityQueue[3] = 16'b1111111111111111;
	PriorityQueue[4] = 16'b1111111111111111;
	
	// Inicializando Done
	Done = 1'b0;
	
	// Inicializando Break Loop
	break_loop = 1'b0;
	
	// Inicializando demais variáveis
	input1_already_in = 1'b0;
	input2_already_in = 1'b0;
	
end

always @(posedge clock) begin

	// Resetando Variáveis
	break_loop = 1'b0;
	input1_already_in = 1'b0;
	input2_already_in = 1'b0;
	
	// Lógica para checar se o dado presente em ULA_output ou ULA_ld_sd_output já está presente na Fila de Prioridade
	for(i = 0; i <= 4; i = i + 1) begin
		
		if (ULA_output == PriorityQueue[i]) begin
			input1_already_in = 1'b1;
		end
		else if (ULA_ld_sd_output == PriorityQueue[i]) begin
			input2_already_in = 1'b1;
		end
		
	end

	// Adicionar entrada de ULA_output
	if (input1_already_in == 1'b0 && ULA_output != 16'b1111111111111111) begin
	
		for(i = 0; i <= 4 && break_loop != 1; i = i + 1) begin
		
			// Checar se a posição da Fila está vazia
			if (PriorityQueue[i] == 16'b1111111111111111) begin
				
				// Adicionar entrada de ULA_output
				PriorityQueue[i] = ULA_output;
				break_loop = 1'b1;
				
			end
			
		end
		
	end
	
	// Resetando Break Loop
	break_loop = 1'b0;
	
	// Adicionar entrada de ULA_ld_sd_output
	if (input2_already_in == 1'b0 && ULA_ld_sd_output != 16'b1111111111111111) begin
	
		for(i = 0; i <= 4 && break_loop != 1; i = i + 1) begin
		
			// Checar se a posição da Fila está vazia
			if (PriorityQueue[i] == 16'b1111111111111111) begin
				
				// Adicionar entrada de ULA_ld_sd_output
				PriorityQueue[i] = ULA_ld_sd_output;
				break_loop = 1'b1;
				
			end
			
		end
		
	end
	
	
	
	// CDB recebe a primeira posição da Fila de Prioridade
	if (PriorityQueue[0] != 16'b1111111111111111) begin
		cdb = PriorityQueue[0];
		Done = 1'b1;
	end

	
	// Atualizar a Fila de Prioridade
	if (Done) begin
		PriorityQueue[0] = PriorityQueue[1];
		PriorityQueue[1] = PriorityQueue[2];
		PriorityQueue[2] = PriorityQueue[3];
		PriorityQueue[3] = PriorityQueue[4];
		PriorityQueue[4] = 16'b1111111111111111;
		Done = 1'b0;
	end
	
	
	// TODO
	// Acresecentar uma variável que controle se o dado presente no cdb já foi utilizado ou nao, sendo assim, é possível impedir com que
	// o cdb escreva no BR todos os ciclos
	
	// TODO
	// Acrescentar lógica para que o CDB receba o dado no mesmo ciclo em que o sinal "Ula_can_write" seja setado para 1

	
end

endmodule
