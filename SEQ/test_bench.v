`include "decode/decode_64.v"
`include "fetch/fetch_64.v"
`include "execute/execute_64.v"
`include "pcupdate/pcupdate_64.v"
`include "memory/memory_64.v"
`include "writeback/writeback_64.v"


module testbench;
    reg [7:0] IM[0:61]; 
    reg [0:79] instruction; reg [63:0] PC; reg clk;
    wire [3:0] icode; wire [3:0] ifun; wire [3:0] rA; wire [3:0] rB; wire [63:0] valC; wire [63:0] valP; wire imem_error; wire instr_valid ;
    reg [63:0] [0:14] R;
    wire [63:0] valA;
    wire [63:0] valB;
    reg [7:0] fder;

    reg [2:0] cndnflagin; 
    wire [2:0] cndnflagout ; 
    wire [63:0] valE ; 
    wire cndn;

    wire [63:0] valM;
    reg [63:0] [0:1023] Min;
    wire [63:0] [0:1023] Mout; 
    wire [63:0] [0:14] Regout;
    
    reg cnd;
    wire [63:0] new_pc;

    fetch_64 fetch4(instruction, PC, clk, icode, ifun, rA, rB, valC, valP, imem_error, instr_valid);

    decode_64 decode4 (clk, icode, rA, rB, R, valA, valB);

    execute_64 execute4(clk, icode, ifun, valA, valB, valC, cndnflagin, cndnflagout, valE, cndn);

    memory_64 memory4 (clk, Min, icode, valE, valA, valP, valM, Mout);

    writeback_64 writeback4(icode,ifun,rA,rB,valA,valB,valE,valM,clk,R,Regout, cndn);

    pc_update_64 pc_update4 (clk, icode, valC, valM, valP, cndn, new_pc);


    integer fp;
    integer i;
    integer j;
    // reg [7:0] line[0:31];
    integer lineCount;
    reg [7:0] character;

    always #15 begin
        clk = (clk==1) ? 0: 1;
    end

    initial begin
         fp = $fopen("../SampleTestcase/2.txt", "r");
        if (fp == 0) begin
            $display("Error opening file");
            $finish;
        end
        lineCount = 1;
        while (!$feof(fp)) begin
            character = $fgetc(fp);
            if (character == 10) begin
                lineCount = lineCount + 1;
            end
        end
        $fclose(fp);
        $display("Number of lines in the file: %0d", lineCount);
        // $monitor($time,"ns, icode:ifun : = %d:%d rA=%d rB=%d,valC=%d,PC=%d \t valA:%d;  valB:%d\n valE= %d, cndn = %d, cndnflagout = %b  valM = %b (%d) \n",clk,icode,ifun,rA,rB,valC,PC,valA,valB,valE,cndn, cndnflagout, valM, valM,$time, "\nclk:%d\nrA:%d rB:%d icode:%d\n valA:%d valB:%d valE:%d valM:%d\n R[0]: %d  R[1]: %d   R[2] : %d\n R[3]: %d  R[4] : %d   \n R[5]: %d   R[6] : %d    R[7]: %d\n   R[8] : %d   R[9]: %d   R[10]: %d\n R[11]: %d    R[12]: %d   R[13] : %d  R[14] : %d\n", 
        // clk, rA,rB,icode,valA,valB,valE,valM,Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14]);
$monitor($time,"ns   FETCH ---> icode:ifun = %d:%d rA=%d rB=%d,valC=%d \n\t\t\t DECODE --> valA:%d;  valB:%d\n\t\t\t EXECUTE--> valE:%d, cndn = %d, cndnflagout = %b \n\t\t\t MEMORY --> valM:%d\n\t\t\t WRITEBACK--> R0:%d, R1:%d, R2:%d, R3:%d, R4:%d, R5:%d, R6:%d, R7:%d, R8:%d, R9:%d, R10:%d, R11:%d, R12:%d, R13:%d, R14:%d \n\t\t\t PC UPD --> PC:%d \n\n ", icode, ifun, rA, rB, valC, valA, valB, valE, cndn, cndnflagout, valM, Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14], PC);        clk = 1'b0;
        // fp = $fopen("../SampleTestcase/1.txt", "r");
        // if (fp == 0) begin
        //     $display("Error: Could not open file");
        //     $finish;
        // end
        $readmemb("../SampleTestcase/2.txt", IM);
        j = 0;
        for (j=0; j<62; j= j+1) begin
            $display("%b",IM[j]);
        end
        // $fclose(fp);

        PC = 8'b0;
        R[0] = 64'd9;
        R[1] = 64'd8;
        R[2] = 64'd7;
        R[3] = 64'd6;
        R[4] = 64'd9;
        R[5] = 64'd4;
        R[6] = 64'd3;
        R[7] = 64'd2;
        R[8] = 64'd1;
        R[9] = 64'd10;
        R[10] = 64'd12;
        R[11] = 64'd13;
        R[12] = 64'd14;
        R[13] = 64'd15;
        R[14] = 64'd16;


        // IM[0] = 8'b00110000;
        // IM[1] = 8'b11110011;
        // IM[2] = 8'b00000000;
        // IM[3] = 8'b00000001;
        // IM[4] = 8'b00000000;
        // IM[5] = 8'b00000000;
        // IM[6] = 8'b00000000;
        // IM[7] = 8'b00000000;
        // IM[8] = 8'b00000000;
        // IM[9] = 8'b00000000;
        // IM[10] = 8'b00110000;
        // IM[11] = 8'b11110010;
        // IM[12] = 8'b00000000;
        // IM[13] = 8'b00000010;
        // IM[14] = 8'b00000000;
        // IM[15] = 8'b00000000;
        // IM[16] = 8'b00000000;
        // IM[17] = 8'b00000000;
        // IM[18] = 8'b00000000;
        // IM[19] = 8'b00000000;
        // IM[20] = 8'b01100000;
        // IM[21] = 8'b00100011;
    end

    reg p;
    always @(icode) begin
        p = (icode != 4'b0) ? 1'b0 : 1'b1;
        if (p == 1'b1) begin
            $finish;
        end
    end

    always@(PC) begin
        if (PC > 63) begin
            $finish;
        end
        instruction = { IM[PC] , IM[PC+1] , IM[PC+2] , IM[PC+3] , IM[PC+4] , IM[PC+5] , IM[PC+6] , IM[PC+7] , IM[PC+8] , IM[PC+9]};
    end 

    always @(*) begin

        PC <= new_pc;
        for (i=0; i<1024; i=i+1) begin
            Min[i] = Mout[i];
        end
        
    end

    always @(imem_error) begin
    if(imem_error == 1 || instr_valid == 0)
        $monitor("Wrong instruction address detected\n");
        end

    always @(*)
    begin
        if(icode == 4'b0110) begin
                for (i=0;i<3;i=i+1) begin
                        cndnflagin[i] = cndnflagout[i] ;
                    end
            end
        for (i=0;i<15;i=i+1) begin
            R[i] = Regout[i] ;
        end
    end

endmodule
