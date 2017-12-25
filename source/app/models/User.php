<?php

namespace App\Models;

class User {
  public $name;
  public $surname;

  private $ssn;

  public function __construct(string $ssn, string $name, string $surname) {
    $this->ssn = $ssn;
    $this->name = $name;
    $this->surname = $surname;
  }
}
