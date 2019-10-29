#Black Line Sensors: BlkLL, BlkLC, BlkLR. [000] - Robot is on Black Line, [111] - No Black Line Present. 
#Proximity Sensors: ProxL, ProxR (Both ProxL and ProxR are 1'b1 if Obstruction is directly ahead of robot).
#Backwards Variable: SP_BKWDS - Updated when robot is moving forward on black line. 

################################
#-----Sensor Register Info-----#------------------------------------------------------------------------------------------------#
################################

PORT_BOTINFO		= 0xbf80000c		# (i) Bot Info port

#Sensors_reg = IO_BotInfo[15:8]

MSKSENSOR	= 0x0000FF00

#Sensors_reg[0]	BlkLR
#Sensors_reg[1]	BlkLC
#Sensors_reg[2]	BlkLL
#Sensors_reg[3]	ProxR
#Sensors_reg[4]	ProxL

# sensor info masks
MSKPROXL	= 0x10		# Mask out Proximity L sensor
MSKPROXR	= 0x08		# Mask out Proximity R sensor
MSKBLKL 	= 0x07		# Mask out Black line sensor
MSKPROX		= 0x18		# Mask out all but proximity sensor bits

################################
#-----Bot Info Register Info-----#------------------------------------------------------------------------------------------------#
################################

PORT_BOTINFO		= 0xbf80000c		# (i) Bot Info port

#BotInfo_reg = IO_BotInfo[7:0]

MSKBOTINFO	= 0x000000FF

#BotInfo_reg[2:0] Orient - Orientation bits.


########################################
#-----Motion Control Register Info-----#------------------------------------------------------------------------------------------------#
########################################

PORT_BOTCTRL		= 0xbf800010		# (o) Bot Control port

#MotCtl_in[0] 	RMDir		- Reverse or Forward
#MotCtl_in[3:1]	RMSpd 3'b	- Speed of Reverse or Forward
#MotCtl_in[4]	LMDir		- Reverse or Forward
#MotCtl_in[7:5]	LMSpd 3'b	- Speed of Reverse or Forward

SP_LSRS 	= 0x00		#0000_0000 left motor off, right motor off 				[0000]
SP_LORR 	= 0x02		#0000_0010 left motor off, right motor reverse			[0001]
SP_LSRF 	= 0x03		#0000_0011 left motor off, right motor forward			[0010]
SP_LSRFR	= 0x00		#0000_0000 left motor off, right motor fwd & rev = off	[0011]
SP_LRRS 	= 0x20		#0010_0000 left motor reverse, right motor off			[0100]
SP_LRRR 	= 0x22		# left motor reverse, right motor reverse		[0101]
SP_LRRF 	= 0x23		# left motor reverse, right motor forward		[0110]
SP_LRRFR 	= 0x20		# left motor rev, right motor fwd & rev = off	[0111]
SP_LFRS 	= 0x30		# left motor forward, right motor off 			[1000]
SP_LFRR 	= 0x32		# left motor forward, right motor reverse		[1001]
SP_LFRF	 	= 0x33		# left motor forward, right motor forward		[1010]
SP_LFRFR 	= 0x30		# left motor fwd, right motor fwd & rev = off	[1011]
SP_LFRRS 	= 0x00		# left motor fwd & rev = off, right motor off	[1100]
SP_LFRRR 	= 0x02		# left motor fwd & rev = off, right motor rev	[1101]
SP_LFRRF 	= 0x03		# left motor fwd & rev = off, right motor fwd	[1110]
SP_LFRRFR 	= 0x00		# left  and right motor fwd & rev = off			[1111]

######################################
###---Begin High Level Algorithm---###-------------------------------------------------------------------------------------------------#
######################################


#WHILE( Forever )
	#IF( The Robot is on a black line )  *Sensors_reg*
		#THEN( 
			#IF( Current Motion is Reverse )	*BotInfo_reg*
				#THEN( 
					# Rotate 45 degrees clockwise	*MotCtl_in reg*
				#)
			#ELSE IF( Current Motion is Forward)	*BotInfo_reg*
				#THEN(
					#Update the known backwards direction from current direction	*SP_BKWDS Variable*
				#)
			#ELSE
				#THEN(
					#IF(   is equal to known backwards direction ) *SP_BKWDS Variable*
						# Rotate 45 degrees clockwise	*MotCtl_in reg*
					#ELSE
						# Go Forward	*MotCtl_in reg*
				#)
	#ELSE
		#THEN(
			# Reverse	*MotCtl_in reg*
		#)
#ENDWHILE


###################################
####-Begin Low Level Algorithm-####-------------------------------------------------------------------------------------------------#
###################################

#-----------------------------------------------------------------------------------------------------
#
#	Available Registers: (From unused btn2mot() function)
#	$25
#	$2
#	#4
#
#	New Stack Pointer Variables:
#		SP_BKWDS - Retains the last orientation that was 180 frome direction of black line traversal.
#		SP_FWDS - Retains the last orientation that forward along black line traversal.
#
#-----------------------------------------------------------------------------------------------------
		
		
#WHILE( Forever )
while_loop:
	#IF( The Robot is on a black line )
	li $25, PORT_BOTINFO	# Load Bot info reg address for sensor info.
	lw $2, 0($25)			# Load Bot info reg value.
	ANDi $2, $2, MSKBLKL	# Mask out all but the black line sensor bits.
	ORi $2, $2, 0			# Test to see if all bits are 0 or 1s
	BNEZ no_line			# Branch to Else if no black line detected.
		#THEN( 
			#Go Forward
			li $25, PORT_BOTCTRL	# Load Bot control reg address.
			li $2, SP_LFRF			# Load control to move forward.
			sw $2, 0($25)			# Write forward to control reg.
			
			#Update the known forward direction
			li $25, PORT_BOTINFO	# Load Bot info reg address.
			lw $2, 0($25)			# Load Bot infor reg value.
			ANDi $2, $2, MSKBOTINFO # Mask out all but info reg from port.
			la $25, (SP_FWDS)		# Load the Forward variable address.
			sb $2, 0($25)			# Store the Forward orientation to the variables.

			#Update the known backwards direction from current direction )		#Goes in next_mvmt()
				#Rotate the current orientation by 1/2 pi.
			ADDi $2, $2, 0x8		
			sra $2, $2, 1
			la $25, (SP_BKWDS)		# Load the Backwards variable address.
			sb $2, 0($25)			# Store the Backwards orientation into the variable. 
			
	#ELSE
	no_line:
		#THEN( 
			# Backup
			li $25, PORT_BOTCTRL	# Load Bot control reg address.
			li $2, SP_LRRR			# Load control to reverse.
			sw $2, 0($25)			# Write reverse to control reg.
			# IF( Orientation is equal to known backwards direction )
				#THEN( 
					# Rotate 45 degrees clockwise
					li $25, PORT_BOTCTRL	# Load Bot control reg address.
					li $2, SP_LRRS			# Load control to turn right .
					sw $2, 0($25)			# Write right turn to control reg.

			#ELSE
				#THEN( Go Forward )
				li $25, PORT_BOTCTRL	# Load Bot control reg address.
				li $2, SP_LFRF			# Load control to move forward.
				sw $2, 0($25)	
#ENDWHILE
	