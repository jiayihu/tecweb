<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <?php if ($isEdit && !$investigationId && $role !== 'inspector'): ?>
    <form action="/caso" method="post">
      <input type="hidden" name="caseId" value="<?= $selectedCase->getId() ?>"
      <dl class="case-info">
        <?php if ($erroreArchiviazione) : ?>
          <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
          <p class="alert alert-danger">
            <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
              <span aria-hidden="true">&times;</span>
            </label>
            Non è possibile archiviare un caso risolto con un colpevole.
          </p>
        <?php endif; ?>

        <?php if ($duplicato) : ?>
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
        <input type="checkbox" name="archivia" <?= $selectedCase->isArchived() ? 'checked' : ''?>> Archivia come irrisolto</input>
        </dd>
        <dt>Titolo</dt>
        <dd><input class="input" type="text" name="title" value="<?= $selectedCase->nome; ?>"></dd>
        <dt>Descrizione</dt>
        <dd><textarea name="descrizione"><?= $selectedCase->descrizione ?></textarea></dd>
        <dt>Tipologia</dt>
        <dd>
        <select class="select" name="tariffa">
          <option value="furto" <?= $selectedCase->tipologia === 'furto' ? 'selected' : '' ?> >Furto</option>
          <option value="omicidio" <?= $selectedCase->tipologia === 'omicidio' ? 'selected' : '' ?> >Omicidio</option>
          <option value="ricatto" <?= $selectedCase->tipologia === 'ricatto' ? 'selected' : '' ?> >Ricatto</option>
          <option value="ricerca" <?= $selectedCase->tipologia === 'ricerca' ? 'selected' : '' ?> >Ricerca</option>
          <option value="spionaggio" <?= $selectedCase->tipologia === 'spionaggio' ? 'selected' : '' ?> >Spionaggio</option>
        </select>
        </dd>
        <dt>Cliente</dt>
        <dd>
          <select class="select" name="cliente">
            <?php foreach ($clienti as $cliente) : ?>
              <?php if ($cliente->codice_fiscale === $selectedCase->cliente->getCodice()) : ?>
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
            <option value="no_criminal" <?= $selectedCase->isResolved() ? '' : 'selected' ?>>Nessun criminale</option>
            <?php foreach ($criminali as $criminale) : ?>
              <option
                value="<?= $criminale->codice_fiscale; ?>"
                <?= isset($selectedCase->criminale) && $selectedCase->criminale->getCodice() === $criminale->codice_fiscale ? 'selected' : '' ?>
              >
                <?= $criminale->codice_fiscale; ?>
              </option>
            <?php endforeach; ?>
          </select>
        </dd>
        <dt>Tag</dt>
        <dd>
          <ul class="tags list">
            <?php foreach ($allTags as $tag) : ?>
              <li class="list-item">
                <label class="tag">
                  <input class="hide" type="checkbox" name="tags[]" value="<?php $tag->getSlug() ?>"
                    <?php
                      $selected = \array_filter($selectedCase->tags, function($selectedCaseTag) use ($tag) {
                        return $selectedCaseTag->getSlug() === $tag->getSlug();
                      });
                      $isSelected = \count($selected) > 0;
                      echo $isSelected ? 'checked' : '';
                    ?>
                  />
                  <span class="input-label tag-label"><?= $tag->nome ?></span>
                </label>
              </li>
            <?php endforeach; ?>
          </ul>
        </dd>
      </dl>
      
      <hr />
      <p class="center">
        <a class="btn btn-link" href="/caso?id=<?= $selectedCase->getId(); ?>">Annulla</a>
        <button type="submit" class="btn btn-primary">Salva le modifiche</button>
      </p>
    </form>
    <?php else : ?>

    <?php if ($modificaOk) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-success">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Caso modificato con successo.
      </p>
    <?php endif; ?>

    <?php if ($modificaErrore) : ?>
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
      <?php if ($selectedCase->isResolved()) : ?>
        <span class="status status-resolved" title="Risolto"></span>
        <span class="sr-only">Risolto</span>
      <?php elseif ($selectedCase->isArchived()) : ?>
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
          if ($selectedCase->isResolved()) {
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
            if (count($detectives) === 0) {
              echo '-';
            } else {
              foreach ($detectives as $detective) {
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
      <?php if ($role !== 'inspector') : ?>           <!-- Visibile solo agli investigatori e admin -->
        <dt>Ore totali di investigazione</dt> 
        <dd><?= $selectedCase->getTotalHours(); ?></dd>
      <?php endif; ?>

      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <?php if (count($selectedCase->tags) === 0) : ?>
          Nessun tag
        <?php else: ?>
          <?php foreach ($selectedCase->tags as $tag) : ?>
            <li class="list-item"><span class="tag-label"><?= $tag->nome; ?></span></li>
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

    <?php if ($investigazioneErrore) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-danger">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non è stato possibile applicare nessuna modifica. Riprovare.
      </p>
    <?php endif; ?>
    
    <?php if ($investigazioneOk) : ?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-success">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Investigazione modificata con successo.
      </p>
    <?php endif; ?>

    <?php if (count($investigations) === 0) : ?>
      <p> Nessuna investigazione disponibile.
    <?php else : ?>
      <?php foreach ($investigations as $index => $investigation) : ?>
        <?php require 'partials/investigation.partial.php' ?>
      <?php endforeach; ?>
    <?php endif; ?>
  </section>
</main>
