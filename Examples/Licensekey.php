<?php
require_once "../PHP/Licensekey.php";
$lk = new \LSV\Licensekey();
$formats = [
    "????-####-%%%%",
    "????-????-????",
    "####-####-####",
    ["%%%%-%%%%-%%%%", "****-****-****"],
];
$o = "";
for ($i = 0; $i < 1e3; $i++) {
    $formatI = array_rand($formats);
    $format = is_array($formats[$formatI]) ? $formats[$formatI][array_rand($formats[$formatI])] : $formats[$formatI];
    $o .= $format . " | " . $lk->generate($format) . "\n";
}
file_put_contents("Licensekey.txt", rtrim($o));