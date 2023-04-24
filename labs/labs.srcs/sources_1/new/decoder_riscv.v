`include "defines_riscv.v"

module decoder_riscv (
  input       [31:0]  fetched_instr_i,
  output  reg [1:0]   ex_op_a_sel_o,      // ������ ������� ����������,
  output  reg [2:0]   ex_op_b_sel_o,      // ������ ��� �� ����������
  output  reg [4:0]   alu_op_o,           // ����� �������������� ������
  output  reg         mem_req_o,          // ��������� ������ �����
  output  reg         mem_we_o,           // always, � ����� �� ����� �����
  output  reg [2:0]   mem_size_o,         // ������ always ������ ������
  output  reg         gpr_we_a_o,         // ������ ������ ��������,
  output  reg         wb_src_sel_o,       // ���� ���� � ����� �����
  output  reg         illegal_instr_o,    // ����������� �
  output  reg         branch_o,           // ������������� ����������
  output  reg         jal_o,              // ��� ������
  output  reg         jalr_o              //
);

// ��� ���� ��� ��������

always @* begin
    mem_req_o = 1'b0;          // ��������� ������ �����
            mem_we_o = 1'b0;      // always, � ����� �� ����� �����
            mem_size_o = 1'b0;         // ������ always ������ ������
            gpr_we_a_o = 1'b1;        // ������ ������ ��������,
            wb_src_sel_o = 1'b0;     // ���� ���� � ����� �����
            illegal_instr_o = 1'b0;    // ����������� �
            branch_o = 1'b0;          // ������������� ����������
            jal_o = 1'b0;             // ��� ������
            jalr_o = 1'b0;
    case (fetched_instr_i[6:2])
        `OP_OPCODE:
        begin
            ex_op_a_sel_o = 2'b00;
            ex_op_b_sel_o = 3'b000;
            // wire = fetch 14 12
            case(fetched_instr_i[14:12])          
                3'd0:
                    case(fetched_instr_i[31:25])
                        7'd20: alu_op_o = `ALU_SUB;
                        7'd0: alu_op_o = `ALU_ADD;
                        default:  illegal_instr_o=1'b1;
                    endcase
                3'd4: alu_op_o = `ALU_XOR;
                3'd6: alu_op_o = `ALU_OR;
                3'd7: alu_op_o = `ALU_AND;
                3'd1: alu_op_o = `ALU_SLL;
                3'd5:
                    case(fetched_instr_i[31:25])
                        7'd20: alu_op_o = `ALU_SRL ;
                        7'd0: alu_op_o = `ALU_SRA;
                        default:   illegal_instr_o=1'b1;
                    endcase
                3'd2: alu_op_o = `ALU_SLTS;
                3'd3: alu_op_o = `ALU_SLTU;
                default:   illegal_instr_o=1'b1;
            endcase
            mem_req_o = 1'b0;          // ��������� ������ �����
            mem_we_o = 1'b0;      // always, � ����� �� ����� �����
            mem_size_o = 1'b0;         // ������ always ������ ������
            gpr_we_a_o = 1'b1;        // ������ ������ ��������,
            wb_src_sel_o = 1'b0;     // ���� ���� � ����� �����
            illegal_instr_o = 1'b0;    // ����������� �
            branch_o = 1'b0;          // ������������� ����������
            jal_o = 1'b0;             // ��� ������
            jalr_o = 1'b0;
         end
        `OP_IMM_OPCODE: 
        begin
            ex_op_a_sel_o = 2'b00;
            ex_op_b_sel_o = 3'b001;
            case(fetched_instr_i[14:12])          
                3'd0: alu_op_o = `ALU_ADD;
                3'd4: alu_op_o = `ALU_XOR;
                3'd6: alu_op_o = `ALU_OR;
                3'd7: alu_op_o = `ALU_AND;
                3'd1: case(fetched_instr_i[31:25])
                    11'd0: alu_op_o = `ALU_SLL;
                    default:   illegal_instr_o=1'b1;
                endcase
                
                3'd5:
                    case(fetched_instr_i[31:25])
                        7'd20: alu_op_o = `ALU_SRL;
                        7'd0: alu_op_o = `ALU_SRA;
                        default:   illegal_instr_o=1'b1;
                    endcase
                3'd2: alu_op_o = `ALU_SLTS;
                3'd3: alu_op_o = `ALU_SLTU;
                default:   illegal_instr_o=1'b1;
            endcase
                
            mem_req_o = 1'b0;          // ��������� ������ �����
            mem_we_o = 1'b0;      // always, � ����� �� ����� �����
            mem_size_o = 1'b0;         // ������ always ������ ������
            gpr_we_a_o = 1'b1;        // ������ ������ ��������,
            wb_src_sel_o = 1'b0;     // ���� ���� � ����� �����
            illegal_instr_o = 1'b0;    // ����������� �
            branch_o = 1'b0;          // ������������� ����������
            jal_o = 1'b0;             // ��� ������
            jalr_o = 1'b0;
        end
        `LOAD_OPCODE: 
        begin
            mem_req_o = 1'b1;       
            case(fetched_instr_i[14:12])        
                `LDST_B: mem_size_o = 3'd0 ;
                `LDST_H:  mem_size_o = 3'd1;
                `LDST_W:  mem_size_o = 3'd2;
                `LDST_BU:  mem_size_o = 3'd4;
                `LDST_HU:  mem_size_o = 3'd5;
                default: illegal_instr_o=1'b1;
             endcase
            ex_op_a_sel_o = 2'd0;
            ex_op_b_sel_o = 3'd1;
            alu_op_o = `ALU_ADD;
            mem_we_o = 1'b0;      // always, � ����� �� ����� �����
            gpr_we_a_o = 1'b1;        // ������ ������ ��������,
            wb_src_sel_o = 1'b0;     // ���� ���� � ����� �����
            illegal_instr_o = 1'b0;    // ����������� �
            branch_o = 1'b0;          // ������������� ����������
            jal_o = 1'b0;             // ��� ������
            jalr_o = 1'b0;
        end
        `STORE_OPCODE:            
        begin
            
            case(fetched_instr_i[14:12])        
                3'd0: begin mem_we_o = 1'b1; mem_size_o = 3'd0; end
                3'd1:  begin mem_we_o = 1'b1; mem_size_o = 3'd1; end
                3'd2:  begin mem_we_o = 1'b1; mem_size_o = 3'd2; end
                default: illegal_instr_o=1'b1;
             endcase
             alu_op_o = `ALU_ADD;
             ex_op_a_sel_o = 2'd0;
             ex_op_b_sel_o = 3'd3;
             mem_req_o = 1'b0;      // always, � ����� �� ����� �����
            gpr_we_a_o = 1'b0;        // ������ ������ ��������,
            wb_src_sel_o = 1'b0;     // ���� ���� � ����� �����
            illegal_instr_o = 1'b0;    // ����������� �
            branch_o = 1'b0;          // ������������� ����������
            jal_o = 1'b0;             // ��� ������
            jalr_o = 1'b0;
        end
        `BRANCH_OPCODE:             
        begin
            ex_op_a_sel_o = 2'b00;
            ex_op_b_sel_o = 3'b000;
             case(fetched_instr_i[14:12])        
                3'd0: begin
                    branch_o=
                end
                3'd1:
                3'd4:
                3'd5:
                3'd6:
                3'd7:
                default: illegal_instr_o=1'b1;
             endcase
        end
        `JAL_OPCODE:
        begin
            jal_o = 1'b1
        end
        `JALR_OPCODE:
        begin
            jalr_o = 1'b1; 
            ex_op_a_sel_o = 2'b01;
            ex_op_b_sel_o = 3'b100;
            alu_op_o = `ALU_ADD;
            gpr_we_a_o = 1'b0; 
        end
        `LUI_OPCODE:             
            begin
            alu_op_o = `ALU_ADD;
            ex_op_a_sel_o = 2'd2;
            ex_op_b_sel_o = 3'd2;
            gpr_we_a_o= 1'b1;
            end
        `AUIPC_OPCODE:            ex_op_a_sel_o = 2'b00;
        `SYSTEM_OPCODE:            ex_op_a_sel_o = 2'b00;
        `MISC_MEM_OPCODE:            ex_op_a_sel_o = 2'b00;
    endcase
end
    
endmodule