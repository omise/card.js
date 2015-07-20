"use strict"

a = do ->
  b: ->
    return true

class OmiseCard
  constructor: (params={}) ->
    # Define construct variables
    @params       = {}
    @buttons      = []
    @iframeEvent  = {}
    @serverOrigin = "https://card.omise.co"

    # Initiate OmiseCard's default parameters
    @_setParams params

    # Initiate OmiseCard's iframe
    @iframeWrapper  = @_createIframeWrapper()
    @iframe         = @_createIframe()

  ###
  # Set parameters for Card.js
  # @param {int} params.amount                                  - Amount of price
  # @param {string} params.publicKey                            - The public key that you can find in your dashboard once you're signed in
  # @param {string} params.currency                             - Currency code
  # @param {string} [params.logo=""]                            - Merchant logo image
  # @param {string} [params.frameLabel=Omise Payment Gateway]   - The header text you want to show in the credit card popup window
  # @param {string} [params.submitLabel=CHECKOUT]               - The label to be displayed in the submit button in credit card popup window
  # @param {string} [params.buttonLabel=Pay with Omise]         - The label to be displayed in the button that is embeded in your form
  # @param {boolean} [params.locationField=false]               - If value is true, the popup will have the Postal code and City fields included
  # @param {boolean} [params.submitFormTarget=""]               -
  # @param {boolean} [params.submitAuto=true]                   -
  # @param {object} [_default={}]                               -
  # @param {boolean} [_overrideDefault=true]                    -
  # @return {object}
  ###
  _setParams: (params, _default={}, _overrideDefault=true) ->
    _p =
      amount            : params.amount || _default.amount || 0
      publicKey         : params.publicKey || _default.publicKey || ""
      currency          : params.currency || _default.currency || "THB"
      logo              : params.logo || _default.logo || ""
      frameLabel        : params.frameLabel || _default.frameLabel || "Omise Payment Gateway"
      submitLabel       : params.submitLabel || _default.submitLabel || "CHECKOUT"
      buttonLabel       : params.buttonLabel || _default.buttonLabel || "Pay with Omise"
      locationField     : params.locationField || _default.locationField || false
      submitFormTarget  : params.submitFormTarget || _default.submitFormTarget || ""
      submitAuto        : params.submitAuto || _default.submitAuto || true

    @params = _p if _overrideDefault is true
    return _p

  ###
  # Iframe's wrapper initial function
  # @return {object} An iframe wrapper element
  ###
  _createIframeWrapper: ->
    _e                          = document.createElement("DIV")
    _e.id                       = "OmiseCardJsIFrameWrapper"
    _e.style.backgroundColor    = 'rgba(' + [0,0,0,0.88].join(',') + ')'
    _e.style.visibility         = "hidden"
    _e.style.zIndex             = "9990"
    _e.style.position           = "fixed"
    _e.style.top                = "0px"
    _e.style.left               = "0px"
    _e.style.width              = "100%"
    _e.style.height             = "100%"
    _e.style.overflowX          = "hidden"
    _e.style.opacity            = "0"
    _e.style.border             = "none"

    document.body?.appendChild(_e)
    return _e

  ###
  # Iframe initial function
  # @return {object} An iframe element
  ###
  _createIframe: ->
    _e                          = document.createElement("IFRAME")
    _e.id                       = "OmiseCardJsIFrame"
    _e.src                      = @serverOrigin + "/index.html"
    _e.style.width              = "100%"
    _e.style.height             = "100%"
    _e.style.border             = "none"
    _e.style.margin             = "0"
    _e.style.opacity            = "0"
    _e.style.webkitTransform    = "scale(0.1)"
    _e.style.MozTransform       = "scale(0.1)"
    _e.style.msTransform        = "scale(0.1)"
    _e.style.OTransform         = "scale(0.1)"
    _e.style.transform          = "scale(0.1)"
    _e.style.setProperty("-webkit-transition", "200ms opacity ease, -webkit-transform 200ms")
    _e.style.setProperty("-moz-transition", "200ms opacity ease, -moz-transform 200ms")
    _e.style.setProperty("-ms-transition", "200ms opacity ease, -ms-transform 200ms")
    _e.style.setProperty("-o-transition", "200ms opacity ease, -o-transform 200ms")
    _e.style.setProperty("transition", "200ms opacity ease, transform 200ms")

    _e.addEventListener "load", (event) =>
      @iframeEvent = event.currentTarget.contentWindow

    @iframeWrapper.appendChild _e
    return _e

  ###
  # Pop-up iframe onto screen
  # @return {void}
  ###
  _showIframe: (params) ->
    # Initial iframe data
    @_popIframeData params

    @iframeWrapper.style.opacity      = "1"
    @iframeWrapper.style.visibility   = "visible"
    @iframe.style.webkitTransform     = "scale(1)"
    @iframe.style.MozTransform        = "scale(1)"
    @iframe.style.msTransform         = "scale(1)"
    @iframe.style.OTransform          = "scale(1)"
    @iframe.style.transform           = "scale(1)"
    @iframe.style.opacity             = "1"

    document.body.style.overflow      = "hidden"
    return

  ###
  # Hide iframe from screen
  # @return {void}
  ###
  _hideIframe: ->
    @iframeWrapper.style.opacity      = "0"
    @iframeWrapper.style.visibility   = "hidden"
    @iframe.style.opacity             = "0"
    @iframe.style.webkitTransform     = "scale(0.1)"
    @iframe.style.MozTransform        = "scale(0.1)"
    @iframe.style.msTransform         = "scale(0.1)"
    @iframe.style.OTransform          = "scale(0.1)"
    @iframe.style.transform           = "scale(0.1)"

    document.body.style.overflow      = ""
    return

  ###
  # Initial iframe data
  # @return {void}
  ###
  _popIframeData: (params) ->
    data =
      key           : params.publicKey
      image         : params.logo
      currency      : params.currency
      location      : params.locationField
      amount        : params.amount
      frameLabel    : params.frameLabel
      submitLabel   : params.submitLabel
      tokenFieldId  : params.tokenFieldId
      submitAuto    : params.submitAuto

    @iframeEvent.postMessage JSON.stringify(data), @serverOrigin
    return

  ###
  # Observe a message of event that send from iframe
  # @return {void}
  ###
  _listenToCardJsIframeMessage: (event) =>
    if !event.origin then return
    if event.origin != @serverOrigin then return

    if event.data == "closeOmiseCardJsPopup"
      @_hideIframe()
    else
      try
        _result = JSON.parse event.data
        _result.submitAuto    = true                                  # Mock-data (Don't forget to remove it)
        _result.tokenFieldId  = "form-class-checkout-us-omiseToken"   # Mock-data (Don't forget to remove it)
        _input = document.getElementById(_result.tokenFieldId)

        if _input?
          _input.value  = _result.omiseToken
          @_hideIframe()

          if _result.submitAuto is true
            _formObject = _input.parentNode
            _formObject.submit()
      catch e
        @_hideIframe()

    return

  ###
  # Create a token field for contain token_id that response from ifram
  # @return {string} Token field id
  ###
  _createTokenField: (form) ->
    _input        = document.createElement('INPUT');
    _input.type   = "text";
    _input.name   = "omiseToken";
    _input.id     = "";

    if form
      switch form[0]
        when "#"
          formElem    = document.getElementById form.substring(1)
          _input.id   = "form-id-#{form.substring(1)}-omiseToken";

        when "."
          formElem    = document.getElementsByClassName form.substring(1)
          formElem    = formElem[0]
          _input.id   = "form-class-#{form.substring(1)}-omiseToken";
        else
          formElem    = document.getElementById(button.target)
          _input.id   = "form-id-#{form.substring(1)}-omiseToken";

      formElem.appendChild _input if !document.getElementById(_input.id)?

    return _input.id

  ###
  # Configure OmiseCard's parameters
  # @param {object} params -
  # @return {void}
  ###
  configure: (params={}) ->
    @_setParams params, @params
    return

  ###
  # Configure button's parameters
  # @param {string} button  - Button target id/class name
  # @param {object} params  - Specific parameters that want to assign into a button
  # @return {void}
  ###
  configureButton: (button, params) ->
    @buttons.push(
        target: button,
        params: @_setParams params, @params, false
    )

  ###
  # Attach OmiseCard's abilities to buttons
  # @return {void}
  ###
  attach: ->
    for button, i in @buttons
      continue if button.params.attached? and button.params.attached is true

      switch button.target[0]
        when "#"
          buttonElem = document.getElementById button.target.substring(1)
        when "."
          buttonElem = document.getElementsByClassName button.target.substring(1)
          buttonElem = buttonElem[0]
        else
          buttonElem = document.getElementById(button.target)

      if buttonElem?
        # Create token field into target form
        button.params.tokenFieldId = @_createTokenField button.params.submitFormTarget

        buttonElem.omiseCardParams = button.params
        buttonElem.addEventListener "click", (event) =>
          event.preventDefault();

          if @iframeWrapper? and @iframe?
            @_showIframe event.target.omiseCardParams

        @buttons[i].params.attached = true

    return

###
--------------------------------------------------------------------------------
Execution part
--------------------------------------------------------------------------------
###

###
Legacy support
Integrate card.js via assign all of params inside data-attribute of <script></script> tag
###
scriptElement = do ->
  target = document.getElementsByTagName 'script'
  target = target[target.length - 1];

scriptParent = do ->
  scriptElement.parentNode

if scriptElement? and scriptElement.getAttribute("data-key")? and scriptElement.getAttribute("data-amount")?
  console.log 'Legacy'

# Create OmiseCard instance variable
OmiseCardInstance = new OmiseCard

# Reset an event listener
window.removeEventListener "message", OmiseCardInstance._listenToCardJsIframeMessage
window.addEventListener "message", OmiseCardInstance._listenToCardJsIframeMessage, false

window._OmiseCard = OmiseCard
window.OmiseCard  = OmiseCardInstance
