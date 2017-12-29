<?php 

namespace Core;

class Logger {
  public static function log($msg) {
    if (App::get('config')['production']) {
      return;
    }

    $msgString = $msg;

    if (!\is_string($msg)) $msgString = \json_encode($msg);

    \error_log($msgString);
  }
}
