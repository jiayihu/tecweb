<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <?php if ($isEdit && !$investigationId && $role !== 'inspector'): ?>
    <form action="/caso" method="post">
      <input type="hidden" name="caseId" value="<?= $case->getId() ?>"
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
        <input type="checkbox" name="archivia" <?= $case->isArchived() ? 'checked' : ''?>> Archivia come irrisolto</input>
        </dd>
        <dt>Titolo</dt>
        <dd><input class="input" type="text" name="title" value="<?= $case->nome; ?>"></dd>
        <dt>Descrizione</dt>
        <dd><textarea name="descrizione"><?= $case->descrizione ?></textarea></dd>
        <dt>Tipologia</dt>
        <dd>
        <select class="select" name="tariffa">
          <option value="furto" <?= $case->tipologia === 'furto' ? 'selected' : '' ?> >Furto</option>
          <option value="omicidio" <?= $case->tipologia === 'omicidio' ? 'selected' : '' ?> >Omicidio</option>
          <option value="ricatto" <?= $case->tipologia === 'ricatto' ? 'selected' : '' ?> >Ricatto</option>
          <option value="ricerca" <?= $case->tipologia === 'ricerca' ? 'selected' : '' ?> >Ricerca</option>
          <option value="spionaggio" <?= $case->tipologia === 'spionaggio' ? 'selected' : '' ?> >Spionaggio</option>
        </select>
        </dd>
        <dt>Cliente</dt>
        <dd>
          <select class="select" name="cliente">
            <?php foreach ($clienti as $cliente) : ?>
              <?php if ($cliente->codice_fiscale === $case->cliente->getCodice()) : ?>
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
            <option value="no_criminal" <?= $case->isResolved() ? '' : 'selected' ?>>Nessun criminale</option>
            <?php foreach ($criminali as $criminale) : ?>
              <option
                value="<?= $criminale->codice_fiscale; ?>"
                <?= isset($case->criminale) && $case->criminale->getCodice() === $criminale->codice_fiscale ? 'selected' : '' ?>
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
                      $selected = \array_filter($case->tags, function($caseTag) use ($tag) {
                        return $caseTag->getSlug() === $tag->getSlug();
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
        <a class="btn btn-link" href="/caso?id=<?= $case->getId(); ?>">Annulla</a>
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
      <?= $case->nome ?>
      <?php if ($case->isResolved()) : ?>
        <span class="status status-resolved" title="Risolto"></span>
        <span class="sr-only">Risolto</span>
      <?php elseif ($case->isArchived()) : ?>
        <span class="status status-archived" title="Archiviato"></span>
        <span class="sr-only">Archiviato</span>
      <?php else : ?>
        <span class="status status-progress" title="In corso"></span>
        <span class="sr-only">In corso</span>
      <?php endif; ?>
    </h1>
    <dl class="case-info">
      <dt>Descrizione</dt>
      <dd><?= ucfirst($case->descrizione); ?></dd>
      <dt>Tipologia</dt>
      <dd><?= ucfirst($case->tipologia); ?></dd>
      <dt>Cliente</dt>
      <dd>
        <?= $case->cliente->getCodice(); ?> <br>
        <?= $case->cliente->nome; ?>
        <?= $case->cliente->cognome; ?>
      </dd>
      <dt>Criminale</dt>
      <dd>
        <?php 
          if ($case->isResolved()) {
            echo $case->criminale->getCodice().'<br>';
            echo ucwords($case->criminale->nome).' ';
            echo ucwords($case->criminale->cognome);
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
        <dd><?= $case->getTotalHours(); ?></dd>
      <?php endif; ?>

      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <?php if (count($case->tags) === 0) : ?>
          Nessun tag
        <?php else: ?>
          <?php foreach ($case->tags as $tag) : ?>
            <li class="list-item"><span class="tag-label"><?= $tag->nome; ?></span></li>
          <?php endforeach; ?>
        <?php endif; ?>
      </dd>
    </dl>
    
    <?php if ($role !== 'inspector'): ?>
    <hr />
    <p class="center">
      <a class="btn btn-outline" href="/caso?id=<?= $case->getId(); ?>&modifica=true">Modifica i dati</a>
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
