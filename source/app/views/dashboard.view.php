<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <h2>Casi</h2>
    <ul class="menu-case">
    <?php foreach($cases as $case) : ?>
      <?php if($case->nome == $selectcase->nome) : ?>
      <li class="case case-select"><?= $case->nome ?></li>
      <?php else : ?>
        <li>
          <a class="case" href="/dashboard?id=<?= $case->codice ?>"><?= $case->nome ?></a>
        </li>
      <?php endif; ?>
    <?php endforeach; ?>
    </ul>
  </aside>

  <section class="main-content dashboard">

    <h2><?= $selectcase->nome ?></h2>

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
        <dt>Risolto </dt>
        <?php if($selectcase->isResolved() == false) : ?>
          <dd>No</dd>
        <?php else : ?>
          <dd>Si</dd>
        <?php endif; ?>

        <dt>Tipologia </dt>
        <dd><?= $selectcase->tipologia ?></dd>
        <dt>Descrizione</dt>
        <dd><?= $selectcase->descrizione ?></dd>
      </dl>

      <?php foreach ($investigations as $index => $investigation) : ?>
        <?php require 'partials/investigation.partial.php' ?>
      <?php endforeach; ?>
    </div>
  </section>

</main>
