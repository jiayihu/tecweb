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

    <?php if ($genericError) :?>
    <input id="genericerror-alert-close" class="alert-checkbox" type="checkbox" />
    <p class="alert alert-danger">
      <label for="genericerror-alert-close" class="alert-close" aria-label="Chiudi">
        <span aria-hidden="true">&times;</span>
      </label>
      Non è stato possibile completare l'operazione. Si consiglia di riprovare.
    </p>
    <?php endif; ?>

    <?php if ($successful) :?>
    <input id="success-alert-close" class="alert-checkbox" type="checkbox" />
    <p class="alert alert-success">
      <label for="success-alert-close" class="alert-close" aria-label="Chiudi">
        <span aria-hidden="true">&times;</span>
      </label>
      Operazione eseguita con successo.
    </p>
    <?php endif; ?>

    <div class="tabs">
      <input type="radio" name="tabs" id="tab-detectives" checked>
      <label for="tab-detectives">Investigatori</label>

      <input type="radio" name="tabs" id="tab-admins">
      <label for="tab-admins">Amministratori</label>

      <input type="radio" name="tabs" id="tab-inspectors">
      <label for="tab-inspectors">Ispettori</label>

      <div class="tab">
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
            <?php foreach ($detectives as $user): ?>
            <tr>
              <td><?php echo $user->codice_fiscale ?></td>
              <td><?php echo $user->nome ?></td>
              <td><?php echo $user->cognome ?></td>
              <td class="actions">
                <form action="/modifica-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="detective">
                  <button type="submit" class="btn btn-link">Modifica</button>
                </form>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="detective">
                  <button type="submit" class="btn btn-link">Elimina</button>
                </form>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
      
      <div class="tab">
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
            <?php foreach ($admins as $user): ?>
            <tr>
              <td><?php echo $user->codice_fiscale ?></td>
              <td><?php echo $user->nome ?></td>
              <td><?php echo $user->cognome ?></td>
              <td class="actions">
                <form action="/modifica-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="admin">
                  <button type="submit" class="btn btn-link">Modifica</button>
                </form>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="admin">
                  <button type="submit" class="btn btn-link">Elimina</button>
                </form>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
      
      <div class="tab">
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
            <?php foreach ($inspectors as $user): ?>
            <tr>
              <td><?php echo $user->codice_fiscale ?></td>
              <td><?php echo $user->nome ?></td>
              <td><?php echo $user->cognome ?></td>
              <td class="actions">
                <form action="/modifica-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="inspector">
                  <button type="submit" class="btn btn-link">Modifica</button>
                </form>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $user->codice_fiscale ?>">
                  <input type="hidden" name="role" value="inspector">
                  <button type="submit" class="btn btn-link">Elimina</button>
                </form>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </section>

</main>
