<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <h2>Casi</h2>
    <ul class="menu-case">
      <li class="case case-select">Caso 1</li>
      <li class="case">Caso 2</li>
      <li class="case">Caso 3</li>
      <li class="case">Caso 4</li>
      <li class="case">Caso 5</li>
      <li class="case">Caso 6</li>
      <li class="case">Caso 7</li>
      <li class="case">Caso 8</li>
      <li class="case">Caso 9</li>
    </ul>
  </aside>

  <section class="main-content dashboard">
    <h2>Caso "Uno studio in rosa"</h2>

    <?php if ($autoLogin) :?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-info">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Sei stato automaticamente rimandato all'area amministrativa.
      </p>
    <?php endif; ?>

    <?php if ($notAuthorized) :?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-danger">
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non hai i permessi per accedere alla pagina. Sei stato rimandato alla pagina iniziale.
      </p>
    <?php endif; ?>

    <div class="case-details">
      <p class="actions">
        <a class="" href="/caso?id=1">Mostra dettagli</a>
      </p>

      <dl class="case-info">
        <dt>Risolto: </dt>
        <dd>No</dd>
        <dt>Tipologia: </dt>
        <dd>Omicidio</dd>
        <dt>Descrizione</dt>
        <dd>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut
        labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex
        ea commodo consequat</dd>
      </dl>

      <?php foreach ($investigations as $index => $investigation) : ?>
        <?php require 'partials/investigation.partial.php' ?>
      <?php endforeach; ?>
    </div>
  </section>

</main>
