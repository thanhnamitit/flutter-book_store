import 'dart:ui';

import 'package:flutter/material.dart';

void main() => runApp(App());

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: BookStore(),
    );
  }
}

class BookStore extends StatefulWidget {
  @override
  _BookStoreState createState() => _BookStoreState();
}

class _BookStoreState extends State<BookStore> with TickerProviderStateMixin {
  static const ANIMATION_DURATION = 500;
  static const BUTTON_HEIGHT = 58.0;
  static const RADIUS = 24.0;
  static const HORIZONTAL_PADDING = 24.0;
  static const BOOKSHELF_PAGE_HEIGHT = 354.0;

  AnimationController _controller;
  Animation<double> valueTween;
  Animation<Color> colorTween;
  Animation<double> tabHeightAnim;
  Animation<double> popularPageHeight;
  Animation<double> bookshelfPageHeight;
  Animation<Color> grayToWhite;
  Animation<Color> whiteToGray;
  Animation<Color> popularLabelColor;
  Animation<Color> bookShelfLabelColor;
  Animation<double> valueAnimation;

  final gray = Color(0xffdbe1ed);
  final white = Colors.white;
  final closedLabelColor = Color(0xff9fa5b2);

  _init() {
    final screenHeight = MediaQuery.of(context).size.height;
    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: ANIMATION_DURATION),
    );
    CurvedAnimation parent = CurvedAnimation(
      parent: _controller,
      curve: Curves.ease,
      reverseCurve: Curves.ease,
    );

    bookshelfPageHeight = Tween<double>(
      end: BUTTON_HEIGHT,
      begin: BOOKSHELF_PAGE_HEIGHT,
    ).animate(parent);

    final minPopularPageHeight = BOOKSHELF_PAGE_HEIGHT + BUTTON_HEIGHT;

    final maxTabHeight = minPopularPageHeight;
    final minTabHeight = screenHeight / 3.5;

    tabHeightAnim = Tween<double>(
      begin: maxTabHeight,
      end: minTabHeight,
    ).animate(parent);

    grayToWhite = ColorTween(
      begin: gray,
      end: white,
    ).animate(parent);
    whiteToGray = ColorTween(
      begin: white,
      end: gray,
    ).animate(parent);
    valueTween = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(parent);
    colorTween = ColorTween(
      begin: Colors.black,
      end: Colors.white,
    ).animate(parent);

    bookShelfLabelColor = ColorTween(
      begin: Colors.black,
      end: closedLabelColor,
    ).animate(parent);

    popularLabelColor = ColorTween(
      end: Colors.black,
      begin: closedLabelColor,
    ).animate(parent);

    valueAnimation = Tween<double>(
      begin: 1,
      end: 0,
    ).animate(parent);
  }

  _forward() => _controller.forward();

  _reverse() => _controller.reverse();

  _buildSearchMenu() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: <Widget>[
                Icon(
                  Icons.search,
                  size: 16,
                ),
                SizedBox(width: 12),
                Text(
                  "Search or scan",
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.5),
                      fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
        ),
        SizedBox(width: 24),
        Icon(
          Icons.menu,
          color: Colors.white,
        ),
      ],
    );
  }

  _buildTabIndicator() {
    return Row(
      children: Iterable.generate(
        4,
        (index) => Container(
          margin: EdgeInsets.all(4),
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index == 2 ? Colors.white : Colors.grey.withOpacity(0.3),
          ),
        ),
      ).toList(),
    );
  }

  _buildTabTitle() {
    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Transform.scale(
              alignment: Alignment.centerLeft,
              scale: valueAnimation.value,
              child: Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 16 * valueAnimation.value),
                child: Text(
                  "New 93 books",
                  style: TextStyle(
                    color: Colors.grey.withOpacity(0.7),
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            Text(
              "MY STERIES & \nTHRILLERS",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 32)
          ],
        ),
        Positioned(
          bottom: 32,
          left: 0,
          right: 0,
          child: Row(
            children: <Widget>[
              Spacer(
                flex: 1000,
              ),
              _buildTabIndicator(),
              Spacer(
                flex: (1001 - (1 - valueAnimation.value) * 1000).toInt(),
              )
            ],
          ),
        )
      ],
    );
  }

  _buildTab() {
    final height = tabHeightAnim.value + 32;
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: ExactAssetImage('image/tab.png'),
            fit: BoxFit.cover,
          ),
        ),
        height: height,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 24),
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                _buildSearchMenu(),
                Expanded(child: _buildTabTitle()),
              ],
            ),
          ),
        ),
      ),
    );
  }

  _buildTitle(String title, Color titleColor, double animValue,
      {Function onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
        height: BUTTON_HEIGHT,
        child: Row(
          children: <Widget>[
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
                color: titleColor,
              ),
            ),
            Expanded(
              child: Stack(
                alignment: Alignment.topRight,
                children: <Widget>[
                  Opacity(
                    opacity: 1 - animValue,
                    child: Text(
                      "See all",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  ),
                  Opacity(
                    opacity: animValue,
                    child: Text(
                      "Open section",
                      textAlign: TextAlign.right,
                      style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: closedLabelColor),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildPopularItem(Book book) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: HORIZONTAL_PADDING),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(
                width: 84,
                child: AspectRatio(
                  aspectRatio: 384 / 614,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(
                      book.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          book.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          "\$ ${book.price}",
                          style: TextStyle(fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Text(
                      book.author,
                      style: TextStyle(
                        fontWeight: FontWeight.w300,
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    SizedBox(height: 24),
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.star,
                          size: 18,
                          color: Colors.pink,
                        ),
                        SizedBox(width: 2),
                        Text(
                          "${book.rating}",
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 12,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 12),
          Container(
            height: 1,
            color: Colors.grey.withOpacity(0.3),
          ),
          SizedBox(height: 12),
        ],
      ),
    );
  }

  _buildPopularPage() {
    return Positioned(
      top: tabHeightAnim.value,
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        decoration: BoxDecoration(
          color: grayToWhite.value,
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(RADIUS),
              topRight: Radius.circular(RADIUS * (1 - valueAnimation.value))),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildTitle(
              "Popular page",
              popularLabelColor.value,
              valueAnimation.value,
              onTap: _forward,
            ),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.only(top: 6, bottom: BUTTON_HEIGHT + 6),
                shrinkWrap: true,
                itemBuilder: (_, index) =>
                    _buildPopularItem(booksInPopular[index]),
                itemCount: booksInPopular.length,
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildBookshelfItem(Book book) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: SizedBox(
        width: 130,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            AspectRatio(
              aspectRatio: 384 / 614,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  book.image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(height: 5),
            SizedBox(
              height: 4,
              child: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  FractionallySizedBox(
                    alignment: Alignment.topLeft,
                    widthFactor: book.progress / 100.0,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.red.withOpacity(.8),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(height: 10),
            Text(
              book.name,
              maxLines: 1,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 2),
            Text(
              book.author,
              maxLines: 1,
              style: TextStyle(
                color: Colors.grey,
                fontWeight: FontWeight.w400,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildBookShelfPage() {
    return Positioned(
      left: 0,
      right: 0,
      bottom: 0,
      child: Container(
        decoration: BoxDecoration(
          color: whiteToGray.value,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(RADIUS),
            topRight: Radius.circular(RADIUS),
          ),
        ),
        height: bookshelfPageHeight.value,
        child: ListView(
          padding: EdgeInsets.all(0),
          children: <Widget>[
            _buildTitle(
              "Bookshelf",
              bookShelfLabelColor.value,
              1 - valueAnimation.value,
              onTap: _reverse,
            ),
            Container(
              child: SingleChildScrollView(
                padding: EdgeInsets.only(left: HORIZONTAL_PADDING),
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: booksInShelf
                      .map((it) => _buildBookshelfItem(it))
                      .toList(),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    _init();
    return Scaffold(
      body: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            fit: StackFit.expand,
            children: <Widget>[
              _buildTab(),
              _buildPopularPage(),
              _buildBookShelfPage(),
            ],
          );
        },
      ),
    );
  }
}

class Book {
  final String name;
  final String author;
  final int progress;
  final String image;
  final String price;
  final double rating;

  Book({
    this.name,
    this.author,
    this.progress,
    this.image,
    this.price = "",
    this.rating = 0.0,
  });
}

final booksInShelf = [
  Book(
    name: "Cleansed by dead",
    author: "Catherine finger",
    progress: 50,
    image: "image/1.jpg",
  ),
  Book(
    name: "A thin veil",
    author: "Jane Gorman",
    progress: 34,
    image: "image/2.jpg",
  ),
  Book(
    name: "Be mine",
    author: "Rick mofina",
    progress: 38,
    image: "image/3.jpg",
  ),
  Book(
    name: "Rick mofina",
    author: "Before sunrise",
    progress: 94,
    image: "image/4.jpg",
  ),
  Book(
    name: "Bullet in the blue sky",
    author: "Bill larkin",
    progress: 80,
    image: "image/5.jpg",
  ),
];

final booksInPopular = [
  Book(
    name: "Cleansed by dead",
    author: "Catherine finger",
    progress: 50,
    image: "image/7.jpg",
    rating: 8.2,
    price: "9.95",
  ),
  Book(
    name: "A thin veil",
    author: "Jane Gorman",
    progress: 34,
    image: "image/8.jpg",
    rating: 8.2,
    price: "11.95",
  ),
  Book(
    name: "Be mine",
    author: "Rick mofina",
    progress: 38,
    image: "image/9.jpg",
    rating: 9.2,
    price: "8.95",
  ),
  Book(
    name: "Rick mofina",
    author: "Before sunrise",
    rating: 6.4,
    price: "6.95",
    progress: 94,
    image: "image/10.jpg",
  ),
  Book(
    name: "Bullet in the blue sky",
    rating: 7.4,
    price: "12.95",
    author: "Bill larkin",
    progress: 80,
    image: "image/11.jpg",
  ),
  Book(
    name: "Bullet in the blue sky",
    author: "Bill larkin",
    progress: 80,
    image: "image/12.jpg",
    rating: 8.2,
    price: "8.99",
  ),
  Book(
    name: "Bullet in the blue sky",
    author: "Bill larkin",
    progress: 80,
    image: "image/13.jpg",
    rating: 8.2,
    price: "8.99",
  ),
];
