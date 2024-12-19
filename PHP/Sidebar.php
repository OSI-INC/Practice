<?php 
	session_start(); 
?>

<!DOCTYPE html>
<html>

<body>

<h1>Sidebar Demonstration: Top Level</h1>

<?php
	include 'SubList.php';
	$sid = session_id();
	print "<b>SESSION ID:</b> $sid<br>\n";
?>


</body>
</html>
