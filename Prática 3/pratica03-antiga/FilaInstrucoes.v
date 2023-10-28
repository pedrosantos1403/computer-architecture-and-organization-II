module memoriaInstrucao(origem,saida);
	input [7:0]origem;
	output [11:0] saida;
	reg [11:0]MEM[127:0];	initial
	begin//Instruções a serem executadas
		MEM[0] = 12'b111111111111;  //Vai pular esta instrução (sempre pula a primeira)
		MEM[1] = 12'b001010000000; //R2 = R0 + R1 (2)
		MEM[2] = 12'b000100010001; //R4 = R2 - R0 (1)
		MEM[3] = 12'b101100011000; //R4 = R3 + R5 (3)
		MEM[4] = 12'b100101100000; //R5 = R4 + R4 (6)
		// MEM[5] = 12'b111111111111;  //Vai pular esta instrução (sempre pula a primeira)
	end
	assign saida = MEM[origem];
endmodule

module PC(clk,reset,parada,pc);
  input clk,reset,parada;
  output reg [7:0]pc;
  initial
  begin
    pc <= 8'b00000000; //Valor incial de pc tem que ser zero
  end
  always @(posedge clk)
  begin
    if(reset) //Se reset for ativo, pc deve ser zerado novamente
	   pc <= 8'b00000000;
	 else if(!parada) //Se não estiver ocorrendo uma parada, pc deve ser acrescido em um
      pc <= pc + 1;
  end
endmodule

module FilaInstrucoes(clk,reset,inst,addFullControl); 
//Modulo de controle das instrucoes a serem despachadas
	parameter ADD = 3'b000;
	parameter SUB = 3'b001;
	
	input [2:0]addFullControl;
	input clk,reset;
	output [11:0]inst;
	wire [7:0]PC;
	reg parada;
	
	wire [2:0]I;
	assign I = inst[2:0];
	//Sempre que o clock se alterar
	always @(clk) begin 
		parada = 0;
		//Verificando se é uma soma ou subtração
		if(addFullControl == 3 && (I == ADD || I == SUB))begin 
			parada = 1;
		end
	end
	PC pc(clk,reset,parada,PC);
	memoriaInstrucao memoriaInst(PC,inst);
endmodule 