import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_generative_ai/google_generative_ai.dart';

void main() {
  runApp(QuoteOfTheDayApp());
}

class QuoteOfTheDayApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Quote of the Day',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.cyan,
        fontFamily: 'Orbitron',
        scaffoldBackgroundColor: Colors.black,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.cyanAccent,
          titleTextStyle: TextStyle(
            fontFamily: 'Orbitron',
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.cyanAccent,
            foregroundColor: Colors.black,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
        ),
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
    "I don’t doubt that we’re in a simulation. I just think it’s not that important unless it gives me power over nature. - George Hotz",
    "The codebase at Twitter was a mess because promotions were tied to making bloated libraries. - George Hotz",
    "I’m good at things when it’s wartime, not at patiently scaling up. - George Hotz",
    "AI is a fascinating psychology problem, not just a driving challenge. - George Hotz",
    "Don’t work for Darth Vader, man. - George Hotz (on Andrej Karpathy joining OpenAI)",
    "To me, science is about understanding the world, not pushing an agenda. - Lex Fridman",
    "The beauty of AI is in its ability to reveal the human condition. - Lex Fridman",
    "I’d rather listen and learn than pretend to know it all. - Lex Fridman",
    "Technology is a mirror to our humanity, reflecting both our brilliance and flaws. - Lex Fridman",
    "Elon Musk is at a higher intellectual level than most journalists. - Lex Fridman",
    "We’re going to make America great again with technology—tremendous, believe me. - Donald Trump",
    "I have the best tech, folks, nobody does it better than me. - Donald Trump",
    "AI is fantastic, but we need to keep it under control, it’s a big deal. - Donald Trump",
    "Elon Musk is a genius, one of the smartest guys out there, I love what he’s doing. - Donald Trump",
    "Cybersecurity is huge, and I’ve got the best people working on it. - Donald Trump",
    "The best way to predict the future is to invent it—wait, I made that better than Drucker! - Elon Musk",
    "AI is our biggest existential risk, but also our greatest opportunity. - Elon Musk",
    "I’d like to die on Mars, just not on impact. - Elon Musk",
    "The goal of Neuralink is to merge human cognition with AI—pretty cool, right? - Elon Musk",
    "If you’re not failing, you’re not innovating enough. - Elon Musk",
    "Superhuman AI will be the final boss of humanity. - Ilya Sutskever",
    "Alignment is about making AI behave nicely before it outsmarts us. - Ilya Sutskever",
    "The beauty of deep learning is its simplicity behind the complexity. - Ilya Sutskever",
    "AGI is not the end, it’s the beginning of a new era. - Ilya Sutskever",
    "We need to get AI right for the sake of humanity. - Ilya Sutskever",
    "Innovation distinguishes between a leader and a follower. - Steve Jobs",
    "Stay hungry, stay foolish—it’s how you change the world. - Steve Jobs",
    "Technology is nothing without creativity driving it. - Steve Jobs",
    "The cloud is just someone else’s computer—let’s make it ours. - Satya Nadella",
    "AI will amplify human ingenuity, not replace it. - Satya Nadella",
    "The future is open source, because collaboration beats control. - Linus Torvalds",
    "Software is like sex: it’s better when it’s free. - Linus Torvalds",
    "Talk is cheap, show me the code. - Linus Torvalds",
    "The internet is the most powerful tool we’ve ever built. - Jeff Bezos",
    "Work backwards from the customer—everything else follows. - Jeff Bezos",
    "AI is the new electricity, powering everything soon. - Andrew Ng",
    "Machine learning is the art of teaching computers to learn like humans. - Andrew Ng",
    "The best ideas come from asking ‘what if’ over and over. - Tim Cook",
    "Privacy is a fundamental human right in the tech age. - Tim Cook",
    "AGI should be a tool for humans, not a replacement. - Sam Altman",
    "The pace of AI progress is insane—buckle up. - Sam Altman",
    "We’re not here to hoard tech; we’re here to share it. - Mark Zuckerberg",
    "Move fast and break things—then fix them better. - Mark Zuckerberg",
    "AI is about augmenting reality, not escaping it. - Sundar Pichai",
    "Quantum computing will redefine what’s possible. - Sundar Pichai",
    "The web is a living thing—keep it wild and free. - Tim Berners-Lee",
    "Data is the new oil, but ethics is the refinery. - Ginni Rometty",
    "Great tech comes from great teams, not lone geniuses. - Jack Dorsey",
    "Bitcoin is the future of money—simple as that. - Jack Dorsey",
    "Keep pushing the boundaries, because that’s where magic happens. - Jensen Huang",
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
        const SnackBar(content: Text('No quote to share!')),
      );
    }
  }

  void toggleFavorite() {
    setState(() {
      if (favoriteQuotes.contains(currentQuote)) {
        favoriteQuotes.remove(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Removed from favorites!')),
        );
      } else {
        favoriteQuotes.add(currentQuote);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Added to favorites!')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    updateQuote();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quote of the Day'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              setState(() {
                currentQuote = quotes[DateTime.now().millisecondsSinceEpoch % quotes.length];
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.favorite, color: Colors.redAccent),
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
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.black, Color.fromARGB(255, 49, 56, 59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Card(
                        elevation: 10,
                        color: Colors.white.withOpacity(0.1),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: const BorderSide(color: Colors.cyanAccent, width: 1),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Text(
                            currentQuote,
                            style: const TextStyle(
                              fontSize: 22,
                              fontStyle: FontStyle.italic,
                              fontWeight: FontWeight.w500,
                              color: Colors.cyanAccent,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: shareQuote,
                            icon: const Icon(Icons.share),
                            label: const Text('Share'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 16),
                          ElevatedButton.icon(
                            onPressed: toggleFavorite,
                            icon: Icon(
                              favoriteQuotes.contains(currentQuote)
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.redAccent,
                            ),
                            label: const Text('Favorite'),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        height: 300,
                        child: ChatWidget(
                          apiKey: "AIzaSyB88Y5ctTPAqV0-Omf8ly0pHxHbudtwgQQ", // Replace with your actual API key
                          currentQuote: currentQuote,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Chat Widget
class ChatWidget extends StatefulWidget {
  const ChatWidget({required this.apiKey, required this.currentQuote, super.key});
  final String apiKey;
  final String currentQuote;

  @override
  State<ChatWidget> createState() => _ChatWidgetState();
}

class _ChatWidgetState extends State<ChatWidget> {
  late final GenerativeModel _model;
  late final ChatSession _chat;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _textController = TextEditingController();
  final FocusNode _textFieldFocus = FocusNode();
  final List<({String? text, bool fromUser})> _messages = [];
  bool _loading = false;

  final String _promptTemplate =
      "You are a futuristic AI advisor. Given the quote: '{{QUOTE}}', provide practical, actionable steps to implement its meaning in daily life. Be concise, witty, and forward-thinking. Avoid using markdown like ** or * in your response.";

  @override
  void initState() {
    super.initState();
    _model = GenerativeModel(
      model: 'gemini-1.5-pro',
      apiKey: widget.apiKey,
    );
    _chat = _model.startChat();
    _sendInitialMessage();
  }

  @override
  void didUpdateWidget(ChatWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.currentQuote != oldWidget.currentQuote) {
      // Quote has changed, reset chat and prompt AI again
      setState(() {
        _messages.clear(); // Clear previous messages
        _loading = false; // Reset loading state
      });
      _sendInitialMessage(); // Prompt AI with new quote
    }
  }

  void _sendInitialMessage() async {
    final prompt = _promptTemplate.replaceAll('{{QUOTE}}', widget.currentQuote);
    setState(() {
      _messages.add((text: prompt, fromUser: true));
      _loading = true;
    });
    final response = await _chat.sendMessage(Content.text(prompt));
    setState(() {
      _messages.add((text: _cleanText(response.text), fromUser: false));
      _loading = false;
    });
    _scrollDown();
  }

  String _cleanText(String? text) {
    if (text == null) return '';
    return text.replaceAll(RegExp(r'\*\*|\*'), '');
  }

  void _scrollDown() {
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOut,
      ),
    );
  }

  void _sendMessage() async {
    final text = _textController.text;
    _textController.clear();
    if (text.isNotEmpty) {
      setState(() {
        _messages.add((text: text, fromUser: true));
        _loading = true;
      });
      final response = await _chat.sendMessage(Content.text(text));
      setState(() {
        _messages.add((text: _cleanText(response.text), fromUser: false));
        _loading = false;
      });
      _scrollDown();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            controller: _scrollController,
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final message = _messages[index];
              if (message.fromUser && index == 0) return const SizedBox.shrink();
              return Align(
                alignment: message.fromUser ? Alignment.centerRight : Alignment.centerLeft,
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: message.fromUser
                        ? Colors.cyanAccent.withOpacity(0.3)
                        : Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.cyanAccent),
                  ),
                  child: Text(
                    message.text ?? '',
                    style: const TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              );
            },
          ),
        ),
        if (_loading) const TriangleLoadingIndicator(),
        Container(
          padding: const EdgeInsets.all(8.0),
          decoration: const BoxDecoration(
            color: Colors.black,
            border: Border(top: BorderSide(color: Colors.cyanAccent)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  focusNode: _textFieldFocus,
                  controller: _textController,
                  decoration: InputDecoration(
                    hintText: 'Ask for more steps...',
                    hintStyle: const TextStyle(
                      color: Colors.cyanAccent,
                      fontFamily: 'Orbitron',
                      fontSize: 16,
                    ),
                    filled: true,
                    fillColor: Colors.black.withOpacity(0.7),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.cyanAccent,
                        width: 2,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.cyanAccent,
                        width: 2,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(
                        color: Colors.cyanAccent,
                        width: 2,
                      ),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    suffixIcon: Container(
                      margin: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [Colors.cyanAccent, Colors.blueAccent],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyanAccent.withOpacity(0.5),
                            blurRadius: 8,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.black),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ),
                  style: const TextStyle(
                    color: Colors.cyanAccent,
                    fontFamily: 'Orbitron',
                    fontSize: 16,
                  ),
                  onSubmitted: (_) => _sendMessage(),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// Custom Triangle Loading Indicator
class TriangleLoadingIndicator extends StatefulWidget {
  const TriangleLoadingIndicator({super.key});

  @override
  _TriangleLoadingIndicatorState createState() => _TriangleLoadingIndicatorState();
}

class _TriangleLoadingIndicatorState extends State<TriangleLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: 30,
        height: 30,
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return CustomPaint(
              painter: TrianglePainter(_controller.value),
            );
          },
        ),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  final double progress;

  TrianglePainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.cyanAccent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final path = Path();
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(2 * 3.14159 * progress);
    canvas.translate(-center.dx, -center.dy);

    path.moveTo(center.dx, center.dy - radius);
    path.lineTo(center.dx - radius * 0.866, center.dy + radius * 0.5);
    path.lineTo(center.dx + radius * 0.866, center.dy + radius * 0.5);
    path.close();

    canvas.drawPath(path, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// FavoritesScreen
class FavoritesScreen extends StatelessWidget {
  final List<String> favoriteQuotes;

  const FavoritesScreen({required this.favoriteQuotes, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Quotes'),
      ),
      body: favoriteQuotes.isEmpty
          ? const Center(
              child: Text(
                'No favorite quotes yet!',
                style: TextStyle(fontSize: 18, color: Colors.cyanAccent),
              ),
            )
          : Container(
              padding: const EdgeInsets.all(12),
              child: ListView.separated(
                itemCount: favoriteQuotes.length,
                itemBuilder: (context, index) {
                  return Card(
                    elevation: 4,
                    color: Colors.white.withOpacity(0.1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.cyanAccent),
                    ),
                    child: ListTile(
                      leading: const Icon(Icons.format_quote, color: Colors.cyanAccent),
                      title: Text(
                        favoriteQuotes[index],
                        style: const TextStyle(
                          fontSize: 16,
                          fontStyle: FontStyle.italic,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(color: Colors.cyanAccent),
              ),
            ),
    );
  }
}