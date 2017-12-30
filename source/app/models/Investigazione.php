<?php

namespace App\Models;

require_once 'app/models/Scena.php';
require_once 'app/models/Investigatore.php';

class Investigazione {
  public $dataInizio;
  public $dataTermine;
  public $rapporto;
  public $oreTotali;

  public $investigatore;
  public $scena;
  public $prove;

  private $id;
  private $caso;

  public function __construct(
    int $id,
    int $caso,
    string $dataInizio,
    string $dataTermine,
    string $rapporto,
    int $oreTotali = 0,

    Investigatore $investigatore = null,
    Scena $scena = null,
    array $prove = []
    ) {
    $this->id = $id;
    $this->caso = $caso;
    $this->dataInizio = $dataInizio;
    $this->dataTermine = $dataTermine;
    $this->rapporto = $rapporto;
    $this->oreTotali = $oreTotali;
    
    $this->investigatore = $investigatore;
    $this->scena = $scena;
    $this->prove = $prove;
  }

  public function getId(): int {
    return $this->id;
  }

  public function getCaseId(): int {
    return $this->caso;
  }

  public function getInvestigatore(): string {
    return $this->investigatore->nome . ' ' . $this->investigatore->cognome;
  }

  public function getScene(): string {
    return $this->scena->citta . ', ' . $this->scena->indirizzo;
  }
}
