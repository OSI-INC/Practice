<?php 
	session_start(); 
?>

<!DOCTYPE html>
<html>

<body>

<style>
table {
  border-collapse: collapse;
  font-family: sans-serif;
  font-size: 14px;
  margin: 1em auto;
}
table, th, td {
  border: 1px solid #d0d7de;
}
th {
  background-color: #f6f8fa;
  font-weight: bold;
}
th, td {
  padding: 6px 13px;
  text-align: left;
}
</style>

<pre>This page, Readme.php, demonstrates translation from Markdown (MD) to
Hyper-Text Markup Language (HTML). It loads the Parsedown.php library. It
creates a new Parsdown object, which provides a function called "text". The PHP
script reads the local Readme.md file using file_get_contents. It then passes
the file contents to the Parsedown "text" routine, which returns an HTML string.
The PHP code prints this HTML string to its output, which is the page that will
be rendered by the browser. The Readme.md includes an in-line image, which is
Schematic.gif. This image should appear in the browser window. The HTML in
Readme.php includes an HTML style block that formats the text table in the HTML
output from the Parsedown routine.</pre>

<?php
require 'Parsedown.php';
$Parsedown = new Parsedown();
$markdown = file_get_contents('Readme.md');
$html = $Parsedown->text($markdown);
echo $html;
?>

</body>
</html>