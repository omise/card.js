(function (window, $, undefined) {

  var cardholderNameInput = $("#cardholder_name");
  var cardNumberInput = $("#card_number")
  var expirationMonthInput = $("#expiration_month");
  var expirationYearInput = $("#expiration_year");
  var securityCodeInput = $("#security_code");
  var postalCodeInput = $("#postal_code");
  var cityInput = $("#city");
  var errorMessage = $("#errorMessage");
  var clientWindowDomain;

  function validateInput(input) {
    if ($(input).val().length == 0) {
      $(input).addClass("error");
      return 1;
    } else {
      $(input).removeClass("error");
      return 0;
    }
  };

  function resetForm() {
    card = {};
    cardholderNameInput.val('').removeClass('error');
    cardNumberInput.val('').removeClass('error');
    expirationMonthInput.val('').removeClass('error');
    expirationYearInput.val('').removeClass('error');
    securityCodeInput.val('').removeClass('error');
    postalCodeInput.val('').removeClass('error');
    cityInput.val('').removeClass('error');
    errorMessage.html('');
  };

  function validateForm(){
    var error = validateInput(cardholderNameInput);
    error += validateInput(cardNumberInput);
    error += validateInput(expirationMonthInput);
    error += validateInput(expirationYearInput);
    error += validateInput(securityCodeInput);

    if (error > 0) {
      return false;
    } else {
      return true;
    }
  };

  cardholderNameInput.keyup(function (event) {
    validateInput(this);
  });

  cardNumberInput.keyup(function (event) {
    validateInput(this);
  });

  expirationMonthInput.keyup(function (event) {
    validateInput(this);
  });

  expirationYearInput.keyup(function (event) {
    validateInput(this);
  });

  securityCodeInput.keyup(function (event) {
    validateInput(this);
  });

  $(".close-modal").click(function () {
    resetForm();
    parent.window.postMessage("closeOmiseCardJsPopup", "*");
  });

  $("#paynow").click(function (e) {
    e.preventDefault();
    var formIsValid = validateForm();
    if (!formIsValid) {
      return;
    };

    var card = {
      "name": cardholderNameInput.val(),
      "number": cardNumberInput.val(),
      "expiration_month": expirationMonthInput.val(),
      "expiration_year": expirationYearInput.val(),
      "security_code": securityCodeInput.val(),
      "postal_code": postalCodeInput.val(),
      "city": cityInput.val()
    };

    Omise.createToken("card", card, function (statusCode, response) {
      resetForm();

      if (response.object == "error") {
        errorMessage.html(response.message);
      } else {
        parent.window.postMessage('{ "omiseToken": "' + response.id + '" }', clientWindowDomain);
      };
    });
  });

  window.removeEventListener("message", listenToParentWindowMessage);
  window.addEventListener("message", listenToParentWindowMessage, false);

  function listenToParentWindowMessage(event){
    if (event.data) {
      var json = JSON.parse(event.data);
      $("#checkoutDisplayAmount").html(json.amount/100);
      $("#merchantName").html(json.merchantName);
      $("#merchantImage").attr("src", json.image);
      clientWindowDomain = event.origin;

      if (Omise) {
        Omise.config.defaultHost = "vault-staging.omise.co";
        Omise.setPublicKey(json.key);
      };
    };
  };

})(window, jQuery);
