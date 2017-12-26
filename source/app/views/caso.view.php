<?php require 'partials/admin-header.partial.php' ?>

<main class="container">
  <aside class="col one-fourth">
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
    <hr />
    <p class="center">
      <a class="btn btn-outline" href="/caso?id=1&modifica=true">Modifica i dati del caso</a>
    </p>
  </aside>
  <section class="content col three-fourth">
    <h2>Investigazioni del caso</h2>

    <?php foreach ($investigations as $index => $investigation) : ?>
      <?php require 'partials/investigation.partial.php' ?>
    <?php endforeach; ?>
  </section>
</main>
