`include "adder_64.v"
`include "subtractor_64.v"
`include "and_64.v"
`include "xor_64.v"

module ALU(input signed [63:0] A, input signed [63:0] B, input [1:0] Selectline,output reg signed [63:0] selected_result, output reg Overflow);

    wire [63:0] add_result;
    wire [63:0] sub_result;
    wire [63:0] xor_result;
    wire [63:0] and_result;
    wire overflow1, overflow2;
    adder_64 add12(A,B,add_result,overflow1);
    subtractor_64 sub12(A,B,sub_result,overflow2);
    and_64 and12 (A, B, and_result);
    xor_64 xor12 (A, B, xor_result);

    
    always @* begin
        case (Selectline)
            2'b00: begin
                selected_result = add_result;
                Overflow = overflow1;
            end
            2'b01: begin
                selected_result = sub_result;
                Overflow = overflow2;
            end
            2'b10: begin
                selected_result = and_result;
                Overflow = 1'b0;
            end
            2'b11: begin
                selected_result = xor_result;
                Overflow = 1'b0;
            end
        endcase
    end


endmodule