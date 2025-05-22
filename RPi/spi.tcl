while {1} {
	catch {exec echo -ne "\x01\x02\x03\x04" | sudo dd of=/dev/spidev0.0}
}