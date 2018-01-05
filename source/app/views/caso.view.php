<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <?php if ($isEdit && !$investigationId && $role !== 'inspector'): ?>
    <form action="/caso" method="post">
      <input type="hidden" name="caseId" value="<?= $selectcase->getId() ?>"
      <dl class="case-info">
        <dt>Titolo</dt>
        <dd><input class="input" type="text" name="title" value="<?= $selectcase->nome; ?>"></dd>
        <dt>Descrizione</dt>
        <dd><textarea name="descrizione"><?= $selectcase->descrizione ?></textarea></dd>
        <dt>Tipologia</dt>
        <dd>
        <select class="select" name="tariffa">
          <?php 
            switch($selectcase->tipologia) : 
              case 'furto':
            ?>
              <option value="furto" selected>Furto</option>
              <option value="omicidio">Omicidio</option>
              <option value="ricatto">Ricatto</option>
              <option value="ricerca">Ricerca</option>
              <option value="spionaggio">Spionaggio</option>
            <?php break; ?>
            <?php case 'omicidio': ?>
              <option value="furto">Furto</option>
              <option value="omicidio"selected>Omicidio</option>
              <option value="ricatto">Ricatto</option>
              <option value="ricerca">Ricerca</option>
              <option value="spionaggio">Spionaggio</option>
            <?php break; ?>
            <?php case 'ricatto': ?>
              <option value="furto">Furto</option>
              <option value="omicidio">Omicidio</option>
              <option value="ricatto" selected>Ricatto</option>
              <option value="ricerca">Ricerca</option>
              <option value="spionaggio">Spionaggio</option>
            <?php break; ?>
            <?php case 'ricerca': ?>
              <option value="furto">Furto</option>
              <option value="omicidio">Omicidio</option>
              <option value="ricatto">Ricatto</option>
              <option value="ricerca" selected>Ricerca</option>
              <option value="spionaggio">Spionaggio</option>
            <?php break; ?>
            <?php case 'spionaggio': ?>
              <option value="furto">Furto</option>
              <option value="omicidio">Omicidio</option>
              <option value="ricatto">Ricatto</option>
              <option value="ricerca">Ricerca</option>
              <option value="spionaggio" selected>Spionaggio</option>
            <?php break; ?>
          <?php endswitch; ?>
        </select>
        </dd>
        <dt>Cliente</dt>
        <dd>
          <select class="select" name="cliente">
            <?php foreach($clienti as $cliente) : ?>
              <?php if($cliente->codice_fiscale == $selectcase->cliente->getCodice()) : ?>
                <option value="<?= $cliente->codice_fiscale; ?>" selected><?= $cliente->codice_fiscale; ?></option>
              <?php else: ?>
                <option value="<?= $cliente->codice_fiscale; ?>"><?= $cliente->codice_fiscale; ?></option>
              <?php endif; ?>
            <?php endforeach; ?>
          </select>
        </dd>
        <dt>Criminale</dt>
        <dd>
          <select class="select" name="criminale">
            <?php if($selectcase->isResolved()) : ?>
              <option value="no_criminal">-</option>
              <?php foreach($criminali as $criminale) : ?>
                <?php if($criminale->codice_fiscale == $selectcase->criminale->getCodice()) : ?>
                  <option value="<?= $criminale->codice_fiscale; ?>" selected><?= $criminale->codice_fiscale; ?></option>
                <?php else: ?>
                  <option value="<?= $criminale->codice_fiscale; ?>"><?= $criminale->codice_fiscale; ?></option>
                <?php endif; ?>
              <?php endforeach; ?>
            <?php else : ?>
              <option value="no_criminal" selected>-</option>
              <?php foreach($criminali as $criminale) : ?>
                <option value="<?= $criminale->codice_fiscale; ?>"><?= $criminale->codice_fiscale; ?></option>
              <?php endforeach; ?>
            <?php endif; ?>
          </select>
        </dd>
        <dt>Tag</dt>
        <dd>
          Seleziona i tag da eliminare dal caso:
          <ul class="tags list">
            <?php foreach($selectcase->tags as $tag) : ?>
              <li class="list-item">
                <label class="tag">
                  <input hidden type="checkbox" name="tags[]" value="<?= $tag->getSlug(); ?>" />
                  <span class="tag-label"><?= $tag->nome; ?></span>
                </label>
              </li>
            <?php endforeach; ?>
          </ul>
        </dd>
      </dl>
      <hr />
      <p class="center">
        <button type="submit" class="btn btn-outline">Salva le modifiche</button>
      </p>
      <p class="center">
        <a class="btn btn-outline" href="/caso?id=<?= $selectcase->getId(); ?>">Annulla</a>
      </p>
    </form>
    <?php else : ?>

    <?php if($successo) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-success">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Caso modificato con successo.
      </p>
    <?php endif; ?>

    <?php if($errore) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-danger">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non è stato possibile applicare nessuna modifica. Riprovare.
      </p>
    <?php endif; ?>

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
      <dd><?= $selectcase->descrizione; ?></dd>
      <dt>Tipologia</dt>
      <dd><?= ucfirst($selectcase->tipologia); ?></dd>
      <dt>Cliente</dt>
      <dd>
        <?= $selectcase->cliente->getCodice(); ?> <br>
        <?= $selectcase->cliente->nome; ?>
        <?= $selectcase->cliente->cognome; ?>
      </dd>
      <dt>Criminale</dt>
      <dd>
        <?php 
          if($selectcase->isResolved()) {
            echo $selectcase->criminale->getCodice().'<br>';
            echo ucwords($selectcase->criminale->nome).' ';
            echo ucwords($selectcase->criminale->cognome);
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
                echo $detective->codice_fiscale.'<br>';
                echo ucwords($detective->nome).' ';
                echo ucwords($detective->cognome);
                echo '</li>';
              }
            }
          ?>
        </ul>
      </dd>
      <?php if($role !== 'inspector') : ?>           <!-- Visibile solo agli investigatori e admin -->
        <dt>Ore totali di investigazione</dt> 
        <dd><?= $selectcase->getTotalHours(); ?></dd>
      <?php endif; ?>

      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <?php if(sizeof($selectcase->tags) == 0) : ?>
          -
        <?php else: ?>
          <?php foreach($selectcase->tags as $tag) : ?>
            <li class="list-item"><span class="tag-label"><?= ucfirst($tag->nome); ?></span></li>
          <?php endforeach; ?>
        <?php endif; ?>
      </dd>
    </dl>
    
    <?php if ($role !== 'inspector'): ?>
    <hr />
    <p class="center">
      <a class="btn btn-outline" href="/caso?id=<?= $selectcase->getId(); ?>&modifica=true">Modifica i dati</a>
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
