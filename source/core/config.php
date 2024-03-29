<?php

namespace Core;

// Differentiate from development and production, when the website is deployed in tecweb lab
$production = true;
$folder = $production ? 'emattiaz' : '';

// Define a global constant to facilitate requiring CSS files and images
$base_url = $folder !== '' ? "/{$folder}" : '';
define('ROOT', $base_url);

return [
  'production' => $production,
  'base_url' => $base_url,
  'database' => [
    'name' => $production ? 'emattiaz' : 'sherlock',
    'username'=> $production ? 'emattiaz' : 'root',
    'password' => $production ? 'wae2ahngee3Eiphu' : 'password',
    'hostdb' => '127.0.0.1',
    'options' => [
      \PDO::ATTR_ERRMODE => \PDO::ERRMODE_EXCEPTION
    ]
  ]
];
