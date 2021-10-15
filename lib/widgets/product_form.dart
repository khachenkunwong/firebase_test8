import 'package:firebase_test8/models/product_model.dart';
import 'package:firebase_test8/services/database.dart';
import 'package:flutter/material.dart';

class ProductForm extends StatefulWidget {
  final ProductModel? product; //เก็บสินค้าที่จะแก้ไข
  ProductForm({this.product});
  @override
  _ProductFormState createState() => _ProductFormState();
}
class _ProductFormState extends State<ProductForm> {
  Database db = Database.instance;
  TextEditingController nameController = TextEditingController();//สำหรับควบคุมและติดตามราคาสินค้าในแบบฟอร์ม
  TextEditingController priceController = TextEditingController();
  @override
  void initState() {
    super.initState();
    if (widget.product != null) { //ตรวจสอบข้อมูลว่ามีสินค้าส่งมาหรือไม่ หากมีสินค้าส่งมาแสดงว่าเป็นการแก้ไขข้อมูลสินค้า
      nameController.text = widget.product!.productName;// เป็นการแสดงรายชื่อสินค้าที่แบบฟอร์ม
      priceController.text = widget.product!.price.toString();// เป็นการเเสดงราคาที่แบบฟอร์ม
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(widget.product != null //ตรวจสอบว่ามีข้อมูลสินค้าเข้ามาในวิดเจ็ตหรือไม่
              ? 'แก้ไข ${widget.product?.productName}'//หากมีสินค้า
              : 'เพิ่มสิ้นค้าใหม่'),
          TextField(
            controller: nameController,
            keyboardType: TextInputType.text,
            decoration: InputDecoration(labelText: 'ชื่อสินค้า'),
          ),
          TextField(
            controller: priceController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: 'ราคาสินค้า'),
          ),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _showOKButton(),
              SizedBox(width: 20),
              _showCancelButton(context),
            ],
          ),
        ],
      ),
    );
  }
  Widget _showOKButton() {
    return ElevatedButton(
      onPressed: () async {

        String newProductId =
            'PD${DateTime.now().millisecondsSinceEpoch.toString()}';
        // newProductId เพื่อกำหนดรหัสเอกสารที่จะเขียนลงในฐานข้อมูล
        // แปลงวันเวลาปัจจุบันให้กลายเป็นตัวเลขแสดงจำนวนมิลลิวินาทีจากปี 1970 ไปใช้เป็นรหัสเอกสาร
        await db.setProduct( //ใช้ setProduct เพื่อเพิ่มหรือแก้ไขเอกสารไปยังฐานข้อมูล Cloud Firestore
          product: ProductModel(
            id: widget.product == null ? newProductId : widget.product!.id,
            productName: nameController.text,
            price: int.tryParse(priceController.text) ?? 0,//double.tryParse แปลงเป็นเลขทศนิยม ถ้าไม่สำเร็จก็จะใช้ค่า 0 แทน
          ),
        );
        nameController.clear();//เคลียณข้อความที่อินพุตชื่อสินค้า
        priceController.clear();
        Navigator.of(context).pop();
      },
      child: Text(widget.product == null ? 'เพิ่ม' : 'แก้ไข'),
    );
  }
  Widget _showCancelButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: Text('ปิด'),
    );
  }
}
