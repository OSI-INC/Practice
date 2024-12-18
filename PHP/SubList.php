<?php
$x = "<p>This file is: " . $_SERVER['SCRIPT_NAME'] . "</p>";
echo $x;
?>

<style>

li.selected {
	background-color:tomato
}

</style>

<?php

if ($_SERVER['SCRIPT_NAME'] === "/Sub1.php") {
	echo "<p>This is Sub1.php!!!</p>";
} else {
	echo "<p>This is not Sub1.php.</p>";
}

if ($_SERVER['SCRIPT_NAME'] === "/Sub2.php") {
	echo "<p>This is Sub2.php!!!</p>";
} else {
	echo "<p>This is not Sub2.php.</p>";
}

?>

<ul>
	<li<?php if ($_SERVER['SCRIPT_NAME'] === "/Sub1.php") {echo ' class="selected"';} ?>>
		<a href="Sub1.php">Sub Page One</a>.
	</li>
	<li<?php if ($_SERVER['SCRIPT_NAME'] === "/Sub2.php") {echo ' class="selected"';} ?>>
		<a href="Sub2.php">Sub Page Two</a>.
	</li>
</ul>
