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
    $name = 'home';

    return \Core\view('index', [
      'name' => $name
    ]);
  }

  public function servizi() {
    $name = 'servizi';

    return \Core\view('servizi', [
      'name' => $name
    ]);
  }

  public function casi() {
    $name = 'casi';

    return \Core\view('casi', [
      'name' => $name
    ]);
  }

  public function contatti() {
    $name = 'contatti';

    return \Core\view('contatti', [
      'name' => $name
    ]);
  }

  public function login() {
    $name = 'login';
    $loginError = Request::getQueryParam('loginFailed') != null
      ? 'Non esiste un utente con questo codice fiscale e password'
      : null;
    $dashboardError = Request::getQueryParam('notAuthorized') != null
      ? 'Accedi con le tue credenziali per poter visualizzare l\'area amministrativa.'
      : null;

    return \Core\view('login', [
      'name' => $name,
      'loginError' => $loginError,
      'dashboardError' => $dashboardError,
    ]);
  }

  public function loginPOST() {
    $isAuthenticated = $this->authController->authenticate();
    
    if ($isAuthenticated) \Core\redirect('/dashboard');
    else \Core\redirect('/login?loginFailed=true');
  }

  /**
   * Administration area
   */

  public function dashboard() {
    if (!$this->authController->isAuthenticated()) {
      \Core\redirect('/login?notAuthorized=true');
      return;
    }
    
    $name = 'dashboard';
    $user = $this->authController->getUser();

    return \Core\view('dashboard', [
      'name' => $name,
      'username' => $user->nome . ' ' . $user->cognome
    ]);
  }

  public function addCase() {
    $name = 'aggiungi-caso';

    return \Core\view('aggiungi-caso', [
      'name' => $name
    ]);
  }

  public function notFound() {
    $name = '404';

    return \Core\view('404', [
      'name' => $name
    ]);
  }
}
