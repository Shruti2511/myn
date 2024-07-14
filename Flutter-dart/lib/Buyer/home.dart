import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon/Buyer/myOrders.dart';
import 'package:hackathon/Buyer/shoppingBag.dart';
import 'package:hackathon/Buyer/likedAnimation.dart';
import 'package:hackathon/Buyer/likedPage.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'data.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  List<String> likedImages = [];
  List<String> cartImages = [];
  List<String> dislikedImages = [];
  int points = 0;
  bool showHeart = false;
  bool showBrokenHeart = false;
  String selectedCategory = ''; // Initialize selectedCategory

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.isNotEmpty
        ? categories[0]
        : ''; // Initialize with the first category
    _loadCategoryImages();
  }

  void _loadCategoryImages() {
    // Check if selectedCategory is not null and exists in categoryImages
    if (selectedCategory.isNotEmpty &&
        categoryImages.containsKey(selectedCategory)) {
      _swipeItems = categoryImages[selectedCategory]!.map((item) {
        return SwipeItem(
          content: item,
          likeAction: () {
            likedImages.add(item['image']);
            points++;
            setState(() {
              showHeart = true;
            });
          },
          nopeAction: () {
            dislikedImages.add(item['image']);
            points++;
            setState(() {
              showBrokenHeart = true;
            });
          },
        );
      }).toList();

      _matchEngine = MatchEngine(swipeItems: _swipeItems);
      setState(() {});
    }
  }

  void _onHeartAnimationComplete() {
    setState(() {
      showHeart = false;
    });
  }

  void _onBrokenHeartAnimationComplete() {
    setState(() {
      showBrokenHeart = false;
    });
  }

  void _addToBag(String image) {
    cartImages.add(image);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Center(child: Text('Added to bag!')),
      backgroundColor: Color.fromARGB(255, 11, 72, 33),
      duration: Duration(milliseconds: 500),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          'Fashion Rental',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.favorite_border,
                color: Color.fromARGB(213, 255, 68, 190)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikedScreen(
                    likedImages: likedImages,
                    dislikedImages: dislikedImages,
                    points: points,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_bag_outlined,
                color: Color.fromARGB(213, 255, 68, 190)),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShoppingBag(
                    cartImages: cartImages,
                  ),
                ),
              );
            },
          ),
          PopupMenuButton<String>(
            icon: Icon(Icons.menu, color: Color.fromARGB(213, 255, 68, 190)),
            onSelected: (String result) {
              if (result == 'show_orders') {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => OrdersPage()),
                );
              }
            },
            itemBuilder: (BuildContext context) => [
              PopupMenuItem<String>(
                value: 'show_orders',
                child: Text('Show Orders'),
              ),
            ],
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                height: 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedCategory = categories[index];
                          _loadCategoryImages();
                        });
                      },
                      child: Container(
                        margin: EdgeInsets.all(8.0),
                        padding: EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: selectedCategory == categories[index]
                              ? Color.fromARGB(213, 255, 68, 190)
                              : Color.fromARGB(154, 248, 190, 228),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: const Color.fromARGB(255, 216, 216, 216)),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              fontWeight: FontWeight.w500,
                              fontSize: 12,
                              color: selectedCategory == categories[index]
                                  ? Colors.white
                                  : Colors.grey[850],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.9,
                    padding: EdgeInsets.fromLTRB(4, 10, 4, 10),
                    child: _swipeItems.isEmpty
                        ? Center(
                            child: Text(
                              'No images available for $selectedCategory',
                              style: TextStyle(fontSize: 18),
                            ),
                          )
                        : Builder(builder: (context) {
                            return SwipeCards(
                              matchEngine: _matchEngine,
                              itemBuilder: (BuildContext context, int index) {
                                var item = _swipeItems[index].content;
                                return GestureDetector(
                                  onDoubleTap: () {
                                    _addToBag(
                                      item['image'],
                                    );
                                    _matchEngine.currentItem?.like();
                                  },
                                  child: SizedBox(
                                    width: 350,
                                    height: 600,
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(
                                            color: Color.fromARGB(
                                                255, 154, 152, 152),
                                            width: 2),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        child: SingleChildScrollView(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Image.asset(
                                                item['image'],
                                                fit: BoxFit.fitWidth,
                                                width: double.infinity,
                                              ),
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    SizedBox(height: 5),
                                                    Center(
                                                      child: Text(item['name'],
                                                          style: TextStyle(
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              fontSize: 16)),
                                                    ),
                                                    SizedBox(
                                                      height: 10,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                          'Renting Price: ${item['price']}',
                                                          style: TextStyle(
                                                              fontSize: 15,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold)),
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      'Seller: ${item['seller']}',
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Text(
                                                        'Selected ${item['selectionCount']} times',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    Text(
                                                        'Sizes: ${item['availableSizes'].join(', ')}',
                                                        style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight
                                                                    .w500)),
                                                    SizedBox(height: 20),
                                                    Center(
                                                      child: Text('Reviews:',
                                                          style: TextStyle(
                                                              fontStyle:
                                                                  FontStyle
                                                                      .italic,
                                                              fontSize: 14)),
                                                    ),
                                                    Column(
                                                      children: [
                                                        if (item['reviews'] !=
                                                            null)
                                                          ...item['reviews']
                                                              .map<Widget>(
                                                                  (review) {
                                                            return Row(
                                                              children: [
                                                                RatingBarIndicator(
                                                                  rating: review[
                                                                      'rating'].toDouble(),
                                                                  itemBuilder:
                                                                      (context,
                                                                              index) =>
                                                                          Icon(
                                                                    Icons.star,
                                                                    color: Colors
                                                                        .amber,
                                                                  ),
                                                                  itemCount: 5,
                                                                  itemSize:
                                                                      18.0,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                ),
                                                                SizedBox(
                                                                  width: 8.0,
                                                                ),
                                                                Expanded(
                                                                  child: Text(
                                                                    review[
                                                                        'text'],
                                                                    style: TextStyle(
                                                                        fontSize:
                                                                            14),
                                                                  ),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                        SizedBox(height: 10),
                                                        Row(
                                                          children: [
                                                            Expanded(
                                                              child: TextField(
                                                                decoration:
                                                                    InputDecoration(
                                                                  hintText:
                                                                      'Add your review...',
                                                                  border:
                                                                      OutlineInputBorder(),
                                                                ),
                                                                onSubmitted:
                                                                    (value) {
                                                                  setState(() {
                                                                    item['reviews'] ??=
                                                                        [];
                                                                    item['reviews']
                                                                        .add({
                                                                      'rating':
                                                                          0.0,
                                                                      'text':
                                                                          value,
                                                                    });
                                                                  });
                                                                },
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                              onStackFinished: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content:
                                        Center(child: Text('No more items!')),
                                    backgroundColor:
                                        Color.fromARGB(255, 11, 72, 33),
                                    duration: Duration(milliseconds: 500),
                                  ),
                                );
                              },
                            );
                          }),
                  ),
                ),
              ),
            ],
          ),
          IconAnimation(
            show: showHeart,
            onComplete: _onHeartAnimationComplete,
            icon: Icons.favorite,
            color: Colors.red,
          ),
          IconAnimation(
            show: showBrokenHeart,
            onComplete: _onBrokenHeartAnimationComplete,
            icon: Icons.sentiment_dissatisfied_outlined,
            color: Colors.yellow,
          ),
        ],
      ),
    );
  }
}
