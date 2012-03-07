`timescale 1ns / 1ps

module ps2key(
clk50,                        // 50 MHz Clock
kin,                          // serial keyboard data input
kclk,                         // keyboard clock
code                          // parallel scan code
);

input kin, kclk, clk50;
output [7:0] code;
reg [7:0] code;
reg [3:0] i;                 // counter variable
reg [10:0] ksr;              // keyboard shift register
reg [11:0] cnt;              // large count variable used for reset
reg reset;                   // signal used to reset i

initial begin                // Initialization block that resets all valuse 
 ksr = 0;                    // to zero by default
 i = 0;
 code = 0;
 cnt = 0;
 end 

always @ (posedge clk50) begin //  This block will drive a signal, reset, high 
  if (cnt > 3000)  begin     // if kclk is ever high for longer than 60 
    reset <= 0;              // microsec. This is used to reset the value of   
    cnt <= 0;                // i in the block below if the system ever gets  
    end                      // off in count or a new device is connected.   
  else if (kclk == 1) begin  // Under normal conditions, kclk should never be 
    reset <= 1;              // asserted for longer than at max 30 microsec as
    cnt <= cnt + 1;          // the period of kcclk is 60 microsec.
    end
  else begin
    reset <= 1;
    cnt <= 0;
    end
  end
 
always @ (negedge kclk or negedge reset) begin
  if (reset == 0) begin      //  Here, the reset condition for i is checked.  
    ksr <= ksr;              // If the system is not keyboard is not sending  
    i <= 0;                  // any signals, i is set to 0.  This allows the 
    code <= code;            // keyboard to be unplugged and plugged  back in
    end                      // without i getting messed up.
  else if (i < 10) begin     //  If i is less than 10, go through the usual
    ksr[i] <= kin;           // motions of assigning the bit value to the
    i <= i + 1;              // correct place in ksr, increment i, and keep
    code <= code;            // code the same.
    end                      //
  else begin                 //  If i is equal to 10, i.e. this is the last
    i <= 0;                  // bit... read that bit in, set i to 0, and 
    ksr[i] <= kin;           // set code to its approproate section of ksr.
    code <= ksr[8:1];
    end
  end

endmodule
