import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf_text/pdf_text.dart';

class Detail extends StatefulWidget {
  final String title;
  final String type;
  const Detail({super.key, required this.title, required this.type});

  @override
  State<Detail> createState() => _DetailState();
}

class _DetailState extends State<Detail> {
  String? path;
  PDFViewController? controller;
  double initialZoom = 1.2; // Initial zoom level
  bool _isSearching = false;
  int currentPage = 0;
  int page = 0;

  final TextEditingController _searchController = TextEditingController();
  late PDFDoc _pdfDocument;
  bool _isPdfReady = false;
  String _filePath = '';
  // int _currentPage = 0;
  int _totalPages = 0;
  // late PDFViewController _pdfViewController;

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  loadPdf() async {
    try {
      String? _document = "";
      if (widget.type == '45') {
        _document = "assets/files/45.pdf";
      } else if (widget.type == 'tshiab') {
        _document = "assets/files/100-tshiab.pdf";
      } else {
        _document = "assets/files/100-qub.pdf";
      }
      final file = await getFileFromAsset(_document);
      if (!(await file.exists())) {
        throw Exception("PDF file not found in the local directory.");
      }
      setState(() {
        path = file.path;
      });

      _pdfDocument = await PDFDoc.fromFile(file);
      setState(() {
        _isPdfReady = true;
      });
    } catch (e) {
      // Handle any errors that occur during PDF loading
      print("Error loading PDF: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  void _searchText(String searchText) async {
    if (_pdfDocument != null) {
      final pages = _pdfDocument.pages;

      int pageIndex = -1;
      for (int i = 0; i < pages.length; i++) {
        final pageText = await pages[i].text;
        if (pageText.contains(searchText)) {
          pageIndex = i;
          break;
        }
      }

      if (pageIndex != -1) {
        print("pageIndex: $pageIndex");
        setState(() {
          // currentPage = pageIndex+1;
          currentPage = 5;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Text found on page ${pageIndex + 1}')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Text not found')),
        );
      }
    }
  }

  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getTemporaryDirectory();
      File file = File("${dir.path}/temp.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error loading pdf file");
    }
  }

  @override
  Widget build(BuildContext context) {
    if (path == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    } else {
      return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          centerTitle: true,
          title: _isSearching
              ? TextField(
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: 'Sau tus lej nplooj ntawv',
                    border: InputBorder.none,
                    hintStyle: TextStyle(color: Colors.grey.shade800),
                  ),
                  style: TextStyle(color: Colors.grey.shade800),
                  onChanged: (value) {
                    // currentPage = int.parse(value);
                    _searchText(value);
                  },
                  onEditingComplete: () {
                    // Handle the "Next" action
                    print("currentPage: ${currentPage}");
                    if (currentPage.toString().isNotEmpty) {
                      if (widget.type == "tshiab") {
                        controller!.setPage(currentPage + 3);
                      } else {
                        controller!.setPage(currentPage - 1);
                      }
                    }
                  },
                  textInputAction: TextInputAction.search,
                )
              : Text(
                  widget.title,
                  style: TextStyle(fontSize: 20),
                ),
          actions: <Widget>[
            _isSearching
                ? IconButton(
                    icon: Icon(Icons.cancel),
                    onPressed: () {
                      setState(() {
                        _isSearching = false;
                      });
                    },
                  )
                : IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      setState(() {
                        _isSearching = true;
                      });
                    },
                  ),
          ],
        ),
        body: _isPdfReady
            ?
            PDFView(
                filePath: path,
                enableSwipe: true, // Enable swipe navigation
                swipeHorizontal: false, // Vertical scrolling
                autoSpacing: true, // Add spacing between pages
                pageFling: true, // Page fling effect
                pageSnap: true, // Snap pages to screen boundaries
                defaultPage: currentPage, // Starting page
                fitPolicy: FitPolicy.BOTH,
                onRender: (_pages) {

                },
                onViewCreated: (PDFViewController pdfViewController) {
                  controller = pdfViewController;
                },
              )
                  
            : Center(child: CircularProgressIndicator()),
      );
    }
  }
}
