<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="main-container container">
  <aside class="main-sidebar">
    <a class="screen-reader" href="#users">Salta i campi di modifica o inserimento utente e vai alla lista utenti</a>
    <h2><?= $isEdit ? 'Modifica' : 'Aggiungi' ?> utente</h2>

    <?php if ($passwordsNotEqual) :?>
    <p class="alert alert-danger">La password inserita non è uguale a quella di conferma.</p>
    <?php endif; ?>

    <?php if ($alreadyExisting) :?>
    <p class="alert alert-danger">L'utente inserito è già esistente.</p>
    <?php endif; ?>
    
    <?php if ($addFailed) :?>
    <p class="alert alert-danger">Non è stato possibile creare l'utente. Si consiglia di riprovare.</p>
    <?php endif; ?>

    <form action="<?= $isEdit ? 'modifica-utente' : 'aggiungi-utente' ?>" method="post">
      <dl class="case-info">
        <dt>Codice Fiscale</dt>
        <dd>
          <?php if ($isEdit): ?>
          <input type="hidden" name="old_codice_fiscale" value="<?= $editingUser->codice_fiscale ?>">
          <?php endif; ?>

          <input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale" aria-label="Inserisci codice fiscale"
            <?= $isEdit ? "value=\"{$editingUser->codice_fiscale}\"" : '' ?> required>
        </dd>
        
        <dt>Password</dt>
        <dd>
          <input class="input" type="password" name="password" placeholder="Inserisci password" aria-label="Inserisci password" minlength="6" required>
        </dd>
        
        <dt>Conferma password</dt>
        <dd>
          <input class="input" type="password" name="password_confirm" placeholder="Conferma password" aria-label="Conferma password" minlength="6" required>
        </dd>
        
        <dt>Nome</dt>
        <dd>
          <input class="input" type="text" name="nome" placeholder="Inserisci nome" aria-label="Inserisci nome"
            <?= $isEdit ? "value=\"{$editingUser->nome}\"" : '' ?> required>
        </dd>
        
        <dt>Cognome</dt>
        <dd>
          <input class="input" type="text" name="cognome" placeholder="Inserisci cognome" aria-label="Inserisci cognome"
            <?= $isEdit ? "value=\"{$editingUser->cognome}\"" : '' ?> required>
        </dd>

        <dt>Tipologia <?= $isEdit ? '(non modificabile)' : '' ?></dt>
        <dd>
          <?php if ($isEdit): ?>
          <?= $editingRole ?>
          <input type="hidden" name="role" value="<?= $editingRole ?>">
          <?php else: ?>
          <input class="input-role" id="input-role-detective" type="radio" name="role" value="detective" checked>
          <label class="radio-label" for="input-role-detective">Investigatore</label>
          <br />

          <input class="input-role" id="input-role-admin" type="radio" name="role" value="admin">
          <label class="radio-label" for="input-role-admin">Admin</label>
          <br />

          <input class="input-role" id="input-role-inspector" type="radio" name="role" value="inspector">
          <label class="radio-label" for="input-role-inspector">Ispettore</label>
          <?php endif; ?>
        </dd>
      </dl>
      <hr />
      <p class="center">
        <?php if ($isEdit): ?>
        <a href="/utenti" class="btn btn-link">Annulla</a>
        <button type="submit" class="btn btn-primary">Modifica utente</button>
        <?php else: ?>
        <button type="submit" class="btn btn-outline">Aggiunti utente</button>
        <?php endif; ?>
      </p>
    </form>
  </aside>

  <section id="users" class="main-content dashboard">
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
      <input class="screen-reader" type="radio" name="tabs" id="tab-detectives" checked>
      <label for="tab-detectives">Investigatori</label>

      <input class="screen-reader" type="radio" name="tabs" id="tab-admins">
      <label for="tab-admins">Amministratori</label>

      <input class="screen-reader" type="radio" name="tabs" id="tab-inspectors">
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
            <?php foreach ($detectives as $genericUser): ?>
            <tr>
              <td><?= $genericUser->codice_fiscale ?></td>
              <td><?= $genericUser->nome ?></td>
              <td><?= $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?= $genericUser->codice_fiscale ?>&role=detective">Modifica</a>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?= $genericUser->codice_fiscale ?>">
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
            <?php foreach ($admins as $genericUser): ?>
            <tr>
              <td><?= $genericUser->codice_fiscale ?></td>
              <td><?= $genericUser->nome ?></td>
              <td><?= $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?= $genericUser->codice_fiscale ?>&role=admin">Modifica</a>
                <?php if ($userCodiceFiscale !== $genericUser->codice_fiscale): ?>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?= $genericUser->codice_fiscale ?>">
                  <input type="hidden" name="role" value="admin">
                  <button type="submit" class="btn btn-link">Elimina</button>
                </form>
                <?php endif; ?>
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
            <?php foreach ($inspectors as $genericUser): ?>
            <tr>
              <td><?= $genericUser->codice_fiscale ?></td>
              <td><?= $genericUser->nome ?></td>
              <td><?= $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?= $genericUser->codice_fiscale ?>&role=inspector">Modifica</a>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?= $genericUser->codice_fiscale ?>">
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

<?php require 'partials/admin-footer.partial.php' ?>
