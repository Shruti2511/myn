import 'package:flutter/material.dart';
import 'package:hackathon/cart.dart';
import 'package:hackathon/likedAnimation.dart';
import 'package:hackathon/likedDisliked.dart';
import 'package:swipe_cards/swipe_cards.dart';

class ImageSwipingPage extends StatefulWidget {
  @override
  _ImageSwipingPageState createState() => _ImageSwipingPageState();
}

class _ImageSwipingPageState extends State<ImageSwipingPage> {
  List<String> categories = ['Outfits', 'Pendants', 'Skirts', 'Dresses', 'Shoes', 'Hand Bags'];
  String selectedCategory = 'Outfits';

  Map<String, List<String>> categoryImages = {
    'Outfits': ['assets/O1.jpg', 'assets/O2.jpg', 'assets/O3.jpg', 'assets/O4.jpg', 'assets/O5.jpg', 'assets/O6.jpg', 'assets/O7.jpg', 'assets/O8.jpg', 'assets/O9.jpg', 'assets/O10.png', 'assets/O11.jpg', 'assets/O12.jpg', 'assets/O13.jpg', 'assets/O14.jpg', 'assets/O15.png'],
    'Skirts': ['assets/S1.jpg', 'assets/S2.jpeg', 'assets/S3.jpeg', 'assets/S4.jpeg', 'assets/S5.png', 'assets/S6.jpg', 'assets/S7.jpg', 'assets/S8.jpg', 'assets/S9.jpg'],
    'Dresses': ['assets/O1.jpg', 'assets/O2.jpg', 'assets/O3.jpg', 'assets/O4.jpg'],
    'Shoes': ['assets/O1.jpg', 'assets/O2.jpg', 'assets/O3.jpg', 'assets/O4.jpg'],
    'Pendants': ['assets/N1.jpg', 'assets/N2.jpg', 'assets/N3.jpg', 'assets/N4.jpg', 'assets/N5.jpg', 'assets/N6.jpg', 'assets/N7.jpg', 'assets/N8.jpg', 'assets/N9.png', 'assets/N10.jpg', 'assets/N11.jpeg'],
  };

  List<String> likedImages = [];
  List<String> cartImages = [];
  List<String> dislikedImages = [];
  late MatchEngine _matchEngine;
  List<SwipeItem> _swipeItems = [];
  int points = 0;
  bool showHeart = false;

  @override
  void initState() {
    super.initState();
    _loadCategoryImages();
  }

  void _loadCategoryImages() {
    _swipeItems = categoryImages[selectedCategory]!.map((image) {
      return SwipeItem(
        content: image,
        likeAction: () {
          likedImages.add(image);
          points++;
          setState(() {
            showHeart = true;
          });
        },
        nopeAction: () {
          dislikedImages.add(image);
          points++;
          setState(() {});
        },
      );
    }).toList();

    _matchEngine = MatchEngine(swipeItems: _swipeItems);
    setState(() {});
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
      duration: Duration(milliseconds: 300), // Fast flash
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Choose your fit!', style: TextStyle(color: Colors.white)), // White text
        backgroundColor: Colors.grey[850], // Dark grey AppBar
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.white), // White icon
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LikedDislikedPage(
                    likedImages: likedImages,
                    dislikedImages: dislikedImages,
                    points: points,
                  ),
                ),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white), // White icon
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
                        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                        decoration: BoxDecoration(
                          color: selectedCategory == categories[index] ? Colors.grey[850] : Colors.grey[300], // Dark grey for selected, light grey for others
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Center(
                          child: Text(
                            categories[index],
                            style: TextStyle(
                              color: selectedCategory == categories[index] ? Colors.grey[300] : Colors.grey[850], // White text
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
                    width: MediaQuery.of(context).size.width * 0.8, // Center the cards
                    padding: EdgeInsets.all(16.0),
                    child: SwipeCards(
                      matchEngine: _matchEngine,
                      itemBuilder: (BuildContext context, int index) {
                        return GestureDetector(
                          onDoubleTap: () {
                            _addToCart(_swipeItems[index].content);
                            _matchEngine.currentItem?.like();
                          },
                          child: SizedBox(
                            width: 300, // Fixed width
                            height: 400, // Fixed height
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                                side: BorderSide(color: Colors.white, width: 2), // White border
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10.0), // Rounded corners
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    _swipeItems[index].content,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      onStackFinished: () {
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('No more images!'),
                        ));
                      },
                      upSwipeAllowed: false,
                      fillSpace: true,
                    ),
                  ),
                ),
              ),
            ],
          ),
          HeartAnimation(
            show: showHeart,
            onComplete: _onHeartAnimationComplete,
          ),
        ],
      ),
    );
  }
}
