<?php require 'partials/public-header.partial.php' ?>

<main id="content" class="container">
  <?php if ($dashboardError) :?>
    <p class="alert alert-danger">
      Accedi con le tue credenziali per poter visualizzare l'area amministrativa.
    </p>
  <?php endif; ?>

  <form id="login" action="/login" method="post">
    <div class="loginbox v-centered">
      <div class="loginbox-field">
        <label for="codice_fiscale" class="input-label">Codice fiscale (*)</label>
        <input id="codice_fiscale" class="input" name="codice_fiscale" type="text" placeholder="Il tuo codice fiscale" required>
        <span class="underline"></span>
      </div>
      <div class="loginbox-field">
        <label for="password" class="input-label">Password (*)</label>
        <input id="password" class="input" name="password" type="password" placeholder="La tua password" required>
        <span class="underline"></span>
      </div>
      <fieldset class="loginbox-fieldset">
        <legend class="input-label">Accedi come</legend>

        <input class="input-role" id="input-role-detecitve" type="radio" name="role" value="detective" checked>
        <label class="radio-label" for="input-role-detecitve">Investigatore</label>

        <input class="input-role" id="input-role-admin" type="radio" name="role" value="admin">
        <label class="radio-label" for="input-role-admin">Admin</label>

        <input class="input-role" id="input-role-inspector" type="radio" name="role" value="inspector">
        <label class="radio-label" for="input-role-inspector">Ispettore</label>
      </fieldset>
      <input type="submit" class="btn btn-outline" value="Login">
      <?php if ($loginError) :?>
        <p class="alert alert-danger">Non esiste un utente con questo codice fiscale e password</p>
      <?php endif; ?>
    </div> 
  </form>    
</main>

<?php require 'partials/public-footer.partial.php' ?>
