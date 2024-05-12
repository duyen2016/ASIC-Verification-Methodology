@echo off
REM ****************************************************************************
REM Vivado (TM) v2021.2 (64-bit)
REM
REM Filename    : simulate.bat
REM Simulator   : Xilinx Vivado Simulator
REM Description : Script for simulating the design by launching the simulator
REM
REM Generated by Vivado on Sun May 12 21:59:28 +0700 2024
REM SW Build 3367213 on Tue Oct 19 02:48:09 MDT 2021
REM
REM IP Build 3369179 on Thu Oct 21 08:25:16 MDT 2021
REM
REM usage: simulate.bat
REM
REM ****************************************************************************
REM simulate design
echo "xsim processor_testbench_behav -key {Behavioral:sim_1:Functional:processor_testbench} -tclbatch processor_testbench.tcl -view E:/CE409/ASIC-Verification-Methodology/RISC-V/processor_testbench_behav.wcfg -log simulate.log"
call xsim  processor_testbench_behav -key {Behavioral:sim_1:Functional:processor_testbench} -tclbatch processor_testbench.tcl -view E:/CE409/ASIC-Verification-Methodology/RISC-V/processor_testbench_behav.wcfg -log simulate.log
if "%errorlevel%"=="0" goto SUCCESS
if "%errorlevel%"=="1" goto END
:END
exit 1
:SUCCESS
exit 0
