<?php

namespace App\Controllers;

use \App\Models\Investigazione;
use \App\Models\Investigatore;
use \App\Models\Scena;

require_once 'app/models/Investigazione.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Scena.php';

class InvestigationsController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  public function __construct() {
    $this->database = \Core\App::get('database');
  }

  private function deleteScena(int $id_caso, string $id_investigazione): bool {
    $table = 'scena_investigazione';
    $where = "investigazione = ::id_investigazione AND caso = :id_caso";

     return $this->database->delete($table, $where, [
      ':id_caso' => $id_caso,
      ':id_investigazione' => $id_investigazione
    ]);
  }

  public function editInvestigation(array $param): bool {
    $caseId = $param['caseId'];
    $investigationId = $param['investigationId'];
    $investigatore = $param['investigatore'];
    $date_to = $param['date_to'];
    $rapporto = $param['rapporto'];
    $ore = $param['ore'];

    $where = 'numero = :numero AND caso = :id_caso';   
    $changes = '
      data_termine = :data_termine,
      rapporto = :rapporto';
    $table = 'investigazione';   
    $update_investigazione = $this->database->update($table, $changes, $where, [
      ':numero' => $investigationId,
      ':id_caso' => $caseId,
      ':data_termine' => $date_to,
      ':rapporto' => $rapporto
    ]);

    $where = 'investigazione = :numero AND caso = :id_caso AND investigatore = :investigatore';   
    $changes = '
      ore_lavoro = :ore_lavoro';
    $table = 'lavoro';   
    $update_lavoro = $this->database->update($table, $changes, $where, [
      ':numero' => $investigationId,
      ':id_caso' => $caseId,
      ':investigatore' => $investigatore,
      'ore_lavoro' => $ore
    ]);

    if ($update_lavoro && $update_investigazione)
      return true;

    return false;
  }

  public function editScena(array $param): bool {
    $caseId = $param['caseId'];
    $investigationId = $param['investigationId'];
    $nome = $param['nome'];
    $descrizione = $param['descrizione'];
    $indirizzo = $param['indirizzo'];
    $citta = $param['citta'];

    $scena = new Scena($nome, $descrizione, $indirizzo, $citta);
    $slug = $scena->createSlug();
    $slug = $slug.'-'.$caseId.'-'.$investigationId;

    $parameters[':id_caso'] = $caseId;
    $parameters[':id_investigazione'] = $investigationId;
    $where = 'caso = :id_caso AND investigazione = :id_investigazione';
    $exist = $this->database->selectWhere(  // controlla se esiste già una scena per l'investigazione
      'scena_investigazione',
      ['*'],
      $where,
      $parameters
    );

    if ($exist !== null) {
      if ($exist[0]->slug === $slug) {    // stesso slug, aggiorna descrizione, indirizzo e città
        $where = 'slug = :slug';   
        $changes = '
          descrizione = :descrizione,
          citta = :citta,
          indirizzo = :indirizzo';
        $table = 'scena_investigazione';   
        return $this->database->update($table, $changes, $where, [
          ':descrizione' => $descrizione,
          ':indirizzo' => $indirizzo,
          ':citta' => $citta,
          ':slug' => $slug
        ]);       
      } else {                          // nome diverso (primary key), elimina vecchia scena e ne crea una nuova
        $delete = $this->deleteScena($caseId, $investigationId);
        $insert = $this->insertScena($slug, $caseId, $investigationId, $scena);

        if ($delete & $insert)
          return true;

        return false;
      }
    } else {                            // non esiste nessuna scena, ne crea una nuova
      return $this->insertScena($slug, $caseId, $investigationId, $scena);
    }
  }

  public function getInvestigations(int $idcaso): array {
    return $this->getInvestigationsDetails($idcaso);
  }

  private function insertScena(string $slug, int $id_caso, string $id_investigazione, Scena $scena) {
    $table = 'scena_investigazione';

    $this->database->insert($table, [
      'slug' => $slug,
      'nome' => $scena->nome,
      'descrizione' => $scena->descrizione,
      'citta' => $scena->citta,
      'indirizzo' => $scena->indirizzo,
      'investigazione' => $id_investigazione,
      'caso' => $id_caso
    ]);
  }
 
  public function insertInvestigation(int $idcaso, string $cf_investigatore) {
    $parameters[':idcaso'] = $idcaso;
    $parameters[':cf_investigatore'] = $cf_investigatore;

    $num_inv = $this->getNumInv($idcaso) + 1;

    $table = 'investigazione';

    $ins1 = $this->database->insert($table, [
      'numero' => $num_inv,
      'caso' => $idcaso,
      'data_inizio' => date('Y-m-d'),
      'data_termine' => null,
      'rapporto' => '',
      'ore_totali' => 0
    ]);

    $table = 'lavoro';

    $ins2 = $this->database->insert($table, [
      'investigatore' => $cf_investigatore,
      'investigazione' => $num_inv,
      'caso' => $idcaso,
      'ore_lavoro' => 0
    ]);

    if ($ins1 && $ins2) 
      return true;

    return false;
  }

  public function searchInvestigations(array $parameters): array {
    if (\Core\isArrayEmpty($parameters)) {
      throw new \Exception('emptySearch');
    }

    $searchText = $parameters['searchText'];
    $investigatoreCodiceFiscale = $parameters['investigatoreCodiceFiscale'];
    $scena = $parameters['scena'];
    $dateFrom = $parameters['dateFrom'];
    $dateTo = $parameters['dateTo'];

    $tables = ['investigazione', 'lavoro', 'investigatore', 'scena_investigazione'];
    $conditions = [
      'investigazione.caso = lavoro.caso AND investigazione.numero = lavoro.investigazione',
      'lavoro.investigatore = investigatore.codice_fiscale',
      'investigazione.caso = scena_investigazione.caso AND investigazione.numero = scena_investigazione.investigazione'
    ];
    $parameters = [];

    if ($searchText) {
      \array_push($conditions, 'investigazione.rapporto LIKE CONCAT(\'%\', :search_text, \'%\')');
      $parameters[':search_text'] = $searchText;
    }
    if ($investigatoreCodiceFiscale) {
      \array_push($conditions, 'lavoro.investigatore = :investigatore_codice_fiscale');
      $parameters[':investigatore_codice_fiscale'] = $investigatoreCodiceFiscale;
    }
    if ($scena) {
      \array_push($conditions, '
        (scena_investigazione.citta LIKE CONCAT(\'%\', :scena, \'%\')
        OR scena_investigazione.indirizzo LIKE CONCAT(\'%\', :scena, \'%\'))
      ');
      $parameters[':scena'] = $scena;
    }
    if ($dateFrom) {
      \array_push($conditions, 'investigazione.data_inizio >= :data_inizio');
      $parameters[':data_inizio'] = \date_format($dateFrom, 'Y-m-d');
    }
    if ($dateTo) {
      \array_push($conditions, 'investigazione.data_termine <= :data_termine');
      $parameters[':data_termine'] = \date_format($dateTo, 'Y-m-d');
    }

    $columns = [
      'investigazione.numero, investigazione.caso',
      'investigazione.data_inizio',
      'investigazione.data_termine',
      'investigazione.rapporto',
      'investigazione.ore_totali',
      'investigatore.codice_fiscale AS investigatore_codice_fiscale',
      'investigatore.nome AS investigatore_nome',
      'investigatore.cognome AS investigatore_cognome',
      'scena_investigazione.nome AS scena_nome',
      'scena_investigazione.descrizione AS scena_descrizione',
      'scena_investigazione.citta',
      'scena_investigazione.indirizzo'
    ];
    $where = \implode(' AND ', $conditions);
    $results = $this->database->selectWhere(
      \implode(', ', $tables),
      $columns,
      $where,
      $parameters
    );
    $investigations = \array_map(function ($result) {
      return $this->createInvestigazione($result);
    }, $results);

    return $investigations;
  }

  private function getNumInv($idcaso): int {
    $columns = ['max(numero) as max_num'];
    $parameters[':id_caso'] = $idcaso;
    $where = 'caso = :id_caso';

    $result = $this->database->selectWhere(
      'investigazione',
      $columns,
      $where,
      $parameters
    );

    if ($result === null)
      return 0;
    else
      return intval($result[0]->max_num);
  }

  private function getInvestigationsDetails($id) {
    $columns = [
      'investigazione.numero, investigazione.caso',
      'investigazione.data_inizio',
      'investigazione.data_termine',
      'investigazione.rapporto',
      'investigazione.ore_totali',
      'investigatore.codice_fiscale AS investigatore_codice_fiscale',
      'investigatore.nome AS investigatore_nome',
      'investigatore.cognome AS investigatore_cognome',
      'scena_investigazione.nome AS scena_nome',
      'scena_investigazione.descrizione AS scena_descrizione',
      'scena_investigazione.citta',
      'scena_investigazione.indirizzo'
    ];
    $parameters[':id_caso'] = $id;

    $tables = 'investigazione JOIN lavoro ON investigazione.numero = lavoro.investigazione AND investigazione.caso = lavoro.caso JOIN investigatore ON investigatore.codice_fiscale = lavoro.investigatore LEFT JOIN scena_investigazione ON scena_investigazione.caso = investigazione.caso AND scena_investigazione.investigazione = investigazione.numero';

    $where = 'investigazione.caso = :id_caso ORDER BY investigazione.numero DESC'; 

    $results = $this->database->selectWhere(
      $tables,
      $columns,
      $where,
      $parameters
    );

    $investigations = \array_map(function ($result) {
      return $this->createInvestigazione($result);
    }, $results);

    return $investigations;
  }

  private function createInvestigazione($result): Investigazione {
    $investigatore = new Investigatore($result->investigatore_codice_fiscale, $result->investigatore_nome, $result->investigatore_cognome);

    if ($result->scena_nome === null) {
      $scena = null;
    } else {
      $scena = new Scena($result->scena_nome, $result->scena_descrizione, $result->citta, $result->indirizzo);
    }

    return new Investigazione(
      $result->numero,
      $result->caso,
      $result->data_inizio,
      $result->data_termine,
      $result->rapporto,
      $result->ore_totali,
      $investigatore,
      $scena
    );
  }
}
