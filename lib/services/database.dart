import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_test8/models/product_model.dart';



// ใช้เพื่อติดต่อและจัดการข้อมูลไปยังฐานข้อมูลไปยังฐานข้อมูล Cloud Firestore เช้นการติดตามข้อมูลสินค้า การเพิ่มข้อมูล
// การแก้ไขข้อมูล และการลบข้อมูลสินค้า
class Database {
  static Database instance = Database._();
  Database._();
  //ดูรายการสินค้า
  Stream<List<ProductModel>> getAllProductStream() {
    //เลือก collection products
    final reference = FirebaseFirestore.instance.collection('products');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ price
    final query = reference.orderBy('price', descending: true);
    final snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      return snapshot.docs.map((doc) {
        return ProductModel.fromMap(doc.data());
      }).toList();
    });
  }

  //แก้ไขสินค้า
  Future<void> setProduct({ProductModel? product}) async {
    final reference = FirebaseFirestore.instance.doc('products/${product?.id}');
    try {
      await reference.set(product!.toMap());
    } catch (err) {
      rethrow;
    }
  }
  // ลบ สินค้า
  Future<void> deleteProduct({ProductModel? product}) async {
    final reference = FirebaseFirestore.instance.doc('products/${product?.id}');
    try {
      await reference.delete();
    } catch (err) {
      rethrow;
    }
  }
  // เพิ่มสินค่า
  Future<void> addSampleProducts(List<ProductModel> allProducts) async {
    // เขียนรายการสินค้าไปยังคอลเล็กชัน products โดยผ่านค่าพารามิเตอร์ ในแบบList<ProductModel> ซึ้งหมายถึง รายการสินค้าทั้งหมดที่จะเขียนไปยังฐานข้อมูล
    allProducts.forEach((newProduct) async {
      //นำid ทั้งหมดออกมาจากฐานข้อมูลเรียงลงมา
      final reference =
          FirebaseFirestore.instance.doc('products/${newProduct.id}');
      try {
        await reference.set(newProduct
            .toMap()); // set() เพื่อนำเอาสินค้าแต่ละรายการเขียนลงฐานข้อมูล
      } catch (err) {
        rethrow;
      }
    });
  }

  
  
}
