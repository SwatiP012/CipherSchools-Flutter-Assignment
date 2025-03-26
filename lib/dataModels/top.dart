import 'package:cipherx/dataModels/data.dart';

List<Money> geterTop() {
  Money snapFood = Money(
    name: 'Macdonald',
    time: 'Jan 30, 2022',
    image: 'assets/images/mac.jpg',
    fee: '- \$100',
    buy: true,
  );

  Money snap = Money(
    name: 'Transfer',
    time: 'Today',
    image: 'assets/images/cre.png',
    fee: '- \$60',
    buy: true,
  );

  return [snapFood, snap];
}