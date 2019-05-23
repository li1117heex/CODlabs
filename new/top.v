`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/05/06 13:11:16
// Design Name:
// Module Name: top
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


module top(
    input clk,
    input rst,
    input run,
    input [7:0] addr,
    output reg [7:0] pc,
    output [31:0] mem_data,
    output [31:0] reg_data
    );
    wire PCWriteCond;
    wire PCWriteCondne;
    wire PCWrite;
    wire IRWrite;
    wire ALUSrcA;
    wire [1:0] ALUSrcB;
    wire [1:0] ALUOp;
    wire RegDst;
    wire [1:0] PCSource;
    wire RegWrite;
    wire IorD;
    wire MemWrite;
    wire MemtoReg;

    wire [31:0] Writedatamem;
    wire [31:0] Memdata;
    wire [7:0] memaddr;
    reg [31:0] IR;
    reg [31:0] MDR;

    wire [5:0] Readregister1,Readregister2;
    wire [5:0] Writeregister;
    wire [31:0] Writedatareg;
    wire [31:0] Readdata1,Readdata2;
    reg [31:0] A,B;
    wire [31:0] signextimm,immsftl2;

    wire [31:0] Src1,Src2;
    wire [31:0] Out;
    wire [3:0] Op;
    wire [2:0] Flag;
    reg [31:0] ALUOut;
    wire [31:0] pcext;

    wire [31:0] pcin,jext;
    wire pcen;

    ALU ALU(Src1,Src2,Op,Out,Flag);
    RF RF(addr[4:0],Readregister1,Readregister2,Writeregister,Writedatareg,RegWrite,rst,clk,reg_data,Readdata1,Readdata2);
    mem mem(clk,memaddr,addr,MemWrite,Writedatamem,Memdata,mem_data);
    Contral Contral(run,IR[31:26],clk,rst,PCWriteCond,PCWriteCondne,PCWrite,IRWrite,ALUOp,ALUSrcB,ALUSrcA,RegDst,PCSource,RegWrite,IorD,MemWrite,MemtoReg);
    ALUContral ALUContral(IR[31:26],IR[5:0],ALUOp,Op);

    assign memaddr=IorD?ALUOut:pc;
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            MDR<=32'b0;
            IR<=32'b0;
        end
        else
        begin
            if(IRWrite) IR<=Memdata;
            MDR<=Memdata;
        end
    end

    assign Writeregister=RegDst?IR[15:11]:IR[20:16];
    assign Writedatareg=MemtoReg?MDR:ALUOut;
    assign Readregister1=IR[25:21];
    assign Readregister2=IR[20:16];
    always @ (posedge clk or posedge rst)
    begin
        if(rst)
        begin
            A<=32'b0;
            B<=32'b0;
        end
        else
        begin
            A<=Readdata1;
            B<=Readdata2;
        end
    end
    assign signextimm={{16{IR[15]}},IR[15:0]};
    assign immsftl2=signextimm;
    assign Writedatamem=B;

    assign pcext={{24{1'b0}},pc};
    assign Src1=ALUSrcA?A:pcext;
    assign one=32'b00000000000000000000000000000001;
    assign Src2=ALUSrcB[1]?(ALUSrcB[0]?immsftl2:signextimm):(ALUSrcB[0]?one:B);
    always @ (posedge clk)
    begin
        ALUOut<=Out;
    end

    assign pcin=PCSource[1]?jext:(PCSource[0]?ALUOut:Out);
    assign jext={{24{1'b0}},IR[7:0]};
    assign pcen= PCWrite || PCWriteCond && Flag[0] || PCWriteCondne && ~Flag[0];
    always @ (posedge clk or posedge rst)
    begin
        if(rst) pc<=32'b0;
        else if(pcen) pc<=pcin;
    end
endmodule
