<?php

namespace App\Controllers;

use \App\Models\Caso;
use \App\Models\Cliente;
use \App\Models\Criminale;

require_once 'app/models/Caso.php';
require_once 'app/models/Cliente.php';
require_once 'app/models/Criminale.php';

class CasesController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  public function __construct() {
    $this->database = \Core\App::get('database');
  }

  public function searchCases(array $parameters) {
    if ($this->isEmpty($parameters)) {
      throw new \Exception('emptySearch');
    }

    $searchText = $parameters['searchText'];
    $clienteCodiceFiscale = $parameters['clienteCodiceFiscale'];
    $criminaleCodiceFiscale = $parameters['criminaleCodiceFiscale'];
    $tipologia = $parameters['tipologia'];
    $tags = $parameters['tags'];

    $tables = ['caso'];
    $conditions = [];
    $parameters = [];

    if ($searchText) {
      \array_push($conditions, 'caso.nome LIKE CONCAT(\'%\', :search_text, \'%\')');
      $parameters[':search_text'] = $searchText;
    }
    if ($clienteCodiceFiscale) {
      \array_push($conditions, 'caso.cliente = :cliente_codice_fiscale');
      $parameters[':cliente_codice_fiscale'] = $clienteCodiceFiscale;
    }
    if ($criminaleCodiceFiscale) {
      \array_push($tables, 'risoluzione');
      \array_unshift($conditions, 'caso.codice = risoluzione.caso');
      \array_push($conditions, 'risoluzione.criminale = :criminale_codice_fiscale');
      $parameters[':criminale_codice_fiscale'] = $criminaleCodiceFiscale;
    }
    if ($tipologia) {
      \array_push($conditions, 'caso.tipologia = :tipologia');
      $parameters[':tipologia'] = $tipologia;
    }
    if ($tags && \count($tags) > 0) {
      \array_push($tables, 'etichettamento');
      \array_unshift($conditions, 'caso.codice = etichettamento.caso');
      $tagsQuery = \implode(
        ' OR ',
        \array_map(function($tag) {
          return "etichettamento.tag = '{$tag}'";
        }, $tags)
      );
      $tagsConditions = \sprintf('(%s)', $tagsQuery);
      \array_push($conditions, $tagsConditions);
    }

    $where = \implode(' AND ', $conditions);
    $results = $this->database->selectWhere(
      \implode(', ', $tables),
      ['*'],
      $where,
      $parameters
    );
    $cases = \array_map(function ($result) use ($clienteCodiceFiscale, $criminaleCodiceFiscale) {
      $cliente = $clienteCodiceFiscale ? new Cliente() : null;
      $criminale = $criminaleCodiceFiscale ? new Criminale() : null;

      return new Caso(
        $result->codice,
        $result->passato,
        $result->risolto,
        $result->nome,
        $result->descrizione,
        $result->tipologia
      );
    }, $results);

    return $cases;
  }

  private function isEmpty(array $values) {
    $notNullValues = \array_filter(\array_values($values), function ($value) {
      return !empty($value);
    });

    return \count($notNullValues) === 0;
  }
}
