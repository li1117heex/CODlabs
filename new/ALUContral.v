`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/07 22:55:13
// Design Name: 
// Module Name: ALUContral
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


module ALUContral(
    input [5:0] IRop,
    input [5:0] funct,
    input [1:0] ALUOp,
    output reg [3:0] Op
    );
    always @ *
    begin
        case(ALUOp)
            2'b00:Op=4'b0000;
            2'b01:Op=4'b0001;
            2'b10:
                case(funct)
                    6'b100000:Op=4'b0010;
                    6'b100010:Op=4'b0011;
                    6'b100100:Op=4'b0100;
                    6'b100101:Op=4'b0101;
                    6'b100110:Op=4'b0110;
                    6'b100111:Op=4'b0111;
                    6'b101010:Op=4'b1000;
                    default:Op=4'b0000;
                endcase
            2'b11:
                case(IRop)
                    6'b001000:Op=4'b0010;
                    6'b001100:Op=4'b0100;
                    6'b001101:Op=4'b0101;
                    6'b001110:Op=4'b0110;
                    6'b001010:Op=4'b1000;
                    default:Op=4'b0000;
                endcase
        endcase
    end
endmodule
