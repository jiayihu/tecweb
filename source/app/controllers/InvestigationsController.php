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

  public function searchInvestigations(array $parameters) {
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

  private function createInvestigazione($result) {
    $investigatore = new Investigatore($result->investigatore_codice_fiscale, $result->investigatore_nome, $result->investigatore_cognome);
    $scena = new Scena($result->scena_nome, $result->scena_descrizione, $result->citta, $result->indirizzo);

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
