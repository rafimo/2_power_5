
# golfscript - Fibonnaci series until 100
# cerner_2tothe5th_2022

!! []! {'d')\;<} { .@+ } / \ ; p

# explanation!
# !! generates 0, []! generates 1 'd'\; generates 100 
# < as long as it less than 100 add items to an array
# / runs the loop checking above assertion
# \ swap top of stack 
# ; pop the top of stack
# p print
