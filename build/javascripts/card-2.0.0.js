(function() {
  "use strict";
  var OmiseCard, OmiseCardInstance, scriptElement, scriptParent;

  OmiseCard = (function() {
    function OmiseCard(params) {
      if (params == null) {
        params = {};
      }
      this.params = {};
      this.buttons = [];
      this.iframeEvent = {};
      this.serverOrigin = "https://card.omise.co";
      this._setParams();
    }


    /*
     * Set parameters for Card.js
     * @param {int} params.amount                                  - Amount of price
     * @param {string} params.publicKey                            - The public key that you can find in your dashboard once you're signed in
     * @param {string} params.currency                             - Currency code
     * @param {string} [params.logo=""]                            - Merchant logo image
     * @param {string} [params.frameLabel=Omise Payment Gateway]   - The header text you want to show in the credit card popup window
     * @param {string} [params.submitLabel=CHECKOUT]               - The label to be displayed in the submit button in credit card popup window
     * @param {string} [params.buttonLabel=Pay with Omise]         - The label to be displayed in the button that is embeded in your form
     * @param {boolean} [params.locationField=false]               - If value is true, the popup will have the Postal code and City fields included
     * @param {boolean} [params.submitFormTarget=""]               -
     * @param {boolean} [params.submitAuto=true]                   -
     * @param {boolean} [_overrideDefault=true]                    -
     * @return {object}
     */

    OmiseCard.prototype._setParams = function(params, _overrideDefault) {
      var _p;
      if (params == null) {
        params = {};
      }
      if (_overrideDefault == null) {
        _overrideDefault = true;
      }
      _p = {
        amount: params.amount || this.params.amount || 0,
        publicKey: params.publicKey || this.params.publicKey || "",
        currency: params.currency || this.params.currency || "THB",
        logo: params.logo || this.params.logo || "",
        frameLabel: params.frameLabel || this.params.frameLabel || "Omise Payment Gateway",
        submitLabel: params.submitLabel || this.params.submitLabel || "CHECKOUT",
        buttonLabel: params.buttonLabel || this.params.buttonLabel || "Pay with Omise",
        locationField: params.locationField || this.params.locationField || "no",
        submitFormTarget: params.submitFormTarget || this.params.submitFormTarget || "",
        submitAuto: params.submitAuto || this.params.submitAuto || "yes"
      };
      if (_overrideDefault === true) {
        this.params = _p;
      }
      return _p;
    };


    /*
     * Iframe's wrapper initial function
     * @return {object} An iframe wrapper element
     */

    OmiseCard.prototype._createIframeWrapper = function() {
      var _elem, ref;
      _elem = document.createElement("DIV");
      _elem.id = "OmiseCardJsIFrameWrapper";
      _elem.style.backgroundColor = 'rgba(' + [0, 0, 0, 0.88].join(',') + ')';
      _elem.style.visibility = "hidden";
      _elem.style.zIndex = "9990";
      _elem.style.position = "fixed";
      _elem.style.top = "0px";
      _elem.style.left = "0px";
      _elem.style.width = "100%";
      _elem.style.height = "100%";
      _elem.style.overflowX = "hidden";
      _elem.style.opacity = "0";
      _elem.style.border = "none";
      if ((ref = document.body) != null) {
        ref.appendChild(_elem);
      }
      return _elem;
    };


    /*
     * Iframe initial function
     * @return {object} An iframe element
     */

    OmiseCard.prototype._createIframe = function() {
      var _elem;
      _elem = document.createElement("IFRAME");
      _elem.id = "OmiseCardJsIFrame";
      _elem.src = this.serverOrigin + "/index.html";
      _elem.style.width = "100%";
      _elem.style.height = "100%";
      _elem.style.border = "none";
      _elem.style.margin = "0";
      _elem.style.opacity = "0";
      _elem.style.webkitTransform = "scale(0.1)";
      _elem.style.MozTransform = "scale(0.1)";
      _elem.style.msTransform = "scale(0.1)";
      _elem.style.OTransform = "scale(0.1)";
      _elem.style.transform = "scale(0.1)";
      _elem.style.setProperty("-webkit-transition", "200ms opacity ease, -webkit-transform 200ms");
      _elem.style.setProperty("-moz-transition", "200ms opacity ease, -moz-transform 200ms");
      _elem.style.setProperty("-ms-transition", "200ms opacity ease, -ms-transform 200ms");
      _elem.style.setProperty("-o-transition", "200ms opacity ease, -o-transform 200ms");
      _elem.style.setProperty("transition", "200ms opacity ease, transform 200ms");
      _elem.addEventListener("load", (function(_this) {
        return function(event) {
          return _this.iframeEvent = event.currentTarget.contentWindow;
        };
      })(this));
      this.iframeWrapper.appendChild(_elem);
      return _elem;
    };


    /*
     * Pop-up iframe onto a screen
     * @param {object} params
     * @return {void}
     */

    OmiseCard.prototype._showIframe = function(params) {
      this._popIframeData(params);
      this.iframeWrapper.style.opacity = "1";
      this.iframeWrapper.style.visibility = "visible";
      this.iframe.style.webkitTransform = "scale(1)";
      this.iframe.style.MozTransform = "scale(1)";
      this.iframe.style.msTransform = "scale(1)";
      this.iframe.style.OTransform = "scale(1)";
      this.iframe.style.transform = "scale(1)";
      this.iframe.style.opacity = "1";
      document.body.style.overflow = "hidden";
    };


    /*
     * Hide iframe from a screen
     * @return {void}
     */

    OmiseCard.prototype._hideIframe = function() {
      this.iframeWrapper.style.opacity = "0";
      this.iframeWrapper.style.visibility = "hidden";
      this.iframe.style.opacity = "0";
      this.iframe.style.webkitTransform = "scale(0.1)";
      this.iframe.style.MozTransform = "scale(0.1)";
      this.iframe.style.msTransform = "scale(0.1)";
      this.iframe.style.OTransform = "scale(0.1)";
      this.iframe.style.transform = "scale(0.1)";
      document.body.style.overflow = "";
    };


    /*
     * Initial iframe data
     * @param {object} params
     * @return {void}
     */

    OmiseCard.prototype._popIframeData = function(params) {
      var data;
      data = {
        key: params.publicKey,
        image: params.logo,
        currency: params.currency,
        location: params.locationField,
        amount: params.amount,
        frameLabel: params.frameLabel,
        submitLabel: params.submitLabel,
        tokenFieldId: params.tokenFieldId,
        submitAuto: params.submitAuto
      };
      this.iframeEvent.postMessage(JSON.stringify(data), this.serverOrigin);
    };


    /*
     * Observe a message of event that send from iframe
     * @return {void}
     */

    OmiseCard.prototype._listenToCardJsIframeMessage = function() {
      var _listener;
      _listener = (function(_this) {
        return function(event) {
          var _formObject, _input, _result, e;
          if (!event.origin) {
            return;
          }
          if (event.origin !== _this.serverOrigin) {
            return;
          }
          if (event.data === "closeOmiseCardJsPopup") {
            return _this._hideIframe();
          } else {
            try {
              _result = JSON.parse(event.data);
              _input = document.getElementById(_result.tokenFieldId);
              if (_input != null) {
                _input.value = _result.omiseToken;
                _this._hideIframe();
                if (_result.submitAuto === "yes") {
                  _formObject = _input.parentNode;
                  return _formObject.submit();
                }
              }
            } catch (_error) {
              e = _error;
              console.log(e);
              return _this._hideIframe();
            }
          }
        };
      })(this);
      window.removeEventListener("message", _listener);
      window.addEventListener("message", _listener, false);
    };


    /*
     * Create a token field for contain token_id that response from ifram
     * @param {string} form
     * @param {DOM-object} buttonElem
     * @param {object} button
     * @return {string} Token field id
     */

    OmiseCard.prototype._createTokenField = function(form, buttonElem, button) {
      var _formElem, _inp;
      _inp = document.createElement('INPUT');
      _inp.type = "hidden";
      _inp.name = "omiseToken";
      _inp.id = "";
      _inp.className = "omisecardjs-checkout-btn";
      if (form) {
        _inp.id = form.match(/^([.#])(.+)/) ? "form-" + (form.substring(1)) + "-omiseToken" : "form-" + form + "-omiseToken";
        _formElem = (function() {
          switch (form[0]) {
            case "#":
              return document.getElementById(form.substring(1));
            case ".":
              return (document.getElementsByClassName(form.substring(1)))[0];
            default:
              return document.getElementById(form);
          }
        })();
      }
      if (_formElem == null) {
        _formElem = buttonElem.parentNode;
        _inp.id = "form-" + (form.match(/^([.#])(.+)/) ? button.target.substring(1) : button.target) + "-omiseToken";
      }
      if (document.getElementById(_inp.id) == null) {
        _formElem.appendChild(_inp);
      }
      return _inp.id;
    };


    /*
     * Generate button element on-the-fly
     * @param {object} button
     * @return {DOM-object} Button element
     */

    OmiseCard.prototype._generateButton = function(button) {
      var _btnElem, _target;
      _btnElem = document.createElement('BUTTON');
      _btnElem.id = button.target;
      _btnElem.textContent = button.params.buttonLabel;
      _target = document.getElementsByTagName('script');
      _target = _target[_target.length - 1];
      _target.parentNode.appendChild(_btnElem);
      return _btnElem;
    };


    /*
     * Configure OmiseCard's parameters
     * @param {object} params -
     * @return {void}
     */

    OmiseCard.prototype.configure = function(params) {
      if (params == null) {
        params = {};
      }
      this._setParams(params);
    };


    /*
     * Configure button's parameters
     * @param {string} button                  - Button target id/class name
     * @param {object} params                  - Specific parameters that want to assign into a button
     * @param {boolean} [generateButton=false] -
     * @return {void}
     */

    OmiseCard.prototype.configureButton = function(button, params, generateButton) {
      if (params == null) {
        params = {};
      }
      if (generateButton == null) {
        generateButton = false;
      }
      return this.buttons.push({
        target: button,
        generateButton: generateButton,
        params: this._setParams(params, false)
      });
    };


    /*
     * Attach OmiseCard's abilities to buttons
     * @return {void}
     */

    OmiseCard.prototype.attach = function() {
      var button, buttonElem, i, j, len, ref;
      if (this.iframeWrapper == null) {
        this.iframeWrapper = this._createIframeWrapper();
      }
      if (this.iframe == null) {
        this.iframe = this._createIframe();
      }
      this._listenToCardJsIframeMessage();
      ref = this.buttons;
      for (i = j = 0, len = ref.length; j < len; i = ++j) {
        button = ref[i];
        if ((button.params.attached != null) && button.params.attached === true) {
          continue;
        }
        if (button.generateButton === true) {
          buttonElem = this._generateButton(button);
        } else {
          buttonElem = (function() {
            switch (button.target[0]) {
              case "#":
                return document.getElementById(button.target.substring(1));
              case ".":
                return (document.getElementsByClassName(button.target.substring(1)))[0];
              default:
                return document.getElementById(button.target);
            }
          })();
        }
        if (buttonElem != null) {
          button.params.tokenFieldId = this._createTokenField(button.params.submitFormTarget, buttonElem, button);
          buttonElem.omiseCardParams = button.params;
          buttonElem.addEventListener("click", (function(_this) {
            return function(event) {
              event.preventDefault();
              if ((_this.iframeWrapper != null) && (_this.iframe != null)) {
                return _this._showIframe(event.target.omiseCardParams);
              }
            };
          })(this));
          this.buttons[i].params.attached = true;
          this.buttons[i].params.attachFailed = false;
          this.buttons[i].params.attachFailedMessage = "";
        } else {
          this.buttons[i].params.attached = false;
          this.buttons[i].params.attachFailed = true;
          this.buttons[i].params.attachFailedMessage = "button element not found";
        }
      }
    };

    return OmiseCard;

  })();


  /*
  --------------------------------------------------------------------------------
  Execution part
  --------------------------------------------------------------------------------
   */

  OmiseCardInstance = new OmiseCard;


  /*
  Legacy support
  Integrate card.js via assign all of params inside data-attribute of <script></script> tag
   */

  scriptElement = (function() {
    var target;
    target = document.getElementsByTagName('script');
    return target = target[target.length - 1];
  })();

  scriptParent = (function() {
    return scriptElement.parentNode;
  })();

  if ((scriptElement != null) && (scriptElement.getAttribute("data-key") != null) && (scriptElement.getAttribute("data-amount") != null)) {
    OmiseCardInstance.configure({
      amount: scriptElement.getAttribute("data-amount"),
      publicKey: scriptElement.getAttribute("data-key"),
      currency: scriptElement.getAttribute("data-currency"),
      logo: scriptElement.getAttribute("data-image"),
      frameLabel: scriptElement.getAttribute("data-frame-label"),
      submitLabel: scriptElement.getAttribute("data-submit-label"),
      buttonLabel: scriptElement.getAttribute("data-button-label"),
      locationField: scriptElement.getAttribute("data-location"),
      submitFormTarget: scriptElement.getAttribute("data-form-target"),
      submitAuto: scriptElement.getAttribute("data-submit-auto")
    });
    OmiseCardInstance.configureButton("omisecardjs-legacy-checkout-btn", {}, true);
    OmiseCardInstance.attach();
  }

  window._OmiseCard = OmiseCard;

  window.OmiseCard = OmiseCardInstance;

}).call(this);
