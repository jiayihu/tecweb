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
      Uno scandalo in Boemia
      <span class="status status-resolved" title="Risolto"></span>
      <span class="sr-only">Risolto</span>
    </h1>
    <dl class="case-info">
      <dt>Descrizione</dt>
      <dd>Maecenas ut massa quis augue luctus tincidunt. Nulla mollis molestie lorem. Quisque ut erat. Curabitur gravida nisi at nibh. In hac habitasse platea dictumst. Aliquam augue quam, sollicitudin vitae, consectetuer eget, rutrum at, lorem. Integer tincidunt ante vel ipsum.</dd>
      <dt>Tipologia</dt>
      <dd>Riscatto</dd>
      <dt>Cliente</dt>
      <dd>AMGSOU02T42U148D</dd>
      <dt>Criminale</dt>
      <dd>AMGSOU02T42U148D</dd>
      <dt>Investigatori</dt>
      <dd>
        <ul class="list">
          <li>Sherlock Holmes</li>
          <li>John Watson</li>
          <li>Sherlock Holmes</li>
          <li>John Watson</li>
        </ul>
      </dd>
      <dt>Ore totali di investigazione</dt> <!-- Visibile solo agli investigatori e admin -->
      <dd>160</dd>
      <dt>Tag</dt>
      <dd>
      <ul class="tags list">
        <li class="list-item"><span class="tag-label">Annegamento</span></li>
        <li class="list-item"><span class="tag-label">Cellulare</span></li>
        <li class="list-item"><span class="tag-label">Sparatoia</span></li>
        <li class="list-item"><span class="tag-label">Terrorismo</span></li>
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

    <?php foreach ($investigations as $index => $investigation) : ?>
      <?php require 'partials/investigation.partial.php' ?>
    <?php endforeach; ?>
  </section>
</main>
