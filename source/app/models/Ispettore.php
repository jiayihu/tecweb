<?php

namespace App\Models;

require_once 'app/models/User.php';

class Ispettore extends User {
  public $codiceDistretto;

  public function __construct(string $codice_fiscale, string $nome, string $cognome, int $codiceDistretto = 0) {
    $this->codice_fiscale = $codice_fiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
    $this->codiceDistretto = $codiceDistretto;
  }
}
