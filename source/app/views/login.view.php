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
        <span class="input-label">Codice fiscale (*)</span>
        <input class="input" name="codice_fiscale" type="text" placeholder="Il tuo codice fiscale" required>
        <span class="underline"></span>
      </div>
      <div class="loginbox-field">
        <span class="input-label">Password (*)</span>
        <input class="input" name="password" type="password" placeholder="La tua password" required>
        <span class="underline"></span>
      </div>
      <div class="loginbox-field">
        <span class="input-label">Accedi come</span>

        <input class="input-role" id="input-role-detecitve" type="radio" name="role" value="detective" checked>
        <label class="radio-label" for="input-role-detecitve">Investigatore</label>

        <input class="input-role" id="input-role-admin" type="radio" name="role" value="admin">
        <label class="radio-label" for="input-role-admin">Admin</label>

        <input class="input-role" id="input-role-inspector" type="radio" name="role" value="inspector">
        <label class="radio-label" for="input-role-inspector">Ispettore</label>
      </div>
      <input type="submit" class="btn btn-outline" value="Login">
      <?php if ($loginError) :?>
        <p class="alert alert-danger">Non esiste un utente con questo codice fiscale e password</p>
      <?php endif; ?>
    </div> 
  </form>    
</main>

<?php require 'partials/public-footer.partial.php' ?>
