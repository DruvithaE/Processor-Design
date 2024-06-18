module decode_64 (input clk, input E_bubble, input [3:0] D_stat, input [3:0] D_icode, input [3:0] D_ifun, input [3:0] D_rA, input [3:0] D_rB, input[63:0] D_valC ,input[63:0] D_valP, input [63:0] [0:14] R, output reg [3:0] E_stat, output reg [3:0] E_icode, output reg [3:0] E_ifun, output reg [63:0] E_valC, output reg [63:0] E_valA, output reg [63:0] E_valB, output reg [3:0] E_dstE, output reg [3:0] E_dstM, output reg [3:0] E_srcA, output reg [3:0] E_srcB, input [63:0] W_valE, input [63:0] W_valM, input [63:0] m_valM, input [63:0] M_valA, input [63:0] M_valE, input [63:0] e_valE, output reg [3:0] d_srcA, output reg [3:0] d_srcB, input [3:0] e_dstE, input [3:0] M_dstM, input [3:0] M_dstE, input [3:0] W_dstM, input [3:0] W_dstE);
    
    reg [63:0] d_valA, d_valB, d_valC, d_origvalA, d_origvalB;
    reg [3:0] d_dstE, d_dstM, d_icode, d_ifun, d_stat;

    always @(posedge clk)
    begin
        d_srcA = 4'hF;
        d_srcB = 4'hF;
        d_dstE = 4'hF;
        d_dstM = 4'hF;

        d_stat = D_stat;
        d_icode = D_icode;
        d_ifun  = D_ifun;
        d_valC = D_valC;


        // halt -> do nothing

        // nop -> do nothing

        // cmovxx
        if(D_icode == 4'b0010)
        begin
            d_origvalA=R[D_rA];
            d_origvalB = 0;
            d_srcA = D_rA;
            d_dstE = D_rB;
        end

        //irmovq
        else if(D_icode == 4'b0011) 
        begin
            d_dstE = D_rB;
        end

        //rmmovq
        else if(D_icode == 4'b0100)
        begin
            d_origvalA = R[D_rA];
            d_origvalB = R[D_rB];
            d_srcA = D_rA;
            d_srcB = D_rB;
        end

        //mrmovq
        else if (D_icode == 4'b0101)
        begin
            d_origvalB = R[D_rB];
            d_srcB = D_rB;
            d_dstM = D_rA;
        end

        //opq
        else if(D_icode == 4'b0110)
        begin
            d_origvalA = R[D_rA];
            d_origvalB = R[D_rB];
            d_srcA = D_rA;
            d_srcB = D_rB;
            d_dstE = D_rB; 
        end

        //jxx -> do nothing

        //call
        else if(D_icode == 4'b1000) 
        begin
            d_origvalB = R[4];
            d_srcB = 4;
            d_dstE = 4;
        end

        // ret
        else if(D_icode == 4'b1001) 
        begin
            d_origvalA = R[4];
            d_origvalB = R[4];
            d_srcA = 4;
            d_srcB = 4;
            d_dstE = 4;
        end

        //push
        else if (D_icode == 4'b1010) 
        begin
            d_origvalA = R[D_rA];
            d_origvalB = R[4];
            d_srcA = D_rA;
            d_srcB = 4;
            d_dstE = 4;
        end

        //pop
        else if(D_icode == 4'b1011) 
        begin
            d_origvalA = R[4];
            d_origvalB = R[4]; 
            d_srcA = 4;
            d_srcB = 4;
            d_dstE = 4;
            d_dstM = D_rA;
        end

        if(D_icode==4'b0111 | D_icode == 4'b1000) //jxx or call 
            d_origvalA = D_valP;

    end

    always @(negedge clk) begin

        if(e_dstE != 4'b1111 && d_srcA == e_dstE) 
        begin
            $display("DATA FORWARDING");
            d_valA = e_valE;
        end
        else if(M_dstM != 4'b1111 & d_srcA == M_dstM)
        begin
            d_valA = m_valM; 
            $display("DATA FORWARDING");
        end
        else if(W_dstM != 4'b1111 & d_srcA == W_dstM)
        begin
            d_valA = W_valM; 
            $display("DATA FORWARDING");
        end
        else if(M_dstE != 4'b1111 & d_srcA == M_dstE) 
        begin
            $display("DATA FORWARDING");
            d_valA = M_valE; 
        end
        else if(W_dstE!=4'b1111 & d_srcA==W_dstE) 
        begin
            d_valA = W_valE; 
            $display("DATA FORWARDING");
        end
        else begin
            // $display("DATA FORWA----------d_srcA = %b; e_dstE = %b-----------------------------------------------------------", d_srcA, e_dstE);
            d_valA = d_origvalA;
        end

        // Fwd B
        if(e_dstE != 4'hF & d_srcB == e_dstE)      
            d_valB = e_valE; 
        else if(M_dstM != 4'hF & d_srcB == M_dstM) 
            d_valB = m_valM; 
        else if(W_dstM != 4'hF & d_srcB == W_dstM) 
            d_valB = W_valM; 
        else if(M_dstE != 4'hF & d_srcB == M_dstE) 
            d_valB = M_valE; 
        else if(W_dstE != 4'hF & d_srcB == W_dstE) 
            d_valB = W_valE; 
        else
            d_valB = d_origvalB; 
        if(E_bubble)  // no op
        begin
            E_stat <= 4'b0001;
            E_icode <= 4'b0001;
            E_ifun <= 4'b0000;
            E_valC <= 4'b0000;
            E_valA <= 4'b0000;
            E_valB <= 4'b0000;
            E_dstE <= 4'hF;
            E_dstM <= 4'hF;
            E_srcA <= 4'hF;
            E_srcB <= 4'hF;

        end  
        else
        begin
            E_stat <= d_stat;
            E_icode<= d_icode;
            E_ifun <= d_ifun;
            E_valC <= d_valC;
            E_valA <= d_valA;
            E_valB <= d_valB;
            E_dstE <= d_dstE;
            E_dstM <= d_dstM;
            E_srcA <= d_srcA;
            E_srcB <= d_srcB;
        end 
    end
endmodule