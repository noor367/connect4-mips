########################################################################
# Assignment -- Connect Four!
#
#
# This program was written on 08-07-22
#
#
########################################################################

#![tabsize(8)]

# Constant definitions.
# DO NOT CHANGE THESE DEFINITIONS

# MIPS doesn't have true/false by default
true  = 1
false = 0

# How many pieces we're trying to connect
CONNECT = 4

# The minimum and maximum board dimensions
MIN_BOARD_DIMENSION = 4
MAX_BOARD_WIDTH     = 9
MAX_BOARD_HEIGHT    = 16

# The three cell types
CELL_EMPTY  = '.'
CELL_RED    = 'R'
CELL_YELLOW = 'Y'

# The winner conditions
WINNER_NONE   = 0
WINNER_RED    = 1
WINNER_YELLOW = 2

# Whose turn is it?
TURN_RED    = 0
TURN_YELLOW = 1

########################################################################
# .DATA
# YOU DO NOT NEED TO CHANGE THE DATA SECTION
	.data

# char board[MAX_BOARD_HEIGHT][MAX_BOARD_WIDTH];
board:		.space  MAX_BOARD_HEIGHT * MAX_BOARD_WIDTH

# int board_width;
board_width:	.word 0

# int board_height;
board_height:	.word 0


enter_board_width_str:	.asciiz "Enter board width: "
enter_board_height_str: .asciiz "Enter board height: "
game_over_draw_str:	.asciiz "The game is a draw!\n"
game_over_red_str:	.asciiz "Game over, Red wins!\n"
game_over_yellow_str:	.asciiz "Game over, Yellow wins!\n"
board_too_small_str_1:	.asciiz "Board dimension too small (min "
board_too_small_str_2:	.asciiz ")\n"
board_too_large_str_1:	.asciiz "Board dimension too large (max "
board_too_large_str_2:	.asciiz ")\n"
red_str:		.asciiz "[RED] "
yellow_str:		.asciiz "[YELLOW] "
choose_column_str:	.asciiz "Choose a column: "
invalid_column_str:	.asciiz "Invalid column\n"
no_space_column_str:	.asciiz "No space in that column!\n"


############################################################
####                                                    ####
####   Your journey begins here, intrepid adventurer!   ####
####                                                    ####
############################################################


########################################################################
#
# Implement the following 7 functions,
# and check these boxes as you finish implementing each function
#
#  - [X] main
#  - [X] assert_board_dimension
#  - [X] initialise_board
#  - [X] play_game
#  - [X] play_turn
#  - [X] check_winner
#  - [X] check_line
#  - [X] is_board_full	(provided for you)
#  - [X] print_board	(provided for you)
#
########################################################################


########################################################################
# .TEXT <main>
	.text
main:
	# Args:     void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [$ra, ...]
	# Uses:     [$v0,$a0,$a1,$a2]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   main
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

main__prologue:
	begin			# begin a new stack frame
	push    $ra		# | $ra

main__body:
	# TODO ... complete this function
	
	la      $a0, enter_board_width_str              # printf("Enter board width: ")
	li      $v0, 4
	syscall                 
	
	li      $v0, 5                                  
	syscall                 
	la      $a0, board_width        
	sw      $v0, board_width                        # scanf("%d", &board_width);
	
	move    $a0, $v0
	li      $a1, MIN_BOARD_DIMENSION
	li      $a2, MAX_BOARD_WIDTH
	jal     assert_board_dimension                  # check width dimension
	
	la      $a0, enter_board_height_str
	li      $v0, 4
	syscall                                         # printf("Enter board height: "); 
	
	li      $v0, 5
	syscall                                         
	la      $a0, board_height       
	sw      $v0, board_height                       # scanf("%d", &board_height);  
	
	move    $a0, $v0
	li      $a1, MIN_BOARD_DIMENSION
	li      $a2, MAX_BOARD_HEIGHT
	jal     assert_board_dimension                  # check height dimension
	
	jal     initialise_board                        # create board
	jal     print_board                             # print board
	jal     play_game                               # start the game

main__epilogue:
	pop	$ra		# | $ra
	end			# ends the current stack frame

	li	$v0, 0
	jr	$ra		# return 0;


########################################################################
# .TEXT <assert_board_dimension>
	.text
assert_board_dimension:
	# Args:
	#   - $a0: int dimension
	#   - $a1: int min
	#   - $a2: int max
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   assert_board_dimension
	#   -> [prologue]
	#   -> body
	#       -> small
	#       -> large
	#   -> [epilogue]

assert_board_dimension__prologue:
	begin			                                # begin a new stack frame
	push	$ra		                                # | $ra
        
assert_board_dimension__body:

        blt     $a0, $a1, assert_board_small                    # if dimension < min
        bgt     $a0, $a2, assert_board_large                    # if dimension > max
        
        j       assert_board_dimension__epilogue                # goto end

assert_board_small:
	la      $a0, board_too_small_str_1              # load address into $a0
	li      $v0, 4                
	syscall                                         # printf("Board dimension too small (min "); 
	
	move    $a0, $a1
	li      $v0, 1
	syscall                                         # printf("%d", MIN_BOARD_DIMENSION);
	
	la      $a0, board_too_small_str_2
	li      $v0, 4          
	syscall                                         # printf(")\n");
	
	la	$a0, 1 
	li      $v0, 17
	syscall

assert_board_large:
	li      $a0, board_too_large_str_1
	li      $v0, 4 
	syscall                                         # printf("Board dimension too large (max "); 
	
	move    $a0, $a2                              
	li      $v0, 1                               
	syscall                                         # printf("%d", MAX_BOARD_HEIGHT);
	
	la      $a0, board_too_large_str_2            
	li      $v0, 4                                 
	syscall                                         # printf(")\n");
	
	la      $a0, 1
	li      $v0, 17
	syscall

assert_board_dimension__epilogue:
      	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;


########################################################################
# .TEXT <initialise_board>
	.text
initialise_board:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0,$t0,$t1,$t3,$t4,$t5,$t6]
	# Clobbers: [...]
	#
	# Locals:
	#   - $t0: int board_width
	#   - $t1: int board_height
	#   - $t2: int row
	#   - $t3: int col
	#
	# Structure:
	#   initialise_board
	#   -> [prologue]
	#   -> body
	#   -> [epilogue]

initialise_board__prologue:
        begin
        push    $ra
        
        lw      $t0, board_width                # $t0 = board_width
        lw      $t1, board_height               # $t1 = board_height
        
        li      $t2, 0                          # $t2 = row = 0
        li      $t3, 0                          # $t3 = col = 0
        
        j       initialise_board_loop
        
initialise_board__body:

	# TODO ... complete this function
        bgt     $t2, $t1, initialise_board__epilogue            # if row < board_height
        
        addi    $t2, $t2, 1                                     # row++
        li      $t3, 0                                          # $t3 = col = 0
        
initialise_board_loop:

        #li      $s0, MAX_BOARD_WIDTH
        
        mul     $t4, $t2, MAX_BOARD_WIDTH               # $t4 = row * MAX_BOARD_WIDTH
        add     $t4, $t4, $t3                           # $t4 = $t4 + col
        
        la      $t5, board                              # load address of the array
        add     $t5, $t5, $t4
        
        la      $t6, CELL_EMPTY                         # $t6 = CELL_EMPTY
        sb      $t6, board($t4)                         # board() = CELL_EMPTY
        
        addi    $t3, $t3, 1
        
        bgt     $t3, $t0, initialise_board__body
        
        j       initialise_board_loop
        
initialise_board__epilogue:
	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;

########################################################################
# .TEXT <play_game>
	.text
play_game:
	# Args:     void
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0,$s0,$s1,$s2]
	# Clobbers: [...]
	#
	# Locals:
	#   - $s0: int whose_turn
	#   - $s1: int winner
	#   - $s2: is_board_full
	#
	# Structure:
	#   play_game
	#   -> [prologue]
	#   -> body
	#       -> loop 
	#       -> ending
	#       -> draw
	#       -> red 
	#       -> yellow
	#   -> [epilogue]

play_game__prologue:
        begin			# begin a new stack frame
	push	$ra		# | $ra
	#push    $s0
	#push    $s1
	#push    $s2
        
        li      $s0, TURN_RED
        
play_game__body:

	# TODO ... complete this function
	move    $a1, $s0
	jal     play_turn
	move    $s0, $v0
	
	li      $s1, WINNER_NONE
	
	jal     print_board

play_game_loop:
	
	jal     check_winner
	move    $s1, $v0                                        # $t0 = winner = check_winner()
	bne     $s1, WINNER_NONE, play_game_ending              # while (winner == WINNER_NONE
	
	jal     is_board_full
	move    $s2, $v0
	beq     $s2, true, play_game_ending                     # && !is_board_full())
	
	move    $a1, $s0
	jal     play_turn
	move    $s0, $v0                                        # $a0 = whose_turn 
	
	jal     print_board
	
	j       play_game_loop

play_game_ending:
        beq     $s1, WINNER_RED, play_game_red                  # if (winner == WINNER_RED)
        beq     $s1, WINNER_YELLOW, play_game_yellow            # if (winner == WINNER_YELLOW)

play_game_draw:
        la      $a0, game_over_draw_str               
        li      $v0, 4
        syscall                                         # printf("The game is a draw!\n");
        
        j       play_game__epilogue

play_game_red:
        la      $a0, game_over_red_str
        li      $v0, 4
        syscall                                         # printf("Game over, Red wins!\n");
        
        j       play_game__epilogue

play_game_yellow:
        la      $a0, game_over_yellow_str
        li      $v0, 4
        syscall                                         # printf("Game over, Yellow wins!\n");
        
play_game__epilogue:
	#pop     $s2
	#pop     $s1
	#pop     $s0
	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;


########################################################################
# .TEXT <play_turn>
	.text
play_turn:
	# Args:
	#   - $a1: int whose_turn
	# Returns:  void
	#
	# Frame:    [$ra]
	# Uses:     [$v0,$s0,$s1,$s2,$s3,$t0,$t1,$t2]
	# Clobbers: [$v0,$a1,$t0,$t1,$t2]
	#
	# Locals:
	#   - $s0: int board_width
	#   - $s1: int board_height
	#   - $s2: cell value
	#   - $s3: cell change
	#   - $t0: target_col
	#   - $t1: target_row
	#   - $t2: offset
	#
	# Structure:
	#   play_turn
	#   -> [prologue]
	#   -> body
	#       -> red
	#       -> yellow 
	#       -> test
	#       -> check_space
	#       -> invalid 
	#       -> valid
	#       -> valid_red
	#   -> [epilogue]

play_turn__prologue:
        begin			                                # begin a new stack frame
	push	$ra		                                # | $ra
	#push    $s0
	#push    $s1
	#push    $s2
	#push    $s3
	
	lw      $s0, board_width                                # $s0 = board_width
        lw      $s1, board_height                               # $s1 = board_height
	
	beq     $a1, TURN_RED, play_turn_red                    # if whose_turn = RED
	beq     $a1, TURN_YELLOW, play_turn_yellow              # if whose_turn = YELLOW
        
play_turn__body:

	# TODO ... complete this function
play_turn_red:
        la      $a0, red_str                   # printf("[RED] ");
        li      $v0, 4
        syscall

        j       play_turn_test       
        
play_turn_yellow:
        la      $a0, yellow_str                # printf("[RED] ");
        li      $v0, 4
        syscall

play_turn_test:
        la	$a0, choose_column_str
        li 	$v0, 4
        syscall                                         # printf("Choose a column: ");
        
        li 	$v0, 5
        syscall
        move	$t0, $v0                                # scanf("%d", &target_col);
        
        subu	$t0, $t0, 1                             # $t0: target_col--;
        
        blt	$t0, 0, play_turn_invalid		# if (target_col < 0 
        bge	$t0, $s0, play_turn_invalid		# || target_col >= board_width) {
        
        move	$t1, $s1				# int $t1 = target_row = board_height
        subu	$t1, $t1, 1			        # $t1: target_row--
        
play_turn_check_space:      
        mul     $t2, $t1, MAX_BOARD_WIDTH                       # $t2 = row * board_width
        add     $t2, $t2, $t0                                   # $t2 = $t2 + col 
        
        lb      $s2, board($t2)
        
        beq     $s2, CELL_EMPTY, play_turn_valid                # if (board[target_row][target_col] != CELL_EMPTY
        blt     $t1, 0, play_turn_valid                         # && target_row >= 0) continue
        
        sub     $t1, $t1, 1                                     # target_row--
        
        bge     $t1, 0, play_turn_check_space                   # if (target_row < 0) continue 
        
        la      $a0, no_space_column_str
        li      $v0, 4
        syscall                                                 # printf("No space in that column!\n");
        
        move    $v0, $a1
        j       play_turn__epilogue                             # return whose_turn;

play_turn_invalid:
	la 	$a0, invalid_column_str               		
	li	$v0, 4
	syscall				                # printf("Invalid column\n");	
	
	move    $v0, $a1
	j       play_game__epilogue                     # return whose_turn;

play_turn_valid:
        mul     $t2, $t1, MAX_BOARD_WIDTH                       # $t2 = row * board_width;
        add     $t2, $t2, $t0                                   # $t2 = $t2 + col; 
        
        beq     $a1, TURN_RED, play_turn_valid_red              # branch if red, continue if yellow
        
        la      $s3, CELL_YELLOW                                # $s3 = CELL_YELLOW;
        sb      $s3, board($t2)                                 # board[target_row][target_col] = CELL_YELLOW;
        
        li      $v0, TURN_RED                                   # whose_turn = TURN_RED;
        
        j       play_turn__epilogue

play_turn_valid_red:
        la      $s3, CELL_RED                   # $t4 = CELL_RED;
        sb      $s3, board($t2)                 # board[target_row][target_col] = CELL_RED;
        
        li      $v0, TURN_YELLOW                # whose_turn = TURN_YELLOW;

play_turn__epilogue:
	#pop     $s3
	#pop     $s2
	#pop     $s1
	#pop     $s0
	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;

########################################################################
# .TEXT <check_winner>
	.text
check_winner:
	# Args:	    void
	# Returns:
	#   - $v0: int
	#
	# Frame:    [...]
	# Uses:     [...]
	# Clobbers: [...]
	#
	# Locals:
	#   - [...]
	#
	# Structure:
	#   check_winner
	#   -> [prologue]
	#   -> body
	#       -> loop 
	#       -> return
	#   -> [epilogue]

check_winner__prologue:
        begin			                # begin a new stack frame
	push	$ra		                # | $ra
	push    $s0
	push    $s1
	
	lw	$s0, board_width                # $s0 = board_width
	lw	$s1, board_height               # $s1 = board_height
	
	li      $t0, 0                          # int row = 0;
	
	j       check_winner_loop
	
check_winner__body:
	bgt     $t0, $s1, check_winner__epilogue                # while (row < board_height)
	
	addi    $t0, $t0, 1                                     # row++;
	li      $t1, 0                                          # int col = 0;   
	
check_winner_loop:
	move    $a0, $t0
	move    $a1, $t1
	
	li      $a2, 1
	li      $a3, 0
	jal     check_line                                      # check_line(row, col, 1, 0)
	bne     $v0, WINNER_NONE, check_winner_return           # if (check != WINNER_NONE)
	
	li      $a2, 0
	li      $a3, 1
	jal     check_line                                      # check_line(row, col, 0, 1)
	bne     $v0, WINNER_NONE, check_winner_return           # if (check != WINNER_NONE)
	
	li      $a2, 1
	li      $a3, 1
	jal     check_line                                      # check_line(row, col, 1, 1)
	bne     $v0, WINNER_NONE, check_winner_return           # if (check != WINNER_NONE)
	
	li      $a2, 1
	li      $a3, -1
	jal     check_line                                      # check_line(row, col, 1, -1)
	bne     $v0, WINNER_NONE, check_winner_return           # if (check != WINNER_NONE)
	
	bgt     $t1, $s0, check_winner__body                    # while (col < board_width)
	
	addi    $t1, $t1, 1                                     # col++;
	
	j       check_winner_loop
	
check_winner_return:
        li      $v0, WINNER_NONE

check_winner__epilogue:
	pop     $s1
	pop     $s0
	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;


########################################################################
# .TEXT <check_line>
	.text
check_line:
	# Args:
	#   - $a0: int start_row
	#   - $a1: int start_col
	#   - $a2: int offset_row
	#   - $a3: int offset_col
	# Returns:
	#   - $v0: int
	#
	# Frame:    [...]
	# Uses:     [$v0,$s0,$s1,$s2,$s3,$t0,$t1,$t3,$t4,$,t5,$t6,$t7]
	# Clobbers: [...]
	#
	# Locals:
	#   - $s0: int board_width
	#   - $s1: int board_height
	#   - $s2: char first_cell
	#   - $s3: char EMPTY_CELL
	#   - $t0: int offset 
	#   - $t1: int start_col 
	#   - $t4: int row = start_row + offset_row;
	#   - $t5: int col = start_col + offset_col;    
	#
	# Structure:
	#   check_line
	#   -> [prologue]
	#   -> body
	#       -> loop 
	#       -> end 
	#       -> none
	#       -> red 
	#       -> yellow
	#   -> [epilogue]

check_line__prologue:
        begin			# begin a new stack frame
	push	$ra		# | $ra
	#push    $s0
	#push    $s1
	#push    $s2
	#push    $s3
	
	lw      $s0, board_width
	lw      $s1, board_height

	
check_line__body:
        mul     $t2, $a0, MAX_BOARD_WIDTH                       # $t0 = start_row * board_width;
        add     $t0, $t0, $a1                                   # $t0 = $t0 + start_col; 
        
        lb      $s2, board($t2)                                 # first_cell = board[start_row][start_col];
        la      $s3, CELL_EMPTY                                 # $t3 = CELL_EMPTY;
        beq     $s2, $s3, check_line__epilogue                  # return WINNER_NONE;
        
        add     $t3, $a0, $a2                                   # $t3: int row = start_row + offset_row;
        add     $t4, $a1, $a3                                   # $t4: int col = start_col + offset_col;    
                
        li      $t5, 0                                          # $t5: int i = 0;
        li      $t6, CONNECT
        subu    $t6, $t6, 1                                     # $t6 = CONNECT - 1
        
check_line_loop:
        bge     $t5, $t6, check_line_end                # while (i < CONNECT - 1)
        
        blt     $t3, 0, check_line_none                 # if (row < 0
        blt     $t4, 0, check_line_none                 # || col < 0) return WINNER_NONE;
       
        bge     $t3, $s1, check_line_none               # if (row >= board_height               
        bge     $t4, $s0, check_line_none               # || col >= board_width) return WINNER_NONE;
        
        mul     $t8, $t4, $s0                           # $t8 = row * board_width;
        add     $t8, $t0, $t5                           # $t8 = $t0 + col; 
        
        lb      $t7, board($t8)                         # char cell = board[row][col];
        
        bne     $t7, $s2, check_line_none               # if (cell != first_cell) return WINNER_NONE;
        
        add     $t3, $t3, $a2                           # row += offset_row;
        add     $t4, $t4, $a3                           # col += offset_col;
        
        addi    $t5, $t5, 1                             # i++;
        
        j       check_line_loop
        
check_line_end:
        beq     $t2, CELL_RED, check_line_red                   # if (first_cell == CELL_RED) return WINNER_RED;
        beq     $t2, CELL_YELLOW, check_line_yellow             # if (first_cell == CELL_YELLOW) return WINNER_YELLOW;

check_line_none:
        li      $v0, WINNER_NONE
        j       check_line__epilogue

check_line_red:
        li      $v0, WINNER_RED
        j       check_line__epilogue

check_line_yellow:
        li      $v0, WINNER_YELLOW

check_line__epilogue:
	#pop     $s3
	#pop     $s2
	#pop     $s1
	#pop     $s0
	pop	$ra		# | $ra
	end			# ends the current stack frame

	jr	$ra		# return 0;

########################################################################
# .TEXT <is_board_full>
# YOU DO NOT NEED TO CHANGE THE IS_BOARD_FULL FUNCTION
	.text
is_board_full:
	# Args:     void
	# Returns:
	#   - $v0: bool
	#
	# Frame:    []
	# Uses:     [$v0, $t0, $t1, $t2, $t3]
	# Clobbers: [$v0, $t0, $t1, $t2, $t3]
	#
	# Locals:
	#   - $t0: int row
	#   - $t1: int col
	#
	# Structure:
	#   is_board_full
	#   -> [prologue]
	#   -> body
	#   -> loop_row_init
	#   -> loop_row_cond
	#   -> loop_row_body
	#     -> loop_col_init
	#     -> loop_col_cond
	#     -> loop_col_body
	#     -> loop_col_step
	#     -> loop_col_end
	#   -> loop_row_step
	#   -> loop_row_end
	#   -> [epilogue]

is_board_full__prologue:
is_board_full__body:
	li	$v0, true

is_board_full__loop_row_init:
	li	$t0, 0						# int row = 0;

is_board_full__loop_row_cond:
	lw	$t2, board_height
	bge	$t0, $t2, is_board_full__epilogue		# if (row >= board_height) goto is_board_full__loop_row_end;

is_board_full__loop_row_body:
is_board_full__loop_col_init:
	li	$t1, 0						# int col = 0;

is_board_full__loop_col_cond:
	lw	$t2, board_width
	bge	$t1, $t2, is_board_full__loop_col_end		# if (col >= board_width) goto is_board_full__loop_col_end;

is_board_full__loop_col_body:
	mul	$t2, $t0, MAX_BOARD_WIDTH			# row * MAX_BOARD_WIDTH
	add	$t2, $t2, $t1					# row * MAX_BOARD_WIDTH + col
	lb	$t3, board($t2)					# board[row][col];
	bne	$t3, CELL_EMPTY, is_board_full__loop_col_step	# if (cell != CELL_EMPTY) goto is_board_full__loop_col_step;

	li	$v0, false
	b	is_board_full__epilogue				# return false;

is_board_full__loop_col_step:
	addi	$t1, $t1, 1					# col++;
	b	is_board_full__loop_col_cond			# goto is_board_full__loop_col_cond;

is_board_full__loop_col_end:
is_board_full__loop_row_step:
	addi	$t0, $t0, 1					# row++;
	b	is_board_full__loop_row_cond			# goto is_board_full__loop_row_cond;

is_board_full__loop_row_end:
is_board_full__epilogue:
	jr	$ra						# return;


########################################################################
# .TEXT <print_board>
# YOU DO NOT NEED TO CHANGE THE PRINT_BOARD FUNCTION
	.text
print_board:
	# Args:     void
	# Returns:  void
	#
	# Frame:    []
	# Uses:     [$v0, $a0, $t0, $t1, $t2]
	# Clobbers: [$v0, $a0, $t0, $t1, $t2]
	#
	# Locals:
	#   - `int col` in $t0
	#   - `int row` in $t0
	#   - `int col` in $t1
	#
	# Structure:
	#   print_board
	#   -> [prologue]
	#   -> body
	#   -> for_header_init
	#   -> for_header_cond
	#   -> for_header_body
	#   -> for_header_step
	#   -> for_header_post
	#   -> for_row_init
	#   -> for_row_cond
	#   -> for_row_body
	#     -> for_col_init
	#     -> for_col_cond
	#     -> for_col_body
	#     -> for_col_step
	#     -> for_col_post
	#   -> for_row_step
	#   -> for_row_post
	#   -> [epilogue]

print_board__prologue:
print_board__body:
	li	$v0, 11			# syscall 11: print_int
	la	$a0, '\n'
	syscall				# printf("\n");

print_board__for_header_init:
	li	$t0, 0			# int col = 0;

print_board__for_header_cond:
	lw	$t1, board_width
	blt	$t0, $t1, print_board__for_header_body	# col < board_width;
	b	print_board__for_header_post

print_board__for_header_body:
	li	$v0, 1			# syscall 1: print_int
	addiu	$a0, $t0, 1		#              col + 1
	syscall				# printf("%d", col + 1);

	li	$v0, 11			# syscall 11: print_character
	li	$a0, ' '
	syscall				# printf(" ");

print_board__for_header_step:
	addiu	$t0, 1			# col++
	b	print_board__for_header_cond

print_board__for_header_post:
	li	$v0, 11
	la	$a0, '\n'
	syscall				# printf("\n");

print_board__for_row_init:
	li	$t0, 0			# int row = 0;

print_board__for_row_cond:
	lw	$t1, board_height
	blt	$t0, $t1, print_board__for_row_body	# row < board_height
	b	print_board__for_row_post

print_board__for_row_body:
print_board__for_col_init:
	li	$t1, 0			# int col = 0;

print_board__for_col_cond:
	lw	$t2, board_width
	blt	$t1, $t2, print_board__for_col_body	# col < board_width
	b	print_board__for_col_post

print_board__for_col_body:
	mul	$t2, $t0, MAX_BOARD_WIDTH
	add	$t2, $t1
	lb	$a0, board($t2)		# board[row][col]

	li	$v0, 11			# syscall 11: print_character
	syscall				# printf("%c", board[row][col]);
	
	li	$v0, 11			# syscall 11: print_character
	li	$a0, ' '
	syscall				# printf(" ");

print_board__for_col_step:
	addiu	$t1, 1			# col++;
	b	print_board__for_col_cond

print_board__for_col_post:
	li	$v0, 11			# syscall 11: print_character
	li	$a0, '\n'
	syscall				# printf("\n");

print_board__for_row_step:
	addiu	$t0, 1
	b	print_board__for_row_cond

print_board__for_row_post:
print_board__epilogue:
	jr	$ra			# return;

