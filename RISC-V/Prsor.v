module processor(clk, rst, loadIM, addr, data);
    input clk, rst, loadIM;
    input [31:0] addr, data;
    reg [31:0] PC = -4;
    wire [31:0] inst;
    wire [1:0] WBSel, Afwd, Bfwd;
    wire [2:0] ImmSel, funct3, type_ID, type_EX, type_MA, type_WB;
    wire RegWEn, BSel, MemRW, PCSel, BrUn, BrEq, BrLT, ASel, BrEq_MA, BrLT_MA, stall;
    wire [3:0] ALUSel;
    wire [4:0] i0, i1, i2,  AddrD;
    wire [24:0] i3;
    wire [31:0] DA, DB, imm, ALU_A, ALU_B, alu_res, memread, wb, PCadd4, PC_next, inst_ID, PC_ID, PCadd4_ID, PC_EX, PCadd4_EX, DA_EX, DB_EX,
    imm_EX, inst_EX, alu_res_MA, DB_MA, PCadd4_MA, inst_MA, alu_res_WB, PCadd4_WB, memread_WB, DA_FW, DB_FW, inst_WB, addrIM;
//    assign i0 = inst[11:7];
//    assign i1 = inst[19:15];
//    assign i2 = inst[24:20];
//    assign i3 = inst[31:7];
    mux MUX2 (.sel(stall), .in0(PCadd4), .in1(alu_res), .s(PC_next));
    always @(posedge clk) begin
        if (rst) PC <= -4;
        else PC <= PC_next;
    end
    assign PCadd4 = PC + 4;
    assign addrIM = (loadIM)? addr: PC;
    imem IMEM (.clk(clk), .loadIM(loadIM), .Address(addrIM), .data(data), .InstCode(inst));
    IF_ID IF_ID(.clk(clk), .stall(stall), .rst(rst), .inst_IF(inst), .PC_IF(PC), .PCadd4_IF(PCadd4), .i1(i1), .i2(i2), .i3(i3), .inst_ID(inst_ID), 
        .PC_ID(PC_ID), .PCadd4_ID(PCadd4_ID), .type(type_ID), .ImmSel(ImmSel));
    immgen ImmGen (.in(i3), .immsel(ImmSel), .out(imm));
    regfile Reg (.clk(clk), .rst(rst), .WriteData(wb), .WriteAddress(AddrD), .RegWriteEn(RegWEn), .ReadAddress1(i1), .ReadAddress2(i2), .ReadData1(DA), 
        .ReadData2(DB));
    ID_EX ID_EX(.clk(clk), .stall(stall), .rst(rst), .PC_ID(PC_ID), .PCadd4_ID(PCadd4_ID), .DA_ID(DA), .DB_ID(DB), .imm_ID(imm), .inst_ID(inst_ID), .type_ID(type_ID), 
        .PC_EX(PC_EX), .PCadd4_EX(PCadd4_EX), .DA_EX(DA_FW), .DB_EX(DB_FW), .imm_EX(imm_EX), .inst_EX(inst_EX),
        .type_EX(type_EX), .BrUn(BrUn), .BSel(BSel), .ASel(ASel), .ALUSel(ALUSel));
    forwarding Forwarding(
        .inst_EX(inst_EX), .inst_MA(inst_MA), .inst_WB(inst_WB),
        .type_EX(type_EX),
        .AForwarding(Afwd), .BForwarding(Bfwd)
    );
    mux4 MUX4 (.sel(Afwd), .in0(memread), .in1(alu_res_MA), .in2(DA_FW), .in3(wb), .s(DA_EX));
    mux4 MUX5 (.sel(Bfwd), .in0(memread), .in1(alu_res_MA), .in2(DB_FW), .in3(wb), .s(DB_EX));
    branchcomp BranchComp (.a(DA_EX), .b(DB_EX), .BrUn(BrUn), .BrEq(BrEq), .BrLT(BrLT));
    mux MUX0 (.sel(BSel), .in0(DB_EX), .in1(imm_EX), .s(ALU_B));
    mux MUX1 (.sel(ASel), .in0(DA_EX), .in1(PC_EX), .s(ALU_A));
    alu ALU (.reg1(ALU_A), .reg2(ALU_B), .ALUsel(ALUSel), .ALUresult(alu_res));
    stall STALL(
        .type(type_EX),
        .inst(inst_EX), 
        .BrEq(BrEq), .BrLT(BrLT),
        .stall(stall)
    );
    EX_MA EX_MA (.ALU_res_EX(alu_res), .DB_EX(DB_EX), .PCadd4_EX(PCadd4_EX), .inst_EX(inst_EX),
        .type_EX(type_EX),
        .BrEq_EX(BrEq), .BrLT_EX(BrLT), .clk(clk), .rst(rst),
        .type_MA(type_MA),
        .ALU_res_MA(alu_res_MA), .DB_MA(DB_MA), .PCadd4_MA(PCadd4_MA), .inst_MA(inst_MA),
        .MemRW(MemRW), .PCSel(PCSel), .BrEq_MA(BrEq_MA), .BrLT_MA(BrLT_MA),
        .funct3(funct3));
    dmem DMEM (.clk(clk), .rst(rst), .Address(alu_res_MA), .WriteData(DB_MA), .ReadData(memread), .MemRW(MemRW), .funct3(funct3));
    MA_WB MA_WB(
        .ALU_res_MA(alu_res_MA), .PCadd4_MA(PCadd4_MA), .mem_MA(memread), .inst_MA(inst_MA),
        .type_MA(type_MA),
        .BrEq_MA(BrEq_MA), .BrLT_MA(BrLT_MA), .clk(clk), .rst(rst),
        .type_WB(type_WB),
        .ALU_res_WB(alu_res_WB), .PCadd4_WB(PCadd4_WB), .mem_WB(memread_WB), .inst_WB(inst_WB),
        //.BrEq_WB(Br), BrLT_WB,
        .RegWEn(RegWEn),
        .WBSel(WBSel),
        .AddrD(AddrD));
    mux3 MUX3 (.sel(WBSel), .in0(memread_WB), .in1(alu_res_WB), .in2(PCadd4_WB), .s(wb));  
    //controller CTRL (PCSel, inst, ImmSel, RegWEn, BrUn, BrEq, BrLT, Bsel, ASel, ALUSel, MemRW, WBSel, funct3);
    
endmodule
