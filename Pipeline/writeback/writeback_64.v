module writeback_64(input clk, input [3:0] W_stat, input [3:0] W_icode, input [63:0] W_valE, input [63:0] W_valM, input [3:0] W_dstE, input [3:0] W_dstM, input [63:0] [0:14] Regin , output reg [63:0] [0:14] Regout, input cnd);

    reg [3:0] i;
    always@(posedge clk)
    begin
        for (i=0;i<15;i=i+1) begin
            Regout[i] = Regin[i] ;
        end
        case (W_icode)
            4'b0000: ;     // halt -> do nothing
            4'b0001: ;     // nop -> do nothing
            4'b0010: begin     // cmov
                if (cnd)
                    Regout[W_dstE] = W_valE;
            end
            4'b0011: begin     // irmov
                Regout[W_dstE] = W_valE;
            end
            4'b0100: ;     // rmmov -> don nothing
            4'b0101: begin     // mrmov
                Regout[W_dstM] = W_valM;
            end
            4'b0110: begin     // opq 
                $display("YOYO %b %b",W_dstE, W_valE);
                Regout[W_dstE] = W_valE;
            end
            4'b0111: ;     // jxx -> do nothing
            4'b1000: begin     // call
                Regout[W_dstE] = W_valE;
            end
            4'b1001: begin     // ret
                Regout[W_dstE] = W_valE;
            end
            4'b1010: begin     // push
                Regout[W_dstE] = W_valE;
            end
            4'b1011: begin     // pop
                Regout[W_dstE] = W_valE;
                Regout[W_dstM] = W_valM;
            end
        endcase
end

endmodule