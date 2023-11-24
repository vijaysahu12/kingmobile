// import 'package:flutter/material.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
// import 'package:fluttertoast/fluttertoast.dart';

// class RazorPay extends StatefulWidget {
//   const RazorPay({super.key});

//   @override
//   State<RazorPay> createState() => _RazorPay();
// }

// class _RazorPay extends State<RazorPay> {
//   RazorPay? _razorPay;

//   void _handlePaymentSuccess(PaymentSuccessResponse response) {
//     Fluttertoast.showToast(
//         msg: "SUCCESS PAYMENT: ${response.paymentId}", timeInSecForIosWeb: 4);
//   }

//   void _handlePaymentError(PaymentFailureResponse response) {
//     Fluttertoast.showToast(
//         msg: "ERROR HERE: ${response.code}-${response.message}",
//         timeInSecForIosWeb: 4);
//   }

//   void _handleExternalWallet(ExternalWalletResponse response) {
//     Fluttertoast.showToast(
//         msg: "EXTERNAL_WALLET IS: ${response.walletName}",
//         timeInSecForIosWeb: 4);
//   }

//   @override
//   void initState() {
//     super.initState();
//     _razorPay = RazorPay();
//     _razorPay?.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     _razorPay?.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     _razorPay?.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }

//   void makePayment() async {
//     var options = {
//       'key': 'rzp_test_8x2It6dJUckx0i',
//       'amount': '100', //RS 1
//       'name': 'Seshadri Kaku',
//       'description': 'testing Purpose',
//       'prefill': {
//         'contact': '+916309373318',
//         'email': 'kakuseshadri033@gmail.com'
//       },
//     };

//     try {
//       _razorPay.open(options);
//     } catch (e) {
//       print(e);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: EdgeInsets.all(10),
//       child: ElevatedButton(
//         child: Text("make Payment"),
//         onPressed: makePayment,
//       ),
//     );
//   }
// }
