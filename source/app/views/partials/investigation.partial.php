<div class="investigation">
  <input
    id="inv-<?php echo $index; ?>" 
    type="checkbox" 
    name="investigations" 
    <?php echo $index == $investigationId ? 'checked' : '' ?>
  >
  <label for="inv-<?php echo $index; ?>">Investigazione <?php echo $index; ?></label>
  <div class="investigation-content">
    <p class="actions">
      <a href="/caso?id=1&investizione=1">Mostra dettagli</a>
      <a href="/caso?id=1&investizione=1&modifica=true">Modifica</a>
    </p>
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
