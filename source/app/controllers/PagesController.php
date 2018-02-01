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
    $nuovoCaso = Request::getQueryParam('nuovoCaso') !== null; 
    $erroreCampiNuovoCaso = Request::getQueryParam('erroreCampiNuovoCaso') !== null; 
    $nuovaInvestigazione = Request::getQueryParam('nuovaInvestigazione') !== null; 
    $archiviato = Request::getQueryParam('archiviato') !== null;
    $archiviatoIrrisolto = Request::getQueryParam('archiviatoIrrisolto') !== null;
    $duplicazione = Request::getQueryParam('duplicazione') !== null;
    $nuovoCasoOk = Request::getQueryParam('nuovoCasoOk') !== null;
    $erroreNuovaInvestigazione = false;

    $role = $this->authController->getUserRole();
    $user = $this->authController->getUser();

    if($role == 'admin') {
      $cases = $this->casesController->getAllCases(); // visualizza casi presenti e passati
    } else {
      if($role == 'detective') {
        $cases = $this->casesController->getPresentCases(); // visualizza casi solo presenti
      } else {
        $cases = $this->casesController->getIspectorCases($user->codice_fiscale); //visualizza soli i casi di cui l'ispettore è cliente
      }
    }

    $clienti = $this->usersController->getClients();
    
    if($cases != null) {
      $codice = Request::getQueryParam('id');
      if($codice==null) {
        $codice = $cases[0]->codice;
      }
      $case = $this->casesController->getCase($codice); 
      
      if($nuovaInvestigazione) {
        $succ = $this->investigationsController->insertInvestigation($codice, $user->codice_fiscale);

        if(!$succ) {
          $erroreNuovaInvestigazione = true;
        }
      }

      $investigations = $this->investigationsController->getInvestigations($codice); 
      
      return \Core\view('dashboard', [
        'routeName' => $routeName,
        'autoLogin' => $autoLogin,
        'notAuthorized' => $notAuthorized,
        'username' => $this->getUsername(),
        'role' => $role,
        'caseId' => $codice,
        'investigations' => $investigations,
        'investigationId' => null,
        'isEdit' => false,
        'cases' => $cases,
        'selectcase' => $case,
        'nuovoCaso' => $nuovoCaso,
        'clienti' => $clienti,

        'archiviato' => $archiviato,
        'archiviatoIrrisolto' => $archiviatoIrrisolto,
        'erroreCampiNuovoCaso' => $erroreCampiNuovoCaso,
        'duplicazione' => $duplicazione,
        'nuovoCasoOk' => $nuovoCasoOk,
        'erroreNuovaInvestigazione' => $erroreNuovaInvestigazione
      ]);
    } 
    
    return \Core\view('dashboard', [
      'routeName' => $routeName,
      'autoLogin' => $autoLogin,
      'notAuthorized' => $notAuthorized,
      'username' => $this->getUsername(),
      'role' => $role,
      'caseId' => null,
      'investigations' => null,
      'investigationId' => null,
      'isEdit' => false,
      'cases' => $cases,
      'selectcase' => null,
      'nuovoCaso' => $nuovoCaso,
      'clienti' => $clienti,

      'zeroCasi' => true,
      'archiviato' => $archiviato,
      'archiviatoIrrisolto' => $archiviatoIrrisolto,
      'erroreCampiNuovoCaso' => $erroreCampiNuovoCaso,
      'duplicazione' => $duplicazione,
      'nuovoCasoOk' => $nuovoCasoOk,
      'erroreNuovaInvestigazione' => $erroreNuovaInvestigazione
    ]);
  }

  public function addCasePOST() {
    $this->protectRoute();

    $routeName = 'dashboard';

    $nome = Request::getPOSTParam('nome');
    $descrizione = Request::getPOSTParam('descrizione');
    $tipo = Request::getPOSTParam('tipo');
    $cliente = Request::getPOSTParam('cliente');

    if($tipo == null || $cliente == null) {
      return \Core\redirect("/dashboard?nuovoCaso=true&erroreCampiNuovoCaso=true");

    } else {
      $insert = $this->casesController->insertCase($nome, $tipo, $descrizione, $cliente);

      if(!$insert) {
        return \Core\redirect("/dashboard?nuovoCaso=true&duplicazione=true");
      }
    }
    return \Core\redirect("/dashboard?nuovoCasoOk=true");
  }


  public function case() {
    $this->protectRoute();

    $routeName = 'caso';
    $role = $this->authController->getUserRole();
    $caseId = Request::getQueryParam('id');
    $investigations = $this->investigationsController->getInvestigations($caseId);
    $investigationId = (int) Request::getQueryParam('investigazione');
    $isEdit = Request::getQueryParam('modifica') !== null;

    $case = $this->casesController->getCaseDetails($caseId);
    $detectives = $this->casesController->getDetectives($caseId);
    $tags = $this->casesController->getTags($caseId);
    
    $case->investigazioni = $investigations;
    $case->tags = $tags;

    $clienti = $this->usersController->getClients();
    $criminali = $this->usersController->getCriminals();
    $investigatori = $this->usersController->getDetectives();
    $allTags = $this->tagsController->getTags();

    $erroreArchiviazione = Request::getQueryParam('erroreArchiviazione') !== null;
    $duplicato = Request::getQueryParam('duplicato') !== null;
    $modificaOk = Request::getQueryParam('modificaOk') !== null;
    $modificaErrore = Request::getQueryParam('modificaErrore') !== null;
    $investigazioneOk = Request::getQueryParam('investigazioneOk') !== null;
    $investigazioneErrore = Request::getQueryParam('investigazioneErrore') !== null;

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
      'case' => $case,
      'detectives' => $detectives,
      'clienti' => $clienti,
      'criminali' => $criminali,
      'investigatori' => $investigatori,
      'allTags' => $allTags,

      'erroreArchiviazione' => $erroreArchiviazione,
      'duplicato' => $duplicato,
      'modificaOk' => $modificaOk,
      'modificaErrore' => $modificaErrore,
      'investigazioneOk' => $investigazioneOk,
      'investigazioneErrore' => $investigazioneErrore
    ]);
  }

  public function editCasePOST() {
    $this->protectRoute();

    $routeName = 'caso';

    $caseId = Request::getPOSTParam('caseId');
    $investigationId = Request::getPOSTParam('invId');

    if($investigationId === null) {
      $this->handleEditCasePOST($caseId);
    } else {
      $this->handleEditInvestigationPOST($investigationId);
    }
  }

  public function handleEditCasePOST(int $caseId) {
    $nome = Request::getPOSTParam('title');
    $descrizione = Request::getPOSTParam('descrizione');
    $tipologia = Request::getPOSTParam('tariffa');
    $cf_cliente = Request::getPOSTParam('cliente');
    $criminale = Request::getPOSTParam('criminale');
    $tags = Request::getPOSTParam('tags');
    $archiviaIrrisolto = Request::getPOSTParam('archivia');

    $case = $this->casesController->getCaseDetails($caseId);

    // Cannot archived without a criminal
    if($archiviaIrrisolto && $criminale != 'no_criminal') {
      return \Core\redirect('/caso?id='.$caseId.'&modifica=true&erroreArchiviazione=true');
    }

    if ($archiviaIrrisolto) {
      $case->setArchived(true);
    }
    
    if(!$archiviaIrrisolto) {
      // Resolved case
      if($criminale != 'no_criminal' && !$case->isResolved()) {
        $succ = $this->casesController->insertCaseCriminal($case->getId(), $criminale);
        $case->setResolved(true);
        $case->setArchived(true);
      }

      // Case already resolved, just changing the criminal
      if($criminale != 'no_criminal' && $case->isResolved() && $criminale != $case->criminale->getCodice()) {
        $succ = $this->casesController->editCaseCriminal($case->getId(), $criminale);
      }

      // Resolved case is set back as active
      if($criminale == 'no_criminal' && $case->isResolved()) {
        $succ = $this->casesController->deleteCaseCriminal($case->getId());
        $case->setResolved(false);
        $case->setArchived(false);
      }

      if($criminale == 'no_criminal' && !$case->isResolved()) {
        $case->setArchived(false);
      }
    }

    $risolto = $case->isResolved() ? 1 : 0;
    $passato = $case->isArchived() ? 1 : 0;

    $exist = $this->casesController->checkCaseName($nome, $case->getId());

    if ($exist) {
      $path = '/caso?id='.$caseId.'&modifica=true&duplicato=true';
      return \Core\redirect($path);
    }

    $success = $this->casesController->editCase([
      'case' => $case,
      'newNome' => $nome,
      'newDescrizione' => $descrizione,
      'tipologia' => $tipologia,
      'cf_cliente' => $cf_cliente,
      'risolto' => $risolto,
      'passato' => $passato,
      'tags' => $tags
    ]);

    if(isset($archiviaIrrisolto)) {
      return \Core\redirect('/dashboard?archiviatoIrrisolto=true');
    }

    $path = "/caso?id={$case->getId()}";

    if((isset($succ) && !$succ) || !$success) {
      $path = "${$path}&modificaErrore=true";
    } else {
      $path = "${$path}&modificaOk=true";
    }

    return \Core\redirect($path);          
  }

  public function handleEditInvestigationPOST($investigationId) {
    $investigatore = Request::getPOSTParam('investigatore');
    $ore = Request::getPOSTParam('ore');
    $date_to = Request::getPOSTParam('date_to');
    $rapporto = Request::getPOSTParam('rapporto');
    $scena_nome = Request::getPOSTParam('scena_nome');
    $scena_descrizione = Request::getPOSTParam('scena_descrizione');
    $scena_citta = Request::getPOSTParam('scena_citta');
    $scena_indirizzo = Request::getPOSTParam('scena_indirizzo');

    $succ_scena = $this->investigationsController->editScena([
      'caseId' => $caseId,
      'investigationId' => $investigationId,
      'nome' => $scena_nome,
      'descrizione' => $scena_descrizione,
      'citta' => $scena_citta,
      'indirizzo' => $scena_indirizzo
    ]);

    $succ_inv = $this->investigationsController->editInvestigation([
      'caseId' => $caseId,
      'investigationId' => $investigationId,
      'investigatore' => $investigatore,
      'date_to' => $date_to,
      'rapporto' => $rapporto,
      'ore' => $ore
    ]);

    $path = "/caso?id={$caseId}&investigazione={$investigationId}";
    
    if($succ_scena && $succ_inv) {
      $path = "{$path}&investigazioneOk=true";
    } else {
      $path = "{$path}&investigazioneErrore=true";
    }

    return \Core\redirect($path);
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

  public function addCriminale() {
    $this->protectRoute();

    $routeName = 'aggiungi-criminale';

    return \Core\view('aggiungi-criminale', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
    ]);
  }

  public function aggiungiCriminale(){
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $descrizione = Request::getPOSTParam("descrizione");

    $successful=$this->casesController->addCriminale([
      'codice_fiscale' => $codiceFiscale,
      'nome' => $nome,
      'cognome' => $cognome,
      'descrizione' => $descrizione,
    ]);
    if ($successful) return \Core\redirect('/aggiungi-criminale');
    else return \Core\redirect('/aggiungi-criminale');
  }

  public function addCliente() {
    $this->protectRoute();

    $routeName = 'aggiungi-cliente';

    return \Core\view('aggiungi-cliente', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
    ]);
  }

  public function aggiungiCliente(){
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $password = Request::getPOSTParam("password");

    $successful=$this->casesController->addCliente([
      'codice_fiscale' => $codiceFiscale,
      'nome' => $nome,
      'cognome' => $cognome,
      'password' => $password,
    ]);
    if ($successful) return \Core\redirect('/aggiungi-cliente');
    else return \Core\redirect('/aggiungi-cliente');
  }

  public function impostazioni() {
    $this->protectRoute();

    $routeName = 'impostazioni';
    $role = $this->authController->getUserRole();
    $user = $this->authController->getUser();

    $passwordsNotEqual = Request::getQueryParam('passwordNonUguali') !== null;
    $codiciNotEqual = Request::getQueryParam('codiciNonUguali') !== null;
    $passwordSbagliata = Request::getQueryParam('wrongPassword') !== null;


    $successful = Request::getQueryParam('successo') !== null;
    $genericError = Request::getQueryParam('errore') !== null;




    return \Core\view('impostazioni', [
      'routeName' => $routeName,
      'role' => $role,
      'username' => $user->nome,
      'userCodiceFiscale' => $user->codice_fiscale,

      'passwordsNotEqual' => $passwordsNotEqual,
      'codiciNotEqual' => $codiciNotEqual,
      'passwordSbagliata' => $passwordSbagliata,

      'successful' => $successful,
      'genericError' => $genericError,


    ]);
  }

  public function editUserPasswordPOST() {
    $realCodiceFiscale = $this->getCodiceFiscale();
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $oldPassword = Request::getPOSTParam('old_password');
    $password = Request::getPOSTParam('password');
    $passwordConfirm = Request::getPOSTParam('password_confirm');
    $role = Request::getPOSTParam('role');
    $realPassword= $this->authController->checkPassword($realCodiceFiscale,$oldPassword,$role);

    $successful = false;
    try{
    $successful = $this->usersController->editUserPassword([
      'real_password' => $realPassword,
      'real_codice_fiscale' => $realCodiceFiscale,
      'codice_fiscale' => $codiceFiscale,
      'old_password' => $oldPassword,
      'password' => $password,
      'passwordConfirm' => $passwordConfirm,
      'role' => $role,
    ]);
    } catch (\Exception $e){
      if($e->getMessage()=== 'passwordsNotEqual'){
        return \Core\redirect('/impostazioni?passwordNonUguali=true');
      }
      if($e->getMessage()=== 'codiciNotEqual'){
        return \Core\redirect('/impostazioni?codiciNonUguali=true');
      }
      if($e->getMessage()=== 'wrongPassword'){
        return \Core\redirect('/impostazioni?wrongPassword=true');
      }
    }
    if ($successful) return \Core\redirect('/impostazioni');
    else return \Core\redirect('/impostazioni');
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
  private function getCodiceFiscale(): string {
    $user = $this->authController->getUser();

    return $user->codice_fiscale;
  }

  private function protectRoute() {
    if (!$this->authController->isAuthenticated()) {
      \Core\redirect('/login?notAuthorized=true');

      // Terminate execution
      exit;
    }
  }
}
