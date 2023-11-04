module ReservationStation(
	
	input clock,
	input reset,
	
	// Informações da Instruction Queue
	input [2:0] RX,
	input [2:0] RY,
	input [2:0] RZ,
	input [2:0] ULA_op,
	input [3:0] immediate,
	
	// Informações do CDB
	// cdb[15:15] -> R0_in (Registrador Destino R0)
	// cdb[14:14] -> R1_in (Registrador Destino R1)
	// cdb[13:13] -> R2_in (Registrador Destino R2)
	// cdb[12:11] -> Posição da Instrução na RS
	// cdb[10:10] -> Indica qual ULA escreveu no cdb (1 -> ULA , 0 -> ULA_ld_sd)
	// cdb[9:0]   -> Dado
	input[15:0] cdb,
	
	// Informações do Bank Of Registers
	input[9:0] R0_data,
	input[9:0] R1_data,
	input[9:0] R2_data,
	
	// Saídas para ULA de Soma/Sub
	output reg[15:0] operand1_sumsub, operand2_sumsub,
	output reg[2:0] Opcode_sumsub,
	output reg[2:0] Reg_dest_sumsub,
	output reg operands_ready_sumsub,
	output reg[1:0] sumsub_position,
	
	// Saídas para ULA de Load/Store
	output reg[15:0] operand1_ldsd, operand2_ldsd,
	output reg[2:0] Opcode_ldsd,
	output reg[2:0] Reg_dest_ldsd,
	output reg operands_ready_ldsd,
	output reg[1:0] ldsd_position,
	
	output reg[4:0] address,
	
	output reg wren,
	output reg[15:0] data_in_mem,
	
	output reg stall

);

// Instanciar i
integer i;

// Instanciar Tabela da RS
reg Busy[2:0];
reg[2:0] Operation[2:0];
reg[2:0] Reg_dest[2:0];
reg[15:0] Vj[2:0];
reg[15:0] Vk[2:0];
reg[2:0] Qj[2:0];
reg[2:0] Qk[2:0];
reg[15:0] Address[2:0];
reg[15:0] full_instruction[2:0];

// Variável que controla se o operando está pronto para ser utilizado na ULA
// [0:0] -> Indica se o R0 está esperando algum valor
// [1:1] -> Indica se o R1 está esperando algum valor
// [2:2] -> Indica se o R2 está esperando algum valor
reg[2:0] is_waiting_value;

// TODO -> witing value deve ser uma matriz que indica quantas instruções estão aleterando o valor de um determinado registrador

// Sinal para controlar disponibilidade das ULA's
reg ULA_free;
reg ULA_ld_sd_free;

// Variável auxiliar para salvar o Registrador de Destino de uma instrução
reg[2:0] reg_dest_aux;

// Variável para controlar o Loop
reg break_loop;

// Variável para controlar presença da instrução na RS
reg instruction_already_in;

// Variável para controlar quantas instrução da RS produzem valor para o mesmo registrador
reg still_waiting_value;

// Variável para controlar se o dado recebido do CDB proveniente de um Load é endereço de memória ou dado real
reg counter_ld_sd;

// Teste
reg teste;


initial begin

	// Teste
	teste = 1'b0;
	
	// Inicializando variável de controle de Loop
	break_loop = 1'b0;
	
	// Inicializando a coluna Addrress
	Address[0] = 16'b1111111111111111;
	Address[1] = 16'b1111111111111111;
	Address[2] = 16'b1111111111111111;
	
	// Inicializando Busy
	Busy[0] = 1'b0;
	Busy[1] = 1'b0;
	Busy[2] = 1'b0;
	
	// Inicializando as colunas Qj e Qk com todos os bits iguais a 1, o que indica valores inválidos
	Qj[0] = 3'b111;
	Qj[1] = 3'b111;
	Qj[2] = 3'b111;
	Qk[0] = 3'b111;
	Qk[1] = 3'b111;
	Qk[2] = 3'b111;
	
	// Inicializando as colunas Vj e Vk com todos os bits iguais a 1, o que indica valores inválidos
	Vj[0] = 16'b1111111111111111;
	Vj[1] = 16'b1111111111111111;
	Vj[2] = 16'b1111111111111111;
	Vk[0] = 16'b1111111111111111;
	Vk[1] = 16'b1111111111111111;
	Vk[2] = 16'b1111111111111111;
	
	// Inicializando vetor que salva os registradores que estão aguardando novos valores
	is_waiting_value <= 3'b000;
	
	// Inicializando disponibilidade das ULA's
	ULA_free <= 1'b1;
	ULA_ld_sd_free <= 1'b1;
	
	// Inicializando variável auxiliar de registrador de destino
	reg_dest_aux <= 3'b000;
	
	// Inicializando sinal de stall
	stall <= 1'b0;
	
	// Inicializando demais variáveis
	instruction_already_in = 1'b0;
	still_waiting_value = 1'b0;
	counter_ld_sd = 1'b0;
	address = 5'b11111;
	wren = 1'b0;
	data_in_mem = 16'b1111111111111111;
	
end

always @(posedge clock) begin

	// Resetando variáveis
	break_loop = 1'b0;
	still_waiting_value = 1'b0;

	// Lógica para analisar se existe alguma entrada no CDB e atualizar a RS
	
	// Se o cdb possui um dado válido esse dado será analisado
	if (cdb != 16'b0000000000000000) begin
	
		// Checar se a entrada do CDB é proveniente de um Load
		if (cdb[10:10] == 1'b0 && Operation[cdb[12:11]] == 3'b010) begin
		
			// Resetando variável auxiliar
			reg_dest_aux = 3'b000;
			
			// CDB retornou o endereço de memória
			if (counter_ld_sd == 1'b0) begin
			
				// Salvar endereco rebido na coluna address		
				Address[cdb[12:11]] = cdb[9:0];
				
				// Quando o Address for alterado é preciso alterar o endereço de acesso à memória
				address = cdb[4:0];
				
				// Somar contador
				counter_ld_sd = counter_ld_sd + 1'b1;
				
			end
			
			// CDB retornou o dado
			else if (counter_ld_sd == 1'b1) begin
			
				// Analisar se o Registrador Destino indicado pelo cdb está esperando algum valor (Resultado de Soma e Subtração)
				if ((cdb[15:13] == 3'b100 && is_waiting_value[0:0] == 1'b1) ||
					 (cdb[15:13] == 3'b010 && is_waiting_value[1:1] == 1'b1) ||
					 (cdb[15:13] == 3'b001 && is_waiting_value[2:2] == 1'b1)) begin
					
					// Salvar o rótulo do registrador de destino apartir do sinal do cdb em uma variável auxiliar
					if (cdb[15:13] == 3'b100) begin
						reg_dest_aux = 3'b000;
					end
					else if (cdb[15:13] == 3'b010) begin
						reg_dest_aux = 3'b001;
					end
					else if (cdb[15:13] == 3'b001) begin
						reg_dest_aux = 3'b010;
					end
			
			
					// Atualizar todas as referências àquele registrador na RS
					for(i = 0; i <= 2; i = i + 1) begin
						
						// Checar se o registrador de destino do cdb está na coluna Qj
						if (Qj[i] == reg_dest_aux) begin
							
							// Invalidar coluna Qj
							Qj[i] = 3'b111;
							
							// Escrever valor em Vj
							Vj[i][15:10] = 6'b0;
							Vj[i][9:0] = cdb[9:0];
							
						end
						
						// Checar se o registrador de destino do cdb está na coluna Qk
						if (Qk[i] == reg_dest_aux) begin
						
							// Invalidar coluna Qk
							Qk[i] = 3'b111;
							
							// Escrever valor em Vk
							Vk[i][15:10] = 6'b0;
							Vk[i][9:0] = cdb[9:0];
							
						end
					
					end
			
					// Checar se existe alguma instrução subsequente que vai produzir valor para o mesmo registrador
					for(i = 0; i <= 2; i = i + 1) begin
						if (Reg_dest[i] == reg_dest_aux && Busy[i] == 1'b1) begin
							still_waiting_value = 1'b1;
						end
					end
					
					// Atualizar Vetor que indica qual Registrador está esperando um valor
					if (still_waiting_value == 1'b0) begin
						if (cdb[15:13] == 3'b100) begin
							is_waiting_value[0:0] = 1'b0;
						end
						else if (cdb[15:13] == 3'b010) begin
							is_waiting_value[1:1] = 1'b0;
						end
						else if (cdb[15:13] == 3'b001) begin
							is_waiting_value[2:2] = 1'b0;
						end
					end
				
					// Excluir instrução executada da RS
					Busy[cdb[12:11]] = 0;
					
					// Alterar a disponibilidade da ULA que escreveu no CDB
					if (cdb[10:10] == 1) begin
						ULA_free = 1'b1;
					end
					else if (cdb[10:10] == 0) begin
						ULA_ld_sd_free = 1'b1;
					end
					
					// Resetar o contador
					counter_ld_sd = 1'b0;
					
					// Resetar o address
					address = 5'b11111;
			
				end
				
			end
			
		end
		
		// Checar se a entrada do CDB é proveniente de um Store
		if (cdb[10:10] == 1'b0 && Operation[cdb[12:11]] == 3'b011) begin
		
			// Enviando dado para a memória
			if (counter_ld_sd == 1'b0) begin
			
				// Salvar endereco rebido na coluna address		
				Address[cdb[12:11]] = cdb[9:0];
			
				// Quando o Address for alterado é preciso alterar o endereço de acesso à memória
				address = cdb[4:0];
				
				// Habilitar escrita na memória
				wren = 1'b1;
				
				// Atribuir dado que será escrito na memória
				if (Reg_dest[cdb[12:11]] == 3'b000/*R0*/) begin
					data_in_mem = R0_data;
				end
				else if (Reg_dest[cdb[12:11]] == 3'b001/*R1*/) begin
					data_in_mem = R1_data;
				end
				else if (Reg_dest[cdb[12:11]] == 3'b010/*R2*/) begin
					data_in_mem = R2_data;
				end
				
				// Excluir Store da Estação de Reserva
				Busy[cdb[12:11]] = 0;
				
				// Somar contador
				counter_ld_sd = counter_ld_sd + 1'b1;
				
			end
			
			// Dado já foi salvo na memória - Resetar o Address
			else if (counter_ld_sd == 1'b1) begin
			
				// Resetar o address
				address = 5'b11111;
				
				// Desabilitar a escrita na memória
				wren = 1'b0;
				
				// Alterar a disponibilidade da ULA que escreveu no CDB
				if (cdb[10:10] == 1) begin
					ULA_free = 1'b1;
				end
				else if (cdb[10:10] == 0) begin
					ULA_ld_sd_free = 1'b1;
				end
				
			end
			
		end
		
		// Checar se a entrada do CDB é proveniente de uma Soma/Subtração
		else if (cdb[10:10] == 1'b1) begin
		
			// Resetando variável auxiliar
			reg_dest_aux = 3'b000;
		
			// Analisar se o Registrador Destino indicado pelo cdb está esperando algum valor (Resultado de Soma e Subtração)
			if ((cdb[15:13] == 3'b100 && is_waiting_value[0:0] == 1'b1) ||
				 (cdb[15:13] == 3'b010 && is_waiting_value[1:1] == 1'b1) ||
				 (cdb[15:13] == 3'b001 && is_waiting_value[2:2] == 1'b1)) begin
				
				// Salvar o rótulo do registrador de destino apartir do sinal do cdb em uma variável auxiliar
				if (cdb[15:13] == 3'b100) begin
					reg_dest_aux = 3'b000;
				end
				else if (cdb[15:13] == 3'b010) begin
					reg_dest_aux = 3'b001;
				end
				else if (cdb[15:13] == 3'b001) begin
					reg_dest_aux = 3'b010;
				end
			
			
				// Atualizar todas as referências àquele registrador na RS
				for(i = 0; i <= 2; i = i + 1) begin
					
					// Checar se o registrador de destino do cdb está na coluna Qj
					if (Qj[i] == reg_dest_aux) begin
						
						// Invalidar coluna Qj
						Qj[i] = 3'b111;
						
						// Escrever valor em Vj
						Vj[i][15:10] = 6'b0;
						Vj[i][9:0] = cdb[9:0];
						
					end
					
					// Checar se o registrador de destino do cdb está na coluna Qk
					if (Qk[i] == reg_dest_aux) begin
					
						// Invalidar coluna Qk
						Qk[i] = 3'b111;
						
						// Escrever valor em Vk
						Vk[i][15:10] = 6'b0;
						Vk[i][9:0] = cdb[9:0];
						
					end
				
				end
			
				// Checar se existe alguma instrução subsequente que vai produzir valor para o mesmo registrador
				for(i = 0; i <= 2; i = i + 1) begin
					if (Reg_dest[i] == reg_dest_aux && Busy[i] == 1'b1) begin
						still_waiting_value = 1'b1;
					end
				end
				
				// Atualizar Vetor que indica qual Registrador está esperando um valor
				if (still_waiting_value == 1'b0) begin
					if (cdb[15:13] == 3'b100) begin
						is_waiting_value[0:0] = 1'b0;
					end
					else if (cdb[15:13] == 3'b010) begin
						is_waiting_value[1:1] = 1'b0;
					end
					else if (cdb[15:13] == 3'b001) begin
						is_waiting_value[2:2] = 1'b0;
					end
				end
			
				// Excluir instrução executada da RS
				Busy[cdb[12:11]] = 0;
				
				// Alterar a disponibilidade da ULA que escreveu no CDB
				if (cdb[10:10] == 1) begin
					ULA_free = 1'b1;
				end
				else if (cdb[10:10] == 0) begin
					ULA_ld_sd_free = 1'b1;
				end
			
			end
		
		end
		
	end
	
	// Lógica para adicionar instrução na RS
	
	// Resetando Variáveis
	operands_ready_sumsub = 1'b0;
	operands_ready_ldsd = 1'b0;
	instruction_already_in = 1'b0;
	
	// TODO
	// Loop para checar se a instrução recebida já está na RS
	for(i = 0; i <= 2; i = i + 1) begin
		if ({immediate,ULA_op,RX,RY,RZ} == full_instruction[i]) begin
			instruction_already_in = 1'b1;
		end
	end
	
	// Loop para adicionar instrução recebida na RS
	for(i = 0; i <= 2 && break_loop != 1; i = i + 1) begin
		
		// Se uma instrução válida é encontrada na entrada e a RS possui espaço vazio essa instrução é adicionada
		if (Busy[i] == 0 && {immediate,ULA_op,RX,RY,RZ} != 16'b1111111111111111 && instruction_already_in == 1'b0) begin
		
			// Quebrar o Loop ao adicionar uma instrução
			break_loop = 1'b1;
		
			// Alterar o Busy para 1 na linha em que a instrução for inserida
			Busy[i] = 1;
			
			// Salvar a instrução inserida na sua forma completa
			full_instruction[i] = {immediate,ULA_op,RX,RY,RZ};
			
			// Salvar tipo da instrução
			Operation[i] = ULA_op;
			
			// Adicionando Soma/Subtração na RS
			if (ULA_op == 3'b000 /*Soma*/ || ULA_op == 3'b001 /*Subtração*/) begin
			
				// Salvar o Registrador de Destino (RX)
				Reg_dest[i] = RX;
				
				// Checar se o primeiro operando está disponível (RY)
				if (RY == 3'b000 /*R0*/ && is_waiting_value[0:0] == 0) begin
					Vj[i] = R0_data;
				end
				else if (RY == 3'b001 /*R1*/ && is_waiting_value[1:1] == 0) begin
					Vj[i] = R1_data;
				end
				else if (RY == 3'b010 /*R2*/ && is_waiting_value[2:2] == 0) begin
					Vj[i] = R2_data;
				end
				
				// Checar se o primeiro operando está esperando algum valor (RY)
				if (RY == 3'b000 /*R0*/ && is_waiting_value[0:0] == 1) begin
					Qj[i] = RY;
				end
				else if (RY == 3'b001 /*R1*/ && is_waiting_value[1:1] == 1) begin
					Qj[i] = RY;
				end
				else if (RY == 3'b010 /*R2*/ && is_waiting_value[2:2] == 1) begin
					Qj[i] = RY;
				end
				
				// Checar se o segundo operando está disponível (RZ)
				if (RZ == 3'b000 /*R0*/ && is_waiting_value[0:0] == 0) begin
					Vk[i] = R0_data;
				end
				else if (RZ == 3'b001 /*R1*/ && is_waiting_value[1:1] == 0) begin
					Vk[i] = R1_data;
				end
				else if (RZ == 3'b010 /*R2*/ && is_waiting_value[2:2] == 0) begin
					Vk[i] = R2_data;
				end
				
				// Checar se o segundo operando está esperando algum valor (RZ)
				if (RZ == 3'b000 /*R0*/ && is_waiting_value[0:0] == 1) begin
					Qk[i] = RZ;
				end
				else if (RZ == 3'b001 /*R1*/ && is_waiting_value[1:1] == 1) begin
					Qk[i] = RZ;
				end
				else if (RZ == 3'b010 /*R2*/ && is_waiting_value[2:2] == 1) begin
					Qk[i] = RZ;
				end
				
				// Salvar que Reg_dest está esperando um valor novo
				if (RX == 3'b000) begin
					is_waiting_value[0:0] = 1'b1;
				end
				else if (RX == 3'b001) begin
					is_waiting_value[1:1] = 1'b1;
				end
				if (RX == 3'b010) begin
					is_waiting_value[2:2] = 1'b1;
				end
				
			end
			
			// Adicionando Load/Store na RS
			else if (ULA_op == 3'b010 /*Load*/ || ULA_op == 3'b011 /*Store*/) begin
				
				// Salvar o Registrador de Destino (RX)
				Reg_dest[i] = RX;
				
				// Salvar o primeiro operando (immediate)
				Vj[i] = immediate;
				
				// Checar se o segundo operando está disponível (RY)
				if (RY == 3'b000 /*R0*/ && is_waiting_value[0:0] == 0) begin
					Vk[i] = R0_data;
				end
				else if (RY == 3'b001 /*R1*/ && is_waiting_value[1:1] == 0) begin
					Vk[i] = R1_data;
				end
				else if (RY == 3'b010 /*R2*/ && is_waiting_value[2:2] == 0) begin
					Vk[i] = R2_data;
				end
				
				// Checar se o segundo operando está esperando algum valor (RY)
				if (RY == 3'b000 /*R0*/ && is_waiting_value[0:0] == 1) begin
					Qk[i] = RY;
				end
				else if (RY == 3'b001 /*R1*/ && is_waiting_value[1:1] == 1) begin
					Qk[i] = RY;
				end
				else if (RY == 3'b010 /*R2*/ && is_waiting_value[2:2] == 1) begin
					Qk[i] = RY;
				end
				
				// Salvar que Reg_dest está esperando um valor novo
				if (RX == 3'b000 && Operation[i] == 3'b010) begin
					is_waiting_value[0:0] = 1'b1;
				end
				else if (RX == 3'b001 && Operation[i] == 3'b010) begin
					is_waiting_value[1:1] = 1'b1;
				end
				else if (RX == 3'b010 && Operation[i] == 3'b010) begin
					is_waiting_value[2:2] = 1'b1;
				end
				
			end
			
		end
		
	end
	
	// Loop para percorrer a RS e mandar instruções para serem executadas
	for(i = 0; i <= 2; i = i + 1) begin
		
		// Se a posição da RS possui uma instrução com os operandos prontos ela poderá ser executada
		if (Busy[i] == 1 && Qj[i] == 3'b111 && Qk[i] == 3'b111) begin
			
			// Soma/Sub
			if (Operation[i] == 3'b000 || Operation[i] == 3'b001) begin
				
				// Despachar Soma/Sub se a ULA de Soma/Sub estiver disponível
				if (ULA_free == 1'b1) begin
					ULA_free = 1'b0;
					operand1_sumsub = Vj[i];
					operand2_sumsub = Vk[i];
					Reg_dest_sumsub = Reg_dest[i];
					Opcode_sumsub = Operation[i];
					operands_ready_sumsub = 1'b1;
					sumsub_position = i;
				end
				
			end
			
			// Load/Store
			if (Operation[i] == 3'b010 || Operation[i] == 3'b011) begin
			
				// Despachar Load/Store se a ULA de Load/Store estiver disponível
				if (ULA_ld_sd_free == 1'b1) begin
					ULA_ld_sd_free = 1'b0;
					operand1_ldsd = Vj[i];
					operand2_ldsd = Vk[i];
					Reg_dest_ldsd = Reg_dest[i];
					Opcode_ldsd = Operation[i];
					operands_ready_ldsd = 1'b1;
					ldsd_position = i;
				end
				
			end
			
		end
		
	end
	
	// Checar se a RS está cheia, caso esteja nenhum isntrução é recebida no prócimo clock
	if (Busy[0] == 1 && Busy[1] == 1 && Busy[2] == 1) begin
		
		// Sinal que avisa a Instruction Queue que a RS está cheia
		stall = 1'b1;
		
	end
	
	else begin
	
		// Sinal que avisa a Instruction Queue que a RS possui espaço vazio
		stall = 1'b0;
		
	end
	
	
	
	// O label é sempre referente a última coluna que possui o registrador especificado como registrador de destino
	
end

endmodule
