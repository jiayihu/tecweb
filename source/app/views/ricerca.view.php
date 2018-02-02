<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
  <aside class="main-sidebar">
    <a class="screen-reader" href="#result">Salta i campi di ricerca e vai ai risultati</a>
    <h1 class="page-title">Ricerca casi o investigazioni</h1>
    <form action="/ricerca" method="post">
      <?php if ($emptySearch) :?>
      <p class="alert alert-danger">Non è possibile eseguire una ricerca vuota.</p>
      <?php endif; ?>

      <div>
        <span class="input-label">Tipologia</span>
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
            <input class="input" type="text" name="cliente" id="input-client" placeholder="Codice fiscale cliente">
          </p>
          <?php else: ?>
          <p>
            <input type="hidden" name="cliente" value="<?= $user->codice_fiscale ?>">
          </p>
          <?php endif; ?>
          <p>
            <label class="input-label" for="input-criminal">Criminale</label>
            <input class="input" type="text" name="criminale" id="input-criminal" placeholder="Codice fiscale criminale">
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
          <div> 
            <span class="input-label">Tags</span>
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
          </div>
        </div>

        <!-- Fields unique for investigation -->
        <div class="investigation-fields">
          <p>
            <label class="input-label" for="input-investigator">Investigatore</label>
            <input class="input" type="text" name="investigatore" id="input-investigator" placeholder="Codice fiscale investigatore">
          </p>
          <p>
            <label class="input-label" for="input-scene">Scena investigazione</label>
            <input class="input" type="text" name="scena" id="input-scene" placeholder="Città o indirizzo della scena">
          </p>
          <p>
            <label class="input-label" for="input-date-from">A partire da data</label>
            <input pattern="\d{4}-\d{1,2}-\d{1,2}" name="date-from" id="input-date-from">
          </p>
          <p>
            <label class="input-label" for="input-date-to">Fino a data</label>
            <input pattern="\d{4}-\d{1,2}-\d{1,2}" name="date-to" id="input-date-to">
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
          <td><a href="/caso?id=<?= $case->getId(); ?>">Apri &rightarrow;</a></td>
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
            <a href="/caso?id=<?= $investigation->getCaseId(); ?>&investigazione=<?= $investigation->getId(); ?>">
              Apri &rightarrow;
            </a>
          </td>
        </tr>
        <?php endforeach; ?>
      </tbody>
    </table>
    <?php endif; ?>

    <?php if ($cases === null && $investigations === null): ?>
    <p class="alert alert-secondary">Effettua una ricerca usando i campi a sinistra.</p>
    <?php endif; ?>

    <?php if (($cases !== null && \count($cases) === 0) || ($investigations !== null && \count($investigations) === 0)): ?>
    <p class="alert alert-info">Non ci sono risultati per questa ricerca.</p>
    <?php endif; ?>

  </section>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
