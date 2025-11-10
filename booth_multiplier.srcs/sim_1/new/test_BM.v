`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 09:22:07 PM
// Design Name: 
// Module Name: test_BM
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


module test_BM;
    
    localparam n = 8;
    
    reg signed [n-1:0] a,b;
    wire [2*n+1:0] result;
    booth_mul #(.n(n)) bm(a, b, result);
   
    initial begin
        a = 'b0;
        b = 'b0;
        repeat(10) begin
            a = $random;
            #10 b = $random;
        end
    end

endmodule
