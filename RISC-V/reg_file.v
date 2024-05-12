module regfile(clk, WriteData, WriteAddress, RegWriteEn, ReadAddress1, ReadAddress2, ReadData1, ReadData2);
  input clk;
  input [31:0] WriteData;
  output [31:0] ReadData1, ReadData2;
  input [4:0] WriteAddress, ReadAddress1, ReadAddress2;
  input RegWriteEn;
  reg [31:0] ReadData1, ReadData2;
  reg [31:0] register [31:0];
  
  always @(ReadAddress1, ReadAddress2, register) begin
    ReadData1 = register[ReadAddress1];
    ReadData2 = register[ReadAddress2];
  end    
  always @(negedge clk) begin
    if (RegWriteEn)
    register[WriteAddress] <= WriteData;  
  end
endmodule