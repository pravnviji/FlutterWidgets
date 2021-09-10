import 'package:flutter/material.dart';

class LayoutPractice extends StatefulWidget {
  @override
  _LayoutPracticeState createState() => _LayoutPracticeState();
}

class _LayoutPracticeState extends State<LayoutPractice> {
  static Color _custColor = Colors.blue.shade900;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Layout Example'),
      ),
      body: ListView(
        children: [
          Image.asset(
            'assets/images/lake.jpeg',
            width: 600,
            height: 240,
            fit: BoxFit.cover,
          ),
          titleSection,
          buttonSection,
          textSection,
        ],
      ),
    );
  }

  Widget titleSection = Container(
    padding: const EdgeInsets.all(30),
    child: Row(
      children: [
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: const Text(
                  'Great Picture 2021',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              Text(
                'Kandersteg, Switzerland',
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[500],
                    fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        FavouriteIcon(),
      ],
    ),
  );

  Widget buttonSection = Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _buildButtonColumn(_custColor, Icons.call, "Call"),
        _buildButtonColumn(_custColor, Icons.near_me, "Route"),
        _buildButtonColumn(_custColor, Icons.share, "Share")
      ]);

  Widget textSection = const Padding(
    padding: EdgeInsets.all(32),
    child: Text(
      'Lake Oeschinen lies at the foot of the Blüemlisalp in the Bernese '
      'Alps. Situated 1,578 meters above sea level, it is one of the '
      'larger Alpine Lakes. A gondola ride from Kandersteg, followed by a '
      'half-hour walk through pastures and pine forest, leads you to the '
      'lake, which warms to 20 degrees Celsius in the summer. Activities '
      'enjoyed here include rowing, and riding the summer toboggan run.',
      softWrap: true,
    ),
  );
}

Column _buildButtonColumn(Color color, IconData icon, String label) {
  return Column(
    mainAxisSize: MainAxisSize.min,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(
        icon,
        color: color,
        size: 28,
      ),
      Container(
        margin: const EdgeInsets.only(top: 12),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: color,
          ),
        ),
      ),
    ],
  );
}

class FavouriteIcon extends StatefulWidget {
  const FavouriteIcon({Key? key}) : super(key: key);

  @override
  _FavouriteIconState createState() => _FavouriteIconState();
}

class _FavouriteIconState extends State<FavouriteIcon> {
  bool _isFavorited = false;
  int _favoriteCount = 40;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            child: IconButton(
          icon: (_isFavorited
              ? const Icon(
                  Icons.star,
                  color: Colors.red,
                )
              : const Icon(Icons.star_border)),
          onPressed: _toggleFavourite,
        )),
        SizedBox(
          width: 18,
          child: SizedBox(
            child: Text('$_favoriteCount'),
          ),
        ),
      ],
    );
  }

  void _toggleFavourite() {
    setState(() {
      if (_isFavorited) {
        _favoriteCount -= 1;
        _isFavorited = false;
      } else {
        _favoriteCount += 1;
        _isFavorited = true;
      }
    });
  }
}
