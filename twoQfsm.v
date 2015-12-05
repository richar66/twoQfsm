module LCDTSTTwo(answer, submit, clk, rst, redOut, greenOut,/* QUESTION*/, LCD_ON, LCD_RW, LCD_EN, LCD_RS, LCD_DATA);

//	LCD Module 16X2
output LCD_ON;	// LCD Power ON/OFF
output LCD_RW;	// LCD Read/Write Select, 0 = Write, 1 = Read
output LCD_EN;	// LCD Enable
output LCD_RS;	// LCD Command/Data Select, 0 = Command, 1 = Data
inout [7:0] LCD_DATA;	// LCD Data bus 8 bits,

input [9:0] answer;
input submit, clk, rst;
output redOut, greenOut;
reg redOut, greenOut;
reg [2:0] S, NS;
reg [9:0] Answer;
reg [1:0] QUESTION;
parameter
				Q0 = 3'b000,
				check0 = 3'b001,
				wrong0 = 3'b010,
				correct0 = 3'b011,
				
				Q1 = 3'b100,
				check1 = 3'b101,
				wrong1 = 3'b110,
				correct1 = 3'b111;
				


always @ (posedge clk or negedge rst)
begin
	if (rst == 1'b0)
	begin
		S <= Q0;
	end
	
	else
	begin
		S<= NS;
	end
end

always @ (*)
begin
	case(S) 
	Q0:
	begin
		if (submit == 1'b0)
		begin	
			NS = Q0;
		end
		else
		begin	
			NS = check0;
		end
	end
	
	check0:
	begin
		if(submit == 1'b1)
		begin
			if (Answer == 10'b0000000001 )
			begin
				NS = correct0;
			end
			else 
			begin
				NS = wrong0;
			end
		end
		
		else 
		begin
			NS = Q0;
		end
	end
	
	wrong0:
	begin
		if (submit == 0)
		begin
			NS = Q0;
		end
		else
		begin
			NS = wrong0;
		end
	
	end
	correct0:
	begin
		if (submit == 0)
		begin
			NS = Q1;
		end
		else
		begin
			NS = correct0;
		end
	end
	Q1:
	begin
		if (submit == 1'b0)
		begin	
			NS = Q1;
		end
		else
		begin	
			NS = check1;
		end
	end
	
	check1:
	begin
		if(submit == 1'b1)
		begin
			if (Answer == 10'b0000000010 )
			begin
				NS = correct1;
			end
			else 
			begin
				NS = wrong1;
			end
		end
		
		else 
		begin
			NS = Q1;
		end
	end
	
	wrong1:
	begin
		if (submit == 0)
		begin
			NS = Q1;
		end
		else
		begin
			NS = wrong1;
		end
	
	end
	correct1:
	begin
		if (submit == 0)
		begin
			NS = Q0;
		end
		else
		begin
			NS = correct1;
		end
	end
	endcase
end	
always @ (posedge clk or negedge rst)
begin
	if(rst == 1'b0)
	begin
	greenOut <= 1'b0;
	redOut <= 1'b0;
	QUESTION <= 2'b00;
	end
	else
	begin
		case(S)
		Q0: 
		begin
		Answer <= answer;
		greenOut <= 1'b0;
		redOut <= 1'b0;
		QUESTION <= 2'b00;
		
		end
		correct0: greenOut <= 1'b1;
	
		wrong0: redOut <= 1'b1;
		
		Q1: 
		begin
		Answer <= answer;
		greenOut <= 1'b0;
		redOut <= 1'b0;
		QUESTION <= 2'b01;
		
		end
		correct1: greenOut <= 1'b1;
	
		wrong1: redOut <= 1'b1;
		endcase
	end
	
end

lcdlab1 test(
  .CLOCK_50(clk),	//	50 MHz clock
//	LCD Module 16X2
  .LCD_ON(LCD_ON),	// LCD Power ON/OFF
  .LCD_RW(LCD_RW),	// LCD Read/Write Select, 0 = Write, 1 = Read
  .LCD_EN(LCD_EN),	// LCD Enable
  .LCD_RS(LCD_RS),	// LCD Command/Data Select, 0 = Command, 1 = Data
  .LCD_DATA(LCD_DATA),	// LCD Data bus 8 bits,
  .QUESTION(QUESTION),
  .rst(rst)
);

endmodule
