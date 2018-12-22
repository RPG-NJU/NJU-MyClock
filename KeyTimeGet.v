/*
 * 该模块的作用是将其和键盘模块联系，同时维护一个不断写入的数组，用于保存时间的输入
 * 根据不同的模式进入到时间设定或者闹钟设定的模式中
 */


module KeyTimeGet(

	input ps2_clk,
	input ps2_data,

	input CLK_50,

	output reg set_en,
	output reg alarm_en, //用于输出给上层提示目前是什么模式，是否是时钟或者闹钟设定

	//output wire ready//用输出以检查

	output reg all_ready, // 用于标识已经敲下了回车键，所有的时间准备已经充分
	output reg [5:0] hour,
	output reg [5:0] minute,
	output reg [5:0] second
	//output wire [7:0] ASCII
	);

	

	wire [7:0] data;
	wire ready;
	wire [7:0] ASCII;
	wire trans_en;
	reg [2:0] location;
	//wire ready;
	//wire nextdata_n;

	initial
	begin
		set_en = 1'b0;
		alarm_en = 1'b0;
		hour = 6'b0;
		minute = 6'b0;
		second = 6'b0;
		location = 3'b0;
	end

	ps2_keyboard keyboard(
		.clk(CLK_50),
		.clrn(1'b1),
		.ps2_clk(ps2_clk),
		.ps2_data(ps2_data),
		.data(data),//传出的数据
		.ready(ready),
		.nextdata_n(1'b0)
		//.overflow(overflow)
		);
	
	KeyTranslate GetASCII(
		.ready(ready),
		.now_data(data),
		.ASCII(ASCII),
		.out_en(trans_en)
	);


	always @ (negedge trans_en) // 使用trans_en作为操作判定
								// 如果其为上升沿，则说明此时的ASCII是有效的
	begin
		if (alarm_en == 1'b0 && set_en == 1'b0) // 此时两种模式都没有用
		begin
			if (ASCII == 8'h61)
				alarm_en = 1'b1;
			else if (ASCII == 8'h73)
				set_en = 1'b1;
		end

		else if (ASCII == 8'h64) // 此时是D
		begin
			alarm_en = 1'b0;
			set_en = 1'b0;
			if (all_ready == 1'b0) all_ready = 1'b1;
			else all_ready = 1'b0;

			hour = 8'b0;
			minute = 8'b0;
			second = 8'b0;
			location = 3'b0;
		end

		else // 这个时候需要监听键盘的动向，并且将数据写入时间设定
		begin
			if (ASCII >= 8'h30 && ASCII <= 8'h39)
			begin
				case (location)
				0:hour = hour + (ASCII - 8'h30) * 8'd10;
				1:hour = hour + (ASCII - 8'h30);
				2:minute = minute + (ASCII - 8'h30) * 8'd10;
				3:minute = minute + (ASCII - 8'h30);
				4:second = second + (ASCII - 8'h30) * 8'd10;
				5:second = second + (ASCII - 8'h30);
				default:;
				endcase
				location = location + 3'b1;
			end

			else
			begin
			end

		end
	end

endmodule
