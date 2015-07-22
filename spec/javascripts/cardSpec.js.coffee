###
# Existing methods assertions
# 1. Expect that core methods must be exist in the OmiseCard instance
# 2. Expect that a new OmiseCard instance must be the same as in window.OmiseCard instance
###
describe "Existing method assertions", ->
  OmiseCardInstance = {}
  beforeEach ->
    OmiseCardInstance = new _OmiseCard
    return

  # 1
  it "expect that core methods must be exist in the OmiseCard instance", ->
    expect(typeof OmiseCardInstance._setParams).toEqual("function")
    expect(typeof OmiseCardInstance._createIframeWrapper).toEqual("function")
    expect(typeof OmiseCardInstance._createIframe).toEqual("function")
    expect(typeof OmiseCardInstance._showIframe).toEqual("function")
    expect(typeof OmiseCardInstance._hideIframe).toEqual("function")
    expect(typeof OmiseCardInstance._popIframeData).toEqual("function")
    expect(typeof OmiseCardInstance._listenToCardJsIframeMessage).toEqual("function")
    expect(typeof OmiseCardInstance._createTokenField).toEqual("function")
    expect(typeof OmiseCardInstance.configure).toEqual("function")
    expect(typeof OmiseCardInstance.configureButton).toEqual("function")
    expect(typeof OmiseCardInstance.attach).toEqual("function")
    return

  # 2
  it "expect that a new OmiseCard instance must be the same as in window.OmiseCard variable", ->
    expect(OmiseCardInstance).toEqual(OmiseCard)
    return

###
# Configuring OmiseCard's parameter assertions
# 1. Expect that the OmiseCard's default parameters must contain correctly values
# 2. Expect that the configure() method must be able to alter parameter inside OmiseCard.params object
# 3. Expect that the configure() method must be use the default parameter if it is not set with a new value
# 4. Expect that the configure() method must not be able to add any parameter that did not define inside _setParams() method into OmiseCard.params object
###
describe "Configuring OmiseCard's parameter assertions", ->
  OmiseCardInstance = {}
  beforeEach ->
    OmiseCardInstance = new _OmiseCard
    return

  # 1
  it "expect that the OmiseCard's default parameters must contain correctly values", ->
    expect(OmiseCardInstance.params).toEqual(
      Object
        amount: 0
        publicKey: ""
        currency: "THB"
        logo: ""
        frameLabel: "Omise Payment Gateway"
        submitLabel: "CHECKOUT"
        buttonLabel: "Pay with Omise"
        locationField: "no"
        submitFormTarget: ""
        submitAuto: "yes"
    )

  # 2
  it "expect that the configure() method must be able to alter parameter inside OmiseCard.params object", ->
    OmiseCardInstance.configure
      amount: 50000
      publicKey: "my-public-key"
      currency: "THBx"
      logo: "//omise.co/img/logo.png"
      frameLabel: "Payment Form"
      submitLabel: "Checkout with Omise"
      buttonLabel: "PAY IT!!"
      locationField: "yes"
      submitFormTarget: "#checkout-form"
      submitAuto: "no"

    expect(OmiseCardInstance.params.amount).toEqual(50000)
    expect(OmiseCardInstance.params.publicKey).toEqual("my-public-key")
    expect(OmiseCardInstance.params.currency).toEqual("THBx")
    expect(OmiseCardInstance.params.logo).toEqual("//omise.co/img/logo.png")
    expect(OmiseCardInstance.params.frameLabel).toEqual("Payment Form")
    expect(OmiseCardInstance.params.submitLabel).toEqual("Checkout with Omise")
    expect(OmiseCardInstance.params.buttonLabel).toEqual("PAY IT!!")
    expect(OmiseCardInstance.params.locationField).toEqual("yes")
    expect(OmiseCardInstance.params.submitFormTarget).toEqual("#checkout-form")
    expect(OmiseCardInstance.params.submitAuto).toEqual("no")
    return

  # 3
  it "expect that the configure() method must be use the default parameter if it is not set with a new value", ->
    OmiseCardInstance.configure
      amount: 50000
      publicKey: "my-public-key"

    expect(OmiseCardInstance.params.currency).toEqual("THB")
    expect(OmiseCardInstance.params.logo).toEqual("")
    expect(OmiseCardInstance.params.frameLabel).toEqual("Omise Payment Gateway")
    expect(OmiseCardInstance.params.submitLabel).toEqual("CHECKOUT")
    expect(OmiseCardInstance.params.buttonLabel).toEqual("Pay with Omise")
    expect(OmiseCardInstance.params.locationField).toEqual("no")
    expect(OmiseCardInstance.params.submitFormTarget).toEqual("")
    expect(OmiseCardInstance.params.submitAuto).toEqual("yes")
    return

  # 4
  it "expect that the configure() method must not be able to add any parameter that did not define inside _setParams() method into OmiseCard.params object", ->
    OmiseCardInstance.configure
      anotherParam: "can not add this"

    expect(OmiseCardInstance.params.anotherParam).toBeUndefined()
    return

###
# Configuring button behaviour (attributes)
# 1. Expect that the OmiseCard.buttons must be an empty array in the first time initial
# 2. Expect that possible to create a new button behaviour without set any attributes (just inherited all of attributes, value from OmiseCard.params
# 3. Expect that possible to alter some of button's attributes when create a new one of it
# 4. Expect that possible to alter some of button's attributes when create a new one of it - in case of 'multiple buttons'
###
describe "Configuring button behaviour (attributes)", ->
  OmiseCardInstance = {}
  beforeEach ->
    # Create new OmiseCard instance
    OmiseCardInstance = new _OmiseCard

    # Initiate default values
    OmiseCardInstance.configure
      amount: 50000
      publicKey: "my-public-key"

    return

  # 1
  it "expect that the OmiseCard.buttons must be an empty array in the first time initial", ->
    expect(OmiseCardInstance.buttons.length).toEqual(0)

  # 2
  it "expect that possible to create a new button behaviour without set any attributes (just inherited all of attributes, value from OmiseCard.params", ->
    # Configure new button attribute
    OmiseCardInstance.configureButton "MyButton"
    expect(OmiseCardInstance.buttons.length).toEqual(1)
    expect(OmiseCardInstance.buttons[0].params).toEqual(
      Object
        amount: 50000
        publicKey: "my-public-key"
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

  # 3
  it "expect that possible to alter some of button's attributes when create a new one of it", ->
    OmiseCardInstance.configureButton "MyButton-1",
      amount: 100000

    expect(OmiseCardInstance.buttons[0].params.amount).toEqual(100000)
    expect(OmiseCardInstance.params.publicKey).toEqual("my-public-key")
    expect(OmiseCardInstance.params.currency).toEqual("THB")
    expect(OmiseCardInstance.params.logo).toEqual("")
    expect(OmiseCardInstance.params.frameLabel).toEqual("Omise Payment Gateway")
    expect(OmiseCardInstance.params.submitLabel).toEqual("CHECKOUT")
    expect(OmiseCardInstance.params.buttonLabel).toEqual("Pay with Omise")
    expect(OmiseCardInstance.params.locationField).toEqual("no")
    expect(OmiseCardInstance.params.submitFormTarget).toEqual("")
    expect(OmiseCardInstance.params.submitAuto).toEqual("yes")

  # 4
  it "expect that possible to alter some of button's attributes when create a new one of it - in case of 'multiple buttons'", ->
    OmiseCardInstance.configureButton "MyButton-1",
      amount: 10000

    OmiseCardInstance.configureButton "MyButton-2",
      amount: 20000

    OmiseCardInstance.configureButton "MyButton-3"

    OmiseCardInstance.configureButton "MyButton-4",
      amount: 40000

    expect(OmiseCardInstance.buttons[0].params.amount).toEqual(10000)
    expect(OmiseCardInstance.buttons[1].params.amount).toEqual(20000)
    expect(OmiseCardInstance.buttons[2].params.amount).toEqual(50000)
    expect(OmiseCardInstance.buttons[3].params.amount).toEqual(40000)

    expect(OmiseCardInstance.params.amount).toEqual(50000)

###
# Attaching button behaviour (attributes) into button elements of a page
# 1. Expect that 'attached', 'attachFailed', 'attachFailedMessage' params must be 'undefined' before run .attach() method
# 2. Expect that .attach() must be fail because button element did not defined on a page
# 3. Expect that .attach() must be able to attach multiple buttons
###
describe "Attaching button behaviour (attributes) into button elements of a page", ->
  OmiseCardInstance = {}
  beforeEach ->
    # Create new OmiseCard instance
    OmiseCardInstance = new _OmiseCard

    # Initiate default values
    OmiseCardInstance.configure
      amount: 50000
      publicKey: "my-public-key"

    return

  # 1
  it "expect that 'attached', 'attachFailed', 'attachFailedMessage' params must be 'undefined' before run .attach() method", ->
    OmiseCardInstance.configureButton "my-button-1"

    expect(OmiseCardInstance.buttons[0].params.attached).toBeUndefined()
    expect(OmiseCardInstance.buttons[0].params.attachFailed).toBeUndefined()
    expect(OmiseCardInstance.buttons[0].params.attachFailedMessage).toBeUndefined()

  # 2
  it "expect that .attach() must be fail because button element did not defined on a page", ->
    OmiseCardInstance.configureButton "my-button-1"
    OmiseCardInstance.attach()

    expect(OmiseCardInstance.buttons[0].params.attached).toBeFalsy()
    expect(OmiseCardInstance.buttons[0].params.attachFailed).toBeTruthy()
    expect(OmiseCardInstance.buttons[0].params.attachFailedMessage).toEqual("button element not found")

  # 3
  it "expect that .attach() must be able to attach multiple buttons", ->
    # Create elements
    _formElem               = document.createElement 'FORM'
    _formElem.id            = "form-test"

    _buttonElem1            = document.createElement 'BUTTON'
    _buttonElem1.id         = "my-button-1"

    _buttonElem2            = document.createElement 'BUTTON'
    _buttonElem2.className  = "my-button-2"

    _buttonElem3            = document.createElement 'BUTTON'
    _buttonElem3.id         = "my-button-3"

    _formElem.appendChild _buttonElem1
    _formElem.appendChild _buttonElem2
    _formElem.appendChild _buttonElem3
    document.body.appendChild _formElem

    OmiseCardInstance.configureButton "#my-button-1"
    OmiseCardInstance.configureButton ".my-button-2"
    OmiseCardInstance.configureButton "my-button-3"
    OmiseCardInstance.configureButton "my-button-4"

    OmiseCardInstance.attach()

    expect(OmiseCardInstance.buttons[0].params.attached).toBeTruthy()
    expect(OmiseCardInstance.buttons[1].params.attached).toBeTruthy()
    expect(OmiseCardInstance.buttons[2].params.attached).toBeTruthy()
    expect(OmiseCardInstance.buttons[3].params.attached).toBeFalsy()
    expect(OmiseCardInstance.buttons[3].params.attachFailed).toBeTruthy()
    expect(OmiseCardInstance.buttons[3].params.attachFailedMessage).toEqual("button element not found")

    document.body.removeChild _formElem
