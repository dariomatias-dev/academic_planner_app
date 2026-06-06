import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:academic_planner/src/shared/utils/open_url.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/icon_buttons/icon_button_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/loading_state_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/error_state_widget.dart';

class PdfViewerScreen extends ConsumerStatefulWidget {
  final String title;
  final String url;

  const PdfViewerScreen({super.key, required this.title, required this.url});

  @override
  ConsumerState<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends ConsumerState<PdfViewerScreen> {
  final _pdfViewerKey = GlobalKey<SfPdfViewerState>();
  final _pdfViewerController = PdfViewerController();

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

  void _handleRetry() {
    setState(() {
      _isLoading = true;
      _hasError = false;
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
      appBar: AppBarWidget(
        title: widget.title,
        actions: [
          IconButtonWidget(
            icon: Icons.open_in_new_rounded,
            onPressed: () {
              openUrl(context, widget.url);
            },
            style: IconButtonStyle.neutral,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            height: 1.0,
            width: double.infinity,
            color: colorScheme.onSurface.withAlpha(20),
          ),
          Expanded(
            child: Stack(
              children: [
                if (!_hasError)
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
                if (_isLoading)
                  const LoadingStateWidget(message: 'Carregando documento...'),
                if (_hasError)
                  ErrorStateWidget(
                    title: "Falha ao carregar",
                    description:
                        "Não foi possível abrir o documento. Verifique sua conexão com a internet.",
                    actionLabel: "Tentar novamente",
                    onActionPressed: _handleRetry,
                  ),
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
                            boxShadow: [
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
