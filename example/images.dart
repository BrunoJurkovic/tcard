// @dart=2.9

import 'package:flutter/material.dart';
import 'package:tcard/tcard.dart';

List<String> images = [
  'https://gank.io/images/5ba77f3415b44f6c843af5e149443f94',
  'https://gank.io/images/02eb8ca3297f4931ab64b7ebd7b5b89c',
  'https://gank.io/images/31f92f7845f34f05bc10779a468c3c13',
  'https://gank.io/images/b0f73f9527694f44b523ff059d8a8841',
  'https://gank.io/images/1af9d69bc60242d7aa2e53125a4586ad',
];

List<Widget> cards = List.generate(
  images.length,
  (int index) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            offset: Offset(0, 17),
            blurRadius: 23.0,
            spreadRadius: -13.0,
            color: Colors.black54,
          )
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.0),
        child: Image.network(
          images[index],
          fit: BoxFit.cover,
        ),
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
            SizedBox(height: 120),
            TCard(
              size: Size(400, 600),
              cards: cards,
              controller: _controller,
              onForward: (index, info) {
                _index = index;
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
