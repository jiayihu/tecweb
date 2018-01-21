<?php require 'partials/admin-header.partial.php' ?>

<main class="container">
  <h1 class="page-title">Nuovo cliente</h1>
  <form action="aggiunta-cliente" class="content clearfix" method='post'>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Nome</label>
      <input class="forminput" type="text" name="nome">
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Cognome</label>
      <input class="forminput" type="text" name="cognome">
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Codice Fiscale</label>
      <input class="forminput" type="text" name="codice_fiscale">
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Password</label>
      <input class="forminput" type="password" name="password">
    </div>
    <button type="submit" class="btn btn-primary">Aggiungi</button>
  </form>
</main>
