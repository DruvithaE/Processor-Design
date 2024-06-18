module fetch_64(input [63:0]m_valM, input [3:0]M_icode, input [3:0]W_icode, input M_cnd, input [63:0] M_valA, input [63:0] Jxx_Pred, input Jxx_cnd, input F_stall, input D_bubble, input D_stall, input [0:79] instruction, input [63:0] F_PC , input clk, output reg [3:0] f_icode, output reg [3:0] f_ifun, output reg [3:0] f_rA, output reg [3:0] f_rB, output reg [63:0] f_valC, output reg [63:0] f_valP, output reg [3:0] f_stat,  output reg [63:0] f_PC, output reg [63:0] Temp_predPC, input fi);
    
   reg [3:0] icode; reg [3:0] ifun; reg [3:0] rA; reg [3:0] rB; reg [63:0] valC; reg [63:0] valP;
   reg halt;reg [3:0] D_stat;
   reg instr_valid;
   reg first_ins = 1'b1;
   reg [63:0] PC;
   
   always@(posedge clk) begin
    // $display("in positive fetch");
        icode = instruction[0:3];
    // $display("icode in 12: %b", icode);
        ifun = instruction[4:7];
        halt =1'b0;
        instr_valid = 1'b1;
        if(M_cnd == 0 & M_icode == 4'b0111)
            begin
                PC= M_valA;
                Temp_predPC = M_valA; 
            end
        else if(M_icode == 4'b1001 )
            begin
                PC = m_valM;
                Temp_predPC = m_valM;
                // $display("Im HERE bb temp pc = %d\n",Temp_predPC);
            end
        else
            begin
                PC = F_PC;
                // $display("HERE PC: %b", PC);
            end
        $display("inst %b", instruction);
        // icode and ifun together is 1 byte of instruction i.e lower 8bits of instruction.
        case(icode)
            4'b0000: 
                begin
                    
                    valP = PC+1; // As there are no other registers to extract for halt and nop rather than icode,ifun.
                    Temp_predPC = PC+1;
                    halt = 1'b1; //HLT
                end
            4'b0001: 
                begin
                    valP = PC+1; // As there are no other registers to extract for halt and nop rather than icode,ifun.
                    Temp_predPC = valP;
                end
            4'b0010:
                begin
                    rB = instruction[12:15];
                    rA = instruction[8:11]; 
                    valP = PC + 2; // As cmovxx only have icode, ifun , and two registers to extract so total of 2 bytes.
                    Temp_predPC = valP;
                end
            4'b0011:
                begin 
                    $display("in ir fetch");
                    rA = instruction[8:11]; //which is null rA = F
                    rB = instruction[12:15];
                    $display("rB : in line 58 : %b             ins: %b",rB,instruction);
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS irmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                    Temp_predPC = valP;
                    // $display("Temp_predPC: %b", Temp_predPC);
                end
            4'b0100:
                begin 
                    rA = instruction[8:11];
                    rB = instruction[12:15];
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS rmmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                    Temp_predPC = valP;
                end
            4'b0101:
                begin 
                    rA = instruction[8:11];
                    rB = instruction[12:15];
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS mrmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                    Temp_predPC = valP;
                end
            4'b0110:
                begin
                    rA = instruction[8:11]; 
                    rB = instruction[12:15];
                    valP = PC + 2; // As opq only have icode, ifun , and two registers to extract so total of 2 bytes.
                    Temp_predPC = valP;
                end
            4'b0111:
                begin
                    valC = {instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23],instruction[8:15]};
                    valP = PC +9; // As jXX have icode, ifun and Dest so total of 9 bytes .
                    Temp_predPC = valC;
                end
            4'b1000:
                begin
                    valC = {instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23],instruction[8:15]};
                    valP = PC +9; // As call have icode, ifun and Dest so total of 9 bytes .
                    Temp_predPC = valC;
                end
            4'b1001:
                begin
                    valP = PC +1; // As ret only have icode and ifun So incrementing only by 1 byte.
                end
            4'b1010:
                begin
                    rA = instruction[8:11]; 
                    rB = instruction[12:15]; // which is null rB =F
                    valP = PC + 2; // As pushq only have icode, ifun , and two registers to extract so total of 2 bytes.
                    Temp_predPC = valP;
                end
            4'b1011:
                begin
                    rA = instruction[8:11]; 
                    rB = instruction[12:15]; // which is null rB =F
                    valP = PC + 2; // As popq only have icode, ifun , and two registers to extract so total of 2 bytes.
                    Temp_predPC = valP;
                end
            default:
                begin
                    instr_valid = 0; // if icode is neither of these then instruction is invalid.
                    // Temp_predPC = 64'd1000;
                end

        endcase
        // if PC is greater than the memory size leads to imem_error.
        D_stat[3] = 1'b0; //INS
        D_stat[2] = 1'b0; //ADR
        D_stat[1] = 1'b0; //HLT
        D_stat[0] = 1'b1; //AOK
        if (F_PC > 1023) 
            begin
                $display("ADR\n");
                D_stat[3] = 1'b0; //INS
                D_stat[2] = 1'b1; //ADR
                D_stat[1] = 1'b0; //HLT
                D_stat[0] = 1'b0; //AOK
            end
        else if(halt == 1'b1) 
            begin
                $display("HLT\n");
                D_stat[3] = 1'b0; //INS
                D_stat[2] = 1'b0; //ADR
                D_stat[1] = 1'b1; //HLT
                D_stat[0] = 1'b0; //AOK
            end
        else if(instr_valid == 1'b0 )
            begin
                $display("INS\n");
                D_stat[3] = 1'b1; //INS
                D_stat[2] = 1'b0; //ADR
                D_stat[1] = 1'b0; //HLT
                D_stat[0] = 1'b0; //AOK
            end
            
   end   

   always@(negedge clk)
        begin
            // $display("in neg fetch PC: %b", instruction);

            if(F_stall)
                begin
                    f_PC = F_PC;
                end
            if(D_stall)
                begin
                    
                end
           if(D_bubble)
                begin
                    if(Jxx_cnd)
                        f_PC = Jxx_Pred;
                    f_icode = 4'b0001;
                    f_ifun = 4'b0000;
                    f_rA = 4'b1111;
                    f_rB = 4'b1111;
                    f_valC = 64'b0;
                    f_valP = 64'b0;
                    f_stat = 4'b0001;          
                end
            if(!D_bubble && !D_stall && !F_stall) begin
                $display("NEGEDGE HERE icode: %b    temp: %d jxxcnd :  %d     jxxPRed:  %d\n",icode,Temp_predPC, Jxx_cnd, Jxx_Pred);
                f_icode = icode;
                f_ifun = ifun;
                f_rA = rA;
                f_rB = rB;
                f_valC = valC;
                f_valP = valP;
                f_stat = D_stat; 
                if(Jxx_cnd)    
                    f_PC = Jxx_Pred;
                else
                    f_PC = Temp_predPC;
            end
        end
endmodule
