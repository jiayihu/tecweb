<?php require 'partials/admin-header.partial.php' ?>

<main class="container">
  <aside class="col one-fourth">
    <h1 class="page-title">Ricerca casi o investigazioni</h1>
    <form action="ricerca" method="post">
      <p>
        <label class="input-label" for="input-query">Testo da cercare</label>
        <input class="input" type="text" name="query" id="input-query" placeholder="Inserisci del testo">
      </p>
      <div>
        <span class="input-label">Tipologia</span>
        <input class="input-type" id="input-type-case" type="radio" name="type" value="case" checked>
        <label class="radio-label" for="input-type-case">Casi</label>
        <input class="input-type" id="input-type-investigation" type="radio" name="type" value="investigation">
        <label class="radio-label" for="input-type-investigation">Investigazioni</label>

        <!-- Fields unique for case -->
        <div class="case-fields">
          <p>
            <label class="input-label" for="input-client">Cliente</label>
            <input class="input" type="text" name="client" id="input-client" placeholder="Codice fiscale cliente">
          </p>
          <p>
            <label class="input-label" for="input-criminal">Criminale</label>
            <input class="input" type="text" name="criminal" id="input-criminal" placeholder="Codice fiscale criminale">
          </p>
          <p>
            <label class="input-label" for="input-rate">Tipologia</label>
            <select class="select" name="rate" id="input-rate">
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
          </p>
        </div>

        <!-- Fields unique for investigation -->
        <div class="investigation-fields">
          <p>
            <label class="input-label" for="input-investigator">Investigatore</label>
            <input class="input" type="text" name="investigator" id="input-investigator" placeholder="Codice fiscale investigatore">
          </p>
          <p>
            <label class="input-label" for="input-scene">Scena investigazione</label>
            <input class="input" type="text" name="scene" id="input-scene" placeholder="Città della scena">
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
  <section class="content col three-fourth">
    <h2>Risultati per "<?php echo $query; ?>"</h2>

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
        <tr>
          <td>
            <span class="status status-resolved" title="Risolto"></span>
            <span class="sr-only">Risolto</span>
          </td>
          <td>Uno scandalo in Boemia</td>
          <td>Ricatto</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>
            <span class="status status-progress" title="In Progress"></span>
            <span class="sr-only">In Progress</span>
          </td>
          <td>Uno scandalo in Boemia</td>
          <td>Ricatto</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>
            <span class="status status-archived" title="Archiviato"></span>
            <span class="sr-only">Archiviato</span>
          </td>
          <td>Uno scandalo in Boemia</td>
          <td>Ricatto</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>
            <span class="status status-archived" title="Archiviato"></span>
            <span class="sr-only">Archiviato</span>
          </td>
          <td>Uno scandalo in Boemia</td>
          <td>Ricatto</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
      </tbody>
    </table>

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
        <tr>
          <td>Sherlock Holmes</td>
          <td>02 Dic 2017 - 25 Dic 2017</td>
          <td>Padova (PD)</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>Sherlock Holmes</td>
          <td>02 Dic 2017 - 25 Dic 2017</td>
          <td>Padova (PD)</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>Sherlock Holmes</td>
          <td>02 Dic 2017 - 25 Dic 2017</td>
          <td>Padova (PD)</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
        <tr>
          <td>Sherlock Holmes</td>
          <td>02 Dic 2017 - 25 Dic 2017</td>
          <td>Padova (PD)</td>
          <td>Aliquam quis turpis eget elit sodales scelerisque. Mauris sit amet eros. Suspendisse accumsan tortor quis turpis. Sed ante.</td>
          <td><a href="/caso?id=1&investigazione=1">Apri &rightarrow;</a></td>
        </tr>
      </tbody>
    </table>
  </section>
</main>
