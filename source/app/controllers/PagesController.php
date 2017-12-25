<?php 

namespace App\Controllers;

require_once 'app/controllers/AuthController.php';

class PagesController {
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

  /**
   * Returns the login page
   *
   * @param boolean $loginFailed Whether the load is after a failed login
   * @return void
   */
  public function login(bool $loginFailed = false) {
    $name = 'login';
    $loginError = $loginFailed ? 'Non esiste un utente con questo codice fiscale e password' : null;

    return \Core\view('login', [
      'name' => $name,
      'loginError' => $loginError,
    ]);
  }

  public function loginPOST() {
    $isAuthenticated = $this->authController->authenticate();
    
    if ($isAuthenticated) \Core\redirect('/dashboard');
    else $this->login(true);
  }

  /**
   * Administration area
   */

  public function dashboard() {
    $name = 'dashboard';

    return \Core\view('dashboard', [
      'name' => $name
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
