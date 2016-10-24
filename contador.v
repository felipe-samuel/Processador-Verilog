module contador(
	
	input j1,k1,
	input clock,
	output reg [3:0]saida

);
	
	wire [6:1]q;	
	
	//Instanciando flip-flops JK...
	ffd f1( .j(j1), .k(k1), .clk(clock),.q(q[1]),.q_barra(q[2]));
	ffd f2( .j(j1), .k(k1), .clk(!q[1]),.q(q[3]),.q_barra(q[4]));
	ffd f3( .j(j1), .k(k1), .clk(!q[3]),.q(q[5]),.q_barra(q[6]));

		always@(*)
			begin
				saida[0]=q[1];
				saida[1]=q[3];
				saida[2]=q[5];
				saida[3]=1'b0;
			end
endmodule
