import 'package:flutter/material.dart';
import 'package:tiffinbox/utils/constants/color.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text('About Us'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSectionWithImage(
              title: 'University of Windsor',
              content:
              'The University of Windsor is a comprehensive, student-centered institution located in Windsor, Ontario, Canada. Renowned for its diverse and supportive learning environment, the university offers a wide array of undergraduate and graduate programs. We are dedicated to fostering a vibrant community of scholars and professionals. Through our diverse programs and research initiatives, we aim to equip students with the skills and knowledge needed to navigate and succeed in an ever-evolving global landscape.',
              assetPath: 'assets/images/university.png',
            ),
            _buildSectionWithImage(
              title: 'Master of Applied Computing',
              content:
              'The Master of Applied Computing (MAC) program at the University of Windsor is designed to equip students with advanced knowledge and skills in computing and information technology. Our rigorous curriculum combines theoretical foundations with practical experience, ensuring that graduates are well-prepared for the demands of the tech industry. The MAC program emphasizes hands-on learning, innovation, and collaboration, providing students with the tools they need to succeed in their professional careers.',
              assetPath: 'assets/images/mac2.jpg',
            ),
            _buildSectionTitle('Our Team'),
            _buildTeamMemberWithImage(
              name: 'Riddhi Jobanputra',
              description:
              'Riddhi is a talented developer with a strong background in front-end development and user interface design. Her creative vision and technical skills have significantly contributed to the attractive and intuitive design of the TiffinBox app. Riddhi\'s commitment to creating an engaging user experience is evident in every aspect of the application.',
              assetPath: 'assets/images/riddhi.jpeg',
            ),
            _buildTeamMemberWithImage(
              name: 'Dhvani Sheth',
              description:
              'Dhvani brings a wealth of knowledge in software development and project management to the team. Her expertise in backend development and database management has been instrumental in the smooth functioning of the TiffinBox application. Dhvani\'s meticulous attention to detail ensures that the app runs efficiently and effectively.',
              assetPath: 'assets/images/dhvani.jpeg',
            ),
            _buildTeamMemberWithImage(
              name: 'Parth Dangaria',
              description:
              'Parth is an experienced developer with a solid foundation in both front-end and back-end technologies. His proficiency in Flutter and Firebase has been crucial in developing the core functionalities of the TiffinBox app. Parth\'s problem-solving abilities and dedication to excellence have greatly enhanced the overall quality of the application.',
              assetPath: 'assets/images/parth.jpg',
            ),
            _buildSectionTitle('Our Mentors'),
            _buildTeamMemberWithImage(
              name: 'Dr. Usama Mir',
              description:
              'Dr. Usama Mir is a distinguished professor at the University of Windsor, specializing in computer science and software engineering. With extensive experience in academia and industry, Dr. Mir has guided numerous students in their research and project development. His mentorship and expertise have been invaluable in the successful completion of the TiffinBox project. We are immensely grateful for his support and encouragement.',
              assetPath: 'assets/images/usama.jpeg',
            ),
            _buildTeamMemberWithImage(
              name: 'Dr. Shafaq Khan',
              description:
              'Dr. Shafaq Khan is an esteemed professor at the University of Windsor, overseeing the internship project course. Dr. Khan has received the ‘Excellence in Teaching’ award and an ‘Award from Alumni’. She has been teaching undergraduate and graduate level courses and is well experienced in the international accreditation processes. Her leadership and vision have been instrumental in guiding students through their internship projects, ensuring they gain valuable real-world experience and insights.',
              assetPath: 'assets/images/shafaq.png',
            ),
            _buildSectionTitle('Our Vision'),
            _buildSectionContent(
              'In today\'s fast-paced world, students and working professionals often find it challenging to allocate time for preparing nutritious meals at home. This constant struggle has led to a growing demand for convenient yet healthy food options. The TiffinBox Mobile App aims to address this need by developing a comprehensive platform that connects users with local home chefs. Through an intuitive and seamless user interface, the application will enable users to browse a diverse range of homemade meals, customize orders based on dietary preferences, and schedule deliveries according to their convenience.',
            ),
            _buildSectionContent(
              'This project not only simplifies access to healthy food but also provides a unique opportunity for local chefs to showcase and monetize their culinary skills. By fostering a community-oriented approach to dining, TiffinBox ensures that users have access to wholesome, homemade meals while supporting local chefs.',
            ),
            // _buildSectionTitle('Technology Stack'),
            // _buildSectionContent(
            //   'The TiffinBox Mobile Application is developed using a robust technology stack, including:',
            // ),
            // _buildBulletPoint('• Python: For backend development and server-side logic.'),
            // _buildBulletPoint('• Django: As the web framework to build a scalable and maintainable backend.'),
            // _buildBulletPoint('• Flutter: For creating a beautiful and responsive mobile user interface.'),
            // _buildBulletPoint('• Firebase: For authentication, real-time database, and other cloud services.'),
            // _buildSectionTitle('Key Features'),
            // _buildBulletPoint('• User Registration and Authentication: Secure and seamless sign-up and login process.'),
            // _buildBulletPoint('• Meal Browsing and Ordering: Browse a diverse range of homemade meals and place orders with ease.'),
            // _buildBulletPoint('• Delivery Scheduling: Schedule deliveries according to your convenience.'),
            // _buildBulletPoint('• Payment Gateway Integration: Safe and secure payment options.'),
            // _buildBulletPoint('• Chef Registration and Profile Management: Local chefs can register, manage their profiles, and showcase their culinary skills.'),
            // _buildBulletPoint('• Order Management: Efficient management of orders from preparation to delivery.'),
            // _buildBulletPoint('• Rating and Review System: Users can rate and review meals, helping others make informed choices.'),
            // const SizedBox(height: 24),
            _buildSectionTitle('Our Appreciation'),
            const Text(
              'We are excited to present TiffinBox and are committed to continuously improving and expanding our application to better serve our users and support our local chefs.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Thank you for joining us on this journey towards convenient and healthy eating!',
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: primarycolor,
          ),
        ),
        const Divider(color: primarycolor),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildSectionContent(String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          content,
          style: const TextStyle(fontSize: 16, height: 1.5),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBulletPoint(String point) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        point,
        style: const TextStyle(fontSize: 16),
      ),
    );
  }

  Widget _buildSectionWithImage({
    required String title,
    required String content,
    required String assetPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title),
        ClipRRect(
          borderRadius: BorderRadius.circular(8.0),
          child: Image.asset(assetPath),
        ),
        const SizedBox(height: 8),
        _buildSectionContent(content),
      ],
    );
  }

  Widget _buildTeamMemberWithImage({
    required String name,
    required String description,
    required String assetPath,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipOval(
              child: Image.asset(
                assetPath,
                width: 64,
                height: 64,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(fontSize: 16, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
 