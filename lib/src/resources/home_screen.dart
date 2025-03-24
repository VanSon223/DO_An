import 'package:flutter/material.dart';
import 'drink_detail_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {
  TabController? _tabController;
  Map<String, int> cart = {}; // Giỏ hàng

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }

  // Dữ liệu sản phẩm
  final List<Map<String, dynamic>> drinks = [
    {"name": "Coca Cola", "description": "Nước ngọt có ga", "price": 12000},
    {"name": "Pepsi", "description": "Pepsi vị ngọt đậm", "price": 11000},
  ];

  final List<Map<String, dynamic>> foods = [
    {"name": "Bánh mì", "description": "Bánh mì giòn tan", "price": 15000},
  ];

  final List<Map<String, dynamic>> households = [
    {"name": "Nước rửa chén", "description": "Làm sạch dầu mỡ", "price": 25000},
  ];

  final List<Map<String, dynamic>> snacks = [
    {"name": "Snack khoai tây", "description": "Giòn tan, thơm ngon", "price": 10000},
  ];

  List<Map<String, dynamic>> get allProducts => [...drinks, ...foods, ...households, ...snacks];

  // Lấy giá sản phẩm
  double getPrice(String productName) {
    var product = allProducts.firstWhere((p) => p["name"] == productName, orElse: () => {});
    return product.isNotEmpty ? product["price"].toDouble() : 0.0;
  }

  // Đếm tổng số sản phẩm trong giỏ hàng
  int getCartItemCount() {
    return cart.values.fold(0, (sum, quantity) => sum + quantity);
  }

  // Thêm sản phẩm vào giỏ hàng
  void addToCart(String productName) {
    setState(() {
      cart[productName] = (cart[productName] ?? 0) + 1;
    });
    showCartDialog();
  }

  // Tính tổng tiền giỏ hàng
  double calculateTotal() {
    return cart.entries.fold(0, (total, entry) {
      return total + getPrice(entry.key) * entry.value;
    });
  }

  // Hiển thị giỏ hàng
  void showCartDialog() {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(16),
          height: 400,
          child: Column(
            children: [
              Text("🛒 Giỏ Hàng", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Divider(),
              Expanded(
                child: cart.isEmpty
                    ? Center(child: Text("Giỏ hàng trống!"))
                    : ListView(
                  children: cart.keys.map((item) {
                    return ListTile(
                      title: Text(item),
                      subtitle: Text("Giá: ${getPrice(item).toStringAsFixed(0)} VND"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.red),
                            onPressed: () {
                              setState(() {
                                if (cart[item]! > 1) {
                                  cart[item] = cart[item]! - 1;
                                } else {
                                  cart.remove(item);
                                }
                              });
                              Navigator.pop(context);
                              showCartDialog();
                            },
                          ),
                          Text("${cart[item]}"),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.green),
                            onPressed: () {
                              setState(() {
                                cart[item] = cart[item]! + 1;
                              });
                              Navigator.pop(context);
                              showCartDialog();
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Tổng tiền:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text("${calculateTotal().toStringAsFixed(0)} VND", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.red)),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(onPressed: () => Navigator.pop(context), child: Text("Đóng giỏ hàng")),
                  ElevatedButton(onPressed: processPayment, child: Text("Thanh toán"), style: ElevatedButton.styleFrom(backgroundColor: Colors.green)),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Xử lý thanh toán
  void processPayment() {
    if (cart.isEmpty) return;

    double totalAmount = calculateTotal();
    setState(() {
      cart.clear();
    });

    Navigator.pop(context); // Đóng giỏ hàng
    showBillDialog(totalAmount);
  }

  // Hiển thị hóa đơn
  void showBillDialog(double totalAmount) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("🧾 Hóa Đơn"),
          content: Text("Tổng tiền: ${totalAmount.toStringAsFixed(0)} VND"),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: Text("Đóng")),
          ],
        );
      },
    );
  }

  // Xây dựng danh sách sản phẩm theo danh mục
  Widget buildCategoryList(List<Map<String, dynamic>> items) {
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(Icons.fastfood, color: Colors.orange, size: 40),
          title: Text(items[index]["name"], style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(items[index]["description"], style: TextStyle(fontSize: 14, color: Colors.grey[700])),
              Text("Giá: ${items[index]["price"]} VND", style: TextStyle(fontSize: 14, color: Colors.red)),
            ],
          ),
          trailing: IconButton(
            icon: Icon(Icons.add_shopping_cart, color: Colors.green),
            onPressed: () => addToCart(items[index]["name"]),
          ),
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DrinkDetailPage(drink: items[index])));
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        appBar: AppBar(
          title: Text("Danh sách sản phẩm"),
          actions: [
            Stack(
              children: [
                IconButton(icon: Icon(Icons.shopping_cart, size: 28), onPressed: showCartDialog),
                if (getCartItemCount() > 0)
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      padding: EdgeInsets.all(6),
                      decoration: BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                      child: Text("${getCartItemCount()}", style: TextStyle(fontSize: 12, color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
          ],
          bottom: TabBar(
            controller: _tabController,
            tabs: [
              Tab(text: "Đồ uống"),
              Tab(text: "Thức ăn"),
              Tab(text: "Gia dụng"),
              Tab(text: "Ăn vặt"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            buildCategoryList(drinks),
            buildCategoryList(foods),
            buildCategoryList(households),
            buildCategoryList(snacks),
          ],
        ),
      ),
    );
  }
}
