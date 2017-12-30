<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
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
          <p>
            <label class="input-label" for="input-client">Cliente</label>
            <input class="input" type="text" name="cliente" id="input-client" placeholder="Codice fiscale cliente">
          </p>
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
          <p> 
            <span class="input-label">Tags</span>
            <ul class="tags list">
              <?php foreach ($allTags as $tag): ?>
              <li class="list-item">
                <label class="tag">
                  <input class="hide" type="checkbox" name="tags[]" value="<?php echo $tag->getSlug() ?>" />
                  <span class="input-label tag-label"><?php echo $tag->nome ?></span>
                </label>
              </li>
              <?php endforeach; ?>
            </ul>
          </p>
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
            <input type="date" name="date-from" id="input-date-from">
          </p>
          <p>
            <label class="input-label" for="input-date-to">Fino a data</label>
            <input type="date" name="date-to" id="input-date-to">
          </p>
        </div>
      </div>

      <p>
        <button type="submit" class="btn btn-primary" href="contatti">Avvia ricerca</button>
      </p>
    </form>
  </aside>
  <section class="main-content">
    <?php if ($searchText !== null): ?>
    <h2>Risultati per "<?php echo $searchText; ?>"</h2>
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
            <span class="sr-only">Risolto</span>
            <?php elseif ($case->isArchived()): ?>
            <span class="status status-archived" title="Archiviato irrisolto"></span>
            <span class="sr-only">Archiviato irrisolto</span>
            <?php else: ?>
            <span class="status status-progress" title="In progress"></span>
            <span class="sr-only">In progress</span>
            <?php endif; ?>
          </td>
          <td><?php echo $case->nome; ?></td>
          <td><?php echo $case->tipologia; ?></td>
          <td class="case-description"><?php echo \Core\ellipsis($case->descrizione); ?></td>
          <td><a href="/caso?id=<?php echo $case->getId(); ?>">Apri &rightarrow;</a></td>
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
          <td><?php echo $investigation->getInvestigatore(); ?></td>
          <td><?php echo $investigation->dataInizio . ' ' . $investigation->dataTermine; ?></td>
          <td><?php echo $investigation->getScene(); ?></td>
          <td class="investigation-report"><?php echo \Core\ellipsis($investigation->rapporto); ?></td>
          <td>
            <a href="/caso?id=<?php echo $investigation->getCaseId(); ?>&investigazione=<?php echo $investigation->getId(); ?>">
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
