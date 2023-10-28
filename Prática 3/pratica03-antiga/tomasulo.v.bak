module tomasulo(clk,registrador0,registrador1,registrador2,registrador3,registrador4,registrador5);
		input clk; 
		integer i;	
		wire [20:0]Tempo; // Contador PC
		reg breakLoop; // Sinal para parar o loop contido na estaçao
		reg [20:0]minTempo; // Reserva o index referente instruçao
		reg primeiraIntrucao; // Verifica se é a primeira instruçao
		output reg [8:0]registrador0,registrador1,registrador2,registrador3,registrador4,registrador5; // registradores 
		
		wire [11:0]instrucao; // instruçao lida
		wire [2:0]inZ,inX,inY,inI; // endereço de cada registrador
		assign inZ = instrucao[11:9];
		assign inX = instrucao[8:6];
		assign inY = instrucao[5:3];
		assign inI = instrucao[2:0];
	
		reg [2:0]controleSomSub; // Controle para verificar se a estaçao está cheia = 3

		wire doneSomSub; // Verifica se uma instruçao de Soma ou Subtraçao terminou de ser executada

		reg RUNSomSub; // Sinal que ativa a operação de soma ou subtraçao
		reg [2:0] opSomSub; // Reserva o opcode da instruçao de soma/sub
		reg [2:0] inX_SomSub; // reserva o endereço do registrador que irá receber o valor resultante da operaçao de soma/sub
		reg [2:0] InLabelSomSub; // entrada do index da estaçao (i)
		wire [2:0] enderecoX; // Endereço do registrador que sera salvo o resultado da operaçao no tempo correto
		wire [2:0] labelSomSub; // saida do index da estaçao (i) 
		reg [8:0]regX,regY,regZ;// Registradores no momento de cada instruçao
		wire [8:0]resultadoSomSub; // armazena o resultado da operaçao de soma/sub

	//Variaveis para controle do registrador
		wire [8:0]rotuloEstacao[6:0]; // index da estaçao referente ao registrador no tempo correto
		wire [8:0]Regs[6:0]; // valor do registrador no tempo correto
		reg newDataControl[6:0]; // sinal para realizar a atualização do dado no registrador
		reg newLabelControl[6:0];// sinal para realizar a atualização do endereço no registrador
		reg [8:0]newLabel; // index da estaçao
		reg [8:0]newData; // valor que irá ser enviado para registrador no tempo correto
		
	
	//Variaveis da estação de reserva
		reg estadoOcupado[5:0]; // estado ocupado na estaçao reserva
		reg [8:0]ValueX[5:0]; // valores do registrador X
		reg [8:0]ValueJ[5:0];// valores do registrador Y
		reg [8:0]ValueZ[5:0];// valores do registrador Z
		reg [8:0]rotuloEstacaoX[5:0];
		reg [8:0]rotuloEstacaoJ[5:0];	
		reg [8:0]rotuloEstacaoZ[5:0];	
		reg [11:0]reservaInstrucao[5:0];
		reg executa[5:0];
		reg [20:0]tempoCorreto[5:0];
	
		parameter SOM = 3'b000;
		parameter SUB = 3'b001;
	
		initial begin
			tempoCorreto[labelSomSub]=21'b11111111111111111111; 
			controleSomSub = 0;
			primeiraIntrucao = 1;
			RUNSomSub = 0;
			breakLoop = 0;
			reservaInstrucao[0] = instrucao;
			for(i = 0; i <= 6; i = i + 1) begin
				newLabelControl[i] = 0;
				newDataControl[i] = 0;
			end
			for(i = 0; i <= 5; i = i + 1) begin
				estadoOcupado[i] = 0;
				executa[i] = 0;
			end
		end
	
		always @(clk) begin
			breakLoop = 0;
			for(i = 0; i <= 6; i = i + 1) begin
				newLabelControl[i] = 0;
				newDataControl[i] = 0;
			end
			@(posedge clk) begin
			
			registrador0=Regs[0];
			registrador1=Regs[1];
			registrador2=Regs[2];
			registrador3=Regs[3];
			registrador4=Regs[4];
			registrador5=Regs[5];

		// Estação de reserva Soma/sub
			if(controleSomSub != 3 && (inI == SOM || inI == SUB)) begin
			//Passa  por toda a estação 0-3
				for(i = 0; i <= 2 && breakLoop != 1; i = i + 1) begin 
					if(estadoOcupado[i] == 0) begin
							estadoOcupado[i] = 1;
							executa[i] = 0;
							reservaInstrucao[i] = instrucao;
							tempoCorreto[i] = Tempo;
							if(rotuloEstacao[inX] == 9'b111111111) begin // 
									ValueX[i] = Regs[inX];
									rotuloEstacaoX[i] = 9'b111111111;
							end
							else begin
									rotuloEstacaoX[i] = rotuloEstacao[inX]; 
									ValueX[i] = 9'b111111111;
							end
							if(rotuloEstacao[inY] == 9'b111111111) begin
									ValueJ[i] = Regs[inY];
									rotuloEstacaoJ[i] = 9'b111111111;
							end
							else begin
									rotuloEstacaoJ[i] = rotuloEstacao[inY]; 
									ValueJ[i] = 9'b111111111;
							end
							if(rotuloEstacao[inZ] == 9'b111111111) begin
									ValueZ[i] = Regs[inZ];
									rotuloEstacaoZ[i] = 9'b111111111;
							end
							else begin
									rotuloEstacaoZ[i] = rotuloEstacao[inZ]; 
									ValueZ[i] = 9'b111111111;
							end
							newLabel = i;
							newLabelControl[inX] = 1;
							controleSomSub = controleSomSub + 1;
							breakLoop = 1; // Variavel para parar de percorrer
					end
				end //end for
			end //end if
			breakLoop = 0;	
			end //end Always
			
				// tratamento do done da instruçao de soma e subtraçao
				if(doneSomSub | (primeiraIntrucao) | ~RUNSomSub)begin
					minTempo = 9'b111111111;
					if(doneSomSub) begin
						RUNSomSub = 0;
						newData = resultadoSomSub;
						newDataControl[enderecoX] = 1;
						estadoOcupado[labelSomSub] = 0;
						if((enderecoX != inX) && (rotuloEstacao[enderecoX] == labelSomSub))begin
							wait( newLabelControl[0] || newLabelControl[1] || newLabelControl[2]|| newLabelControl[3]|| newLabelControl[4]|| newLabelControl[5]|| newLabelControl[6] == 0) #1  newLabelControl[enderecoX] = 1;
							newLabel = 9'b111111111;
						end

						if(controleSomSub != 0 && doneSomSub) begin
							controleSomSub = 0;
						end
											
						for(i = 0; i <= 5; i = i + 1) begin	
							if(rotuloEstacaoX[i] == labelSomSub) begin
								rotuloEstacaoX[i] = 9'b111111111;
								ValueX[i] = resultadoSomSub;  
							end
							if(rotuloEstacaoJ[i] == labelSomSub) begin
								rotuloEstacaoJ[i] = 9'b111111111;
								ValueJ[i] = resultadoSomSub; 
							end
							if(rotuloEstacaoZ[i] == labelSomSub) begin
								rotuloEstacaoZ[i] = 9'b111111111;
								ValueZ[i] = resultadoSomSub; 
							end
						end
					end // endif if(doneSomSub) begin - linha 327

					for(i = 0; i <= 2; i = i + 1) begin
						if(executa[i] == 0 && ((ValueX[i] != 9'b111111111) && (ValueJ[i] != 9'b111111111))) begin
							if(minTempo == 9'b111111111) begin
								minTempo = i;
							end
							else if(tempoCorreto[minTempo] > tempoCorreto[i])begin
								minTempo = i; 
							end
						end
					end
					if(minTempo != 9'b111111111) begin
						primeiraIntrucao = 0;
						executa[minTempo] = 1;
						opSomSub = reservaInstrucao[minTempo][2:0];
						regY = ValueJ[minTempo];
						regX = ValueX[minTempo];
						regZ = ValueZ[minTempo];
						inX_SomSub = reservaInstrucao[minTempo][8:6];
						InLabelSomSub = minTempo;
						RUNSomSub = 1;
					end
				end // if if(doneSomSub | (primeiraIntrucao) | ~RUNSomSub)begin - linha 325
		end

	registrador1 reg0(clk,newData,newDataControl[0],newLabel,newLabelControl[0],rotuloEstacao[0],Regs[0]);
	registrador1 reg1(clk,newData,newDataControl[1],newLabel,newLabelControl[1],rotuloEstacao[1],Regs[1]);
	registrador1 reg2(clk,newData,newDataControl[2],newLabel,newLabelControl[2],rotuloEstacao[2],Regs[2]);
	registrador2 reg3(clk,newData,newDataControl[3],newLabel,newLabelControl[3],rotuloEstacao[3],Regs[3]);
	registrador0 reg4(clk,newData,newDataControl[4],newLabel,newLabelControl[4],rotuloEstacao[4],Regs[4]);
	registrador1 reg5(clk,newData,newDataControl[5],newLabel,newLabelControl[5],rotuloEstacao[5],Regs[5]);
	count PC(clk,Tempo);
	SomSub UF_SomSub(clk,RUNSomSub,regX,regY,regZ,opSomSub,resultadoSomSub,doneSomSub,inX_SomSub,InLabelSomSub,enderecoX,labelSomSub);
	FilaInstrucoes instrucoes(clk,0,instrucao,controleSomSub);
	
endmodule 