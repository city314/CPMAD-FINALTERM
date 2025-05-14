import 'package:flutter/material.dart';
import 'home.dart';

class ProductDetail extends StatefulWidget {
  const ProductDetail({super.key});

  @override
  State<ProductDetail> createState() => _ProductDetailState();
}

class _ProductDetailState extends State<ProductDetail> {
  // Danh sách danh mục và thương hiệu mẫu
  final Map<String, List<String>> categoryBrands = {
    'Laptop': ['Asus', 'Dell', 'HP', 'Apple'],
    'PC': ['Acer', 'Lenovo', 'MSI'],
    'Tai nghe': ['Sony', 'JBL', 'Sennheiser'],
    'Màn hình': ['Samsung', 'LG', 'ViewSonic'],
    'Bàn phím': ['Logitech', 'Razer'],
    'Chuột': ['Logitech', 'Razer', 'Fuhlen'],
    'Phụ kiện': ['Anker', 'Xiaomi'],
  };

  final Map<String, IconData> categoryIcons = {
    'Laptop': Icons.laptop,
    'PC': Icons.desktop_windows,
    'Tai nghe': Icons.headphones,
    'Màn hình': Icons.monitor,
    'Bàn phím': Icons.keyboard,
    'Chuột': Icons.mouse,
    'Phụ kiện': Icons.extension,
  };

  final Map<String, String> brandLogos = {
    'Asus': 'assets/images/brand/asus.png',
    'Dell': 'assets/images/brand/dell.png',
    'HP': 'assets/images/brand/hp.png',
    'Apple': 'assets/images/brand/apple.png',
    'Acer': 'assets/images/brand/acer.png',
    'Lenovo': 'assets/images/brand/lenovo.png',
    'MSI': 'assets/images/brand/msi.png',
    'Sony': 'assets/images/brand/sony.png',
    'JBL': 'assets/images/brand/jbl.png',
    'Sennheiser': 'assets/images/brand/sennheiser.png',
    'Samsung': 'assets/images/brand/samsung.png',
    'LG': 'assets/images/brand/lg.png',
    'ViewSonic': 'assets/images/brand/viewsonic.png',
    'Logitech': 'assets/images/brand/logitech.png',
    'Razer': 'assets/images/brand/razer.png',
    'Fuhlen': 'assets/images/brand/fuhlen.png',
    'Anker': 'assets/images/brand/anker.png',
    'Xiaomi': 'assets/images/brand/xiaomi.png',
  };

  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomNavbar(
        cartItemCount: 0,
        onHomeTap: () {},
        onCategoriesTap: () {},
        onCartTap: () {},
        onRegisterTap: () {},
        onLoginTap: () {},
        onSupportTap: () {},
        onSearch: (value) {},
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar danh mục
          Container(
            width: 250,
            decoration: BoxDecoration(
              color: const Color(0xFFEEF9FE),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 12,
                  offset: const Offset(2, 0),
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 12),
            child: ListView(
              children: [
                const Text('Tất Cả Danh Mục', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                const SizedBox(height: 12),
                ...categoryBrands.entries.map((entry) => ExpansionTile(
                  title: Text(entry.key),
                  leading: Icon(categoryIcons[entry.key] ?? Icons.category),
                  children: entry.value.map((brand) => ListTile(
                    leading: brandLogos[brand] != null
                        ? Image.asset(brandLogos[brand]!, width: 24, height: 24)
                        : null,
                    title: Text(brand),
                    dense: true,
                    contentPadding: const EdgeInsets.only(left: 32),
                    onTap: () {},
                  )).toList(),
                )),
              ],
            ),
          ),
          // Nội dung chi tiết sản phẩm
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Tên sản phẩm + đánh giá
                  Text(
                    'Laptop Gaming ROG Zephyrus',
                    style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) => const Icon(Icons.star, color: Colors.amber, size: 22)),
                      ),
                      const SizedBox(width: 8),
                      const Text('(120 đánh giá)', style: TextStyle(fontSize: 15, color: Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Ảnh + giá + logo + nút
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Ảnh sản phẩm
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Image.asset(
                          'assets/images/product/laptop1.png',
                          width: 320,
                          height: 320,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(width: 32),
                      // Giá + logo + nút
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                // Logo thương hiệu
                                Image.asset('assets/images/brand/asus.png', width: 36, height: 36),
                                const SizedBox(width: 12),
                                // Logo danh mục
                                Icon(Icons.laptop),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              '200.000.000 đ',
                              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.red),
                            ),
                            const SizedBox(height: 24),
                            // Điều chỉnh số lượng
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                const Text('Số lượng:', style: TextStyle(fontWeight: FontWeight.w500)),
                                const SizedBox(width: 12),
                                IconButton(
                                  icon: const Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      if (quantity > 1) quantity--;
                                    });
                                  },
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.grey.shade400),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withOpacity(0.08),
                                        blurRadius: 6,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text('$quantity', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    setState(() {
                                      quantity++;
                                    });
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add_shopping_cart, size: 18),
                                  label: const Text('Thêm giỏ hàng', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                                const SizedBox(width: 16),
                                ElevatedButton(
                                  onPressed: () {},
                                  child: const Text('Mua ngay', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Mô tả sản phẩm
                  const Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Laptop Gaming ROG Zephyrus sở hữu cấu hình mạnh mẽ, thiết kế mỏng nhẹ, màn hình 240Hz, phù hợp cho cả game thủ và dân sáng tạo nội dung. Pin trâu, tản nhiệt tốt, nhiều cổng kết nối.',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 32),
                  // Đánh giá khách hàng
                  const Text(
                    'Đánh giá của khách hàng',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Danh sách đánh giá mẫu
                  Column(
                    children: [
                      _buildReview(
                        avatar: 'assets/images/avatar1.png',
                        name: 'Nguyễn Văn A',
                        rating: 5,
                        comment: 'Sản phẩm rất tốt, chơi game mượt, pin lâu, giao hàng nhanh!',
                      ),
                      const SizedBox(height: 16),
                      _buildReview(
                        avatar: 'assets/images/avatar2.png',
                        name: 'Trần Thị B',
                        rating: 4,
                        comment: 'Máy đẹp, cấu hình mạnh, hơi nóng khi chơi lâu.',
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  // Sản phẩm gợi ý
                  const Text(
                    'Sản phẩm gợi ý',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 4,
                      mainAxisSpacing: 16,
                      crossAxisSpacing: 16,
                      childAspectRatio: 1.1,
                    ),
                    itemCount: 8,
                    itemBuilder: (context, index) {
                      return Card(
                        elevation: 6,
                        shadowColor: Colors.black.withOpacity(0.14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                                child: Image.asset(
                                  'assets/images/product/laptop1.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Laptop Gợi ý #${index + 1}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 2),
                                  const Text('19.990.000 đ', style: TextStyle(color: Colors.indigo, fontSize: 12)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                  // Footer từ home.dart
                  Container(
                    width: double.infinity,
                    color: const Color(0xFF43A7C6),
                    padding: const EdgeInsets.symmetric(vertical: 24),
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Text(
                            'CỬA HÀNG LAPIZONE',
                            style: TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              letterSpacing: 1.2,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.phone, color: Colors.black, size: 18),
                              SizedBox(width: 8),
                              Text('SĐT: 0123 456 789', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.location_on, color: Colors.black, size: 18),
                              SizedBox(width: 8),
                              Text('Địa chỉ: Tân Phong, Quận 7, TP HCM', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.email, color: Colors.black, size: 18),
                              SizedBox(width: 8),
                              Text('Email: info@lapizone.vn', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.support_agent, color: Colors.black, size: 18),
                              SizedBox(width: 8),
                              Text('Hotline: 1800 1234', style: TextStyle(color: Colors.black)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildReview({
    required String avatar,
    required String name,
    required int rating,
    required String comment,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.10),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundImage: AssetImage(avatar),
            radius: 24,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    const SizedBox(width: 8),
                    Row(
                      children: List.generate(
                        rating,
                        (index) => const Icon(Icons.star, color: Colors.amber, size: 18),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(comment, style: const TextStyle(fontSize: 15)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}


