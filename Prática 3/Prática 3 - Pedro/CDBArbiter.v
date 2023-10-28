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

reg ULA_can_write;
reg ULA_ld_sd_can_write;

initial begin

	// Inicializando variáveis que controlam escrita da ULA
	ULA_can_write <= 1'b0;
	ULA_ld_sd_can_write <= 1'b0;
	
	// Inicializando o cdb com um valor inválido
	cdb = 16'b0000000000000000;
	
end

always @(posedge clock) begin

	// Resetando Variáveis
	cdb = 16'b0000000000000000;

	// Checar se a saída das ULA's é válida
	if (ULA_output != 16'b1111111111111111) begin
		ULA_can_write <= 1'b1;
	end
	
	if (ULA_ld_sd_output != 16'b1111111111111111) begin
		ULA_ld_sd_can_write <= 1'b1;
		// Acrescentar lógica da memória de dados
	end

	// ULA de Sum/Sub tem prioridade para escrever no cdb
	if (ULA_can_write) begin
		cdb = ULA_output;
		ULA_can_write <= 1'b0;
	end
	
	else if (ULA_ld_sd_can_write) begin
	
		// Se for um Load/Store o cdb não escreve no Banco de Registradores, ele deve apenas retornar
		// o endereço de memória para a RS e salvar esse endereço na coluna Address
		
		cdb = ULA_ld_sd_output;
		ULA_ld_sd_can_write <= 1'b0;
		// Acrescentar lógica da memória de dados
	end
	
end

endmodule
