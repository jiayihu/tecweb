<?php

namespace App\Models;

class Criminale {
  public $nome;
  public $cognome;
  public $descrizione;

  private $codiceFiscale;

  public function __construct(string $codiceFiscale, string $nome, string $cognome, string $descrizione) {
    $this->codiceFiscale = $codiceFiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
    $this->descrizione = $descrizione;
  }
}
