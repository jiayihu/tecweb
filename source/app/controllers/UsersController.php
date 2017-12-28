<?php

namespace App\Controllers;

use \Core\Request;
use \App\Models\User;

require_once 'app/controllers/AuthController.php';

class UsersController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  /**
   * @var AuthController
   */
  private $authController;

  public function __construct() {
    $this->database = \Core\App::get('database');
    $this->authController = new AuthController();
  }

  public function getUsers() {
    $query = "
    (SELECT codice_fiscale, nome, cognome FROM amministratore)
    UNION
    (SELECT codice_fiscale, nome, cognome FROM investigatore)
    UNION 
    (SELECT ispettore.codice_fiscale, nome, cognome FROM cliente, ispettore WHERE cliente.codice_fiscale = ispettore.codice_fiscale);";
    $results = $this->database->runQuery($query);

    return \array_map(function ($result) {
      return new User($result->codice_fiscale, $result->nome, $result->cognome);
    }, $results);
  }

  public function addUserAPI() {
    $successful = false;
    $response = null;
    $errors = null;

    try {
      $successful = $this->addUser();
      $response = ['success' => $successful];
    } catch (\Exception $e) {
      if ($e->getMessage() === 'passwordsNotEqual') {
        $errors = [['id' => 'passwordsNotEqual']];
      }
      if ($e->getMessage() === 'alreadyExisting') {
        $errors = [['id' => 'alreadyExisting']];
      }
    }

    return $successful ? \Core\json($response) : \Core\json(null, $errors);
  }

  public function addUser() {
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $passwordConfirm = Request::getPOSTParam('password_confirm');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $role = Request::getPOSTParam('role');
    $table = '';

    if ($role === 'detective') $table = 'investigatore';
    else if ($role === 'admin') $table = 'amministratore';
    else $table = 'inspector';

    if ($passwordConfirm !== $passwordConfirm) {
      throw new \Exception('passwordsNotEqual');
    }

    // Check if the user already exists
    $existing = $this->authController->checkCredentials($codiceFiscale, $password, $role);
    if ($existing !== null) {
      throw new \Exception('alreadyExisting');
    }

    return $this->database->insert($table, [
      'codice_fiscale' => $codiceFiscale,
      'password_hash' => \password_hash($password, PASSWORD_DEFAULT),
      'nome' => $nome,
      'cognome' => $cognome,
    ]);
  }
}
