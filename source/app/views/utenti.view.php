<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <h2>Aggiungi/Modifica utente</h2>
    <form action="/aggiungi-utente" method="post">
      <dl class="case-info">
        <dt>Codice Fiscale</dt>
        <dd><input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale" required></dd>
        
        <dt>Password</dt>
        <dd><input class="input" type="password" name="password" placeholder="Inserisci password" required></dd>
        
        <dt>Conferma password</dt>
        <dd><input class="input" type="password" name="password_confirm" placeholder="Conferma password" required></dd>
        
        <dt>Nome</dt>
        <dd><input class="input" type="text" name="nome" placeholder="Inserisci nome" required></dd>
        
        <dt>Cognome</dt>
        <dd><input class="input" type="text" name="cognome" placeholder="Inserisci cognome" required></dd>
        
        <dt>Tipologia</dt>
        <dd>
          <input class="input-role" id="input-role-detecitve" type="radio" name="role" value="detective" checked>
          <label class="radio-label" for="input-role-detecitve">Investigatore</label>
          <br />

          <input class="input-role" id="input-role-admin" type="radio" name="role" value="admin">
          <label class="radio-label" for="input-role-admin">Admin</label>
          <br />

          <input class="input-role" id="input-role-inspector" type="radio" name="role" value="inspector">
          <label class="radio-label" for="input-role-inspector">Ispettore</label>
        </dd>
      </dl>
      <hr />
      <p class="center">
        <button type="submit" class="btn btn-outline">Aggiungi utente</button>

        <?php if ($passwordsNotEqual) :?>
        <p class="alert alert-danger">La password inserita non è uguale a quella di conferma.</p>
        <?php endif; ?>

        <?php if ($alreadyExisting) :?>
        <p class="alert alert-danger">L'utente inserito è già esistente.</p>
        <?php endif; ?>
        
        <?php if ($addFailed) :?>
        <p class="alert alert-danger">Non è stato possibile creare l'utente. Si consiglia di riprovare.</p>
        <?php endif; ?>
        
      </p>
    </form>
  </aside>

  <section class="main-content dashboard">
    <h2>Utenti</h2>

    <table class="results">
      <thead>
        <tr>
          <th>Codice Fiscale</th>
          <th>Nome</th>
          <th>Cognome</th>
          <th>Azioni</th>
        </tr>
      </thead>
      <tbody>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
        <tr>
          <td>AMGSOU02T42U148D</td>
          <td>Julia</td>
          <td>Little</td>
          <td class="actions">
            <a href="/utenti?id=1&modifica=true">Modifica</a>
            <a href="/utenti?id=1&cancella=true">Cancella</a>
          </td>
        </tr>
      </tbody>
    </table>
  </section>

</main>
