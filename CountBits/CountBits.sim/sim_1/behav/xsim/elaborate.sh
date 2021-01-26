#!/bin/bash -f
# ****************************************************************************
# Vivado (TM) v2020.1.1 (64-bit)
#
# Filename    : elaborate.sh
# Simulator   : Xilinx Vivado Simulator
# Description : Script for elaborating the compiled design
#
# Generated by Vivado on Mon Jan 25 20:05:58 CST 2021
# SW Build 2960000 on Wed Aug  5 22:57:21 MDT 2020
#
# Copyright 1986-2020 Xilinx, Inc. All Rights Reserved.
#
# usage: elaborate.sh
#
# ****************************************************************************
set -Eeuo pipefail
echo "xelab -wto 0325e4f34e0248bdbf1031e33be5216a --incr --debug typical --relax --mt 8 -L axi_infrastructure_v1_1_0 -L xil_defaultlib -L axi_vip_v1_1_7 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot cb_sim_behav xil_defaultlib.cb_sim xil_defaultlib.glbl -log elaborate.log"
xelab -wto 0325e4f34e0248bdbf1031e33be5216a --incr --debug typical --relax --mt 8 -L axi_infrastructure_v1_1_0 -L xil_defaultlib -L axi_vip_v1_1_7 -L xilinx_vip -L unisims_ver -L unimacro_ver -L secureip -L xpm --snapshot cb_sim_behav xil_defaultlib.cb_sim xil_defaultlib.glbl -log elaborate.log

