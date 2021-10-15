import 'package:firebase_test8/models/product_model.dart';
import 'package:flutter/material.dart';

import 'product_popup.dart';

const KLeadingText = TextStyle(
  fontSize: 18,
  fontWeight: FontWeight.w300,
  color: Colors.blue,
);
const kTrailingText = TextStyle(
  fontSize: 16,
  fontWeight: FontWeight.w400,
  color: Colors.black87,
);

class ProductItem extends StatelessWidget {
  final ProductModel product;
  ProductItem({required this.product});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showModalBottomSheet(
            backgroundColor: Color(0x00ffffff),
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return ProductPopup(
                product: product,
              );
            });
      },
      child: ListTile(
        leading: Text(
          product.productName,
          style: KLeadingText,
        ),
        title: Text(
          product.price.toStringAsFixed(2),
          style: kTrailingText,
          textAlign: TextAlign.right,
        ),
        trailing: Icon(Icons.chevron_right),
      ),
    );
  }

}
