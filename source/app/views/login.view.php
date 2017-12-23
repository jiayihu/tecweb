<?php require 'partials/public-header.partial.php' ?>

<main class="container">
  <form id="login" action="" method="post">
    <div class="loginbox v-centered">
      <div class="loginbox-field">
        <input class="input" name="email" type="email" placeholder="email" required>
        <span class="underline"></span>
      </div>
      <div class="loginbox-field">
        <input class="input" name="password" type="password" placeholder="password" required>
        <span class="underline"></span>
      </div>
      <input type="submit" class="btn btn-outline" value="Login">
    </div> 
  </form>    
</main>

<?php require 'partials/public-footer.partial.php' ?>
