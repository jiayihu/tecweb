<?php require 'partials/public-header.partial.php' ?>

<div class="intro">
  <div class="container v-centered-wrapper">
    <div class="v-centered">
      <h1 class="intro-name">
        <a href="#formcontatti" class="underl">Contattaci</a>
      </h1>
    </div>
  </div>
</div>

<main class="container">
  <section class="service clearfix">
    <div class="service-content col half">
      <h2>INDIRIZZO</h2>
      <p>Via Trieste, 63 -</p>
      <p>35121 Padova</p>
      <p>Italia</p>
      <h2>TELEFONO</h2>
      <p>+39 049 827 5111</p>
      <a href="https://goo.gl/maps/vpzLkY5mzd22" class="underl">google maps</a>
    </div>
    <div class="service-photo col half img">
      <img src="public/images/contatti/office.jpg" alt="Il nostro ufficio">
    </div>
  </section>

  <section class="service clearfix">
    <div class="service-photo col half img">
      <img src="public/images/contatti/envelop.jpg" alt="Lettera">
    </div>
    <div class="service-content col half">
      <h2>Contattaci</h2>
      <form id="formcontatti" action="/" method="post">
        <div class="contactbox">
          <div class="contactbox-field">
            <label for="name" class="hidden">nome e cognome</label>
            <input id="name" class="input" type="text" name="nome" placeholder="Nome e cognome" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="phone" class="hidden">telefono</label>
            <input id="phone" class="input" type="text" name="telefono" placeholder="Telefono" required>
            <span class="underline"></span>
          </div>
          <div class="contactbox-field">
            <label for="email" class="hidden" lang="en">email</label>
            <input id="email" class="input" type="email" name="email" required placeholder="Email">
            <span class="underline"></span>
          </div>
          <div class="contactbox-message">
            <label for="message" class="hidden">messaggio</label>
            <textarea id="message" rows="3" cols="30" placeholder="Messaggio" required name="message"></textarea>
          </div>
        </div>
      </form>
      <input type="submit" class="btn btn-outline" value="Invia">
      </div>
  </section>
</main>

<?php require 'partials/public-footer.partial.php' ?>
