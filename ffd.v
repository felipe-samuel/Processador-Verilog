module ffd(
input j,k,
input clk,
output reg q,q_barra
);
	initial
		begin
		    q=1'b0;
			 q_barra=1'b1;
		end
		
always@(posedge clk)
		begin
			case({j,k})
				{1'b0,1'b0}:
					begin
					   q=q;
						q_barra=q_barra;
					end
				{1'b0,1'b1}:
					begin 
						q=0;
						q_barra=1; 
					end
				{1'b1,1'b0}:
					begin
						q=1;
						q_barra=0;
					end
				{1'b1,1'b1}:
					begin
						q=~q;
						q_barra=~q_barra;
					end
			endcase						
		end
		
endmodule
