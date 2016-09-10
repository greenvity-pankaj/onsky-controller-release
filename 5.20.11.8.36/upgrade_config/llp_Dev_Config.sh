#!/bin/bash
# Note - Please follow the below structure while filling new entry in this script. 
#		 Each field from the below strucure has meaning explained in the comment next
#		 to filed.
#
#typedef struct _sensor_table {
#	u8 dev_type;				/* Device tpye LIGHT_RGB-1, LIGHT_TEMP-2, LIGHT_DIMM-3, SENSOR_BOARD-4, SMART_PLUG-5,
#							   	   SMART_LIGHT-6, SIMPLE_SWITCH-7, RELAY_PWM-8, SEC_SENSOR-9, DEVICE_IAS-10, SCURITY_PLUG-11,
#							   	   SMART_GRID - 20 */
#	u8 sensor_name[SENSOR_NAME]; /* Name of Type field from tuple TV */ */
#	u8 sensor_type;				 /* Type from tuple TV */*/
#	u8 sensor_len;				 /* Lenght of Value from TV tuple */
#	u8 tx;						 /* 0 - FW TO HOST
#									1 - HOST TO FW
#									2 - BIDIRECTIONAL
#									3 - Dont Send */
#	u8 bitmap;					 /* Bit-1 (1)- Store/Update Device Name to flash.
#							        Bit-2 (2)- Store/Update Device Subtype to flash. 
#								    Bit-3 (4)- Store TLV into flash and send in update request to. Whether the TLV should go out or not is decided on basis of 
#											above tx flag value.
#								    Bit-4 (8)- Generate event for TCP.
#							        Bit-5 (16)- Update this TLV locally in database and dont send same in Update Set command */
#
#	u8 tag;						/* Split as  Type |Value (Type - Parent/Child & Value - to indicate whether it carries any value) 
#								   Parent - A, Child - B, NA - 0 & Value - 0 -carries no value , Value -1 - carries value */
#}PACKED dev_sensor_table_t;
#
## Delete old llp_MAC.txt and generate a new one
if [ ! -f opt/greenvity/llp/llp_Dev_Config.txt ]; then
	rm -f llp_Dev_Config.txt
	touch llp_Dev_Config.txt

	# LIGHT DEVICE
	echo "1,red,0,1,1,0,0xA1" >> llp_Dev_Config.txt				#red - Value goes from HOST TO FW and bitmap=0 
	echo "1,green,1,1,1,0,0xA1" >> llp_Dev_Config.txt			#green - Value goes from HOST TO FW and bitmap=0 
	echo "1,blue,2,1,1,0,0xA1" >> llp_Dev_Config.txt			#blue - Value goes from HOST TO FW and bitmap=0 

	# LIGHT_TEMP
	echo "2,warm,0,1,1,0,0xA1" >> llp_Dev_Config.txt			#warm - Value goes from HOST TO FW and bitmap=0 
	echo "2,natural,1,1,1,0,0xA1" >> llp_Dev_Config.txt         #natural - Value goes from HOST TO FW and bitmap=0 
	echo "2,cool,2,1,1,0,0xA1" >> llp_Dev_Config.txt			#cool - Value goes from HOST TO FW and bitmap=0 
	
	# LIGHT_DIMM
	echo "3,dimm,0,1,1,8,0xA1" >> llp_Dev_Config.txt			#dimm - Value goes from HOST TO FW and bitmap=0 

	# SENSOR_BOARD
	echo "4,SensorSecMode,0,1,2,12,0x1" >> llp_Dev_Config.txt	#SensorSecMode - BIDIRECTIONAL & Generate event for TCP.
	echo "4,opMode,1,1,2,12,0xA1" >> llp_Dev_Config.txt			#opMode - BIDIRECTIONAL & Generate event for TCP.
	echo "4,sleep,2,1,1,12,0xA1" >> llp_Dev_Config.txt			#sleep - HOST TO FW & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,onoff,3,1,2,12,0xA1" >> llp_Dev_Config.txt			#onoff - BIDIRECTIONAL & Generate event for TCP.
	echo "4,light,4,4,0,8,0xA1" >> llp_Dev_Config.txt			#light - FW TO HOST & Generate event for TCP.
	echo "4,utlight,5,4,3,4,0xA1" >> llp_Dev_Config.txt			#utlight - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,ltlight,6,4,3,4,0xA1" >> llp_Dev_Config.txt			#ltlight - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,temp,7,4,0,8,0xA1" >> llp_Dev_Config.txt			#temp - FW TO HOST & Generate event for TCP.
	echo "4,uttemp,8,4,3,4,0xA1" >> llp_Dev_Config.txt			#uttemp - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "4,lttemp,9,4,3,4,0xA1" >> llp_Dev_Config.txt          #lttemp - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "4,motion,10,1,0,8,0xA1" >> llp_Dev_Config.txt			#motion - FW TO HOST & Generate event for TCP.
	echo "4,enmotion,11,1,1,12,0xA1" >> llp_Dev_Config.txt		#enmotion - HOST TO FW & Generate event for TCP while tore TLV into flash and 
																#			send in update request to. Whether the TLV should go out or not is decided on #			  basis of above tx flag value
	echo "4,motiontimeout,12,2,1,4,0xA1" >> llp_Dev_Config.txt	#motiontimeout - HOST TO FW & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "4,slider,13,4,2,4,0xA1" >> llp_Dev_Config.txt			#slider - BIDIRECTIONAL & Generate event for TCP & Store TLV into flash.
	echo "4,ulslider,14,4,3,4,0xA1" >> llp_Dev_Config.txt		#ulslider - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,llslider,15,4,3,4,0xA1" >> llp_Dev_Config.txt	    #llslider - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,humidity,16,4,0,8,0xA1" >> llp_Dev_Config.txt		#humidity - FW TO HOST & Generate event for TCP.
	echo "4,uhumidity,17,4,3,4,0xA1" >> llp_Dev_Config.txt		#uhumidity - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,lhumidity,18,4,3,4,0xA1" >> llp_Dev_Config.txt		#lhumidity - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "4,sonoff,19,1,2,12,0xA1" >> llp_Dev_Config.txt			#sonoff - BIDIRECTIONAL & Generate event for TCP.
	echo "4,ledstatusen,20,1,2,12,0x1" >> llp_Dev_Config.txt		#ledstatusen - FW TO HOST & Generate event for TCP.

	# SMART_PLUG
	echo "5,mConfig,0,1,1,8,0x1" >> llp_Dev_Config.txt			#mConfig - HOST TO FW & Generate event for TCP.
	echo "5,mVal,1,1,0,8,0x1" >> llp_Dev_Config.txt				#mVal - FW TO HOST & Generate event for TCP.
	echo "5,SecMode,2,1,1,8,0x1" >> llp_Dev_Config.txt			#SecMode - HOST TO FW & Generate event for TCP.
	echo "5,plug_1,3,1,1,8,0xA1" >> llp_Dev_Config.txt			#plug_1 - HOST TO FW & Generate event for TCP.
	echo "5,current_1,4,4,0,8,0xA1" >> llp_Dev_Config.txt		#current_1 - FW TO HOST & Generate event for TCP.
	echo "5,voltage_1,5,4,0,8,0xA1" >> llp_Dev_Config.txt		#voltage_1 - FW TO HOST & Generate event for TCP.
	echo "5,power_1,6,4,0,8,0xA1" >> llp_Dev_Config.txt			#power_1 - FW TO HOST & Generate event for TCP.
	echo "5,plug_2,7,1,1,8,0xA1" >> llp_Dev_Config.txt			#plug_2 - HOST TO FW & Generate event for TCP.
	echo "5,current_2,8,4,0,8,0xA1" >> llp_Dev_Config.txt		#current_2 - FW TO HOST & Generate event for TCP.
	echo "5,voltage_2,9,4,0,8,0xA1" >> llp_Dev_Config.txt		#voltage_2 - FW TO HOST & Generate event for TCP.
	echo "5,power_2,10,4,0,8,0xA1" >> llp_Dev_Config.txt		#power_2 - FW TO HOST & Generate event for TCP.

	# SMART_LIGHT
	echo "6,slight_onoff,0,1,1,4,0xA1" >> llp_Dev_Config.txt		#slight_onoff - HOST TO FW & BITMAP = 0	
	echo "6,slight_sw_1,1,1,2,4,0xA1" >> llp_Dev_Config.txt			#slight_sw_1 - BIDIRECTIONAL & BITMAP = 0	
	echo "6,slight_sw_2,2,1,2,4,0xA1" >> llp_Dev_Config.txt			#slight_sw_2 - BIDIRECTIONAL & BITMAP = 0	
	echo "6,slight_1,3,1,2,4,0xA1" >> llp_Dev_Config.txt			#slight_1 - BIDIRECTIONAL & BITMAP = 0
	echo "6,slight_2,4,1,2,4,0xA1" >> llp_Dev_Config.txt 			#slight_2 - BIDIRECTIONAL & BITMAP = 0
	echo "6,slight_3,5,1,2,4,0xA1" >> llp_Dev_Config.txt 			#slight_3 - BIDIRECTIONAL & BITMAP = 0
	echo "6,slight_4,6,1,2,4,0xA1" >> llp_Dev_Config.txt 			#slight_4 - BIDIRECTIONAL & BITMAP = 0
	echo "6,slight_motion,7,1,2,4,0xA1" >> llp_Dev_Config.txt		#slight_motion - BIDIRECTIONAL & BITMAP = 0
	echo "6,slight_sw_1_name,8,4,3,4,0xA1" >> llp_Dev_Config.txt	#slight_sw_1_name - Dont Send & store/Update Device Name to flash.
	echo "6,slight_sw_2_name,9,4,3,4,0xA1" >> llp_Dev_Config.txt	#slight_sw_2_name - Dont Send & store/Update Device Name to flash.
	echo "6,slight_name_1,10,4,3,4,0xA1" >> llp_Dev_Config.txt		#slight_name_1 - Dont Send & store/Update Device Name to flash.
	echo "6,slight_name_2,11,4,3,4,0xA1" >> llp_Dev_Config.txt		#slight_name_2 - Dont Send & store/Update Device Name to flash.
	echo "6,slight_name_3,12,4,3,4,0xA1" >> llp_Dev_Config.txt		#slight_name_3 - Dont Send & store/Update Device Name to flash.
	echo "6,slight_name_4,13,4,3,4,0xA1" >> llp_Dev_Config.txt		#slight_name_4 - Dont Send & store/Update Device Name to flash.
	
	# RELAY_PWM
	echo "8,onoff,0,1,0,4,0xA1" >> llp_Dev_Config.txt			#onoff - FW TO HOST & BITMAP = 0	

	# SEC_SENSOR
	echo "9,tps_motion,0,1,0,8,0xA1" >> llp_Dev_Config.txt		#tps_motion - FW TO HOST & Generate event for TCP.
	echo "9,tps_doorlock,1,1,0,12,0xA1" >> llp_Dev_Config.txt	#tps_doorlock - FW TO HOST & Generate event for TCP.
	echo "9,tps_alarm1,2,1,3,0,0xA1" >> llp_Dev_Config.txt		#tps_rev1 - Dont Send this TLV & BITMAP = 0	
	echo "9,tps_alarm2,3,1,3,0,0xA1" >> llp_Dev_Config.txt		#tps_rev2 - Dont Send this TLV & BITMAP = 0	
	echo "9,tps_tamper,4,1,3,0,0xA1" >> llp_Dev_Config.txt	 	#tps_rev3 - Dont Send this TLV & BITMAP = 0	
	echo "9,tps_battery,5,1,3,0,0xA1" >> llp_Dev_Config.txt		#tps_rev4 - Dont Send this TLV & BITMAP = 0	
	echo "9,tps_secm,6,1,3,4,0xA1" >> llp_Dev_Config.txt		#tps_secm - Dont Send this TLV & store TLV into flash and send in update request to. Whether
																#			the TLV should go out or not is decided on basis of above tx flag value.

	# DEVICE_IAS
	echo "10,tpi_rev1,0,1,1,8,0xA1" >> llp_Dev_Config.txt		#tpi_rev1 - HOST TO FW & BITMAP = 8, Generate event for TCP.	
	echo "10,tpi_secm,1,1,3,4,0xA1" >> llp_Dev_Config.txt		#tpi_secm - Dont Send this TLV & store TLV into flash and send in update request to. Whether
																#			the TLV should go out or not is decided on basis of above tx flag value.

	# SCURITY_PLUG
	echo "11,SensorSecMode,0,1,2,12,0x1" >> llp_Dev_Config.txt	#SensorSecMode - BIDIRECTIONAL & Generate event for TCP.
	echo "11,opMode,1,1,2,12,0xA1" >> llp_Dev_Config.txt			#opMode - BIDIRECTIONAL & Generate event for TCP.
	echo "11,sleep,2,1,1,12,0xA1" >> llp_Dev_Config.txt			#sleep - HOST TO FW & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,onoff,3,1,2,12,0xA1" >> llp_Dev_Config.txt			#onoff - BIDIRECTIONAL & Generate event for TCP.
	echo "11,light,4,4,0,8,0xA1" >> llp_Dev_Config.txt			#light - FW TO HOST & Generate event for TCP.
	echo "11,utlight,5,4,3,4,0xA1" >> llp_Dev_Config.txt			#utlight - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,ltlight,6,4,3,4,0xA1" >> llp_Dev_Config.txt			#ltlight - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,temp,7,4,0,8,0xA1" >> llp_Dev_Config.txt			#temp - FW TO HOST & Generate event for TCP.
	echo "11,uttemp,8,4,3,4,0xA1" >> llp_Dev_Config.txt			#uttemp - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "11,lttemp,9,4,3,4,0xA1" >> llp_Dev_Config.txt          #lttemp - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "11,motion,10,1,0,8,0xA1" >> llp_Dev_Config.txt			#motion - FW TO HOST & Generate event for TCP.
	echo "11,enmotion,11,1,1,12,0xA1" >> llp_Dev_Config.txt		#enmotion - HOST TO FW & Generate event for TCP while tore TLV into flash and 
																#			send in update request to. Whether the TLV should go out or not is decided on #			  basis of above tx flag value
	echo "11,motiontimeout,12,2,1,4,0xA1" >> llp_Dev_Config.txt	#motiontimeout - HOST TO FW & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value
	echo "11,slider,13,4,2,12,0xA1" >> llp_Dev_Config.txt			#slider - BIDIRECTIONAL & Generate event for TCP.
	echo "11,ulslider,14,4,3,4,0xA1" >> llp_Dev_Config.txt		#ulslider - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,llslider,15,4,3,4,0xA1" >> llp_Dev_Config.txt	    #llslider - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,humidity,16,4,0,8,0xA1" >> llp_Dev_Config.txt		#humidity - FW TO HOST & Generate event for TCP.
	echo "11,uhumidity,17,4,3,4,0xA1" >> llp_Dev_Config.txt		#uhumidity - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,lhumidity,18,4,3,4,0xA1" >> llp_Dev_Config.txt		#lhumidity - Dont Send & Store TLV into flash and send in update request to. 
																#        Whether the TLV should go out or not is decided on basis of above tx flag value.
	echo "11,sonoff,19,1,2,12,0x1" >> llp_Dev_Config.txt			#sonoff - BIDIRECTIONAL & Generate event for TCP.
	echo "11,ledstatusen,20,1,1,12,0x1" >> llp_Dev_Config.txt		#ledstatusen - HOST TO FW & Generate event for TCP.

	# SMART_GRID
	echo "20,smartgrid_onoff,0,1,1,0,0xA1" >> llp_Dev_Config.txt	#smartgrid_onoff - HOST TO FW & BITMAP = 0
	echo "20,smartgrid_rx,1,4,0,0,0xA1" >> llp_Dev_Config.txt		#smartgrid_rx -	FW TO HOST & BITMAP = 0
	echo "20,smartgrid_tx,2,4,1,0,0xA1" >> llp_Dev_Config.txt		#smartgrid_tx - HOST TO FW & BITMAP = 0

	# Viettel device 1
	echo "101,red,0,1,2,4,0xA1" >> llp_Dev_Config.txt	
	echo "101,green,1,1,2,4,0xA1" >> llp_Dev_Config.txt	
	echo "101,blue,2,1,2,4,0xA1" >> llp_Dev_Config.txt	
	echo "101,doorstatus,3,1,2,4,0xA1" >> llp_Dev_Config.txt

	# Viettel device 2
	echo "102,irdatatx,0,4,1,0,0xA1" >> llp_Dev_Config.txt	
	echo "102,irdatarx,1,4,0,0,0xA1" >> llp_Dev_Config.txt	

	cp llp_Dev_Config.txt /opt/greenvity/llp/llp_Dev_Config.txt
fi
