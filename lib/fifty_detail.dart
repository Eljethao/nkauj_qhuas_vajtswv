import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nkauj_qhuas_vajtswv/helper/help.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dropdown_search/dropdown_search.dart';

class FiftyDetail extends StatefulWidget {
  final String title;
  final String type;
  const FiftyDetail({super.key, required this.title, required this.type});

  @override
  State<FiftyDetail> createState() => _FiftyDetailState();
}

class _FiftyDetailState extends State<FiftyDetail> {
  String? path;
  PDFViewController? controller;
  bool _isPdfReady = false;
  PdfDocument? _pdfDoc; // PdfDocument object for text extraction
  int currentPage = 0;
  List<Map<String, dynamic>> pageTitles =
      []; // List to store page titles and numbers
  String _selectedTitle = ""; // Selected title from the dropdown
  // final dropDownKey = GlobalKey<DropdownSearchState>();

  @override
  void initState() {
    super.initState();
    loadPdf();
  }

  // Load the PDF from assets and initialize the PdfDocument for text extraction
  loadPdf() async {
    try {
      String _documentPath = 'assets/files/50.pdf';

      // Load the PDF file from assets
      final file = await getFileFromAsset(_documentPath);

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


  // Function to jump to the selected page in the PDF viewer
  void _jumpToPage({required int pageNumber}) {
    // setState(() {
    //   _selectedTitle = title;
    // });
    controller
        ?.setPage(pageNumber - 1); // PDFView uses 0-based index, so subtract 1
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
        backgroundColor: const Color(0xff52568F),
      ),
      body: _isPdfReady
          ? SafeArea(
              child: Column(
                children: [
                  Container(
                    color: Colors.white,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 7,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: DropdownSearch<String>(
                              popupProps: PopupProps.dialog(
                                showSearchBox: true,
                                searchFieldProps: TextFieldProps(
                                  decoration: InputDecoration(
                                    labelText: "Search title",
                                    filled: true,
                                    fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                      borderSide:
                                          const BorderSide(color: Colors.teal),
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20.0),
                                    prefixIcon:
                                        const Icon(Icons.search, color: Colors.blue),
                                  ),
                                ),
                                dialogProps: DialogProps(
                                  backgroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  elevation: 8,
                                ),
                              ),
                              clearButtonProps: const ClearButtonProps(
                                isVisible: true,
                              ),
                              dropdownDecoratorProps: DropDownDecoratorProps(
                                dropdownSearchDecoration: InputDecoration(
                                    labelText: "Search",
                                    filled: true,
                                    // fillColor: Colors.white,
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16.0),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 30.0),
                                    prefixIcon: const Icon(Icons.search),
                                    suffixIcon: null,
                                    fillColor: Colors.grey.shade200),
                              ),
                              items: fiftyTitles
                                  .map((title) => title['title'] as String)
                                  .toList(),
                              onChanged: (String? data) {
                                // Find the map in fiftyTitles that corresponds to the selected title
                                final selectedTitle = fiftyTitles.firstWhere(
                                    (title) => title['title'] == data);

                                // Now you can access the "pageNumber" value from the map
                                print(
                                    "Selected: ${selectedTitle['pageNumber']}");
                                int _pageNumber =
                                    selectedTitle['pageNumber'] as int;
                                _jumpToPage(pageNumber: _pageNumber);
                              },
                              // asyncItems: (String filter) async {
                              //   // Filter the list based on search input
                              //   return fiftyTitles
                              //       .where((titleMap) => titleMap['title']
                              //           .toLowerCase()
                              //           .contains(filter.toLowerCase()))
                              //       .map((titleMap) =>
                              //           titleMap['title'] as String)
                              //       .toList();
                              // },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: PDFView(
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
                    ),
                  ),
                ],
              ),
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }
}
