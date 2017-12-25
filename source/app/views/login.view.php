<?php require 'partials/public-header.partial.php' ?>

<main class="container">
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
        <p class="alert alert-danger"><?php echo $loginError; ?></p>
      <?php endif; ?>
    </div> 
  </form>    
</main>

<?php require 'partials/public-footer.partial.php' ?>
