<?php

namespace App\Controllers;
use \Core\Session;

require_once 'app/models/User.php';
require_once 'app/models/Amministratore.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Cliente.php';

class AuthController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  public function __construct() {
    $this->database = \Core\App::get('database');
  }

  public function authenticateAPI() {
    $isAuthorized = $this->authenticate();

    return \Core\json(['success' => $isAuthorized]);
  }

  public function authenticate() {
    $codiceFiscale = \htmlentities($_POST['codice_fiscale']);
    $password = \htmlentities($_POST['password']);
    $role = \htmlentities($_POST['role']);

    var_dump($_POST);

    return $this->checkCredentials($codiceFiscale, $password, $role);
  }

  public function getUser() {
    return Session::get('user');
  }

  public function isAuthenticated() {
    return Session::get('user') !== null;
  }

  public function logout() {
    Session::destroy();
  }

  private function checkCredentials($codiceFiscale, $password, $role) {
    $userClass = '\App\Models\User';
    $table = '';

    if ($role === 'detective') {
      $userClass = '\App\Models\Investigatore';
      $table = 'investigatore';
    } else if ($role === 'admin') {
      $userClass = '\App\Models\Amministratore';
      $table = 'amministratore';
    } else {
      $userClass = '\App\Models\Cliente';
      $table = 'cliente';
    }

    $results = $this->database->selectWhere(
      ['codice_fiscale', 'password_hash', 'nome', 'cognome'],
      $table,
      'codice_fiscale = :codice_fiscale',
      [':codice_fiscale' => $codiceFiscale]
    );

    if (\count($results) !== 1) return false;
    else {
      $user = $results[0];
      $isAuthorized = \password_verify($password, $user->password_hash);

      if ($isAuthorized) {
        Session::start();
        Session::set('user', new $userClass($user->codice_fiscale, $user->nome, $user->cognome));
      }

      return $isAuthorized;
    }
  }
}
