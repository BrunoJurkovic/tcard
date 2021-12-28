// @dart=2.9

import 'package:flutter/material.dart';

import '../lib/tcard.dart';

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
  colors.length,
  (int index) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: colors[index],
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
  TCardController _controller = TCardController();

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
              rightIcon: const Icon(
                Icons.favorite,
                color: Colors.pink,
                size: 32,
              ),
              controller: _controller,
              onForward: (index, info) {
                // you can load more cards from you server
                var offset = 3;
                if (index >= cards.length - offset) {
                  print('loading more...');
                  List<Widget> addCards = List.generate(
                    colors.length,
                    (int index2) {
                      return Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colors[index2],
                        ),
                        child: Text(
                          '${index2 + 1}',
                          style:
                              TextStyle(fontSize: 100.0, color: Colors.white),
                        ),
                      );
                    },
                  ).toList();
                  setState(() {
                    cards.addAll(addCards);
                  });
                  _controller.append(addCards);
                }
                _index = index;
                print(info.direction);
                setState(() {});
              },
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
                OutlineButton(
                  onPressed: () {
                    _controller.back();
                  },
                  child: Text('Back'),
                ),
                OutlineButton(
                  onPressed: () {
                    _controller.forward();
                  },
                  child: Text('Forward'),
                ),
                OutlineButton(
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
