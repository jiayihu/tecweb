<?php

namespace Core;

class Request {
  /**
   * Returns the URI of the request like 'login' in 'localhost:8888/login'
   *
   * @return void
   */
  public static function uri() {
    $path = empty($_SERVER['PATH_INFO']) ? $_SERVER['REQUEST_URI'] : $_SERVER['PATH_INFO'];
    return \trim($path, '/');
  }

  /**
   * Returns the HTTP method of the request, like 'GET' or 'POST'
   *
   * @return void
   */
  public static function method() {
    return $_SERVER['REQUEST_METHOD'];
  }

  /**
   * Returns safe values passed in GET request
   *
   * @param string $name
   * @return void
   */
  public static function getQueryParam(string $name) {
    return empty($_GET[$name]) ? null : \htmlentities(\trim($_GET[$name]));
  }

  /**
   * Returns safe values passed in POST request
   *
   * @param string $name
   * @return void
   */
  public static function getPOSTParam(string $name) {
    return empty($_POST[$name]) ? null : \htmlentities(\trim($_POST[$name]));
  }
}
