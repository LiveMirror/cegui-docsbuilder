<?php
//ini_set('display_errors', 'On');
//error_reporting(E_ALL);
// PHP is so horrible, yuck!

$old_uri = $_REQUEST['uri'];
$version = $_REQUEST['version'];

if (!preg_match("/[0-9]+\.[0-9]+\.[0-9]+/", $version))
{
    die("Invalid request");
}

//$old_uri is likely something like http://static.cegui.org.uk/docs/X.Y.Z/some_File.html
$split = split("static.cegui.org.uk/docs", $old_uri, 2);

if (count($split) != 2)
{
    die("Invalid request");
}

$protocol = $split[0];
$desired_file = split("/", $split[1]);

if (count($desired_file) != 3)
{
    die("Invalid request");
}

// new_file can be some_class_123.html#abcdefgh
$new_file = $desired_file[2];
// existing_file has the # and anything following it stripped
$existing_file = split("#", $new_file, 2);
$existing_file = $existing_file[0];

$parent_dir = realpath(dirname(__FILE__));
$uri = "";
if (is_file($parent_dir."/".$version."/".$existing_file))
{
    $uri = $protocol."static.cegui.org.uk/docs/".$version."/".$new_file;
}
else
{
    $uri = $protocol."static.cegui.org.uk/docs/".$version."/";
}

header("Location: ".$uri);
?>
