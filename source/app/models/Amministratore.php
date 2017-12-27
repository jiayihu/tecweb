<?php

namespace App\Models;

require_once 'app/models/User.php';

class Amministratore extends User {
  public function __construct(string $codice_fiscale, string $nome, string $cognome) {
    $this->codice_fiscale = $codice_fiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
  }
}
