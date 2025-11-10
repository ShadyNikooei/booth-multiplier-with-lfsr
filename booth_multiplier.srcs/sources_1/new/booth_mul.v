`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/06/2025 06:53:41 PM
// Design Name: 
// Module Name: booth_mul
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
