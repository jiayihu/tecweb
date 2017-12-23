<?php

namespace Core;

function view($filename, $data = []) {
  extract($data);
  
  return require_once "app/views/{$filename}.view.php";
}

function redirect($path) {
  header("Location: /{$path}");
}
