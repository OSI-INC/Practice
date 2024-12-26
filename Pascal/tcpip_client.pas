program tcpip_client;

uses
	baseunix, sockets, sysutils;

var
	addr: TInetSockAddr;
	sock,err,count: longint;
	buff: array[0..255] of char;
	s: string;
	
begin
	sock := fpSocket(AF_INET, SOCK_STREAM, 0);
	if sock = -1 then
	begin
		writeln('Failed to create socket: ', SocketError);
		halt(1);
	end;

	addr.sin_family := AF_INET;	
	addr.sin_port := htons(8080);
	addr.sin_addr.s_addr := htonl($7F000001);

	err := fpConnect(sock, @addr, SizeOf(addr));
	if err = 0 then
		writeln('Connected successfully!')
	else
		writeln('Failed to connect: ', SocketError);
		
	repeat
		write('> ');
		readln(s);
		if length(s)=0 then continue;
		count:=fpSend(sock,@s[1],length(s),0);
		if count<0 then begin
			writeln('Error writing ',length(s),' bytes to socket.');
			break;
		end;
		count:=fpRecv(sock,@buff,SizeOf(buff),0);
		if count<0 then begin
			writeln('Error reading echo from socket.');
			break;
		end;
		s:=copy(buff,0,count);
		writeln(s);
	until s='quit';

	fpClose(sock);
end.
