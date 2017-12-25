<?php

namespace App\Controllers;
use App\Models\Task;

require_once 'app/models/Task.php';

/**
 * Old: da aggiornare per il progetto Tecweb
 */

class UsersController {
  /**
   * QueryBuilder instance
   * 
   * @var \Core\Database\QueryBuilder
   */
  private $database;

  public function __construct() {
    $this->database = \Core\App::get('database');
  }

  public function index() {
    $tasks = $this->fetchAllTasks();
    $tasks[0]->complete();
    
    return \Core\view('tasks', ['tasks' => $tasks]);
  }

  public function getTasksTemplate() {
    $tasks = $this->fetchAllTasks();
    $tasks[0]->complete();
    
    \ob_start();
    \Core\view('tasks', ['tasks' => $tasks]);
    $template = \ob_get_clean();

    return $template;
  }

  private function fetchAllTasks() {
    $results = $this->database->selectAll('todos');
    
    $tasks = \array_map(function($result) {
      return new Task($result->description);
    }, $results);
  
    return $tasks;
  }
}
