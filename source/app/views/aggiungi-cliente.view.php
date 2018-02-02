<?php require 'partials/admin-header.partial.php' ?>

<main id="content" class="container">
  <h1 class="page-title">Nuovo cliente</h1>

  <ul class="form-instructions">
    <li>Tutti i campi sono obbligatori</li>
  </ul>

  <form action="aggiunta-cliente" class="content clearfix" method='post'>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Nome</label>
      <input id="nome" class="forminput" type="text" name="nome" required>
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="cognome">Cognome</label>
      <input id="cognome" class="forminput" type="text" name="cognome" required>
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="codice_fiscale">Codice Fiscale</label>
      <input id="codice_fiscale" class="forminput" type="text" name="codice_fiscale" required>
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="password">Password</label>
      <input id="password" class="forminput" type="password" name="password" required>
    </div>
    <button type="submit" class="btn btn-primary">Aggiungi</button>
  </form>
</main>

<?php require 'partials/admin-footer.partial.php' ?>
