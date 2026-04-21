enum AnnouncementType { info, reminder, poll, alert }

class AnnouncementPollOption {
  final String text;
  final int votes;

  AnnouncementPollOption({required this.text, required this.votes});
}

class AnnouncementPoll {
  final List<AnnouncementPollOption> options;
  final bool hasVoted;
  final bool isMultiSelect;

  AnnouncementPoll({
    required this.options,
    this.hasVoted = false,
    this.isMultiSelect = false,
  });
}

class Announcement {
  final String id;
  final String title;
  final String message;
  final AnnouncementType type;
  final DateTime createdAt;
  final AnnouncementPoll? poll;
  final DateTime? eventDate;
  final bool isHighlighted;

  Announcement({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.createdAt,
    this.poll,
    this.eventDate,
    this.isHighlighted = false,
  });
}
