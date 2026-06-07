import 'package:academic_planner/src/core/extensions/user_role_extension.dart';
import 'package:academic_planner/src/features/users/di/user_providers.dart';
import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';
import 'package:academic_planner/src/features/users/presentation/widgets/user_card_widget.dart';
import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';
import 'package:academic_planner/src/shared/widgets/inputs/input_widget.dart';
import 'package:academic_planner/src/shared/widgets/states/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

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
      appBar: const AppBarWidget(title: 'Usuários'),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              children: [
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
                  message: 'Buscando usuários...',
                );
              },
              error: (err, _) {
                return ErrorStateWidget(description: err.toString());
              },
              data: (users) {
                if (users.isEmpty) {
                  return const EmptyStateWidget(
                    icon: Icons.people_outline_rounded,
                    title: 'Nenhum usuário',
                    description: 'A busca não retornou resultados.',
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
        boxShadow: [
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
        prefixIcon: const Icon(Icons.search_rounded),
      ),
    );
  }

  Widget _buildFilterChips(WidgetRef ref, ColorScheme colorScheme) {
    final filter = ref.watch(userFilterProvider);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: [
          _buildChip(ref, 'Todos', null, filter.role == null, colorScheme),
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
