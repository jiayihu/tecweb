<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <?php if ($isEdit && !$investigationId && $role !== 'inspector'): ?>
    <form action="/caso" method="post">
      <dl class="case-info">
        <dt>Titolo</dt>
        <dd><input class="input" type="text" name="title" value="Uno scandalo in Boemia"></dd>
        <dt>Descrizione</dt>
        <dd><textarea name="descrizione">Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.</textarea></dd>
        <dt>Tipologia</dt>
        <dd>
        <select class="select" name="tariffa">
          <option value="furto">Furto</option>
          <option value="omicidio">Omicidio</option>
          <option value="ricatto">Ricatto</option>
          <option value="ricerca">Ricerca</option>
          <option value="spionaggio">Spionaggio</option>
        </select>
        </dd>
        <dt>Cliente</dt>
        <dd><input class="input" type="text" name="cliente" value="AMGSOU02T42U148D"></dd>
        <dt>Criminale</dt>
        <dd><input class="input" type="text" name="criminale" value="AMGSOU02T42U148D"></dd>
        <dt>Tag</dt>
        <dd>
          <ul class="tags list">
            <li class="list-item">
              <label class="tag">
                <input hidden type="checkbox" name="tags" value="annegamento" />
                <span class="tag-label">Annegamento</span>
              </label>
            </li>
            <li class="list-item">
              <label class="tag">
                <input hidden type="checkbox" name="tags" value="cellulare" />
                <span class="tag-label">Cellulare</span>
              </label>
            </li>
            <li class="list-item">
              <label class="tag">
                <input hidden type="checkbox" name="tags" value="sparatoia" />
                <span class="tag-label">Sparatoia</span>
              </label>
            </li>
            <li class="list-item">
              <label class="tag">
                <input hidden type="checkbox" name="tags" value="terrorismo" />
                <span class="tag-label">Terrorismo</span>
              </label>
            </li>
          </ul>
        </dd>
      </dl>
      <hr />
      <p class="center">
        <button type="submit" class="btn btn-outline">Salva le modifiche</button>
      </p>
    </form>
    <?php else : ?>
    <h1 class="page-title">
      <?= $selectcase->nome ?>
      <?php if($selectcase->isResolved()) : ?>
        <span class="status status-resolved" title="Risolto"></span>
        <span class="sr-only">Risolto</span>
      <?php elseif($selectcase->isArchived()) : ?>
        <span class="status status-archived" title="Archiviato"></span>
        <span class="sr-only">Archiviato</span>
      <?php else : ?>
        <span class="status status-progress" title="In corso"></span>
        <span class="sr-only">In corso</span>
      <?php endif; ?>
    </h1>
    <dl class="case-info">
      <dt>Descrizione</dt>
      <dd><?= $selectcase->descrizione ?></dd>
      <dt>Tipologia</dt>
      <dd><?= ucfirst($selectcase->tipologia) ?></dd>
      <dt>Cliente</dt>
      <dd>
        <?= $selectcase->cliente->getCodice() ?> <br>
        <?= $selectcase->cliente->nome ?>
        <?= $selectcase->cliente->cognome ?>
      </dd>
      <dt>Criminale</dt>
      <dd>
        <?php 
          if($selectcase->isResolved()) {
            echo $selectcase->criminale->getCodice().'<br';
            echo $selectcase->criminale->nome;
            echo $selectcase->criminale->cognome;
          } else {
            echo '-';
          }
        ?>
      </dd>
      <dt>Investigatori</dt>
      <dd>
        <ul class="list">
          <?php
            if(sizeof($detectives) == 0) {
              echo '-';
            } else {
              foreach($detectives as $detective) {
                echo '<li>';
                echo $detective->nome;
                echo $detective->cognome;
                echo '</li>';
              }
            }
          ?>
        </ul>
      </dd>
      <?php if($role !== 'inspector') : ?>           <!-- Visibile solo agli investigatori e admin -->
        <dt>Ore totali di investigazione</dt> 
        <dd><?= $selectcase->getTotalHours() ?></dd>
      <?php endif; ?>

      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <?php if(sizeof($selectcase->tags) == 0) : ?>
            -
        <?php else: ?>
          <?php foreach($selectcase->tags as $tag) : ?>
            <li class="list-item"><span class="tag-label"><?= $tag->nome ?></span></li>
          <?php endforeach; ?>
          <?php endif; ?>
      </dd>
    </dl>
    
    <?php if ($role !== 'inspector'): ?>
    <hr />
    <p class="center">
      <a class="btn btn-outline" href="/caso?id=1&modifica=true">Modifica i dati</a>
    </p>
    <?php endif; ?>

    <?php endif; ?>
  </aside>
  <section class="main-content">
    <h2>Investigazioni del caso</h2>
    <?php if(sizeof($investigations) == 0) : ?>
      <p> Nessuna investigazione disponibile.
    <?php else : ?>
      <?php foreach ($investigations as $index => $investigation) : ?>
        <?php require 'partials/investigation.partial.php' ?>
      <?php endforeach; ?>
    <?php endif; ?>
  </section>
</main>
