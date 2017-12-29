<?php require 'partials/admin-header.partial.php' ?>

<main class="main-container container">
  <aside class="main-sidebar">
    <h2><?php echo $isEdit ? 'Modifica' : 'Aggiungi' ?> utente</h2>
    <form action="<?php echo $isEdit ? 'modifica-utente' : 'aggiungi-utente' ?>" method="post">
      <dl class="case-info">
        <dt>Codice Fiscale</dt>
        <dd>
          <?php if ($isEdit): ?>
          <input type="hidden" name="old_codice_fiscale" value="<?php echo $editingUser->codice_fiscale ?>">
          <?php endif; ?>

          <input class="input" type="text" name="codice_fiscale" placeholder="Inserisci codice fiscale"
            <?php echo $isEdit ? "value=\"{$editingUser->codice_fiscale}\"" : '' ?> required>
        </dd>
        
        <dt>Password</dt>
        <dd>
          <input class="input" type="password" name="password" placeholder="Inserisci password" minlength="6" required>
        </dd>
        
        <dt>Conferma password</dt>
        <dd>
          <input class="input" type="password" name="password_confirm" placeholder="Conferma password" minlength="6" required>
        </dd>
        
        <dt>Nome</dt>
        <dd>
          <input class="input" type="text" name="nome" placeholder="Inserisci nome"
            <?php echo $isEdit ? "value=\"{$editingUser->nome}\"" : '' ?> required>
        </dd>
        
        <dt>Cognome</dt>
        <dd>
          <input class="input" type="text" name="cognome" placeholder="Inserisci cognome"
            <?php echo $isEdit ? "value=\"{$editingUser->cognome}\"" : '' ?> required>
        </dd>

        <?php if ($isEdit): ?>
        <input type="hidden" name="role" value="<?php echo $editingRole ?>">
        <?php else: ?>
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
        <?php endif; ?>
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

      <?php if ($passwordsNotEqual) :?>
      <p class="alert alert-danger">La password inserita non è uguale a quella di conferma.</p>
      <?php endif; ?>

      <?php if ($alreadyExisting) :?>
      <p class="alert alert-danger">L'utente inserito è già esistente.</p>
      <?php endif; ?>
      
      <?php if ($addFailed) :?>
      <p class="alert alert-danger">Non è stato possibile creare l'utente. Si consiglia di riprovare.</p>
      <?php endif; ?>
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
      <input class="hide" type="radio" name="tabs" id="tab-detectives" checked>
      <label for="tab-detectives">Investigatori</label>

      <input class="hide" type="radio" name="tabs" id="tab-admins">
      <label for="tab-admins">Amministratori</label>

      <input class="hide" type="radio" name="tabs" id="tab-inspectors">
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
              <td><?php echo $genericUser->codice_fiscale ?></td>
              <td><?php echo $genericUser->nome ?></td>
              <td><?php echo $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?php echo $genericUser->codice_fiscale ?>&role=detective">Modifica</a>
                <?php if ($userCodiceFiscale !== $genericUser->codice_fiscale): ?>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $genericUser->codice_fiscale ?>">
                  <input type="hidden" name="role" value="detective">
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
            <?php foreach ($admins as $genericUser): ?>
            <tr>
              <td><?php echo $genericUser->codice_fiscale ?></td>
              <td><?php echo $genericUser->nome ?></td>
              <td><?php echo $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?php echo $genericUser->codice_fiscale ?>&role=admin">Modifica</a>
                <?php if ($userCodiceFiscale !== $genericUser->codice_fiscale): ?>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $genericUser->codice_fiscale ?>">
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
              <td><?php echo $genericUser->codice_fiscale ?></td>
              <td><?php echo $genericUser->nome ?></td>
              <td><?php echo $genericUser->cognome ?></td>
              <td class="actions">
                <a href="/utenti?modifica=true&codice_fiscale=<?php echo $genericUser->codice_fiscale ?>&role=inspector">Modifica</a>
                <?php if ($userCodiceFiscale !== $genericUser->codice_fiscale): ?>
                <form action="/elimina-utente" method="post">
                  <input type="hidden" name="codice_fiscale" value="<?php echo $genericUser->codice_fiscale ?>">
                  <input type="hidden" name="role" value="inspector">
                  <button type="submit" class="btn btn-link">Elimina</button>
                </form>
                <?php endif; ?>
              </td>
            </tr>
            <?php endforeach; ?>
          </tbody>
        </table>
      </div>
    </div>
  </section>

</main>
