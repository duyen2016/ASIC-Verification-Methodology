`timescale 1ns/1ps
module processor_testbench();
  reg clk;
  initial forever #10 clk = ~clk;
  processor f(clk);
  initial begin
    #0 clk = 1'b0;
    #500 $stop;
  end
  always@(posedge clk) begin
    #5
    //$display("pc = %h", f.PC);
//    $display("inst = %h", f.inst);
//    $display("control signal: ", f.PCSel, f.ImmSel, f.RegWEn, f.BrUn, f.BrEq, f.BrLT, f.Bsel, f.ASel, f.ALUSel, f.MemRW, f.WBSel, f.funct3);
//    $display("data A = %h", f.DA);
//    $display("data B = %h", f.DB);
//    $display("imm_gen output = %h", f.imm);
//    $display("ALU A = %h", f.ALU_A);
//    $display("ALU B = %h", f.ALU_B);
//    $display("alu_res = %h", f.alu_res);
//    $display("read mem = %h", f.memread);
//    $display("wb = %h\n", f.wb);
    $display("ID stage addressA = %h", f.i1);
    $display("ID stage addressB = %h", f.i2);
    $display("ID stage imm input = %h", f.i3);
    $display("ID stage inst = %h", f.inst_ID);
    $display("ID stage PC = %h", f.PC_ID);
    $display("ID stage PCadd4 = %h", f.PCadd4_ID);
    $display("ID stage type = %h", f.type_ID);
    $display("ID stage ImmSel = %h\n", f.ImmSel);
//    $stop;
    end
    
  initial begin
  $readmemh("inst_file.txt", f.IMEM.imem_cell);
  //$readmemh("E:/CE213-Lab/Lab5-21522016-RISCV/reg_file.txt", f.f1.f2.register);
  //$readmemh("E:/CE213-Lab/Lab5-21522016-RISCV/data_file.txt", f.f1.f5.dmem_cell);
  end
endmodule
