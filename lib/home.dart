import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:hackathon/cart.dart';
import 'package:hackathon/likedAnimation.dart';
import 'package:hackathon/likedDisliked.dart';
import 'package:swipe_cards/swipe_cards.dart';
import 'data.dart'; // Import your data file

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
            setState(() {});
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

  void _addToCart(String image) {
    cartImages.add(image);
    setState(() {});
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Added to cart!'),
      backgroundColor: Color.fromARGB(255, 11, 72, 33),
      duration: Duration(milliseconds: 300),
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Choose your fit!',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.grey[850],
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white),
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
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CartPage(
                    cartImages: cartImages,
                  ),
                ),
              );
            },
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
                              ? Colors.grey[850]
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: selectedCategory == categories[index]
                                  ? Colors.grey[300]
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
                    padding: EdgeInsets.all(16.0),
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
                                    _addToCart(item['image']);
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
                                            color: Colors.white, width: 2),
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
                                                              fontSize: 18)),
                                                    ),
                                                    SizedBox(
                                                      height: 20,
                                                    ),
                                                    Center(
                                                      child: Text(
                                                          'Price: ${item['price']}',
                                                          style: TextStyle(
                                                              fontSize: 16)),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                          'Seller: ${item['seller']}',
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                          'Selected ${item['selectionCount']} times',
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
                                                    Center(
                                                      child: Text(
                                                          'Sizes: ${item['availableSizes'].join(', ')}',
                                                          style: TextStyle(
                                                              fontSize: 14)),
                                                    ),
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
                                                                          'rating']
                                                                      .toDouble(),
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
                                                                      20.0,
                                                                  direction: Axis
                                                                      .horizontal,
                                                                ),
                                                                SizedBox(
                                                                    width: 8),
                                                                Expanded(
                                                                  child: Text(
                                                                      review['review'] ??
                                                                          ''),
                                                                ),
                                                              ],
                                                            );
                                                          }).toList(),
                                                        SizedBox(height: 15),
                                                        TextField(
                                                          decoration:
                                                              InputDecoration(
                                                            labelText:
                                                                'Write a review',
                                                            border:
                                                                OutlineInputBorder(),
                                                          ),
                                                          onSubmitted: (value) {
                                                            setState(() {
                                                              if (item[
                                                                      'reviews'] ==
                                                                  null) {
                                                                item['reviews'] =
                                                                    [];
                                                              }
                                                              item['reviews']!
                                                                  .add({
                                                                'rating': 5,
                                                                'review': value
                                                              });
                                                            });
                                                          },
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
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(
                                  content: Text('No more images!'),
                                ));
                              },
                              upSwipeAllowed: false,
                              fillSpace: true,
                            );
                          }),
                  ),
                ),
              ),
            ],
          ),
          if (showHeart)
            Positioned(
              top: MediaQuery.of(context).size.height / 2 - 80,
              right: MediaQuery.of(context).size.width / 2 - 20,
              child: HeartAnimation(
                onComplete: _onHeartAnimationComplete,
                show: true,
              ),
            ),
        ],
      ),
    );
  }
}
