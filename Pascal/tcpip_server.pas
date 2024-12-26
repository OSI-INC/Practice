program tcpip_server;

{
	A tcpip server using FPC's sockets unit.
}

uses
	BaseUnix, Sockets;
	
const
	port = 8080;
	

var
	sock_listen,sock_client:longint;
	addr:TInetSockAddr;
	buff:array[0..255] of Char;
	count:integer;
	s:string;
	
begin
	writeln('Starting server listening on port ',port,'.');
	sock_listen:=fpSocket(AF_INET, SOCK_STREAM, 0);
	if sock_listen<0 then begin
		writeln('Error "',socketerror,'" while starting server.');
		halt;
	end;

	addr.sin_family:=AF_INET;
	addr.sin_port:=htons(port);
	addr.sin_addr:=StrToNetAddr('0.0.0.0');
	if fpBind(sock_listen, @addr, SizeOf(addr)) <> 0 then Halt(1);
	if fpListen(sock_listen, 5) <> 0 then Halt(1);

	repeat
		writeln('Server listening on port ',port,'.');
		sock_client:=fpAccept(sock_listen, nil, nil);
		if sock_client>0 then begin
			writeln('Socket connection accepted 0x',hexstr(sock_client,8),'.');
			repeat 
				count:=fpRecv(sock_client,@buff,SizeOf(buff),MSG_DONTWAIT);
				if (count=0) then begin
					writeln('Received empty string, closing socket.');
					fpClose(sock_client);
					break;
				end;
				if (count<0) and (socketerror<>ESockEWOULDBLOCK) then begin
					writeln('Error "',socketerror,'" while reading from socket.');
					fpClose(sock_client);
					break;
				end;
				if (count>0) then begin
					s:=copy(buff,0,count);
					writeln('Received: ',s);
					count:=fpSend(sock_client,@s[1],length(s),0);
					if count<0 then begin
						writeln('Error writing ',length(s),' bytes to socket, closing socket.');
						fpClose(sock_client);
						break;
					end;
				end;
			until s='quit';
		end;
	until s='quit';
end.
