<?php

namespace App\Models;

class Criminale {
  public $nome;
  public $cognome;
  public $descrizione;

  private $codice_fiscale;

  public function __construct(string $codice_fiscale, string $nome, string $cognome, string $descrizione) {
    $this->codice_fiscale = $codice_fiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
    $this->descrizione = $descrizione;
  }
}
