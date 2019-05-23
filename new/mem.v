`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/09 17:30:40
// Design Name: 
// Module Name: mem
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


module mem(
    input clk,
    input [7:0] memaddr,
    input [7:0] addr,
    input MemWrite,
    input [31:0] Writedata,
    output [31:0] Memdata,
    output [31:0] mem_data
    );
    dist_mem_gen_0 mem0(memaddr,Writedata,addr,clk,MemWrite,Memdata,mem_data);
endmodule
