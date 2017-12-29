<?php

namespace Core;
use Core\Database\Connection;
use Core\Database\QueryBuilder;

require_once 'core/functions.php';
$config = require_once 'core/config.php';
require_once 'core/App.php';
require_once 'core/database/Connection.php';
require_once 'core/database/QueryBuilder.php';
require_once 'core/Logger.php';
require_once 'core/Router.php';
require_once 'core/Request.php';
require_once 'core/Session.php';

App::bind('config', $config);
App::bind('pdo', Connection::make(App::get('config')['database']));
App::bind('database', new QueryBuilder(App::get('pdo')));

if (!$config['production']) {
  /**
   * Throw PhP warnings and notices as errors
   */
  set_error_handler(function ($errNo, $errStr, $errFile, $errLine) use ($config) {
    $msg = "$errStr in $errFile on line $errLine";

    if ($config['production']) {
      \Core\Logger::log($msg, $errNo);
    } else if ($errNo == E_NOTICE || $errNo == E_WARNING) {
        throw new \ErrorException($msg, $errNo);
    } else {
        echo $msg;
    }
  });
}
