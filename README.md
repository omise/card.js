[![Circle CI](https://circleci.com/gh/omise/card.js.svg?style=svg)](https://circleci.com/gh/omise/card.js)

Card.js
=======

[Read the full documentation](https://docs.omise.co/card-js-api/)

Getting started
---------------

Card.js is built on top of Omise.js which enables you to easily integrate a payment form into your website, tablet or mobile device. Card.js creates a token that you can send to your server to create a charge using another Omise API client library, such as ruby, nodejs, python, php, or with Omise Rest API.

Installation
------------

Include the card.js from Omise CDN to your checkout form as below
Available CDNs are:  

- [https://cdn.omise.co/card.js.gz](https://cdn.omise.co/card.js.gz)
- [https://cdn2.omise.co/card.js.gz](https://cdn2.omise.co/card.js.gz)

```html
<html>
...
<body>
<form name="checkoutForm" method="POST" action="test.html">
    <!--Sample checkout for a 995.00 THB charge-->
    <script type="text/javascript" src="https://cdn.omise.co/card.js.gz"
      data-key="YOUR_PUBLIC_KEY"
      data-amount="99500"
      data-currency="thb"
      data-frame-label="Merchant site name">
    </script>
</form>
</body>
</html>
```

*_Note that the data-amount attribute requires the amount to be paid in Satangs (100 Satangs = 1 THB)._*

How it works
------------

Card.js will render a "Pay now" button which when a user click at the payout button, a popup window with a credit card form will be displayed. The user will then fill out the credit card information and submit. If successful, the popup will be closed and your form will be automatically submitted to your server. Otherwise there will be an error information shown.  

Full documentation: [https://docs.omise.co/card-js/](https://docs.omise.co/card-js-api/) 
