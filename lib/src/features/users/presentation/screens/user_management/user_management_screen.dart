import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/extensions/user_role_extension.dart';

import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';

class UserManagementScreen extends ConsumerStatefulWidget {
  const UserManagementScreen({super.key});

  @override
  ConsumerState<UserManagementScreen> createState() =>
      _UserManagementScreenState();
}

class _UserManagementScreenState extends ConsumerState<UserManagementScreen> {
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final usersAsync = ref.watch(usersProvider);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: const AppBarWidget(title: "Usuários"),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              children: <Widget>[
                _buildSearchBar(ref, colorScheme),
                const SizedBox(height: 16.0),
                _buildFilterChips(ref, colorScheme),
              ],
            ),
          ),
          Expanded(
            child: usersAsync.when(
              loading: () {
                return const LoadingStateWidget(
                  message: "Buscando usuários...",
                );
              },
              error: (err, _) {
                return ErrorStateWidget(description: err.toString());
              },
              data: (users) {
                if (users.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.people_outline_rounded,
                    title: "Nenhum usuário",
                    description: "A busca não retornou resultados.",
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.refresh(usersProvider.future),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
                    physics: const AlwaysScrollableScrollPhysics(
                      parent: BouncingScrollPhysics(),
                    ),
                    itemCount: users.length,
                    itemBuilder: (context, index) {
                      return UserCardWidget(user: users[index]);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(WidgetRef ref, ColorScheme colorScheme) {
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(20.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(8),
            blurRadius: 20.0,
            offset: const Offset(0.0, 4.0),
          ),
        ],
      ),
      child: InputWidget(
        controller: _searchController,
        onSubmitted: (value) {
          ref.read(userFilterProvider.notifier).setQuery(value.trim());
        },
        hint: 'Pressione enter para buscar...',
        prefixIcon: Icon(Icons.search_rounded),
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref, ColorScheme colorScheme) {
    final filter = ref.watch(userFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: <Widget>[
          _buildChip(ref, "Todos", null, filter.role == null, colorScheme),
          ...UserRole.values.map(
            (role) => _buildChip(
              ref,
              role.label,
              role,
              filter.role == role,
              colorScheme,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    WidgetRef ref,
    String label,
    UserRole? role,
    bool isSelected,
    ColorScheme colorScheme,
  ) {
    return GestureDetector(
      onTap: () => ref.read(userFilterProvider.notifier).setRole(role),
      child: Container(
        margin: const EdgeInsets.only(right: 8.0),
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
        decoration: BoxDecoration(
          color: isSelected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(14.0),
          border: Border.all(
            color: isSelected
                ? Colors.transparent
                : colorScheme.onSurface.withAlpha(15),
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.plusJakartaSans(
            fontSize: 12.0,
            fontWeight: FontWeight.w800,
            color: isSelected
                ? colorScheme.onPrimary
                : colorScheme.onSurface.withAlpha(180),
          ),
        ),
      ),
    );
  }
}

class UserCardWidget extends StatelessWidget {
  final UserEntity user;

  const UserCardWidget({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final roleColor = user.role.getColor(colorScheme);

    return Container(
      margin: const EdgeInsets.only(bottom: 16.0),
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(28.0),
        border: Border.all(
          color: theme.dividerTheme.color ?? Colors.transparent,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: colorScheme.onSurface.withAlpha(10),
            blurRadius: 24.0,
            offset: const Offset(0.0, 8.0),
          ),
        ],
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 56.0,
            height: 56.0,
            decoration: BoxDecoration(
              color: roleColor.withAlpha(20),
              borderRadius: BorderRadius.circular(18.0),
            ),
            child: Icon(user.role.icon, color: roleColor, size: 26.0),
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8.0,
                        vertical: 3.0,
                      ),
                      decoration: BoxDecoration(
                        color: roleColor.withAlpha(25),
                        borderRadius: BorderRadius.circular(6.0),
                      ),
                      child: Text(
                        user.role.label.toUpperCase(),
                        style: GoogleFonts.plusJakartaSans(
                          color: roleColor,
                          fontSize: 9.0,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Icon(
                      Icons.access_time_rounded,
                      size: 12.0,
                      color: colorScheme.onSurface.withAlpha(100),
                    ),
                    const SizedBox(width: 4.0),
                    Text(
                      DateFormat('dd/MM/yy').format(user.createdAt),
                      style: GoogleFonts.plusJakartaSans(
                        color: colorScheme.onSurface.withAlpha(120),
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6.0),
                Text(
                  user.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w800,
                    fontSize: 16.0,
                    color: colorScheme.onSurface,
                  ),
                ),
                Text(
                  user.email,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: GoogleFonts.plusJakartaSans(
                    color: colorScheme.onSurface.withAlpha(140),
                    fontSize: 13.0,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8.0),
          Icon(
            Icons.chevron_right_rounded,
            color: colorScheme.onSurface.withAlpha(60),
          ),
        ],
      ),
    );
  }
}
