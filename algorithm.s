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

# MotCtl_in[0] 	RMDir		- Reverse or Forward
# MotCtl_in[3:1]	RMSpd 3'b	- Speed of Reverse or Forward
# MotCtl_in[4]	LMDir		- Reverse or Forward
# MotCtl_in[7:5]	LMSpd 3'b	- Speed of Reverse or Forward

SP_LSRS 	= 0x00		#0000_0000 left motor off, right motor off 				[0000]
SP_LFRS 	= 0x30		# left motor forward, right motor off 			[1000]
SP_LFRF	 	= 0x33		# left motor forward, right motor forward		[1010]

######################################
###---Begin High Level Algorithm---###-------------------------------------------------------------------------------------------------#
######################################


	#IF The Robot is on a black line			*Sensors_reg*
		#SET the line flag.

		#THEN(
		
			#IF Current State is Reverse 		*BotInfo_reg*
				#THEN Set next motion register to Reverse
				#IF Line is Present
					#THEN Set Next state to halt
				#ELSE
					#THEN Set Next state to reverse
					#THEN Continue (Return)
			#ELSE IF Current State is Forward	*BotInfo_reg*
				#IF Motion is already set to forward
					#THEN Update the backwards register from current orientation moving forward.
				#ELSE IF Line is not present
					#THEN Set next state as reverse
				#ELSE 
					#THEN Update next state to forward
					#THEN Update motion register to forward motion. 
					#THEN set next motion register to forward.
				#CONTINUE (return)
			#ELSE IF Current State is Rotate	*BotInfo_reg*
				#THEN Clear the reverse flag register
				#THEN Update the current orientation Register
				#IF Current orientation register and Target orientation register matches
					#THEN Set next state as forward.
				#ELSE
					#THEN Set next motion register to turn right.
					#THEN update next state to Rotate 
			#ELSE
				#THEN  Update current orientation
					#IF Target orientation is at setting 315 degrees
						#THEN Wrap around to zero degrees.
					#ELSE
						#THEN Increment the next orientation by 45 degrees.
				#THEN Test the Line and Reverse Registers
					#IF Reverse reg is set and Line reg is set 
						#THEN Set next state as reverse.
					#ELSE IF Reverse reg is set and Line reg is clear 
						#THEN Set next state as rotate. 
					#ELSE IF Reverse reg is clear and Line reg is Clear
						#THEN Set next state to fwd.
					#ELSE
						#THEN Set the next state to halt.
						#THEN Continue (return)



###################################
####-Begin Low Level Algorithm-####-------------------------------------------------------------------------------------------------#
###################################

#-----------------------------------------------------------------------------------------------------
#
#	Available Registers: (From unused btn2mot() function)
#	$25
#	#4
#	$2 - Line present register (0 means line present)
#
##	Added Registers:
#	$8 - Next target orientation for rotation.
#	$15 - Next State register
#	$16 - Reverse flag register
#	$17 - Current Backwards orientation register
#	$18 - Current Orientation register
#	$19	- Next Motion register
#
#	New Stack Pointer Variables:
#		SP_BKWDS - Retains the last orientation that was 180 frome direction of black line traversal.
#		SP_FWDS - Retains the last orientation that forward along black line traversal.
#
#-----------------------------------------------------------------------------------------------------

		linecheck:
		li $20, PORT_BOTINFO
		lw $20, 0($20)
		li $21, PORT_BOTCTRL
		lw $21, 0($21)
		li $25, PORT_BOTINFO	# Load Bot info reg address for sensor info.
		lw $2, 0($25)			# Load Bot info reg value.
		ANDi $2, $2, 0x0200		# Mask out all but the black line sensor bits.
		SRL $2, $2, 9			# shift eight to put the value in the bit 0 spot.
		#$2[0] holds the line status
	state:
		#$15 holds the current state. 
		#00 - halt
		andi $15, $15, 0x3	# Mask the lower two bits.
		beqz $15, halt
		li $4, 0x3			# Testing for reverse state 11
		subu $4, $15, $4	
		beqz $4, reverse
		li $4, 0x2			# Testing for fwd state 10
		subu $4, $15, $4
		beqz $4, fwd
		li $4, 0x1			# Testing for rotate state 01
		subu $4, $15, $4
		beqz $4, r45

	halt:
	
		li $19, SP_LSRS			# Load control to halt.
	
		li $25, PORT_BOTINFO	# Load Bot info reg address.
		lw $4, 0($25)			# Load Bot info reg value.
		andi $8, $4, 0x7		# update current orientation
		haltspin:
		li $4, 0x7
		subu $4, $8, $4
		beqz $4, settgtorient

		addi $8, $8, 0x1		# increment clockwise, the next target rotation value.
		b cont_halt

		settgtorient:
		li $8, 0x0

		cont_halt:
		ADD $4, $16, $2			# combine reverse and line flags
		andi $4, $4, 0x3		# mask lower 2 bits.
		li $25, 0x3 			# test for reverse
		subu $25, $4, $25
		beqz $25, setreverse
		
		li $25, 0x2				# Test for rotate
		subu $25, $4, $25	
		beqz $25, setr45
		
		li $25, 0x0
		subu $25, $4, $25
		beqz $25, setfwd
		
		li $15, 0x0			# load state flag as halted.
		b ret_next_step
				
		setr45:	li $15, 0x1
		b ret_next_step

	fwd:
		# Go Forward	*MotCtl_in reg*					
		li $16, 0x0
		subu $4, $18, $17
		beqz $4, haltspin
		li $4, SP_LFRF
		sub $4, $19, $4			# Test to see if already moving forward.
		beqz $4, updtbkwds
		b line_present
		

	updtbkwds:
		li $25, PORT_BOTINFO	# Load Bot info reg address.
		lw $4, 0($25)			# Load Bot infor reg value.
		ANDi $4, $4, 0x07 		# Mask out all but Orient info reg from port.
		li $17, 0x4
		subu $4, $4, $17		# subtract 4
		and $4, $4, 0x7
		move $17, $4			# Store the Backwards orientation to the backwards reg.
		
	line_present:
		bnez $2, setreverse		# change state to reverse if line is not present.
		li $15, 0x2			# update next state to fwd
		li $19, SP_LFRF			# Load control to move forward.
		b ret_next_step
		
		setreverse: li $15, 0x3	#Next state is reverse 
		b ret_next_step
		
	reverse:
		# Reverse	*MotCtl_in reg*
		li $19, SP_LRRR			# Load control to reverse.
		li $4, 0x2				# Reverse Flag value
		move $16, $4			# Write to register.
		
		beqz $2, sethalt		# change state if line present.
		li $15, 0x3				# Next state is reverse.
		b ret_next_step		
		
		sethalt: li $15, 0x0	# Set next state to halt
		b ret_next_step		

	r45:
		# Test to see if orientation matches backwards register
		li $16, 0x0				# Clear reverse flag.
		li $25, PORT_BOTINFO	# Load Bot info reg address.
		lw $4, 0($25)			# Load Bot info reg value.
		andi $18, $4, 0x7		# update current orientation
		andi $8, $8, 0x7
		subu $4, $18, $8
		beqz $4, setfwd			# Test for matching dirctions before moving forward.

		li $19, SP_LFRS			# Load control to turn right .
		
		li $15, 0x1				# update state
		b ret_next_step
		
		setfwd:
		li $15, 0x2				# Next state is fwd.
		b ret_next_step