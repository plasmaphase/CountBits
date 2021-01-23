# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "AXIL_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXIL_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_ADDR_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_ARUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_AWUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_BUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_DATA_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_ID_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_RUSER_WIDTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "AXI_WUSER_WIDTH" -parent ${Page_0}


}

proc update_PARAM_VALUE.AXIL_ADDR_WIDTH { PARAM_VALUE.AXIL_ADDR_WIDTH } {
	# Procedure called to update AXIL_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIL_ADDR_WIDTH { PARAM_VALUE.AXIL_ADDR_WIDTH } {
	# Procedure called to validate AXIL_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXIL_DATA_WIDTH { PARAM_VALUE.AXIL_DATA_WIDTH } {
	# Procedure called to update AXIL_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXIL_DATA_WIDTH { PARAM_VALUE.AXIL_DATA_WIDTH } {
	# Procedure called to validate AXIL_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to update AXI_ADDR_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ADDR_WIDTH { PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to validate AXI_ADDR_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_ARUSER_WIDTH { PARAM_VALUE.AXI_ARUSER_WIDTH } {
	# Procedure called to update AXI_ARUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ARUSER_WIDTH { PARAM_VALUE.AXI_ARUSER_WIDTH } {
	# Procedure called to validate AXI_ARUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_AWUSER_WIDTH { PARAM_VALUE.AXI_AWUSER_WIDTH } {
	# Procedure called to update AXI_AWUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_AWUSER_WIDTH { PARAM_VALUE.AXI_AWUSER_WIDTH } {
	# Procedure called to validate AXI_AWUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_BUSER_WIDTH { PARAM_VALUE.AXI_BUSER_WIDTH } {
	# Procedure called to update AXI_BUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_BUSER_WIDTH { PARAM_VALUE.AXI_BUSER_WIDTH } {
	# Procedure called to validate AXI_BUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to update AXI_DATA_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_DATA_WIDTH { PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to validate AXI_DATA_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_ID_WIDTH { PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to update AXI_ID_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_ID_WIDTH { PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to validate AXI_ID_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_RUSER_WIDTH { PARAM_VALUE.AXI_RUSER_WIDTH } {
	# Procedure called to update AXI_RUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_RUSER_WIDTH { PARAM_VALUE.AXI_RUSER_WIDTH } {
	# Procedure called to validate AXI_RUSER_WIDTH
	return true
}

proc update_PARAM_VALUE.AXI_WUSER_WIDTH { PARAM_VALUE.AXI_WUSER_WIDTH } {
	# Procedure called to update AXI_WUSER_WIDTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.AXI_WUSER_WIDTH { PARAM_VALUE.AXI_WUSER_WIDTH } {
	# Procedure called to validate AXI_WUSER_WIDTH
	return true
}


proc update_MODELPARAM_VALUE.AXI_RUSER_WIDTH { MODELPARAM_VALUE.AXI_RUSER_WIDTH PARAM_VALUE.AXI_RUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_RUSER_WIDTH}] ${MODELPARAM_VALUE.AXI_RUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ARUSER_WIDTH { MODELPARAM_VALUE.AXI_ARUSER_WIDTH PARAM_VALUE.AXI_ARUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ARUSER_WIDTH}] ${MODELPARAM_VALUE.AXI_ARUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_WUSER_WIDTH { MODELPARAM_VALUE.AXI_WUSER_WIDTH PARAM_VALUE.AXI_WUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_WUSER_WIDTH}] ${MODELPARAM_VALUE.AXI_WUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_AWUSER_WIDTH { MODELPARAM_VALUE.AXI_AWUSER_WIDTH PARAM_VALUE.AXI_AWUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_AWUSER_WIDTH}] ${MODELPARAM_VALUE.AXI_AWUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_BUSER_WIDTH { MODELPARAM_VALUE.AXI_BUSER_WIDTH PARAM_VALUE.AXI_BUSER_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_BUSER_WIDTH}] ${MODELPARAM_VALUE.AXI_BUSER_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ID_WIDTH { MODELPARAM_VALUE.AXI_ID_WIDTH PARAM_VALUE.AXI_ID_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ID_WIDTH}] ${MODELPARAM_VALUE.AXI_ID_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_DATA_WIDTH { MODELPARAM_VALUE.AXI_DATA_WIDTH PARAM_VALUE.AXI_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_DATA_WIDTH}] ${MODELPARAM_VALUE.AXI_DATA_WIDTH}
}

proc update_MODELPARAM_VALUE.AXI_ADDR_WIDTH { MODELPARAM_VALUE.AXI_ADDR_WIDTH PARAM_VALUE.AXI_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXI_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXI_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXIL_ADDR_WIDTH { MODELPARAM_VALUE.AXIL_ADDR_WIDTH PARAM_VALUE.AXIL_ADDR_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIL_ADDR_WIDTH}] ${MODELPARAM_VALUE.AXIL_ADDR_WIDTH}
}

proc update_MODELPARAM_VALUE.AXIL_DATA_WIDTH { MODELPARAM_VALUE.AXIL_DATA_WIDTH PARAM_VALUE.AXIL_DATA_WIDTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.AXIL_DATA_WIDTH}] ${MODELPARAM_VALUE.AXIL_DATA_WIDTH}
}

