Card.js
=======

[Read the full documentation](https://docs.omise.co/card-js/)

Getting started
---------------

Card.js is built on top of Omise.js which enables you to easily integrate a payment form into your website, tablet or mobile device. Card.js creates a token that you can send to your server to create a charge using another Omise API client library, such as ruby, nodejs, python, php, or with Omise Rest API.

Installation
------------

Include the card.js from Omise CDN to your checkout form as below
Available CDNs are:  
- Singapore: `https://cdn.omise.co/card.js`
- Japan: `https://cdn2.omise.co/card.js`


```html
<html>
...
<body>
<form name="checkoutForm" method="POST" action="test.html">
    <!--Sample checkout for a 995.00 THB charge-->
    <script type="text/javascript" src="https://cdn.omise.co/card.js"
      data-key="YOUR_PUBLIC_KEY"
      data-amount="99500"
      data-currency="thb"
      data-frame-label="Merchant site name">
    </script>
</form>
</body>
</html>
```

Note that the data-amount attribute requires the amount to be paid in Satangs (100 Satangs = 1 THB).

How it works
------------

Card.js will render a "Pay now" button which when a user click at the payout button, a popup window with a credit card form will be displayed. The user will then fill out the credit card information and submit. If successful, the popup will be closed and your form will be automatically submitted to your server. Otherwise there will be an error information shown.  

Custom Integration
------------------

The custom integration allows you to attach `card.js button behaviour` into your own custom button, These steps are as follows:
- Include the **card.js** from Omise CDN to your checkout page
- Use `OmiseCard.configure` to configuring your credential or/and your checkout information such as amount or publicKey
- Then, use `OmiseCard.configureButton` to configuring the `card.js button behaviour` that you want to attach it to your button. First argunment is for `button name` that reference to `id` or `class` attribute of button
- After that, call `OmiseCard.attach()` method in the buttom of the page to attach all of your config to button elements in your checkout page

Here is an example for custom integration with Card.js

```html
<html>
...
<body>
<script type="text/javascript" src="https://cdn.omise.co/card-2.0.0.js"></script>
<script type="text/javascript">
    // Set default parameters
    OmiseCard.configure({
        publicKey: 'YOUR_PUBLIC_KEY',
        amount: 99500
    });
    
    // Configuring your own custom button
    OmiseCard.configureButton('#checkout-button-1', {
        frameLabel: 'Merchant site name',
        submitLabel: 'PAY NOW',
    });
</script>

<form name="checkoutForm" method="POST" action="test.html">
    <!--Sample checkout for a 995.00 THB charge-->
    <button type="submit" id="checkout-button-1">Checkout</button>
</form>

<script type="text/javascript">OmiseCard.attach();</script>
</body>
</html>
```

### Multiple Buttons
Custom integration also support `multiple buttons` in the same page. It is possible to create many of `card.js button behaviour` by call the `OmiseCard.configureButton` and assign the first argument with any of your button id (or class) name.

```html
<script type="text/javascript">
    // Set default parameters
    OmiseCard.configure({
        publicKey: 'YOUR_PUBLIC_KEY',
        amount: 99500,
        frameLabel: 'Merchant site name'
    });
        
    // Configuring your button <button type="submit" id="checkout-button-1">PAY IT with ...</button>
    OmiseCard.configureButton('#checkout-button-1');
    
    // Configuring your button <button type="submit" class="checkout-button-2">PAY IT NOW!</button>
    OmiseCard.configureButton('.checkout-button-2');
</script>

<form name="checkoutForm" method="POST" action="test.html">
    <!--Sample checkout for a 995.00 THB charge-->
    <button type="submit" id="checkout-button-1">PAY IT with ...</button>
    <button type="submit" class="checkout-button-2">PAY IT NOW!</button>
</form>

<script type="text/javascript">OmiseCard.attach();</script>
```

### Specify a checkout form
In some situations that the checkout button is not append in the right checkout form. You can set the `submitFormTarget` to reference the form that you want to submit it into the `card.js button behaviour`. After you submiting your credit card with `card.js form`, it will look into your `submitFormTarget` config and append the `Token Field` into that form. Then, submit it.
```html
<script type="text/javascript">
    // Set default parameters
    OmiseCard.configure({
        publicKey: 'YOUR_PUBLIC_KEY',
        amount: 99500,
        frameLabel: 'Merchant site name',
        submitFormTarget: '#my-custom-checkout-form'
    });
    
    OmiseCard.configureButton('#checkout-button');
</script>

<div class="wrong-place-button-appened">
    <button type="submit" id="checkout-button">CHECK OUT!</button>
</div>

<form name="checkoutForm" method="POST" action="test.html"></form>

<script type="text/javascript">OmiseCard.attach();</script>
```

### Override the config
Also, it is possible to override the default parameters config. For instant, you might be create two buttons that the first button to check out your order with an original price and second button for a discount price that will show when user input some of coupon code.
```html
<script type="text/javascript">
    // Set default parameters
    OmiseCard.configure({
        publicKey: 'YOUR_PUBLIC_KEY',
        amount: 1000000, // 10,000 THB
        frameLabel: 'Merchant site name'
    });
    
    OmiseCard.configureButton('#checkout-button');
    OmiseCard.configureButton('#discount-button', {
        amount: 500000 // 5,000 THB
    });
</script>

<form name="checkoutForm" method="POST" action="test.html">
    <!--Sample checkout for a 10,000.00 THB charge-->
    <button type="submit" id="checkout-button">CHECK OUT</button>

    <button type="submit" id="discount-button">LUCKY! DISCOUNT 50%</button>
</form>

<script type="text/javascript">OmiseCard.attach();</script>
```

Full documentation: [https://docs.omise.co/card-js/](https://docs.omise.co/card-js/) 
