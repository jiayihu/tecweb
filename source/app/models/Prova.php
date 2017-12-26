<?php

namespace App\Models;

class Prova {
  public $nome;
  public $descrizione;

  private $codice;

  public function __construct(int $codice, string $nome, string $descrizione) {
    $this->codice = $codice;
    $this->nome = $nome;
    $this->descrizione = $descrizione;
  }
}
