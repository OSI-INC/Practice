proc REST_accept {sock addr port} {
	puts "Connection: $addr $port $sock"
	fconfigure $sock -translation auto -buffering line
	fileevent $sock readable [list REST_interpreter $sock]
}

proc REST_interpreter {sock} {
	if {[eof $sock] || [catch {gets $sock line}]} {
		puts "Closing: $sock\."
		catch {close $sock}
	} else {
		puts "$line"
		if {[catch {puts $sock $line}]} {
			close $sock
		}
	}
	return ""
}

set port 443
set sock [socket -server REST_accept $port]
puts "Listening on port $port"
vwait quit

