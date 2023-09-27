module memoria (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, SW, KEY, LEDG, LEDR);
	
	// [7:0]   => Dados a serem escritos na memoria
	// [15:11] => Endereco da memoria a ser acessado na cache
	// [17:17] => Ativa escrita na cache (wren)
	input [17:0] SW;

	// KEY[0] sera usado como clock
	input [3:0] KEY;

	//Endereco da memoria sendo acessado
	output [0:6] HEX0, HEX1;

	//Estado atual da cache
	output [0:6] HEX2, HEX3;
	
	//Saida da RAM
	output [0:6] HEX4, HEX5;
	
	//Saida da cache
	output [0:6] HEX6, HEX7;

	// LEDs verdes serao usados da seguinte forma:
	// LEDG[7] => aceso para indicar Hit e apagado para indicar Miss
	// LEDG[0] => aceso para indicar wren ativo
	output [8:0] LEDG;

	// LEDs vermelhos serao usados da seguinte forma:
	// LEDR[0]  => aceso para indicar Miss e apagado para indicar Hit
	// LEDR[17] => aceso para indicar que a escrita na memoria foi habilitada
	output [17:0] LEDR;

	// Dados de saida da cache
	wire [7:0] q;

	// Controle de acesso a RAM, sendo
	// [7:0]  => Dados a serem escritos na RAM
	// [8:8]  => Ativa escrita na RAM (wren)
	// [13:9] => Endereco da a ser acessado na RAM
	wire [13:0] RAM;

	// Dados de saida da RAM
	wire [7:0] qRAM;

	// Sinal de hit da cache (0 => Miss, 1 => Hit)
	wire hit;
	
	// Sinal de acesso a memória (0 => Memória está sendo acessada, 1 => Memória deixou de ser acessada)
	wire mem_access_done;
	
	wire [1:0] lru0;
	wire [1:0] lru1;
	wire [1:0] lru2;
	wire [1:0] lru3;
	
	wire d0;
	wire d1;
	wire d2;
	wire d3;
	
	// Identifica o estado atual do processamento da cache
	wire [2:0] state;

	// Implementacao da cache (clock, address, wren, data, q, RAM, qRAM, hit, state, reset, mem_access_done)
	Cache cache (KEY[0], SW[15:11], SW[17], SW[7:0], q, RAM, qRAM, hit, state, KEY[1], mem_access_done, lru0, lru1, lru2, lru3, d0, d1, d2, d3);

	// Memoria RAM (address, clock, data, wren, q)
	ramlpm ram (RAM[13:9], KEY[0], RAM[7:0], RAM[8], qRAM);

	// Displays do endereco da memoria sendo acessado
	disp7seg endereco0 (SW[14:11], HEX0);
	disp7seg endereco1 (SW[15], HEX1);
	
	// Display do estado da cache
	disp7seg estadoCache (state, HEX3);

	// Displays da saida da RAM
	disp7seg dadosRAM0 (qRAM[3:0], HEX4);
	disp7seg dadosRAM1 (qRAM[7:4], HEX5);
	
	// Displays da saida da cache
	disp7seg dadosCache0 (q[3:0], HEX6);
	disp7seg dadosCache1 (q[7:4], HEX7);

	// LED verde indicador de Hit
	assign LEDG[7] = hit;

	// LED vermelho indicador de Miss
	assign LEDR[0] = ~hit;
	
	// LED verde 0 indica acesso a memória
	assign LEDG[0] = ~mem_access_done;
	
	// LED verde 1 indica fim do acesso a memória
	assign LEDG[1] = mem_access_done;

	// LED vermelho indicador de escrita na memoria
	assign LEDR[17] = SW[17];
	
	// LED LRU cache
	assign LEDR[16:15] = lru0;
	assign LEDR[14:13] = lru1;
	assign LEDR[12:11] = lru2;
	assign LEDR[10:9] = lru3;
	
	//dirty cache
	assign LEDR[7] = d0;
	assign LEDR[6] = d1;
	assign LEDR[5] = d2;
	assign LEDR[4] = d3;
	
	
	//assign HEX2=7'b1111111;	 //desativa display 7 segmentos HEX2
	assign HEX2=7'b1111111;	 //desativa display 7 segmentos HEX3
	
endmodule
