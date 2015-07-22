"use strict"

class OmiseCard
  constructor: (params={}) ->
    # Define construct variables
    @params       = {}
    @buttons      = []
    @iframeEvent  = {}
    @serverOrigin = "http://localhost:4567"
    # @serverOrigin = "https://card.omise.co"

    # Initiate OmiseCard's default parameters
    @_setParams()

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
  # @param {boolean} [_overrideDefault=true]                    -
  # @return {object}
  ###
  _setParams: (params={}, _overrideDefault=true) ->
    _p =
      amount            : params.amount || @params.amount || 0
      publicKey         : params.publicKey || @params.publicKey || ""
      currency          : params.currency || @params.currency || "THB"
      logo              : params.logo || @params.logo || ""
      frameLabel        : params.frameLabel || @params.frameLabel || "Omise Payment Gateway"
      submitLabel       : params.submitLabel || @params.submitLabel || "CHECKOUT"
      buttonLabel       : params.buttonLabel || @params.buttonLabel || "Pay with Omise"
      locationField     : params.locationField || @params.locationField || "no"
      submitFormTarget  : params.submitFormTarget || @params.submitFormTarget || ""
      submitAuto        : params.submitAuto || @params.submitAuto || "yes"

    @params = _p if _overrideDefault is true
    return _p

  ###
  # Iframe's wrapper initial function
  # @return {object} An iframe wrapper element
  ###
  _createIframeWrapper: ->
    _elem                          = document.createElement("DIV")
    _elem.id                       = "OmiseCardJsIFrameWrapper"
    _elem.style.backgroundColor    = 'rgba(' + [0,0,0,0.88].join(',') + ')'
    _elem.style.visibility         = "hidden"
    _elem.style.zIndex             = "9990"
    _elem.style.position           = "fixed"
    _elem.style.top                = "0px"
    _elem.style.left               = "0px"
    _elem.style.width              = "100%"
    _elem.style.height             = "100%"
    _elem.style.overflowX          = "hidden"
    _elem.style.opacity            = "0"
    _elem.style.border             = "none"

    document.body?.appendChild(_elem)
    return _elem

  ###
  # Iframe initial function
  # @return {object} An iframe element
  ###
  _createIframe: ->
    _elem                          = document.createElement("IFRAME")
    _elem.id                       = "OmiseCardJsIFrame"
    _elem.src                      = @serverOrigin + "/index.html"
    _elem.style.width              = "100%"
    _elem.style.height             = "100%"
    _elem.style.border             = "none"
    _elem.style.margin             = "0"
    _elem.style.opacity            = "0"
    _elem.style.webkitTransform    = "scale(0.1)"
    _elem.style.MozTransform       = "scale(0.1)"
    _elem.style.msTransform        = "scale(0.1)"
    _elem.style.OTransform         = "scale(0.1)"
    _elem.style.transform          = "scale(0.1)"
    _elem.style.setProperty("-webkit-transition", "200ms opacity ease, -webkit-transform 200ms")
    _elem.style.setProperty("-moz-transition", "200ms opacity ease, -moz-transform 200ms")
    _elem.style.setProperty("-ms-transition", "200ms opacity ease, -ms-transform 200ms")
    _elem.style.setProperty("-o-transition", "200ms opacity ease, -o-transform 200ms")
    _elem.style.setProperty("transition", "200ms opacity ease, transform 200ms")

    _elem.addEventListener "load", (event) =>
      @iframeEvent = event.currentTarget.contentWindow

    @iframeWrapper.appendChild _elem
    return _elem

  ###
  # Pop-up iframe onto a screen
  # @param {object} params
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
  # Hide iframe from a screen
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
  # @param {object} params
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
  _listenToCardJsIframeMessage: ->
    _listener = (event) =>
      if !event.origin then return
      if event.origin != @serverOrigin then return

      if event.data == "closeOmiseCardJsPopup"
        @_hideIframe()
      else
        try
          _result = JSON.parse event.data
          _input  = document.getElementById(_result.tokenFieldId)

          if _input?
            _input.value  = _result.omiseToken
            @_hideIframe()

            if _result.submitAuto is "yes"
              _formObject = _input.parentNode
              _formObject.submit()
        catch e
          console.log e
          @_hideIframe()

    window.removeEventListener "message", _listener
    window.addEventListener "message", _listener, false
    return

  ###
  # Create a token field for contain token_id that response from ifram
  # @param {string} form
  # @param {DOM-object} buttonElem
  # @param {object} button
  # @return {string} Token field id
  ###
  _createTokenField: (form, buttonElem, button) ->
    _inp            = document.createElement 'INPUT'
    _inp.type       = "text"
    _inp.name       = "omiseToken"
    _inp.id         = ""
    _inp.className  = "omisecardjs-checkout-btn"

    if form
      _inp.id   = if form.match /^([.#])(.+)/ then "form-#{form.substring(1)}-omiseToken" else "form-#{form}-omiseToken"
      _formElem = switch form[0]
        when "#" then document.getElementById form.substring(1)
        when "." then (document.getElementsByClassName form.substring(1))[0]
        else document.getElementById form

    if !_formElem?
      _formElem = buttonElem.parentNode
      _inp.id   = "form-#{if form.match /^([.#])(.+)/ then button.target.substring(1) else button.target}-omiseToken"

    _formElem.appendChild _inp if !document.getElementById(_inp.id)?
    return _inp.id

  ###
  # Generate button element on-the-fly
  # @param {object} button
  # @return {DOM-object} Button element
  ###
  _generateButton: (button) ->
    _btnElem              = document.createElement 'BUTTON'
    _btnElem.id           = button.target
    _btnElem.textContent  = button.params.buttonLabel

    _target = document.getElementsByTagName 'script'
    _target = _target[_target.length - 1]

    _target.parentNode.appendChild _btnElem
    return _btnElem

  ###
  # Configure OmiseCard's parameters
  # @param {object} params -
  # @return {void}
  ###
  configure: (params={}) ->
    @_setParams params

    # Initiate OmiseCard's iframe
    @iframeWrapper  = @_createIframeWrapper() if !@iframeWrapper?
    @iframe         = @_createIframe() if !@iframe?

    @_listenToCardJsIframeMessage()

    return

  ###
  # Configure button's parameters
  # @param {string} button                  - Button target id/class name
  # @param {object} params                  - Specific parameters that want to assign into a button
  # @param {boolean} [generateButton=false] -
  # @return {void}
  ###
  configureButton: (button, params={}, generateButton=false) ->
    @buttons.push(
        target: button,
        generateButton: generateButton
        params: @_setParams params, false
    )

  ###
  # Attach OmiseCard's abilities to buttons
  # @return {void}
  ###
  attach: ->
    for button, i in @buttons
      continue if button.params.attached? and button.params.attached is true

      if button.generateButton is true
        buttonElem = @_generateButton button
      else
        buttonElem = switch button.target[0]
          when "#" then document.getElementById button.target.substring(1)
          when "." then (document.getElementsByClassName button.target.substring(1))[0]
          else document.getElementById(button.target)

      if buttonElem?
        # Create token field into target form
        button.params.tokenFieldId = @_createTokenField button.params.submitFormTarget, buttonElem, button

        buttonElem.omiseCardParams = button.params
        buttonElem.addEventListener "click", (event) =>
          event.preventDefault()

          if @iframeWrapper? and @iframe?
            @_showIframe event.target.omiseCardParams

        @buttons[i].params.attached             = true
        @buttons[i].params.attachFailed         = false
        @buttons[i].params.attachFailedMessage  = ""
      else
        @buttons[i].params.attached             = false
        @buttons[i].params.attachFailed         = true
        @buttons[i].params.attachFailedMessage  = "button element not found"

    return

###
--------------------------------------------------------------------------------
Execution part
--------------------------------------------------------------------------------
###

# Create OmiseCard instance variable
OmiseCardInstance = new OmiseCard

###
Legacy support
Integrate card.js via assign all of params inside data-attribute of <script></script> tag
###
scriptElement = do ->
  target = document.getElementsByTagName 'script'
  target = target[target.length - 1]

scriptParent = do ->
  scriptElement.parentNode

if scriptElement? and scriptElement.getAttribute("data-key")? and scriptElement.getAttribute("data-amount")?
  OmiseCardInstance.configure
    amount            : scriptElement.getAttribute("data-amount")
    publicKey         : scriptElement.getAttribute("data-key")
    currency          : scriptElement.getAttribute("data-currency")
    logo              : scriptElement.getAttribute("data-image")
    frameLabel        : scriptElement.getAttribute("data-frame-label")
    submitLabel       : scriptElement.getAttribute("data-submit-label")
    buttonLabel       : scriptElement.getAttribute("data-button-label")
    locationField     : scriptElement.getAttribute("data-location")
    submitFormTarget  : scriptElement.getAttribute("data-form-target")
    submitAuto        : scriptElement.getAttribute("data-submit-auto")

  OmiseCardInstance.configureButton "omisecardjs-legacy-checkout-btn", {}, true
  OmiseCardInstance.attach()


# Export to global variable
window._OmiseCard = OmiseCard
window.OmiseCard  = OmiseCardInstance
