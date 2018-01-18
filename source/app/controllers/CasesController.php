<?php

namespace App\Controllers;

use \App\Models\Caso;
use \App\Models\Cliente;
use \App\Models\Criminale;
use \App\Models\Tag;

require_once 'app/models/Caso.php';
require_once 'app/models/Cliente.php';
require_once 'app/models/Criminale.php';
require_once 'app/models/Tag.php';

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

  public function searchCases(array $parameters): array {
    if (\Core\isArrayEmpty($parameters)) {
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
      \array_push($conditions, '
        (caso.nome LIKE CONCAT(\'%\', :search_text, \'%\') 
        OR caso.descrizione LIKE CONCAT(\'%\', :search_text, \'%\'))'
      );
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
    $cases = \array_map(function ($result) {
      return $this->createCaso($result);
    }, $results);
    $cases = $this->mergeCases($cases);

    return $cases;
  }

  public function getCases() {
    $table = 'caso';
    $where='caso.passato = :caso_passato order by nome';
    $parameters[':caso_passato'] = 0;
    $result = $this->database->selectWhere(
      $table,
      ['nome'],
      $where,
      $parameters
    );
    return $result;
  }

  public function getCase($name) {
    $table = 'caso';
    $where='caso.nome = :nome_caso';
    $parameters[':nome_caso'] = $name;
    $result = $this->database->selectWhere(
      $table,
      ['*'],
      $where,
      $parameters
    );

    return $result;
  }

  private function createCaso($result): Caso {
    return new Caso(
      $result->codice,
      $result->passato,
      $result->risolto,
      $result->nome,
      $result->descrizione,
      $result->tipologia
    );
  }

  /**
   * Merges rows which are the same case but with different tags
   *
   * @param array $cases
   * @return void
   */
  private function mergeCases(array $cases): array {
    return \array_reduce($cases, function (array $merged, Caso $case) {
      $caseId = (string) $case->getId();

      if (\array_key_exists($caseId, $merged)) {
        foreach ($case->tags as $tag) {
          $merged[$caseId]->addTag($tag);
        }
      } else {
        $merged[$caseId] = $case;
      }

      return $merged;
    }, []);
  }

  public function addCriminale(array $parameters){
    $codiceFiscale = $parameters['codice_fiscale'];
    $nome=$parameters['nome'];
    $cognome=$parameters['cognome'];

    return $this->database->insert('criminale', [
      'codice_fiscale' => $codiceFiscale,
      'nome' => $nome,
      'cognome' => $cognome,
    ]);
  }
}
