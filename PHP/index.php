<?php

/*

This is a multi-line php comment, which we begin with the forward-slash star and
end with a star forward slash.

index.php 

Copyright (C) 2024, Kevan Hashemi, Open Source Instruments, Inc.

To use this program, start a php server in the Practice/PHP folder, with a
command like this:

php -S localhost:3000

In a browser, type "localhost:3000" and the php server will accept your
browser's connection, and look for index.php. Later, as your browser sends
further requests, you will see the request with its tokens following in the
console in which you launched your php server.

This program is free software: you can redistribute it and/or modify it under
the terms of the GNU General Public License as published by the Free Software
Foundation, either version 3 of the License, or (at your option) any later
version.

This program is distributed in the hope that it will be useful, but WITHOUT ANY
WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A
PARTICULAR PURPOSE.  See the GNU General Public License for more details.

You should have received a copy of the GNU General Public License along with
this program.  If not, see <https://www.gnu.org/licenses/>.

*/

// We also put comments after double-forward slashes at the start of line within
// php code. In your text editor, you most likely have a feature that allows you
// to wrap comments automatically to a certain width, so that you can add to the
// comment and have it look nice after without having to hand-edit the line
// breaks.

/*
	The session_start command starts or resumes a browser session. A "session"
	provides its own set of variables that we can define in our php code and
	later refer to when the session continues. The client cooperates with the
	continuation of the session by passing a session token along with its http
	request. If there is no such token passed, the php server starts a new
	session. After about an hour, which is a standard value for a browser
	session timeout, the server deletes an idle session. The php server uses the
	session token to look up the session and all its variables. Session
	variables allow us to maintain a click history, a name, or a set of criteria
	for selecting a product. The session start must be called before any html is
	read. We must put this command right at the start of our php file. The
	server won't even let us put an html comment before the first php field,
	because it thinks the comment is going to create some html, even though it
	won't.
	
	When using a local PHP server, we can connect with a GET request like this:
	
	GET / HTTP/1.1
	
	We will get back the following, which includes the session identifier:
	
	HTTP/1.1 200 OK
	Date: Thu, 19 Dec 2024 19:57:23 GMT
	Connection: close
	X-Powered-By: PHP/7.3.29
	Set-Cookie: PHPSESSID=345d41be0dc377b33e8c739bcd5018f7; path=/
	Expires: Thu, 19 Nov 1981 08:52:00 GMT
	Cache-Control: no-store, no-cache, must-revalidate
	Pragma: no-cache
	Content-type: text/html; charset=UTF-8
	
	When we connect again, we specify the same session by listing the identifier
	in a cookie property:
	
	GET / HTTP/1.1
	Cookie: PHPSESSID=345d41be0dc377b33e8c739bcd5018f7

	Browsers do this automatically. If we are using an exploring program like 
	our Practice/TCPIP/Socket_Explorer.tcl, we can type the above GET instructions
	in by hand and see what we get back. This index.php page will print out the
	PHP session identifier.
*/
session_start();

?>

<!DOCTYPE html>
<html>

<head>
	<title>PHP Demonstration</title>
</head>

<body>

<center>
<h1>PHP Demonstration</h1>
&copy; 2024 Kevan Hashemi, Open Source Instruments Inc.<br>
</center>

<!--

This is an html comment, note the unusual sequence of characters that starts the
comment, and the reverse sequence that ends the comment.

--!>

<?php

// Print a message to say that we are running php and all is well.
print "<b>GREETINGS:</b> This notice comes from a PHP print command.<br>\n";
$root = $_SERVER['DOCUMENT_ROOT'];
print "<b>DOCUMENT ROOT:</b> $root<br>\n";
$wd = getcwd();
print "<b>WORKING DIRECTORY:</b> $wd<br>\n";
$sid = session_id();
print "<b>SESSION ID:</b> $sid<br>\n";

?>

<a href="Hello_Sailor.php"><button>Hello Sailor</button></a><br>
<a href="Buttons.php"><button>Buttons</button></a><br>
<a href="Sidebar.php"><button>Sidebar</button></a><br>
<a href="Server_Dump.php"><button>Server Dump</button></a><br>
<a href="Readme.php"><button>Display Markdown Readme File</button></a><br>

</body>
</html>
