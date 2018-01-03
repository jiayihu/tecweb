<?php

namespace App\Controllers;

use \App\Models\Investigazione;
use \App\Models\Investigatore;
use \App\Models\Scena;
use \App\Models\Prova;

require_once 'app/models/Investigazione.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Scena.php';
require_once 'app/models/Prova.php';

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

  public function getInvestigations($idcaso) {
    $investigations = $this->getInvestigationsDetails($idcaso);

    foreach ($investigations as $investigation) {
      $prove = $this->getProve($investigation->getCaseId(), $investigation->getId());
      $investigation->prove = $prove;
    }

    return $investigations;
  }

  public function insertInvestigation($idcaso, $cf_investigatore) {
    $parameters[':idcaso'] = $idcaso;
    $parameters[':cf_investigatore'] = $cf_investigatore;

    $num_inv = $this->getNumInv($idcaso) + 1;

    $table = 'investigazione';

    $this->database->insert($table, [
      'numero' => $num_inv,
      'caso' => $idcaso,
      'data_inizio' => date('Y-m-d'),
      'data_termine' => null,
      'rapporto' => '',
      'ore_totali' => 0
    ]);

    $table = 'lavoro';

    $this->database->insert($table, [
      'investigatore' => $cf_investigatore,
      'investigazione' => $num_inv,
      'caso' => $idcaso,
      'ore_lavoro' => 0
    ]);
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

    if($result == null)
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

  private function getProve($idcase, $investigation) {
    $parameters[':id_caso'] = $idcase;
    $parameters[':investigazione'] = $investigation;
    $columns = [
      'nome',
      'codice',
      'locazione',
      'descrizione'
    ];

    $conditions = [
      'prova.caso = :id_caso',
      'prova.investigazione = :investigazione'
    ];

    $where = \implode(' AND ', $conditions);
    $where . " order by nome";

    $results = $this->database->selectWhere(
      'prova',
      $columns,
      $where,
      $parameters
    );

    $prove = \array_map(function ($result) {
      return $this->createProva($result);
    }, $results);

    return $prove;
  }

  private function createProva($result): Prova {
    return new Prova(
      $result->codice,
      $result->nome,
      $result->descrizione,
      $result->locazione
    );
  }

  private function createInvestigazione($result): Investigazione {
    $investigatore = new Investigatore($result->investigatore_codice_fiscale, $result->investigatore_nome, $result->investigatore_cognome);

    if($result->scena_nome == null) {
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
