<?php 

namespace App\Controllers;
use \Core\App;
use \Core\Request;

require_once 'app/controllers/AuthController.php';
require_once 'app/controllers/CasesController.php';
require_once 'app/controllers/InvestigationsController.php';
require_once 'app/controllers/TagsController.php';
require_once 'app/controllers/UsersController.php';

class PagesController {
  /**
   * @var AuthController
   */
  private $authController;

  /**
   * @var CasesController
   */
  private $casesController;

  /**
   * @var InvestigationsController
   */
  private $investigationsController;

  /**
   * @var TagsController
   */
  private $tagsController;

  /**
   * @var UsersController
   */
  private $usersController;

  public function __construct() {
    $this->authController = new AuthController();
    $this->casesController = new CasesController();
    $this->investigationsController = new InvestigationsController();
    $this->tagsController = new TagsController();
    $this->usersController = new UsersController();
  }

  public function home() {
    $routeName = 'home';

    return \Core\view('index', [
      'routeName' => $routeName
    ]);
  }

  public function services() {
    $routeName = 'servizi';

    return \Core\view('servizi', [
      'routeName' => $routeName
    ]);
  }

  public function cases() {
    $routeName = 'casi';

    return \Core\view('casi', [
      'routeName' => $routeName
    ]);
  }

  public function contacts() {
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
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $role = Request::getPOSTParam('role');

    $isAuthenticated = $this->authController->authenticate($codiceFiscale, $password, $role);
    
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
    $cases = $this->casesController->getCases();
    
    if($cases != null) {
      $selectcase = $this->casesController->getCase($cases[0]->nome);
    }
    

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
      'cases' => $cases,
      'selectcase' => $selectcase[0]
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

  public function search() {
    $this->protectRoute();

    $routeName = 'ricerca';
    $allTags = $this->tagsController->getTags();

    return \Core\view('ricerca', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),

      'allTags' => $allTags,

      'searchText' => null,
      'cases' => null,
      'investigations' => null,

      'emptySearch' => false
    ]);
  }

  public function searchCasesPOST(string $searchText = null) {
    $clienteCodiceFiscale = Request::getPOSTParam('cliente');
    $criminaleCodiceFiscale = Request::getPOSTParam('criminale');
    $tipologia = Request::getPOSTParam('tipologia');
    $tags = Request::getPOSTParam('tags');

    return $this->casesController->searchCases([
      'searchText' => $searchText,
      'clienteCodiceFiscale' => $clienteCodiceFiscale,
      'criminaleCodiceFiscale' => $criminaleCodiceFiscale,
      'tipologia' => $tipologia,
      'tags' => $tags,
    ]);
  }

  public function searchInvestigationsPOST(string $searchText = null) {
    $investigatoreCodiceFiscale = Request::getPOSTParam('investigatore');
    $scena = Request::getPOSTParam('scena');
    $dateFrom = Request::getPOSTParam('date-from');
    $dateTo = Request::getPOSTParam('date-to');

    if ($dateFrom !== null) $dateFrom = \DateTime::createFromFormat('Y-m-d', $dateFrom);
    if ($dateTo !== null) $dateTo = \DateTime::createFromFormat('Y-m-d', $dateTo);

    return $this->investigationsController->searchInvestigations([
      'searchText' => $searchText,
      'investigatoreCodiceFiscale' => $investigatoreCodiceFiscale,
      'scena' => $scena,
      'dateFrom' => $dateFrom,
      'dateTo' => $dateTo,
    ]);
  }

  public function searchPOST() {
    $this->protectRoute();

    $allTags = $this->tagsController->getTags();
    
    $searchText = Request::getPOSTParam('search_text');
    $type = Request::getPOSTParam('type');

    $cases = null;
    $investigations = null;

    $emptySearch = false;

    try {
      if ($type === 'case') {
        $cases = $this->searchCasesPOST($searchText);
      } else if ($type === 'investigation') {
        $investigations = $this->searchInvestigationsPOST($searchText);
      }
    } catch (\Exception $e) {
      if ($e->getMessage() === 'emptySearch') {
        $emptySearch = true;
      } else {
        throw $e;
      }
    }

    $routeName = 'ricerca';
    
    return \Core\view('ricerca', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),

      'allTags' => $allTags,

      'searchText' => $searchText,
      'cases' => $cases,
      'investigations' => $investigations,

      'emptySearch' => $emptySearch,
    ]);
  }

  public function case() {
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

  public function users() {
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
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $passwordConfirm = Request::getPOSTParam('password_confirm');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $role = Request::getPOSTParam('role');

    $successful = false;
    try {
      $successful = $this->usersController->addUser([
        'codiceFiscale' => $codiceFiscale,
        'password' => $password,
        'passwordConfirm' => $passwordConfirm,
        'nome' => $nome,
        'cognome' => $cognome,
        'role' => $role
      ]);
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
    $oldCodiceFiscale = Request::getPOSTParam('old_codice_fiscale');
    $newCodiceFiscale = Request::getPOSTParam('codice_fiscale');
    $password = Request::getPOSTParam('password');
    $passwordConfirm = Request::getPOSTParam('password_confirm');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $role = Request::getPOSTParam('role');

    $successful = $this->usersController->editUser([
      'oldCodiceFiscale' => $oldCodiceFiscale,
      'newCodiceFiscale' => $newCodiceFiscale,
      'password' => $password,
      'passwordConfirm' => $passwordConfirm,
      'nome' => $nome,
      'cognome' => $cognome,
      'role' => $role,
    ]);
    
    if ($successful) return \Core\redirect('/utenti?successo=true');
    else return \Core\redirect('/utenti?errore=true');
  }

  public function deleteUserPOST() {
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $role = Request::getPOSTParam('role');

    $successful = $this->usersController->deleteUser($codiceFiscale, $role);
    
    if ($successful) return \Core\redirect('/utenti?successo=true');
    else return \Core\redirect('/utenti?errore=true');
  }

  public function notFound() {
    $routeName = '404';

    return \Core\view('404', [
      'routeName' => $routeName
    ]);
  }

  private function getUsername(): string {
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
