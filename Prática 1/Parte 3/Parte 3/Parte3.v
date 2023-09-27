module Parte3 (HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, SW, KEY, LEDG, LEDR);
	// Switches serao usados para controlar os bits que formam os seguintes dados:
	// [7:0]   => Dados a serem escritos na memoria
	// [15:11] => Endereco da memoria a ser acessado na cache
	// [17:17] => Ativa escrita na cache (wren)
	input [17:0] SW;

	// KEY[0] sera usado como clock para permitir e execucao passo a passo,
	// pois sempre que o botao for apertado na FPGA um ciclo de clock sera executado
	input [3:0] KEY;

	// Par de displays de 7 seguimentos para mostrar o endereco da memoria sendo acessado
	output [6:0] HEX0, HEX1;

	// Par de displays de 7 seguimentos para mostrar o estado atual da cache
	output [6:0] HEX2, HEX3;
	
	// Par de displays de 7 seguimentos para mostrar a saida da RAM
	output [6:0] HEX4, HEX5;
	
	// Par de displays de 7 seguimentos para mostrar a saida da cache
	output [6:0] HEX6, HEX7;

	// LEDs verdes serao usados da seguinte forma:
	// LEDG[0] => aceso para indicar via 1 e apagado para indicar via 0
	// LEDG[4] => aceso para indicar a finalização do processo da cache
	// LEDG[7] => aceso para indicar Hit e apagado para indicar Miss
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

	// Identificador da via acessada na cache (via 0 ou via 1)
	wire way;
	
	// Identifica o estado atual do processamento da cache
	wire [2:0] state;

	// Implementacao da cache (clock, address, wren, data, q, RAM, qRAM, hit, way, state, done)
	Cache cache (KEY[0], SW[15:11], SW[17], SW[7:0], q, RAM, qRAM, hit, way, state, LEDG[4]);

	// Memoria RAM (address, clock, data, wren, q)
	ramlpm ram (RAM[13:9], KEY[0], RAM[7:0], RAM[8], qRAM);

	// Displays do endereco da memoria sendo acessado
	Display7Seguimentos endereco0 (SW[14:11], HEX0);
	Display7Seguimentos endereco1 (SW[15], HEX1);

	// Displays do estado atual do processamento da cache
	assign HEX2 = 7'b1111111;
	Display7Seguimentos stateDisplay (state, HEX3);

	// Displays da saida da RAM
	Display7Seguimentos dadosRAM0 (qRAM[3:0], HEX4);
	Display7Seguimentos dadosRAM1 (qRAM[7:4], HEX5);
	
	// Displays da saida da cache
	Display7Seguimentos dadosCache0 (q[3:0], HEX6);
	Display7Seguimentos dadosCache1 (q[7:4], HEX7);

	// LED verde indicador de Hit
	assign LEDG[7] = hit;

	// LED vermelho indicador de Miss
	assign LEDR[0] = ~hit;

	// LED verde indicador da via acessada
	assign LEDG[0] = way;

	// LED vermelho indicador de escrita na memoria
	assign LEDR[17] = SW[17];
endmodule
