###
# Existing methods assertions
###
describe "The OmiseCard instance object", ->
  beforeEach ->
    @OmiseCardInstance = new _OmiseCard
    return

  afterEach ->
    iframeWrapper  = document.getElementById("OmiseCardJsIFrameWrapper")
    document.body.removeChild iframeWrapper if iframeWrapper?

    delete @OmiseCardInstance
    return

  it "must contain _setParams method", ->
    expect(typeof @OmiseCardInstance._setParams).toEqual("function")

  it "must contain _createIframeWrapper method", ->
    expect(typeof @OmiseCardInstance._createIframeWrapper).toEqual("function")

  it "must contain _createIframe method", ->
    expect(typeof @OmiseCardInstance._createIframe).toEqual("function")
  
  it "must contain _showIframe method", ->
    expect(typeof @OmiseCardInstance._showIframe).toEqual("function")
  
  it "must contain _hideIframe method", ->
    expect(typeof @OmiseCardInstance._hideIframe).toEqual("function")
  
  it "must contain _popIframeData method", ->
    expect(typeof @OmiseCardInstance._popIframeData).toEqual("function")
  
  it "must contain _listenToCardJsIframeMessage method", ->
    expect(typeof @OmiseCardInstance._listenToCardJsIframeMessage).toEqual("function")
  
  it "must contain _createTokenField method", ->
    expect(typeof @OmiseCardInstance._createTokenField).toEqual("function")
  
  it "must contain configure method", ->
    expect(typeof @OmiseCardInstance.configure).toEqual("function")
  
  it "must contain configureButton method", ->
    expect(typeof @OmiseCardInstance.configureButton).toEqual("function")
  
  it "must contain attach method", ->
    expect(typeof @OmiseCardInstance.attach).toEqual("function")
    return

  it "must contain correctly default values", ->
    expect(@OmiseCardInstance.params).toEqual(
      publicKey: ""
      amount: 0
      currency: "THB"
      logo: ""
      frameLabel: "Omise Payment Gateway"
      submitLabel: "CHECKOUT"
      buttonLabel: "Pay with Omise"
      locationField: "no"
      submitFormTarget: ""
      submitAuto: "yes"
    )

  it "must be the same as in window.OmiseCard object", ->
    expect(@OmiseCardInstance).toEqual(OmiseCard)
    return

###
# Configuring OmiseCard's parameter assertions
###
describe "The OmiseCard's configure() method", ->
  beforeEach ->
    @OmiseCardInstance = new _OmiseCard
    return

  afterEach ->
    iframeWrapper  = document.getElementById("OmiseCardJsIFrameWrapper")
    document.body.removeChild iframeWrapper if iframeWrapper?

    delete @OmiseCardInstance
    return

  it "must be able to alter default parameter's values", ->
    @OmiseCardInstance.configure
      publicKey: "my-public-key"
      amount: 50000
      currency: "THBx"
      logo: "//omise.co/img/logo.png"
      frameLabel: "Payment Form"
      submitLabel: "Checkout with Omise"
      buttonLabel: "PAY IT!!"
      locationField: "yes"
      submitFormTarget: "#checkout-form"
      submitAuto: "no"

    expect(@OmiseCardInstance.params).toEqual(
      publicKey: "my-public-key"
      amount: 50000
      currency: "THBx"
      logo: "//omise.co/img/logo.png"
      frameLabel: "Payment Form"
      submitLabel: "Checkout with Omise"
      buttonLabel: "PAY IT!!"
      locationField: "yes"
      submitFormTarget: "#checkout-form"
      submitAuto: "no"
    )

    return

  it "must use the default parameters if it does not set in these argument", ->
    @OmiseCardInstance.configure
      publicKey: "shop-public-key"
      amount: 1000000

    expect(@OmiseCardInstance.params).toEqual(
      publicKey: "shop-public-key"
      amount: 1000000
      currency: "THB"
      logo: ""
      frameLabel: "Omise Payment Gateway"
      submitLabel: "CHECKOUT"
      buttonLabel: "Pay with Omise"
      locationField: "no"
      submitFormTarget: ""
      submitAuto: "yes"
    )
    
    return

  it "must not be able to add undefined parameter", ->
    @OmiseCardInstance.configure
      anotherParam: "can not add this"

    expect(@OmiseCardInstance.params.anotherParam).toBeUndefined()
    return

###
# OmiseCard iframe
###
describe "The OmiseCard's iframe", ->
  beforeEach ->
    @OmiseCardInstance = new _OmiseCard
    return

  afterEach ->
    iframeWrapper  = document.getElementById("OmiseCardJsIFrameWrapper")
    document.body.removeChild iframeWrapper if iframeWrapper?

    delete @OmiseCardInstance
    return

  it "must create after call configure() method", ->
    spyOn( @OmiseCardInstance, '_createIframeWrapper').and.callThrough()
    spyOn( @OmiseCardInstance, '_createIframe').and.callThrough()

    @OmiseCardInstance.configure
      publicKey: "shop-public-key"
      amount: 1000000

    @OmiseCardInstance.configureButton 'my-button'
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance._createIframeWrapper).toHaveBeenCalled()
    expect(@OmiseCardInstance._createIframe).toHaveBeenCalled()
    return

  it "must create only one iframe even call configure() multiple times", ->
    spyOn( @OmiseCardInstance, '_createIframeWrapper').and.callThrough()
    spyOn( @OmiseCardInstance, '_createIframe').and.callThrough()

    @OmiseCardInstance.configure
      publicKey: "shop-public-key"
      amount: 1000000

    @OmiseCardInstance.configureButton 'my-button'
    @OmiseCardInstance.attach()
    @OmiseCardInstance.attach()
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance._createIframeWrapper.calls.count()).toEqual(1)
    expect(@OmiseCardInstance._createIframe.calls.count()).toEqual(1)
    return

  it "must append on the DOM", ->
    @OmiseCardInstance.configure
      publicKey: "shop-public-key"
      amount: 1000000

    @OmiseCardInstance.configureButton 'my-button'
    @OmiseCardInstance.attach()

    expect(document.getElementById("OmiseCardJsIFrameWrapper")).not.toBeNull()
    expect(document.getElementById("OmiseCardJsIFrame")).not.toBeNull()
    return

###
# Configuring button behaviour (attributes)
###
describe "The OmiseCard's button", ->
  beforeEach ->
    # Create new OmiseCard instance
    @OmiseCardInstance = new _OmiseCard

    # Initiate default values
    @OmiseCardInstance.configure
      publicKey: "my-public-key"
      amount: 50000
    return

  afterEach ->
    iframeWrapper  = document.getElementById("OmiseCardJsIFrameWrapper")
    document.body.removeChild iframeWrapper if iframeWrapper?

    delete @OmiseCardInstance
    return

  it "must be an empty array before config it", ->
    expect(@OmiseCardInstance.buttons.length).toEqual(0)
    return

  it "must be able to create a new behaviour", ->
    @OmiseCardInstance.configureButton "MyButton"

    expect(@OmiseCardInstance.buttons.length).toEqual(1)
    return

  it "must be able to create a new behaviour with default values", ->
    @OmiseCardInstance.configureButton "MyButton"

    expect(@OmiseCardInstance.buttons[0].params).toEqual(
      publicKey: "my-public-key"
      amount: 50000
      currency: "THB"
      logo: ""
      frameLabel: "Omise Payment Gateway"
      submitLabel: "CHECKOUT"
      buttonLabel: "Pay with Omise"
      locationField: "no"
      submitFormTarget: ""
      submitAuto: "yes"
    )
    return

  it "must be able to create a new behaviour and alter some of default values", ->
    @OmiseCardInstance.configureButton "MyButton-1",
      amount: 100000

    expect(@OmiseCardInstance.buttons[0].params).toEqual(
      publicKey: "my-public-key"
      amount: 100000
      currency: "THB"
      logo: ""
      frameLabel: "Omise Payment Gateway"
      submitLabel: "CHECKOUT"
      buttonLabel: "Pay with Omise"
      locationField: "no"
      submitFormTarget: ""
      submitAuto: "yes"
    )

  it "possible to contain many behaviours", ->
    @OmiseCardInstance.configureButton "MyButton-1",
      amount: 10000

    @OmiseCardInstance.configureButton "MyButton-3"

    @OmiseCardInstance.configureButton "MyButton-4",
      amount: 30000

    expect(@OmiseCardInstance.buttons[0].params.amount).toEqual(10000)
    expect(@OmiseCardInstance.buttons[1].params.amount).toEqual(50000)
    expect(@OmiseCardInstance.buttons[2].params.amount).toEqual(30000)

    expect(@OmiseCardInstance.params.amount).toEqual(50000)

  it "'attached', 'attachFailed', 'attachFailedMessage' params must be 'undefined' before run .attach() method", ->
    @OmiseCardInstance.configureButton "my-button-1"

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeUndefined()
    expect(@OmiseCardInstance.buttons[0].params.attachFailed).toBeUndefined()
    expect(@OmiseCardInstance.buttons[0].params.attachFailedMessage).toBeUndefined()

###
# Configuring button behaviour (attributes)
###
describe "The OmiseCard's attach() method", ->
  beforeEach ->
    # Create new OmiseCard instance
    @OmiseCardInstance = new _OmiseCard

    # Initiate default values
    @OmiseCardInstance.configure
      publicKey: "my-public-key"
      amount: 50000

    # Create elements
    @_divElem      = document.createElement 'DIV'
    @_divElem.id   = "custom-div"
    document.body.appendChild @_divElem
    return

  afterEach ->
    iframeWrapper  = document.getElementById("OmiseCardJsIFrameWrapper")
    document.body.removeChild iframeWrapper if iframeWrapper?

    div  = document.getElementById("custom-div")
    document.body.removeChild div if div?

    delete @_divElem
    delete @OmiseCardInstance
    return

  it "should be fail because button element did not defined on a page", ->
    # Initiate button behaviour
    @OmiseCardInstance.configureButton "my-button-1"
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeFalsy()
    expect(@OmiseCardInstance.buttons[0].params.attachFailed).toBeTruthy()
    expect(@OmiseCardInstance.buttons[0].params.attachFailedMessage).toEqual("button element not found")
    return

  it "must be able to attach button behaviour into button element", ->
    # Create elements
    _buttonElem            = document.createElement 'BUTTON'
    _buttonElem.id         = "my-button-1"
    
    @_divElem.appendChild _buttonElem

    # Initiate button behaviour
    @OmiseCardInstance.configureButton "my-button-1"
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeTruthy()
    return

  it "must be able to attach button behaviours into multiple button element", ->
    _buttonElem1            = document.createElement 'BUTTON'
    _buttonElem1.id         = "my-button-1"

    _buttonElem2            = document.createElement 'BUTTON'
    _buttonElem2.className  = "my-button-2"

    _buttonElem3            = document.createElement 'BUTTON'
    _buttonElem3.id         = "my-button-3"

    @_divElem.appendChild _buttonElem1
    @_divElem.appendChild _buttonElem2
    @_divElem.appendChild _buttonElem3

    # Initiate button behaviour
    @OmiseCardInstance.configureButton "my-button-1"
    @OmiseCardInstance.configureButton ".my-button-2"
    @OmiseCardInstance.configureButton "#my-button-3"
    @OmiseCardInstance.configureButton ".my-button-4"
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeTruthy()
    expect(@OmiseCardInstance.buttons[1].params.attached).toBeTruthy()
    expect(@OmiseCardInstance.buttons[2].params.attached).toBeTruthy()
    expect(@OmiseCardInstance.buttons[3].params.attached).toBeFalsy()
    expect(@OmiseCardInstance.buttons[3].params.attachFailed).toBeTruthy()
    expect(@OmiseCardInstance.buttons[3].params.attachFailedMessage).toEqual("button element not found")
    return

  it "must create a token field inside a div that button rely on", ->
    # Create a form element
    _formElem            = document.createElement 'FORM'
    _formElem.id         = "my-form"
    @_divElem.appendChild _formElem

    # Create a button element
    _buttonElem            = document.createElement 'BUTTON'
    _buttonElem.id         = "my-button"
    _formElem.appendChild _buttonElem

    # Initiate button behaviour
    @OmiseCardInstance.configureButton "my-button"
    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeTruthy()
    expect(_formElem.getElementsByClassName("omisecardjs-checkout-btn").length).toEqual(1)
    return

  it "must create a token field inside a form target that be set in submitFormTarget parameter", ->
    # Create a form element
    _formElem         = document.createElement 'FORM'
    _formElem.id      = "my-form"
    @_divElem.appendChild _formElem

    # Create a button element
    _buttonElem1      = document.createElement 'BUTTON'
    _buttonElem1.id   = "my-button"
    @_divElem.appendChild _buttonElem1

    # Initiate button behaviour
    @OmiseCardInstance.configureButton "my-button",
      submitFormTarget: "my-form"

    @OmiseCardInstance.attach()

    expect(@OmiseCardInstance.buttons[0].params.attached).toBeTruthy()
    expect(_formElem.getElementsByClassName("omisecardjs-checkout-btn").length).toEqual(1)
    return
