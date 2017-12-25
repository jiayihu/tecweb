<?php

namespace Core;

class Request {
  /**
   * Returns the URI of the request like 'login' in 'localhost:8888/login'
   *
   * @return void
   */
  public static function uri() {
    return \trim($_SERVER['REQUEST_URI'], '/');
  }

  /**
   * Returns the HTTP method of the request, like 'GET' or 'POST'
   *
   * @return void
   */
  public static function method() {
    return $_SERVER['REQUEST_METHOD'];
  }
}
