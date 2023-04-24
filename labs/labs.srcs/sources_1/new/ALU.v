`include "defines_riscv.v"

module alu_riscv (
  input       [31:0]  A,
  input       [31:0]  B,
  input       [4:0]   ALUOp,
  output  reg         Flag,   // reg потому что тебе потребуется мультиплексор
  output  reg [31:0]  Result  // описанный в case внутри always 
);                            // а в always, слева от "равно", всегда стоит reg

wire [31:0] S;
fulladder32 fulladder32(
    .A(A[31:0]),
    .B(B[31:0]),
    .Pin(0),
    .S(S[31:0])
    );

// тут твой код
always @ * begin 
    case(ALUOp)
        `ALU_EQ: Flag = (A == B);
        `ALU_NE: Flag = (A != B);
        `ALU_LTS: Flag = $signed(A) < $signed(B);
        `ALU_GES: Flag = $signed(A) >= $signed(B);
        `ALU_LTU: Flag = (A < B);
        `ALU_GEU: Flag = (A >= B);
         default: Flag = 0;
    endcase
end


always @(*) begin
    case(ALUOp)
        `ALU_SLTS : Result = $signed(A) < $signed(B);
        `ALU_SLTU : Result = A < B;
        `ALU_ADD : Result = S;
        `ALU_SUB : Result = A- B;
        `ALU_SLL : Result = A << B[4:0];
        `ALU_XOR : Result = A ^ B;
        `ALU_SRL : Result = A >> B[4:0];
        `ALU_SRA : Result = $signed(A) >>> B[4:0];
        `ALU_OR : Result = A | B;
        `ALU_AND : Result = A & B;
         default : Result = 0;    
    endcase
end

endmodule