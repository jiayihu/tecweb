<?php 

namespace App\Controllers;

require_once 'app/controllers/UsersController.php';

class PagesController {
  public function home() {
    $name = 'home';
    // $tasks = (new UsersController())->getTasksTemplate();

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

    return \Core\view('login', [
      'name' => $name
    ]);
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
