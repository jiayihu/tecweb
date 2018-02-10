<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
    <h2> Modifica password</h2>
    <?php if ($passwordsNotEqual) :?>
    <p role="alert" class="alert alert-danger">La nuova password inserita non è uguale a quella di conferma.</p>
    <?php endif; ?>

    <?php if ($codiciNotEqual) :?>
    <p role="alert" class="alert alert-danger">Codice Fiscale Sbagliato</p>
    <?php endif; ?>
    
    <?php if ($passwordSbagliata) :?>
    <p role="alert" class="alert alert-danger">La password vecchia è sbagliata</p>
    <?php endif; ?>

    <?php if ($successful) :?>
    <input id="alert-close" role="alert" class="alert-checkbox" type="checkbox" />
    <p role="alert" class="alert alert-success">
      <label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">
        <span aria-hidden="true">&times;</span>
      </label>
      Operazione eseguita con successo.
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
      <li>La password deve essere almeno di almeno 6 caratteri</li>
    </ul>

    <form action="<?= ROOT ?>/modifica-password" class="content clearfix" method="post">
      <div class="form-field clearfix">
        <input type="hidden" name="codice_fiscale" value="<?= $userCodiceFiscale ?>" />
      </div>
      <div class="form-field clearfix">
        <label class="input-text" for="old_password">Inserisci vecchia password</label>
        <input id="old_password" class="forminput" type="password" name="old_password" required pattern=".{6,}" />
      </div>
      <div class="form-field clearfix new-pwd">
        <label class="input-text" for="password">Inserisci nuova password</label>
        <input id="password" class="forminput" type="password" name="password" required pattern=".{6,}" />
      </div>
      <div class="form-field clearfix">
        <label class="input-text" for="password_confirm">Conferma nuova password</label>
        <input id="password_confirm" class="forminput" type="password" name="password_confirm" required pattern=".{6,}" />
      </div>
      <button type="submit" class="btn btn-primary">Cambia Password</button>
    </form>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
