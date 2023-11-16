<!DOCTYPE HTML>  
<html>

<head>
<title>Buttons, Forms, and Entry Boxes</title>
</head>

<body>

<center>
<h1>Buttons, Forms, and Entry Boxes</h1>
</center>

<h2>Button with Java Script</h2>

<p>We declare a JAVA procedure, which is invisible to the user, and call the script when the user presses "Calculate". The script refers to elements in a "form". The "button" is an "input" of type "button".</p>

<script type="text/javascript">
function Product() {
	with (document.formproduct) {
		var xx = parseFloat(x.value)
		if (isNaN(xx)) {
			product.value = "Invalid X"
			return
		}
		var yy = parseFloat(y.value)
		if (isNaN(yy)) {
			product.value = "Invalid Y"
			return
		}
		product.value = xx * yy
	}
}
</script>

<center>
<form name="formproduct">
	<table>
		<tr>
			<td>X:</td>
			<td><input name="x" size="10" value="11"></td>
			<td>Y:</td>
			<td><input name="y" size="10" value="12">kg</td>
			<td><input type="button" value="Calculate" onclick="Product()"></td>
			<td>Product:</td>
			<td><input name="product" size="20" value="0"></td>
		</tr>
	</table>
</form>
</center>

<h2>PHP Forms</h2>

<p>Our web server provides in-line PHP execution for text files with the ".php" extension. Invisible to you, but embedded in this file, are segments of PHP code that are executed by the server. The code directly below this paragraph in the PHP file checks to see if this page was loaded with a POST or a GET request, and reports accordingly.</p>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	echo "<br>POST REQUEST";
} else {
	echo "<br>NOT A POST REQUEST";
}
if ($_SERVER["REQUEST_METHOD"] == "GET") {
	echo "<br>GET REQUEST";
} else {
	echo "<br>NOT A GET REQUEST";
}
?>

<p>The code below this paragraph sets the "post_string" and "get_string" variables.</p>

<?php
if ($_SERVER["REQUEST_METHOD"] == "POST") {
	$post_string = $_POST["string"];
} else {
	$post_string = "";
}
if ($_SERVER["REQUEST_METHOD"] == "GET") {
	$get_string = $_GET["string"];
} else {
	$get_string = "";
}
?>

<p>Here is a form that generates a post request when we press the submit button.</p>

<form method="post" action="<?php echo $_SERVER['PHP_SELF'];?>">
	<input type="text" name="string" value="ABCD">
	<input type="submit" name="submit" value="POST_Submit">
</form>

<?php
echo "<br>POST string: $post_string";
?>

<p>Here is a form that generates a get request when we press the submit button.</p>

<form method="get" action="<?php echo $_SERVER['PHP_SELF'];?>">
	<input type="text" name="string" value="ABCD">
	<input type="submit" name="submit" value="GET_Submit">
</form>

<?php
echo "<br>GET string: $get_string";
echo "<br>Contents of the \$_GET Array:</br><pre>";
print_r($_GET);
echo "<pre>"
?>

</body>
</html>
