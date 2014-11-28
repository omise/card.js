Card.js
=======


Getting started
---------------

Card.js is built on top of Omise.js enables you to easily integrate a payment form into your website, tablet or mobile device. Card.js creates an Omise.js token that you can use to create a charge with another Omise API client library (ruby, .net, ...) or with Omise Rest API.

Installation
------------

Include the card.js from Omise CDN to your checkout form as below

```html
<html>
...
<body>
<form name="checkoutForm" method="POST" action="test.html">
    <script type="text/javascript" src="https://omise-cdn.s3.amazonaws.com/card.js"
      data-key="YOUR_PUBLIC_KEY"
      data-amount="10025"
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

Card.js will render a "Pay now" button which when a user click at the payout button, a popup window with a credit card form will be displayed. The user will then fill out the credit card information and submit. If success, the popup will be closed and your form will be automatically submit to your server. Otherwise there will be the error information shown.

