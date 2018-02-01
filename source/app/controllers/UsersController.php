<?php

namespace App\Controllers;

use \App\Models\Investigatore;
use \App\Models\Amministratore;
use \App\Models\Ispettore;

require_once 'app/controllers/AuthController.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Amministratore.php';
require_once 'app/models/Ispettore.php';

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

  public function getUsers(): array {
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

  public function getClients(): array {
    return $this->database->runQuery('SELECT codice_fiscale FROM cliente ORDER BY codice_fiscale');
  }

  public function getCriminals(): array {
    return $this->database->runQuery('SELECT codice_fiscale FROM criminale ORDER BY codice_fiscale');
  }

  public function getDetectives(): array {
    return $this->database->runQuery('SELECT codice_fiscale FROM investigatore ORDER BY codice_fiscale');
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

  public function addUser(array $parameters): bool {
    $codiceFiscale = $parameters['codiceFiscale'];
    $password = $parameters['password'];
    $passwordConfirm = $parameters['passwordConfirm'];
    $nome = $parameters['nome'];
    $cognome = $parameters['cognome'];
    $role = $parameters['role'];
    $table = $this->getRoleTable($role);

    if ($password !== $passwordConfirm) {
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

  public function editUser(array $parameters): bool {
    $oldCodiceFiscale = $parameters['oldCodiceFiscale'];
    $newCodiceFiscale = $parameters['newCodiceFiscale'];
    $password = $parameters['password'];
    $passwordConfirm = $parameters['passwordConfirm'];
    $nome = $parameters['nome'];
    $cognome = $parameters['cognome'];
    $role = $parameters['role'];

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

  public function editUserPassword(array $parameters){
    $realPassword= $parameters['real_password'];
    $realCodiceFiscale = $parameters['real_codice_fiscale'];
    $codiceFiscale = $parameters['codice_fiscale'];
    $oldPassword = $parameters['old_password'];
    $password = $parameters['password'];
    $passwordConfirm = $parameters['passwordConfirm'];
    $role = $parameters['role'];

    if ($password !== $passwordConfirm) {
      throw new \Exception('passwordsNotEqual');
    }

    if ($realCodiceFiscale !== $codiceFiscale) {
      throw new \Exception('codiciNotEqual');
    }
    if($realPassword === false){
      throw new \Exception('wrongPassword');
    }

    $changes ='
    password_hash = :password_hash';
    $where = 'codice_fiscale = :codice_fiscale';
    $table = $this->getRoleTable($role);

    // Changes are done in table 'cliente' and not 'ispettore'
    if ($role === 'inspector') $table = 'cliente';

    return $this->database->update($table, $changes, $where, [
      ':password_hash' => \password_hash($password, PASSWORD_DEFAULT),
      'codice_fiscale' => $codiceFiscale
    ]);
  }


  public function deleteUser($codiceFiscale, $role): bool {
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

  private function getRoleTable(string $role): string {
    if ($role === 'detective') return 'investigatore';
    else if ($role === 'admin') return 'amministratore';
    else return 'ispettore';
  }
}
