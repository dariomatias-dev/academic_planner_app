import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:academic_planner/src/core/extensions/list_extension.dart';

import 'package:academic_planner/src/features/users/domain/entities/user_entity.dart';

import 'package:academic_planner/src/shared/widgets/app_bar_widget.dart';

class UserManagementScreen extends StatefulWidget {
  const UserManagementScreen({super.key});

  @override
  State<UserManagementScreen> createState() => _UserManagementScreenState();
}

class _UserManagementScreenState extends State<UserManagementScreen> {
  UserRole? _selectedRole;
  final TextEditingController _searchController = TextEditingController();

  final _mockUsers = <UserEntity>[
    UserEntity(
      id: '1',
      name: 'Dr. Valderi Reis',
      email: 'valderi.reis@ifpb.edu.br',
      role: UserRole.admin,
      createdAt: DateTime(2023, 5, 12),
      updatedAt: DateTime.now(),
    ),
    UserEntity(
      id: '2',
      name: 'Msc. Maria Oliveira',
      email: 'maria.oliveira@ifpb.edu.br',
      role: UserRole.teacher,
      createdAt: DateTime(2023, 8, 20),
      updatedAt: DateTime.now(),
    ),
    UserEntity(
      id: '3',
      name: 'Lucas Silva Souza',
      email: 'lucas.souza@academico.ifpb.edu.br',
      role: UserRole.student,
      createdAt: DateTime(2024, 2, 10),
      updatedAt: DateTime.now(),
    ),
    UserEntity(
      id: '4',
      name: 'Ana Beatriz Cavalcanti',
      email: 'ana.beatriz@academico.ifpb.edu.br',
      role: UserRole.student,
      createdAt: DateTime(2024, 2, 11),
      updatedAt: DateTime.now(),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final filteredUsers = _mockUsers.filter((user) {
      final matchesRole = _selectedRole == null || user.role == _selectedRole;
      final matchesSearch =
          user.name.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          ) ||
          user.email.toLowerCase().contains(
            _searchController.text.toLowerCase(),
          );

      return matchesRole && matchesSearch;
    });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(title: "Usuários"),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 0.0),
            child: Column(
              children: <Widget>[
                _buildSearchBar(colorScheme),
                const SizedBox(height: 16.0),
                _buildFilterChips(colorScheme),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.fromLTRB(20.0, 24.0, 20.0, 100.0),
              physics: const BouncingScrollPhysics(),
              itemCount: filteredUsers.length,
              itemBuilder: (context, index) {
                return UserCardWidget(user: filteredUsers[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(ColorScheme colorScheme) {
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
      child: TextField(
        controller: _searchController,
        onChanged: (value) => setState(() {}),
        style: GoogleFonts.plusJakartaSans(
          fontSize: 14.0,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          hintText: "Pesquisar por nome ou e-mail...",
          hintStyle: GoogleFonts.plusJakartaSans(
            color: colorScheme.onSurface.withAlpha(100),
            fontSize: 14.0,
            fontWeight: FontWeight.w500,
          ),
          prefixIcon: Icon(Icons.search_rounded, color: colorScheme.primary),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
      ),
    );
  }

  Widget _buildFilterChips(ColorScheme colorScheme) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: <Widget>[
          _buildChip("Todos", null),
          _buildChip("Admins", UserRole.admin),
          _buildChip("Professores", UserRole.teacher),
          _buildChip("Alunos", UserRole.student),
        ],
      ),
    );
  }

  Widget _buildChip(String label, UserRole? role) {
    final isSelected = _selectedRole == role;
    final colorScheme = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
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

  Color _getRoleColor(ColorScheme colorScheme) {
    return switch (user.role) {
      UserRole.admin => colorScheme.primary,
      UserRole.teacher => Colors.teal,
      UserRole.student => colorScheme.secondary,
    };
  }

  String _getRoleLabel() {
    return switch (user.role) {
      UserRole.admin => "ADMINISTRADOR",
      UserRole.teacher => "PROFESSOR",
      UserRole.student => "ALUNO",
    };
  }

  IconData _getRoleIcon() {
    return switch (user.role) {
      UserRole.admin => Icons.admin_panel_settings_rounded,
      UserRole.teacher => Icons.school_rounded,
      UserRole.student => Icons.person_rounded,
    };
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final roleColor = _getRoleColor(colorScheme);

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
            child: Icon(_getRoleIcon(), color: roleColor, size: 26.0),
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
                        _getRoleLabel(),
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
