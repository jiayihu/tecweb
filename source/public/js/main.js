function isDate(date) {
  if (Object.prototype.toString.call(date) === '[object Date]') {
    if (isNaN(date.getTime())) return false;
    else return true;
  }

  return false;
}

function createError(container, message) {
  // Create the alert message
  var element = document.createElement('p');
  element.className = 'alert alert-danger';
  element.setAttribute('role', 'alert');
  element.innerHTML =
    '<label for="alert-close" role="alert" class="alert-close" aria-label="Chiudi">' +
    '  <span aria-hidden="true">&times;</span>' +
    '</label>' +
    message;

  // Destroy the alert on close click
  var close = element.querySelector('.alert-close');
  close.addEventListener('click', function() {
    container.removeChild(element);
  });

  // Add the alert to the container element
  container.appendChild(element);
}

function validateCaseEdit() {
  var container = document.querySelector('.case-info');
  var archived = document.querySelector('.case-info input[name="archivia"]');
  var criminal = document.querySelector('.case-info select[name="criminale"]');

  if (!archived || !criminal) return;

  var form = document.querySelector('.main-sidebar form');

  form.addEventListener('submit', function(event) {
    if (archived.checked && criminal.value !== 'no_criminal') {
      // Avoid submitting the form to the server
      event.preventDefault();
      createError(
        container,
        'Non è possibile archiviare un caso come irrisolto e assegnare un colpevole.'
      );
    }
  });
}

function validateInvestigation() {
  var dataInizio = document.querySelector('.investigation input[name="data_inizio"]');
  var dataTermine = document.querySelector('.investigation input[name="date_to"]');

  if (!dataTermine) return;

  var container = document.querySelector('.field-data-termine');

  dataTermine.addEventListener('change', function(event) {
    var termine = new Date(event.target.value);
    var inizio = new Date(dataInizio.value);

    if (!isDate(termine)) {
      createError(container, 'La data è in un formato non valido. Assicurati che sia aaaa-mm-gg');
      return;
    }

    if (termine < inizio) {
      createError(container, 'La data di termine non può essere prima di quella di inizio.');
    }
  });
}

function main() {
  var pageName = document.body.className;

  switch (pageName) {
    case 'page-caso':
      validateCaseEdit();
      validateInvestigation();
      break;

    default:
      break;
  }
}

main();
