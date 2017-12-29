<?php 

namespace Core;

class Logger {
  public static function log(...$msgs) {
    if (App::get('config')['production']) {
      return;
    }

    foreach ($msgs as $msg ) {
      $msgString = $msg;

      if (!\is_string($msg)) $msgString = \json_encode($msg);

      \error_log($msgString);
    }
  }
}
