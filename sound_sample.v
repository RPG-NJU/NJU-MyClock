/*
 * 从老师的例子中移植过来的音频模块
 * 为了耦合与现在的模块，所以更改了一些明明需要改变的参数为不变的参数，同时，屏蔽了大多数无用接口
 */

module sound_sample(
//////////// CLOCK //////////
	// input 		          		CLOCK2_50,
	// input 		          		CLOCK3_50,
	// input 		          		CLOCK4_50,
	input 		          		CLOCK_50,

	//////////// KEY //////////
	// input 		     [3:0]		KEY,

	//////////// SW //////////
	// input 		     [9:0]		SW,

	//////////// LED //////////
	// output		     [9:0]		LEDR,
	output [3:0] LEDR,

	//////////// Seg7 //////////
	// output		     [6:0]		HEX0,
	// output		     [6:0]		HEX1,
	// output		     [6:0]		HEX2,
	// output		     [6:0]		HEX3,
	// output		     [6:0]		HEX4,
	// output		     [6:0]		HEX5,

	//////////// Audio //////////
	// input 		          		AUD_ADCDAT,
	// inout 		          		AUD_ADCLRCK,
	inout 		          		AUD_BCLK,
	output		          		AUD_DACDAT,
	inout 		          		AUD_DACLRCK,
	output		          		AUD_XCK,

	//////////// PS2 //////////
	// inout 		          		PS2_CLK,
	// inout 		          		PS2_CLK2,
	// inout 		          		PS2_DAT,
	// inout 		          		PS2_DAT2,

	//////////// I2C for Audio and Video-In //////////
	output		          		FPGA_I2C_SCLK,
	inout 		          		FPGA_I2C_SDAT,

	input [2:0] en_count // 标识了是否响的同时要标识是在哪一个位置以好改变音调
	);



	//=======================================================
	//  REG/WIRE declarations
	//=======================================================

	wire clk_i2c;
	//wire reset;
	wire [15:0] audiodata;

	reg [15:0] freq;

	initial
	begin
		freq = 16'b0;
	end

	//=======================================================
	//  Structural coding
	//=======================================================

	//assign reset = ~KEY[0];

	audio_clk u1(CLOCK_50, reset,AUD_XCK, LEDR[3]);


	//I2C part
	clkgen #(10000) my_i2c_clk(CLOCK_50,/*reset*/1'b0,1'b1,clk_i2c);  //10k I2C clock


	I2C_Audio_Config myconfig(clk_i2c, /*KEY[0]*/1'b1,FPGA_I2C_SCLK,FPGA_I2C_SDAT,LEDR[2:0]);

	I2S_Audio myaudio(AUD_XCK, /*KEY[0]*/1'b1, AUD_BCLK, AUD_DACDAT, AUD_DACLRCK, audiodata);

	Sin_Generator sin_wave(AUD_DACLRCK, /*KEY[0]*/1'b1, /*16'h0300*/ freq, audiodata);//更改了参数的值

	always @ (posedge CLOCK_50)
	begin
		case (en_count)
		0:freq = 16'd0;
		1:freq = 16'd714;
		2:freq = 16'd802;
		3:freq = 16'd900;
		4:freq = 16'd714;
		5:freq = 16'd900;
		6:freq = 16'd954;
		7:freq = 16'd1070;
		default:freq = 16'd0;
		endcase
	end

endmodule
