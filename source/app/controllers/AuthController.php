<?php

namespace App\Controllers;

use \Core\Session;
use \Core\Request;
use \App\Models\User;
use \App\Models\Amministratore;
use \App\Models\Investigatore;
use \App\Models\Ispettore;

require_once 'app/models/User.php';
require_once 'app/models/Amministratore.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Ispettore.php';

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
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $role = Request::getPOSTParam('role');
    $userClass = 'User';

    if ($role === 'detective') $userClass = '\App\Models\Investigatore';
    else if ($role === 'admin') $userClass = '\App\Models\Amministratore';
    else $userClass = '\App\Models\Ispettore';

    $user = $this->getUserByCredentials($codiceFiscale, $password, $role);

    if ($user !== null) {
      Session::start();
      Session::set('user', new $userClass($user->codice_fiscale, $user->nome, $user->cognome));
    }
  }

  public function getUser() {
    return Session::get('user');
  }

  public function getUserRole() {
    $user = $this->getUser();
    $role = '';

    if ($user instanceof Investigatore) $role = 'detective';
    else if ($user instanceof Amministratore) $role = 'admin';
    else $role = 'inspector';

    return $role;
  }

  public function isAuthenticated() {
    return $this->getUser() !== null;
  }

  public function logout() {
    Session::destroy();
  }

  function getUserByCredentials($codiceFiscale, $password, $role) {
    $table = '';

    if ($role === 'detective') $table = 'investigatore';
    else if ($role === 'admin') $table = 'amministratore';
    else $table = 'cliente';

    $results = $this->database->selectWhere(
      $table,
      ['codice_fiscale', 'password_hash', 'nome', 'cognome'],
      'codice_fiscale = :codice_fiscale',
      [':codice_fiscale' => $codiceFiscale]
    );

    if (\count($results) !== 1) return null;
    else {
      $user = $results[0];
      $isAuthorized = \password_verify($password, $user->password_hash);

      return $isAuthorized ? $user : null;
    }
  }
}
