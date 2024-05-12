`timescale 1ns / 1ps
module dmem(clk, Address, WriteData, ReadData, MemRW, funct3);
    input clk;
    input [31:0]Address, WriteData;
    input MemRW;
    input [2:0] funct3;
    output [31:0]ReadData;
    reg [31:0]ReadData;
    parameter [31:0]range = 32'h07ffffff;
    reg [7:0] dmem_cell [range:0];
    //Write = 0; Read = 1
    
    always @(negedge clk) begin
        if (~MemRW) begin
            if (funct3 == 3'b000) dmem_cell[Address] <= WriteData[7:0];
            else if (funct3 == 3'b001) begin 
                dmem_cell[Address+1] <= WriteData[15:8];
                dmem_cell[Address] <= WriteData[7:0];
                end
            else if (funct3 == 3'b010) begin
                dmem_cell[Address+3] <= WriteData[31:24];
                dmem_cell[Address+2] <= WriteData[23:16];
                dmem_cell[Address+1] <= WriteData[15:8];
                dmem_cell[Address] <= WriteData[7:0];
                end
        end
    end
  
    always @(Address, dmem_cell, MemRW, funct3) begin
        if (MemRW) begin
            case (funct3)
                3'b001: begin 
                    ReadData[7:0] = dmem_cell[Address];
                    ReadData[15:8] = dmem_cell[Address+1];
                    ReadData[31:16] = {16,{dmem_cell[Address+1][7]}};
                    end
                3'b010: ReadData = {dmem_cell[Address+3], dmem_cell[Address+2], dmem_cell[Address+1], dmem_cell[Address]};
                3'b100: ReadData = {{24'b0}, dmem_cell[Address]};
                3'b101: ReadData = {{16'b0}, dmem_cell[Address+1], dmem_cell[Address]};
                3'b000: ReadData = {{24{dmem_cell[Address][7]}}, dmem_cell[Address]};
                default: ReadData = 32'b0; 
            endcase
        end
    end
endmodule

