<?php

function render_list($ver_list)
{
    $result = "<ul class='uk-list uk-list-striped'>";

    foreach ($ver_list as $ver)
    {
        $result .= "    <li><a href='".$ver."'>".$ver."</a></li>\n";
    }

    $result .= "</ul>\n";

    return $result;
}

function render_body($cegui_versions, $ceed_versions)
{
    return sprintf('
<div class="uk-grid">
    <div class="uk-width-1-2">
        <div class="uk-panel uk-panel-box uk-panel-box-primary">
            <img class="uk-thumbnail uk-thumbnail-mini uk-border-circle" src="//bitbucket-assetroot.s3.amazonaws.com/c/photos/2013/Dec/29/cegui-logo-678614273-12_avatar.png" alt="cegui-logo" >
            <h3 class="uk-panel-title">Available CEGUI versions:</h3>
            %s
        </div>
    </div>
    <div class="uk-width-1-2">
        <div class="uk-panel uk-panel-box uk-panel-box-primary">
            <img class="uk-thumbnail uk-thumbnail-mini uk-border-circle" src="//bitbucket-assetroot.s3.amazonaws.com/c/photos/2013/Dec/29/ceed-logo-1279420685-10_avatar.png" alt="ceed-logo" >
            <h3 class="uk-panel-title">Available CEED versions:</h3>
            %s
        </div>
    </div>
</div>
', render_list($cegui_versions), render_list($ceed_versions));

}

function render_page($cegui_versions, $ceed_versions)
{
    echo sprintf(
"<!DOCTYPE html>
<html class='uk-height-1-1' lang='en-gb' dir='ltr'>
    <head>
        <title></title>
        <link rel='stylesheet' href='css/uikit.gradient.min.css' />
        <script src='//ajax.googleapis.com/ajax/libs/jquery/1.11.1/jquery.min.js'></script>
        <script src='js/uikit.min.js'></script>
    </head>
    <body class='uk-height-1-1'>
        <div class='uk-text-center uk-vertical-align uk-height-1-1'
             style='background-image:url(\"http://cegui.org.uk/sites/all/themes/cegui2/img/flask.png\"); background-position: 2%% 95%%; background-repeat: no-repeat; background-size:111px 250px;'>
            <div class='uk-vertical-align-middle' style='width: 600px'>
                %s
            </div>
        </div>
    </body>
</html>", render_body($cegui_versions, $ceed_versions));
}

?>