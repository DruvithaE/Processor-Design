module pc_update_64 (input clk, input [3:0] icode, input [63:0] valC, input [63:0] valM, input [63:0] valP, input cnd, output reg [63:0] new_pc);

    always@(*)
    begin
        case (icode)
            4'b0000: new_pc = 63'b0;  // halt
            4'b0001: new_pc = valP;   // nop
            4'b0010: new_pc = valP;   // cmovXX
            4'b0011: new_pc = valP;   // irmovq
            4'b0100: new_pc = valP;   // rmmovq
            4'b0101: new_pc = valP;   // mrmovq
            4'b0110: new_pc = valP;   // Opq
            4'b0111: begin            // jXX
                if(cnd == 1)
                    new_pc = valC;
                else
                    new_pc = valP;
            end
            4'b1000: new_pc = valC;   // call
            4'b1001: new_pc = valM;   // ret
            4'b1010: new_pc = valP;   // pushq
            4'b1011: new_pc = valP;   // popq
            default: new_pc = valP;
        endcase
    end

endmodule