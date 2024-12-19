<?php
	$subfiles = array('Sub1', 'Sub2', 'Sub3', 'Sidebar');
?>
<style>
li.selected {
	background-color:green
}
li:hover {
	background-color:tomato
}
</style>

<ul>
<?php
	foreach ($subfiles as $value) {
		print("\t<li");
		if ($_SERVER['SCRIPT_NAME'] === '/' . $value . '.php') {
			print(' class="selected"');
		}
		print('><a href="' . $value . '.php">' . $value . '</a></li>');
		print("\n");
	}
?>
</ul>
