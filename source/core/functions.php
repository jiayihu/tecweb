<?php

namespace Core;

/**
 * Returns a JSON object to the client with the format as specified in standard
 * http://jsonapi.org/format/
 *
 * @param array $data
 * @param array $errors
 * @return void
 */
function json(array $data, array $errors = null) {
  $response = [];

  if (!$errors) {
    $response = ['data' => $data];
  } else {
    $response = ['errors' => $errors];
  }

  header('Content-Type: application/json');
  echo json_encode($response);
}

function view($filename, $data = []) {
  extract($data);
  
  return require_once "app/views/{$filename}.view.php";
}

function redirect($path) {
  header("Location: {$path}");
}
