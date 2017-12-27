<?php require 'partials/admin-header.partial.php' ?>

<main class="container">
  <h1 class="page-title">Nuovo caso</h1>
  <form action="" class="content clearfix">
    <div class="form-field clearfix">
      <label class="input-text" for="nome">Nome</label>
      <input class="forminput" type="text" id="nome">
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="tipo">Tipo</label>
      <select class="forminput" name="tipo" id="tipo">
        <option value="omicidio" selected="selected">Omicidio</option>
        <option value="rapina">Rapina</option>
      </select>
    </div>
    <div class="form-field clearfix">
      <label class="input-text" for="descrizione">Descrizione</label>
      <textarea class="forminput" rows="4"></textarea>
    </div>
  </form>
</main>
