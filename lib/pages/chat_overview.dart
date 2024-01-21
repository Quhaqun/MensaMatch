import 'package:flutter/material.dart';
import 'package:mensa_match/components/toolbar.dart';

class ChatOverview extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Übersicht',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  TextEditingController _searchController = TextEditingController();
  List<String> chatList = List.generate(10, (index) => 'Chat $index');
  List<String> filteredList = [];

  @override
  void initState() {
    super.initState();
    filteredList.addAll(chatList);
  }

  void filterChats(String query) {
    setState(() {
      filteredList = chatList
          .where((chat) => chat.toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  void _filterChats(String query) {
    query = query.toLowerCase();
    setState(() {
      filteredList = chatList
          .where((chat) => chat.toLowerCase().contains(query))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chats'),
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8.0),
            color: Colors.grey[200],
            child: TextField(
              controller: _searchController,
              onChanged: _filterChats,
              decoration: InputDecoration(
                labelText: 'Suche nach Chats',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          ),
          Expanded(
            child: ChatList(filteredList),
          ),
        ],
      ),
      bottomNavigationBar: MyIconToolbar(),
    );
  }
}

class ChatList extends StatelessWidget {
  final List<String> chatList;

  ChatList(this.chatList);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: chatList.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(chatList[index]),
          subtitle: Text('Letzte Nachricht im ${chatList[index]}'),
          onTap: () {
            // Hier könntest du die Logik implementieren, um in den ausgewählten Chat zu wechseln.
            // Zum Beispiel: Navigator.push(context, MaterialPageRoute(builder: (context) => ChatDetailScreen(chatIndex: index)));
          },
        );
      },
    );
  }
}