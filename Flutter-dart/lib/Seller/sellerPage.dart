import 'package:flutter/material.dart';
import 'package:hackathon/Seller/sellerProducts.dart';

class SellerPage extends StatefulWidget {
  @override
  _SellerPageState createState() => _SellerPageState();
}

class _SellerPageState extends State<SellerPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            'Fashion Rental',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          backgroundColor: Colors.white,
          actions: [
            IconButton(
              icon: Icon(Icons.list_alt_outlined,
                  color: Color.fromARGB(213, 255, 68, 190)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SellerProducts(),
                  ),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.shopping_bag_outlined,
                  color: Color.fromARGB(213, 255, 68, 190)),
              onPressed: () {
                // Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //     builder: (context) => ShoppingBag(),
                //   ),
                // );
              },
            ),
            // PopupMenuButton<String>(
            //   icon: Icon(Icons.menu, color: Color.fromARGB(213, 255, 68, 190)),
            //   onSelected: (String result) {
            //     if (result == 'show_orders') {
            //       Navigator.push(
            //         context,
            //         MaterialPageRoute(builder: (context) => OrdersPage()),
            //       );
            //     }
            //   },
            //   itemBuilder: (BuildContext context) => [
            //     PopupMenuItem<String>(
            //       value: 'show_orders',
            //       child: Text('Show Orders'),
            //     ),
            //   ],
            // ),
          ],
        ),
        body: Stack(children: [
          Text("data"),
        ]));
  }
}
