set cmd "GET"
set ip "206.188.192.181"
set port "80"

set ff [frame $f.cframe]
pack $ff -side top -fill x

entry $ff.cmd -textvariable cmd -width 100
pack $ff.cmd -side left

set ff [frame $f.bframe]
pack $ff -side top -fill x
foreach {a w} {ip 60 port 10} {
  entry $ff.$a -textvariable $a -width $w
  pack $ff.$a -side left
}

button $ff.do -text "Do" -command "docmd"
pack $ff.do -side left

proc docmd {} {
	global t cmd ip port
	set sock [socket $ip $port]
	LWDAQ_print $t "Opened: $sock to port $port of $ip"
	fconfigure $sock -buffering line
	fileevent $sock readable "readsock $sock"
	puts $sock $cmd
	LWDAQ_print $t "Wrote: $cmd" orange
}

proc readsock {sock} {
	global t
	if {[eof $sock] || [catch {gets $sock line}]} {
		LWDAQ_print $t "Closing: $sock\."
		catch {close $sock}
	} else {
		if {$line != ""} {LWDAQ_print $t "$line" green}
	}
}

while {[winfo exists $t]} {
	LWDAQ_update
}

close $sock