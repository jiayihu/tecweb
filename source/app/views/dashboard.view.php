<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
  <aside class="main-sidebar clearfix">
    <a class="screen-reader" href="#dettaglio-caso">Salta la lista dei casi e vai alla descrizione del caso <?= $selectedCase->nome ?></a>
    <h2>Casi</h2>
    <?php if (!$zeroCasi) : ?>
      <ul class="menu-case">
      <?php foreach ($cases as $case) : ?>
          <?php if (!$nuovoCaso && isset($selectedCase) && $case->nome === $selectedCase->nome) : ?>
            <li>
              <a class="case case-select" href="#dettaglio-caso"><?= $case->nome ?></a>
            </li>
          <?php else : ?>
            <li>
              <a class="case" href="<?= ROOT ?>/dashboard?id=<?= $case->codice ?>"><?= $case->nome ?></a>
            </li>
          <?php endif; ?>
      <?php endforeach; ?>
      </ul>
    <?php else: ?>
      <p class="center">Nessun caso disponibile.</p>
    <?php endif;?>
    <?php if ($role!='inspector') : ?>
      <a class="btn btn-outline" href="<?= ROOT ?>/dashboard?nuovoCaso=true">Nuovo caso</a>
    <?php endif; ?>
  </aside>

  <section id="dettaglio-caso" class="main-content dashboard">

    <?php if ($autoLogin) :?>
      <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
      <p role="alert" class="alert alert-info">
        <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Sei stato automaticamente rimandato all'area amministrativa.
      </p>
    <?php endif; ?>

    <?php if ($notAuthorized) :?>
      <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
      <p role="alert" class="alert alert-danger">
        <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Non hai i permessi per accedere alla pagina. Sei stato rimandato alla pagina iniziale.
      </p>
    <?php endif; ?>

    <?php if ($nuovoCaso) : ?>
      <?php if ($erroreCampiNuovoCaso) : ?>
        <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
        <p role="alert" class="alert alert-danger">
          <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Tutti i campi devono essere compilati.
        </p>
      <?php endif; ?>

      <?php if ($duplicazione) : ?>
        <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
        <p role="alert" class="alert alert-danger">
          <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Caso già esistente. Provare con un altro nome.
        </p>
      <?php endif; ?>

      <h2>Nuovo caso</h2>
      <form action="<?= ROOT ?>/dashboard" method="post" class="content clearfix">
        <ul class="form-instructions">
          <li>Tutti i campi sono obbligatori</li>
          <li>Non è possibile inserire un nuovo caso con un nome uguale ad uno già esistente</li>
        </ul>
        <p class="form-field clearfix">
          <label for="nome">Nome</label>
            <?php if (isset($nome)) : ?>
              <input type="text" name="nome" id="nome" value="<?= $nome ?>" required />
            <?php else : ?>
              <input type="text" name="nome" id="nome" required />
            <?php endif; ?>
        </p>
        <p class="form-field clearfix">
          <label for="tipo">Tipo</label>
          <select class="input-rate" name="tipo" id="tipo">
            <option disabled selected> -- Seleziona un valore -- </option>
            <option value="furto">Furto</option>
            <option value="omicidio">Omicidio</option>
            <option value="ricatto">Ricatto</option>
            <option value="ricerca">Ricerca</option>
            <option value="spionaggio">Spionaggio</option>
          </select>
        </p>
        <p class="form-field clearfix">
          <label for="descrizione">Descrizione</label>
          <?php if (isset($descrizione)) : ?>
          <textarea rows="4" name="descrizione" id="descrizione" required><?= $descrizione ?></textarea>
          <?php else : ?>
            <textarea rows="4" name="descrizione" id="descrizione" required></textarea>
          <?php endif; ?>
        </p>
        <p class="form-field clearfix">
          <label for="cliente">Cliente</label>
          <select class="input-rate" name="cliente" id="cliente">
            <option disabled selected> -- Seleziona un valore -- </option>
            <?php foreach ($clienti as $cliente) : ?>
              <option value="<?= $cliente->codice_fiscale; ?>"><?= $cliente->codice_fiscale; ?></option>
            <?php endforeach; ?>
          </select>
        </p>
        <button type="submit" class="btn btn-primary">Aggiungi caso</button>
      </form>
    <?php else : ?>
      <?php if ($nuovoCasoOk) : ?>
        <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
        <p role="alert" class="alert alert-success">
          <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Nuovo caso inserito con successo.
        </p>
      <?php endif; ?>

      <?php if (!$zeroCasi) : ?>
        <h2><?= $selectedCase->nome ?></h2>
        <div class="case-details">
          <p class="actions">
            <a class="" href="<?= ROOT ?>/caso?id=<?=$selectedCase->getId() ?>">Mostra dettagli</a>
          </p>

          <dl>
            <dt>Tipologia </dt>
            <dd><?= ucfirst($selectedCase->tipologia) ?></dd>
            <dt>Descrizione</dt>
            <dd><?= ucfirst($selectedCase->descrizione) ?></dd>
          </dl>

          <?php foreach ($investigations as $index => $investigation) : ?>
            <?php require 'partials/investigation.partial.php' ?>
          <?php endforeach; ?>
        </div>
      <?php endif; ?>
    <?php endif; ?>
  </section>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
