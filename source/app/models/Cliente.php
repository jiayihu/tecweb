<?php

namespace App\Models;

class Cliente {
  public $codice_fiscale;
  public $nome;
  public $cognome;
  public $citta;
  public $indirizzo;

  public function __construct(
    string $codice_fiscale,
    string $nome,
    string $cognome,
    string $citta = '',
    string $indirizzo = ''
  ) {
    $this->codice_fiscale = $codice_fiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
    $this->citta = $citta;
    $this->indirizzo = $indirizzo;
  }
}
