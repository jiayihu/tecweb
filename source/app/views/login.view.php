<?php require 'partials/public-header.partial.php' ?>

<main class="container">
  <?php if ($dashboardError) :?>
    <p class="alert alert-danger">
      Accedi con le tue credenziali per poter visualizzare l'area amministrativa.
    </p>
  <?php endif; ?>

  <form id="login" action="/login" method="post">
    <div class="loginbox v-centered">
      <div class="loginbox-field">
        <input class="input" name="codice_fiscale" type="text" placeholder="Codice Fiscale" required>
        <span class="underline"></span>
      </div>
      <div class="loginbox-field">
        <input class="input" name="password" type="password" placeholder="Password" required>
        <span class="underline"></span>
      </div>
      <input type="submit" class="btn btn-outline" value="Login">
      <?php if ($loginError) :?>
        <p class="alert alert-danger">Non esiste un utente con questo codice fiscale e password</p>
      <?php endif; ?>
    </div> 
  </form>    
</main>

<?php require 'partials/public-footer.partial.php' ?>
