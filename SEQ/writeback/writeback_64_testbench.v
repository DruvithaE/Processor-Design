`include "writeback_64.v"


module writeback_64_tb;
reg clk;
reg [3:0] icode,ifun,rA,rB;
reg [63:0] valA,valB,valE,valM;
reg [63:0] [0:14] Regin;
wire [63:0] [0:14] Regout;
reg cnd;

writeback_64 writeback1(icode,ifun,rA,rB,valA,valB,valE,valM,clk,Regin,Regout, cnd);

initial begin
        $dumpfile("writeback_output.vcd");
        $dumpvars(0,writeback_64_tb);
    end


always #5
clk = (clk==1) ? 0: 1;

reg [3:0] i;
 reg [3:0] b;
initial b = 4'b0000;



    initial begin
        for (i = 0; i < 15; i = i + 1) begin
            Regin[i] = {64{b}} + i;
        end


    clk = 1;
        
    #10
    // mrmov5
    rA = 4'd3; rB = 4'd9; icode = 4'd5; valA = 64'd10; valB = 64'd20; valE = 64'd50; valM = 64'd49;

    #10

    // cmov2
    rA = 4'd4; rB = 4'd10; icode = 4'd2; valA = 64'd11; valB = 64'd21; valE = 64'd51; valM = 64'd41;

    #10
    // ret9
    rA = 4'd3; rB = 4'd9;icode = 4'd9; valA = 64'd10; valB = 64'd20; valE = 64'd59; valM = 64'd40;

    
    #10
    // irmov3
    rA = 4'd3; rB = 4'd2; icode = 4'd3; valA = 64'd10; valB = 64'd20; valE = 64'd57;  valM = 64'd40;
    
    #10
    // call8
    rA = 4'd3; rB = 4'd9; icode = 4'd8; valA = 64'd10; valB = 64'd20; valE = 64'd50; valM = 64'd40;
    
    #10
    // pushq10
    rA = 4'd3; rB = 4'd9; icode = 4'd10; valA = 64'd10; valB = 64'd20; valE = 64'd76; valM = 64'd40;

    #10  
    // opq6
    rA = 4'd3; rB = 4'd9; icode = 4'd6; valA = 64'd10; valB = 64'd20; valE = 64'd50; valM = 64'd40;

        #10
    // popq11
    rA = 4'd3;  rB = 4'd9;  icode = 4'd11;  valA = 64'd10;  valB = 64'd20;  valE = 64'd50; valM = 64'd40;

    #10;
#2;
$finish;

end


always @(*)
begin
    for (i=0;i<15;i=i+1) begin
            Regin[i] = Regout[i] ;
        end
end

initial begin
    $monitor($time, "\nclk:%d\nrA:%d rB:%d icode:%d\n valA:%d valB:%d valE:%d valM:%d\n R[0]: %d  R[1]: %d   R[2] : %d\n R[3]: %d  R[4] : %d   \n R[5]: %d   R[6] : %d    R[7]: %d\n   R[8] : %d   R[9]: %d   R[10]: %d\n R[11]: %d    R[12]: %d   R[13] : %d  R[14] : %d\n", 
    clk, rA,rB,icode,valA,valB,valE,valM,Regout[0], Regout[1], Regout[2], Regout[3], Regout[4], Regout[5], Regout[6], Regout[7], Regout[8], Regout[9], Regout[10], Regout[11], Regout[12], Regout[13], Regout[14]);
    end

endmodule