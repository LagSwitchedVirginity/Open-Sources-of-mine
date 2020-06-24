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
    if (is_array($formats[$formatI])) {
        $format = $formats[$formatI][array_rand($formats[$formatI])];
    } else {
        $format = $formats[$formatI];
    }
    $o .= $format . " | " . $lk->generate($format) . "\n";
}
file_put_contents("Licensekey.txt", rtrim($o));