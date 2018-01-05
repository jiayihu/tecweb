<?php

namespace App\Models;

class Scena {
  public $nome;
  public $descrizione;
  public $citta;
  public $indirizzo;

  public function __construct(string $nome = null, string $descrizione = null, string $citta = null, string $indirizzo = null) {
    $this->nome = $nome;
    $this->descrizione = $descrizione;
    $this->citta = $citta;
    $this->indirizzo = $indirizzo;
  }

  public function createSlug(): string {
    return preg_replace('/[^A-Za-z0-9-]+/', '-', $this->nome);
  }
}
