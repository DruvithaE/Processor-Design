`include "pcupdate_64.v"

module pcupdate_64_tb;

    reg clk;
    reg [3:0] icode;
    reg cnd;
    reg [63:0] valC, valM, valP;
    wire [63:0] new_pc;

    pc_update_64 uut2 (clk, icode, valC, valM, valP, cnd, new_pc);

    initial begin
        $dumpfile("pcupdate_output.vcd");
        $dumpvars(0,pcupdate_64_tb);
    end

    always #5 clk = ~clk;

    initial begin
        $monitor($time,"ns: icode:%d \t new-pc: %d", icode,new_pc); 

        clk = 1'b1; 
        cnd = 1'b1;

        valP = 64'd112;
        valC = 64'd100;
        valM = 64'd17;

        icode = 4'd0;

        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd1;

        #10;
        valP = 64'd11;
        valC = 64'd22;
        valM = 64'd33;

        icode = 4'd2;

        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd3; 
        
        #10;
        valP = 64'd11;
        valC = 64'd22;
        valM = 64'd33;

        icode = 4'd4; 
        
        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd5; 
        
        #10;
        valP = 64'd11;
        valC = 64'd22;
        valM = 64'd33;

        icode = 4'd6; 
        
        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd7; 

        #10;
        valP = 64'd11;
        valC = 64'd22;
        valM = 64'd33;

        icode = 4'd8;

        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd9;

        #10;
        valP = 64'd11;
        valC = 64'd22;
        valM = 64'd33;

        icode = 4'd10;

        #10;
        valP = 64'd1;
        valC = 64'd2;
        valM = 64'd3;

        icode = 4'd11; #10;

        $finish;
    end
    
endmodule