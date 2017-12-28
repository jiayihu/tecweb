<?php

namespace Core\Database;

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
    $statement = $this->pdo->prepare($query);
    $statement->execute();

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ);
  }

  public function selectAll(string $table) {
    $statement = $this->pdo->prepare("select * from {$table}");
    $statement->execute();

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ);
  }

  public function selectWhere(string $table, array $columns, string $where, array $parameters) {
    $query = \sprintf('select %s from %s where %s', \implode(', ', $columns), $table, $where);
    $statement = $this->pdo->prepare($query);
    $statement->execute($parameters);

    if (!$statement) return null;
    
    return $statement->fetchAll(\PDO::FETCH_OBJ); 
  }

  public function insert(string $table, array $parameters) {
    $columns = \implode(', ', array_keys($parameters));
    $placeholders = \implode(
      ', ',
      \array_map(function ($key) { return ":{$key}"; }, \array_keys($parameters))
    );
    $query = \sprintf('insert into %s (%s) values (%s)', $table, $columns, $placeholders);

    $statement = $this->pdo->prepare($query);
    return $statement->execute($parameters);
  }

  public function update(string $table, string $changes, string $where, array $parameters) {
    $query = \sprintf('update %s set %s where (%s)', $table, $changes, $where);

    $statement = $this->pdo->prepare($query);
    return $statement->execute($parameters);
  }

  public function delete(string $table, $where, array $parameters) {
    $query = \sprintf('delete from %s where %s', $table, $where);
    $statement = $this->pdo->prepare($query);

    return $statement->execute($parameters);
  }
}
