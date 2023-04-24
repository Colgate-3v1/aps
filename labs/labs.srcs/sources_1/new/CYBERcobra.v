module CYBERcobra(
   input    clk_i,
   input    rst_i,
   input [15:0]   sw_i,
   output [31:0]   out_o
   );
   
   reg[31:0] PC;
   wire[31:0] read_data;
   wire[31:0] sum_output;
   wire[31:0] RD1;
   wire[31:0] RD2;
   wire [31:0] Result;
   reg[31:0] Usl;
   wire Flag;


    instr_mem inst(
    .addr(PC),
    .read_data(read_data)   
   );
   
   fulladder32 adder(
    .A(PC),
    .B(Usl),
    .Pin(0),
    .S(sum_output)
    );
   
   always @(*) begin
    case (read_data[31]|read_data[30]& Flag)
        1'b0: Usl = 32'd4;
        1'b1: Usl = {{22{read_data[12]}} ,read_data[12:5],2'b00};
        
    endcase
   
   end
   
   always @(posedge clk_i) begin
        PC <= sum_output;
        if (!rst_i) begin
            PC <= 32'd0;
        end        
   end
   
   
   
 reg[31:0] WD3;
 
 always @(*) begin
    case(read_data[29:28])          
      2'b00:  WD3 = {{9{read_data[27]}} ,read_data[27:5]} ;  
      2'b01:  WD3 = Result;       
      2'b10:  WD3 = {{16{sw_i[15]}} ,sw_i};
      2'b11:  WD3 = 32'd0;                 
    endcase          
  end
  
rf_riscv rf(
    .clk(clk_i),
    .WE(~(read_data[30]|read_data[31])),
    .A1(read_data[22:18]),
    .A2(read_data[17:13]),
    .A3(read_data[4:0]),

    .WD3(WD3),
    .RD1(RD1),
    .RD2(RD2)
);


alu_riscv alu(
  .A(RD1),
  .B(RD2),
  .ALUOp(read_data[27:23]),
  .Flag(Flag),  
  .Result(Result)   
);
    
   
   
   
   
   
   assign out_o = RD1;
   
   
   
  
   endmodule