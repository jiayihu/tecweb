<?php

namespace Core;

function ellipsis(string $text): string {
  return \strlen($text) > 100 ? \substr($text, 0, 100) . '...' : $text;
}

function isArrayEmpty(array $values): bool {
  $notNullValues = \array_filter(\array_values($values), function ($value) {
    return !empty($value);
  });

  return \count($notNullValues) === 0;
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
  $root = ROOT;

  header("Location: {$root}{$path}");
}
