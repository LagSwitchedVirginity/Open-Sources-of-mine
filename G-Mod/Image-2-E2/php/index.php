<?php
/**
 * Created by Nicholas J. Phillips (LagSwitchedVirginity) @ 1/26/2019
 **/
$src    = '2fuse.jpg';
$im     = imagecreatefromjpeg($src);
$im     = imagecreatefrompng($src);
$size   = getimagesize($src);
$width  = $size[0];
$height = $size[1];

for($x=0;$x<$width;$x++)
{
	for($y=0;$y<$height;$y++)
	{
		$rgb = imagecolorat($im, $x, $y);
		$r = ($rgb >> 16) & 0xFF;
		$g = ($rgb >> 8) & 0xFF;
		$b = $rgb & 0xFF;
		var_dump($r, $g, $b);
	}
}