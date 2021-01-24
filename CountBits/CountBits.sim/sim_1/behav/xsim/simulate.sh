#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1 (64-bit)
#
# Filename    : simulate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for simulating the design by launching the simulator
#
# Generated by Vivado on Sat Jan 23 19:27:11 CST 2021
# SW Build 2902540 on Wed May 27 19:54:35 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: simulate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xsim cb_sim_behav -key {Behavioral:sim_1:Functional:cb_sim} -tclbatch cb_sim.tcl -view /home/tron/Projects/CountBits/CountBits/cb_sim_behav.wcfg -log simulate.log"
xsim cb_sim_behav -key {Behavioral:sim_1:Functional:cb_sim} -tclbatch cb_sim.tcl -view /home/tron/Projects/CountBits/CountBits/cb_sim_behav.wcfg -log simulate.log

