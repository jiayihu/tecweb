<?php

namespace App\Models;

require_once 'app/models/Cliente.php';
require_once 'app/models/Criminale.php';
require_once 'app/models/Investigatore.php';
require_once 'app/models/Investigazione.php';
require_once 'app/models/Tag.php';

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

  public function getId(): int {
    return $this->codice;
  }

  public function getTotalHours() {
    $ore = 0;
    foreach($this->investigazioni as $investigazione) {
      $ore = $ore + $investigazione->oreTotali;
    }

    return $ore;
  }

  public function isArchived(): bool {
    return $this->passato;
  }

  public function isResolved(): bool {
    return $this->risolto;
  }

  public function addTag(Tag $tag) {
    \array_push($this->tags, $tag);
  }

  public function setResolved($status) {
    $this->risolto = $status;
  }

  public function setArchived($status) {
    $this->passato = $status;
    echo "aggiorno ".$status;
  }
}
