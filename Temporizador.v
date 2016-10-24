module Temporizador(
input clkf,
output reg saidaq
);

  parameter jf = 1'b1,kf = 1'b1;
  
	wire [3:0]v1;
	wire [3:0]v2;
	wire [3:0]v3;
	wire [3:0]v4;
	wire [3:0]v5;
	wire [3:0]v6;
	wire [3:0]v7;
	wire [3:0]v8;
	wire [3:0]v9;
	
  //sera o numero de contadores no temporizador da maquina de estado anterior +1...
  contador c1(jf,kf,clkf,v1);
  contador c2(jf,kf,v1[2],v2);
  contador c3(jf,kf,v2[2],v3);
  contador c4(jf,kf,v3[2],v4);
  contador c5(jf,kf,v4[2],v5);
  contador c6(jf,kf,v5[2],v6);
  contador c7(jf,kf,v6[2],v7);
  contador c8(jf,kf,v7[2],v8);


  always@(*)
		begin
			saidaq = v3[1];
		end

endmodule
