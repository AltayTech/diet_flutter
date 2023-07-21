import 'package:behandam/base/resourceful_state.dart';
import 'package:epub_view/epub_view.dart';
import 'package:flutter/material.dart';
import 'package:internet_file/internet_file.dart';

class DoctorBookPage extends StatefulWidget {
  const DoctorBookPage({Key? key}) : super(key: key);

  @override
  State<DoctorBookPage> createState() => _DoctorBookPageState();
}

class _DoctorBookPageState extends ResourcefulState<DoctorBookPage> {
  late EpubController _epubController;

  @override
  void initState() {
    super.initState();

    loadBook();
  }

  Future<void> loadBook() async {
    _epubController = EpubController(
      // Load document
      document: EpubDocument.openData(await InternetFile.get(
          'https://user.drkermanidiet.com/user/video/badinin.epub')),
    );
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Scaffold(
        appBar: AppBar(
          // Show actual chapter name
          title: EpubViewActualChapter(
              controller: _epubController,
              builder: (chapterValue) => Text(
                'Chapter: ' + (chapterValue?.chapter?.Title?.replaceAll('\n', '').trim() ?? ''),
                textAlign: TextAlign.start,
              )
          ),
        ),
        // Show table of contents
        drawer: Drawer(
          child: EpubViewTableOfContents(
            controller: _epubController,
          ),
        ),
        // Show epub document
        body: EpubView(
          controller: _epubController,
        ),
    );
  }

  @override
  void onRetryAfterMaintenance() {
    // TODO: implement onRetryAfterMaintenance
  }

  @override
  void onRetryAfterNoInternet() {
    // TODO: implement onRetryAfterNoInternet
  }

  @override
  void onRetryLoadingPage() {
    // TODO: implement onRetryLoadingPage
  }

  @override
  void onShowMessage(String value) {
    // TODO: implement onShowMessage
  }
}
