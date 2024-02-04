import 'package:flutter/material.dart';
import 'package:mensa_match/components/toolbar.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/wave_background.dart';
import 'package:mensa_match/components/page_header.dart';
import 'package:mensa_match/components/chat_overview_element.dart';

class ChatOverview extends StatefulWidget {
  const ChatOverview({Key? key}) : super(key: key);

  @override
  _ChatOverviewState createState() => _ChatOverviewState();
}

class _ChatOverviewState extends State<ChatOverview> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredChatData = [];

  @override
  void initState() {
    super.initState();
    // Initialize filtered data with all chat data initially
    _filteredChatData = List.from(chatData);
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    // Filter chat data based on the search query
    setState(() {
      _filteredChatData = chatData
          .where((chat) => chat['name']!
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: CustomPaint(
              painter: WaveBackgroundPainterShort(baseHeight: 160),
              child: Padding(
                padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                child: Container(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PageHeader(
                        title: 'Chats',
                        backButton: false,
                        headerHeight: 150,
                      ),
                      const SizedBox(height: 24),
                      _buildSearchBar(),
                      const SizedBox(height: 16),
                      _buildChatList(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      }),
      bottomNavigationBar: const MyIconToolbar(),
    );
  }

Widget _buildSearchBar() {
  return Container(
    height: 40, // Set the height of the search bar
    padding: const EdgeInsets.symmetric(horizontal: 8),
    decoration: BoxDecoration(
      color: AppColors.cardColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: TextField(
      controller: _searchController,
      decoration: const InputDecoration(
        hintText: 'Search',
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(vertical: 9), // Adjust vertical padding
          child: Icon(
            Icons.search,
            color: AppColors.textColorGray, // Change the color of the search icon
          ),
        ),
        border: InputBorder.none,
        contentPadding: EdgeInsets.symmetric(vertical: 8), // Set to 0
      ),
    ),
  );
}




  Widget _buildChatList() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: _filteredChatData.length,
      itemBuilder: (context, index) {
        return chatOverviewElement(
          image: _filteredChatData[index]['image']!,
          name: _filteredChatData[index]['name']!,
          message_preview: _filteredChatData[index]['message_preview']!,
        );
      },
    );
  }
}

// Your example data
List<Map<String, String>> chatData = [
  {
    'image':
        'https://media.istockphoto.com/id/525211480/photo/pop-girl-portrait-wearing-weird-sunglasses-and-blue-wig.jpg?s=612x612&w=0&k=20&c=Wf1Unydyx_pH7wvMJraP7WdqH7tuGNJG0PxYQM5_Ox0=',
    'name': 'Amanda',
    'message_preview': 'Hey! How are you doing?',
  },
  {
    'image': 'https://placekitten.com/100/100?image=2',
    'name': 'Bob',
    'message_preview':
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  },
  {
    'image': 'https://placekitten.com/100/100?image=3',
    'name': 'Charlie',
    'message_preview':
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  },
  {
    'image':
        'https://media.istockphoto.com/id/525211480/photo/pop-girl-portrait-wearing-weird-sunglasses-and-blue-wig.jpg?s=612x612&w=0&k=20&c=Wf1Unydyx_pH7wvMJraP7WdqH7tuGNJG0PxYQM5_Ox0=',
    'name': 'Amanda',
    'message_preview': 'Hey! How are you doing?',
  },
  {
    'image': 'https://placekitten.com/100/100?image=2',
    'name': 'Bob',
    'message_preview':
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit.',
  },
  {
    'image': 'https://placekitten.com/100/100?image=3',
    'name': 'Charlie',
    'message_preview':
        'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  },
];
