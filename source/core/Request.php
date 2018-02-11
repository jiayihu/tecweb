<?php

namespace Core;

class Request {
  /**
   * Returns the URI of the request like 'login' in 'localhost:8888/login'
   *
   * @return void
   */
  public static function uri(): string {
    $path = $_SERVER['REQUEST_URI'];

    $path = preg_replace('/\?.+/', '', $path);
    $path = str_replace(['ddisomma', 'ghu', 'emattiaz', 'source', \Core\App::get('config')['folder']], '', $path);

    return \trim($path, '/');
  }

  /**
   * Returns the HTTP method of the request, like 'GET' or 'POST'
   *
   * @return void
   */
  public static function method(): string {
    return $_SERVER['REQUEST_METHOD'];
  }

  /**
   * Returns safe values passed in GET request
   *
   * @param string $name
   * @return void
   */
  public static function getQueryParam(string $name) {
    return empty($_GET[$name]) ? null : self::sanitize($_GET[$name]);
  }

  /**
   * Returns safe values passed in POST request
   *
   * @param string $name
   * @return void
   */
  public static function getPOSTParam(string $name) {
    return empty($_POST[$name]) ? null : self::sanitize($_POST[$name]);
  }

  private static function sanitize($value) {
    if (\is_array($value)) {
      return \array_map(function ($x) {
        return self::sanitize($x);
      }, $value);
    }

    return \htmlentities(\trim($value));
  }
}
