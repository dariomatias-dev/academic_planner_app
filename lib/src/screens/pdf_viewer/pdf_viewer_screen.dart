import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:academic_planner/src/core/app_colors.dart';

class PdfViewerScreen extends StatefulWidget {
  const PdfViewerScreen({
    super.key,
    required this.url,
    required this.title,
    this.subtitle,
  });

  final String url;
  final String title;
  final String? subtitle;

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  final _pdfViewerKey = GlobalKey<SfPdfViewerState>();
  final _pdfViewerController = PdfViewerController();

  bool _isLoading = true;
  bool _hasError = false;
  int _currentPage = 1;
  int _totalPages = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: Column(
        children: <Widget>[
          PdfViewerHeaderWidget(
            onBack: () => Navigator.pop(context),
            title: widget.title,
            subtitle: widget.subtitle,
          ),
          Container(
            height: 1.0,
            width: double.infinity,
            color: AppColors.textMain.withAlpha(20),
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
                  },
                  onPageChanged: (details) {
                    setState(() {
                      _currentPage = details.newPageNumber;
                    });
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
                    bottom: 32,
                    left: 0,
                    right: 0,
                    child: Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.textMain.withAlpha(230),
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.black.withAlpha(40),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "$_currentPage / $_totalPages",
                          style: GoogleFonts.plusJakartaSans(
                            color: AppColors.white,
                            fontSize: 11.0,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.5,
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

class PdfViewerHeaderWidget extends StatelessWidget {
  const PdfViewerHeaderWidget({
    super.key,
    required this.onBack,
    required this.title,
    this.subtitle,
  });

  final VoidCallback onBack;
  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16.0, 60.0, 16.0, 16.0),
      color: AppColors.white,
      child: Row(
        children: <Widget>[
          IconButton(
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.bg,
              fixedSize: const Size(48.0, 48.0),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0),
              ),
            ),
            icon: const Icon(
              Icons.chevron_left_rounded,
              color: AppColors.textMain,
              size: 28.0,
            ),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (subtitle != null)
                  Text(
                    subtitle!.toUpperCase(),
                    style: GoogleFonts.plusJakartaSans(
                      color: AppColors.primary,
                      fontSize: 10.0,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                Text(
                  title,
                  style: GoogleFonts.plusJakartaSans(
                    color: AppColors.textMain,
                    fontSize: 16.0,
                    fontWeight: FontWeight.w800,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    return Container(
      color: AppColors.bg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: AppColors.primary,
                strokeWidth: 3.0,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              "Carregando documento...",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textSub,
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
    return Container(
      color: AppColors.bg,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Icon(
              Icons.error_outline_rounded,
              color: AppColors.dangerText,
              size: 48.0,
            ),
            const SizedBox(height: 16.0),
            Text(
              "Erro ao carregar arquivo",
              style: GoogleFonts.plusJakartaSans(
                color: AppColors.textMain,
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
