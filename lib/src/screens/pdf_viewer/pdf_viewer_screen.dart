import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';

class PdfViewerScreen extends StatefulWidget {
  final String url;
  final String title;

  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final GlobalKey<SfPdfViewerState> _pdfViewerKey =
      GlobalKey<SfPdfViewerState>();
  final PdfViewerController _pdfViewerController = PdfViewerController();

  bool _isLoading = true;
  bool _hasError = false;
  bool _showIndicator = false;
  int _currentPage = 1;
  int _totalPages = 0;
  Timer? _hideTimer;

  void _triggerIndicator() {
    _hideTimer?.cancel();

    setState(() => _showIndicator = true);

    _hideTimer = Timer(const Duration(seconds: 2), () {
      if (mounted) {
        setState(() => _showIndicator = false);
      }
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _pdfViewerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBarWidget(title: widget.title),
      body: Column(
        children: <Widget>[
          Container(
            height: 1.0,
            width: double.infinity,
            color: colorScheme.onSurface.withAlpha(20),
          ),
          Expanded(
            child: Stack(
              children: <Widget>[
                SfPdfViewer.network(
                  widget.url,
                  key: _pdfViewerKey,
                  controller: _pdfViewerController,
                  canShowPaginationDialog: false,
                  canShowScrollHead: false,
                  canShowPageLoadingIndicator: false,
                  onDocumentLoaded: (details) {
                    setState(() {
                      _isLoading = false;
                      _totalPages = details.document.pages.count;
                    });

                    _triggerIndicator();
                  },
                  onPageChanged: (details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });

                    _triggerIndicator();
                  },
                  onDocumentLoadFailed: (details) {
                    setState(() {
                      _isLoading = false;
                      _hasError = true;
                    });
                  },
                ),
                if (_isLoading) const PdfViewerLoadingWidget(),
                if (_hasError) const PdfViewerErrorWidget(),
                if (!_isLoading && !_hasError && _totalPages > 0)
                  Positioned(
                    bottom: 32.0,
                    left: 0.0,
                    right: 0.0,
                    child: Center(
                      child: AnimatedOpacity(
                        opacity: _showIndicator ? 1.0 : 0.0,
                        duration: _showIndicator
                            ? Duration.zero
                            : const Duration(milliseconds: 600),
                        curve: Curves.easeOut,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14.0,
                            vertical: 6.0,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.onSurface.withAlpha(230),
                            borderRadius: BorderRadius.circular(30.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: Colors.black.withAlpha(40),
                                blurRadius: 12.0,
                                offset: const Offset(0.0, 4.0),
                              ),
                            ],
                          ),
                          child: Text(
                            "$_currentPage / $_totalPages",
                            style: GoogleFonts.plusJakartaSans(
                              color: colorScheme.surface,
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class PdfViewerLoadingWidget extends StatelessWidget {
  const PdfViewerLoadingWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 24.0,
              height: 24.0,
              child: CircularProgressIndicator(
                color: colorScheme.primary,
                strokeWidth: 3.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Carregando documento...",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface.withAlpha(160),
                fontSize: 13.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class PdfViewerErrorWidget extends StatelessWidget {
  const PdfViewerErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(
              Icons.error_outline_rounded,
              color: colorScheme.error,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Erro ao carregar arquivo",
              style: GoogleFonts.plusJakartaSans(
                color: colorScheme.onSurface,
                fontSize: 15.0,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
