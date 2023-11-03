module CDBArbiter(

	input clock,
	input reset,
	
	// Dados das ULA's
	input[15:0] ULA_output,
	input[15:0] ULA_ld_sd_output,
	
	input[15:0] data_mem,
	
	// Saídas
	// cdb[15:15] -> R0_in (Registrador Destino R0)
	// cdb[14:14] -> R1_in (Registrador Destino R1)
	// cdb[13:13] -> R2_in (Registrador Destino R2)
	// cdb[12:11] -> Posição da Instrução na RS
	// cdb[10:10] -> Indica qual ULA escreveu no cdb (1 -> ULA , 0 -> ULA_ld_sd)
	// cdb[9:0]   -> Dado
	output reg[15:0] cdb
	
	
);

// Instanciar i
integer i;

// Fila de Prioridade do CDB Arbiter
reg[15:0] PriorityQueue[4:0];

// Lista de instruções que já foram executadas
reg[15:0] old_instructions[9:0];

// Sinal que registra quando a instrução de maior prioridade é escrita no CDB
reg Done;

// Sinal para controlar Loop
reg break_loop;

// Sinais que salvam a ocorrência e uma entrada na Fila de Prioridade
reg input1_already_in;
reg input2_already_in;

// Sinal para bloquear o cdb durante a execução de um LD
reg load_store_running;

// Variável auxiliar
reg[9:0] data_aux;

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
	load_store_running = 1'b0;
	
	old_instructions[0] = 16'b1111111111111111;
	old_instructions[1] = 16'b1111111111111111;
	old_instructions[2] = 16'b1111111111111111;
	old_instructions[3] = 16'b1111111111111111;
	old_instructions[4] = 16'b1111111111111111;
	old_instructions[5] = 16'b1111111111111111;
	old_instructions[6] = 16'b1111111111111111;
	old_instructions[7] = 16'b1111111111111111;
	old_instructions[8] = 16'b1111111111111111;
	old_instructions[9] = 16'b1111111111111111;
	
end

always @(posedge clock) begin

	// TODO
	// Implementar uma lógica para garantir que o registrador só será atualizado pela última instrução que referência ele como registrador de destino

	// Resetando Variáveis
	break_loop = 1'b0;
	input1_already_in = 1'b0;
	input2_already_in = 1'b0;
	
	// Checando se a instrução já foi executada anteriormente
	for(i = 0; i <= 9; i = i + 1) begin
		if (old_instructions[i] == ULA_output) begin
			input1_already_in = 1'b1;
		end
	end
	
	for(i = 0; i <= 9; i = i + 1) begin
		if (old_instructions[i] == ULA_ld_sd_output) begin
			input2_already_in = 1'b1;
		end
	end
	
	// Lógica para checar se o dado presente em ULA_output ou ULA_ld_sd_output já está presente na Fila de Prioridade
	for(i = 0; i <= 4; i = i + 1) begin
		
		if (ULA_output == PriorityQueue[i]) begin
			input1_already_in = 1'b1;
		end
		else if (ULA_ld_sd_output == PriorityQueue[i]) begin
			input2_already_in = 1'b1;
		end
		
	end
	
	// Adicionar saída das ulas na Fila de Prioridade
	
	// Caso em que ambas as ulas produzem saídas no mesmo ciclo
	if ((input1_already_in == 1'b0 && ULA_output != 16'b1111111111111111) && (input2_already_in == 1'b0 && ULA_ld_sd_output != 16'b1111111111111111)) begin
	
		// Adicionando instrução na lista de instruções já executadas
		for(i = 0; i <= 9 && break_loop != 1; i = i + 1) begin
			if (old_instructions[i] == 16'b1111111111111111) begin
				old_instructions[i] = ULA_output;
				break_loop = 1'b1;
			end
		end
		
		// Resetando Break Loop
		break_loop = 1'b0;
		
		// Adicionando instrução na lista de instruções já executadas
		for(i = 0; i <= 9 && break_loop != 1; i = i + 1) begin
			if (old_instructions[i] == 16'b1111111111111111) begin
				old_instructions[i] = ULA_ld_sd_output;
				break_loop = 1'b1;
			end
		end
		
		// Resetando Break Loop
		break_loop = 1'b0;
		
		// Adicionar primeira saída da ULA
		for(i = 0; i <= 4 && break_loop != 1; i = i + 1) begin
		
			// Checar se a posição da Fila está vazia
			if (PriorityQueue[i] == 16'b1111111111111111) begin
			
				// Dar prioridade para a instrução que foi despachada primeiro
				if (ULA_output[12:11] < ULA_ld_sd_output[12:11]) begin
					PriorityQueue[i] = ULA_output;
					break_loop = 1'b1;
					input1_already_in = 1'b1;
				end
				
				else begin
					PriorityQueue[i] = ULA_ld_sd_output;
					break_loop = 1'b1;
					input2_already_in = 1'b1;
				end
				
			end
			
		end
		
		// Resetando Break Loop
		break_loop = 1'b0;
		
		// Adicionar segunda saída da ULA
		for(i = 0; i <= 4 && break_loop != 1; i = i + 1) begin
		
			// Checar se a posição da Fila está vazia
			if (PriorityQueue[i] == 16'b1111111111111111) begin
			
				// Dar prioridade para a instrução que foi despachada primeiro
				if (ULA_output[12:11] > ULA_ld_sd_output[12:11]) begin
					PriorityQueue[i] = ULA_output;
					break_loop = 1'b1;
					input1_already_in = 1'b1;
				end
				
				else begin
					PriorityQueue[i] = ULA_ld_sd_output;
					break_loop = 1'b1;
					input2_already_in = 1'b1;
				end
				
			end
			
		end
		
		
		
	end

	// Adicionar entrada de ULA_output
	if (input1_already_in == 1'b0 && ULA_output != 16'b1111111111111111) begin
	
		// Resetando Break Loop
		break_loop = 1'b0;
	
		// Adicionando instrução na lista de instruções já executadas
		for(i = 0; i <= 9 && break_loop != 1; i = i + 1) begin
			if (old_instructions[i] == 16'b1111111111111111) begin
				old_instructions[i] = ULA_output;
				break_loop = 1'b1;
			end
		end
		
		// Resetando Break Loop
		break_loop = 1'b0;
		
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
	
		// Adicionando instrução na lista de instruções já executadas
		for(i = 0; i <= 9 && break_loop != 1; i = i + 1) begin
			if (old_instructions[i] == 16'b1111111111111111) begin
				old_instructions[i] = ULA_ld_sd_output;
				break_loop = 1'b1;
			end
		end
		
		// Resetando Break Loop
		break_loop = 1'b0;
	
		for(i = 0; i <= 4 && break_loop != 1; i = i + 1) begin
		
			// Checar se a posição da Fila está vazia
			if (PriorityQueue[i] == 16'b1111111111111111) begin
				
				// Adicionar entrada de ULA_ld_sd_output
				PriorityQueue[i] = ULA_ld_sd_output;
				break_loop = 1'b1;
				
			end
			
		end
		
	end
	
	// Checando se o dado recebido é proveniente de um Load ou Store
	if (PriorityQueue[0][10:10] == 1'b0 && data_mem == 16'b1111111111111111) begin
	
		// Atribuir saída da ULA para o CDB
		cdb = {3'b000,PriorityQueue[0][12:0]}; // Os bits que indicam a escrita no Banco de Registradores são enviado todos com valor 0, para evitar que o endereço do Load seja escrito em algum registrador	
		
		// Bloquear o CDB
		load_store_running = 1'b1;
		
	end
	
	// Checar se o CDB Arbiter recebeu algum dado proveniente da memória
	if (load_store_running == 1'b1 && data_mem != 16'b1111111111111111) begin
		
		// Salvando o dado vindo da memória
		PriorityQueue[0][9:0] = data_mem;
	
		// Montar o sinal do Load com o dado buscado na memória
		cdb = PriorityQueue[0];
		
		// Desbloquear o CDB
		load_store_running = 1'b0;
		
		// Setar Done
		Done = 1'b1;
		
	end
	
	// CDB recebe a primeira posição da Fila de Prioridade
	if (PriorityQueue[0] != 16'b1111111111111111 && load_store_running == 1'b0) begin
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

end

endmodule
