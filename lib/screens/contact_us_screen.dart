// lib/screens/contact_us_screen.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:my_flutter_app/models/contact_data.dart';
import 'package:my_flutter_app/services/api_service.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  _ContactUsScreenState createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  late Future<ContactData> futureContactData;

  @override
  void initState() {
    super.initState();
    futureContactData = _loadContactData();
  }

  Future<ContactData> _loadContactData() async {
    try {
      return await ApiService().getContactData();
    } catch (e) {
      // Return default data if API fails
      return ContactData(
        id: '',
        address:
            'Transportation Systems Engineering Group\nDepartment of Civil Engineering, IIT Bombay',
        email: 'tpmdc@civil.iitb.ac.in',
        website: 'https://tpmdc.iitb.ac.in',
        developmentInfo: 'Developed by TUTEM Project Team at IIT Bombay',
        phone: '022-2576-7301',
        socialMedia: 'instagram.com/tutem.iitb',
        contactHeader:
            'Transportation Planning & Implementation\nContact Information',
        aboutAppHeader: 'About This App',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Contact Us'), centerTitle: true),
      body: FutureBuilder<ContactData>(
        future: futureContactData,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final contact = snapshot.data!;
          final widgets = <Widget>[];

          // Header Section
          widgets.add(
            Padding(
              padding: const EdgeInsets.only(top: 24, bottom: 32),
              child: Text(
                contact.contactHeader,
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          );

          // Contact Information Cards
          final contactItems = [
            if (contact.phone.isNotEmpty)
              _ContactInfo(
                icon: Icons.phone,
                title: 'Phone',
                value: contact.phone.startsWith('+')
                    ? contact.phone
                    : '+91 ${contact.phone}',
              ),
            if (contact.email.isNotEmpty)
              _ContactInfo(
                icon: Icons.email,
                title: 'Email',
                value: contact.email,
              ),
            if (contact.address.isNotEmpty)
              _ContactInfo(
                icon: Icons.location_on,
                title: 'Address',
                value: contact.address,
                isMultiline: true,
              ),
            if (contact.website.isNotEmpty)
              _ContactInfo(
                icon: Icons.public,
                title: 'Website',
                value: contact.website.trim().replaceAll(' ', ''),
              ),
            if (contact.socialMedia.isNotEmpty)
              _ContactInfo(
                iconWidget: Icon(
                  FontAwesomeIcons.instagram,
                  color: Color(0xFFE1306C),
                ),
                title: 'Instagram',
                value: contact.socialMedia
                    .replaceAll('www.', '')
                    .replaceAll('https://', '')
                    .replaceAll('/', ''),
              ),
          ];

          // Add contact cards with proper spacing
          for (var i = 0; i < contactItems.length; i++) {
            widgets.add(_ContactCard(item: contactItems[i]));
            if (i < contactItems.length - 1) {
              widgets.add(SizedBox(height: 16));
            }
          }

          // About Section
          // About Section
          widgets.addAll([
            SizedBox(height: 32),
            Center(
              child: Text(
                contact.aboutAppHeader,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                contact.developmentInfo,
                style: TextStyle(fontSize: 14),
                textAlign: TextAlign.center,
              ),
            ),
          ]);

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: widgets,
            ),
          );
        },
      ),
    );
  }
}

class _ContactInfo {
  final IconData? icon;
  final Widget? iconWidget;
  final String title;
  final String value;
  final bool isMultiline;

  _ContactInfo({
    this.icon,
    this.iconWidget,
    required this.title,
    required this.value,
    this.isMultiline = false,
  }) : assert(icon != null || iconWidget != null);
}

class _ContactCard extends StatelessWidget {
  final _ContactInfo item;

  const _ContactCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                shape: BoxShape.circle,
              ),
              child:
                  item.iconWidget ??
                  Icon(item.icon, color: Colors.blue[800], size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[600],
                    ),
                  ),
                  SizedBox(height: 4),
                  item.isMultiline
                      ? Text(item.value, style: TextStyle(fontSize: 16))
                      : Text(
                          item.value,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
