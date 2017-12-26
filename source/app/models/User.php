<?php

namespace App\Models;

class User {
  public $nome;
  public $cognome;

  private $codice_fiscale;

  public function __construct(string $codice_fiscale, string $nome, string $cognome) {
    $this->codice_fiscale = $codice_fiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
  }
}
