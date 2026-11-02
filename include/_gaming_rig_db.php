<?php
$x_mem_types = array(
	"FPM"=>"DDR", 
	"EDO"=>"DDR2 667", 
	"PC66 SDRAM"=>"DDR2 800", 
	"PC100 SDRAM"=>"DDR2 1066", 
	"PC133 SDRAM"=>"DDR2 1066+", 
	"PC150 SDRAM"=>"DDR3 1066", 
	"PC1600 DDR SDRAM"=>"DDR3 1333", 
	"PC2100 DDR SDRAM"=>"DDR3 1600", 
	"PC2400 DDR SDRAM"=>"DDR3 1866", 
	"PC2700 DDR SDRAM"=>"DDR3 2133",
	"PC3000 DDR SDRAM"=>"SOdimm DDR2 677", 
	"PC3200 DDR SDRAM"=>"SOdimm DDR2 800", 
	"PC3500 DDR SDRAM"=>"SOdimm DDR3 1066", 
	"PC4000 DDR SDRAM"=>"SOdimm DDR3 1333", 
	"800 RDRAM"=>"SOdimm DDR3 1666", 
	"1066 RDRAM"=>"SOdimm DDR3 1666+", 
	"Other..." => "Other...");

$x_mem_sizes = array(
	"32"=>"32MB",
	"64"=>"64MB",
	"128"=>"128MB");
for($i=256;$i<=28096;$i+=128) {
	$x_mem_sizes[$i] = $i." MB";
}

$x_storage = array();
for($i=20;$i<=15000;$i+=20) {
	$x_storage[$i] = $i." GB";
}
$x_processors = array(
	"AMD" => "AMD",
	"Apple (IBM PowerPC)" => "Apple (IBM PowerPC)",
	"Apple (Intel)" => "Apple (Intel)",
	"Cyrix" => "Cyrix",
	"IDT" => "IDT",
	"Intel" => "Intel",
	"NEC" => "NEC",
	"Transmeta" => "Transmeta",
	"VIA" => "VIA",
	"Other..." => "Other..."
);

$x_gpus = array(
	"ATI" => "ATI",
	"Intel" => "Intel",	
	"Nvidia" => "Nvidia",
	"VIA/S3" => "VIA/S3",
	"Other..." => "Other..."
);

// keyword searches
/*
$x_ati = array('ati','radeon','rage','xpert','firegl');
$x_nvidia = array('geforce','gefroce','gf4','gf3','annihilator','vidia','quadro','nforce','n-force','tnt');

function logo_return($keywords, $field, $userid) {
	global $dbc;
	$bool = false;
	if(sizeof($keywords)>0) {
		foreach($keywords as $val) {
			if($dbc->database_num_rows($dbc->database_query("SELECT * FROM users WHERE ".$field." LIKE '%".$val."%' AND userid='".$userid."'"))) {
				$bool = true;
			}
		}
	}
	return $bool;
}
*/
?>