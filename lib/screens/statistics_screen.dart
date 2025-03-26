import 'package:cipherx/widgets/chart_card.dart';
import 'package:flutter/material.dart';
import 'package:cipherx/dataModels/utility.dart';
import '../../dataModels/model/add_data.dart'; // fixed: was add_date.dart

class Statistics extends StatefulWidget {
  const Statistics({super.key});

  @override
  State<Statistics> createState() => _StatisticsState();
}

class _StatisticsState extends State<Statistics> {
  final ValueNotifier<int> _selectedIndex = ValueNotifier<int>(0);

  final List<String> _labels = ['Day', 'Week', 'Month', 'Year'];
  final List<List<Add_data>> _filters = [today(), week(), month(), year()];
  int _highlightIndex = 0;

  @override
  void dispose() {
    _selectedIndex.dispose(); // cleanup
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder<int>(
          valueListenable: _selectedIndex,
          builder: (context, value, _) {
            final filteredData = _filters[value];
            return _buildBody(filteredData);
          },
        ),
      ),
    );
  }

  Widget _buildBody(List<Add_data> filteredData) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                'Statistics',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 20),
              _buildFilterButtons(),
              const SizedBox(height: 20),
              Chart(indexx: _highlightIndex),
              const SizedBox(height: 20),
              const Padding(
                padding:  EdgeInsets.symmetric(horizontal: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Top Spending',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Icon(Icons.swap_vert, size: 25, color: Colors.grey),
                  ],
                ),
              ),
            ],
          ),
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final item = filteredData[index];
              return ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(5),
                  child: Image.asset('assets/${item.name}.png', height: 40),
                ),
                title: Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  '${item.datetime.day}-${item.datetime.month}-${item.datetime.year}',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: Text(
                  item.amount,
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 19,
                    color: item.IN == 'Income' ? Colors.green : Colors.red,
                  ),
                ),
              );
            },
            childCount: filteredData.length,
          ),
        ),
      ],
    );
  }

  Widget _buildFilterButtons() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_labels.length, (index) {
          return GestureDetector(
            onTap: () {
              setState(() {
                _highlightIndex = index;
              });
              _selectedIndex.value = index;
            },
            child: Container(
              height: 30,
              width: 80,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: _highlightIndex == index
                    ? const Color(0xffFCEED4)
                    : Colors.white,
              ),
              child: Text(
                _labels[index],
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: _highlightIndex == index
                      ? const Color(0xffFCAC12)
                      : Colors.black,
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
