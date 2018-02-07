<?php

namespace Core;

// Differentiate from development and production, when the website is deployed in tecweb lab
$production = true;
$base_url = $production ? 'http://tecweb1617.studenti.math.unipd.it/ghu' : '';

// Define a global constant to facilitate requiring CSS files
define('ROOT', $base_url);

return [
  'production' => $production,
  'base_url' => $base_url,
  'database' => [
    'name' => 'sherlock',
    'username'=> 'root',
    'password' => 'password',
    'hostdb' => '127.0.0.1',
    'options' => [
      \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION
    ]
  ]
];
