import 'package:cipherx/dataModels/data.dart';

List<Money> geter() {
  return [
    Money(
      name: 'Upwork',
      fee: '650',
      time: 'Today',
      image: 'assets/images/up.png',
      buy: false,
    ),
    Money(
      name: 'Starbucks',
      fee: '15',
      time: 'Today',
      image: 'assets/images/Star.jpg',
      buy: true,
    ),
    Money(
      name: 'Transfer for Sam',
      fee: '100',
      time: 'Jan 30, 2022',
      image: 'assets/images/cre.png',
      buy: true,
    ),
  
  ];
}
