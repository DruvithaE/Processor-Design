module memory_64(input clk, input [63:0] [0:1023] Min, input [3:0] icode, input [63:0] valE, input [63:0] valA, input [63:0] valP, output reg [63:0] valM,  output reg [63:0] [0:1023] M);

    integer i;
    reg [63:0] Mo [0:1023];

    always@(*)
    begin
        for (i=0; i<1024; i=i+1) begin
            Mo[i] = Min[i];
        end
        case (icode)
            4'b0100: begin
                Mo[valE] = valA;  // rmmovq
                // $display("icode: %4b Mem allocated %d at valE", icode,valA, valE);
            end
            4'b0101: begin
                valM = Mo[valE];  // mrmovq
                // $display("icode: %4b Value read %d from valE %d",icode,valM, valE);
            end
            4'b1000: begin 
                Mo[valE] = valP;  // call
                // $display("icode: %4b Mem allocated %d at valE", icode,valP, valE);
            end
            4'b1001: begin 
                valM = Mo[valA];  // ret
                // $display("icode: %4b Value read %d",icode,valM);
            end
            4'b1010: begin 
                Mo[valE] = valA;  // pushq
                // $display("icode: %4b Mem allocated %d at valE", icode,valA, valE);
            end
            4'b1011: begin 
                valM = Mo[valA];  // popq
                // $display("icode: %4b Value read %d",icode,valM);
            end
            default: ;
        endcase
        for (i=0; i<1024; i=i+1) begin
            M[i] = Mo[i];
        end
    end

endmodule