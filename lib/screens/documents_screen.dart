// screens/documents_screen.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';

class DocumentsScreen extends StatefulWidget {
  const DocumentsScreen({super.key});

  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  // Online documents (from server)
  final List<Map<String, String>> onlineDocuments = [
    {
      'name': 'Resume Tips',
      'url': 'https://tutem.in/files/resume_tips.pdf',
      'type': 'pdf',
    },
    {
      'name': 'Interview Guide',
      'url': 'https://tutem.in/files/interview_guide.pdf',
      'type': 'pdf',
    },
    {
      'name': 'Career Roadmap',
      'url': 'https://tutem.in/files/career_roadmap.pdf',
      'type': 'pdf',
    },
  ];

  // Local documents (from device)
  List<File> localFiles = [];

  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _loadLocalFiles();
  }

  // Load files from app's document directory
  Future<void> _loadLocalFiles() async {
    final directory = await getApplicationDocumentsDirectory();
    final files = directory.listSync();

    setState(() {
      localFiles = files
          .where((file) => file.path.endsWith('.pdf'))
          .map((file) => File(file.path))
          .toList();
    });
  }

  // Download a file from URL
  Future<void> _downloadFile(String url, String fileName) async {
    final appDir = await getApplicationDocumentsDirectory();
    final file = File('${appDir.path}/$fileName');

    try {
      setState(() {
        _isDownloading = true;
      });

      final response = await http.get(Uri.parse(url.trim()));
      await file.writeAsBytes(response.bodyBytes);

      setState(() {
        localFiles.add(file);
        _isDownloading = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('$fileName downloaded')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Download failed: $e')));
      setState(() {
        _isDownloading = false;
      });
    }
  }

  // Pick a file from device storage
  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      final appDir = await getApplicationDocumentsDirectory();
      final newFile = await file.copy(
        '${appDir.path}/${file.uri.pathSegments.last}',
      );

      setState(() {
        localFiles.add(newFile);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('File added: ${newFile.path.split('/').last}')),
      );
    }
  }

  // Delete a local file
  Future<void> _deleteFile(File file) async {
    await file.delete();
    setState(() {
      localFiles.remove(file);
    });
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('File deleted')));
  }

  // Open file (local or online)
  Future<void> _openFile(File file) async {
    final result = await OpenFile.open(file.path);
    if (result.type == ResultType.noAppToOpen) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("No app to open this file")));
    }
  }

  // Share file
  Future<void> _shareFile(File file) async {
    await Share.shareXFiles([XFile(file.path)]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Documents"),
        backgroundColor: Colors.teal,
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: _pickFile,
            tooltip: 'Add from device',
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.teal,
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => _buildDownloadOptions(),
          );
        },
        tooltip: 'Download from server',
        child: Icon(Icons.download),
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            TabBar(
              labelColor: Colors.teal,
              unselectedLabelColor: Colors.grey,
              tabs: [
                Tab(text: 'Online'),
                Tab(text: 'Offline'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // === ONLINE TAB ===
                  ListView.builder(
                    itemCount: onlineDocuments.length,
                    itemBuilder: (context, index) {
                      final doc = onlineDocuments[index];
                      final fileName = doc['url']!.split('/').last;
                      return ListTile(
                        leading: Icon(Icons.public, color: Colors.blue),
                        title: Text(doc['name']!),
                        subtitle: Text("Download & view offline"),
                        trailing: IconButton(
                          icon: Icon(Icons.download, color: Colors.grey),
                          onPressed: () => _downloadFile(doc['url']!, fileName),
                        ),
                        onTap: () => _downloadFile(doc['url']!, fileName),
                      );
                    },
                  ),

                  // === OFFLINE TAB ===
                  localFiles.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.folder_open,
                                size: 60,
                                color: Colors.grey,
                              ),
                              SizedBox(height: 10),
                              Text(
                                'No offline documents yet',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          itemCount: localFiles.length,
                          itemBuilder: (context, index) {
                            final file = localFiles[index];
                            final fileName = file.path.split('/').last;
                            return ListTile(
                              leading: Icon(
                                Icons.description,
                                color: Colors.teal,
                              ),
                              title: Text(
                                fileName,
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                              subtitle: Text("Offline • Tap to open"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.share,
                                      size: 18,
                                      color: Colors.grey,
                                    ),
                                    onPressed: () => _shareFile(file),
                                  ),
                                  IconButton(
                                    icon: Icon(
                                      Icons.delete,
                                      size: 18,
                                      color: Colors.red,
                                    ),
                                    onPressed: () => _deleteFile(file),
                                  ),
                                ],
                              ),
                              onTap: () => _openFile(file),
                            );
                          },
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadOptions() {
    return Container(
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Download Documents",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 16),
          ...onlineDocuments.map((doc) {
            final fileName = doc['url']!.split('/').last;
            return ListTile(
              title: Text(doc['name']!),
              subtitle: Text(doc['url']?.trim() ?? 'URL not available'),
              trailing: Icon(Icons.download),
              onTap: () {
                Navigator.pop(context);
                _downloadFile(doc['url']!, fileName);
              },
            );
          }),
          ListTile(
            leading: Icon(Icons.close),
            title: Text("Cancel"),
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
