<?php require 'partials/public-header.partial.php' ?>

<main class="container">
  <div class="center">
    <h3>
      <a href="#formcontatti" class="underl">contattaci</a>
    </h3>
  </div>
  <section class="service clearfix">
    <div class="service-content half">
      <h3>PADOVA, ITALIA</h3>
      <p>221B Baker St</p>
      <p>Marylebone, London UK</p>
      <h3>TELEFONO</h3>
      <p>+39 (0)45 875 2845</p>
      <a href="https://goo.gl/maps/vpzLkY5mzd22" class="underl">google maps</a>
    </div>
    <div class="service-photo half img">
      <img src="public/images/home/legal.jpg">
      <!-- alt non importante -->
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-photo half img">
      <img src="public/images/home/agency.jpg">
      <!-- alt non importante -->
    </div>
    <div class="service-content half">
      <h3>Contattaci</h3>
      <form id="formcontatti" action="" method="post">
        <div class="contactbox">
          <div class="contactbox-field">
            <label for="phone" class="hidden">nome e cognome</label>
            <input class="input" type="text" name="nome" placeholder="Nome e cognome" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="phone" class="hidden">telefono</label>
            <input class="input" type="text" name="telefono" placeholder="Telefono" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="email" class="hidden">email</label>
            <input class="input" type="email" name="email" required placeholder="Email">
            <span class="underline"></span>
          </div>
          <div class="contactbox-message">
            <label for="message" class="hidden">messaggio</label>
            <textarea rows="3" cols="30" placeholder="Messaggio" required name="message"></textarea>
          </div>
      </form>
      <input type="submit" class="btn btn-outline" value="Invia">
      </div>
  </section>
</main>

<?php require 'partials/public-footer.partial.php' ?>
