<?php

namespace Core\Database;

use \Core\Logger;

class QueryBuilder {
  /**
   * Instance of the PDO
   *
   * @var \PDO
   */
  private $pdo;

  public function __construct($pdo) {
    $this->pdo = $pdo;
  }

  public function runQuery(string $query) {
    Logger::log($query);

    $statement = $this->pdo->prepare($query);
    $statement->execute();

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ);
  }

  public function selectAll(string $table) {
    $query = "select * from {$table}";

    Logger::log($query);

    $statement = $this->pdo->prepare($query);
    $statement->execute();

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ);
  }

  public function selectWhere(string $table, array $columns, string $where, array $parameters) {
    $query = \sprintf('select %s from %s where %s', \implode(', ', $columns), $table, $where);

    Logger::log($query);

    $statement = $this->pdo->prepare($query);
    $statement->execute($parameters);

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ); 
  }

  public function insert(string $table, array $parameters): bool {
    $columns = \implode(', ', array_keys($parameters));
    $placeholders = \implode(
      ', ',
      \array_map(function ($key) { return ":{$key}"; }, \array_keys($parameters))
    );
    $query = \sprintf('insert into %s (%s) values (%s)', $table, $columns, $placeholders);

    Logger::log($query);

    $statement = $this->pdo->prepare($query);
    return $statement->execute($parameters);
  }

  public function update(string $table, string $changes, string $where, array $parameters): bool {
    $query = \sprintf('update %s set %s where (%s)', $table, $changes, $where);
    Logger::log($query);
    
    $statement = $this->pdo->prepare($query);
    return $statement->execute($parameters);
  }

  public function delete(string $table, string $where, array $parameters): bool {
    $query = \sprintf('delete from %s where %s', $table, $where);
    Logger::log($query);

    $statement = $this->pdo->prepare($query);
    return $statement->execute($parameters);
  }
}
