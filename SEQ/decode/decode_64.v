module decode_64 (input clk, input [3:0] icode, input [3:0] rA, input [3:0] rB, input [63:0] [0:14] R, output reg [63:0] valA, output reg [63:0] valB);

    always @(icode)
    begin
        case (icode)
            // halt -> do nothing
            // nop -> do nothing
            4'b0010: begin   // cmovXX
                valA = R[rA];
                valB = 63'b0;
            end
            // irmovq -> do nothing
            4'b0100: begin   // rmmovq
                valA = R[rA];
                valB = R[rB];
            end
            4'b0101: begin   // mrmovq
                valB = R[rB];
            end
            4'b0110: begin   // Opq
                valA = R[rA];
                valB = R[rB];
            end
            // jXX -> do nothing
            4'b1000: begin   // call
                valB = R[4];       
            end
            4'b1001: begin   // ret
                valA = R[4];
                valB = R[4];
            end
            4'b1010: begin   // pushq
                valA = R[rA];
                valB = R[4];
            end
            4'b1011: begin   // popq
                valA = R[4];
                valB = R[4];
            end
            default: ;
        endcase

    end
endmodule