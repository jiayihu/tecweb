<?php

namespace App\Controllers;

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

    $results = $this->database->selectWhere(
      ['codice_fiscale', 'password_hash'],
      'investigatore',
      'codice_fiscale = :codice_fiscale',
      [':codice_fiscale' => $codiceFiscale]
    );

    if (\count($results) != 1) return false;
    else return \password_verify($password, $results[0]->password_hash);
  }
}
