<?php

namespace App\Controllers;
use \Core\Session;

require_once 'app/models/User.php';
require_once 'app/models/Investigatore.php';

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

    return $this->checkCredentials($codiceFiscale, $password);
  }

  public function getUser() {
    return Session::get('user');
  }

  public function isAuthenticated() {
    return Session::get('user') != null;
  }

  public function logout() {
    Session::destroy();
  }

  private function checkCredentials($codiceFiscale, $password) {
    $results = $this->database->selectWhere(
      ['codice_fiscale', 'password_hash', 'nome', 'cognome'],
      'investigatore',
      'codice_fiscale = :codice_fiscale',
      [':codice_fiscale' => $codiceFiscale]
    );

    if (\count($results) != 1) return false;
    else {
      $user = $results[0];
      $isAuthorized = \password_verify($password, $user->password_hash);

      if ($isAuthorized) {
        Session::start();
        Session::set('user', new \App\Models\Investigatore($user->codice_fiscale, $user->nome, $user->cognome));
      }

      return $isAuthorized;
    }
  }
}
