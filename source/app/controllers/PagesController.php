<?php 

namespace App\Controllers;
use \Core\Request;

require_once 'app/controllers/AuthController.php';

class PagesController {
  /**
   * Authentication controller
   *
   * @var AuthController
   */
  private $authController;

  public function __construct() {
    $this->authController = new AuthController();
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
    $investigations = [null, null, null, null, null];

    return \Core\view('dashboard', [
      'routeName' => $routeName,
      'autoLogin' => $autoLogin,
      'username' => $this->getUsername(),
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
      'username' => $this->getUsername()
    ]);
  }

  public function ricerca() {
    $this->protectRoute();

    $routeName = 'ricerca';

    return \Core\view('ricerca', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'query' => 'someQuery'
    ]);
  }

  public function caso() {
    $this->protectRoute();

    $routeName = 'caso';
    $caseId = Request::getQueryParam('caso');
    $investigations = [null, null, null, null, null];
    $investigationId = (int) Request::getQueryParam('investigazione');
    $isEdit = Request::getQueryParam('modifica') !== null;

    return \Core\view('caso', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'caseId' => $caseId,
      'investigations' => $investigations,
      'investigationId' => $investigationId,
      'isEdit' => $isEdit,
    ]);
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
