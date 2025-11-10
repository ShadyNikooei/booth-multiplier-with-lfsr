`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/09/2025 11:23:06 PM
// Design Name: 
// Module Name: lfsr
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module lfsr #(parameter n = 8)(clk,rst,seed,q,rdo);

    input clk,rst;
    input [n-1:0] seed;
    output reg [n-1:0] q;
    output reg rdo;
    integer i=1;

    

    always@(posedge clk)begin
        rdo = q[1]^q[7];
        if(rst)begin
            q <= (seed == {n{1'b0}}) ? {{n-1{1'b0}},1'b1} : seed;
        end

        else begin

            q <= {q[n-2:0],rdo};

        end
        
    end

endmodule
