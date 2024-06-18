`include "decode_64.v"

module decode_64_tb;

    reg clk;
    reg [3:0] icode;
    reg [3:0] rA, rB;
    reg [63:0] [0:14] R;
    wire [63:0] valA;
    wire [63:0] valB;

    decode_64 uut1 (clk, icode, rA, rB, R, valA, valB);

    initial begin
        $dumpfile("decode_output.vcd");
        $dumpvars(0,decode_64_tb);
    end

    always #5 clk = ~clk;

    initial begin
        $monitor($time,"ns: icode:%d \t rA:%d;  rB:%d \t valA:%d;  valB:%d", icode,rA,rB,valA,valB); 

        R[0] = 64'd999;
        R[1] = 64'd888;
        R[2] = 64'd777;
        R[3] = 64'd666;
        R[4] = 64'd555;
        R[5] = 64'd444;
        R[6] = 64'd333;
        R[7] = 64'd222;
        R[8] = 64'd111;
        R[9] = 64'd10;
        R[10] = 64'd20;
        R[11] = 64'd30;
        R[12] = 64'd40;
        R[13] = 64'd50;
        R[14] = 64'd60;

        clk = 1'b1; 

        icode = 4'd0;
        rA = 4'd1;
        rB = 4'd12;

        #10;
        icode = 4'd1;
        rA = 4'd0;
        rB = 4'd2;

        #10;
        icode = 4'd2;
        rA = 4'd10;
        rB = 4'd1;

        #10;
        rA = 4'd13;
        rB = 4'd12;
        icode = 4'd3; 
        
        #10;
        rA = 4'd2;
        rB = 4'd3;
        icode = 4'd4; 
        
        #10;
        rA = 4'd13;
        rB = 4'd5;
        icode = 4'd5; 
        
        #10;
        rA = 4'd10;
        rB = 4'd7;
        icode = 4'd6; 
        
        #10;
        rA = 4'd6;
        rB = 4'd7;
        icode = 4'd7; 

        #10;
        rA = 4'd13;
        rB = 4'd7;
        icode = 4'd8;

        #10;
        rA = 4'd11;
        rB = 4'd12;
        icode = 4'd9;

        #10;
        rA = 4'd5;
        rB = 4'd2;
        icode = 4'd10;

        #10;
        rA = 4'd1;
        rB = 4'd7;
        icode = 4'd11;

        $finish;
    end
    
endmodule