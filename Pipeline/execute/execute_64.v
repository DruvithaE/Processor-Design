`include "../ALU/alu.v"
// `include "alu.v"
module execute_64(input clk, input [3:0] E_icode, input [3:0] E_ifun, input [63:0] E_valA, input [63:0] E_valB , input [63:0] E_valC , input [2:0] E_cndnflagin, input [3:0] E_stat, input [3:0] E_dstE, input [3:0] E_dstM, output reg [2:0] e_cndnflagout , output reg [63:0] valE, output reg [63:0] M_valE , output reg e_cndn, output reg [3:0] e_stat, output reg [3:0] e_icode, output reg [3:0] e_dstE, output reg [3:0] M_dstE, output reg [3:0] e_dstM, output reg [63:0] e_valA );

    wire zeroflag;
    wire signedflag;
    wire overflowflag;

    assign zeroflag = E_cndnflagin[0];
    assign signedflag = E_cndnflagin[1];
    assign overflowflag = E_cndnflagin[2];

    reg [3:0] icode;
    reg [3:0] dstM;
    reg [63:0] valA;
    reg [3:0] stat;
    always@(posedge clk) begin
        stat = E_stat;
        icode = E_icode;
        dstM = E_dstM;
        valA = E_valA;

        if (E_icode == 4'b0010 || E_icode == 4'b0111 ) begin // only for jmpxx and cmovxx
            case(E_ifun)
                4'b0000:
                    begin
                        e_cndn = 1'b1; // as it is universal.
                    end
                4'b0001:
                    begin
                        e_cndn = (signedflag^overflowflag)| zeroflag; // lessthan equal to.
                    end
                4'b0010:
                    begin
                        e_cndn = overflowflag ^ signedflag; // less than.
                    end
                4'b0011:
                    begin
                        e_cndn = zeroflag; // equal
                    end
                4'b0100:
                    begin
                        e_cndn = ~ zeroflag; // not equal
                    end
                4'b0101:
                    begin
                        e_cndn = ~ (overflowflag ^ signedflag) ; // greater than equal to.
                    end
                4'b0110:
                    begin
                        e_cndn = ~( (signedflag^overflowflag)| zeroflag ); // greater than.
                    end    
            endcase
            if ( icode == 4'b0010)
                begin
                    e_dstE = e_cndn ? E_dstE : 4'hF;
                end
            else
                e_dstE = E_dstE;
        end
        else begin
            e_cndn = 0;
            e_dstE = E_dstE;
        end
    end
    wire of1,of2;
    wire [63:0] Opq_valE;
    wire [63:0] Stkinc_valE;
    wire [63:0] Stkdec_valE;
    wire [63:0] Movq_valE;

    ALU alu2(E_valB, E_valA,E_ifun[1:0], Opq_valE, of2 );
    ALU alu3( 64'd8, E_valB, 2'b00, Stkinc_valE, of1 );
    ALU alu4( E_valB, 64'd8,2'b01, Stkdec_valE, of1 ); 
    ALU alu5( E_valC, E_valB, 2'b00, Movq_valE, of1);

    always@(posedge clk) begin
        case(E_icode)
            4'b0010:
                valE = E_valA; 
            4'b0011: begin
                $display("Entered heren correct");
                valE = E_valC;
            end
            4'b0100:
                valE = Movq_valE;
            4'b0101:
                valE = Movq_valE;
            4'b0110: begin
                valE = Opq_valE;
                e_cndnflagout[0] <= (valE ==0) ? 1'b1:1'b0;
                e_cndnflagout[1] <= Opq_valE[63];
                e_cndnflagout[2] <= of2;
            end
            4'b1000:
                valE = Stkdec_valE;
            4'b1001:
                valE = Stkinc_valE;
            4'b1010:
                valE = Stkdec_valE;
            4'b1011:
                valE = Stkinc_valE;      
            default:
                valE = 64'b0;      
        endcase
    end

    always@(negedge clk) begin
        e_stat <= stat;
        e_icode <= icode;
        e_dstM <= dstM;
        e_valA <= valA;
        // $display("Entered here\n");
        M_dstE <= e_dstE;
        M_valE <= valE;
    end
endmodule




