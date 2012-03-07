///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 13.2
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chip_scope.veo
// /___/   /\     Timestamp  : Sat Dec 03 15:58:19 Eastern Standard Time 2011
// \   \  /  \
//  \___\/\___\
//
// Design Name: ISE Instantiation template
///////////////////////////////////////////////////////////////////////////////

// The following must be inserted into your Verilog file for this
// core to be instantiated. Change the instance name and port connections
// (in parentheses) to your own signal names.

//----------- Begin Cut here for INSTANTIATION Template ---// INST_TAG
chip_scope YourInstanceName (
    .CONTROL(CONTROL), // INOUT BUS [35:0]
    .CLK(CLK), // IN
    .SYNC_IN(SYNC_IN), // IN BUS [63:0]
    .SYNC_OUT(SYNC_OUT) // OUT BUS [63:0]
);

// INST_TAG_END ------ End INSTANTIATION Template ---------

