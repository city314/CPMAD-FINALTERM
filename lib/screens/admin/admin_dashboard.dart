import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../service/ProductService.dart';
import '../../service/UserService.dart';
import '../../service/WebSocketService.dart';
import 'component/SectionHeader.dart';

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
      final users = await UserService.fetchUsers();
      final products = await ProductService.fetchAllProducts();
      // TODO: Fetch orders and calculate revenue when OrderService methods are available
      setState(() {
        totalUsers = users.length;
        totalProducts = products.length;
        // totalOrders = orders.length;
        // totalRevenue = calculate revenue from orders;
      });
    } catch (e) {
      debugPrint('Error loading dashboard data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;

        if (isMobile || isTablet) {
          return Container(
            color: const Color(0xFFF5F6FA),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                _buildHeader(),
                const SizedBox(height: 16),
                _buildOverviewGrid(crossAxisCount: isMobile ? 1 : 2),
                const SizedBox(height: 32),
                _buildChartCard('📈 Doanh thu theo thời gian', _buildLineChart()),
                const SizedBox(height: 32),
                _buildChartCard('📊 Tỷ lệ loại sản phẩm bán chạy', _buildPieChart()),
              ],
            ),
          );
        } else {
          return Container(
            color: const Color(0xFFF5F6FA),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildOverviewGrid(crossAxisCount: 4),
                  const SizedBox(height: 32),
                  _buildChartCard('📈 Doanh thu theo thời gian', _buildLineChart()),
                  const SizedBox(height: 32),
                  _buildChartCard('📊 Tỷ lệ loại sản phẩm bán chạy', _buildPieChart()),
                ],
              ),
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
                items: ranges
                    .map((range) => DropdownMenuItem(
                  value: range,
                  child: Text(range),
                ))
                    .toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() => selectedRange = value);
                    // TODO: reload data based on selectedRange
                  }
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
        _DashboardCard(
          title: 'Tổng người dùng',
          value: '$totalUsers',
          icon: Icons.people,
        ),
        _DashboardCard(
          title: 'Tổng sản phẩm',
          value: '$totalProducts',
          icon: Icons.shopping_bag,
        ),
        _DashboardCard(
          title: 'Đơn hàng',
          value: '$totalOrders',
          icon: Icons.shopping_cart,
        ),
        _DashboardCard(
          title: 'Doanh thu',
          value: '₫${totalRevenue.toStringAsFixed(0)}',
          icon: Icons.bar_chart,
        ),
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
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: 220,
              child: chart,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: const [
              FlSpot(0, 5),
              FlSpot(1, 6.2),
              FlSpot(2, 4.8),
              FlSpot(3, 7),
              FlSpot(4, 6.1),
              FlSpot(5, 6.8),
              FlSpot(6, 7.2),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sectionsSpace: 4,
        centerSpaceRadius: 30,
        sections: [
          PieChartSectionData(value: 40, color: Colors.blue, title: 'Laptop'),
          PieChartSectionData(value: 25, color: Colors.orange, title: 'Phụ kiện'),
          PieChartSectionData(value: 20, color: Colors.green, title: 'Chuột'),
          PieChartSectionData(value: 15, color: Colors.red, title: 'Khác'),
        ],
      ),
    );
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
            Text(
              value,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(title, style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
