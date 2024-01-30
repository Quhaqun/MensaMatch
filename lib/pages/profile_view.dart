import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mensa_match/constants/colors.dart';
import 'package:mensa_match/components/bubble.dart';
import 'package:mensa_match/pages/edit_profile.dart';

class Profile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int age;
  final String major;
  final String semester;
  final String bio;
  final bool showEditButton;

  const Profile({
    // TODO: insert 'required' and remove placeholder values as soon as data is oaded from database
    Key? key,
    this.imageUrl =
        'https://images.pexels.com/photos/774909/pexels-photo-774909.jpeg?cs=srgb&dl=pexels-andrea-piacquadio-774909.jpg&fm=jpg', // Placeholder image URL
    this.name = 'John Doe', // Placeholder name
    this.age = 25,
    this.major = 'M. Sc. Computer Science',
    this.semester = '3rd Semester',
    this.bio =
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.', // Placeholder bio
    this.showEditButton = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<String> availableOptions = [
      'Tennis',
      'Gym',
      'Programming',
      'Dogs',
      'Photography',
      'Nature',
      'Travelling',
      'Cooking',
      'Environmentalism'
    ];

    List<String> selectedOptions = [
      'Tennis',
      'Programming',
      'Travelling',
    ];

    return Scaffold(
      backgroundColor: AppColors.backgroundColorLight,
      body: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Top Image with Back and Edit Buttons
                  Container(
                    height:
                        MediaQuery.of(context).size.width, // Aspect ratio 1:1
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage(imageUrl), // Set image URL
                        fit: BoxFit.cover,
                      ),
                    ),
                    child: Stack(
                      children: [
                        // Back Button
                        Positioned(
                          top: 16.0,
                          left: 16.0,
                          child: Container(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.accentColor1,
                            ),
                            child: IconButton(
                              padding: EdgeInsets.all(12.0),
                              icon: Icon(
                                Icons.chevron_left,
                                color: AppColors.white,
                                size: 32,
                              ),
                              onPressed: () {
                                Navigator.pop(context); // Navigate back
                              },
                            ),
                          ),
                        ),
                        // Edit Button (conditionally displayed)
                        if (showEditButton)
                          Positioned(
                            top: 16.0,
                            right: 16.0,
                            child: Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.accentColor1,
                              ),
                              child: IconButton(
                                padding: EdgeInsets.all(16.0),
                                icon: Icon(
                                  Icons.edit,
                                  color: AppColors.white,
                                  size: 24,
                                ),
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilePage()));
                                },
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  // Name and Subheadlines
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$name, $age',
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorDark,
                            fontWeight: FontWeight.w700,
                            fontSize: 32,
                          ),
                        ),
                        Text(
                          major,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          semester,
                          style: GoogleFonts.roboto(
                            color: AppColors.textColorGray,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Bio Text
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: Text(
                      bio,
                      style: GoogleFonts.roboto(
                        color: AppColors.textColorGray,
                        fontWeight: FontWeight.w400,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Interests',
                              style: GoogleFonts.roboto(
                                color: AppColors.textColorGray,
                                fontWeight: FontWeight.w400,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            ReadOnlyBubbleList(
                                availableOptions: availableOptions,
                                selectedOptions: selectedOptions)
                          ])),
                ],
              ),
            ),
          ),
        );
      }),
    );
  }
}
