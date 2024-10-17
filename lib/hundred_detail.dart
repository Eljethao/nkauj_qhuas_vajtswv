import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:nkauj_qhuas_vajtswv/helper/help.dart';
import 'package:path_provider/path_provider.dart';
import 'package:syncfusion_flutter_pdf/pdf.dart';
import 'package:dropdown_search/dropdown_search.dart';

class HundredDetail extends StatefulWidget {
  final String title;
  final String type;
  const HundredDetail({super.key, required this.title, required this.type});

  @override
  State<HundredDetail> createState() => _HundredDetailState();
}

class _HundredDetailState extends State<HundredDetail> {
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
      String _documentPath = 'assets/files/100-tshiab.pdf';

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

  // Custom drop down display for the selected item
  Widget _customDropDown(BuildContext context, Map<String, dynamic>? item) {
    if (item == null) {
      return Text(
        "Select a title",
        style: TextStyle(color: Colors.black54, fontSize: 16),
      );
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.teal.shade50,
        boxShadow: [
          BoxShadow(
            color: Colors.teal.shade100,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(Icons.book, color: Colors.teal),
          SizedBox(width: 10),
          Text(
            item['title'],
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16, color: Colors.teal),
          ),
          Spacer(),
          Text(
            'Page ${item['pageNumber']}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
  }

  // Custom popup item display
  Widget _customPopupItemBuilder(
      BuildContext context, Map<String, dynamic> item, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
        color: isSelected ? Colors.teal.shade50 : Colors.white,
      ),
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
      child: Row(
        children: [
          Icon(
            isSelected ? Icons.check_circle : Icons.book_outlined,
            color: isSelected ? Colors.teal : Colors.grey,
          ),
          SizedBox(width: 10),
          Expanded(
            child: Text(
              item['title'],
              style: TextStyle(
                fontSize: 16,
                color: isSelected ? Colors.teal.shade900 : Colors.black87,
              ),
            ),
          ),
          Text(
            'Page ${item['pageNumber']}',
            style: TextStyle(color: Colors.grey.shade600),
          ),
        ],
      ),
    );
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
        backgroundColor: Colors.blue.shade400,
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
                                          BorderSide(color: Colors.teal),
                                    ),
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 15.0, horizontal: 20.0),
                                    prefixIcon:
                                        Icon(Icons.search, color: Colors.blue),
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
                              clearButtonProps: ClearButtonProps(
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
                              items: newHundredTitles
                                  .map((title) => title['title'] as String)
                                  .toList(),
                              onChanged: (String? data) {
                                // Find the map in newHundredTitles that corresponds to the selected title
                                final selectedTitle = newHundredTitles.firstWhere(
                                    (title) => title['title'] == data);

                                // Now you can access the "pageNumber" value from the map
                                print(
                                    "Selected: ${selectedTitle['pageNumber']}");
                                int _pageNumber =
                                    selectedTitle['pageNumber'] as int;
                                _jumpToPage(pageNumber: _pageNumber);
                              },
                              asyncItems: (String filter) async {
                                // Filter the list based on search input
                                return newHundredTitles
                                    .where((titleMap) => titleMap['title']
                                        .toLowerCase()
                                        .contains(filter.toLowerCase()))
                                    .map((titleMap) =>
                                        titleMap['title'] as String)
                                    .toList();
                              },
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
