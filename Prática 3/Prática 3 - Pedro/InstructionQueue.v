module InstructionQueue(
	input clock,
	input reset,
	input stall,
	output reg [2:0] opcode,
	output reg [2:0] RX,
	output reg [2:0] RY,
	output reg [2:0] RZ,
	output reg [3:0] immediate
);

// Memória de Instruções - Matriz 5x16
reg[15:0] InstructionMemory[4:0];

// Contador
reg[2:0] counter;

// Instruções -> Immediate[15:12], Opcode[11:9], RX[8:6], RY[5:3], RZ[2:0]

// Registradores
// R0 -> 000 
// R1 -> 001
// R2 -> 010

// Opcode Instruções
// ADD -> 000
// SUB -> 001
// LD  -> 010
// SD  -> 011 

initial begin

	// Inicializando o Contador
	counter <= 0;
	
	// Inicializando a Memória de Instruções
	InstructionMemory[0] <= 16'b0000000000001010; // ADD R0, R1, R2
	InstructionMemory[1] <= 16'b0000001001000001; // SUB R1, R0, R1
	//InstructionMemory[2] <= 16'b1111111111111111;
	//InstructionMemory[3] <= 16'b1111111111111111;
	//InstructionMemory[4] <= 16'b1111111111111111;
	
end

always @(posedge clock) begin
	
	if (reset == 1'b1 || counter > 3'b101) begin
		
		// Resetando as variáveis
		opcode <= 3'b000;
		RX <= 3'b000;
		RY <= 3'b000;
		RZ <= 3'b000;
		immediate <= 4'b0000;
		counter <= 3'b000;
		
	end
	
	else if (stall == 1'b0) begin
		
		// Existe posição disponível na estação de reserva
		opcode <= InstructionMemory[counter][11:9];
		RX <= InstructionMemory[counter][8:6];
		RY <= InstructionMemory[counter][5:3];
		RZ <= InstructionMemory[counter][2:0];
		immediate <= InstructionMemory[counter][15:12];
		
		// Incrementa o Contador
		counter <= counter + 1'b1;
		
	end
	
	// Uma outra opção seria salvar os valores dos regs em output quando stall == 1
	// e salva os valores da memória no output quando stall == 0
	
end

endmodule
