import 'package:flutter/material.dart';

class DrinkDetailPage extends StatelessWidget {
  final Map<String, dynamic> drink;

  DrinkDetailPage({required this.drink});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(drink["name"] ?? "Chi tiết sản phẩm"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.fastfood, size: 100, color: Colors.blue), // Ảnh mặc định
            SizedBox(height: 20),
            Text(
              drink["name"] ?? "Không có tên",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              drink["description"]?.toString() ?? "Không có mô tả.",
              style: TextStyle(fontSize: 16, color: Colors.grey[700]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 10),
            Text(
              "Giá: ${drink["price"]?.toString() ?? "Không có thông tin"} VND",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Nút quay lại
              },
              child: Text("Quay lại"),
            ),
          ],
        ),
      ),
    );
  }
}
