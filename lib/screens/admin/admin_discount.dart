import 'package:flutter/material.dart';
import '../../models/product.dart';
import '../../models/productDiscount.dart';
import 'component/SectionHeader.dart';

class AdminDiscountScreen extends StatefulWidget {
  const AdminDiscountScreen({Key? key}) : super(key: key);

  @override
  State<AdminDiscountScreen> createState() => _AdminDiscountScreenState();
}

class _AdminDiscountScreenState extends State<AdminDiscountScreen> {
  final _discountCtrl = TextEditingController();
  DateTime _startDate = DateTime.now();
  DateTime _endDate   = DateTime.now().add(const Duration(days: 7));
  final Set<String> _selectedIds = {};
  // Searching
  String _searchQuery = '';
  // State cho filter
  String? _selectedCategory;
  String? _selectedBrand;
  final _minPriceCtrl = TextEditingController();
  final _maxPriceCtrl = TextEditingController();

  // ── Test data (thay thế bằng fetch từ API sau này) ───────────────────
  final List<Product> _products = [
    Product(
      id: 'p001',
      name: 'Gaming Laptop ROG Strix',
      categoryId: 'laptop',
      brandId: 'asus',
      price: 30000000,
      description: 'Laptop gaming hiệu năng cao.',
      stock: 12,
      imgUrl: '',
      timeAdd: DateTime.now().subtract(const Duration(days: 3)),
      variants: [], // nếu chưa cần biến thể cụ thể
    ),
    Product(
      id: 'p002',
      name: 'SSD Samsung 980 Pro 1TB',
      categoryId: 'ssd',
      brandId: 'samsung',
      price: 4500000,
      description: 'Ổ cứng SSD PCIe Gen4 1TB.',
      stock: 20,
      imgUrl: '',
      timeAdd: DateTime.now().subtract(const Duration(days: 10)),
      variants: [],
    ),
    // … thêm sản phẩm test khác nếu muốn …
  ];
  // Tạo danh sách category/brand từ _products (có thể thay bằng fetch API)
  late final List<String> _allCategories = [
    'Tất cả',
    ...{for (var p in _products) p.categoryId}
  ];
  late final List<String> _allBrands = [
    'Tất cả',
    ...{for (var p in _products) p.brandId}
  ];
  // ─────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    _selectedCategory = 'Tất cả';
    _selectedBrand    = 'Tất cả';
  }

  @override
  void dispose() {
    _discountCtrl.dispose();
    _minPriceCtrl.dispose();
    _maxPriceCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickStartDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _startDate = d);
  }

  Future<void> _pickEndDate() async {
    final d = await showDatePicker(
      context: context,
      initialDate: _endDate,
      firstDate: _startDate,
      lastDate: DateTime(2100),
    );
    if (d != null) setState(() => _endDate = d);
  }

  void _apply() {
    final perc = double.tryParse(_discountCtrl.text.trim());
    if (perc == null || perc < 0 || perc > 100) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng nhập % giảm hợp lệ (0–100)')),
      );
      return;
    }
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ít nhất 1 sản phẩm')),
      );
      return;
    }

    // Tạo list ProductDiscount dựa trên model của bạn
    final discounts = _products
        .where((p) => _selectedIds.contains(p.id))
        .map((p) => ProductDiscount(
      productId:       p.id!,
      discountPercent: perc,
      startDate:       _startDate,
      endDate:         _endDate,
    ))
        .toList();

    // TODO: gọi API hoặc xử lý tiếp với `discounts`
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
            'Áp dụng giảm $perc% cho ${discounts.length} sản phẩm'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Lọc theo tất cả điều kiện
    final filtered = _products.where((p) {
      final matchesSearch = p.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final matchesCat    = _selectedCategory == 'Tất cả' || p.categoryId == _selectedCategory;
      final matchesBrand  = _selectedBrand    == 'Tất cả' || p.brandId    == _selectedBrand;
      final minPrice = double.tryParse(_minPriceCtrl.text) ?? 0;
      final maxPrice = double.tryParse(_maxPriceCtrl.text) ?? double.infinity;
      final matchesPrice = p.price >= minPrice && p.price <= maxPrice;

      return matchesSearch && matchesCat && matchesBrand && matchesPrice;
    }).toList();
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SectionHeader('Quản lý Giảm giá sản phẩm'),
            const SizedBox(height: 16),

            // Nhập % giảm và chọn khoảng thời gian
            Row(children: [
              Expanded(
                child: TextField(
                  controller: _discountCtrl,
                  decoration: const InputDecoration(
                    labelText: '% Giảm giá',
                    suffixText: '%',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: _pickStartDate,
                child: Text(
                    'Từ: ${_startDate.toLocal().toString().split(' ')[0]}'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _pickEndDate,
                child: Text(
                    'Đến: ${_endDate.toLocal().toString().split(' ')[0]}'),
              ),
            ]),

            const SizedBox(height: 24),
            // ————— Bộ lọc —————
            Row(
              children: [
                // Category
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Danh mục',
                      border: OutlineInputBorder(),
                    ),
                    items: _allCategories
                        .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedCategory = v),
                  ),
                ),
                const SizedBox(width: 12),
                // Brand
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _selectedBrand,
                    decoration: const InputDecoration(
                      labelText: 'Thương hiệu',
                      border: OutlineInputBorder(),
                    ),
                    items: _allBrands
                        .map((b) => DropdownMenuItem(value: b, child: Text(b)))
                        .toList(),
                    onChanged: (v) => setState(() => _selectedBrand = v),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                // Min Price
                Expanded(
                  child: TextField(
                    controller: _minPriceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Giá từ (₫)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 12),
                // Max Price
                Expanded(
                  child: TextField(
                    controller: _maxPriceCtrl,
                    decoration: const InputDecoration(
                      labelText: 'Đến (₫)',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            // —————————————— Thanh Search ——————————————
            TextField(
              decoration: InputDecoration(
                labelText: 'Tìm kiếm sản phẩm',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => setState(() => _searchQuery = v.trim()),
            ),
            const SizedBox(height: 16),
            // Danh sách sản phẩm với Checkbox
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (_, i) {
                  final p = filtered[i];
                  final checked = _selectedIds.contains(p.id);
                  return CheckboxListTile(
                    value: checked,
                    onChanged: (v) {
                      setState(() {
                        if (v == true) _selectedIds.add(p.id!);
                        else _selectedIds.remove(p.id!);
                      });
                    },
                    title: Text(p.name,
                        maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text(
                      'Giá: ₫${p.price.toStringAsFixed(0)}  •  Biến thể: ${p.variants.length}',
                      style: const TextStyle(fontSize: 12),
                    ),
                    controlAffinity: ListTileControlAffinity.leading,
                  );
                },
              ),
            ),

            // Nút xác nhận
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _apply,
                child: const Text('Xác nhận áp dụng giảm giá'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
