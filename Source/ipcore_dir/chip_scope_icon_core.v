///////////////////////////////////////////////////////////////////////////////
// Copyright (c) 2011 Xilinx, Inc.
// All Rights Reserved
///////////////////////////////////////////////////////////////////////////////
//   ____  ____
//  /   /\/   /
// /___/  \  /    Vendor     : Xilinx
// \   \   \/     Version    : 13.2
//  \   \         Application: Xilinx CORE Generator
//  /   /         Filename   : chip_scope_icon_core.v
// /___/   /\     Timestamp  : Mon Dec 05 17:17:33 Eastern Standard Time 2011
// \   \  /  \
//  \___\/\___\
//
// Design Name: Verilog Synthesis Wrapper
///////////////////////////////////////////////////////////////////////////////
// This wrapper is used to integrate with Project Navigator and PlanAhead

`timescale 1ns/1ps

module chip_scope_icon_core(
    CONTROL0,
    CONTROL1);


inout [35 : 0] CONTROL0;
inout [35 : 0] CONTROL1;

endmodule
