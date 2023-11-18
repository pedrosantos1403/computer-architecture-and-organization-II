module mesi_state_machine (

	input clock,
	input reset,
	
	// Entrada que controla se o bloco é ouvinte ou se o bloco vai executar a instrução
	// 0 -> Ouvinte
	// 1 -> Executa a instrução
	input listener_or_executer,
	
	// Entrada que controla o estado atual do bloco
	input [1:0] state,
	
	// Transição Simulada
	input [2:0] transition,
	
	output reg [1:0] bus,
	output reg write_back,
	output reg [1:0] new_state
	
);

// Estados
// I -> 00 (0)
// S -> 01 (1)
// E -> 10 (2)
// M -> 11 (3)

// Sinais do BUS
// 00 -> Read Miss  - Pode acontecer sozinho ou junto de um Write Back
// 01 -> Write Miss - Pode acontecer sozinho ou junto de um Write Back
// 10 -> Invalidate

// Transições
// 000 -> Read Miss Shared
// 110 -> Read Miss Exclusive
// 001 -> Read Hit
// 010 -> Write Miss
// 011 -> Write Hit
// 100 -> Invalidate - Usado apenas para simular blocos ouvintes

// Inicializar Variáveis
initial begin

	write_back = 1'b0;
	bus = 2'b11;
	new_state = 2'b11;
	
end

always @(posedge clock) begin

	// Reset
	if (reset) begin
		write_back = 1'b0;
		bus = 2'b11;
		new_state = 2'b11;
	end

	// Bloco Ouvinte
	if (listener_or_executer == 1'b0) begin
	
		case (state)
			
			// Invalid
			2'b00: begin
				// Um ouvinte que está no estado Invalid se mantém no estado Invalid independente da transição
				new_state = state;
			end
			
			// Shared
			2'b01: begin
			
				case (transition)
					
					// READ MISS -> Estado se mantém Shared
					3'b000: begin
						new_state = state;
					end
					
					// INVALIDATE -> Estado é alterado para Invalid
					3'b100: begin
						new_state = 2'b00;
					end
					
					// WRITE MISS -> Estado é alterado para Invalid
					3'b010: begin
						new_state = 2'b00;
					end
					
				endcase
			end
			
			// Exclusive
			2'b10: begin
			
				case (transition)
				
					// READ MISS -> Estado é alterado para Shared
					3'b000: begin
						new_state = 2'b01;
					end
					
					// WRITE MISS -> Estado é alterado para Invalid
					3'b010: begin
						new_state = 2'b00;
					end
					
					// OBS: O estado Exclusive como ouvinte nunca recebe a transicao INVALIDATE, pois essa transicao só é colocada no BUS quando ocorre um Write Hit
					// e caso o Exclusive seja ouvinte, nunca poderá ocorrer um Write Hit.
					
				endcase
				
			end
			
			// Modified
			2'b11: begin
			
				case (transition)
					
					// READ MISS -> Estado é alterado para Shared e ocorre Write Back
					3'b000: begin
						new_state = 2'b01;
						write_back = 1'b1;
					end
					
					// WRITE MISS -> Estado é alterado para Invalid e ocorre Write Back
					3'b010: begin
						new_state = 2'b00;
						write_back = 1'b1;
					end
					
				endcase
				
			end
			
		endcase
		
	end

	// Bloco Emissor
	if (listener_or_executer == 1'b1) begin
	
		case (state)
			
			// Invalid
			2'b00: begin
			
				case (transition)
				
					// READ MISS (SHARED) -> Bus recebe a mensagem de Read Miss e o estado é alterado para Shared - OK!
					3'b000: begin
						bus = 2'b00;
						new_state = 2'b01;	
					end
					
					// READ MISS (EXCLUSIVE) -> Bus recebe a mensagem de Read Miss e o estado é alterado para Exclusive - OK!
					3'b110: begin
						bus = 2'b00;
						new_state = 2'b10;	
					end
					
					// WRITE MISS -> Bus recebe a mensagem de Write Miss e o estado é alterado para Modified - OK!
					3'b010: begin
						bus = 2'b01;
						new_state = 2'b11;
					end
					
				endcase
				
			end
			
			// Shared
			2'b01: begin
			
				case (transition)
				
					// READ MISS (SHARED) -> Bus recebe Read Miss e o estado se mantém shared
					3'b000: begin
						bus = 2'b00;
						new_state = state;
					end
					
					// READ HIT -> Não escreve no Bus e o estado se mantém shared
					3'b001: begin
						new_state = state;
					end
					
					// WRITE MISS -> Bus recebe Write Miss e estado é alterado para Modified
					3'b010: begin
						bus = 2'b01;
						new_state = 2'b11;
					end
					
					// WRITE HIT -> Bus recebe Invalidate e estado é alterado para Modified
					3'b011: begin
						bus = 2'b10;
						new_state = 2'b11;
					end
					
				endcase
				
			end
			
			// Exclusive - REVISAR!
			2'b10: begin
			
				case (transition)
				
					// READ HIT -> Não escreve no Bus e o estado se mantém Exclusive
					3'b001: begin
						new_state = state;
					end
					
					// WRITE HIT -> Não escreve no Bus e o estado é alterado para Modified
					3'b110: begin
						new_state = 2'b11;
					end
					
					// READ MISS (Exclusive) -> Não escreve no Bus e o estado é alterado para Shared
					3'b110: begin
						new_state = 2'b01;
					end
					
					// WRITE MISS -> Bus recebe Write Miss e o estado é alterado para Modified
					3'b010: begin
						bus = 3'b001;
						new_state = 2'b11;
					end
					
				endcase
				
			end
			
			// Modified
			2'b11: begin
			
				case (transition)
				
					// READ HIT -> Não escreve no Bus e o estado se mantém Modified
					3'b001: begin
						new_state = state;
					end
					
					// WRITE HIT -> Não escreve no Bus e o estado se mantém Modified
					3'b011: begin
						new_state = state;
					end
					
					// READ MISS (SHARED) -> Bus recebe Read Miss, o estado é alterado para Shared, e ocorre Write Back
					3'b000: begin
						bus = 3'b000;
						new_state = 2'b01;
						write_back = 1'b1;
					end
					
					// WRITE MISS -> Bus recebe Write Miss, o estado se mantém Modified, e ocorre Write Back - REVISAR!
					3'b010: begin
						bus = 3'b001;
						new_state = state;
						write_back = 1'b1;
					end
					
					
					
				endcase
				
			end
			
			
		endcase
		
	end

end

	
endmodule










