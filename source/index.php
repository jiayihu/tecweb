<?php 

use Core\Router;
use Core\Request;

require_once 'core/main.php';

Router::load('app/routes.php')
  ->direct(Request::uri(), Request::method());
