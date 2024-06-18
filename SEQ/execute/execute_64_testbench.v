`include "execute_64.v"

module execute_64_tb();

    reg [3:0] icode;
    reg [3:0] ifun; 
    reg [63:0] valA; 
    reg [63:0] valB ; 
    reg [63:0] valC ; 
    reg [2:0] cndnflagin; 
    wire [2:0] cndnflagout ; 
    wire [63:0] valE ; 
    wire cndn;
    reg [3:0] i;
    reg clk;

    execute_64 execute1(clk, icode, ifun, valA, valB, valC, cndnflagin, cndnflagout, valE, cndn);

    always #15 begin
        clk = (clk==1) ? 0: 1;
    end

    initial begin

        $monitor($time,"ns   EXECUTE--> valE:%d, cndn = %d, cndnflagout = %b \n" ,valE, cndn, cndnflagout);

        clk =1'b0;
        
        #10
        icode = 4'b0010;
        ifun = 4'b0011;
        valC = 64'h0000_0000_011;
        valA = 64'd5;
        valB = 3'b000;
        #10
        icode = 4'b0110;
        ifun = 4'b0000;
        valA = 64'd5;
        valB = 3'd3;
        #10
        icode = 4'b1010;
        ifun = 4'b0011;
        valC = 64'h0000_0000_011;
        valA = 64'd8;
        valB = 3'b000;
        #10
        icode = 4'b0110;
        ifun = 4'b0001;
        valA = 64'd8;
        valB = 64'd8;
        #10
        icode = 4'b0111;
        ifun = 4'b0011;
        valC = 64'h0000_0000_011;
        valA = 64'd5;
        valB = 3'b000;
        #2;
        $finish   ;     

    end

    always @(*)
        begin
            if(icode == 4'b0110) begin
                for (i=0;i<3;i=i+1) begin
                        cndnflagin[i] = cndnflagout[i] ;
                    end
            end
        end




endmodule
