# Socket Explorer, a LWDAQ Toolmaker Script.
# (C) 2023 Kevan Hashemi, Open Source Instruments Inc.
#
# Socket Explorer allows us to connect to a TCPIP server and send a command.
# It allows us to listen on a local port to see what commands are sent to us
# from another process, such as a web browser.

# Create the command text widget.
label $f.lcmd -text "Command:"
pack $f.lcmd -side top
set cmd_txt [LWDAQ_text_widget $f 50 20] 
LWDAQ_print $cmd_txt {GET / HTTP/1.1
User-Agent: Tcl
Host: www.bndhep.net
Accept-Language: en, mi}

# Create a sub-frame within the master "f" frame of our Toolmaker
# execution window.
set ff [frame $f.f1]
pack $ff -side top -fill x

# Create another sub-frame.
set ff [frame $f.f2]
pack $ff -side top -fill x

# Create a Send button that opens a socket, sends string, reads socket, and
# closes socket.
button $ff.send -text "Send" -command {
	set cmd [$cmd_txt get 1.0 end]
	REST_send $ip $port $cmd $wait
}
pack $ff.send -side left -expand yes

# Entry for IP address and socket.
label $ff.lip -text "IP:"
entry $ff.eip -textvariable ip -width 14
label $ff.lport -text "Port:"
entry $ff.eport -textvariable port -width 4
label $ff.lwait -text "Wait:"
entry $ff.ewait -textvariable wait -width 3
pack $ff.lip $ff.eip $ff.lport $ff.eport $ff.lwait $ff.ewait -side left -expand yes

# Set the global variables that hold the ip address, port, command, and wait
# time.
set ip "www.bndhep.net"
set port "80"
set cmd "GET /Temporary/Hello_Sailor.php"
set wait "2"

# Create another sub-frame.
set ff [frame $f.f3]
pack $ff -side top -fill x

# Create a Listen button that starts listening on a named port.
button $ff.listen -text "Start Listening" -command {REST_listen}
pack $ff.listen -side left -expand yes

# The listening port.
label $ff.llport -text "Listen Port:"
entry $ff.elport -textvariable listen_port -width 5
pack $ff.llport $ff.elport -side left -expand yes

# Create a Stop button that starts listening on a named port.
button $ff.stop -text "Stop Listening" -command {
	catch {close $listen_sock}
	LWDAQ_print $t "Stopped listening on port $listen_port\."
}
pack $ff.stop -side left -expand yes

# Set the global variables for the listening port.
set listen_port "1000"
set listen_sock "none"

# The Listen procedure starts listening on a particular port
# and installs REST_accept as the connection handler.
proc REST_listen {} {
	global listen_port listen_sock t
	catch {close $listen_sock}
	set listen_sock [socket -server REST_accept $listen_port]
	LWDAQ_print $t "Listening on port $listen_port"
}

#
# REST_send procedure opens a socket and sends our command, waits for a while,
# then reads everything available in the socket and prints to the screen.
#
proc REST_send {ip port cmd wait} {
	global t
	if {[catch {
		LWDAQ_print $t "Opening socket to $ip $port\."
		set sock [socket $ip $port]
		fconfigure $sock -buffering line -blocking 0
		puts $sock $cmd
		LWDAQ_print $t "Sent command to $ip $port\."
		LWDAQ_print $t "Waiting for $wait seconds."
		LWDAQ_wait_seconds $wait
		while {[gets $sock line] >= 0} {
			if {[string length $line] > 0} {
				incr index
				LWDAQ_print $t "$line" green
			}
		}
		close $sock
		LWDAQ_print $t "Closed socket."
	} message]} {
		LWDAQ_print $t "ERROR: $message"
	}
}

#
# REST_accept reports that a new socket has been opened. It reports the port to
# which the connection has been moved after the initial listening port
# connection. configures a new socket for line buffering and assigns the
# REST_interpreter to read and interpret whatever arrives through the socket.
#
proc REST_accept {sock addr port} {
	global t
	LWDAQ_print $t "Connection: $addr $port $sock"
	fconfigure $sock -translation auto -buffering line
	fileevent $sock readable [list REST_interpreter $sock]
}

#
# REST_Interpreter reads what's available from a socket and prints
# to our text window in green. If the socket returns an end of file
# code, we close the socket and report.
#
proc REST_interpreter {sock} {
	global t
	if {[eof $sock] || [catch {gets $sock line}]} {
		LWDAQ_print $t "Closing: $sock\."
		close $sock
	} else {
		LWDAQ_print $t "$line" green
		if {[catch {puts $sock $line}]} {
			close $sock
		}
	}
	return ""
}
