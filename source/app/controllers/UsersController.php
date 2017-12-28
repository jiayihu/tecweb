<?php

namespace App\Controllers;

use \Core\Request;
use \App\Models\Investigatore;
use \App\Models\Amministratore;
use \App\Models\Ispettore;

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
    $detectiveResults = $this->database->runQuery('SELECT codice_fiscale, nome, cognome FROM investigatore;');
    $adminResults = $this->database->runQuery('SELECT codice_fiscale, nome, cognome FROM amministratore;');
    $inspectorResults = $this->database->runQuery('SELECT ispettore.codice_fiscale, nome, cognome FROM cliente, ispettore WHERE cliente.codice_fiscale = ispettore.codice_fiscale;');

    $detectives = \array_map(function ($result) {
      return new Investigatore($result->codice_fiscale, $result->nome, $result->cognome);
    }, $detectiveResults);
    $admins = \array_map(function ($result) {
      return new Amministratore($result->codice_fiscale, $result->nome, $result->cognome);
    }, $adminResults);
    $inspectors = \array_map(function ($result) {
      return new Ispettore($result->codice_fiscale, $result->nome, $result->cognome);
    }, $inspectorResults);

    return [
      'detectives' => $detectives,
      'admins' => $admins,
      'inspectors' => $inspectors,
    ];
  }

  public function getUser($codiceFiscale, $role) {
    $table = $this->getRoleTable($role);
    $where = 'codice_fiscale = :codice_fiscale';

    // Nome and cognome in table 'cliente' and not 'ispettore'
    if ($role === 'inspector') $table = 'cliente';

    $results = $this->database->selectWhere($table, ['*'], $where, [
      ':codice_fiscale' => $codiceFiscale
    ]);

    return \count($results) === 0 ? null : $results[0];
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
    $table = $this->getRoleTable($role);

    if ($passwordConfirm !== $passwordConfirm) {
      throw new \Exception('passwordsNotEqual');
    }

    // Check if the user already exists
    $existing = $this->authController->getUserByCredentials($codiceFiscale, $password, $role);
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

  public function editUser() {
    $oldCodiceFiscale = Request::getPOSTParam('old_codice_fiscale');
    $newCodiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $passwordConfirm = Request::getPOSTParam('password_confirm');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $role = Request::getPOSTParam('role');

    if ($passwordConfirm !== $passwordConfirm) {
      throw new \Exception('passwordsNotEqual');
    }

    $changes = '
      codice_fiscale = :new_codice_fiscale,
      password_hash = :password_hash,
      nome = :nome,
      cognome = :cognome';
    $where = 'codice_fiscale = :old_codice_fiscale';
    $table = $this->getRoleTable($role);

    // Changes are done in table 'cliente' and not 'ispettore'
    if ($role === 'inspector') $table = 'cliente';

    return $this->database->update($table, $changes, $where, [
      ':new_codice_fiscale' => $newCodiceFiscale,
      ':password_hash' => \password_hash($password, PASSWORD_DEFAULT),
      ':nome' => $nome,
      ':cognome' => $cognome,

      ':old_codice_fiscale' => $oldCodiceFiscale
    ]);
  }

  public function deleteUser() {
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $role = Request::getPOSTParam('role');
    $table = $this->getRoleTable($role);
    $where = "codice_fiscale = :codice_fiscale";

    if ($role === 'inspector') {
      // Inspector must be deleted also from 'cliente' table
      $this->database->delete('cliente', $where, [
        'codice_fiscale' => $codiceFiscale
      ]);
    }

    return $this->database->delete($table, $where, [
      'codice_fiscale' => $codiceFiscale
    ]);
  }

  private function getRoleTable(string $role) {
    if ($role === 'detective') return 'investigatore';
    else if ($role === 'admin') return 'amministratore';
    else return 'ispettore';
  }
}
