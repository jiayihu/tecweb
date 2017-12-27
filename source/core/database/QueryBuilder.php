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

  public function selectAll(string $table) {
    $statement = $this->pdo->prepare("select * from {$table};");
    $statement->execute();
    
    $results = $statement->fetchAll(\PDO::FETCH_OBJ);

    return $results;
  }

  public function selectWhere(array $columns, string $table, string $where, array $parameters) {
    $query = \sprintf('select %s from %s where %s;', \implode(', ', $columns), $table, $where);
    $statement = $this->pdo->prepare($query);
    $statement->execute($parameters);
    
    return $statement->fetchAll(\PDO::FETCH_OBJ); 
  }

  public function insert(string $table, array $parameters) {
    $columns = \implode(', ', array_keys($parameters));
    $placeholders = \implode(
      ', ',
      \array_map(function ($key) { return ":{$key}"; }, \array_keys($parameters))
    );
    $query = \sprintf('insert into %s (%s) values (%s)', $table, $placeholders);

    $statement = $this->pdo->prepare($sql);
    $statement->execute($parameters);
  }
}
