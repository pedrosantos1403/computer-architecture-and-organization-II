module CacheL1()

// Address -> Endereco da Memoria
// address[4:0] -> Index[2:0] e Tag[4:2]
// Talvez criar outra memoria com o endereco maior


// Endereço Bloco
// data [3:0] -> 2 a 9 (Decimal)
// Tag [11:4] -> 100 a 108 (Decimal)
// LRU [13:12] -> 0 a 3 (Decimal)
// Dirty [14:14] -> 0 a 1 (Decimal)
// Valid [15:15] -> 0 a 1 (Decimal)

// Cache Totalmente Associativa de 4 Posições
reg [15:0] cache [3:0];

// Iniciaciliza a cache com os valores indicados no arquivo
	initial begin
		cache[0][15:0] <= 15'b;
		cache[1][15:0] <= 15'b;
		cache[2][15:0] <= 15'b;
		cache[3][15:0] <= 15'b;


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