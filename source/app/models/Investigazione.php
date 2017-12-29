<?php

namespace App\Models;

require_once 'app/models/Scena.php';

class Investigazione {
  public $dataInizio;
  public $dataTermine;
  public $rapporto;
  public $oreTotali;

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

    Scena $scena = null,
    array $prove = []
    ) {
    $this->id = $id;
    $this->caso = $caso;
    $this->dataInizio = $dataInizio;
    $this->dataTermine = $dataTermine;
    $this->rapporto = $rapporto;
    $this->oreTotali = $oreTotali;
    
    $this->scena = $scena;
    $this->prove = $prove;
  }

  public function getId() {
    return $this->id;
  }

  public function getCaseId() {
    return $this->caso;
  }
}
