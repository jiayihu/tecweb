<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
  <h1 class="page-title">Nuovo criminale</h1>

  <?php if ($successful) :?>
  <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
  <p role="alert" class="alert alert-success">
    <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
      <span aria-hidden="true">&times;</span>
    </label>
    Operazione eseguita con successo.
  </p>
  <?php endif; ?>

  <?php if ($erroreDoppio) :?>
  <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
  <p role="alert" class="alert alert-danger">
    <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
      <span aria-hidden="true">&times;</span>
    </label>
    Criminale con stesso codice fiscale già presente.
  </p>
  <?php endif; ?>

  <?php if ($genericError) :?>
  <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
  <p role="alert" class="alert alert-danger">
    <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
      <span aria-hidden="true">&times;</span>
    </label>
    Non è stato possibile completare l'operazione. Si consiglia di riprovare.
  </p>
  <?php endif; ?>

  <ul class="form-instructions">
    <li>Tutti i campi sono obbligatori</li>
  </ul>

  <form action="<?= ROOT ?>/aggiunta-criminale" class="content clearfix" method='post'>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Nome</label>
      <input id="nome" class="forminput" type="text" name="nome" required />
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="cognome">Cognome</label>
      <input id="cognome" class="forminput" type="text" name="cognome" required />
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="codice_fiscale">Codice Fiscale</label>
      <input id="codice_fiscale" class="forminput" type="text" name="codice_fiscale" pattern="^[A-Z]{6}[0-9]{2}[A-Z][0-9]{2}[A-Z][0-9]{3}[A-Z]$" required />
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="descrizione">Descrizione</label>
      <textarea id="descrizione" class="forminput" rows="4" name='descrizione' required></textarea>
    </div>
    <button type="submit" class="btn btn-primary">Aggiungi</button>
  </form>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
