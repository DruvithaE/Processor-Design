`include "fetch_64.v"

module fetch_tb;

    reg [0:79] instruction; reg [63:0] PC; reg clk;
    wire [3:0] icode; wire [3:0] ifun; wire [3:0] rA; wire [3:0] rB; wire [63:0] valC; wire [63:0] valP; wire imem_error; wire instr_valid ;

    reg [7:0] IM[0:23];

    fetch_64 fetch1(instruction, PC, clk, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid);    

    always #15 begin
        clk = (clk==1) ? 0: 1;
    end
    
    initial
    	begin
            $dumpfile("fetch_output.vcd");
            $dumpvars(0,fetch_tb);

            $monitor($time,"ns   FETCH ---> icode:ifun = %d:%d rA=%d rB=%d,valC=%d, PC = %d \n ", icode, ifun, rA, rB, valC, PC);

            PC = 64'b0;

            clk = 1'b0;
            

            IM[0] = 8'b01100001;
            IM[1] = 8'b00100011;
            IM[2] = 8'b00100000;
            IM[3] = 8'b00110100;
            IM[4] = 8'b00110100; 
            IM[5] = 8'b01010011;
            IM[6] = 8'b00010000;
            IM[7] = 8'b00100101;
            IM[8] = 8'b00100101; 
            IM[9] = 8'b01010011;
            IM[10] = 8'b01010100;
            IM[11] = 8'b00010000;
            IM[12] = 8'b00110100;
            IM[13] = 8'b00100101; 
            IM[14] = 8'b10110011;
            IM[15] = 8'b01010100;
            IM[16] = 8'b00010000;
            IM[17] = 8'b00110100;
            IM[18] = 8'b00100101; 
            IM[19] = 8'b01010011;
            IM[20] = 8'b01010100;			
        end  

    reg p;
    always @(icode) begin
        p = (icode != 4'b0) ? 1'b0 : 1'b1;
        if (p == 1'b1) begin
            $finish;
        end
    end

    always@(PC) begin
        if (PC > 20) begin
            $finish;
        end
        instruction = { IM[PC] , IM[PC+1] , IM[PC+2] , IM[PC+3] , IM[PC+4] , IM[PC+5] , IM[PC+6] , IM[PC+7] , IM[PC+8] , IM[PC+9]};
    end 

    always @(*) begin
        PC <= valP;
    end

    always @(imem_error) begin
    if(imem_error == 1 || instr_valid == 0)
        $monitor("Wrong instruction adress detected\n");
        end

endmodule
