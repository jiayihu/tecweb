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

  public function __construct(
    int $id,
    string $dataInizio,
    string $dataTermine,
    string $rapporto,
    Scena $scena,
    Scena $prove,
    int $oreTotali,
    ) {
    $this->id = $id;
    $this->dataInizio = $dataInizio;
    $this->dataTermine = $dataTermine;
    $this->rapporto = $rapporto;
    $this->scena = $scena;
    $this->prove = $prove;
    $this->oreTotali = $oreTotali;
  }
}
