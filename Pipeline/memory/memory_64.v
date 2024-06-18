module memory_64 (input clk, input [63:0] [0:1023] Min, output reg [63:0] [0:1023] Mout, input [3:0] M_stat, input [3:0] M_icode, input M_cnd, input [63:0] M_valE, input [63:0] M_valA, input [3:0] M_dstE, input [3:0] M_dstM, output reg [3:0] W_stat, output reg [3:0] W_icode, output reg [63:0] W_valE, output reg [63:0] W_valM, output reg [3:0] W_dstE, output reg [3:0] W_dstM, output reg [63:0] m_valM, output reg [3:0] m_stat);
  
    reg dmem_error = 0;
    integer i;

    // always@(*)
    // begin
        // $display("HERE IN MEM");
        // for (i=0; i<1024; i=i+1) begin
        //     Mout[i] = Min[i];
        // end
        // if(dmem_error == 1) begin
        //     m_stat[0] = M_stat[0];
        //     m_stat[1] = M_stat[1];
        //     m_stat[2] = 1;
        //     m_stat[3] = M_stat[3];
        // end
        // else begin
        //     m_stat = M_stat;
        // end
        // $display("Done IN MEM");
    // end
    
    always@(posedge clk)
    begin
        for (i=0; i<1024; i=i+1) begin
            Mout[i] = Min[i];
        end
        
        case (M_icode)
            4'b0000: ;     // halt -> do nothing
            4'b0001: ;     // nop -> do nothing
            4'b0010: ;     // cmov -> do nothing
            4'b0011: ;     // irmov -> do nothing
            4'b0100: begin     // rmmov
                if (M_valE > 1023)
                    dmem_error = 1;
                else
                    Mout[M_valE] = M_valA;
            end
            4'b0101: begin     // mrmov
                if (M_valE > 1023)
                    dmem_error = 1;
                else
                    m_valM = Mout[M_valE];
            end
            4'b0110: ;     // opq -> do nothing
            4'b0111: ;     // jxx -> do nothing
            4'b1000: begin     // call
                if (M_valE > 1023)
                    dmem_error = 1;
                else
                    Mout[M_valE] = M_valA;
            end
            4'b1001: begin     // ret
                if (M_valA > 1023)
                    dmem_error = 1;
                else
                    m_valM = Mout[M_valA];
            end
            4'b1010: begin     // push
                if (M_valE > 1023)
                    dmem_error = 1;
                else
                    Mout[M_valE] = M_valA;
            end
            4'b1011: begin     // pop
                if (M_valA > 1023)
                    dmem_error = 1;
                else
                    m_valM = Mout[M_valA];
            end
            


        endcase
        if(dmem_error == 1) begin
                m_stat[0] = M_stat[0];
                m_stat[1] = M_stat[1];
                m_stat[2] = 1;
                m_stat[3] = M_stat[3];
        end
        else begin
            m_stat = M_stat;
        end
    end

    always@(negedge clk)
    begin
        W_stat <= m_stat;
        W_icode<= M_icode;
        W_valE <= M_valE;
        W_valM <= m_valM;
        W_dstE <=  M_dstE;
        W_dstM <=  M_dstM;
    end
    
endmodule