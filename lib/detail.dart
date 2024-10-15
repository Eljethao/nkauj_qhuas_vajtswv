import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart'; // For text extraction and search

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
  bool _isSearching = false;
  int currentPage = 0;
  bool _isPdfReady = false;
  PdfDocument? _pdfDoc; // PdfDocument object for text extraction

  List<int> _matchingPages = []; // Stores matching page numbers after search

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  // Load the PDF from assets and initialize the PdfDocument for text extraction
  loadPdf() async {
    try {
      String _documentPath = '';
      if (widget.type == '50') {
        _documentPath = 'assets/files/50.pdf';
      } else if (widget.type == 'tshiab') {
        _documentPath = 'assets/files/100-tshiab.pdf';
      } else {
        _documentPath = 'assets/files/100-qub.pdf';
      }

      // Load the PDF file from assets
      final file = await getFileFromAsset(_documentPath);
      if (!(await file.exists())) {
        throw Exception('PDF file not found.');
      }

      // Initialize PdfDocument for text extraction using Syncfusion
      _pdfDoc = PdfDocument(inputBytes: await file.readAsBytes());

      setState(() {
        path = file.path;
        _isPdfReady = true;
      });
    } catch (e) {
      // Handle any errors during PDF loading
      print('Error loading PDF: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading PDF: $e')),
      );
    }
  }

  // Utility function to load PDF file from assets
  Future<File> getFileFromAsset(String asset) async {
    try {
      var data = await rootBundle.load(asset);
      var bytes = data.buffer.asUint8List();
      var dir = await getTemporaryDirectory();
      File file = File("${dir.path}/temp.pdf");

      File assetFile = await file.writeAsBytes(bytes);
      return assetFile;
    } catch (e) {
      throw Exception("Error loading PDF file");
    }
  }

  // Function to search for a title or text using Syncfusion's PdfTextExtractor
  void _searchText(String searchText) {
    _matchingPages.clear(); // Clear previous search results
    if (_pdfDoc != null) {
      // Iterate through all pages of the document
      for (int i = 0; i < _pdfDoc!.pages.count; i++) {
        // Extract text from the current page using startPageIndex
        final String extractedText = PdfTextExtractor(_pdfDoc!).extractText(
          startPageIndex: i, // Extract text from the current page
          endPageIndex: i,   // Limit to the same page
        ) ?? '';
        
        // Search for the specific title in the extracted text
        if (extractedText.contains(searchText)) {
          _matchingPages.add(i + 1); // Store page number (i+1 as it's 1-based)
        }
      }

      if (_matchingPages.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Pom nyob rau page(s): ${_matchingPages.join(", ")}')),
        );
        // Navigate to the first matching page where the title is found
        controller?.setPage(_matchingPages.first - 1);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nrhiav Tsis pom qhov koj sau !!!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        title: _isSearching
            ? TextField(
                decoration: InputDecoration(
                  hintText: 'Nrhiav...',
                  border: InputBorder.none,
                  hintStyle: TextStyle(color: Colors.grey.shade800),
                ),
                style: TextStyle(color: Colors.grey.shade800),
                onSubmitted: (value) {
                  _searchText(value); // Perform search when text is submitted
                },
                textInputAction: TextInputAction.search,
              )
            : Text(widget.title, style: TextStyle(fontSize: 20, color: Colors.black)),
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
          ? PDFView(
              filePath: path,
              enableSwipe: true, // Enable swipe navigation
              swipeHorizontal: false, // Vertical scrolling
              autoSpacing: true, // Add spacing between pages
              pageFling: true, // Page fling effect
              pageSnap: true, // Snap pages to screen boundaries
              defaultPage: currentPage, // Starting page
              fitPolicy: FitPolicy.BOTH,
              onViewCreated: (PDFViewController pdfViewController) {
                controller = pdfViewController;
              },
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
