module Cache (clock, address, wren, data, q, RAM, qRAM, hit, way, state, done);
	input clock, wren;
	input [7:0] data;
	input [7:0] qRAM;

	// Endereco a ser acessado sendo:
	// [1:0] => Index do endereco
	// [4:2] => Tag do endereco
	input [4:0] address;

	output reg [7:0] q;
	output reg [13:0] RAM;

	output reg hit;
	output reg way;

	// Controle do estado de processamento da cache, sendo:
	// 0 => Inicio
	// 1 => Processamento Interno da Cache
	// 2 => Write Back
	// 3 => Leitura da RAM
	// 4 => Estado de Espera
	// 5 => Atualizacao da Cache
	output reg [2:0] state;

	// Indica a finalizacao do processo da cache
	output reg done;

	// Cria a cache com duas vias, 4 enderecos por via e 14 bits para cada endereco, sendo estes:
	// [7:0]   => Dados armazenados
	// [10:8]  => Tag do endereco
	// [11:11] => Bit de controle LRU (0 = mais antigo, 1 = mais recente)
	// [12:12] => Bit de controle Dirty
	// [13:13] => Bit de controle Valid
	reg [13:0] cache [1:0][3:0];

	// Iniciaciliza a cache totalmente vazia e sem valores validos
	initial begin
		cache[0][0][13:0] <= 14'b00010000000001;
		cache[0][1][13:0] <= 14'b10100000000011;
		cache[0][2][13:0] <= 14'b11010100000101;
		cache[0][3][13:0] <= 14'b00000000000000;

		cache[1][0][13:0] <= 14'b00000000000010;
		cache[1][1][13:0] <= 14'b00000000000100;
		cache[1][2][13:0] <= 14'b10111100000110;
		cache[1][3][13:0] <= 14'b00000000000000;

		state <= 3'd0;
		done <= 1;
	end

	// Identifica e atualiza hit e via
	always @ (cache, address, wren, data) begin
		// Será hit se a tag em uma das vias para o index do endereco corresponder e se o bit de controle for valido
		hit <= (cache[0][address[1:0]][10:8] == address[4:2] && cache[0][address[1:0]][13]) ||
			   (cache[1][address[1:0]][10:8] == address[4:2] && cache[1][address[1:0]][13]);

		// Usa a via 1 se for hit e a tag na via 1 para o index do endereco corresponder e este for valido,
		// ou se for miss e o LRU da via 0 for o mais recente
		way <= (hit && cache[1][address[1:0]][10:8] == address[4:2] && cache[1][address[1:0]][13]) || (~hit && cache[0][address[1:0]][11]);
	end

	always @ (posedge clock) begin
		case (state)
			3'd0:
			begin
				// Inicio
				done <= 1'b0;

				if (~hit && cache[way][address[1:0]][12]) begin
					// Se Miss e Dirty segue para Write Back na RAM
					state <= 3'd2;
				end
				else if (~hit && ~wren) begin
					// Se Miss e a escrita não estiver ativada segue para a leitura da RAM
					state <= 3'd3;
				end
				else begin
					// Caso contrário segue para o processamento interno da cache
					state <= 3'd1;
				end
			end
			3'd1:
			begin
				// Processamento Interno da Cache
				if (wren) begin
					// Realiza escrita modificando os dados da cache de acordo
					cache[way][address[1:0]][7:0] <= data;
					cache[way][address[1:0]][10:8] <= address[4:2];
					cache[way][address[1:0]][13] <= 1'b1;
					cache[way][address[1:0]][12] <= 1'b1;
					q <= data;
				end
				else begin
					// Realiza leitura passando os dados do endereco
					q <= cache[way][address[1:0]][7:0];
				end

				// Apos a leitura ou escrita, inverte os valores de LRU nas vias
				cache[way][address[1:0]][11] <= 1'b1;
				cache[~way][address[1:0]][11] <= 1'b0;

				// Finaliza processamento da cache
				state <= 3'd0;
				done <= 1;
			end
			3'd2:
			begin
				// Write back passando os dados de escrita para a RAM
				// Endereço = concatena(Tag, Index)
				RAM[13:9] <= {cache[way][address[1:0]][10:8], address[1:0]};

				// Ativa escrita na RAM
				RAM[8] <= 1'b1;

				// Passa os dados da cache para serem escritos na RAM
				RAM[7:0] <= cache[way][address[1:0]][7:0];
				
				if (wren) begin
					// Segue para processamento interno da cache
					state <= 3'd1;
				end
				else begin
					// Segue para leitura da RAM
					state <= 3'd3;
				end
			end
			3'd3:
			begin
				// Leitura da RAM passando o endereco para ela
				RAM[13:9] <= address;

				// Desativa escrita na RAM
				RAM[8] <= 1'b0;
				
				// Segue para estado de espera
				state <= 3'd4;
			end
			3'd4:
			begin
				// Estado de espera para concluir a leitura da RAM
				state <= 3'd5;
			end
			3'd5:
			begin
				// Atualizacao da cache a partir do retorno da RAM
				// Salva a tag
				cache[way][address[1:0]][10:8] <= address[4:2];

				// Salva os dados lidos
				cache[way][address[1:0]][7:0] <= qRAM;

				// Marca registro da cache como valido
				cache[way][address[1:0]][13] <= 1'b1;

				// Marca registro da cache como limpo
				cache[way][address[1:0]][12] <= 1'b0;
				
				// Segue para o processamento interno da cache
				state <= 3'd1;
			end
		endcase
	end
endmodule
