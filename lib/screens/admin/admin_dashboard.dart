import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import 'component/SectionHeader.dart';
import '../../service/ProductService.dart';
import '../../service/UserService.dart';
import '../../service/OrderService.dart';
import '../../service/CartService.dart';
import '../../service/WebSocketService.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String selectedRange = 'Tháng này';
  int totalUsers = 0;
  int totalProducts = 0;
  int totalOrders = 0;
  double totalRevenue = 0.0;

  // Dữ liệu cho Pie Chart
  List<PieChartSectionData> pieSections = [];
  // Bộ màu cho từng phần
  final List<Color> _pieColors = [
    Colors.blue,
    Colors.orange,
    Colors.green,
    Colors.red,
    Colors.purple,
    Colors.deepPurpleAccent,
    Colors.teal,
    Colors.pink,
  ];

  // Khởi tạo các service instance
  final ProductService _productService = ProductService();
  final UserService _userService = UserService();
  final OrderService _orderService = OrderService();
  final CartService _cartService = CartService();
  final WebSocketService _webSocketService = WebSocketService();

  final List<String> ranges = [
    'Hôm nay',
    'Tuần này',
    'Tháng này',
    'Quý này',
    'Năm nay',
    'Tùy chỉnh',
  ];

  @override
  void initState() {
    super.initState();
    _loadDashboardData();
    _webSocketService.connect((review) {
      // TODO: Handle new review events if needed
    });
  }

  Future<void> _loadDashboardData() async {
    try {
      // Tải người dùng và sản phẩm chung
      final users = await UserService.fetchUsers();
      final products = await ProductService.fetchAllProducts();

      // Tải danh mục và tính số sản phẩm mỗi loại
      final categories = await ProductService.fetchAllCategory();
      final List<PieChartSectionData> sections = [];
      for (var i = 0; i < categories.length; i++) {
        final cat = categories[i];
        final prods = await _productService.fetchProductsByCategory(cat.id!);
        final color = _pieColors[i % _pieColors.length];
        sections.add(
          PieChartSectionData(
            value: prods.length.toDouble(),
            title: cat.name,
            radius: 60,
            color: color,
            titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
          ),
        );
      }

      // // TODO: Khi OrderService có API, tải đơn hàng và doanh thu
      // final orders = await _orderService.fetchAllOrders();
      // totalOrders = orders.length;
      // totalRevenue = orders.fold(0.0, (sum, o) => sum + o.totalPrice);

      setState(() {
        totalUsers = users.length;
        totalProducts = products.length;
        pieSections = sections;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: \$e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;

        Widget content = Column(
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildOverviewGrid(crossAxisCount: isMobile ? 1 : isTablet ? 2 : 4),
            const SizedBox(height: 32),
            _buildChartCard('📈 Doanh thu theo thời gian', _buildLineChart()),
            const SizedBox(height: 32),
            _buildChartCard('📊 Tỷ lệ loại sản phẩm bán chạy', _buildPieChart()),
          ],
        );

        if (isMobile || isTablet) {
          return Container(
            color: const Color(0xFFF5F6FA),
            child: ListView(padding: const EdgeInsets.all(16), children: [content]),
          );
        } else {
          return Container(
            color: const Color(0xFFF5F6FA),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: content,
            ),
          );
        }
      },
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      child: Row(
        children: [
          const SectionHeader('Tổng quan'),
          const Spacer(),
          DecoratedBox(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<String>(
                value: selectedRange,
                underline: const SizedBox(),
                items: ranges.map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
                onChanged: (value) {
                  if (value != null) setState(() => selectedRange = value);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOverviewGrid({required int crossAxisCount}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
      children: [
        _DashboardCard(title: 'Tổng người dùng', value: '$totalUsers', icon: Icons.people),
        _DashboardCard(title: 'Tổng sản phẩm', value: '$totalProducts', icon: Icons.shopping_bag),
        _DashboardCard(title: 'Đơn hàng', value: '$totalOrders', icon: Icons.shopping_cart),
        _DashboardCard(title: 'Doanh thu', value: '₫${totalRevenue.toStringAsFixed(0)}', icon: Icons.bar_chart),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            const SizedBox(height: 12),
            SizedBox(height: 220, child: chart),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(LineChartData(
      titlesData: FlTitlesData(show: true),
      borderData: FlBorderData(show: false),
      lineBarsData: [
        LineChartBarData(spots: const [
          FlSpot(0, 5), FlSpot(1, 6.2), FlSpot(2, 4.8), FlSpot(3, 7),
          FlSpot(4, 6.1), FlSpot(5, 6.8), FlSpot(6, 7.2),
        ]),
      ],
    ));
  }

  Widget _buildPieChart() {
    if (pieSections.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    return PieChart(PieChartData(
      sectionsSpace: 4,
      centerSpaceRadius: 30,
      sections: pieSections,
    ));
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({Key? key, required this.title, required this.value, required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 36, color: Colors.blueAccent),
            const SizedBox(height: 12),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}