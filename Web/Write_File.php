<!DOCTYPE html>
<html>
<body>

<?php
$fn = "log.txt";
$f = fopen($fn, "a");
$t = time();
fwrite($f, "TIME: $t\n");
fclose($f);
echo "Wrote time $t to file $fn."
?>

</body>
</html>

