<?php

namespace Core;

/**
 * Handles a cookie session
 */
class Session {
  public static function start() {
    if (!isset($_SESSION)) {
      \session_start([
        // Set cookie lifetime to 1 day
        'cookie_lifetime' => 86400,
      ]);
    }
  }

  public static function destroy() {
    self::start();
    $_SESSION = [];
    \session_destroy();
  }

  public static function set(string $name, $value) {
    self::start();

    $_SESSION[$name] = $value;
  }

  public static function get($name) {
    self::start();

    return empty($_SESSION[$name]) ? null : $_SESSION[$name];
  }
}
