`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 02:24:23 AM
// Design Name: 
// Module Name: test_lfsr
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


module test_lfsr;

    localparam n = 8;

    reg clk=0;
    reg rst=1;
    reg [n-1:0] seed;
    
    wire [n-1:0] q;
    wire rdo;

    lfsr #(.n(n)) tslfsr(.clk(clk),.rst(rst),.seed(seed),.q(q),.rdo(rdo));

    always # 5 clk= ~clk;

    initial begin
        seed = 8'b10001010;
       
        repeat (2) @(posedge clk);
        rst = 0;
        
        repeat (20) @(posedge clk);   
        $finish;    
     end 

endmodule
