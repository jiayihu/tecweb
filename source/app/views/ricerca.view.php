<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
  <aside class="main-sidebar">
    <a class="screen-reader" href="#result">Salta i campi di ricerca e vai ai risultati</a>
    <h1 class="page-title">Ricerca casi o investigazioni</h1>

    <?php if ($emptySearch) :?>
    <input id="empty-alert-close" role="alert" class="alert-checkbox" type="checkbox" />
    <p role="alert" class="alert alert-danger">
      <label for="empty-alert-close" role="alert" class="alert-close" aria-label="Chiudi">
        <span aria-hidden="true">&times;</span>
      </label>
      Non è possibile eseguire una ricerca vuota.
    </p>
    <?php endif; ?>

    <ul class="form-instructions">
      <li>Almeno un campo, oltre la tipologia di ricerca, è obbligatorio</li>
    </ul>

    <form action="/ricerca" method="post">
      <div>
        <span class="input-label">Tipologia di ricerca</span>
        <input class="input-type" id="input-type-case" type="radio" name="type" value="case" checked>
        <label class="radio-label" for="input-type-case">Casi</label>
        <input class="input-type" id="input-type-investigation" type="radio" name="type" value="investigation">
        <label class="radio-label" for="input-type-investigation">Investigazioni</label>

        <p>
          <label class="input-label" for="input-query">Testo da cercare</label>
          <input class="input" type="text" name="search_text" id="input-query" placeholder="Inserisci del testo">
        </p>

        <!-- Fields unique for case -->
        <div class="case-fields">
          <?php if ($role !== 'inspector'): ?>
          <p>
            <label class="input-label" for="input-client">Cliente</label>
            <select class="select" name="cliente" id="input-client">
              <option disabled selected> -- Seleziona un valore -- </option>
              <?php foreach ($clienti as $cliente) : ?>
                  <option value="<?= $cliente->codice_fiscale; ?>"><?= $cliente->codice_fiscale; ?></option>
              <?php endforeach; ?>
            </select>
          </p>
          <?php else: ?>
          <p>
            <input type="hidden" name="cliente" value="<?= $user->codice_fiscale ?>">
          </p>
          <?php endif; ?>
          <p>
            <label class="input-label" for="input-criminal">Criminale</label>
            <select class="select" name="criminale" id="input-criminal">
              <option disabled selected> -- Seleziona un valore -- </option>
              <?php foreach ($criminali as $criminale) : ?>
                  <option value="<?= $criminale->codice_fiscale; ?>"><?= $criminale->codice_fiscale; ?></option>
              <?php endforeach; ?>
            </select>
          </p>
          <p>
            <label class="input-label" for="input-rate">Tipologia</label>
            <select class="select" name="tipologia" id="input-rate">
              <option disabled selected> -- Seleziona un valore -- </option>
              <option value="furto">Furto</option>
              <option value="omicidio">Omicidio</option>
              <option value="ricatto">Ricatto</option>
              <option value="ricerca">Ricerca</option>
              <option value="spionaggio">Spionaggio</option>
            </select>
          </p>
          <fieldset> 
            <legend class="input-label">Tags</legend>
            <ul class="tags list">
              <?php foreach ($allTags as $tag): ?>
              <li class="list-item">
                <label class="tag">
                  <input class="screen-reader" type="checkbox" name="tags[]" value="<?= $tag->getSlug() ?>" />
                  <span class="input-label tag-label"><?= $tag->nome ?></span>
                </label>
              </li>
              <?php endforeach; ?>
            </ul>
          </fieldset>
        </div>

        <!-- Fields unique for investigation -->
        <div class="investigation-fields">
          <p>
            <label class="input-label" for="input-investigator">Investigatore</label>
            <select class="select" name="investigatore" id="input-investigator">
              <option value="null" disabled selected> -- Seleziona un valore -- </option>
              <?php foreach ($investigatori as $investigatore) : ?>
                  <option value="<?= $investigatore->codice_fiscale; ?>"><?= $investigatore->codice_fiscale; ?></option>
              <?php endforeach; ?>
            </select>
          </p>
          <p>
            <label class="input-label" for="input-scene">Scena investigazione</label>
            <input class="input" type="text" name="scena" id="input-scene" placeholder="Città o indirizzo della scena">
          </p>
          <p>
            <label class="input-label" for="input-date-from">A partire da data (aaaa-mm-gg)</label>
            <input class="input" pattern="\d{4}-\d{1,2}-\d{1,2}" name="date-from" id="input-date-from">
          </p>
          <p>
            <label class="input-label" for="input-date-to">Fino a data (aaaa-mm-gg)</label>
            <input class="input" pattern="\d{4}-\d{1,2}-\d{1,2}" name="date-to" id="input-date-to">
          </p>
        </div>
      </div>

      <p>
        <button type="submit" class="btn btn-primary">Avvia ricerca</button>
      </p>
    </form>
  </aside>
  <section id="result" class="main-content">
    <?php if ($searchText !== null): ?>
    <h2>Risultati per "<?= $searchText; ?>"</h2>
    <?php elseif ($cases !== null): ?>
    <h2>Risultati ricerca</h2>
    <?php else: ?>
    <h2>Nessuna ricerca</h2>
    <?php endif; ?>

    <?php if ($cases !== null): ?>
    <table class="results results-cases">
      <thead>
        <tr>
          <th>Stato</th>
          <th>Nome</th>
          <th>Tipologia</th>
          <th>Descrizione</th>
          <th>Azioni</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($cases as $case): ?>
        <tr>
          <td>
            <?php if ($case->isResolved()): ?>
            <span class="status status-resolved" title="Risolto"></span>
            <span class="screen-reader">Risolto</span>
            <?php elseif ($case->isArchived()): ?>
            <span class="status status-archived" title="Archiviato irrisolto"></span>
            <span class="screen-reader">Archiviato irrisolto</span>
            <?php else: ?>
            <span class="status status-progress" title="In progress"></span>
            <span class="screen-reader">In progress</span>
            <?php endif; ?>
          </td>
          <td><?= $case->nome; ?></td>
          <td><?= $case->tipologia; ?></td>
          <td class="case-description"><?= \Core\ellipsis($case->descrizione); ?></td>
          <td><a class="uppercase" href="/caso?id=<?= $case->getId(); ?>">Apri &rightarrow;</a></td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
    <?php endif; ?>

    <?php if ($investigations !== null): ?>
    <table class="results results-investigations">
      <thead>
        <tr>
          <th>Investigatore</th>
          <th>Data</th>
          <th>Scena</th>
          <th>Rapporto</th>
          <th>Azioni</th>
        </tr>
      </thead>
      <tbody>
        <?php foreach ($investigations as $investigation): ?> 
        <tr>
          <td><?= $investigation->getInvestigatore(); ?></td>
          <td><?= $investigation->dataInizio . ' ' . $investigation->dataTermine; ?></td>
          <td><?= $investigation->getScene(); ?></td>
          <td class="investigation-report"><?= \Core\ellipsis($investigation->rapporto); ?></td>
          <td>
            <a class="uppercase" href="/caso?id=<?= $investigation->getCaseId(); ?>&investigazione=<?= $investigation->getId(); ?>">
              Apri &rightarrow;
            </a>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
    <?php endif; ?>

    <?php if ($cases === null && $investigations === null): ?>
    <p role="alert" class="alert alert-secondary">Effettua una ricerca usando i campi a sinistra.</p>
    <?php endif; ?>

    <?php if (($cases !== null && \count($cases) === 0) || ($investigations !== null && \count($investigations) === 0)): ?>
    <p role="alert" class="alert alert-info">Non ci sono risultati per questa ricerca.</p>
    <?php endif; ?>

  </section>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
