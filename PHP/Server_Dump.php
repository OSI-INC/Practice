<?php 
	session_start(); 
?>

<!DOCTYPE html>
<html>
<body>

<h1>Contents of the _SERVER array:</h1>

<?php 
	echo '<pre>';
	var_dump($_SERVER);
	echo '</pre>';
?>

</body>
</html>
