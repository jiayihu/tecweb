<?php require 'partials/admin-header.partial.php' ?>
<main class="main-container container">
    <h2> Modifica password</h2>
    <?php if ($passwordsNotEqual) :?>
    <p class="alert alert-danger">La password inserita non è uguale a quella di conferma.</p>
    <?php endif; ?>

    <?php if ($codiciNotEqual) :?>
    <p class="alert alert-danger">Codice Fiscale Sbagliato</p>
    <?php endif; ?>
    
    <?php if ($passwordSbagliata) :?>
    <p class="alert alert-danger">Password Sbagliata</p>
    <?php endif; ?>

    <form action="modifica-password" method="post">
        <dt>Codice Fiscale</dt>
        <dd>
            <input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale" required>
        </dd>
        <dt>Vecchia Password</dt>
            <dd>
            <input class="input" type="password" name="old_password" placeholder="Inserisci vecchia password" minlength="6" required>
            </dd>
        <dt>Nuova Password</dt>
            <dd>
            <input class="input" type="password" name="password" placeholder="Inserisci nuova password" minlength="6" required>
            </dd>
        <dt>Conferma nuova password</dt>
        <dd>
          <input class="input" type="password" name="password_confirm" placeholder="Conferma nuova password" minlength="6" required>
        </dd>
        <dt>Tipologia</dt>
        <dd>
          <input class="input-role" id="input-role-detective" type="radio" name="role" value="detective" checked>
          <label class="radio-label" for="input-role-detective">Investigatore</label>
          <br />

          <input class="input-role" id="input-role-admin" type="radio" name="role" value="admin">
          <label class="radio-label" for="input-role-admin">Admin</label>
          <br />

          <input class="input-role" id="input-role-inspector" type="radio" name="role" value="inspector">
          <label class="radio-label" for="input-role-inspector">Ispettore</label>
        </dd>
        <button type="submit" class="btn btn-primary">Cambia Password</button>
    </form>
</main>