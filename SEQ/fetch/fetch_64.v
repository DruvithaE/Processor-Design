module fetch_64(input [0:79] instruction, input [63:0] PC , input clk, output reg [3:0] icode, output reg [3:0] ifun, output reg [3:0] rA, output reg [3:0] rB, output reg [63:0] valC, output reg [63:0] valP, output reg imem_error, output reg instr_valid );

   always@(posedge clk) begin
        icode = instruction[0:3];
        ifun = instruction[4:7];
        // icode and ifun together is 1 byte of instruction i.e lower 8bits of instruction.
        case(icode)
            4'b0000, 4'b0001: 
                begin
                    valP = PC+1; // As there are no other registers to extract for halt and nop rather than icode,ifun.
                end
            4'b0010:
                begin
                    rB = instruction[12:15];
                    rA = instruction[8:11]; 
                    valP = PC + 2; // As cmovxx only have icode, ifun , and two registers to extract so total of 2 bytes.
                end
            4'b0011:
                begin 
                    rA = instruction[8:11]; //which is null rA = F
                    rB = instruction[12:15];
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS irmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                end
            4'b0100:
                begin 
                    rA = instruction[8:11];
                    rB = instruction[12:15];
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS rmmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                end
            4'b0101:
                begin 
                    rA = instruction[8:11];
                    rB = instruction[12:15];
                    valC = {instruction[72:79],instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23]}; // 8bytes address(8*8 bits)
                    valP = PC + 10; // AS mrmovq have rA, rB and Dest along with icode , ifun to extract Thus total of 10 bytes.
                end
            4'b0110:
                begin
                    rA = instruction[8:11]; 
                    rB = instruction[12:15];
                    valP = PC + 2; // As opq only have icode, ifun , and two registers to extract so total of 2 bytes.
                end
            4'b0111:
                begin
                    valC = {instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23],instruction[8:15]};
                    valP = PC +9; // As jXX have icode, ifun and Dest so total of 9 bytes .
                end
            4'b1000:
                begin
                    valC = {instruction[64:71],instruction[56:63],instruction[48:55],instruction[40:47],instruction[32:39],instruction[24:31],instruction[16:23],instruction[8:15]};
                    valP = PC +9; // As call have icode, ifun and Dest so total of 9 bytes .
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
                end
            4'b1011:
                begin
                    rA = instruction[8:11]; 
                    rB = instruction[12:15]; // which is null rB =F
                    valP = PC + 2; // As popq only have icode, ifun , and two registers to extract so total of 2 bytes.
                end
            default:
                begin
                   instr_valid = 0; // if icode is neither of these then instruction is invalid.
                end

        endcase

        // if PC is greater than the memory size leads to imem_error.
        if (PC > 1023) 
            begin
                imem_error = 1'b1;
            end
        else 
            begin
                imem_error = 1'b0;
            end
            
   end   

endmodule
