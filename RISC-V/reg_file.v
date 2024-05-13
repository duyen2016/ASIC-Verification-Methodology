module regfile(clk, rst, WriteData, WriteAddress, RegWriteEn, ReadAddress1, ReadAddress2, ReadData1, ReadData2);
  input clk, rst;
  input [31:0] WriteData;
  output [31:0] ReadData1, ReadData2;
  input [4:0] WriteAddress, ReadAddress1, ReadAddress2;
  input RegWriteEn;
  reg [31:0] ReadData1, ReadData2;
  reg [31:0] register [31:0];
  always @(ReadAddress1 or ReadAddress2 or register[ ReadAddress1] or register[ ReadAddress2]) begin
        ReadData1 = register[ReadAddress1];
        ReadData2 = register[ReadAddress2];
  end    
  always @(negedge clk) begin
    if (rst) begin
        register[0] <= 0;
        register[1] <= 0;
        register[2] <= 0;
        register[3] <= 0;
        register[4] <= 0;
        register[5] <= 0;
        register[6] <= 0;
        register[7] <= 0;
        register[8] <= 0;
        register[9] <= 0;
        register[10] <= 0;
        register[11] <= 0;
        register[12] <= 0;
        register[13] <= 0;
        register[14] <= 0;
        register[15] <= 0;
        register[16] <= 0;
        register[17] <= 0;
        register[18] <= 0;
        register[19] <= 0;
        register[20] <= 0;
        register[21] <= 0;
        register[22] <= 0;
        register[23] <= 0;
        register[24] <= 0;
        register[25] <= 0;
        register[26] <= 0;
        register[27] <= 0;
        register[28] <= 0;
        register[29] <= 0;
        register[30] <= 0;
        register[31] <= 0;
    end
    else if (RegWriteEn)
    register[WriteAddress] <= WriteData;  
  end
endmodule