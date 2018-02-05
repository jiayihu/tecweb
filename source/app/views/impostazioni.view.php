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
      </label>
      Operazione eseguita con successo.
    </p>
    <?php endif; ?>

    <ul class="form-instructions">
      <li>Tutti i campi sono obbligatori</li>
      <li>La password deve essere almeno di almeno 6 caratteri</li>
    </ul>

    <form action="modifica-password" method="post">
      <dl>
        <dt>Codice Fiscale</dt>
        <dd>
            <input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale" required>
        </dd>
        <dt>Vecchia Password</dt>
            <dd>
            <input class="input" type="password" name="old_password" placeholder="Inserisci vecchia password" pattern=".{6,}" required>
            </dd>
        <dt>Nuova Password</dt>
            <dd>
            <input class="input" type="password" name="password" placeholder="Inserisci nuova password" pattern=".{6,}" required>
            </dd>
        <dt>Conferma nuova password</dt>
        <dd>
          <input class="input" type="password" name="password_confirm" placeholder="Conferma nuova password" pattern=".{6,}" required>
        </dd>
        <button type="submit" class="btn btn-primary">Cambia Password</button>
    </form>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
