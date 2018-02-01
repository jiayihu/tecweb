<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <?php if ($isEdit && !$investigationId && $role !== 'inspector'): ?>
    <form action="/caso" method="post">
      <input type="hidden" name="caseId" value="<?= $selectedCase->getId() ?>"
      <dl class="case-info">
        <?php if($erroreArchiviazione) : ?>
          <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
          <p class="alert alert-danger">
            <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
              <span aria-hidden="true">&times;</span>
            </label>
            Non è possibile archiviare un caso risolto con un colpevole.
          </p>
        <?php endif; ?>

        <?php if($duplicato) : ?>
          <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
          <p class="alert alert-danger">
            <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
              <span aria-hidden="true">&times;</span>
            </label>
            Esiste già un caso con il nome segnato.
          </p>
        <?php endif; ?>

        <dt>Archivia</dt>
        <dd>
        <?php if($selectedCase->isArchived()) : ?>
          <input type="checkbox" name="archivia" checked>Archivia caso irrisolto</input>
        <?php else: ?>
          <input type="checkbox" name="archivia">Archivia caso irrisolto</input>
        <?php endif; ?>        
        </dd>
        <dt>Titolo</dt>
        <dd><input class="input" type="text" name="title" value="<?= $selectedCase->nome; ?>"></dd>
        <dt>Descrizione</dt>
        <dd><textarea name="descrizione"><?= $selectedCase->descrizione ?></textarea></dd>
        <dt>Tipologia</dt>
        <dd>
        <select class="select" name="tariffa">
          <?php 
            switch($selectedCase->tipologia) : 
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
              <?php if($cliente->codice_fiscale == $selectedCase->cliente->getCodice()) : ?>
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
            <?php if($selectedCase->isResolved()) : ?>
              <option value="no_criminal">-</option>
              <?php foreach($criminali as $criminale) : ?>
                <?php if($criminale->codice_fiscale == $selectedCase->criminale->getCodice()) : ?>
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
          <ul class="tags list">
            <?php foreach($selectedCase->tags as $tag) : ?>
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
        <a class="btn btn-outline" href="/caso?id=<?= $selectedCase->getId(); ?>">Annulla</a>
      </p>
    </form>
    <?php else : ?>

    <?php if($modificaOk) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-success">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Caso modificato con successo.
      </p>
    <?php endif; ?>

    <?php if($modificaErrore) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-danger">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non è stato possibile applicare nessuna modifica. Riprovare.
      </p>
    <?php endif; ?>

    <h1 class="page-title">
      <?= $selectedCase->nome ?>
      <?php if($selectedCase->isResolved()) : ?>
        <span class="status status-resolved" title="Risolto"></span>
        <span class="sr-only">Risolto</span>
      <?php elseif($selectedCase->isArchived()) : ?>
        <span class="status status-archived" title="Archiviato"></span>
        <span class="sr-only">Archiviato</span>
      <?php else : ?>
        <span class="status status-progress" title="In corso"></span>
        <span class="sr-only">In corso</span>
      <?php endif; ?>
    </h1>
    <dl class="case-info">
      <dt>Descrizione</dt>
      <dd><?= ucfirst($selectedCase->descrizione); ?></dd>
      <dt>Tipologia</dt>
      <dd><?= ucfirst($selectedCase->tipologia); ?></dd>
      <dt>Cliente</dt>
      <dd>
        <?= $selectedCase->cliente->getCodice(); ?> <br>
        <?= $selectedCase->cliente->nome; ?>
        <?= $selectedCase->cliente->cognome; ?>
      </dd>
      <dt>Criminale</dt>
      <dd>
        <?php 
          if($selectedCase->isResolved()) {
            echo $selectedCase->criminale->getCodice().'<br>';
            echo ucwords($selectedCase->criminale->nome).' ';
            echo ucwords($selectedCase->criminale->cognome);
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
        <dd><?= $selectedCase->getTotalHours(); ?></dd>
      <?php endif; ?>

      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <?php if(sizeof($selectedCase->tags) == 0) : ?>
          Nessun tag
        <?php else: ?>
          <?php foreach($selectedCase->tags as $tag) : ?>
            <li class="list-item"><span class="tag-label"><?= ucfirst($tag->nome); ?></span></li>
          <?php endforeach; ?>
        <?php endif; ?>
      </dd>
    </dl>
    
    <?php if ($role !== 'inspector'): ?>
    <hr />
    <p class="center">
      <a class="btn btn-outline" href="/caso?id=<?= $selectedCase->getId(); ?>&modifica=true">Modifica i dati</a>
    </p>
    <?php endif; ?>

    <?php endif; ?>
  </aside>
  <section class="main-content">
    <h2>Investigazioni del caso</h2>

    <?php if($investigazioneErrore) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-danger">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non è stato possibile applicare nessuna modifica. Riprovare.
      </p>
    <?php endif; ?>
    
    <?php if($investigazioneOk) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-success">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Investigazione modificata con successo.
      </p>
    <?php endif; ?>

    <?php if(sizeof($investigations) == 0) : ?>
      <p> Nessuna investigazione disponibile.
    <?php else : ?>
      <?php foreach ($investigations as $index => $investigation) : ?>
        <?php require 'partials/investigation.partial.php' ?>
      <?php endforeach; ?>
    <?php endif; ?>
  </section>
</main>
