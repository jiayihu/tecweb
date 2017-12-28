<?php

namespace Core;

return [
  'production' => false,
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
