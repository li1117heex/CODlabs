`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2019/05/06 13:11:16
// Design Name: 
// Module Name: DDU
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


module DDU(
    //input clk100M,
    input clk1k,
    input rst,
    input cont,
    input step,
    input mem,
    input inc,
    input dec,
    output [15:0] led,
    output reg [7:0] an,
    output reg [6:0] seg
    );
    parameter CNT=8;
    reg run;
    reg [7:0] addr;
    wire [7:0] pc;
    wire [31:0] mem_data,reg_data;
    wire [31:0] data;
    reg [CNT-1:0] cnt;
    reg plug,prerun;
    //wire clkvar;
    //wire clk1k;
    wire locked;
    top top(clk1k,rst,run,addr,pc,mem_data,reg_data);
    assign data=mem?mem_data:reg_data;
    assign led = {pc,addr};
    wire [6:0] seg0,seg1,seg2,seg3,seg4,seg5,seg6,seg7;
    
    //frequency frequency(clk100M,rst,1,clk1k,clkvar,locked);
    BCD7 bit0(data[3:0],0,seg0);
    BCD7 bit1(data[7:4],0,seg1);
    BCD7 bit2(data[11:8],0,seg2);
    BCD7 bit3(data[15:12],0,seg3);
    BCD7 bit4(data[19:16],0,seg4);
    BCD7 bit5(data[23:20],0,seg5);
    BCD7 bit6(data[27:24],0,seg6);
    BCD7 bit7(data[31:28],0,seg7);
        
    always@(posedge clk1k)
            begin
            //if(|cnt && plug) cnt<=cnt+1;
            case(an)
            8'b11111110:begin an<=8'b11111101;seg<=seg1;end
            8'b11111101:begin an<=8'b11111011;seg<=seg2;end
            8'b11111011:begin an<=8'b11110111;seg<=seg3;end
            8'b11110111:begin an<=8'b11101111;seg<=seg4;end
            8'b11101111:begin an<=8'b11011111;seg<=seg5;end
            8'b11011111:begin an<=8'b10111111;seg<=seg6;end
            8'b10111111:begin an<=8'b01111111;seg<=seg7;end
            8'b01111111:begin an<=8'b11111110;seg<=seg0;end
            default:an<=8'b01111111;
            endcase
            end
      
    always @ (posedge clk1k or posedge rst)
    begin
        if(rst)
        begin
            run<=0;
            addr<=8'b0;
            cnt<=6'b0;
            plug<=0;
            prerun<=0;
        end
        else
        begin
            if(prerun) begin
            run<=0;
            prerun<=0;
            end
            if(plug)
            begin
                if(~|cnt) plug<=0;
                else cnt<=cnt+1;
            end
            
            else
            begin
                if(cont) 
                begin
                    run<=~run;
                    cnt<=8'b00000001;//{{(CNT-1){1'b0}},1'b1};
                    plug<=1;
                end
                
                else if(step)
                begin
                    prerun<=1;
                    run<=1;
                    cnt<=8'b00000001;//{{(CNT-1){1'b0}},1'b1};
                    plug<=1;
                end
                
                else if(inc && ~dec)
                begin
                    addr<=addr+1;
                    cnt<=8'b00000001;//{{(CNT-1){1'b0}},1'b1};
                    plug<=1;
                end
                
                else if(dec && ~inc)
                begin
                    addr<=addr-1;
                    cnt<=8'b00000001;//{{(CNT-1){1'b0}},1'b1};
                    plug<=1;
                end
            end
        end
    end            
endmodule

module BCD7 (
    input [3:0] x,
    input flag,
    output reg [6:0] seg
    );
    always @ *
    begin
    if(flag) seg=7'b1111111;
    else
    case(x)
    4'b0000:seg=7'b1000000;
    4'b0001:seg=7'b1111001;
    4'b0010:seg=7'b0100100;
    4'b0011:seg=7'b0110000;
    4'b0100:seg=7'b0011001;
    4'b0101:seg=7'b0010010;
    4'b0110:seg=7'b0000010;
    4'b0111:seg=7'b1111000;
    4'b1000:seg=7'b0000000;
    4'b1001:seg=7'b0010000;
    4'b1010:seg=7'b0001000;
    4'b1011:seg=7'b0000011;
    4'b1100:seg=7'b1000110;
    4'b1101:seg=7'b0100001;
    4'b1110:seg=7'b0000110;
    4'b1111:seg=7'b0001110;
    endcase
    end
endmodule

module frequency(
    input clk100M,
    input reset,
    input enable,
    output pulse,
    output clkvar,
    output locked
    );
    wire clk_out;
    clk_wiz_0 sss(clk_out,clkvar,reset,locked,clk100M);
    reg [22:0] cnt;
    
    always@(posedge clk_out,negedge locked)
    begin
        if(~locked)
            cnt<=23'h0;
        else if(enable)
        begin
        if(cnt>=23'd6249)
            cnt<=23'h0;
        else cnt<=cnt+23'h1;
        end
    end
    assign pulse=(cnt==23'd3000)?1:0;
endmodule