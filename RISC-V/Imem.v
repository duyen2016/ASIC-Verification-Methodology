module imem(Address, InstCode);
  input [31:0]Address;
  output reg [31:0]InstCode;
  parameter [31:0]range = 32'h07ffffff;
  reg [7:0] imem_cell [range:0];
  
  always @(Address, imem_cell) begin
      InstCode[7:0] = imem_cell[Address+3];
      InstCode[15:8] = imem_cell[Address+2];
      InstCode[23:16] = imem_cell[Address+1]; 
      InstCode[31:24] = imem_cell[Address]; 
    end
endmodule

