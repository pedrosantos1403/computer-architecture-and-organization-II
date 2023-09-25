module memory(addr, data, wr_en, clock, q);
	
	/*
	Endereço no bit 15 -> 0 para acesso a ROM (Memória Instrução) e 1 para acesso a RAM (Memória Dados)
	*/
	
	
	input [15:0] addr, data;
	input wr_en, clock;
	output [15:0] q;
	
	wire wr_ram;
	wire [15:0] q_ram, q_rom;
	
	
	//Escrita
	assign wr_ram = wr_en & ~addr[7];
	
	//Leitura
	assign q = addr[7] ? q_rom : q_ram;
	
	
	ram_lpm RAM(addr[6:0],clock,data,wr_ram,q_ram);
	rom_lpm ROM(addr[6:0],clock,q_rom);

endmodule