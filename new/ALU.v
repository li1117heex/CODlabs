`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/03/20 16:55:58
// Design Name: 
// Module Name: ALU
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


module ALU #(parameter MSB=32)(
    input [MSB-1:0] in1,
    input [MSB-1:0] in2,
    input [3:0] s,
    output reg [MSB-1:0] out,
    output reg [2:0] f
    );
    always @ *
    begin
    f=3'b000;
        case (s)
        4'b0000: 
        begin 
        {f[2],out}<=in1+in2;
        end
        
        4'b0001:
        begin
        {f[2],out}<=in1-in2;
        end
        
        4'b0010:
        begin
        out=in1+in2;
        f[1]=(in1[MSB-1]&in2[MSB-1]&~out[MSB-1])|(~in1[MSB-1]&~in2[MSB-1]&out[MSB-1]);
        end
        
        4'b0011:
        begin
        out<=in1-in2;
        f[1]<=(~in1[MSB-1]&in2[MSB-1]&out[MSB-1])|(in1[MSB-1]&~in2[MSB-1]&~out[MSB-1]);
        end
        
        4'b0100:out=in1&in2;
        
        4'b0101:out=in1|in2;
               
        4'b0110:out=in1^in2;
                      
        4'b0111:out=~(in1|in2);
        
        4'b1000:begin
            if($signed(in1)<$signed(in2)) out=32'b00000000000000000000000000000001;
            else out=32'b0;
        end
    
        default:out=0;
         endcase
         f[0]=~|out;
         end
endmodule
