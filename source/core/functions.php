<?php

namespace Core;

function ellipsis($text) {
  return \strlen($text) > 100 ? \substr($text, 0, 100) . '...' : $text;
}

function isArrayEmpty(array $values) {
  $notNullValues = \array_filter(\array_values($values), function ($value) {
    return !empty($value);
  });

  return \count($notNullValues) === 0;
}

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

/**
 * Returns the HTML template to the client
 *
 * @param string $filename The name of the file
 * @param array $data Associative array of variables used in the template
 * @return void
 */
function view(string $filename, array $data = []) {
  extract($data);
  
  return require_once "app/views/{$filename}.view.php";
}

/**
 * Redirects the client to a page
 *
 * @param string $path
 * @return void
 * 
 * @example `redirect('/login')` Redirect to login page
 */
function redirect(string $path) {
  header("Location: {$path}");
}
