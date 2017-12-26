<?php

namespace App\Models;

class Scena {
  public $nome;
  public $descrizione;
  public $citta;
  public $indirizzo;

  public function __construct(string $nome, string $descrizione, string $citta, string $indirizzo) {
    $this->nome = $nome;
    $this->descrizione = $descrizione;
    $this->citta = $citta;
    $this->indirizzo = $indirizzo;
  }
}
