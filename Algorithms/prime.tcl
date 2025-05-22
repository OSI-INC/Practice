#! /usr/bin/tclsh 

#
# For each number, use nested for loops to calculate whether an integer
# (i) between 1 and N is divisible by an integer(j) between 2 and i. if i is
# divisible by j, set the prime flag to 0, if the prime flag remains 1
# throughout the for loop that means i was not divisible by j, and is
# therefore prime. Then, increment the prime variable.
#
	foreach N {1 10 100 1000 10000 100000 1000000} {
		set prime 0
		for {set i 1} {$i <= $N} {incr i} {
			set is_prime 1
			for {set j 2} {$j < $i} {incr j} {
				if {$i % $j == 0} {set is_prime 0}
			}
			if {$is_prime !=0} {incr prime}
		}
	set prime [expr $prime-1]
	puts "this is how many prime numbers there are in $N: $prime"
}
 		