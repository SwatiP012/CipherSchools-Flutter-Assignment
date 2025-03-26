import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:cipherx/dataModels/model/add_data.dart';
import 'package:cipherx/dataModels/utility.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

ValueNotifier<int> kj = ValueNotifier<int>(0);

class _HomeState extends State<Home> {
  final box = Hive.box<Add_data>('data');
  final List<String> day = [
    'Monday',
    'Tuesday',
    'Wednesday',
    'Thursday',
    'Friday',
    'Saturday',
    'Sunday'
  ];
  List<String> days = ['Day', 'Week', 'Month', 'Year'];
  List<List<Add_data>> f = [today(), week(), month(), year()];
  List<Add_data> a = [];
  int indexcolor = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ValueListenableBuilder(
          valueListenable: box.listenable(),
          builder: (context, value, child) {
            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                    child: SizedBox(height: 340, child: _head())),
                const SliverToBoxAdapter(
                  child: Padding(
                    padding:  EdgeInsets.symmetric(horizontal: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children:  [
                        Text(
                          'Transactions History',
                          style: TextStyle(
                              fontWeight: FontWeight.w600, fontSize: 19),
                        ),
                        Text(
                          'See all',
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 15,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final history = box.values.toList()[index];
                        return getList(history);
                      },
                      childCount: box.length,
                    ),
                  ),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  Widget customScroll() {
    return ValueListenableBuilder<int>(
      valueListenable: kj,
      builder: (BuildContext context, value, _) {
        a = f[value];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(4, (index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                   indexcolor = index;
                    kj.value = index;
                  });
                },
                child: Container(
                  height: 30,
                  width: 80,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: indexcolor == index
                        ? const Color(0xffFCEED4)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    days[index],
                    style: TextStyle(
                      color: indexcolor == index
                          ? const Color(0xffFCAC12)
                          : Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }

  Widget getList(Add_data history) {
    return Dismissible(
      key: UniqueKey(),
      onDismissed: (direction) => history.delete(),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Image.asset(
            'assets/${history.name}.png',
            height: 40,
            width: 40,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.image_not_supported, size: 40);
            },
          ),
        ),
        title: Text(history.name,
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600)),
        subtitle: Text(
          '${day[(history.datetime.weekday - 1).clamp(0, 6)]}  ${history.datetime.day}-${history.datetime.month}-${history.datetime.year}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        trailing: Text(
          '₹ ${history.amount}',
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 19,
            color: history.IN == 'Income' ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }

  Widget _head() {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              width: double.infinity,
              height: 240,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(-0.06, -1.00),
                  end: Alignment(0.06, 1),
                  colors: [Color(0xFFFFF6E5), Color(0x00F7ECD7)],
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    top: 35,
                    right: 16,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(7),
                      child: Container(
                        height: 40,
                        width: 40,
                        color: const Color.fromRGBO(250, 250, 250, 0.1),
                        child: const Icon(Icons.notifications,
                            size: 30, color: Color(0xff7F3DFF)),
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 40, left: 16),
                    width: 32,
                    height: 32,
                    decoration: ShapeDecoration(
                      image: const DecorationImage(
                        image: AssetImage("assets/05.png"),
                        fit: BoxFit.fill,
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24)),
                      shadows: const [
                        BoxShadow(color: Color(0xFFAD00FF), spreadRadius: 3),
                        BoxShadow(color: Color(0xFFF5F5F5), spreadRadius: 2)
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        Positioned(
          top: 100,
          left: 0,
          right: 0,
          child: Column(
            children: [
              const Text(
                'Account Balance',
                style: TextStyle(
                    color: Color(0xFF90909F),
                    fontSize: 14,
                    fontWeight: FontWeight.w500),
              ),
              Text(
                '₹ ${total()}',
                style:
                    const TextStyle(fontSize: 40, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
        Positioned(
          top: 209,
          left: 7,
          right: 7,
          child: Row(
            children: [
              Expanded(
                  child: _summaryCard('Income', income(), 'assets/income.svg',
                      const Color(0xFF00A86B))),
              const SizedBox(width: 10),
              Expanded(
                  child: _summaryCard('Expenses', expenses(),
                      'assets/expense.svg', const Color(0xFFFD3C4A))),
            ],
          ),
        ),
        Positioned(top: 300, left: 0, right: 0, child: customScroll()),
      ],
    );
  }

  Widget _summaryCard(String title, int amount, String iconPath, Color color) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Container(
            margin: const EdgeInsets.only(right: 10),
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: const Color(0xFFFBFBFB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
                child: SvgPicture.asset(iconPath, width: 24, height: 28)),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
              Text('₹ $amount',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600)),
            ],
          )
        ],
      ),
    );
  }
}
