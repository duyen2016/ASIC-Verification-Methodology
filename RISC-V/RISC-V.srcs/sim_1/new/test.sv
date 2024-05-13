`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 05/13/2024 07:37:37 AM
// Design Name: 
// Module Name: test
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



class Packet;
    static rand bit [6:0] opcode;
    static rand bit [4:0] rs1, rs2, rd;
    static rand bit [20:0] imm;
    static rand bit [2:0] funct3;
    static rand bit [6:0] funct7;
    static bit [31:0] inst; 
    static string name;
    parameter R_Type = 3'b000;
    parameter I_Type = 3'b001;
    parameter S_Type = 3'b010;
    parameter B_Type = 3'b011;
    parameter U_Type = 3'b100;
    parameter J_Type = 3'b101;
    parameter I_Type_JALR = 3'b110;
    extern function new(string namepacket = "Packet");
    extern function gen();
    extern function void display(string prefix = "NOTE");

    function [2:0] gettype (input [6:0] opcode);
        begin
            if (opcode == 7'b0110011) gettype = R_Type;
            else if (opcode == 7'b0000011) gettype = I_Type;
            else if (opcode == 7'b0010011) gettype = I_Type;
            else if (opcode == 7'b0100011) gettype = S_Type;
            else if (opcode == 7'b1100011) gettype = B_Type;
            else if (opcode == 7'b0110111) gettype = U_Type;
            else if (opcode == 7'b0010111) gettype = U_Type;
            else if (opcode == 7'b1101111) gettype = J_Type;
            else if (opcode == 7'b1100111) gettype = I_Type_JALR;    
            else gettype = 3'b111;   
        end
    endfunction    
endclass: Packet

function Packet::new(string namepacket);
    this.name = namepacket;
endfunction: new
function Packet::gen();
    bit [2:0] inst_type;
    inst_type = gettype(opcode);   
    case (inst_type)
        R_Type: inst = {funct7, rs2, rs1, funct3, rd, opcode};
        I_Type: inst = {imm[11:0], rs1, funct3, rd, opcode};
        I_Type_JALR: inst = {imm[11:0], rs1, funct3, rd, opcode};
        S_Type: inst = {imm[11:5], rs2, rs1, funct3, imm[4:0], opcode};
        B_Type: inst = {imm[13], imm[10:5], rs2, rs1, funct3, imm[4:1], imm[11], opcode};
        U_Type: inst = {imm[19:0], rd, opcode};
        J_Type: inst = {imm[20], imm[10:1], imm[11], imm[19:12], rd, opcode};
    endcase 
endfunction: gen
function void Packet::display(string prefix = "NOTE");
    $display("instruction: %h", inst);
    $display("opcode: %h", opcode);
    $display("rs1: %h", rs1);
    $display("rs2: %h", rs2);
    $display("rd: %h", rd);    
    $display("imm: %h", imm);
    $display("funct3: %h", funct3);
    $display("funct7: %h", funct7);
    $display("name: %s", name);
endfunction: display
task gen(Packet pkt2send, logic [31:0] addr);
    static int pkts_generated = 0;
    string numpkts, name; 
    $sformat(numpkts, "%d", pkts_generated);

    name = {"Packet", numpkts};
    pkt2send = new(name);// pkts_generated = pkts_generated + 1; 
//    $display(pkt2send.name);    
    case (addr)
        32'h0: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h2; imm == 20'h00123;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end
        32'h1: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'h456; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h2: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h1; imm == 20'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h3: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rd == 5'h1; rs1 == 5'h1; imm == 20'h5; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h4: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'h2; rs2 == 5'h1; imm == 20'h0; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h5: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rd == 5'hf; rs1 == 5'h2; imm == 20'h0; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h6: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rd == 5'hf; rs1 == 5'h2; imm == 20'h0; funct3 == 3'b100;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
        32'h7: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'h1; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h8: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h1; rd == 5'h1; imm == 20'hffffe; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h9: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'h2; rs2 == 5'b1 ; rd == 5'h2; imm == 20'h0; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'ha: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h2; rd == 5'hf; imm == 20'h0; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'hb: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'h1; funct3 == 3'b000;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'hc: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h1; rd == 5'h1; imm == 20'h600; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'hd: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'h2; rs2 == 5'h1; imm == 20'h0; funct3 == 3'b001; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'he: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h2; rd == 5'hf; imm == 20'h0; funct3 == 3'b001; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'hf: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h2; rd == 5'hf; imm == 20'h0; funct3 == 3'b101; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h10: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'h2; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h11: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h1; imm == 20'h08090; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h12: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h1; rd == 5'h1; imm == 20'h602; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h13: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'h2; rs2 == 5'h1; imm == 20'h0; funct3 == 3'b010; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h14: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h2; rd == 5'hf; imm == 20'h0; funct3 == 3'b010; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h15: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'h0; rs2 == 5'hf; imm == 20'd196; funct3 == 3'b111; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h16: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'hffffc; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h17: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h3; imm == 20'h0; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h18: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h3; rd == 5'h3; imm == 20'h8; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h19: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h4; imm == 20'h0;  
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1a: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h3; rd == 5'h5; imm == 20'hfffff; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1b: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h6; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1c: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110111;
            rd == 5'h0; imm == 20'h0; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1d: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'h7; imm == 20'h7; funct3 == 3'b010; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1e: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'h7; rs2 == 5'h0; imm == 20'h8; funct3 == 3'b001; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h1f: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'h3; rs2 == 5'h0; imm == 20'h64; funct3 == 3'b101; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h20: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'h7; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h21: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'h8; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h22: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h9; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h23: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'h8; rs2 == 5'h3; rd == 5'ha; funct3 == 3'b010; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h24: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'ha; rs2 == 5'h0; imm == 20'd40; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h25: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h9; rd == 5'ha; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h26: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'h6; rs2 == 5'h7; rd == 5'hb; funct3 == 3'b000; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h27: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'hb; rd == 5'hc; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h28: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'ha; rs2 == 5'hc; imm == 20'h8; funct3 == 3'b100; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h29: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100011;
            rs1 == 5'h0; rs2 == 5'h3; imm == 20'h8; funct3 == 3'b110; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2a: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'h8; rs2 == 5'h0; rd == 5'h7; funct3 == 3'b000; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2b: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h9; rd == 5'h9; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2c: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h8; rd == 5'h8; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2d: begin
            if (!pkt2send.randomize() with {opcode == 7'b1101111;
            rd == 5'hf; imm == 21'h1fffd8; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2e: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'h6; rs2 == 5'h7; rd == 5'hb; funct3 == 3'b000; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h2f: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'hb; rd == 5'he; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h30: begin
            if (!pkt2send.randomize() with {opcode == 7'b0000011;
            rs1 == 5'h2; rd == 5'hc; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h31: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'h2; rs2 == 5'he; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h32: begin
            if (!pkt2send.randomize() with {opcode == 7'b0100011;
            rs1 == 5'hb; rs2 == 5'hc; imm == 20'h0; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h33: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'h2; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h34: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'h4; imm == 20'h1; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h35: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010111;
            rd == 5'hf; imm == 20'h0; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h36: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'hf; rd == 5'hf; imm == 20'h8; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h37: begin
            if (!pkt2send.randomize() with {opcode == 7'b1100111;
            rs1 == 5'hf; rd == 5'hf; imm == 20'hfff94; funct3 == 3'b000; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h38: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h2; rd == 5'hf; imm == 20'h5; funct3 == 3'b100; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h39: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h3; rd == 5'hf; imm == 20'h12; funct3 == 3'b110; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3a: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h5; rd == 5'hf; imm == 20'h19; funct3 == 3'b111; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3b: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'h4; imm == 20'h1e; funct3 == 3'b001; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3c: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h1; rd == 5'hf; imm == 20'h8; funct3 == 3'b101; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3d: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'h4; rd == 5'hb; imm == 20'h410; funct3 == 3'b101; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3e: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hf; rs2 == 5'h3; rd == 5'hf; funct3 == 3'b001; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h3f: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hb; rs2 == 5'hc; rd == 5'hf; funct3 == 3'b011; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h40: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hb; rs2 == 5'hc; rd == 5'hf; funct3 == 3'b100; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h41: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'h1; rs2 == 5'h0; rd == 5'hf; funct3 == 3'b101; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h42: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hb; rs2 == 5'he; rd == 5'hf; funct3 == 3'b101; 
            funct7 == 7'h20;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h43: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hf; rs2 == 5'h3; rd == 5'hf; funct3 == 3'b110; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h44: begin
            if (!pkt2send.randomize() with {opcode == 7'b0110011;
            rs1 == 5'hb; rs2 == 5'h1; rd == 5'hf; funct3 == 3'b111; 
            funct7 == 7'h0;})  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end         
        32'h45: begin
            if (!pkt2send.randomize() with {opcode == 7'b0010011;
            rs1 == 5'hf; rd == 5'hf; imm == 20'h9; funct3 == 3'b011; 
            })  $error("This is a randomize error");
            else pkts_generated = pkts_generated + 1;
        end 
    endcase
endtask: gen

program automatic test(yourcpu_io.TB cpu_io);
    Packet pkt2send[69:0];
    logic [31:0] inst_arr [69:0];
    int i;
    initial begin
        $display("Hello World!");

        foreach(inst_arr[i]) begin
            gen(pkt2send[i], i);
            pkt2send[i].display();
            pkt2send[i].gen();
            inst_arr[i] = pkt2send[i].inst;
        end
        driver(0, inst_arr[0]);
        driver(4, inst_arr[1]);
        driver(8, inst_arr[2]);
        driver(12, inst_arr[3]);
        driver(16, inst_arr[4]);
        driver(20, inst_arr[5]);
        driver(24, inst_arr[6]);
        driver(28, inst_arr[7]);
        driver(32, inst_arr[8]);
        driver(36, inst_arr[9]);
        driver(40, inst_arr[10]);
        driver(44, inst_arr[11]);
        driver(48, inst_arr[12]);
        driver(52, inst_arr[13]);
        driver(56, inst_arr[14]);
        driver(60, inst_arr[15]);
        driver(64, inst_arr[16]);
        driver(68, inst_arr[17]);
        driver(72, inst_arr[18]);
        driver(76, inst_arr[19]);
        driver(80, inst_arr[20]);
        driver(84, inst_arr[21]);
        driver(88, inst_arr[22]);
        driver(92, inst_arr[23]);
        driver(96, inst_arr[24]);
        driver(100, inst_arr[25]);
        driver(104, inst_arr[26]);
        driver(108, inst_arr[27]);
        driver(112, inst_arr[28]);
        driver(116, inst_arr[29]);
        driver(120, inst_arr[30]);
        driver(124, inst_arr[31]);
        driver(128, inst_arr[32]);
        driver(132, inst_arr[33]);
        driver(136, inst_arr[34]);
        driver(140, inst_arr[35]);
        driver(144, inst_arr[36]);
        driver(148, inst_arr[37]);
        driver(152, inst_arr[38]);
        driver(156, inst_arr[39]);
        driver(160, inst_arr[40]);
        driver(164, inst_arr[41]);
        driver(168, inst_arr[42]);
        driver(172, inst_arr[43]);
        driver(176, inst_arr[44]);
        driver(180, inst_arr[45]);
        driver(184, inst_arr[46]);
        driver(188, inst_arr[47]);
        driver(192, inst_arr[48]);
        driver(196, inst_arr[49]);
        driver(200, inst_arr[50]);
        driver(204, inst_arr[51]);
        driver(208, inst_arr[52]);
        driver(212, inst_arr[53]);
        driver(216, inst_arr[54]);
        driver(220, inst_arr[55]);
        driver(224, inst_arr[56]);
        driver(228, inst_arr[57]);
        driver(232, inst_arr[58]);
        driver(236, inst_arr[59]);
        driver(240, inst_arr[60]);
        driver(244, inst_arr[61]);
        driver(248, inst_arr[62]);
        driver(252, inst_arr[63]);
        driver(256, inst_arr[64]);
        driver(260, inst_arr[65]);
        driver(264, inst_arr[66]);
        driver(268, inst_arr[67]);
        driver(272, inst_arr[68]);
        driver(276, inst_arr[69]);
        cpu_io.reset = 1'b1;
        @(cpu_io.cb);
        cpu_io.reset = 1'b0;
        #10000 $stop;
    end
    task driver(input int addr, input logic [31:0] data);
        cpu_io.cb.addr <= addr;
        cpu_io.cb.loadIM <= 1'b1;
        cpu_io.cb.data <= data; 
//        $display("addr: %h, inst: %h", addr, data);
        @(cpu_io.cb);
        ##5
        cpu_io.cb.loadIM <= 1'b0;
    endtask: driver
endprogram:test


