<?php require 'partials/admin-header.partial.php' ?>
<main class="main-container container">
    <h2> Modifica password</h2>
    <form action="modifica-password" method="post">
        <dt>Codice Fiscale</dt>
        <dd>
            <input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale" required>
        </dd>
        <dt>Vecchia Password</dt>
            <dd>
            <input class="input" type="password" name="old_password" placeholder="Inserisci password" minlength="6" required>
            </dd>
        <dt>Nuova Password</dt>
            <dd>
            <input class="input" type="password" name="password" placeholder="Inserisci password" minlength="6" required>
            </dd>
        <dt>Conferma nuova password</dt>
        <dd>
          <input class="input" type="password" name="password_confirm" placeholder="Conferma password" minlength="6" required>
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