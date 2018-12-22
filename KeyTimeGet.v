/*
 * 该模块的作用是将其和键盘模块联系，同时维护一个不断写入的数组，用于保存时间的输入
 * 根据不同的模式进入到时间设定或者闹钟设定的模式中
 */


module KeyTimeGet(

	input ps2_clk,
	input ps2_data,

	input CLK_50,

	output reg set_en,
	output reg alarm_en,//用于输出给上层提示目前是什么模式，是否是时钟或者闹钟设定

	output reg ready//用输出以检查

	);

	wire [7:0] data;
	//wire ready;
	wire nextdata_n;

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
	
endmodule
