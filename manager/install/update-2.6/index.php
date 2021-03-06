<?php

$strVersion = "2.6";

ini_set("include_path", dirname(__FILE__) . "/../");
require_once('init.php');
require_once("../../config.php");

$objDb = MDB2::connect($GLOBALS["_CONF"]["db"]["dsn"]);

$check = $objDb->exec(
    "SELECT * FROM `" . $GLOBALS["_CONF"]["db"]["dbName"] . "`.`pcms_setting_tpl`
    WHERE
        `name`='next_after_save'
    OR
        `name`='next_is_child'
    "
);
$blnError = PEAR::isError($check);
if ($blnError || $check == 2) {
    header("HTTP/1.0 500 Internal Server Error");
    if ($blnError) {
        echo "Failed to update database: " . $check->getMessage();
    }
} else {
    $resource = $objDb->exec(
        "INSERT INTO  `" . $GLOBALS["_CONF"]["db"]["dbName"] . "`.`pcms_setting_tpl` (
        	`name` ,
        	`value` ,
        	`section` ,
        	`type` ,
        	`sort` ,
        	`created` ,
        	`modified`
        ) VALUES (
            'next_after_save',
            '0',
            'general',
            'checkbox',
            '500',
            '2013-11-05 13:37:00',
            NOW()
        ), (
            'next_is_child',
            '0',
            'general',
            'checkbox',
            '501',
            '2013-11-05 13:37:00',
            NOW()
        );"
    );

    if (PEAR::isError($resource)) {
        header("HTTP/1.0 500 Internal Server Error");
        echo "Failed to update database: " . $resource->getMessage();
    } else {
        echo "Successfully installed PunchCMS Manager database update {$strVersion}. Current PunchCMS Manager version: {$GLOBALS['_CONF']['app']['version']}";
    }
}
