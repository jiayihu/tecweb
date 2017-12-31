<?php

namespace App\Models;

class Prova {
  public $nome;
  public $descrizione;
  public $locazione;

  private $codice;

  public function __construct(int $codice, string $nome, string $descrizione, string $locazione) {
    $this->codice = $codice;
    $this->nome = $nome;
    $this->descrizione = $descrizione;
    $this->locazione = $locazione;
  }
}
