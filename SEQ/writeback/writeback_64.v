module writeback_64( input [3:0] icode, input [3:0] ifun, input [3:0] rA, input [3:0] rB, input [63:0] valA, input [63:0] valB , input [63:0] valE , input [63:0] valM , input clk , input [63:0] [0:14] Regin , output reg [63:0] [0:14] Reg, input cnd);

    reg [63:0] Regout [0:14];
    reg [3:0] i;

    always@(*) begin
        for (i=0;i<15;i=i+1) begin
            Regout[i] = Regin[i] ;
        end
        
    case(icode)
            4'b0010:
                begin
                    if (cnd)
                        Regout[rB] = valE; // cmovxx 
                end
            4'b0011:
                begin 
                    Regout[rB] = valE; // irmovq 
                end
            4'b0101:
                begin 
                    Regout[rA] = valM; // mrmovq 
                end
            4'b0110:
                begin
                    Regout[rB] = valE; // opq
                end
            4'b1000:
                begin
                   Regout[4] = valE; // call 
                end
            4'b1001:
                begin
                   Regout[4] = valE; // ret 
                end
            4'b1010:
                begin
                   Regout[4] = valE; // pushq 
                end
            4'b1011:
                begin
                    Regout[4] = valE;
                    Regout[rA] = valM;  // popq 
                end

    endcase
    for (i = 0; i < 15; i = i + 1) begin
            Reg[i] = Regout[i];
        end
    end
    
endmodule

