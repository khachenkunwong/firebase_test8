import 'package:firebase_test8/widgets/product_lists.dart';
import 'package:firebase_test8/widgets/product_popup.dart';
import 'package:flutter/material.dart';

class ProductView extends StatefulWidget {
  const ProductView({Key? key}) : super(key: key);

  @override
  _ProductViewState createState() => _ProductViewState();
}

class _ProductViewState extends State<ProductView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product View'),
        actions: [
          IconButton(
            onPressed: () {
              showModalBottomSheet(
                  backgroundColor: const Color(0x00ffffff),
                  isScrollControlled: true,
                  context: context,
                  builder: (context) {
                    return ProductPopup();
                  });
            },
            icon: const Icon(Icons.add),
          )
        ],
      ),
      body: const ProductLists(),
    );
  }
}
