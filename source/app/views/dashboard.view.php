<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar clearfix">
    <h2>Casi</h2>
    <?php if(!isset($zeroCasi)) : ?>
      <ul class="menu-case">
      <?php foreach($cases as $case) : ?>
          <?php if(!$nuovoCaso && isset($selectcase) && $case->nome == $selectcase->nome) : ?>
            <li class="case case-select"><?= $case->nome ?></li>
          <?php else : ?>
            <li>
              <a class="case" href="/dashboard?id=<?= $case->codice ?>"><?= $case->nome ?></a>
            </li>
          <?php endif; ?>
      <?php endforeach; ?>
      </ul>
    <?php else: ?>
      <p class="center">Nessun caso disponibile.</p>
    <?php endif;?>
    <?php if($role!='inspector') : ?>
      <a class="btn btn-outline" href="/dashboard?nuovoCaso=true">Nuovo caso</a>
    <?php endif; ?>
  </aside>

  <section class="main-content dashboard">

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

    <?php if($nuovoCaso) : ?>
      <?php if(isset($errore)) : ?>
        <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
        <p class="alert alert-danger">
          <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Tutti i campi devono essere compilati.
        </p>
      <?php endif; ?>

      <?php if(isset($duplicazione)) : ?>
        <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
        <p class="alert alert-danger">
          <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Caso già esistente.
        </p>
      <?php endif; ?>

      <h2>Nuovo caso</h2>
      <form action="/dashboard" method="post" class="content clearfix">
        <p class="form-field clearfix">
          <label for="nome">Nome</label>
            <?php if(isset($nome)) : ?>
              <input type="text" name="nome" id="nome" value="<?= $nome ?>"required>
            <?php else : ?>
              <input type="text" name="nome" id="nome" required>
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
          <?php if(isset($descrizione)) : ?>
          <textarea rows="4" name="descrizione" id="descrizione" required><?= $descrizione ?></textarea>
          <?php else : ?>
            <textarea rows="4" name="descrizione" id="descrizione" required></textarea>
          <?php endif; ?>
        </p>
        <p class="form-field clearfix">
          <label for="cliente">Cliente</label>
          <select class="input-rate" name="cliente" id="cliente">
            <option disabled selected> -- Seleziona un valore -- </option>
            <?php foreach($clienti as $cliente) : ?>
              <option value="<?= $cliente->codice_fiscale; ?>"><?= $cliente->codice_fiscale; ?></option>
            <?php endforeach; ?>
          </select>
        </p>
        <button type="submit" class="btn btn-outline">Aggiungi caso</button>
      </form>
    <?php else : ?>
      <?php if(isset($nuovoCasoOk)) : ?>
        <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
        <p class="alert alert-success">
          <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
            <span aria-hidden="true">&times;</span>
          </label>
          Nuovo caso inserito con successo.
        </p>
        <h2><?= $selectcase->nome ?></h2>
      <?php 
        endif; 
        unset($nuovoCasoOk);
      ?>
      <?php if(!isset($zeroCasi)) : ?>
        <h2><?= $selectcase->nome ?></h2>
        <div class="case-details">
          <p class="actions">
            <a class="" href="/caso?id=<?=$selectcase->getId() ?>">Mostra dettagli</a>
          </p>

            <dt>Tipologia </dt>
            <dd><?= ucfirst($selectcase->tipologia) ?></dd>
            <dt>Descrizione</dt>
            <dd><?= ucfirst($selectcase->descrizione) ?></dd>
          </dl>

          <?php if($role == 'detective') : ?> 
            <p>
              <a class="btn btn-outline" href="/dashboard?id=<?= $selectcase->getId() ?>&nuovaInvestigazione=true">Nuova investigazione</a>
            </p>
          <?php endif; ?>

          <?php foreach ($investigations as $index => $investigation) : ?>
            <?php require 'partials/investigation.partial.php' ?>
          <?php endforeach; ?>
        </div>
      <?php endif; ?>
    <?php endif; ?>
  </section>
</main>
