`include "decode/decode_64.v"
`include "fetch/fetch_64.v"
`include "execute/execute_64.v"
`include "memory/memory_64.v"
`include "writeback/writeback_64.v"


module testbench;
    reg [7:0] IM[0:100]; 
    reg [0:79] instruction; reg clk;
    reg [63:0] [0:14] R;
    wire [63:0] W_valM; wire [3:0] M_icode; wire [3:0] W_icode;
    wire M_cnd; wire [63:0] M_valA; reg [63:0] Jxx_Pred; reg Jxx_cnd; reg F_stall; reg D_bubble; reg D_stall; wire [63:0] f_PC; wire [3:0] D_icode; wire [3:0] D_ifun; wire [3:0] D_rA; 
  	wire [3:0] D_rB; wire [63:0] D_valC; wire [63:0] D_valP; wire [3:0] D_stat; reg [63:0] PC; wire [63:0] Temp_predPC;

    reg E_bubble;
    wire [3:0] E_stat;
    wire [3:0] E_icode;
    wire [3:0] E_ifun;
    wire [63:0] E_valC;
    wire [63:0] E_valA;
    wire [63:0] E_valB;
    wire [3:0] E_dstE;
    wire [3:0] E_dstM;
    wire [3:0] E_srcA;
    wire [3:0] E_srcB;
    wire [63:0] W_valE;
    wire [63:0] m_valM;
    wire [63:0] M_valE;
    wire [63:0] e_valE;
    wire [3:0] d_srcA;
    wire [3:0] d_srcB;
  	wire [3:0] e_dstE;
 		wire [3:0] M_dstM; 
  	wire [3:0] M_dstE; 
  	wire [3:0] W_dstM; 
  	wire [3:0] W_dstE;
        reg fi;
  
    wire [3:0] M_stat;
  
    wire [3:0] m_stat;
    wire [3:0] W_stat; 


    reg [2:0] E_cndnflagin;
    wire [2:0] e_cndnflagout;

    wire [63:0] valM;
    reg [63:0] [0:1023] Min;
    wire [63:0] [0:1023] Mout; 
    wire [63:0] [0:14] Regout;
    

  	fetch_64 fetch4(m_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC , clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC, Temp_predPC, fi);

  	decode_64 decode4(clk, E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC , D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE);

    execute_64 execute4(clk, E_icode, E_ifun, E_valA, E_valB , E_valC , E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout , e_valE, M_valE , M_cnd, M_stat, M_icode, e_dstE,  M_dstE, M_dstM, M_valA);

    memory_64 memory4 (clk, Min, Mout, M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat);

  	writeback_64 writeback4(clk, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd);


    integer fp;
    integer i;
    integer j;
    integer lineCount;
    reg [7:0] character;

    always #15 begin
        clk = (clk==1) ? 0: 1;
    end

    initial begin
      fi = 1'b1;
            // $dumpfile("integrated.vcd");
            // $dumpvars(0,testbench);

        fp = $fopen("../SampleTestcase/4.txt", "r");
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
        // $display("Number of lines in the file: %0d", lineCount);
				// $monitor($time,"ns   FETCH ---> icode:ifun = %d:%d rA=%d rB=%d,valC=%d \n\t\t\t DECODE --> valA:%d;  valB:%d\n\t\t\t EXECUTE--> valE:%d, cndn = %d, cndnflagout = %d \n\t\t\t MEMORY --> valM:%d\n\t\t\t WRITEBACK--> R0:%d, R1:%d, R2:%d, R3:%d, R4:%d, R5:%d, R6:%d, R7:%d, R8:%d, R9:%d, R10:%d, R11:%d, R12:%d, R13:%d, R14:%d \n\t\t\t PC UPD --> PC:%d \n\n ", icode, ifun, rA, rB, valC, valA, valB, valE, cndn, cndnflagout, valM, Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14], PC);        clk = 1'b0;
        // $monitor($time, "ns   FETCH ---> W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC , clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC, Temp_predPC ")	
        // // Inside fetch_64 module

        // $monitor($time ,"ns\n\n\nfetch_64: W_valM=%d, M_icode=%d, W_icode=%d, M_cnd=%d, M_valA=%d, Jxx_Pred=%d, Jxx_cnd=%d, F_stall=%d, D_bubble=%d, D_stall=%d, instruction=%d, PC=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, D_stat=%d, f_PC=%d,\n\n\ndecode_64: E_bubble=%d, D_stat=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, R=%d, E_stat=%d, E_icode=%d, E_ifun=%d, E_valC=%d, E_valA=%d, E_valB=%d, E_dstE=%d, E_dstM=%d, E_srcA=%d, E_srcB=%d, W_valE=%d, W_valM=%d, m_valM=%d, M_valA=%d, M_valE=%d, e_valE=%d, d_srcA=%d, d_srcB=%d, e_dstE=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d\n\n\nexecute_64: E_icode=%d, E_ifun=%d, E_valA=%d, E_valB=%d, E_valC=%d, E_cndnflagin=%d, E_stat=%d, E_dstE=%d, E_dstM=%d, e_cndnflagout=%d, e_valE=%d, M_valE=%d, M_cnd=%d, M_stat=%d, M_icode=%d, e_dstE=%d, M_dstE=%d, M_dstM=%d, M_valA=%d\n\n\nmemory_64: M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, M_dstE=%d, M_dstM=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, m_valM=%d, m_stat=%d\n\n\nwriteback_64: W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, R=%d, Regout=%d, M_cnd=%d\n ------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
        //     W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC,
        //      E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE,
        //     E_icode, E_ifun, E_valA, E_valB, E_valC, E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout, e_valE, M_valE, M_cnd, M_stat, M_icode, e_dstE, M_dstE, M_dstM, M_valA,
        //     M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat,
        //      W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd);

// $monitor($time ,"ns\n\n\nfetch_64: W_valM=%d, M_icode=%d, W_icode=%d, M_cnd=%d, M_valA=%d, Jxx_Pred=%d, Jxx_cnd=%d, F_stall=%d, D_bubble=%d, D_stall=%d, instruction=%d, PC=%d, clk=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, D_stat=%d, f_PC=%d, Temp_predPC=%d\n\n\ndecode_64: clk=%d, E_bubble=%d, D_stat=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, R=%d, E_stat=%d, E_icode=%d, E_ifun=%d, E_valC=%d, E_valA=%d, E_valB=%d, E_dstE=%d, E_dstM=%d, E_srcA=%d, E_srcB=%d, W_valE=%d, W_valM=%d, m_valM=%d, M_valA=%d, M_valE=%d, e_valE=%d, d_srcA=%d, d_srcB=%d, e_dstE=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d\n\n\nexecute_64: clk=%d, E_icode=%d, E_ifun=%d, E_valA=%d, E_valB=%d, E_valC=%d, E_cndnflagin=%d, E_stat=%d, E_dstE=%d, E_dstM=%d, e_cndnflagout=%d, e_valE=%d, M_valE=%d, M_cnd=%d, M_stat=%d, M_icode=%d, e_dstE=%d, M_dstE=%d, M_dstM=%d, M_valA=%d\n\n\nmemory_64: clk=%d, M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, M_dstE=%d, M_dstM=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, m_valM=%d, m_stat=%d\n\n\nwriteback_64: clk=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, R=%d, Regout=%d, M_cnd=%d",
//         clk, W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC, clk, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC, Temp_predPC, clk, E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE, clk, E_icode, E_ifun, E_valA, E_valB, E_valC, E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout, e_valE, M_valE, M_cnd, M_stat, M_icode, e_dstE, M_dstE, M_dstM, M_valA, clk, M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat, clk, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd);

        // $display($time ,"ns INS : %d, PC: %d", instruction, PC);
        // $monitor($time, " clk %d", clk);
        // $monitor("rbx - %d, rdx - %d", Regout[3], Regout[2]);

        $readmemb("../SampleTestcase/4.txt", IM);
        // j = 0;
        // for (j=0; j<23; j= j+1) begin
        //     $display("%d",IM[j]);
        // end

        clk = 1'b0;
        PC = 8'b0; 
      // $monitor("clk %d", clk);
        // instruction = {IM[PC] , IM[PC+1] , IM[PC+2] , IM[PC+3] , IM[PC+4] , IM[PC+5] , IM[PC+6] , IM[PC+7] , IM[PC+8] , IM[PC+9]};
        // $monitor($time ,"ns INS : %d, PC: %d", instruction, PC);
      // $monitor("\n\n\n\n",$time ,"ns\n\n\nPC: %d  \nfetch_64: W_valM=%d, M_icode=%d, W_icode=%d, M_cnd=%d, M_valA=%d, Jxx_Pred=%d, Jxx_cnd=%d, F_stall=%d, D_bubble=%d, D_stall=%d, \ninstruction=%b, PC=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, D_stat=%d, f_PC=%d,temp pc = %d,\n\n\ndecode_64: E_bubble=%d, D_stat=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, R=%d, E_stat=%d, E_icode=%d, E_ifun=%d, E_valC=%d, E_valA=%d, E_valB=%d, E_dstE=%d, E_dstM=%d, E_srcA=%d, E_srcB=%d, W_valE=%d, W_valM=%d, m_valM=%d, M_valA=%d, M_valE=%d, e_valE=%d, d_srcA=%d, d_srcB=%d, e_dstE=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d\n\n\nexecute_64: E_icode=%d, E_ifun=%d, E_valA=%d, E_valB=%d, E_valC=%d, E_cndnflagin=%d, E_stat=%d, E_dstE=%d, E_dstM=%d, e_cndnflagout=%d, e_valE=%d, M_valE=%d, M_cnd=%d, M_stat=%d, M_icode=%d, e_dstE=%d, M_dstE=%d, M_dstM=%d, M_valA=%d\n\n\nmemory_64: M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, M_dstE=%d, M_dstM=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, m_valM=%d, m_stat=%d\n\n\nwriteback_64: W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, R=%d, Regout=%d, M_cnd=%d\n ------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
      //       PC,W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC, Temp_predPC,
      //        E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE,
      //       E_icode, E_ifun, E_valA, E_valB, E_valC, E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout, e_valE, M_valE, M_cnd, M_stat, M_icode, e_dstE, M_dstE, M_dstM, M_valA,
      //       M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat,
      //        W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd, "\nR0:%d, R1:%d, R2:%d, R3:%d, R4:%d, R5:%d, R6:%d, R7:%d, R8:%d, R9:%d, R10:%d, R11:%d, R12:%d, R13:%d, R14:%d \n", Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14]);  



        R[0] = 64'd9;
        R[1] = 64'd8;
        R[2] = 64'd7;
        R[3] = 64'd6;
      	R[4] = 64'd19;
        R[5] = 64'd4;
        R[6] = 64'd3;
        R[7] = 64'd2;
        R[8] = 64'd10;
        R[9] = 64'd10;
        R[10] = 64'd12;
        R[11] = 64'd13;
        R[12] = 64'd14;
        R[13] = 64'd15;
        R[14] = 64'd16;
				
    end

    // reg p;
    // always @(icode) begin
    //     p = (icode != 4'b0) ? 1'b0 : 1'b1;
    //     if (p == 1'b1) begin
    //         $finish;
    //     end
    // end
  
 	 always@(posedge clk) begin


   	 if(E_icode == 4'b0111 && !M_cnd) begin
      		Jxx_Pred = E_valA;
       		Jxx_cnd = 1'b1;
   	 end
     else begin
       		Jxx_cnd = 1'b0;
     end
     
     if(E_icode == 4'b0000)
          begin
              E_cndnflagin = 0;
              F_stall = 0;
              D_stall = 0;
              E_bubble = 0;
              D_bubble = 0;
          end
     else if(E_icode == 4'b0111 & !M_cnd) begin
          F_stall = 0;
          D_stall = 0;
          D_bubble = 1;
          E_bubble = 1;
     end
     else if ((E_icode == 4'b0101 | E_icode == 4'b1011) & (M_dstM==d_srcA | M_dstM==d_srcB)) begin
          F_stall = 1;
          D_stall = 1;
          E_bubble = 1;
          D_bubble = 0;
      end 
      else if (E_icode == 4'b1001 | M_icode == 4'b1001 | D_icode == 4'b1001) begin
            F_stall = 1;
            D_bubble = 1;
            D_stall = 0;
            E_bubble = 0;
      end
    	else begin
          		F_stall = 0;
              D_stall = 0;
              E_bubble = 0;
              D_bubble = 0;
      end
      
 	 end

   always@(negedge clk) begin
            $display("\n\n\n\n",$time ,"ns\n\n\nPC: %d  \nfetch_64: W_valM=%d, M_icode=%d, W_icode=%d, M_cnd=%d, M_valA=%d, Jxx_Pred=%d, Jxx_cnd=%d, F_stall=%d, D_bubble=%d, D_stall=%d, \ninstruction=%b, PC=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, D_stat=%d, f_PC=%d,temp pc = %d,\n\n\ndecode_64: E_bubble=%d, D_stat=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, R=%d, E_stat=%d, E_icode=%d, E_ifun=%d, E_valC=%d, E_valA=%d, E_valB=%d, E_dstE=%d, E_dstM=%d, E_srcA=%d, E_srcB=%d, W_valE=%d, W_valM=%d, m_valM=%d, M_valA=%d, M_valE=%d, e_valE=%d, d_srcA=%d, d_srcB=%d, e_dstE=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d\n\n\nexecute_64: E_icode=%d, E_ifun=%d, E_valA=%d, E_valB=%d, E_valC=%d, E_cndnflagin=%d, E_stat=%d, E_dstE=%d, E_dstM=%d, e_cndnflagout=%d, e_valE=%d, M_valE=%d, M_cnd=%d, M_stat=%d, M_icode=%d, e_dstE=%d, M_dstE=%d, M_dstM=%d, M_valA=%d\n\n\nmemory_64: M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, M_dstE=%d, M_dstM=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, m_valM=%d, m_stat=%d\n\n\nwriteback_64: W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, R=%d, Regout=%d, M_cnd=%d\n ------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
            PC,W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC, Temp_predPC,
             E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE,
            E_icode, E_ifun, E_valA, E_valB, E_valC, E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout, e_valE, M_valE, M_cnd, M_stat, M_icode, e_dstE, M_dstE, M_dstM, M_valA,
            M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat,
             W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd, "\nR0:%d, R1:%d, R2:%d, R3:%d, R4:%d, R5:%d, R6:%d, R7:%d, R8:%d, R9:%d, R10:%d, R11:%d, R12:%d, R13:%d, R14:%d \n", Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14]);  

   end

    always@(PC) begin
            // if (PC > lineCount+10) begin
            //     $finish;
            // end
            instruction = {IM[PC] , IM[PC+1] , IM[PC+2] , IM[PC+3] , IM[PC+4] , IM[PC+5] , IM[PC+6] , IM[PC+7] , IM[PC+8] , IM[PC+9]};
            // $display("INS insd : %b\n in neg\n",instruction);
            // $display($time ,"ns\n\n\nfetch_64: W_valM=%d, M_icode=%d, W_icode=%d, M_cnd=%d, M_valA=%d, Jxx_Pred=%d, Jxx_cnd=%d, F_stall=%d, D_bubble=%d, D_stall=%d, \ninstruction=%b, PC=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, D_stat=%d, f_PC=%d,\n\n\ndecode_64: E_bubble=%d, D_stat=%d, D_icode=%d, D_ifun=%d, D_rA=%d, D_rB=%d, D_valC=%d, D_valP=%d, R=%d, E_stat=%d, E_icode=%d, E_ifun=%d, E_valC=%d, E_valA=%d, E_valB=%d, E_dstE=%d, E_dstM=%d, E_srcA=%d, E_srcB=%d, W_valE=%d, W_valM=%d, m_valM=%d, M_valA=%d, M_valE=%d, e_valE=%d, d_srcA=%d, d_srcB=%d, e_dstE=%d, M_dstM=%d, M_dstE=%d, W_dstM=%d, W_dstE=%d\n\n\nexecute_64: E_icode=%d, E_ifun=%d, E_valA=%d, E_valB=%d, E_valC=%d, E_cndnflagin=%d, E_stat=%d, E_dstE=%d, E_dstM=%d, e_cndnflagout=%d, e_valE=%d, M_valE=%d, M_cnd=%d, M_stat=%d, M_icode=%d, e_dstE=%d, M_dstE=%d, M_dstM=%d, M_valA=%d\n\n\nmemory_64: M_stat=%d, M_icode=%d, M_Cnd=%d, M_valE=%d, M_valA=%d, M_dstE=%d, M_dstM=%d, W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, m_valM=%d, m_stat=%d\n\n\nwriteback_64: W_stat=%d, W_icode=%d, W_valE=%d, W_valM=%d, W_dstE=%d, W_dstM=%d, R=%d, Regout=%d, M_cnd=%d\n ------------------------------------------------------------------------------------------------------------------------------------------------------------------------",
            // W_valM, M_icode, W_icode, M_cnd, M_valA, Jxx_Pred, Jxx_cnd, F_stall, D_bubble, D_stall, instruction, PC, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, D_stat, f_PC,
            //  E_bubble, D_stat, D_icode, D_ifun, D_rA, D_rB, D_valC, D_valP, R, E_stat, E_icode, E_ifun, E_valC, E_valA, E_valB, E_dstE, E_dstM, E_srcA, E_srcB, W_valE, W_valM, m_valM, M_valA, M_valE, e_valE, d_srcA, d_srcB, e_dstE, M_dstM, M_dstE, W_dstM, W_dstE,
            // E_icode, E_ifun, E_valA, E_valB, E_valC, E_cndnflagin, E_stat, E_dstE, E_dstM, e_cndnflagout, e_valE, M_valE, M_cnd, M_stat, M_icode, e_dstE, M_dstE, M_dstM, M_valA,
            // M_stat, M_icode, M_Cnd, M_valE, M_valA, M_dstE, M_dstM, W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, m_valM, m_stat,
            //  W_stat, W_icode, W_valE, W_valM, W_dstE, W_dstM, R, Regout, M_cnd);
            //  $display("R0:%d, R1:%d, R2:%d, R3:%d, R4:%d, R5:%d, R6:%d, R7:%d, R8:%d, R9:%d, R10:%d, R11:%d, R12:%d, R13:%d, R14:%d \n", Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14]);  


    end 


    always @(*) begin
      // $display("HII D_stat: %b\n",D_stat);
        // if ( fi == 1'b1) begin
        //   PC = 1'b0;
        //   fi = 1'b0;
        // end
        // else
          PC = f_PC;
    end
    always@(*) begin
        for (i=0; i<1024; i=i+1) begin
            Min[i] = Mout[i];
        end
    end
    always@(*) begin
        if ( W_stat[1] == 1'b1 ) begin
          $display("HALT Encountered \n");
            $finish;
        end
        if (W_stat[2] == 1'b1 ) begin
            $display("Wrong Address Encountered \n");
            $finish;
        end
        if (  W_stat[3] == 1'b1 ) begin
            $display("Wrong Instruction Encountered \n");
            $finish;
        end
    end
    always@(*) begin
        for (i=0;i<3;i=i+1) begin
          E_cndnflagin[i] = e_cndnflagout[i];
        end
    end
    always@(*) begin
        for (i=0;i<15;i=i+1) begin
            R[i] = Regout[i];
        end
    end

endmodule
