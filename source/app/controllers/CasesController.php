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

  public function editCase(array $parameters) {
    $table = 'caso';

    $caseId = $parameters['caseId'];
    $newNome = $parameters['newNome'];
    $newDescrizione = $parameters['newDescrizione'];
    $tipologia = $parameters['tipologia'];
    $cf_cliente = $parameters['cf_cliente'];
    $risolto = $parameters['risolto'];
    $passato = $parameters['passato'];

    $changes = '
      descrizione = :new_descrizione,
      nome = :new_nome,
      risolto = :risolto,
      tipologia = :tipologia,
      cliente = :cf_cliente,
      passato = :passato';
    $where = 'codice = :id_caso';

    return $this->database->update($table, $changes, $where, [
      ':new_nome' => $newNome,
      ':new_descrizione' => $newDescrizione,
      ':tipologia' => $tipologia,
      ':cf_cliente' => $cf_cliente,
      ':id_caso' => $caseId,
      ':risolto' => $risolto,
      ':passato' => $passato
    ]);
  }

  public function editCaseCriminal($caseId, $cf_criminale): bool {
    $table = 'risoluzione';
    $changes = 'cf_criminale = :new_cf_criminale';
    $where = 'caso = :id_caso';

    return $this->database->update($table, $changes, $where, [
      ':new_cf_criminale' => $cf_criminale,
      ':id_caso' => $caseId
    ]);
  }

  public function getAllCases() {
    $result = $this->database->runQuery('SELECT codice, nome FROM caso ORDER BY nome');
    return $result;
  }

  public function getCase($codice): Caso {
    $table = 'caso';
    $where='caso.codice = :codice_caso';
    $parameters[':codice_caso'] = $codice;
    $result = $this->database->selectWhere(
      $table,
      ['*'],
      $where,
      $parameters
    );

    return $this->createCaso($result[0]);
  }

  public function getCaseDetails($codice): Caso {
    $caso = $this->getCase($codice);
    
    $table = 'risoluzione, criminale';
    $where = 'risoluzione.caso = :id_caso AND risoluzione.criminale = criminale.codice_fiscale';
    $parameters[':id_caso'] = $codice;
    $result = $this->database->selectWhere(
      $table,
      ['*'],
      $where,
      $parameters
    );

    if(sizeof($result) > 0) {
      $caso->criminale = new Criminale($result[0]->criminale, $result[0]->nome, $result[0]->cognome);
    }

    $table = 'cliente, caso';
    $where = 'caso.codice = :id_caso AND caso.cliente = cliente.codice_fiscale';
    $parameters[':id_caso'] = $codice;
    $result = $this->database->selectWhere(
      $table,
      ['cliente.codice_fiscale, cliente.nome AS nome, cliente.cognome AS cognome'],
      $where,
      $parameters
    );

    $caso->cliente = new Cliente($result[0]->codice_fiscale, $result[0]->nome, $result[0]->cognome);
    return $caso;
  }

  public function getDetectives($codice): array {
    $table = 'lavoro, investigatore';
    $where = 'lavoro.caso = :id_caso AND investigatore.codice_fiscale = lavoro.investigatore ORDER BY nome';
    $parameters[':id_caso'] = $codice;
    $result = $this->database->selectWhere(
      $table,
      ['DISTINCT nome, cognome'],
      $where,
      $parameters
    );

    return $result;
  }

  public function getIspectorCases($cf_ispector) {
    $table = 'caso';
    $columns = [
      'caso.codice',
      'caso.nome'
    ];
    $where='caso.passato = :caso_passato AND caso.cliente = :cf_ispettore ORDER BY nome';
    $parameters[':caso_passato'] = 0;
    $parameters[':cf_ispettore'] = $cf_ispector;
    $result = $this->database->selectWhere(
      $table,
      $columns,
      $where,
      $parameters
    );

    return $result;
  }

  public function getPresentCases() {
    $table = 'caso';
    $columns = [
      'codice',
      'nome'
    ];
    $where='caso.passato = :caso_passato ORDER BY nome';
    $parameters[':caso_passato'] = 0;
    $result = $this->database->selectWhere(
      $table,
      $columns,
      $where,
      $parameters
    );
    return $result;
  }

  public function getTags($idcaso): array {
    $table = 'etichettamento, tag';
    $columns = [
      'nome',
      'slug'
    ];
    $where='etichettamento.caso = :id_caso AND etichettamento.tag = tag.slug ORDER BY nome';
    $parameters[':id_caso'] = $idcaso;
    $results = $this->database->selectWhere(
      $table,
      $columns,
      $where,
      $parameters
    );
    $tags = \array_map(function ($result) {
      return $this->createTag($result);
    }, $results);

    return $tags;
  }

  public function insertCase($nome, $tipo, $descrizione, $cliente): bool {
    $table = 'caso';
    $parameters[':nome_caso'] = $nome;
    $parameters[':tipo_caso'] = $tipo;
    $parameters[':cliente'] = $cliente;

    $conditions = [
      'nome = :nome_caso',
      'tipologia = :tipo_caso',
      'cliente = :cliente'
    ];

    $where = \implode(' AND ', $conditions);

    $exist = $this->database->selectWhere(
      $table,
      ['*'],
      $where,
      $parameters
    );

    if(sizeof($exist) == 0) {
      return $this->database->insert($table, [
        'codice' => "",
        'descrizione' => $descrizione,
        'nome' => $nome,
        'passato' => 0,
        'risolto' => 0,
        'tipologia' => $tipo,
        'cliente' => $cliente
      ]);
    } else {
      return false;
    }
  }

  public function insertCaseCriminal($caseId, $cf_criminale): bool {
    $table = 'risoluzione';

    return $this->database->insert( $table, [
      'criminale' => $cf_criminale,
      'caso' => $caseId
    ]);
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

  private function createTag($result): Tag {
    return new Tag(
      $result->slug,
      $result->nome
    );
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
}
