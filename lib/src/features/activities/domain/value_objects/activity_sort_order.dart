enum ActivitySortOrder {
  asc,
  desc;

  String get label {
    return switch (this) {
      ActivitySortOrder.asc => 'Crescente',
      ActivitySortOrder.desc => 'Decrescente',
    };
  }
}
