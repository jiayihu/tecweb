<?php require 'partials/admin-header.partial.php' ?>

<main class="clearfix">
  <aside class="clearfix">
    <ul class="menu-case">
      <li class="h6 case-select">Caso 1</li>
      <li class="case">Caso 2</li>
      <li class="case">Caso 3</li>
      <li class="case">Caso 4</li>
      <li class="case">Caso 5</li>
      <li class="case">Caso 6</li>
      <li class="case">Caso 7</li>
      <li class="case">Caso 8</li>
      <li class="case">Caso 9</li>
    </ul>
  </aside>

  <section class="dashboard">
    <?php if ($autoLogin) :?>
      <input id="login-alert-close" class="alert-checkbox" type="checkbox" />
      <p class="alert alert-info">
        <!-- Stile rotto dal CSS delle labels del dropdown -->
        <label for="login-alert-close" class="alert-close" aria-label="Chiudi">
          <span aria-hidden="true">&times;</span>
        </label>
        Sei stato automaticamente rimandato all'area amministrativa.
      </p>
    <?php endif; ?>

    <p class="case-info">
      <span class="bold">Risolto: </span>no
      <br>
      <span class="bold">Tipologia: </span>omicidio
      <br> Descrizione caso... Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut
      labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex
      ea commodo consequat.
      <br>
    </p>
    <div class="investigation">
      <input id="inv-5" type="checkbox" name="investigations">
      <label for="inv-5">Investigazione 5</label>
      <div class="investigation-content">
        <div class="investigation-content-field">
          <span class="investigation-content-title">Svolta da: </span> Sherlock Holmes
          <br>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Ore di lavoro: </span>5
          <br>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Data: </span>14.12.2017 - 20.12.2017
          <br>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Luogo: </span> stanza secondo piano; via blablabla n. 6, Padova (PD)
          <br>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Rapporto: </span>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut
          labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip
          ex ea commodo consequat.
          <br>
        </div>
        <div class="investigation-content-field">
          <span class="investigation-content-title">Prove: </span>
          <table>
            <thead>
              <tr>
                <th>Nome</th>
                <th class="descr">Descrizione</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <th>Calzino</th>
                <th class="descr">Piccolo, bianco, sporco di fango. Sicuramente da uomo.</th>
              </tr>
              <tr>
                <th>Valigia</th>
                <th class="descr">Piccolo trolley da bagaglio a mano color rosa.</th>
              </tr>
              <tr>
                <th>Pupazzo</th>
                <th class="descr">Strano, assomiglia ad un coniglio.</th>
              </tr>
            </tbody>
          </table>
        </div>
      </div>
    </div>

    <div class="investigation">
      <input id="inv-4" type="checkbox" name="investigations">
      <label for="inv-4">Investigazione 4</label>
      <div class="investigation-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
          aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      </div>
    </div>

    <div class="investigation">
      <input id="inv-3" type="checkbox" name="investigations">
      <label for="inv-3">Investigazione 3</label>
      <div class="investigation-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
          aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      </div>
    </div>

    <div class="investigation">
      <input id="inv-2" type="checkbox" name="investigations">
      <label for="inv-2">Investigazione 2</label>
      <div class="investigation-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
          aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      </div>
    </div>

    <div class="investigation">
      <input id="inv-1" type="checkbox" name="investigations">
      <label for="inv-1">Investigazione 1</label>
      <div class="investigation-content">
        <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna
          aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.</p>
      </div>
    </div>
  </section>

</main>
