<?php

namespace App\Models;

class Cliente {
  public $nome;
  public $cognome;
  public $citta;
  public $indirizzo;

  private $codice_fiscale;

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

  public function getCodice(): string {
    return $this->codice_fiscale;
  }
}
