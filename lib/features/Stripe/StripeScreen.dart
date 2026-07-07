import 'package:firebaseexample/core/services/stripe_service.dart';
import 'package:flutter/material.dart';

class StripeScreen extends StatefulWidget {
  const StripeScreen({super.key});

  @override
  State<StripeScreen> createState() => _StripeScreenState();
}

class _StripeScreenState extends State<StripeScreen> {
  String result = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stripe Demo")),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                final success = await StripeService.instance.makePayment(
                  amount: 100,
                  currency: "usd",
                  merchantName: "My App",
                );

                setState(() {
                  result = success ? "Payment Success" : "Payment Failed";
                });

                debugPrint(result);
              },
              child: const Text("Pay"),
            ),

            const SizedBox(height: 20),

            Text(
              result,
              style: const TextStyle(fontSize: 18, color: Colors.black),
            ),

           
           
          ],
        ),
      ),
    );
  }
}
