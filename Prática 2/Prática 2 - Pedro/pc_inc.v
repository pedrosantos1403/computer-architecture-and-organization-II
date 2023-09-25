//Similar ao módulo regn porém para incrementar ou alterar o valor de PC (R7)

 module regn_pc(R, Rin, Clock, Q, inc);
 parameter n = 16;
 input [n-1:0] R;
 input Rin, Clock, inc;
 output reg [n-1:0] Q;
 
 initial begin 
	Q<=16'b0000000010000000;
 end
 
 always @(posedge Clock)
 begin
if (Rin)
   Q <= R;
  else if(inc)
   Q <= Q + 1'b1;
 end
endmodule