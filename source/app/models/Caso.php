<?php

namespace App\Models;

require_once 'app/models/Cliente.php';
require_once 'app/models/Criminale.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Investigazione.php';

class Caso {
  public $nome;
  public $descrizione;
  public $tipologia;
  public $cliente;
  public $criminale;
  public $tags;
  public $investigazioni;

  private $id;
  private $risolto;
  
  public function __construct(
    int $id,
    string $nome,
    string $descrizione,
    string $tipologia,
    Cliente $cliente,
    Criminale $criminale,
    array $tags,
    array $investigazioni,
    bool $risolto
  ) {
    $this->id = $id;
    $this->nome = $codice_fiscale;
    $this->descrizione = $descrizione;
    $this->tipologia = $tipologia;
    $this->cliente = $cliente;
    $this->criminale = $criminale;
    $this->tags = $tags;
    $this->investigazioni = $investigazioni;
    $this->risolto = $risolto;
  }

  public function getTotalHours() {
    // ...
  }

  public function getDetectives() {
    // ...
  }
}
