import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({Key? key}) : super(key: key);

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
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final isMobile = width < 600;
        final isTablet = width >= 600 && width < 1200;
        final isDesktop = width >= 1200;

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
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 16),
                  _buildOverviewGrid(crossAxisCount: 4),
                  const SizedBox(height: 32),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: _buildChartCard(
                          '📈 Doanh thu theo thời gian',
                          _buildLineChart(),
                        ),
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: _buildChartCard(
                          '📊 Tỷ lệ loại sản phẩm bán chạy',
                          _buildPieChart(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Text(
          'Tổng quan',
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
        ),
        DropdownButton<String>(
          value: selectedRange,
          items: ranges
              .map((range) => DropdownMenuItem(value: range, child: Text(range)))
              .toList(),
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

  Widget _buildOverviewGrid({required int crossAxisCount}) {
    return GridView.count(
      crossAxisCount: crossAxisCount,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.6,
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
            spots: const [
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
