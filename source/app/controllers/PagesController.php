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
      $selectcase = $this->casesController->getCase($codice); 
      
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
        'selectcase' => $selectcase,
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

    $erroreArchiviazione = Request::getQueryParam('erroreArchiviazione') !== null;
    $duplicato = Request::getQueryParam('duplicato') !== null;
    $modificaOk = Request::getQueryParam('modificaOk') !== null;
    $modificaErrore = Request::getQueryParam('modificaErrore') !== null;
    $investigazioneOk = Request::getQueryParam('investigazioneOk') !== null;
    $investigazioneErrore = Request::getQueryParam('investigazioneErrore') !== null;

    $selectcase = $this->casesController->getCaseDetails($caseId);
    $detectives = $this->casesController->getDetectives($caseId);
    $tags = $this->casesController->getTags($caseId);
    
    $selectcase->investigazioni = $investigations;
    $selectcase->tags = $tags;

    $clienti = $this->usersController->getClients();
    $criminali = $this->usersController->getCriminals();
    $investigatori = $this->usersController->getDetectives();

    $successo = Request::getQueryParam('successo') !== null;
    $errore = Request::getQueryParam('errore') !== null;

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
      'selectcase' => $selectcase,
      'detectives' => $detectives,
      'clienti' => $clienti,
      'criminali' => $criminali,
      'investigatori' => $investigatori,

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

    if($investigationId == null) {                              // modifica caso
      $nome = Request::getPOSTParam('title');
      $descrizione = Request::getPOSTParam('descrizione');
      $tipologia = Request::getPOSTParam('tariffa');
      $cf_cliente = Request::getPOSTParam('cliente');
      $criminale = Request::getPOSTParam('criminale');
      $tags = Request::getPOSTParam('tags');
      $archiviaIrrisolto = Request::getPOSTParam('archivia');
  
      $selectcase = $this->casesController->getCaseDetails($caseId);

      // far tornare attivo un caso irrisolto

      if($archiviaIrrisolto && $criminale != 'no_criminal') {
        return \Core\redirect('/caso?id='.$caseId.'&modifica=true&erroreArchiviazione=true');
      } else {
        if(!$archiviaIrrisolto) {
          if($criminale != 'no_criminal' && !$selectcase->isResolved()) { // caso risolto
            $succ = $this->casesController->insertCaseCriminal($selectcase->getId(), $criminale);
            $selectcase->setResolved(true);
            $selectcase->setArchived(true);
            $archiviato = true;                                 // un caso risolto deve essere anche archiviato
          } else {
            if($criminale != 'no_criminal' && $criminale != $selectcase->criminale->getCodice()) { // caso già risolto, cambia il criminale
              $succ = $this->casesController->editCaseCriminal($selectcase->getId(), $criminale);
            } else {
              if($criminale == 'no_criminal' && $selectcase->isResolved()) { // caso da risolto ritorna attivo (oerazione possibile solo da admin)
                $succ = $this->casesController->deleteCaseCriminal($selectcase->getId());
                $selectcase->setResolved(false);
                $selectcase->setArchived(false);
              } else {
                if($criminale == 'no_criminal' && !$selectcase->isResolved()) {
                  $selectcase->setArchived(false);
                }
              }
            }
          }
        } else {
          $selectcase->setArchived(true);     // caso irrisolto viene archiviato
          $archiviaIrrisolto = true;
        }
      }
  
      if($selectcase->isResolved()) {
        $risolto = 1;
      } else {
        $risolto = 0;
      }
  
      if($selectcase->isArchived()) {
        $passato = 1;
      } else {
        $passato = 0;
      }

      $exist = $this->casesController->checkCaseName($nome, $selectcase->getId());

      if(!$exist) {
        $successo = $this->casesController->editCase([
          'caseId' => $selectcase->getId(),
          'newNome' => $nome,
          'newDescrizione' => $descrizione,
          'tipologia' => $tipologia,
          'cf_cliente' => $cf_cliente,
          'risolto' => $risolto,
          'passato' => $passato,
          'tags' => $tags
        ]);
      } else {
        $path = '/caso?id='.$caseId.'&modifica=true&duplicato=true';
        return \Core\redirect($path);
      }
  
      if(isset($archiviaIrrisolto)) {
        return \Core\redirect('/dashboard?archiviatoIrrisolto=true');
      } else {
        $path = '/caso?id='.$selectcase->getId();
        if((isset($succ) && $succ && $successo) || $successo) {
          $path = $path.'&modificaOk=true';
          return \Core\redirect($path);
        } else {
            $path = $path.'&modificaErrore=true';
            return \Core\redirect($path);          
        }
      }
    } else {                // modifica di una investigazione
      $investigationId = Request::getPOSTParam('invId');
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

      $path = '/caso?id='.$caseId.'&investigazione='.$investigationId;
      
      if($succ_scena && $succ_inv) {
        $path = $path.'&investigazioneOk=true';
      } else {
        $path = $path.'&investigazioneErrore=true';
      }

      return \Core\redirect($path);
    }
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
