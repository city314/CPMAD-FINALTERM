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
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 800;

        return Scaffold(
          backgroundColor: const Color(0xFFF5F6FA),
          appBar: AppBar(
            title: const Text('📊 Admin Dashboard'),
            backgroundColor: Colors.indigo,
            elevation: 2,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: isDesktop
                ? _buildDesktopLayout()
                : _buildMobileLayout(),
          ),
        );
      },
    );
  }

  Widget _buildMobileLayout() {
    return ListView(
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildOverviewGrid(crossAxisCount: 2),
        const SizedBox(height: 32),
        _buildChartCard('📈 Doanh thu theo thời gian', _buildLineChart()),
        const SizedBox(height: 32),
        _buildChartCard('📊 Tỷ lệ loại sản phẩm bán chạy', _buildPieChart()),
      ],
    );
  }

  Widget _buildDesktopLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        const SizedBox(height: 16),
        _buildOverviewGrid(crossAxisCount: 4),
        const SizedBox(height: 32),
        Row(
          children: [
            Expanded(child: _buildChartCard('📈 Doanh thu theo thời gian', _buildLineChart())),
            const SizedBox(width: 24),
            Expanded(child: _buildChartCard('📊 Tỷ lệ loại sản phẩm bán chạy', _buildPieChart())),
          ],
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text('Tổng quan', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        DropdownButton<String>(
          value: selectedRange,
          items: ranges.map((range) => DropdownMenuItem(value: range, child: Text(range))).toList(),
          onChanged: (value) => setState(() => selectedRange = value!),
        ),
      ],
    );
  }

  Widget _buildChartCard(String title, Widget chart) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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

  Widget _buildOverviewGrid({required int crossAxisCount}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6, // 👈 giới hạn chiều cao, làm card nhỏ gọn
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
            gradient: LinearGradient(colors: [Colors.blue, Colors.blueAccent]),
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
