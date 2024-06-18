`include "../ALU/alu.v"
// `include "alu.v"
module execute_64(input clk, input [3:0] icode, input [3:0] ifun, input [63:0] valA, input [63:0] valB , input [63:0] valC , input [2:0] cndnflagin, output reg [2:0] cndnflagout , output reg [63:0] valE , output reg cndn);

    wire zeroflag;
    wire signedflag;
    wire overflowflag;

    assign zeroflag = cndnflagin[0];
    assign signedflag = cndnflagin[1];
    assign overflowflag = cndnflagin[2];

    always@(*) begin
        if (icode == 4'b0010 || icode == 4'b0111 ) begin // only for jmpxx and cmovxx
            case(ifun)
                4'b0000:
                    begin
                        cndn = 1'b1; // as it is universal.
                    end
                4'b0001:
                    begin
                        cndn = (signedflag^overflowflag)| zeroflag; // lessthan equal to.
                    end
                4'b0010:
                    begin
                        cndn = overflowflag ^ signedflag; // less than.
                    end
                4'b0011:
                    begin
                        cndn = zeroflag; // equal
                    end
                4'b0100:
                    begin
                        cndn = ~ zeroflag; // not equal
                    end
                4'b0101:
                    begin
                        cndn = ~ (overflowflag ^ signedflag) ; // greater than equal to.
                    end
                4'b0110:
                    begin
                        cndn = ~( (signedflag^overflowflag)| zeroflag ); // greater than.
                    end    
            endcase
        end
        else
            cndn = 0;
    end
    wire of1,of2;
    wire [63:0] Opq_valE;
    wire [63:0] Stkinc_valE;
    wire [63:0] Stkdec_valE;
    wire [63:0] Movq_valE;

    ALU alu2(  valB, valA,ifun[1:0], Opq_valE, of2 );
    ALU alu3( 64'd8, valB, 2'b00, Stkinc_valE, of1 );
    ALU alu4( valB, 64'd8,2'b01, Stkdec_valE, of1 ); 
    ALU alu5( valC, valB, 2'b00, Movq_valE, of1);

    always@(*) begin
        case(icode)
            4'b0010:
                valE = valA; 
            4'b0011:
                valE = valC;
            4'b0100:
                valE = Movq_valE;
            4'b0101:
                valE = Movq_valE;
            4'b0110: begin
                valE = Opq_valE;
                cndnflagout[0] <= (valE ==0) ? 1'b1:1'b0;
                cndnflagout[1] <= Opq_valE[63];
                cndnflagout[2] <= of2;
            end
            4'b1000:
                valE = Stkdec_valE;
            4'b1001:
                valE = Stkinc_valE;
            4'b1010:
                valE = Stkdec_valE;
            4'b1011:
                valE = Stkinc_valE;            
        endcase
    end
endmodule



