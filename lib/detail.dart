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
  bool _isPdfReady = false;
  PdfDocument? _pdfDoc; // PdfDocument object for text extraction
  int currentPage = 0;
  List<Map<String, dynamic>> pageTitles = []; // List to store page titles and numbers
  String _selectedTitle = ""; // Selected title from the dropdown

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

      // Populate titles and page numbers based on the first line of each page
      _extractTitlesFromPages();

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

  // Extract the first line (title) of each page
  void _extractTitlesFromPages() {
    pageTitles.clear();
    if (_pdfDoc != null) {
      // Iterate through all pages of the document
      for (int i = 0; i < _pdfDoc!.pages.count; i++) {
        // Extract text from the current page
        final String extractedText = PdfTextExtractor(_pdfDoc!).extractText(
          startPageIndex: i,
          endPageIndex: i,
        ) ?? '';

        // Split the extracted text into lines and take the first line as title
        List<String> lines = extractedText.split('\n');
        String firstLine = lines.firstWhere((line) => line.trim().isNotEmpty, orElse: () => 'No title on this page');

        // Add the first line (title) and page number to the list
        pageTitles.add({'title': firstLine, 'pageNumber': i + 1});
      }
    }
  }

  // Function to jump to the selected page in the PDF viewer
  void _jumpToPage(int pageNumber, String title) {
    setState(() {
      _selectedTitle = title;
    });
    controller?.setPage(pageNumber - 1); // PDFView uses 0-based index, so subtract 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.grey.shade300,
        title: _isPdfReady
            ? Text(_selectedTitle.isNotEmpty ? _selectedTitle : widget.title,
                style: const TextStyle(fontSize: 20, color: Colors.black))
            : const Text("Loading...", style: TextStyle(color: Colors.black)),
        actions: <Widget>[
          DropdownButton<String>(
            hint: const Text("Select Title", style: TextStyle(color: Colors.black)),
            value: null, // Ensure no pre-selected value
            icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
            items: pageTitles.map((Map<String, dynamic> page) {
              return DropdownMenuItem<String>(
                value: page['title'],
                child: Text(page['title']),
              );
            }).toList(),
            onChanged: (String? selectedTitle) {
              if (selectedTitle != null) {
                int pageNumber = pageTitles.firstWhere((page) => page['title'] == selectedTitle)['pageNumber'];
                _jumpToPage(pageNumber, selectedTitle);
              }
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
