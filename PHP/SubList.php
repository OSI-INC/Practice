<?php
	$subfiles = array(
		array('Sub1','Subfile Number One'),
		array('Sub2','Subfile Number Two'),
		array('Sub3','Subfile Number Three'),
		array('Sidebar','Sidebar Top Level')
	);
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
	foreach ($subfiles as $definition) {
		print("\t<li");
		if ($_SERVER['SCRIPT_NAME'] === '/' . $definition[0] . '.php') {
			print(' class="selected"');
		}
		print('><a href="' . $definition[0] . '.php">' . $definition[1] . '</a></li>');
		print("\n");
	}
?>
</ul>
