<?php

namespace App\Controllers;

use \App\Models\Tag;

require_once 'app/models/Tag.php';

class TagsController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  public function __construct() {
    $this->database = \Core\App::get('database');
  }

  public function getTags() {
    $results = $this->database->selectAll('tag');

    if (!$results) return [];

    return \array_map(function ($result) {
      return new Tag($result->slug, $result->nome, $result->descrizione);
    }, $results);
  }
}
