#!/usr/bin/expect

# should work in linux or mac environment. needs Tcl and expect
# prints "CERNER CARES" and then 'humanely' prints "First Hand Foundation"
# cerner_2^5_2016

proc er {} {
    send_user "ER"
}

set send_slow { 1 2 }
after 1500 er
after 3500 er
send_user -s "CN CARES"

set send_human { .1 .3 1 .05 2 } 
send_user -h "\b\b\b\b\b\b First Hand Foundation\n"