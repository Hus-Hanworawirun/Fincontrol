import 'package:flutter/material.dart';
import '../widgets/glass_container.dart';

class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'Market Alert',
      'message': 'Apple Inc. (AAPL) is up 5.2% today!',
      'time': '10m ago',
      'icon': Icons.trending_up,
      'color': Colors.greenAccent.shade400,
      'isRead': false,
    },
    {
      'title': 'Goal Milestone',
      'message': 'You reached 50% of your New Car goal! Keep it up! 🎉',
      'time': '2h ago',
      'icon': Icons.flag,
      'color': Colors.orangeAccent,
      'isRead': false,
    },
    {
      'title': 'AI Insight',
      'message': 'Your Weekly Summary is ready! You saved 10% more this week compared to last week.',
      'time': '5h ago',
      'icon': Icons.auto_awesome,
      'color': Colors.blueAccent,
      'isRead': true,
    },
    {
      'title': 'Budget Warning',
      'message': 'Unusual spending detected: \$150 on Dining out this week.',
      'time': '1d ago',
      'icon': Icons.warning_amber_rounded,
      'color': Colors.redAccent.shade400,
      'isRead': true,
    },
    {
      'title': 'Bill Reminder',
      'message': 'Upcoming recurring expense: Netflix Subscription (\$15.99) tomorrow.',
      'time': '2d ago',
      'icon': Icons.calendar_today,
      'color': Colors.purpleAccent,
      'isRead': true,
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notif in _notifications) {
        notif['isRead'] = true;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final mutedTextColor = Theme.of(context).textTheme.bodySmall?.color ?? Colors.grey;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Container(
      decoration: BoxDecoration(
        gradient: isDarkMode 
          ? const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF0F172A), Color(0xFF1E1B4B)],
            )
          : const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFFF8FAFC), Color(0xFFE0E7FF)],
            ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          bottom: false,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: textColor),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'Notifications',
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    TextButton(
                      onPressed: _markAllAsRead,
                      child: Text(
                        'Mark read',
                        style: TextStyle(
                          color: primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.separated(
                  padding: const EdgeInsets.only(left: 20, right: 20, top: 8, bottom: 24),
                  itemCount: _notifications.length,
                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
            final notif = _notifications[index];
            final isRead = notif['isRead'] as bool;
            final iconColor = notif['color'] as Color;

            return GlassContainer(
              padding: const EdgeInsets.all(16),
              border: isRead ? null : Border.all(color: primaryColor.withValues(alpha: 0.5), width: 1.5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: iconColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(notif['icon'], color: iconColor),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              notif['title'],
                              style: TextStyle(
                                color: textColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              notif['time'],
                              style: TextStyle(
                                color: mutedTextColor,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notif['message'],
                          style: TextStyle(
                            color: isRead ? mutedTextColor : textColor,
                            fontSize: 14,
                            height: 1.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!isRead) ...[
                    const SizedBox(width: 12),
                    Container(
                      width: 8,
                      height: 8,
                      margin: const EdgeInsets.only(top: 6),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
