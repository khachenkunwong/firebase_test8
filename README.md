# ทดสอบเชื่อม Firebase

พัฒนาแอปพลิเคชันด้วย Flutter

## ผู้พัฒนาแอปพลิเคชัน

- นาย คเชนทร์ กุลวงศ์ รหัสนิสิต 62020538

## รายละเอียดระบบ

### Product View
[![image.png](https://i.postimg.cc/LXfMQj8P/image.png)](https://postimg.cc/629Sy2R6)

- หน้า Product View ได้ใช้ Cloud Firestore ในการแสดง เพิ่ม ลบ แก้ไข สินค้า
 - กดบวกเพื่อเพิ่มรายการสินค้า
 - กดที่สินค้าเพื่อเเก้ไขสินค้า
 - กดรายการสินค้าแล้วเลื่อนไปทางซ้ายเพื่อลบสินค้า

### เพิ่ม

[![image.png](https://i.postimg.cc/q7WLw5qk/image.png)](https://postimg.cc/5HqLNp8G)
[![Screenrecording-25641015-143945.gif](https://i.postimg.cc/8CtnNHZW/Screenrecording-25641015-143945.gif)](https://postimg.cc/WDq77MLb)

- หน้าเพิ่มสินค้า

### ลบ

[![Screenrecording-25641015-143915.gif](https://i.postimg.cc/L5XSm5k4/Screenrecording-25641015-143915.gif)](https://postimg.cc/N9WS4gPZ)

- ลบสินค้า

### แก้ไข

[![image.png](https://i.postimg.cc/ydwbJNcy/image.png)](https://postimg.cc/jw4Xmt8D)
[![Screenrecording-25641015-144004.gif](https://i.postimg.cc/wv4PcVJH/Screenrecording-25641015-144004.gif)](https://postimg.cc/G8YqbvqS)

- หน้าเเก้สินค้า

### Cloud Firestore
[![image.png](https://i.postimg.cc/nLTscj8N/image.png)](https://postimg.cc/jWwqMjSh)
### Model
```dart
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
  //สร้างเพื่อเเปลง พร็อพเพอณ์ตี้ภายในออบเจ็กต์ ให้เป็น Map<String, dynamic>ซึ่งเป็นประเภทข้อมูลที่เหมาะสำหรับ Cloud Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productName': productName,
      'price': price,
    };
  }
}
```

### ดูสินค้า

```dart 
Stream<List<ProductModel>> getAllProductStream() {//1
    //เลือก collection products
    final reference = FirebaseFirestore.instance.collection('products');
    //เรียงเอกสารจากมากไปน้อย โดยใช้ ฟิลด์ price
    final query = reference.orderBy('price', descending: true);//2
    final snapshots = query.snapshots();//3
    return snapshots.map((snapshot) {//4
      return snapshot.docs.map((doc) {//5
        return ProductModel.fromMap(doc.data());//6
      }).toList();//7
    });
}
```
อธิบายตามหัวข้อใน ที่ Comment ตัวเลขใน code
- 1 ประกาศฟังชัน 'getAllProductStream()'. โดยผลที่รีเทิร์นกลับมาเป็น Stream 
- 2 ประกาศตัวแปร query เพื่อเก็บ Query ออบเจ็กต์โดยเงื่อนไขของคิวรีคือเรียงลำดับจากมากไปน้อยตาม ฟิลด์ price 'descending:' ถ้าเป็น false จะเรียงจากน้อยไปมาก ถ้าเป็น ture จะเรียงจากมากไปน้อย 'Query<Map<String, dynamic>>'
- 3 เรียกใช้เมธอด 'snapshots()' เพื่อทำเป็น Stream ซึ้งเก็บข้อมูลของคอลเล็กชันในขณะนั้นอยู่ 'Stream<QuerySnapshot<Map<String, dynamic>>>'
- 4 เรียกใช้เมธอด 'map()' โดยมีตัวเเปล snapshot ที่เป็น QuerySnapshot ออเจ็กที่มาจาก Stream
- 5 ข้อมูลทั้งหมดจะอยู่ใน 'snapshot.docs' ซึ่งเป็นข้อมูลเเบบ 'QueryDocumentSnapshot<Map<String, dynamic>>' เพื่อนำมาใช้งานเราจำเป็นต้องใช้ 'map()' เพื่อเเปลงจาก QueryDocumentSnapshot เป็น 'Map<String, dynamic>' อีกครั้งหนึ่ง
- 6 เป็นการรีเทร์นข้อมูลแต่ละชุดออกมา 
- 7 ต้องใช้ 'toList()' เพื่อเเปลง Iterable เป็น list

โดยที่เราใช้ Stream เพราะจะได้ดูข้อมูลเเบบเรียลไทม์

### เพิ่มสินค้า

```dart
// เขียนรายการสินค้าไปยังคอลเล็กชัน products โดยผ่านค่าพารามิเตอร์ ในแบบList<ProductModel> ซึ้งหมายถึง รายการสินค้าทั้งหมดที่จะเขียนไปยังฐานข้อมูล
  Future<void> addSampleProducts(List<ProductModel> allProducts) async {
    //นำid ทั้งหมดออกมาจากฐานข้อมูลเรียงลงมา
    allProducts.forEach((newProduct) async {
        //เลือก collection products ตามด้วย document เเล้วเอามาเก็บใน reference
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
```

### ลบสินค้่า

```dart
  Future<void> deleteProduct({ProductModel? product}) async {
      //เลือก collection products ตามด้วย document เเล้วเอามาเก็บใน reference
    final reference = FirebaseFirestore.instance.doc('products/${product?.id}');
    try {
      await reference.delete();  //ทำการลบ document นั้นออก
    } catch (err) {
      rethrow;
    }
}
```
### แก้ไขสินค้า

```dart
  Future<void> setProduct({ProductModel? product}) async {
      //เลือก collection ที่ต้องการตามด้วย document เเล้วเอามาเก็บใน reference
    final reference = FirebaseFirestore.instance.doc('products/${product?.id}');
    try {
      await reference.set(product!.toMap());
    } catch (err) {
      rethrow;
    }
  }
```



