<?php
//ini_set('display_errors', 'On');
//error_reporting(E_ALL);
// PHP is so horrible, yuck!
require('index.ui.php');

$parent_dir = realpath(dirname(__FILE__));
$dirs = scandir($parent_dir);

$cegui_versions = array();
$ceed_versions = array();

foreach($dirs as $dir)
{
    if (!is_dir($dir))
        continue;

    if (preg_match("/[0-9]+\.[0-9]+\.[0-9]+/", $dir))
        array_push($cegui_versions, $dir);
    else if (preg_match("/ceed-[0-9]+\.[0-9]+\.[0-9]+/", $dir))
        array_push($ceed_versions, $dir);
    else if (preg_match("/ceed-snapshot[0-9]+/", $dir))
        array_push($ceed_versions, $dir);
}

rsort($cegui_versions);
rsort($ceed_versions);

if ($_REQUEST['json'] == '1')
{
    $ret = array(
        "cegui" => $cegui_versions,
        "ceed" => $ceed_versions
    );

    echo(json_encode($ret));
}
else
{
    render_page($cegui_versions, $ceed_versions);
}
?>
