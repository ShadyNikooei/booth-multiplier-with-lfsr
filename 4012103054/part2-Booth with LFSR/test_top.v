`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 03:25:29 AM
// Design Name: 
// Module Name: test_top
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


module test_top;
    localparam n = 8;
    reg clk = 0;
    reg rst = 1;
    reg [n-1:0] seed1,seed2;
    wire [2*n+1:0] result;

    topM #(.n(n)) topm(clk,rst,seed1,seed2,result);

    always #5 clk = ~clk;

    wire signed [n-1:0] A = $signed(topm.q1);
    wire signed [n-1:0] B = $signed(topm.q2);
    wire signed [2*n+1:0] P = $signed(result);
    
    integer unsigned Nsamples = 100;
    integer unsigned sum_abs_err = 0;
    integer MAE = 0;
    integer signed  ref ,diff;

    initial begin
        seed1 = 8'b01111000;
        seed2 = 8'b11100000;
        repeat (2) @(posedge clk);
        rst = 0;
        
        repeat (Nsamples) begin
            @(posedge clk);
            
            ref  = $signed({{(64-n){A[n-1]}}, A}) * $signed({{(64-n){B[n-1]}}, B});
            diff = ref - P;
            sum_abs_err = sum_abs_err + (diff < 0) ? -diff : diff; 
            
            //repeat (5) @(posedge clk);
        end
        MAE =MAE+ (sum_abs_err /Nsamples);

    end

endmodule
