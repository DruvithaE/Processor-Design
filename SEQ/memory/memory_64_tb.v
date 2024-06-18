`include "memory_64.v"

module memory_64_tb;
    integer i;

    reg clk;
    reg [3:0] icode;
    reg [63:0] valE, valA, valP;
    wire [63:0] valM;

    reg [7:0] [0:1023] Min;
    wire [7:0] [0:1023] Mout;

    memory_64 uut3 (clk, Min, icode, valE, valA, valP, valM,Mout);

    initial begin
        $dumpfile("memory_output.vcd");
        $dumpvars(0,memory_64_tb);
        i = 0;
        for (i=0; i<1024; i=i+1) begin
            Min[i] = i;
        end
    end

    always #5 clk = ~clk;

    always @(*) begin
        for (i=0; i<1024; i=i+1) begin
            Min[i] <= Mout[i];
        end
    end 


    initial begin

        clk = 1'b0; 

        valP = 64'd112;
        valE = 64'd100;
        valA = 64'd17;

        icode = 4'd0;

        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd1;

        #10;
        valP = 64'd11;
        valE = 64'd22;
        valA = 64'd33;

        icode = 4'd2;

        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd3; 
        
        #10;
        valP = 64'd11;
        valE = 64'd22;
        valA = 64'd33;

        icode = 4'd4; 
        
        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd5; 
        
        #10;
        valP = 64'd11;
        valE = 64'd22;
        valA = 64'd33;

        icode = 4'd6; 
        
        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd7; 

        #10;
        valP = 64'd11;
        valE = 64'd22;
        valA = 64'd33;

        icode = 4'd8;

        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd9;

        #10;
        valP = 64'd11;
        valE = 64'd22;
        valA = 64'd33;

        icode = 4'd10;

        #10;
        valP = 64'd1;
        valE = 64'd2;
        valA = 64'd3;

        icode = 4'd11; #10;

        $finish;
    end
    
endmodule