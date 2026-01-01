import 'package:flutter/material.dart';

class PromotionFilter {
  RangeValues? discountRange;
  String? period;

  PromotionFilter({
    this.discountRange,
    this.period,
  });
}

class FilterBottomSheet extends StatefulWidget {
  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  RangeValues? _discountRange;
  String? _selectedPeriod;

  int _promotionCount = 0;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchPromotionCount();
  }

  Future<void> _fetchPromotionCount() async {
    setState(() => _isLoading = true);

    await Future.delayed(const Duration(milliseconds: 400));
    setState(() {
      _promotionCount = 00;
      _isLoading = false;
    });
  }

  void _onFilterChanged(VoidCallback action) {
    setState(action);
    _fetchPromotionCount();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHandleBar(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  const Text("필터", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 30),
                  _buildRangeSection(),
                  const SizedBox(height: 30),
                  _buildChipSection("기간", ["오늘 진행 중", "이번주 마감", "이번달 마감", "상시 이벤트"], _selectedPeriod,
                          (val) => _onFilterChanged(() => _selectedPeriod = val)),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildFooter(),
        ],
      ),
    );
  }

  Widget _buildHandleBar() {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40, height: 4,
      decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _buildRangeSection() {
    bool isFilterActive = _discountRange != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("할인율 범위", style: TextStyle(color: Colors.grey)),
            if(isFilterActive)
              Text("${_discountRange!.start.round()}~${_discountRange!.end.round()}% 할인", style: const TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
          ],
        ),
        RangeSlider(
          values: _discountRange ?? const RangeValues(0, 90),
          max: 90,
          activeColor: isFilterActive ? Colors.redAccent : Colors.grey[300],
          inactiveColor: Colors.grey[200],
          onChanged: (val) => setState(() => _discountRange = val),
          onChangeEnd: (val) => _fetchPromotionCount(),
        ),
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [Text("0%"), Text("90%")],
        )
      ],
    );
  }

  Widget _buildChipSection(String title, List<String> options, String? selectedValue, Function(String) onSelect) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(color: Colors.grey)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            final isSelected = selectedValue == option;
            return ChoiceChip(
              label: Text(option),
              selected: isSelected,
              onSelected: (_) => onSelect(option),
              selectedColor: Colors.redAccent,
              backgroundColor: Colors.white,
              labelStyle: TextStyle(color: isSelected ? Colors.white : Colors.black54),
              shape: StadiumBorder(side: BorderSide(color: isSelected ? Colors.redAccent : Colors.grey[300]!)),
              showCheckmark: false,
            );
          }).toList(),
        )
      ],
    );
  }

  Widget _buildFooter() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[100]!))),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                  icon: const Icon(Icons.refresh),
                  onPressed: () => _onFilterChanged(() {
                    _discountRange = null;
                    _selectedPeriod = null;
                  })
              ),
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      if(_discountRange!= null)
                        _buildSelectedTag("${_discountRange!.start.round()}~${_discountRange!.end.round()}% 할인", (){
                          _onFilterChanged(() => _discountRange = null);
                        }),
                      if(_selectedPeriod != null)
                        _buildSelectedTag(_selectedPeriod!, (){
                          _onFilterChanged(() => _selectedPeriod = null);
                        }),
                    ],
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.redAccent,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onPressed: _isLoading ? null : () {
                final filterData = PromotionFilter(
                  discountRange: _discountRange,
                  period: _selectedPeriod,
                );
                Navigator.pop(context, filterData);
              },
              child: _isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("$_promotionCount개 프로모션 보기", style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSelectedTag(String text, VoidCallback onDelete) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.only(left: 10, right: 4, top: 4, bottom: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
          const SizedBox(width: 4),
          GestureDetector(
            onTap: onDelete,
            child: const Icon(Icons.close, size: 14, color: Colors.grey),
          ),
        ],
      ),
    );
  }
}