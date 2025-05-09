import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  String selectedRange = 'Tháng này';
  final List<String> ranges = [
    'Hôm nay',
    'Tuần này',
    'Tháng này',
    'Quý này',
    'Năm nay',
    'Tuỳ chỉnh'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Dashboard tổng quan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                DropdownButton<String>(
                  value: selectedRange,
                  items: ranges.map((range) => DropdownMenuItem(value: range, child: Text(range))).toList(),
                  onChanged: (value) => setState(() => selectedRange = value!),
                )
              ],
            ),
            const SizedBox(height: 16),
            _buildOverviewGrid(),
            const SizedBox(height: 24),
            const Text('Biểu đồ Doanh thu theo thời gian', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: _buildLineChart()),
            const SizedBox(height: 24),
            const Text('Biểu đồ loại sản phẩm bán chạy', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            SizedBox(height: 200, child: _buildPieChart()),
          ],
        ),
      ),
    );
  }

  Widget _buildOverviewGrid() {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: const [
        _DashboardCard(title: 'Tổng người dùng', value: '1,250', icon: Icons.people),
        _DashboardCard(title: 'Người dùng mới', value: '120', icon: Icons.person_add),
        _DashboardCard(title: 'Đơn hàng', value: '3,400', icon: Icons.shopping_cart),
        _DashboardCard(title: 'Doanh thu', value: '₫850,000,000', icon: Icons.bar_chart),
      ],
    );
  }

  Widget _buildLineChart() {
    return LineChart(
      LineChartData(
        titlesData: FlTitlesData(show: true),
        borderData: FlBorderData(show: false),
        lineBarsData: [
          LineChartBarData(
            spots: [
              FlSpot(0, 5),
              FlSpot(1, 6.2),
              FlSpot(2, 5.5),
              FlSpot(3, 8),
              FlSpot(4, 6.5),
              FlSpot(5, 7),
            ],
            isCurved: true,
            barWidth: 3,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildPieChart() {
    return PieChart(
      PieChartData(
        sections: [
          PieChartSectionData(value: 40, color: Colors.blue, title: 'Laptop'),
          PieChartSectionData(value: 25, color: Colors.orange, title: 'Phụ kiện'),
          PieChartSectionData(value: 20, color: Colors.green, title: 'Chuột'),
          PieChartSectionData(value: 15, color: Colors.red, title: 'Khác'),
        ],
        sectionsSpace: 4,
        centerSpaceRadius: 30,
      ),
    );
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _DashboardCard({required this.title, required this.value, required this.icon});

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
