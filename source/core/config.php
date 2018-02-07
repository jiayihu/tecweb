<?php

namespace Core;

// Differentiate from development and production, when the website is deployed in tecweb lab
$production = true;
$base_url = $production ? 'http://tecweb2016.studenti.math.unipd.it/ghu' : '';

// Define a global constant to facilitate requiring CSS files
define('ROOT', $base_url);

return [
  'production' => $production,
  'base_url' => $base_url,
  'database' => [
    'name' => $production ? 'ghu' : 'sherlock',
    'username'=> $production ? 'ghu' : 'root',
    'password' => $production ? 'ahNgauMoong9aiVu' : 'password',
    'hostdb' => '127.0.0.1',
    'options' => [
      \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION
    ]
  ]
];
