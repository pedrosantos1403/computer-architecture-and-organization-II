// Tarefas : -> Sinal para garantir que os registradores XXX e YYY não serão alterados durante as instruções

module pratica2(
	input PClock,
	input ResetIn,
	output [15:0] bus,
	output [15:0] Reg0,
	output [15:0] Reg1,
	output [15:0] Reg2,
	output [15:0] Reg3,
	output [15:0] Reg4,
	output [15:0] Reg5,
	output [15:0] Reg6,
	output [15:0] PC // Sinal de PC que será usado para acessar os endereços da memória de instruções
);

wire done;
wire [15:0] DIN;
wire [15:0] Addr;
wire [15:0] DataInMem; // Recebe o valor salvo no Registrador DOUT para salvar na memória
wire W;

// Processador Multiciclo
proc processador(PClock, DIN, ResetIn, Reg0, Reg1, Reg2, Reg3, Reg4, Reg5, Reg6, PC /*Reg7*/, Addr /*Addr_output*/, DataInMem /*Dout_output*/, W /*Wren*/, bus, done);

// Memória RAM
// Posição 0 a 9 => Dados
// Posição 10 a 20 => Instruções
mem_ram mem_data (Addr, PClock, DataInMem, W, DIN);

// Memória ROM (Instruções)
//rom_mem mem_inst (PC, PClock/*~done*/, IR /*Recebe instruções da ROM*/);
// Usar o Clock na ROM pode acarretar na alteração de IR em cada ciclo de clock, ou seja, o IR pode receber uma nova inst durante
// a exec de outra inst
// Usar ~done garante que a memória de instrução será acessada somente enquanto o processador estiver rodando
// ROM -> Podemos usar o sinal de PC para acessar os endereços
// Ou podemos salvar o conteúdo de PC em ADDR na unidade de controle, para isso Addr recebe o valor de Reg7 em T0

endmodule

// OK!
module proc(
	input Clock,
	input [15:0]DIN, // DIN[9:6] -> Opcode, DIN[5:3] -> XXX , DIN[2:0] -> YYY
	input Reset,
	output [15:0] R0_output,
	output [15:0] R1_output,
	output [15:0] R2_output, 
	output [15:0] R3_output,
	output [15:0] R4_output,
	output [15:0] R5_output, 
	output [15:0] R6_output,
	output [15:0] R7_output,
	output [15:0] Addr_output,
	output [15:0] Dout_output,
	output W,
	output reg[15:0] BusWires,
	output Done
); 
	
wire [2:0] Counter; // Informa em qual estado o processador está (Time Step)
wire [15:0] A_output, RNin;
wire [9:0] IR_output;
wire [10:0] IRin;
wire [7:0] RNout; // Sinal que indica qual registrador terá o dado movido para o Bus
wire Ain, Gin, Gout, DINout; 
wire [2:0] ALUop;
wire Dout_in, Addr_in, W_D, Incr_pc;
wire is_Load; // Sinal indica se a instrução em execução é um Load

//Saída dos registradores R0 a R7.
wire [15:0] G_output, ALU_output;
wire Clear = Done | Reset;
  
//Unidade Counter
Counter C(Clock, Clear, Counter);

// Traduzindo Registradores	
wire [7:0] XXX, YYY;

// Usando DIN para receber dados e instruções
RegUpcode X(DIN[5:3], is_Load, XXX);
RegUpcode Y(DIN[2:0], is_Load, YYY);

// Unidade de Controle   
ControlUnit CU(IR_output, Counter, XXX, YYY, G_output, IRin, RNout, RNin, Ain, Gin, Gout, DINout, ALUop, Done, W_D, Addr_in, Dout_in, Incr_pc, is_Load);

// ULA
ALU alu(A_output, BusWires, ALUop, ALU_output);

//Registradores
RegN A_reg(Clock, Ain, BusWires, A_output);
Reg1 G_reg(Clock, Gin, ALU_output, G_output); // Voltar para regn - Valor: 1
RegIR IR_reg(Clock, Done, IRin, DIN, IR_output);
Reg0 R0(Clock, RNin[0], BusWires, R0_output); // 9
Reg1 R1(Clock, RNin[1], BusWires, R1_output); // 3
Reg2 R2(Clock, RNin[2], BusWires, R2_output); // 1
RegN R3(Clock, RNin[3], BusWires, R3_output);
RegN R4(Clock, RNin[4], BusWires, R4_output);
RegN R5(Clock, RNin[5], BusWires, R5_output);
RegN R6(Clock, RNin[6], BusWires, R6_output);

// PC
RegN_pc R7(BusWires, RNin[7], Clock, Incr_pc, Clear, R7_output);

//ADDR
RegN_addr reg_addr (R7_output, Incr_pc, Clock, Addr_in, BusWires, Addr_output);

//DOUT
RegN reg_dout (Clock, Dout_in, BusWires, Dout_output);

//W_D
RegN_W reg_W (Clock, W_D, W);

// OK!   
// Multiplexador -> RNout, Gout e DINout são os sinais de controle do Mux
always @(RNout, Gout, DINout) begin
	// Concatena os sinais para formar o sinal de SELECT de 10 bits para o Mux identificar qual dado vai pro Bus
	case({RNout,Gout,DINout})
		10'b0000000001: BusWires <= DIN;
		10'b0000000010: BusWires <= G_output;
		10'b0000000100: BusWires <= R0_output;
		10'b0000001000: BusWires <= R1_output;
		10'b0000010000: BusWires <= R2_output;
		10'b0000100000: BusWires <= R3_output;
		10'b0001000000: BusWires <= R4_output;
		10'b0010000000: BusWires <= R5_output;
		10'b0100000000: BusWires <= R6_output;
		10'b1000000000: BusWires = R7_output;
	endcase     
end
    
endmodule

// OK!
module ControlUnit(
	input [9:0] IR,          //Define a instrução executada -> IR[8:6]: Opcode
	input [2:0] Counter,     //Contador para que não ocorra sobreposição de instruções.
	input [7:0] XXX,         //Define o reg XXX da instrução.
	input [7:0] YYY,         //Define o reg XXX da instrução.    
	input [15:0] G_output,   //Define a saída de G.    
	output reg [10:0] IRin,  //Habilita a escrita em IR.    
	output reg [7:0] RNout,  //Define se a saída dos reg R0 a R7 seram utilizados.
	output reg [7:0] RNin,   //Habilita a escrita de dados nos reg R0 a R7.  
	output reg Ain,          //Habilita o uso do registrador A. 
	output reg Gin,          //Habilita o uso do registrador G.
	output reg Gout,
	output reg DINout,       //Define se a próxima IR será uma instrução ou dado da chamada imediata.    
	output reg [2:0] ALUOp,  //Define a operação da ULA.    
	output reg Done,     	 //Informa o término da instrução.
	output reg W_D,
	output reg Addr_in,
	output reg Dout_in,
	output reg Incr_pc,      //Habilita a escrita no reg R7: incremento do PC.
	output reg is_Load
);  

wire[3:0] ADD = 4'b0000, SUB = 4'b0001, OR = 4'b0010, SLT = 4'b0011, SLL = 4'b0100, SRL = 4'b0101, MV = 4'b0110, MVI = 4'b0111, LD = 4'b1000, SD = 4'b1001, MVNZ = 4'b1010; 

initial begin
	is_Load = 1'b0;
end

always @(Counter or IR or XXX or YYY) begin
   //Especificação de valores para todo início de execução de instrução.
	IRin = 1'b0;
	RNout[7:0] = 8'b00000000;
	RNin[7:0] = 8'b00000000;
	DINout = 1'b0;
	Ain = 1'b0;
	Gin = 1'b0;
	Gout = 1'b0;
	Incr_pc = 1'b0;
	Done = 1'b0;
	W_D = 1'b0;
	Addr_in = 1'b0;
	Dout_in = 1'b0;
	 
	case (Counter)
		
		// OPÇÃO 1
		// Habilitar a escrita do valor de PC no ADDR em T0 faz com que ADDR receba o valor de PC 1 ciclo depois do início da execução
	   // e isso iria fazer com que a gente precisasse adiar todas as instruções em 1 Time Step
	
		// OPÇÃO 2
		// Alterar o sinal de ADDR sempre que o PC é incrementado faz com que ADDR e PC tenham sempre o mesmo valor no início de cada
		// execução, ou seja, não é necessário espera 1 ciclo para transferir esse valor
		
		// Time Step 0
		3'b000: begin
			RNout = 8'b10000000;        // Habilita a escrita do valor de PC (Reg7) no Bus
			Addr_in = 1'b1;             // Habilita a escrita em Addr -> Addr receberá o valor de PC
			is_Load = 1'b0;             // Coloca o sinal de LD para 0 no início da execução, caso a última instrução tenha sido um LD
		end
		
		// Time Step 1
		3'b001: begin
			// Aguarda o valor buscado na memória ser retornado para DIN
		end
			
		// Time Step 2
		3'b010: begin
			IRin = 1'b1;
		end
			
		// Time Step 3
		3'b011: begin			
			case (IR[9:6]) 
				ADD, SUB, OR, SLT: begin  // Instrução add, sub, OR, slt
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no reg A
				end
				SLL: begin                // Instrução sll
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no reg A
					ALUOp = 3'b011;        // Define a operação de sll na ULA
				end
				SRL: begin                // Instrução srl
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no reg A
					ALUOp = 3'b111;        // Define a operação de srl na ULA
				end
            MV: begin                 // Instrução mv: XXX recebe o dado contido em YYY
               RNout = YYY;			  // Habilita a retirada do dado do reg YYY
               RNin = XXX;            // Habilita a escrita no reg XXX
            end
				MVNZ: begin
					if (G_output != 16'b0) begin  // Realiza um mv apenas se o conteúdo de G != 0
						RNout = YYY;
						RNin = XXX;
					end
				end
				SD: begin
					RNout = YYY;            // Define o registrador de leitura YYY -> O valor salvo em YYY será a posição de memória acessada (RAM)
					Addr_in = 1'b1;         // Habilita a escrita do endereço de memória a ser acessado no registrador ADDR
				end
				LD: begin
					is_Load = 1'b1;
					RNout = YYY;            // Define o registrador de leitura YYY -> O valor salvo em YYY será a posição de memória acessada (RAM)
					Addr_in = 1'b1;         // Habilita a escrita do endereço de memória a ser acessado no registrador ADDR
				end
			endcase
		end
		
		// Time Step 4
		3'b100: begin
			case (IR[9:6])
				ADD: begin                // Instrução add
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no reg G
					ALUOp = 3'b000;        // Define a operação de add na ULA
				end 
				SUB: begin                // Instrução sub
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no reg G
					ALUOp = 3'b001;        // Define a operação de sub na ULA
				end
				OR: begin                 // Instrução OR
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no reg G
					ALUOp = 3'b010;        // Define a operação de OR na ULA
				end
				SLT: begin                // Instrução slt
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no reg G
					ALUOp = 3'b101;        // Define a operação de slt na ULA
				end
				SLL, SRL: begin           // Instrução sll e srl
					Gin = 1'b1;
					RNout = YYY;
            end
				MV, MVNZ: begin
					Done = 1'b1;           // Define o término da instrução de mv ou mvnz
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				MVI: begin
					RNin = XXX;            // Habilita a escrita no reg XXX
					DINout = 1'b1;
				end
				SD: begin
					RNout = XXX;           // Define o registrador de leitura XXX -> O valor de XXX será salvo na memória
					Dout_in = 1'b1;        // Habilita a escrita no registrador DOUT -> DOUT guarda valores que serão escritos na memória
					W_D = 1'b1;            // Habilita escrita na memória
				end
			endcase
		end
		
		// Time Step 5
		3'b101: begin		
			case (IR[9:6]) 
				ADD, SUB, OR, SLT: begin  // Instrução add, sub, OR, slt
					Gout = 1'b1;           // Define que o dado de escrita é da saída da ULA
					RNin = XXX;            // Habilita a escrita no reg XXX
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				SRL, SLL: begin						
					Gout = 1'b1;           // Define que o dado de escrita é da saída da ULA
					RNin = XXX;
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				MVI: begin
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				SD: begin
					W_D = 1'b0;				  // Desliga o sinal de escrita na memória
					Done = 1'b1;
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
			endcase
		end
		
		// Time Step 6
		3'b110: begin
			case (IR[9:6])
				LD: begin
					DINout = 1'b1;         // DIN vai conter o dado que foi pego na memória
					RNin = XXX;            // Habilita a escrita no reg XXX -> O dado que será escrito está em DIN
					Done = 1'b1;
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
			endcase
		end
		
   endcase        
end

endmodule

// OK!
module RegUpcode(	// Módulo para converter o valor de 3 bits do reg para o sinal de 8 bits que seleciona o respectivo registrador
   input [2:0] reg_input,
	input is_Load,
   output reg[7:0] reg_output
);

always @(reg_input && ~is_Load) begin
	case (reg_input)
		3'b000: reg_output = 8'b00000001; // R0
		3'b001: reg_output = 8'b00000010; // R1
		3'b010: reg_output = 8'b00000100; // R2
		3'b011: reg_output = 8'b00001000; // R3
		3'b100: reg_output = 8'b00010000; // R4
		3'b101: reg_output = 8'b00100000; // R5
		3'b110: reg_output = 8'b01000000; // R6
		3'b111: reg_output = 8'b10000000; // R7
	endcase
end

endmodule

// OK!
module ALU(
   input [15:0] A,
   input [15:0] Bus, 
   input [2:0] ALUop,
   output reg [15:0] ALU_output
);

always @(ALUop, Bus, A) begin
   case(ALUop)
		3'b000: ALU_output <= A + Bus;          //Add
      3'b001: ALU_output <= A - Bus;          //Sub
      3'b010: ALU_output <= (A | Bus);        //OR
      3'b101: ALU_output <= A < Bus ? 1 : 0;  //slt
      3'b011: ALU_output <= A << Bus;         //SLL
      3'b111: ALU_output <= A >> Bus;         //SLR
   endcase  
end
  
endmodule

// OK!
module Counter(
   input Clock,
   input Clear, //Habilita a execução do Counter.
   output reg [2:0] Counter //Contador para que não ocorra sobreposição de instruções.
);

initial begin
	Counter = 3'b000;
end

always @(posedge Clock) begin
	if(Clear) begin
		Counter <= 3'b000;
	end
	else begin
		Counter <= Counter + 3'b001;
	end
end

endmodule

// OK!
module RegN_pc( // O PC (R7) guarda endereços de memória de 5 bits - REVISAR
	input Bus,
	input Rin,
   input Clock,
	input incr,
   input Clear,              // Habilita a execução do Counter
   output reg [15:0] Counter // Contador para que não ocorra sobreposição de instruções
);
	
initial begin
	Counter = 16'b0000000000001010; // PC começa apontando para o posição 10, primeira posição na memória que contém instrução
end
	
always @(posedge Clock) begin

	// Reinicia o PC
   //if(Clear) begin
      //Counter <= 16'b0;
	//end
	
	// Salva um valor no PC
	if (Rin) begin
		Counter <= Bus;
	end
	
	// Incrementa o PC em uma posição
   else if (incr) begin
      Counter <= Counter + 1'b1;
	end
	
end
	
endmodule

// OK!
module RegN(
   input Clock,
   input Rin, //Habilita a escrita de dados no reg RN.
   input [15:0] Bus, //Dado que será salvo em RN.
   output reg[15:0] R_output //Dado de saída de RN.
);  

initial begin
	R_output = 16'b0;
end
	
always @(posedge Clock) begin
	if(Rin) begin
		R_output = Bus;
	end
end

endmodule

// OK!
module Reg0(
   input Clock,
   input Rin, //Habilita a escrita de dados no reg RN.
   input [15:0] Bus, //Dado de escrita em RN.
   output reg [15:0] R_output //Dado de saída de RN.
);  

initial begin
	R_output = 16'b0000_0000_0000_1001;
end
	
always @(posedge Clock) begin
	if(Rin) begin
		R_output = Bus;
	end
end

endmodule

// OK!
module Reg1(
   input Clock,
   input Rin, //Habilita a escrita de dados no reg RN.
   input [15:0] Bus, //Dado de escrita em RN.
   output reg[15:0] R_output //Dado de saída de RN.
);  

initial begin
	R_output = 16'b0000_0000_0000_0011;
end
	
always @(posedge Clock) begin
	if(Rin) begin
		R_output = Bus;
	end
end

endmodule

// OK!
module Reg2(
   input Clock,
   input Rin, //Habilita a escrita de dados no reg RN.
   input [15:0] Bus, //Dado de escrita em RN.
   output reg[15:0] R_output //Dado de saída de RN.
);  
initial begin
	R_output = 16'b0000_0000_0000_0001;
end
	
always @(posedge Clock) begin
	if(Rin) begin
		R_output = Bus;
		end
end

endmodule

// OK!
module RegIR( // Salva os 9 primeiros bits de DIN em IR
   input Clock,
	input Done,
   input Rin, //Habilita a escrita de dados no reg IR.
   input [15:0] DIN, //Dado de escrita em IR.
   output reg [9:0] R_output //Dado de saída de IR.
);

// Deve receber o sinal de DONE para ter seu valor resetado para xxxxxxx sempre que uma instrução é finalizada

always @(posedge Clock) begin

	if(Done) begin
		R_output <= 10'bx;
	end
   
	else if(Rin) begin
		R_output = DIN[9:0];
	end
	
end

endmodule

// OK!
module RegN_addr(
	input pc_output,
	input incr_pc,
   input Clock,
   input Rin, //Habilita a escrita de dados em ADDR (Addr_in)
   input [15:0] Bus, //Dado que será salvo em RN.
   output reg[15:0] R_output //Dado de saída de RN.
);

reg [15:0] pc_value;

initial begin
	R_output = 16'b0000000000001010;
	pc_value = 16'b0000000000001010;
end
	
always @(posedge Clock) begin

	// Uma opção seria colocar o valor de PC em ADDR no negedge, dessa forma o valor chegaria mais cedo à ADDR
	// e talvez não atrase a execução das instruções -> Clock teria que comecar em 1
	
	// Outra opção seria criar uma variável local PC e atribuir o valor dela para a saída de ADDR sempre que
	// o incr_pc for 1

	// Coloca o valor de PC em ADDR sempre que PC é atualizado, ou seja, sempre que uma instrução termina
	if (incr_pc) begin
		pc_value = pc_value + 1'b1;
      R_output <= pc_value;
	end

	
	else if(Rin) begin
		R_output = Bus;
	end
	
end

endmodule

// OK!
module RegN_W(
   input Clock,
   input W_D, // Habilita a escrita de dados em W
   output reg R_output //Dado de saída de RN.
);  

initial begin
	R_output = 1'b0;
end
	
always @(posedge Clock) begin

	if(W_D) begin
		R_output = 1'b1;
	end
	
	else begin
		R_output = 1'b0;
	end
	
end

endmodule



