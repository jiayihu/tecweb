<form action="<?= ROOT ?>/caso" method="post">
  <div class="investigation">
    <input
      id="inv-<?= $investigation->getId(); ?>"
      class="accordion-input screen-reader"
      type="checkbox" 
      name="investigations" 
      <?= (!$investigationId && $index === 0) || ($investigation->getId() === $investigationId) ? 'checked' : '' ?>
    >
    <label class="accordion-label" for="inv-<?= $investigation->getId(); ?>">Investigazione <?= $investigation->getId(); ?></label>

    <?php if ($isEdit &&  $investigation->getId() === $investigationId) : ?> 

      <input type="hidden" name="invId" value="<?= $investigation->getId(); ?>">
      <input type="hidden" name="caseId" value="<?= $selectedCase->getId(); ?>">
      <input type="hidden" name="data_inizio" value="<?= $investigation->dataInizio ?>">
      <input type="hidden" name="investigatore_old" value="<?= $investigation->investigatore->codice_fiscale ?>">

      <div class="investigation-content">
        <ul class="form-instructions">
          <li>E' obbligatorio inserire il luogo dell'investigazione</li>
          <li>E' obbligatorio inserire la data di fine investigazione</li>
          <li>La data di fine investigazione deve essere maggiore di quella d'inizio (<?= $investigation->dataInizio ?>)</li>
          <li>Il numero di ore di lavoro deve essere maggiore o uguale a zero</li>
        </ul>
        <div class="investigation-content-field">
          <label for="investigatore" class="investigation-content-title">Svolta da: </label> 
          <select class="select" id="investigatore" name="investigatore">
            <?php foreach ($investigatori as $investigatore) : ?>
              <?php if ($investigatore->codice_fiscale === $investigation->investigatore->codice_fiscale) : ?>
                <option value="<?= $investigatore->codice_fiscale; ?>" selected><?= $investigatore->codice_fiscale; ?></option>
              <?php else: ?>
                <option value="<?= $investigatore->codice_fiscale; ?>"><?= $investigatore->codice_fiscale; ?></option>
              <?php endif; ?>
            <?php endforeach; ?>
          </select>
        </div>
        <div class="investigation-content-field">
          <label for="ore" class="investigation-content-title">Ore di lavoro: </label> 
          <input class="input" type="number" id="ore" name="ore" value="<?= $investigation->oreTotali ?>">
        </div>
        <div class="investigation-content-field field-data-termine">
          <label for="input-date-to" class="investigation-content-title">Data fine (maggiore dell'inizio <?= $investigation->dataInizio ?>): </label> 
          <?php if ($investigation->dataTermine === null) : ?>
            <input type="text" pattern="\d{4}-\d{1,2}-\d{1,2}" name="date_to" id="input-date-to" placeholder="aaaa-mm-gg" required>
          <?php else : ?>
            <input type="text" pattern="\d{4}-\d{1,2}-\d{1,2}" name="date_to" id="input-date-to" value="<?= $investigation->dataTermine ?>" required>
          <?php endif; ?>     
        </div>
        <fieldset class="investigation-content-field">
          <legend class="investigation-content-title">Luogo </legend> 
          <?php if ($investigation->scena === null) : ?>
            <input class="input" type="text" name="scena_nome" value="" placeholder="nome" aria-label="nome" required>
            <input class="input" type="text" name="scena_descrizione" value="" placeholder="descrizione" aria-label="descrizione" required>
            <input class="input" type="text" name="scena_citta" value="" placeholder="città" aria-label="città" required>
            <input class="input" type="text" name="scena_indirizzo" value="" placeholder="indirizzo" aria-label="indirizzo" required>
          <?php else : ?>
            <input class="input" type="text" name="scena_nome" value="<?= $investigation->scena->nome ?>" placeholder="nome" aria-label="nome" required>
            <input class="input" type="text" name="scena_descrizione" value="<?= $investigation->scena->descrizione ?>" placeholder="descrizione" aria-label="descrizione" required>
            <input class="input" type="text" name="scena_citta" value="<?= $investigation->scena->citta ?>" placeholder="città" aria-label="città" required>
            <input class="input" type="text" name="scena_indirizzo" value="<?= $investigation->scena->indirizzo ?>" placeholder="indirizzo" aria-label="indirizzo" required>
          <?php endif; ?>
        </fieldset>
        <div class="investigation-content-field">
          <label for="rapporto" class="investigation-content-title">Rapporto: </label>
          <textarea id="rapporto" name="rapporto"><?= ucfirst($investigation->rapporto) ?></textarea>
        </div>
        <p class="center">
          <a class="btn btn-link" href="<?= ROOT ?>/caso?id=<?= $selectedCase->getId() ?>&investigazione=<?= $investigation->getId(); ?>">Annulla</a>
          <button class="btn btn-primary">Salva</button>
        </p>
      </div>
  
    <?php else: ?>
    <div class="investigation-content">
      <p class="actions">
        <?php if ($routeName === 'dashboard'): ?>
        <a href="<?= ROOT ?>/caso?id=<?= $selectedCase->getId() ?>&investigazione=<?= $investigation->getId(); ?>">Mostra dettagli</a>
        <?php elseif ($role !== 'inspector'): ?>
        <a href="<?= ROOT ?>/caso?id=<?= $selectedCase->getId() ?>&investigazione=<?= $investigation->getId(); ?>&modifica=true">Modifica</a>
        <?php endif; ?>
      </p>

      <div class="investigation-content-field">
        <span class="investigation-content-title">Svolta da: </span> 
        <?= $inv = $investigation->getInvestigatore(); ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Ore di lavoro: 
        </span> <?= $investigation->oreTotali ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Data: </span>
        <?= $investigation->dataInizio ?> /
        <?php 
          if ($investigation->dataTermine === null) {
            echo "in corso";
          } else {
            echo $investigation->dataTermine;
          };      
        ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Luogo: </span>
          <?php 
              if ($investigation->scena === null) 
                echo '-';
              else
                echo $investigation->getScene();
          ?>
      </div>
      <div class="investigation-content-field">
        <span class="investigation-content-title">Rapporto: </span>
          <?php
            if ($investigation->rapporto === '') {
              echo '-';
            } else {
              echo ucfirst($investigation->rapporto);
            }
          ?>
      </div>
    </div>
    <?php endif; ?>
  </div>
</form>
