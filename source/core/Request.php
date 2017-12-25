<?php

namespace Core;

class Request {
  /**
   * Returns the URI of the request like 'login' in 'localhost:8888/login'
   *
   * @return void
   */
  public static function uri() {
    return \trim($_SERVER['PATH_INFO'], '/');
  }

  /**
   * Returns the HTTP method of the request, like 'GET' or 'POST'
   *
   * @return void
   */
  public static function method() {
    return $_SERVER['REQUEST_METHOD'];
  }

  public static function getQueryParam(string $name) {
    return empty($_GET[$name]) ? null : $_GET[$name];
  }
}
