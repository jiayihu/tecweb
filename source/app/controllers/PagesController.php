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
    $duplicazione = Request::getQueryParam('duplicazione') !== null;
    $nuovoCasoOk = Request::getQueryParam('nuovoCasoOk') !== null;

    $role = $this->authController->getUserRole();
    $user = $this->authController->getUser();

    if ($role === 'admin' || $role === 'detective') {
      // Show only open cases
      $cases = $this->casesController->getOpenCases();
    } else {
      // Show only cases relative to the inspector
      $cases = $this->casesController->getIspectorCases($user->codice_fiscale);
    }

    $codice = Request::getQueryParam('id');
    $investigations = null;
    $clienti = $this->usersController->getClients();
    $case = null;
    
    if ($cases !== null && \count($cases) > 0) {
      if ($codice === null) $codice = $cases[0]->codice;
      $case = $this->casesController->getCase($codice); 
      $investigations = $this->investigationsController->getInvestigations($codice);
    } 

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
      'selectedCase' => $case,
      'nuovoCaso' => $nuovoCaso,
      'clienti' => $clienti,

      'zeroCasi' => $cases === null,
      'erroreCampiNuovoCaso' => $erroreCampiNuovoCaso,
      'duplicazione' => $duplicazione,
      'nuovoCasoOk' => $nuovoCasoOk,
    ]);
  }

  public function addCasePOST() {
    $this->protectRoute();

    $routeName = 'dashboard';

    $nome = Request::getPOSTParam('nome');
    $descrizione = Request::getPOSTParam('descrizione');
    $tipo = Request::getPOSTParam('tipo');
    $cliente = Request::getPOSTParam('cliente');

    if ($tipo === null || $cliente === null) {
      return \Core\redirect("/dashboard?nuovoCaso=true&erroreCampiNuovoCaso=true");

    } else {
      $insert = $this->casesController->insertCase($nome, $tipo, $descrizione, $cliente);

      if (!$insert) {
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

    $nuovaInvestigazione = Request::getQueryParam('nuovaInvestigazione') !== null; 
    $erroreNuovaInvestigazione = false;

    if ($nuovaInvestigazione) {
      $user = $this->authController->getUser();
      $succ = $this->investigationsController->insertInvestigation($caseId, $user->codice_fiscale);

      if (!$succ) $erroreNuovaInvestigazione = true;
    }

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

    $archiviato = Request::getQueryParam('archiviato') !== null;
    $erroreArchiviazione = Request::getQueryParam('erroreArchiviazione') !== null;
    $duplicato = Request::getQueryParam('duplicato') !== null;
    $modificaOk = Request::getQueryParam('modificaOk') !== null;
    $modificaErrore = Request::getQueryParam('modificaErrore') !== null;
    $investigazioneOk = Request::getQueryParam('investigazioneOk') !== null;
    $investigazioneErrore = Request::getQueryParam('investigazioneErrore') !== null;
    $investigazioneErroreOre = Request::getQueryParam('investigazioneErroreOre') !== null;
    $investigazioneErroreDataFine = Request::getQueryParam('investigazioneErroreDataFine') !== null;

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
      'selectedCase' => $case,
      'detectives' => $detectives,
      'clienti' => $clienti,
      'criminali' => $criminali,
      'investigatori' => $investigatori,
      'allTags' => $allTags,

      'archiviato' => $archiviato,
      'erroreArchiviazione' => $erroreArchiviazione,
      'duplicato' => $duplicato,
      'modificaOk' => $modificaOk,
      'modificaErrore' => $modificaErrore,
      'investigazioneOk' => $investigazioneOk,
      'investigazioneErrore' => $investigazioneErrore,
      'investigazioneErroreOre' => $investigazioneErroreOre,
      'investigazioneErroreDataFine' => $investigazioneErroreDataFine,
      'erroreNuovaInvestigazione' => $erroreNuovaInvestigazione
    ]);
  }

  public function editCasePOST() {
    $this->protectRoute();

    $routeName = 'caso';

    $caseId = Request::getPOSTParam('caseId');
    $investigationId = Request::getPOSTParam('invId');

    if ($investigationId === null) {
      $this->handleEditCasePOST($caseId);
    } else {
      $this->handleEditInvestigationPOST($caseId, $investigationId);
    }
  }

  public function handleEditCasePOST(int $caseId) {
    $nome = Request::getPOSTParam('nome');
    $descrizione = Request::getPOSTParam('descrizione');
    $tipologia = Request::getPOSTParam('tariffa');
    $cf_cliente = Request::getPOSTParam('cliente');
    $criminale = Request::getPOSTParam('criminale');
    $tags = Request::getPOSTParam('tags');
    $archiviaIrrisolto = Request::getPOSTParam('archivia');

    $case = $this->casesController->getCaseDetails($caseId);

    // Cannot archived without a criminal
    if ($archiviaIrrisolto && $criminale !== 'no_criminal') {
      return \Core\redirect('/caso?id='.$caseId.'&modifica=true&erroreArchiviazione=true');
    }

    if ($archiviaIrrisolto) {
      $case->setArchived(true);
    }
    
    if (!$archiviaIrrisolto) {
      // Resolved case
      if ($criminale !== 'no_criminal' && !$case->isResolved()) {
        $succ = $this->casesController->insertCaseCriminal($case->getId(), $criminale);
        $case->setResolved(true);
        $case->setArchived(true);
      } else if ($criminale !== 'no_criminal' && $criminale !== $case->criminale->getCodice()) {
        // Case already resolved, just changing the criminal
        $succ = $this->casesController->editCaseCriminal($case->getId(), $criminale);
      } else if ($criminale === 'no_criminal' && $case->isResolved()) {
        // Resolved case is set back as active
        $succ = $this->casesController->deleteCaseCriminal($case->getId());
        $case->setResolved(false);
        $case->setArchived(false);
      } else if ($criminale === 'no_criminal' && !$case->isResolved()) {
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

    $path = "/caso?id={$case->getId()}";

    if (isset($archiviaIrrisolto)) {
      $path = "{$path}&archiviatoIrrisolto=true";
    }

    if ((isset($succ) && !$succ) || !$success) {
      $path = "{$path}&modificaErrore=true";
    } else {
      $path = "{$path}&modificaOk=true";
    }

    return \Core\redirect($path);          
  }

  public function handleEditInvestigationPOST(int $caseId, int $investigationId) {
    $investigatore = Request::getPOSTParam('investigatore');
    $ore = Request::getPOSTParam('ore');
    $date_to = Request::getPOSTParam('date_to');
    $data_inizio = Request::getPOSTParam('data_inizio');
    $rapporto = Request::getPOSTParam('rapporto');
    $scena_nome = Request::getPOSTParam('scena_nome');
    $scena_descrizione = Request::getPOSTParam('scena_descrizione');
    $scena_citta = Request::getPOSTParam('scena_citta');
    $scena_indirizzo = Request::getPOSTParam('scena_indirizzo');

    $path = "/caso?id={$caseId}&investigazione={$investigationId}";

    if($ore < 0) {
      $path = "{$path}&modifica=true&investigazioneErroreOre=true";
      return \Core\redirect($path);
    }

    $inizio = new \DateTime($data_inizio);
    $fine = new \DateTime($date_to);

    if($inizio >= $fine) {
      $path = "{$path}&modifica=true&investigazioneErroreDataFine=true";
      return \Core\redirect($path);
    }

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

    
    
    if ($succ_scena && $succ_inv) {
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
    $clienti = $this->usersController->getClients();
    $criminali = $this->usersController->getCriminals();
    $investigatori = $this->usersController->getDetectives();

    return \Core\view('ricerca', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
      'user' => $this->authController->getUser(),

      'allTags' => $allTags,
      'clienti' => $clienti,
      'criminali' => $criminali,
      'investigatori' => $investigatori,

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
    $clienti = $this->usersController->getClients();
    $criminali = $this->usersController->getCriminals();
    $investigatori = $this->usersController->getDetectives();
    
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
      'user' => $this->authController->getUser(),

      'allTags' => $allTags,
      'criminali' => $criminali,
      'clienti' => $clienti,
      'investigatori' => $investigatori,

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

    $successful = Request::getQueryParam('successo') !== null;
    $genericError = Request::getQueryParam('errore') !== null;

    return \Core\view('aggiungi-criminale', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
      'successful' => $successful,
      'genericError' => $genericError,
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
    if ($successful) return \Core\redirect('/aggiungi-criminale?successo=true');
    else return \Core\redirect('/aggiungi-criminale?errore=true');
  }

  public function addCliente() {
    $this->protectRoute();

    $routeName = 'aggiungi-cliente';

    $successful = Request::getQueryParam('successo') !== null;
    $genericError = Request::getQueryParam('errore') !== null;

    return \Core\view('aggiungi-cliente', [
      'routeName' => $routeName,
      'username' => $this->getUsername(),
      'role' => $this->authController->getUserRole(),
      'successful' => $successful,
      'genericError' => $genericError,
    ]);
  }

  public function aggiungiCliente(){
    $codiceFiscale = Request::getPOSTParam('codice_fiscale');
    $nome = Request::getPOSTParam('nome');
    $cognome = Request::getPOSTParam('cognome');
    $citta = Request::getPOSTParam("citta");
    $indirizzo = Request::getPOSTParam("indirizzo");

    $successful=$this->casesController->addCliente([
      'codice_fiscale' => $codiceFiscale,
      'nome' => $nome,
      'cognome' => $cognome,
      'citta' => $citta,
      'indirizzo' => $indirizzo,
    ]);
    if ($successful) return \Core\redirect('/aggiungi-cliente?successo=true');
    else return \Core\redirect('/aggiungi-cliente?errore=true');
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
    $role = $this->authController->getUserRole();

    $checkOldPwd= $this->authController->checkPassword($realCodiceFiscale, $oldPassword, $role);

    if (!$checkOldPwd) return \Core\redirect('/impostazioni?wrongPassword=true');

    $successful = false;
    try{
    $successful = $this->usersController->editUserPassword([
      'real_codice_fiscale' => $realCodiceFiscale,
      'codice_fiscale' => $codiceFiscale,
      'password' => $password,
      'passwordConfirm' => $passwordConfirm,
      'role' => $role,
    ]);
    } catch (\Exception $e){
      if ($e->getMessage()=== 'passwordsNotEqual'){
        return \Core\redirect('/impostazioni?passwordNonUguali=true');
      }
      if ($e->getMessage()=== 'codiciNotEqual'){
        return \Core\redirect('/impostazioni?codiciNonUguali=true');
      }
    }
    if ($successful)  return \Core\redirect('/impostazioni?successo=true');
    else return \Core\redirect('/impostazioni?errore=true');
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
