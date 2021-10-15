import 'package:firebase_test8/models/product_model.dart';
import 'package:firebase_test8/services/database.dart';
import 'package:flutter/material.dart';

import 'product_item.dart';


class ProductLists extends StatelessWidget {
  const ProductLists({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Database db = Database.instance;
    Stream<List<ProductModel>> stream = db.getAllProductStream();
    return Container(
      padding: EdgeInsets.only(top: 10),
      child: StreamBuilder<List<ProductModel>>(
        stream: stream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data?.length == 0) {
              return Center(
                child: Text('ยังไม่มีข้อมูลสินค้า'),
              );
            }
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context, index) {
                return Dismissible(
                  key: UniqueKey(),
                  child: ProductItem(
                    product: snapshot.data![index],
                  ),
                  onDismissed: (direction) {
                    if (direction == DismissDirection.endToStart) {
                      db.deleteProduct(product: snapshot.data?[index]);
                    }
                  },
                  background: Container(color: Colors.red,),
                  direction: DismissDirection.endToStart,
                );
              },
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
