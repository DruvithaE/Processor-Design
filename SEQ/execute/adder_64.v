`include "full_adder.v"

module adder_64 (input signed [63:0] A, input signed [63:0] B, output signed [63:0] Y, output overflow);
    wire signed [64:0] carry;
    assign carry[0] = 1'b0;
    // wire temp;
    genvar i;
    generate 
        for(i = 0; i < 64; i = i + 1) begin 	
    	full_adder uut1(carry[i], A[i], B[i], carry[i+1], Y[i]);
    end
    endgenerate

    wire both_negative;
    wire both_positive;
    and(both_negative, A[63], B[63]);
    wire a_63_neg; wire b_63_neg;
    not(a_63_neg, A[63]);
    not(b_63_neg, B[63]);
    and(both_positive, a_63_neg, b_63_neg);
    and(both_negative, A[63], B[63]);
    wire overflow_1;
    wire overflow_2;
    wire y_63_not;
    not(y_63_not,Y[63]);
    and(overflow_1, both_negative, y_63_not);
    and(overflow_2, both_positive, Y[63]);
    or(overflow, overflow_1, overflow_2);

endmodule


