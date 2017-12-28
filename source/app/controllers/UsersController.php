<?php

namespace App\Controllers;

use \Core\Request;

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

  public function addUserAPI() {
    $successful = false;
    $response = null;
    try {
      $successful = $this->addUser();
      $response = ['success' => $successful];
    } catch (\Exception $e) {
      if ($e->getMessage() === 'passwordsNotEqual') {
        $response = [['id' => 'passwordsNotEqual']];
      }
      if ($e->getMessage() === 'alreadyExisting') {
        $response = [['id' => 'alreadyExisting']];
      }
    }

    return \Core\json($response);
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
