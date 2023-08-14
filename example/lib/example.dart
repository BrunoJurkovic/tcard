import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

List<Color> colors = [
  Colors.blue,
  Colors.yellow,
  Colors.red,
  Colors.orange,
  Colors.pink,
  Colors.amber,
  Colors.cyan,
  Colors.purple,
  Colors.brown,
  Colors.teal,
];

List<Widget> cards = List.generate(
  8,
  (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index].withOpacity(0.5),
      ),
      child: Text(
        '${index + 1}',
        style: TextStyle(fontSize: 100.0, color: Colors.white),
      ),
    );
  },
);

class TCardPage extends StatefulWidget {
  @override
  _TCardPageState createState() => _TCardPageState();
}

class _TCardPageState extends State<TCardPage> {
  final TCardController _controller = TCardController();

  int _index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 200),
            TCard(
              cards: cards,
              controller: _controller,
              stackPosition: StackPosition.right,
              onForward: (index, info) {},
              onBack: (index, info) {
                _index = index;
                setState(() {});
              },
              onEnd: () {
                print('end');
              },
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                TextButton(
                  onPressed: () {
                    _controller.back();
                  },
                  child: Text('Back'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.forward(direction: SwipeDirection.Left);
                  },
                  child: Text('Forward'),
                ),
                TextButton(
                  onPressed: () {
                    _controller.reset();
                  },
                  child: Text('Reset'),
                ),
                ElevatedButton(
                  onPressed: () {
                    // you can add more cards
                    _controller.append(cards);
                  },
                  child: Text('Append'),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: Text(_index.toString()),
      ),
    );
  }
}
