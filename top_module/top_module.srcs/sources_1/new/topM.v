`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/10/2025 03:14:15 AM
// Design Name: 
// Module Name: topM
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


module topM #(parameter n=8)(clk,rst,seed1,seed2,result);
    input clk,rst;
    input [n-1:0] seed1,seed2;
    output [2*n+1:0] result;
    wire [n-1:0]q1,q2;
    wire rdo1,rdo2;
    generate
        lfsr #(.n(n)) num_1(clk,rst,seed1,q1,rdo1);
        lfsr #(.n(n)) num_2(clk,rst,seed2,q2,rdo2);

        booth_mul #(.n(n)) b_res(q1, q2, result);
    endgenerate
endmodule

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

module booth_mul #(parameter n = 6)(num_1, num_2, result);
     
    input signed [n-1:0] num_1, num_2;
    output reg signed [2*n+1:0] result;

    reg signed [n-1:0] a;
    reg signed [n:0] b;

    reg signed [2*n+1:0] parshal_pr;
    reg [2:0] part_sel;
    integer i = 0;
    always@(num_1,num_2) begin
        a = num_1;
        b = {num_2[n-1], num_2, 1'b0};
        parshal_pr = 0;
        part_sel = 0;
        for(i=0; i<n-2 ; i = i+2)begin
            part_sel = {b[i+2], b[i+1], b[i]};
            case (part_sel)
                3'b000, 3'b111: parshal_pr = parshal_pr + 0; // 0
                3'b001, 3'b010: parshal_pr = parshal_pr + a; // +A
                3'b011:         parshal_pr = parshal_pr + (a <<1); // +2A
                3'b100:         parshal_pr = parshal_pr -(a <<1); // -2A
                3'b101, 3'b110: parshal_pr = parshal_pr -a; // -A
                default parshal_pr = parshal_pr;
            endcase

            parshal_pr = parshal_pr<<2;            

        end
        result = parshal_pr;
    end


endmodule
