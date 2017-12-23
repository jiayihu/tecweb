<?php

namespace App\Models;

/**
 * Old: da aggiornare per il progetto Tecweb
 */

class Task {
  public $description;
  private $completed = false;

  public function __construct($description) {
    $this->description = $description;
  }

  public function isComplete() {
    return $this->completed;
  }

  public function complete() {
    $this->completed = true;
  }
}
