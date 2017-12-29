<?php

namespace App\Models;

class Tag {
  public $nome;
  public $descrizione;

  private $slug;

  public function __construct(string $slug, string $nome = '', string $descrizione = null) {
    $this->slug = $slug;
    $this->nome = $nome;
    $this->descrizione = $descrizione;
  }

  public function getSlug(): string {
    return $this->slug;
  }
}
