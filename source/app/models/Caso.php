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

  private $codice;
  private $passato;
  private $risolto;
  
  public function __construct(
    int $codice,
    bool $passato,
    bool $risolto,
    string $nome,
    string $descrizione,
    string $tipologia,
    Cliente $cliente = null,

    Criminale $criminale = null,
    array $tags = [],
    array $investigazioni = []
  ) {
    $this->codice = $codice;
    $this->passato = $passato;
    $this->risolto = $risolto;
    $this->nome = $nome;
    $this->descrizione = $descrizione;
    $this->tipologia = $tipologia;
    $this->cliente = $cliente;

    $this->criminale = $criminale;
    $this->tags = $tags;
    $this->investigazioni = $investigazioni;
  }

  public function getId() {
    return $this->codice;
  }

  public function getTotalHours() {
    // ...
  }

  public function getDetectives() {
    // ...
  }
}
