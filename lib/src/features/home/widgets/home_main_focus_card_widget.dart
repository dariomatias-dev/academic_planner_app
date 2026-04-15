import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:academic_planner/src/core/app_colors.dart';
import 'package:academic_planner/src/core/extensions/list_extension.dart';

class _FocusItem {
  final String title;
  final String subtitle;
  final String description;
  final String tag;
  final IconData icon;
  final String? imageUrl;
  final VoidCallback? onTap;

  _FocusItem({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.tag,
    required this.icon,
    this.imageUrl,
    this.onTap,
  });
}

class HomeMainFocusCardWidget extends StatefulWidget {
  const HomeMainFocusCardWidget({super.key});

  @override
  State<HomeMainFocusCardWidget> createState() =>
      _HomeMainFocusCardWidgetState();
}

class _HomeMainFocusCardWidgetState extends State<HomeMainFocusCardWidget> {
  int _currentIndex = 0;

  final items = <_FocusItem>[
    _FocusItem(
      title: "Entrega de TCC",
      subtitle: "Faltam apenas 15 dias para o envio da primeira prévia.",
      description:
          "A primeira entrega do Trabalho de Conclusão de Curso deve conter a Introdução, Objetivos e Metodologia. Certifique-se de que o arquivo esteja em PDF e siga as normas da ABNT vigentes. O envio deve ser feito exclusivamente via Portal Acadêmico até as 23:59 do prazo final.",
      tag: "URGENTE",
      icon: Icons.history_edu_rounded,
      imageUrl:
          "https://imgs.search.brave.com/Jr_zb-cPZpQgakeMtFiCKVF69nifDA_kNHJySn_YNxY/rs:fit:860:0:0:0/g:ce/aHR0cHM6Ly93d3cu/aWZwYi5lZHUuYnIv/Y2FtcHVzL2pvYW9w/ZXNzb2EvZGVzdGFx/dWUvY29weV9vZl9p/bWFnZW5zL2pvYW8t/cGVzc29hLTIwMjUt/Mi5qcGVnL0BAaW1h/Z2VzL2ltYWdlLTEw/NDMtYmUzMjkzODgw/NGQ2ODg2ZDNjNDZj/OTlkZjk1YjU3ZDAu/anBlZw",
      onTap: () {},
    ),
    _FocusItem(
      title: "Feira de Carreiras",
      subtitle: "Mais de 20 empresas confirmadas no bloco central.",
      description:
          "Venha participar do maior evento de networking do campus. Grandes empresas de tecnologia estarão presentes oferecendo vagas de estágio e trainee. Traga seu currículo atualizado e participe das palestras exclusivas sobre carreira e inovação no auditório principal.",
      tag: "OPORTUNIDADE",
      icon: Icons.work_outline_rounded,
      onTap: () {},
    ),
    _FocusItem(
      title: "Biblioteca Digital",
      subtitle: "Novos títulos de computação adicionados ao acervo.",
      description:
          "A biblioteca acaba de adquirir 50 novos e-books focados em inteligência artificial, desenvolvimento mobile e arquitetura de software. O acesso é gratuito para todos os alunos devidamente matriculados através das credenciais institucionais.",
      tag: "NOVIDADE",
      icon: Icons.menu_book_rounded,
    ),
    _FocusItem(
      title: "Saúde Mental",
      subtitle: "Agende uma conversa com nossos orientadores.",
      description:
          "O campus oferece suporte psicológico gratuito para auxiliar no gerenciamento do estresse acadêmico. As sessões ocorrem no prédio administrativo com total sigilo. O bem-estar do estudante é nossa prioridade fundamental.",
      tag: "APOIO",
      icon: Icons.favorite_border_rounded,
      onTap: () {},
    ),
  ];

  void _showDetailsModal(BuildContext context, _FocusItem item) {
    final colorScheme = Theme.of(context).colorScheme;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.transparent,
      builder: (context) {
        return Container(
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: colorScheme.surface,
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(32.0),
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                SizedBox(
                  height: item.imageUrl != null ? 240.0 : 60.0,
                  child: Stack(
                    children: <Widget>[
                      if (item.imageUrl != null)
                        Positioned.fill(
                          child: ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(32.0),
                            ),
                            child: Image.network(
                              item.imageUrl!,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      Positioned(
                        top: 16.0,
                        right: 16.0,
                        child: GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: colorScheme.surface.withAlpha(220),
                              shape: BoxShape.circle,
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: Colors.black.withAlpha(20),
                                  blurRadius: 10.0,
                                ),
                              ],
                            ),
                            child: Icon(
                              Icons.close_rounded,
                              color: colorScheme.onSurface,
                              size: 24.0,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(32.0, 24.0, 32.0, 40.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12.0,
                          vertical: 6.0,
                        ),
                        decoration: BoxDecoration(
                          color: colorScheme.primary.withAlpha(20),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        child: Text(
                          item.tag,
                          style: GoogleFonts.plusJakartaSans(
                            color: colorScheme.primary,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20.0),
                      Text(
                        item.title,
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface,
                          fontSize: 26.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 16.0),
                      Text(
                        item.description,
                        style: GoogleFonts.plusJakartaSans(
                          color: colorScheme.onSurface.withAlpha(160),
                          fontSize: 16.0,
                          fontWeight: FontWeight.w500,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 48.0),
                      GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: double.infinity,
                          height: 60.0,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: <Color>[
                                colorScheme.primary,
                                colorScheme.secondary,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(20.0),
                            boxShadow: <BoxShadow>[
                              BoxShadow(
                                color: colorScheme.primary.withAlpha(60),
                                blurRadius: 20.0,
                                offset: const Offset(0.0, 8.0),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              "Entendido",
                              style: GoogleFonts.plusJakartaSans(
                                color: colorScheme.onPrimary,
                                fontSize: 16.0,
                                fontWeight: FontWeight.w800,
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
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      children: <Widget>[
        CarouselSlider(
          options: CarouselOptions(
            height: 220.0,
            viewportFraction: 1.0,
            autoPlay: true,
            autoPlayInterval: const Duration(seconds: 7),
            onPageChanged: (index, reason) {
              setState(() => _currentIndex = index);
            },
          ),
          items: items.builder((item, index) {
            final bool hasAction = item.onTap != null;

            return Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                borderRadius: BorderRadius.circular(32.0),
                border: Border.all(
                  color:
                      Theme.of(context).dividerTheme.color ??
                      AppColors.transparent,
                  width: 1.0,
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.onSurface.withAlpha(8),
                    blurRadius: 30.0,
                    offset: const Offset(0.0, 15.0),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(32.0),
                child: Material(
                  color: AppColors.transparent,
                  child: InkWell(
                    onTap: hasAction
                        ? () => _showDetailsModal(context, item)
                        : null,
                    splashColor: hasAction
                        ? colorScheme.primary.withAlpha(15)
                        : AppColors.transparent,
                    highlightColor: hasAction
                        ? colorScheme.primary.withAlpha(5)
                        : AppColors.transparent,
                    child: Stack(
                      children: <Widget>[
                        Positioned(
                          right: -30.0,
                          top: -30.0,
                          child: Icon(
                            item.icon,
                            size: 160.0,
                            color: colorScheme.primary.withAlpha(8),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(28.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12.0,
                                  vertical: 6.0,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withAlpha(20),
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                child: Text(
                                  item.tag,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: colorScheme.primary,
                                    fontSize: 10.0,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: 1.2,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16.0),
                              Text(
                                item.title,
                                style: GoogleFonts.plusJakartaSans(
                                  color: colorScheme.onSurface,
                                  fontSize: 22.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              SizedBox(
                                width: 260.0,
                                child: Text(
                                  item.subtitle,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: GoogleFonts.plusJakartaSans(
                                    color: colorScheme.onSurface.withAlpha(160),
                                    fontSize: 14.0,
                                    fontWeight: FontWeight.w500,
                                    height: 1.4,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              if (hasAction)
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: <Widget>[
                                    Text(
                                      "Ver detalhes",
                                      style: GoogleFonts.plusJakartaSans(
                                        color: colorScheme.primary,
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(width: 4.0),
                                    Icon(
                                      Icons.chevron_right_rounded,
                                      color: colorScheme.primary,
                                      size: 18.0,
                                    ),
                                  ],
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: items.asMap().entries.map((entry) {
            final isSelected = _currentIndex == entry.key;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: isSelected ? 24.0 : 8.0,
              height: 8.0,
              margin: const EdgeInsets.symmetric(horizontal: 4.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                color: isSelected
                    ? colorScheme.primary
                    : Theme.of(context).dividerTheme.color,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
