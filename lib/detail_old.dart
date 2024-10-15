// import 'package:flutter/material.dart';
// import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

// class Detail extends StatefulWidget {
//   final String title;
//   final String type;
//   const Detail({super.key, required this.title, required this.type});

//   @override
//   State<Detail> createState() => _DetailState();
// }

// class _DetailState extends State<Detail> {
//   late PdfViewerController _pdfViewerController;
//   late TextEditingController _textEditingController;
//   bool _isSearching = false;
//   bool _isLoading = true;  // Loading indicator flag

//   @override
//   void initState() {
//     super.initState();
//     _pdfViewerController = PdfViewerController();
//     _textEditingController = TextEditingController();
//   }

//   @override
//   void dispose() {
//     _textEditingController.dispose();
//     super.dispose();
//   }

//   String getDocumentPath() {
//     if (widget.type == '45') {
//       return "assets/files/45.pdf";
//     } else if (widget.type == 'tshiab') {
//       return "assets/files/100-tshiab.pdf";
//     } else {
//       return "assets/files/100-qub.pdf";
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBodyBehindAppBar: true,
//       appBar: AppBar(
//         title: _isSearching
//             ? TextField(
//                 controller: _textEditingController,
//                 decoration: InputDecoration(
//                   hintText: 'Enter search text',
//                   border: InputBorder.none,
//                   hintStyle: TextStyle(color: Colors.white),
//                 ),
//                 style: TextStyle(color: Colors.white),
//                 onSubmitted: (value) {
//                   _pdfViewerController.searchText(_textEditingController.text);
//                 },
//               )
//             : Text(widget.title),
//         actions: <Widget>[
//           _isSearching
//               ? IconButton(
//                   icon: Icon(Icons.cancel),
//                   onPressed: () {
//                     setState(() {
//                       _isSearching = false;
//                     });
//                   },
//                 )
//               : IconButton(
//                   icon: Icon(Icons.search),
//                   onPressed: () {
//                     setState(() {
//                       _isSearching = true;
//                     });
//                   },
//                 ),
//         ],
//       ),
//       body: Stack(
//         children: [
//           SfPdfViewer.asset(
//             getDocumentPath(),
//             controller: _pdfViewerController,
//             onDocumentLoaded: (details) {
//               setState(() {
//                 _isLoading = false; // Set loading to false when document is loaded
//               });
//             },
//             onDocumentLoadFailed: (details) {
//               // Handle document load failure
//             },
//           ),
//           _isLoading
//               ? Center(child: CircularProgressIndicator())
//               : SizedBox.shrink(), // Show loading indicator until PDF is loaded
//         ],
//       ),
//     );
//   }
// }