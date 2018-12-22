/*
 * 该模块如名字所示，用于显示时间在HEX七段数码管上
 * 通过调用HEXShow来完成部分的显示
 * 目前没有打算有使能端进行控制
 */


module TimeShow(
	input [5:0] hour__,
	input [5:0] minute__,
	input [5:0] second__,

	input [5:0] hour_,
	input [5:0] minute_,
	input [5:0] second_,

	input set_en,
	input alarm_en,

	output [41:0] all_hex
	);


	reg [5:0] second;
	reg [5:0] minute;
	reg [5:0] hour;

	initial
	begin
		second = 8'b0;
		minute = 8'b0;
		hour = 8'b0;
	end

	always @ (*)
	begin
		if (set_en == 1'b1 || alarm_en == 1'b1)
		begin
			second = second_;
			minute = minute_;
			hour = hour_;
		end

		else 
		begin
			second = second__;
			minute = minute__;
			hour = hour__;
		end
	end
	HEXShow second_show(
		.data(second),
		.hex_one(all_hex[6:0]),
		.hex_ten(all_hex[13:7])
	);

	HEXShow minute_show(
		.data(minute),
		.hex_one(all_hex[20:14]),
		.hex_ten(all_hex[27:21])
	);

	HEXShow hour_show(
		.data(hour),
		.hex_one(all_hex[34:28]),
		.hex_ten(all_hex[41:35])
	);
	
	
endmodule
