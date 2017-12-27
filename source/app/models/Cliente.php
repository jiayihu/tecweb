<?php

namespace App\Models;

require_once 'app/models/User.php';

class Cliente extends User {
  public $nome;
  public $cognome;
  public $citta;
  public $indirizzo;

  private $codiceFiscale;

  public function __construct(
    string $codiceFiscale,
    string $nome,
    string $cognome,
    string $citta = '',
    string $indirizzo = ''
  ) {
    $this->codiceFiscale = $codiceFiscale;
    $this->nome = $nome;
    $this->cognome = $cognome;
    $this->citta = $citta;
    $this->indirizzo = $indirizzo;
  }
}
