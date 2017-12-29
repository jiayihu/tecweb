<?php

namespace App\Controllers;

use \App\Models\Investigazione;

require_once 'app/models/Investigazione.php';

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

    $tables = ['investigazione'];
    $conditions = [];
    $parameters = [];

    if ($searchText) {
      \array_push($conditions, 'investigazione.rapporto LIKE CONCAT(\'%\', :search_text, \'%\')');
      $parameters[':search_text'] = $searchText;
    }
    if ($investigatoreCodiceFiscale) {
      \array_push($tables, 'lavoro');
      \array_unshift($conditions, '
        investigazione.caso = lavoro.caso
        AND investigazione.numero = lavoro.investigazione'
      );
      \array_push($conditions, 'lavoro.investigatore = :investigatore_codice_fiscale');
      $parameters[':investigatore_codice_fiscale'] = $investigatoreCodiceFiscale;
    }
    if ($scena) {
      \array_push($tables, 'scena_investigazione');
      \array_unshift($conditions, '
        investigazione.caso = scena.caso
        AND investigazione.numero = scena.investigazione'
      );
      \array_push($conditions, '
        (scena.citta LIKE CONCAT(\'%\', :scena, \'%\')
        OR scena.indirizzo LIKE CONCAT(\'%\', :scena, \'%\'))
      ');
      $parameters[':scena'] = $scena;
    }
    if ($dateFrom) {
      \array_push($conditions, 'investigazione.data_inizio = :data_inizio');
      $parameters[':data_inizio'] = \date_format($dateFrom, 'Y-m-d');
    }
    if ($dateTo) {
      \array_push($conditions, 'investigazione.data_termine = :data_termine');
      $parameters[':data_termine'] = \date_format($dateTo, 'Y-m-d');
    }

    $where = \implode(' AND ', $conditions);
    $results = $this->database->selectWhere(
      \implode(', ', $tables),
      ['*'],
      $where,
      $parameters
    );
    $investigations = \array_map(function ($result) {
      return $this->createInvestigazione($result);
    }, $results);

    return $investigations;
  }

  private function createInvestigazione($result) {
    return new Investigazione(
      $result->numero,
      $result->caso,
      $result->data_inizio,
      $result->data_termine,
      $result->rapporto,
      $result->ore_totali
    );
  }
}
