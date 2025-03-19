import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

void main() {
  runApp(QuoteOfTheDayApp());
}

class QuoteOfTheDayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Roboto',
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
List<String> quotes = [
  "The best way to predict the future is to create it. - Peter Drucker",
  "You miss 100% of the shots you don't take. - Wayne Gretzky",
  "The only way to do great work is to love what you do. - Steve Jobs",
  "Do what you can, with what you have, where you are. - Theodore Roosevelt",
  "Success is not final, failure is not fatal: it is the courage to continue that counts. - Winston Churchill",
  "Believe you can and you're halfway there. - Theodore Roosevelt",
  "Act as if what you do makes a difference. It does. - William James",
  "It always seems impossible until it’s done. - Nelson Mandela",
  "The only limit to our realization of tomorrow is our doubts of today. - Franklin D. Roosevelt",
  "Your time is limited, so don’t waste it living someone else’s life. - Steve Jobs",
  "The harder you work for something, the greater you’ll feel when you achieve it. - Unknown",
  "Don’t watch the clock; do what it does. Keep going. - Sam Levenson",
  "Dream big and dare to fail. - Norman Vaughan",
  "The future belongs to those who believe in the beauty of their dreams. - Eleanor Roosevelt",
  "If you want to lift yourself up, lift up someone else. - Booker T. Washington",
  "Keep your face always toward the sunshine—and shadows will fall behind you. - Walt Whitman",
  "Hardships often prepare ordinary people for an extraordinary destiny. - C.S. Lewis",
  "Opportunities don’t happen. You create them. - Chris Grosser",
  "It does not matter how slowly you go as long as you do not stop. - Confucius",
  "You are never too old to set another goal or to dream a new dream. - C.S. Lewis",
  "What lies behind us and what lies before us are tiny matters compared to what lies within us. - Ralph Waldo Emerson",
  "Happiness depends upon ourselves. - Aristotle",
  "We generate fears while we sit. We overcome them by action. - Dr. Henry Link",
  "If you can dream it, you can do it. - Walt Disney",
  "Doubt kills more dreams than failure ever will. - Suzy Kassem",
  "The secret of getting ahead is getting started. - Mark Twain",
  "A journey of a thousand miles begins with a single step. - Lao Tzu",
  "Everything you’ve ever wanted is on the other side of fear. - George Addair",
  "Success usually comes to those who are too busy to be looking for it. - Henry David Thoreau",
  "The way to get started is to quit talking and begin doing. - Walt Disney",
];


  List<String> favoriteQuotes = [];
  String currentQuote = "";
  DateTime lastUpdate = DateTime.now();

  @override
  void initState() {
    super.initState();
    currentQuote = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
    lastUpdate = DateTime.now();
  }

  void updateQuote() {
    if (DateTime.now().day != lastUpdate.day) {
      setState(() {
        currentQuote = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
        lastUpdate = DateTime.now();
      });
    }
  }

  void shareQuote() {
    if (currentQuote.isNotEmpty) {
      Share.share(currentQuote);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('No quote to share!')),
      );
    }
  }

  void toggleFavorite() {
    setState(() {
      if (favoriteQuotes.contains(currentQuote)) {
        favoriteQuotes.remove(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Removed from favorites!')),
        );
      } else {
        favoriteQuotes.add(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Added to favorites!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateQuote();
    return Scaffold(
      appBar: AppBar(
        title: Text('Quote of the Day', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blueAccent,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                currentQuote = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
              });
            },
          ),
          IconButton(
            icon: Icon(Icons.favorite, color: Colors.redAccent),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FavoritesScreen(favoriteQuotes: favoriteQuotes),
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blue.shade100, Colors.blue.shade400],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      currentQuote,
                      style: TextStyle(
                        fontSize: 22,
                        fontStyle: FontStyle.italic,
                        fontWeight: FontWeight.w500,
                        color: Colors.black87,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: shareQuote,
                      icon: Icon(Icons.share),
                      label: Text('Share'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blueAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                    SizedBox(width: 16),
                    ElevatedButton.icon(
                      onPressed: toggleFavorite,
                      icon: Icon(
                        favoriteQuotes.contains(currentQuote) ? Icons.favorite : Icons.favorite_border,
                        color: favoriteQuotes.contains(currentQuote) ? Colors.red : Colors.black,
                      ),
                      label: Text('Favorite'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.redAccent,
                        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  FavoritesScreen({required this.favoriteQuotes});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Quotes', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.redAccent,
      ),
      body: favoriteQuotes.isEmpty
          ? Center(
              child: Text(
                'No favorite quotes yet!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Container(
              padding: EdgeInsets.all(12),
              child: ListView.separated(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: Icon(Icons.format_quote, color: Colors.blueAccent),
                      title: Text(
                        favoriteQuotes[index],
                        style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => Divider(color: Colors.grey.shade400),
              ),
            ),
    );
  }
}