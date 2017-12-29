<?php

namespace App\Models;

class Tag {
  public $nome;
  public $descrizione;

  private $slug;

  public function __construct(int $slug, string $nome = '', string $descrizione = '') {
    $this->slug = $slug;
    $this->nome = $nome;
    $this->descrizione = $descrizione;
  }
}
