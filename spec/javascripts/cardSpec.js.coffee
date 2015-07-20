describe "Configure OmiseCard params", ->
  it "contains spec with an expectation", ->
    OmiseCardParams = OmiseCard.params
    expect(OmiseCardParams).toEqual(
      Object
        amount: 0
        publicKey: ""
        currency: "THB"
        logo: ""
        frameLabel: "Omise Payment Gateway"
        submitLabel: "CHECKOUT"
        buttonLabel: "Pay with Omise"
        locationField: false
        submitFormTarget: ""
        submitAuto: true
      )
