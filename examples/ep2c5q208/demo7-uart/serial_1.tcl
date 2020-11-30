set_global_assignment -name RESERVE_ALL_UNUSED_PINS "AS INPUT TRI-STATED"
set_location_assignment PIN_23 -to clk
set_location_assignment PIN_72 -to seg_data[7]
set_location_assignment PIN_70 -to seg_data[6]
set_location_assignment PIN_69 -to seg_data[5]
set_location_assignment PIN_68 -to seg_data[4]
set_location_assignment PIN_67 -to seg_data[3]
set_location_assignment PIN_64 -to seg_data[2]
set_location_assignment PIN_63 -to seg_data[1]
set_location_assignment PIN_61 -to seg_data[0]

set_location_assignment PIN_84 -to en[7]
set_location_assignment PIN_82 -to en[6]
set_location_assignment PIN_81 -to en[5]
set_location_assignment PIN_80 -to en[4]

set_location_assignment PIN_77 -to en[3]
set_location_assignment PIN_76 -to en[2]
set_location_assignment PIN_75 -to en[1]
set_location_assignment PIN_74 -to en[0]

set_location_assignment PIN_30 -to rst
set_location_assignment PIN_24 -to key_input

set_location_assignment PIN_4 -to rxd
set_location_assignment PIN_3 -to txd
