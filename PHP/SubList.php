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

<ul class="sidebar">
<?php
	foreach ($subfiles as $sub) {
		print("\t<li");
		if ($_SERVER['SCRIPT_NAME'] === '/' . $sub . '.php') {
			print(' class="selected"');
		}
		print('><a href="' . $sub . '.php">' . $sub . '</a></li>');
		print("\n");
	}
?>
</ul>
