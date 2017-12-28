<?php 

namespace App\Controllers;
use \Core\Request;

require_once 'app/controllers/AuthController.php';
require_once 'app/controllers/UsersController.php';

class PagesController {
  /**
   * @var AuthController
   */
  private $authController;

  /**
   * @var UsersController
   */
  private $usersController;

  public function __construct() {
    $this->authController = new AuthController();
    $this->usersController = new UsersController();
  }

  public function home() {
    $routeName = 'home';

    return \Core\view('index', [
      'routeName' => $routeName
    ]);
  }

  public function servizi() {
    $routeName = 'servizi';

    return \Core\view('servizi', [
      'routeName' => $routeName
    ]);
  }

  public function casi() {
    $routeName = 'casi';

    return \Core\view('casi', [
      'routeName' => $routeName
    ]);
  }

  public function contatti() {
    $routeName = 'contatti';

    return \Core\view('contatti', [
      'routeName' => $routeName
    ]);
  }

  public function login() {
    if ($this->authController->isAuthenticated()) {
      \Core\redirect('/dashboard?autoLogin=true');
      return;
    }

    $routeName = 'login';
    $loginError = Request::getQueryParam('loginFailed') !== null;
    $dashboardError = Request::getQueryParam('notAuthorized') !== null;

    return \Core\view('login', [
      'routeName' => $routeName,
      'loginError' => $loginError,
      'dashboardError' => $dashboardError,
    ]);
  }

  public function loginPOST() {
    $isAuthenticated = $this->authController->authenticate();
    
    if ($isAuthenticated) \Core\redirect('/dashboard');
    else \Core\redirect('/login?loginFailed=true');
  }

  public function logout() {
    $this->authController->logout();
    \Core\redirect('/login');
  }

  /**
   * Administration area
   */

  public function dashboard() {
    $this->protectRoute();

    $routeName = 'dashboard';
    $autoLogin = Request::getQueryParam('autoLogin') !== null;
    $notAuthorized = Request::getQueryParam('permessoNegato') !== null;
    $investigations = [null, null, null, null, null];

    return \Core\view('dashboard', [
      'routeName' => $routeName,
      'autoLogin' => $autoLogin,
      'notAuthorized' => $notAuthorized,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
      'caseId' => null,
      'investigations' => $investigations,
      'investigationId' => null,
      'isEdit' => false,
    ]);
  }

  public function addCase() {
    $this->protectRoute();

    $routeName = 'aggiungi-caso';

    return \Core\view('aggiungi-caso', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
    ]);
  }

  public function ricerca() {
    $this->protectRoute();

    $routeName = 'ricerca';

    return \Core\view('ricerca', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
      'query' => 'someQuery'
    ]);
  }

  public function caso() {
    $this->protectRoute();

    $routeName = 'caso';
    $role = $this->authController->getUserRole();
    $caseId = Request::getQueryParam('caso');
    $investigations = [null, null, null, null, null];
    $investigationId = (int) Request::getQueryParam('investigazione');
    $isEdit = Request::getQueryParam('modifica') !== null;

    if ($role === 'inspector' && $isEdit) {
      return \Core\redirect("/caso?caso={$caseId}&investigazione={$investigationId}");
    }

    return \Core\view('caso', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $role,
      'caseId' => $caseId,
      'investigations' => $investigations,
      'investigationId' => $investigationId,
      'isEdit' => $isEdit,
    ]);
  }

  public function utenti() {
    $this->protectRoute();

    $routeName = 'utenti';
    $role = $this->authController->getUserRole();
    $user = $this->authController->getUser();

    $passwordsNotEqual = Request::getQueryParam('passwordNonUguali') !== null;
    $alreadyExisting = Request::getQueryParam('esistente') !== null;
    $addFailed = Request::getQueryParam('erroreCreazione') !== null;

    $isEdit = Request::getQueryParam('modifica') !== null;
    $editingCodiceFiscale = Request::getQueryParam('codice_fiscale');
    $editingRole = Request::getQueryParam('role');
    $editingUser = null;

    if ($isEdit) $editingUser = $this->usersController->getUser($editingCodiceFiscale, $editingRole);

    $successful = Request::getQueryParam('successo') !== null;
    $genericError = Request::getQueryParam('errore') !== null;

    $users = $this->usersController->getUsers();

    if ($role !== 'admin') {
      return \Core\redirect("/dashboard?permessoNegato=true");
    }

    return \Core\view('utenti', [
      'routeName' => $routeName,
      'role' => $role,
      'username' => $user->nome,
      'userCodiceFiscale' => $user->codice_fiscale,

      'passwordsNotEqual' => $passwordsNotEqual,
      'alreadyExisting' => $alreadyExisting,

      'addFailed' => $addFailed,
      'successful' => $successful,
      'genericError' => $genericError,

      'isEdit' => $isEdit,
      'editingRole' => $editingRole,
      'editingUser' => $editingUser,

      'detectives' => $users['detectives'],
      'admins' => $users['admins'],
      'inspectors' => $users['inspectors'],
    ]);
  }

  public function addUserPOST() {
    $successful = false;
    try {
      $successful = $this->usersController->addUser();
    } catch (\Exception $e) {
      if ($e->getMessage() === 'passwordsNotEqual') {
        return \Core\redirect('/utenti?passwordNonUguali=true');
      } else if ($e->getMessage() === 'alreadyExisting') {
        return \Core\redirect('/utenti?esistente=true');
      } else {
        throw $e;
      }
    }

    if ($successful) return \Core\redirect('/utenti?successo=true');
    else return \Core\redirect('/utenti?erroreCreazione=true');
  }

  public function editUserPOST() {
    $successful = $this->usersController->editUser();
    
    if ($successful) return \Core\redirect('/utenti?successo=true');
    else return \Core\redirect('/utenti?errore=true');
  }

  public function deleteUserPOST() {
    $successful = $this->usersController->deleteUser();
    
    if ($successful) return \Core\redirect('/utenti?successo=true');
    else return \Core\redirect('/utenti?errore=true');
  }

  public function notFound() {
    $routeName = '404';

    return \Core\view('404', [
      'routeName' => $routeName
    ]);
  }

  private function getUsername() {
    $user = $this->authController->getUser();

    return $user->nome . ' ' . $user->cognome;
  }

  private function protectRoute() {
    if (!$this->authController->isAuthenticated()) {
      \Core\redirect('/login?notAuthorized=true');

      // Terminate execution
      exit;
    }
  }
}
