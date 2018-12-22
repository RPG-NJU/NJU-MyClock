/*
 * 该模块用于将输入的0~63的数字转化为两个七段数码管的输出
 * 分别标识为hex_one的个位表示，和hex_ten的十位表示，输出为十进制
 * 这个模块的主要作用在于显示时间的子模块
 * 主要作用是减少代码复用以及理清逻辑，与实现并无多大的关联
 */


module HEXShow(
	input [5:0] data,

	output reg [6:0] hex_one,
	output reg [6:0] hex_ten
	//input en
	);
	
	always @ (*)
	begin
		case (data % 10)
		0:hex_one = 7'b1000000;
		1:hex_one = 7'b1111001;
		2:hex_one = 7'b0100100;
		3:hex_one = 7'b0110000;
		4:hex_one = 7'b0011001;
		5:hex_one = 7'b0010010;
		6:hex_one = 7'b0000010;
		7:hex_one = 7'b1111000;
		8:hex_one = 7'b0000000;
		9:hex_one = 7'b0010000;
		default:hex_one = 7'b1111111;
		endcase

		case (data / 10)
		0:hex_ten = 7'b1000000;
		1:hex_ten = 7'b1111001;
		2:hex_ten = 7'b0100100;
		3:hex_ten = 7'b0110000;
		4:hex_ten = 7'b0011001;
		5:hex_ten = 7'b0010010;
		6:hex_ten = 7'b0000010;
		7:hex_ten = 7'b1111000;
		8:hex_ten = 7'b0000000;
		9:hex_ten = 7'b0010000;
		default:hex_ten = 7'b1111111;
		endcase
	end

endmodule
