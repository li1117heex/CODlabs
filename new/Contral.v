`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:
// Engineer:
//
// Create Date: 2019/05/06 14:05:02
// Design Name:
// Module Name: Contral
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


module Contral(
    input run,
    input [5:0] op,
    input clkvar,
    input rst,
    output reg PCWriteCond,
    output reg PCWriteCondne,
    output reg PCWrite,
    output reg IRWrite,
    output reg [1:0] ALUOp,
    output reg [1:0] ALUSrcB,
    output reg ALUSrcA,
    output reg RegDst,
    output reg [1:0] PCSource,
    output reg RegWrite,
    output reg IorD,
    //output reg MemRead,
    output reg MemWrite,
    output reg MemtoReg
    );
    reg [3:0] st,nst;
    reg [5:0] opreg;
    parameter RST = 4'b1111;
    always @ (posedge clkvar or posedge rst)
    begin
        if(rst) st<=RST;
        else st<=nst;
    end

    always @ *
    begin
    case(st)
        RST:begin
            PCWriteCond<=0;
            PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            RegWrite<=0;
            MemWrite<=0;
            nst<=run?4'b0000:RST;
        end

        4'b0000:begin  //if
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=1;
            IRWrite<=1;
            ALUSrcA<=0;
            ALUSrcB<=2'b01;
            ALUOp<=2'b00;
            RegDst<=0;//
            PCSource<=2'b00;
            RegWrite<=0;
            IorD<=0;
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=4'b0001;
        end

        4'b0001:begin//id
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            ALUSrcA<=0;
            ALUSrcB<=2'b11;
            ALUOp<=2'b00;
            RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            opreg<=op;
            case(op)
                6'b000000: nst<=4'b0110;//Rtype
                6'b100011: nst<=4'b0010;//lw
                6'b101011: nst<=4'b0010;//sw
                6'b001000: nst<=4'b1010;//addi
                6'b001100: nst<=4'b1010;//andi
                6'b001101: nst<=4'b1010;//ori
                6'b001110: nst<=4'b1010;//xori
                6'b001010: nst<=4'b1010;//slti
                6'b000100: nst<=4'b1000;//beq
                6'b000101: nst<=4'b1000;//bne
                6'b000010: nst<=4'b1001;//j
                default:nst<=run?4'b0000:RST;
            endcase
        end

        4'b0010:begin//ex lwsw
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            ALUSrcA<=1;
            ALUSrcB<=2'b10;
            ALUOp<=2'b00;
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            case(opreg)
                6'b100011: nst<=4'b0011;//lw
                6'b101011: nst<=4'b0101;//sw
                default:nst<=run?4'b0000:RST;
            endcase
        end

        4'b0011:begin//lw mem
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            //ALUSrcA<=1;
            //ALUSrcB<=2'b10;
            ALUOp<=2'b00;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=1;
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=4'b0100;
        end

        4'b0100:begin//lw rb
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            //ALUSrcA<=1;
            //ALUSrcB<=2'b10;
            ALUOp<=2'b00;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=1;
            IorD<=1;//
            MemWrite<=0;
            MemtoReg<=1;//

            nst<=run?4'b0000:RST;
        end

        4'b0101:begin//sw mem
            PCWriteCond<=0;
		    PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            //ALUSrcA<=1;
            //ALUSrcB<=2'b10;
            ALUOp<=2'b00;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=1;
            MemWrite<=1;
            MemtoReg<=0;//

            nst<=run?4'b0000:RST;
        end

        4'b0110:begin//rtype ex
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            ALUSrcA<=1;
            ALUSrcB<=2'b00;
            ALUOp<=2'b10;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=4'b0111;
        end

        4'b0111:begin//rtype wb
            PCWriteCond<=0;
			PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            //ALUSrcA<=1;
            //ALUSrcB<=2'b10;
            ALUOp<=2'b00;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=1;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;

            nst<=run?4'b0000:RST;
        end

        4'b1000:begin//branch ex
            PCWriteCond<=~(opreg[0]);
            PCWriteCondne<=opreg[0];
            PCWrite<=0;
            IRWrite<=0;
            ALUSrcA<=1;
            ALUSrcB<=2'b00;
            ALUOp<=2'b01;
            //RegDst<=~|op;//
            PCSource<=2'b01;
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=run?4'b0000:RST;
        end

        4'b1001:begin//j ex
            PCWriteCond<=0;
            PCWriteCondne<=0;
            PCWrite<=1;
            IRWrite<=0;
            //ALUSrcA<=1;
            //ALUSrcB<=2'b10;
            ALUOp<=2'b00;//
            //RegDst<=~|op;//
            PCSource<=2'b10;//
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=run?4'b0000:RST;
        end

        4'b1010:begin//addi andi..ex
            PCWriteCond<=0;
            PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            ALUSrcA<=1;
            ALUSrcB<=2'b10;
            ALUOp<=2'b11;//
            //RegDst<=~|op;//
            PCSource<=2'b00;//
            RegWrite<=0;
            IorD<=0;//
            MemWrite<=0;
            MemtoReg<=0;//

            nst<=4'b0111;
        end

        default:begin
            PCWriteCond<=0;
            PCWriteCondne<=0;
            PCWrite<=0;
            IRWrite<=0;
            RegWrite<=0;
            MemWrite<=0;
            nst<=run?4'b0000:RST;
        end
    endcase
    end
endmodule
