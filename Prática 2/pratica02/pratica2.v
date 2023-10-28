module pratica2 (SW, KEY, HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7, LEDG, LEDR);
	
input [17:0] SW;

// KEY[0] -> Clock
// KEY[1] -> Reset
input [3:0] KEY;

// HEX[3:0] -> BusWires
// HEX[4] 	-> Counter
// HEX[6] 	-> Addr
// HEX[7] 	-> PC 
output [0:6] HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7;

// LEDG[2:0] -> Reg X
// LEDG[7:5] -> Reg Y
output [8:0] LEDG;

// LEDR[17:8] -> IR 
// LEDR[4:2]  -> ALUop
output [17:0] LEDR;

// Sinais do Processador
wire [15:0] DIN;
wire [15:0] bus;
wire [15:0] r0;
wire [15:0] r1;
wire [15:0] r2;
wire [15:0] r3;
wire [15:0] r4;
wire [15:0] r5;
wire [15:0] r6;
wire [15:0] pc;
wire [15:0] addr;
wire [9:0] ir;
wire [2:0] counter;
wire [2:0] aluop;
wire [15:0] DataInMem;
wire done;
wire W;

// Clock
assign clock = KEY[0];

// Reset
assign reset = SW[17];

// Counter
wire [7:0] contador;
assign contador = counter;

// Processador Multiciclo
proc processador(clock /*PClock*/, DIN, reset /*ResetIn*/, r0, r1, r2, r3, r4, r5, r6, pc /*Reg7*/, addr /*Addr_output*/, DataInMem /*Dout_output*/, W /*Wren*/, bus, done, ir /*IR_output*/, counter, aluop);

//Memória RAM
//Posição 0 a 9 => Dados
//Posição 10 a 20 => Instruções
mem_ram mem_data (addr, clock, DataInMem, W, DIN);

// DISPLAYS
disp7seg PC (pc, HEX7);
disp7seg Counter (contador, HEX4);
disp7seg Addr (addr, HEX6);
disp7seg R0 (r0, HEX0);
disp7seg R1 (r1, HEX1);
disp7seg R2 (r2, HEX2);
disp7seg R3 (r3, HEX3);

// LEDG
assign LEDG[7:5] = aluop;

// LEDR
assign LEDR[17:8] = ir;

// Inicializando HEX5 sem valor
assign HEX5 = 7'b1111111;

endmodule


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
	output Done,
	output [9:0] IR_output,
	output [2:0] Counter,
	output [2:0] ALUop
); 
	
wire [15:0] RNin; 			 			// Recebe o sinal que habilita a escrita nos registradores RN
wire [10:0] IRin; 						// Recebe o sinal que habilita a escrita no registrador IR
wire Ain, Gin; 							// Recebe o sinal que habilita a escrita nos registradores A e G
wire Dout_in, Addr_in, W_D; 			// Recebe o sinal que habilita a escrita nos registradores ADDR, DOUT e W
wire Gout; 									// Recebe o sinal que habilita a leitura do registrador G
wire [15:0] A_output; 					// Recebe a saída do registrador A
wire [7:0] RNout; 						// Recebe o sinal que habilita a leitura do registrador RN
wire [15:0] G_output, ALU_output; 	// Recebe a saída do registrador G e da ULA
wire DINout; 								// Recebe o sinal que habilita a leitura de DIN
wire Clear = Reset; 						// Sinal de Clear do PC -> Reinicia o valor de PC
wire Clear_counter = Done; 			// Sinal de Clear do Counter -> Reinicia o valor de Counter
wire Incr_pc; 								// Sinal de incremento do PC
wire is_Load; 								// Sinal que indica se a instrução em execução é um Load
wire is_mvi;                        // Sinal que indica se a instrução em execução é um MVI
  
//Counter
Counter C(Clock, Clear_counter, Counter);

//Atribuindo o valor dos registradores a XXX e YYY
//DIN[5:3] -> RX
//DIN[2:0] -> RY
wire [7:0] XXX, YYY;
RegUpcode X(DIN[5:3], is_Load, is_mvi, XXX);
RegUpcode Y(DIN[2:0], is_Load, is_mvi, YYY);

//Unidade de Controle   
ControlUnit CU(IR_output, Counter, XXX, YYY, G_output, IRin, RNout, RNin, Ain, Gin, Gout, DINout, ALUop, Done, W_D, Addr_in, Dout_in, Incr_pc, is_Load, is_mvi);

//ULA
ALU alu(A_output, BusWires, ALUop, ALU_output);

//Registradores (A, G, IR, R0, R1, R2, R3, R4, R5, R6)
RegN A_reg(Clock, Ain, BusWires, A_output);
RegN G_reg(Clock, Gin, ALU_output, G_output); // Voltar para regn - Valor: 1
RegIR IR_reg(Clock, Done, IRin, DIN, IR_output);
RegN R0(Clock, RNin[0], BusWires, R0_output); // 9
RegN R1(Clock, RNin[1], BusWires, R1_output); // 3
RegN R2(Clock, RNin[2], BusWires, R2_output); // 1
RegN R3(Clock, RNin[3], BusWires, R3_output);
RegN R4(Clock, RNin[4], BusWires, R4_output);
RegN R5(Clock, RNin[5], BusWires, R5_output);
RegN R6(Clock, RNin[6], BusWires, R6_output);

RegN_pc R7(BusWires, RNin[7], Clock, Incr_pc, Clear, R7_output);

//ADDR
RegN_addr reg_addr (R7_output, Incr_pc, Clock, Addr_in, BusWires, Addr_output);

//DOUT
RegN reg_dout (Clock, Dout_in, BusWires, Dout_output);

//W_D
RegN_W reg_W (Clock, W_D, W);

//Multiplexador
always @(RNout, Gout, DINout) begin
	// Concatena os sinais para formar o sinal de SELECT de 10 bits para o Mux identificar qual dado vai pro Bus
	// RNout, Gout e DINout são os sinais de controle do Mux
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
	output reg is_Load,
	output reg is_mvi,
	output reg write_pc
);  

wire[3:0] ADD = 4'b0000, SUB = 4'b0001, OR = 4'b0010, SLT = 4'b0011, SLL = 4'b0100, SRL = 4'b0101, MV = 4'b0110, MVI = 4'b0111, LD = 4'b1000, SD = 4'b1001, MVNZ = 4'b1010; 

// Variável reg usada para salvar o valor do registrador onde será salvo o dado da instrução LOAD
// Essa variável foi criada apenas para facilitar o funcionamento na FPGA, uma vez que o sinal do registrador de destino estava sendo perdido
reg [7:0] r_dest;

initial begin
	// Sinal para controlar se a instrução em questão é ou não um load ou um MVI
	// Esse sinal foi criado para evitar que o valor dos registradores XXX e YYY sejam alterados quando a instrução de load ou MVI carregar um dado em DIN
	is_Load = 1'b0;
	is_mvi = 1'b0;
	r_dest = 8'b0;
end

always @(Counter or IR or XXX or YYY) begin
   
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
		
		// Time Step 0
		3'b000: begin
			RNout = 8'b10000000;         // Habilita a escrita do valor de PC (Reg7) no Bus
			Addr_in = 1'b1;              // Habilita a escrita em Addr -> Addr receberá o valor de PC
			is_Load = 1'b0;              // Coloca o sinal de LD para 0 no início da execução, caso a última instrução tenha sido um LD
			is_mvi = 1'b0;               // Coloca o sinal de MVI para 0 no início da execução, caso a última instrução tenha sido um MVI
			ALUOp = 3'b0;					  // Limpa o sinal de operação da ULA para evitar operações indesejadas
			r_dest = 8'b0;					  // Limpa r_dest
		end
		
		// Time Step 1
		3'b001: begin
			// Aguarda o valor buscado na memória ser retornado para DIN
		end
			
		// Time Step 2
		3'b010: begin
			IRin = 1'b1;                 // Habilita a escrita em IR -> IR recebe os dados referente a instrução atual
		end
		
			
		// Time Step 3
		3'b011: begin			
			case (IR[9:6]) 
				ADD, SUB, OR, SLT: begin  // Instrução add, sub, or, slt
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no registrador A
				end
				SLL: begin                // Instrução sll
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no registrador A
					ALUOp = 3'b011;        // Define a operação de sll na ULA
				end
				SRL: begin                // Instrução srl
					RNout = XXX;           // Define o registrador de leitura XXX
					Ain = 1'b1;            // Habilita a escrita no registrador A
					ALUOp = 3'b111;        // Define a operação de srl na ULA
				end
            MV: begin                 // Instrução mv
               RNout = YYY;			  // Habilita a retirada do dado do registrador YYY
               RNin = XXX;            // Habilita a escrita no registrador XXX
            end
				MVI: begin
				   r_dest = XXX;
					Incr_pc = 1'b1;        // Incrementa o PC para buscar o imediato que está na posição subsequente da memória
					is_mvi = 1'b1;         // Habilita o sinal que indica que a instrução é um MVI
				end
				MVNZ: begin
					if (G_output != 16'b0) begin  // Realiza um mv apenas se o conteúdo de G != 0
						RNout = YYY;
						RNin = XXX;
					end
				end
				SD: begin
					RNout = YYY;           // Define o registrador de leitura YYY -> O valor salvo em YYY será a posição de memória acessada
					Addr_in = 1'b1;        // Habilita a escrita do endereço de memória a ser acessado no registrador ADDR
				end
				LD: begin
					is_Load = 1'b1;        // Habilita o sinal que indica que a instrução é um load
					RNout = YYY;           // Define o registrador de leitura YYY -> O valor salvo em YYY será a posição de memória acessada
					Addr_in = 1'b1;        // Habilita a escrita do endereço de memória a ser acessado no registrador ADDR
				end
			endcase
		end
		
		// Time Step 4
		3'b100: begin
			case (IR[9:6])
				ADD: begin                // Instrução add
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no registrador G
					ALUOp = 3'b000;        // Define a operação de add na ULA
				end 
				SUB: begin                // Instrução sub
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no registrador G
					ALUOp = 3'b001;        // Define a operação de sub na ULA
				end
				OR: begin                 // Instrução or
					RNout = YYY;           // Define o registrador de leitura YYY
					Gin = 1'b1;            // Habilita a escrita no registrador G
					ALUOp = 3'b010;        // Define a operação de or na ULA
				end
				SLT: begin                // Instrução slt
					Gin = 1'b1;            // Habilita a escrita no registrador G
					RNout = YYY;           // Define o registrador de leitura YYY
					ALUOp = 3'b101;        // Define a operação de slt na ULA
				end
				SLL: begin           // Instrução sll e srl
					Gin = 1'b1;            // Habilita a escrita no registrador G
					RNout = YYY;           // Define o registrador de leitura YYY
					ALUOp = 3'b011;
            end
				SRL: begin           // Instrução sll e srl
					Gin = 1'b1;            // Habilita a escrita no registrador G
					RNout = YYY;           // Define o registrador de leitura YYY
					ALUOp = 3'b111;        // Define a operação de srl na ULA
            end
				MV: begin
					Done = 1'b1;           // Define o término da instrução de mv ou mvnz
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				MVNZ: begin
					Done = 1'b1;           // Define o término da instrução de mv ou mvnz
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				SD: begin
					RNout = XXX;           // Define o registrador de leitura XXX -> O valor de XXX será salvo na memória
					Dout_in = 1'b1;        // Habilita a escrita no registrador DOUT -> DOUT recebe o valor de XXX para salvar na memória
					W_D = 1'b1;            // Habilita escrita na memória (wren)
				end
				LD: begin
					is_Load = 1'b1;        // Habilita o sinal que indica que a instrução é um load
					r_dest = XXX;          // Salva o registrador de destino em r_dest
				end
			endcase
		end
		
		// Time Step 5
		3'b101: begin		
			case (IR[9:6]) 
				ADD, SUB, OR, SLT: begin  // Instrução add, sub, or, slt
					Gout = 1'b1;           // Define que o dado de escrita é da saída da ULA
					RNin = XXX;            // Habilita a escrita no registrador XXX
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				SRL, SLL: begin						
					Gout = 1'b1;           // Define que o dado de escrita é da saída da ULA
					RNin = XXX;            // Habilita a escrita no registrador XXX
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				LD: begin
					is_Load = 1'b1;        // Habilita o sinal que indica que a instrução é um load
				end
			endcase
		end
		
		// Time Step 6
		3'b110: begin
			case (IR[9:6])
				LD: begin
					is_Load = 1'b1;        // Habilita o sinal que indica que a instrução é um load
					RNin = r_dest;         // Habilita a escrita no reg XXX salvo em r_dest -> O dado que será escrito em XXX foi retornado da memória para DIN
					DINout = 1'b1;         // DIN vai conter o dado que foi pego na memória
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				SD: begin
					W_D = 1'b0;				  // Desliga o sinal de escrita na memória
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
				MVI: begin
					RNin = r_dest;            // Habilita a escrita no registrador XXX
					DINout = 1'b1;         // Habilita a leitura dos dados de DIN (Imediato)
				end
			endcase
		end
		
		// Time Step 7
		3'b111: begin
			case (IR[9:6])
				MVI: begin
					Done = 1'b1;           // Define o término da instrução
					Incr_pc = 1'b1;        // Finaliza a instrução e incrementa PC
				end
			endcase
		end
		
   endcase        
end

endmodule

module RegUpcode(
   input [2:0] reg_input, // Bits de DIN que indicam os registradores
	input is_Load, // Sinal para checar se a instrução em execução é ou não um load ou um MVI
	input is_mvi,  // Caso a instrução em execução seja um load ou MVI, a atualização de registradores não acontece quando um dado é colocado em DIN
						// Pois DIN irá receber dados que não dizem respeito a instruções, ou seja, dados que são apenas valores imediatos
   output reg[7:0] reg_output
);

always @(reg_input && ~is_Load && ~is_mvi) begin
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

module Counter(
   input Clock,
   input Clear,
   output reg [2:0] Counter
);

initial begin
	Counter = 3'b000;
end

always @(posedge Clock) begin

	// O Counter é reinicializado após o fim de cada instrução
	if(Clear) begin
		Counter <= 3'b000;
	end
	
	else begin
		Counter <= Counter + 3'b001;
	end
	
end

endmodule

module RegN_pc(
	input Bus,
	input Rin, // Sinal que habilita a escrita de dados no PC
   input Clock,
	input incr, // Sinal que permite o incremento do PC
   input Clear, // Sinal que habilita a reinicialização do PC
   output reg [15:0] PC_output
);
	
initial begin
	PC_output = 16'b0000000000001010; // PC começa apontando para o posição 10, primeira posição na memória que contém instrução
end
	
always @(posedge Clock) begin

	// Reinicia o PC sempre que uma instrução é finalizada
   if(Clear) begin
      PC_output = 16'b0000000000001010;
	end
	
	// Salva um valor no PC
	else if (Rin) begin
		PC_output = Bus;
	end
	
	// Incrementa o PC em uma posição
	else if (incr) begin
		PC_output = PC_output + 1'b1;
	end
	
	
end
	
endmodule

module RegN(
   input Clock,
   input Rin, // Sinal que habilita a escrita de dados em RN
   input [15:0] Bus,
   output reg[15:0] R_output
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

module RegIR(
   input Clock,
	input Done,
   input Rin, // Sina que habilita a escrita de dados em IR (IR_in)
   input [15:0] DIN, // O dado escrito em IR é proveniente de DIN
   output reg [9:0] R_output
);


always @(posedge Clock) begin

	// Ao final da execução de cada instrução o IR é resetado e se prepara para receber a próxima instrução
	if(Done) begin
		R_output <= 10'bx;
	end
   
	else if(Rin) begin
		R_output = DIN[9:0];
	end
	
end

endmodule

module RegN_addr(
	input pc_output,
	input incr_pc,
   input Clock,
   input Rin, // Sinal que habilita a escrita de dados em ADDR (Addr_in)
   input [15:0] Bus,
   output reg[15:0] R_output
);

reg [15:0] pc_value; // Variável usada para salvar o valor de PC localmente e facilitar a atualização de ADDR

initial begin
	R_output = 16'b0000000000001010;
	pc_value = 16'b0000000000001010;
end
	
always @(posedge Clock) begin

	// Coloca o valor de PC em ADDR sempre que PC é atualizado, ou seja, sempre que uma instrução termina
	// Para isso utiliza a variável pc_value
	if (incr_pc) begin
		pc_value = pc_value + 1'b1;
      R_output <= pc_value;
	end

	else if(Rin) begin
		R_output = Bus;
	end
	
end

endmodule

module RegN_W(
   input Clock,
   input W_D, // Sinal que habilita a escrita de dados em W
   output reg R_output
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



