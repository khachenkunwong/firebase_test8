//ใช้เพื่อกำหนดเค้าโครงข้อมูลของสินค้า ซึ่งใช้เก็บข้อมูลที่ได้มาจากฐานข้อมูล และถูกนำมาใช้ในการแสดงผล
class ProductModel {
  String id; //เก็บรหัสสินค้า
  String productName; //เก็บชื่อสินค้า
  int price; //ราคาสินค้า
  ProductModel({
    required this.id,
    required this.productName,
    required this.price,
  });
  factory ProductModel.fromMap(Map<String, dynamic>? product) {
    // factory นำหน้า แสดงว่าภายในคอนสตรัคเตอร์ จะต้องรีเทิร์นค่ากลับมาเป็นออบเจ็กต์ของคลาส ProductModel
    //ข้อมูล id เก็บค่าที่ได้มาจากฟิลด์ id ของฐานข้อมูล
    String id = product?['id'];
    //ข้อมูล productName เก็บค่าที่ได้มาจากฟิลด์ productName ของฐานข้อมูล
    String productName = product?['productName'];
    //ข้อมูล price เก็บค่าที่ได้มาจากฟิลด์ price ของฐานข้อมูล
    int price = product?['price'];
    return ProductModel(id: id, productName: productName, price: price);
  }
  Map<String, dynamic> toMap() {
    //สร้างเพื่อเเปลง พร็อพเพอณ์ตี้ภายในออบเจ็กต์ ให้เป็น Map<String, dynamic>ซึ่งเป็นประเภทข้อมูลที่เหมาะสำหรับ Cloud Firestore
    return {
      'id': id,
      'productName': productName,
      'price': price,
    };
  }
}
