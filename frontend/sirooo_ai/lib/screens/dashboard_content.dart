import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import '../utils/constants.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import 'chat_screen.dart';
import 'schedule_screen.dart';

class DashboardContent extends StatefulWidget {
  const DashboardContent({super.key});

  @override
  State<DashboardContent> createState() => _DashboardContentState();
}

class _DashboardContentState extends State<DashboardContent> {
  final ScheduleService _scheduleService = ScheduleService();
  Schedule? _upcomingSchedule;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchUpcomingSchedule();
  }

  Future<void> _fetchUpcomingSchedule() async {
    try {
      final schedules = await _scheduleService.getSchedules();
      final now = DateTime.now();
      
      // Filter for future schedules and sort by date and time
      List<Schedule> futureSchedules = schedules.where((s) {
        final scheduleDateTime = _getDateTime(s.date, s.startTime);
        return scheduleDateTime.isAfter(now);
      }).toList();

      futureSchedules.sort((a, b) {
        final aTime = _getDateTime(a.date, a.startTime);
        final bTime = _getDateTime(b.date, b.startTime);
        return aTime.compareTo(bTime);
      });

      setState(() {
        _upcomingSchedule = futureSchedules.isNotEmpty ? futureSchedules.first : null;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  DateTime _getDateTime(DateTime date, String time) {
    final parts = time.split(':');
    return DateTime(date.year, date.month, date.day, int.parse(parts[0]), int.parse(parts[1]));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          // Background Aesthetics
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 300,
              height: 300,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    AppConstants.primaryColor.withOpacity(0.1),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          
          RefreshIndicator(
            onRefresh: _fetchUpcomingSchedule,
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),
                  const SizedBox(height: 32),
                  _buildUpcomingHighlight(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Quick Access'),
                  const SizedBox(height: 16),
                  _buildFeatureGrid(context),
                  const SizedBox(height: 32),
                  _buildSectionTitle('Recent Activity'),
                  const SizedBox(height: 16),
                  _buildSummaryCard(
                    context,
                    title: 'AI Chat History',
                    subtitle: 'Discussion about project timeline',
                    icon: Icons.psychology_rounded,
                    gradient: AppConstants.accentGradient,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen())),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Good Morning,',
              style: GoogleFonts.outfit(
                color: AppConstants.subTextColor,
                fontSize: 16,
              ),
            ),
            Text(
              'Sheva',
              style: GoogleFonts.outfit(
                color: AppConstants.textColor,
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        Hero(
          tag: 'logo',
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: AppConstants.primaryColor.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 26,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUpcomingHighlight(BuildContext context) {
    if (_isLoading) {
      return Container(
        height: 200,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(32),
          boxShadow: AppConstants.softShadow,
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: AppConstants.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppConstants.primaryColor.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Upcoming Schedule',
                style: GoogleFonts.outfit(
                  color: Colors.white.withOpacity(0.8),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const Icon(Icons.notifications_active_rounded, color: Colors.white, size: 20),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _upcomingSchedule?.name ?? 'No Upcoming Events',
            style: GoogleFonts.outfit(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          if (_upcomingSchedule != null)
            Row(
              children: [
                const Icon(Icons.access_time_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 6),
                Text(
                  '${_upcomingSchedule!.startTime} - ${_upcomingSchedule!.endTime}',
                  style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(width: 12),
                const Icon(Icons.location_on_rounded, color: Colors.white70, size: 16),
                const SizedBox(width: 4),
                Flexible(
                  child: Text(
                    _upcomingSchedule!.location,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.outfit(color: Colors.white70, fontSize: 14),
                  ),
                ),
              ],
            ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleScreen())),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white.withOpacity(0.2),
              foregroundColor: Colors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            ),
            child: Text(
              'View All Schedules',
              style: GoogleFonts.outfit(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.outfit(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: AppConstants.textColor,
      ),
    );
  }

  Widget _buildFeatureGrid(BuildContext context) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 1.1,
      children: [
        _buildFeatureItem(
          context,
          'Schedules',
          Icons.calendar_today_rounded,
          AppConstants.primaryColor,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ScheduleScreen())),
        ),
        _buildFeatureItem(
          context,
          'AI Assistant',
          Icons.auto_awesome_rounded,
          AppConstants.accentColor,
          () => Navigator.push(context, MaterialPageRoute(builder: (context) => const ChatScreen())),
        ),
      ],
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppConstants.softShadow,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: color,
              size: 40,
              shadows: [
                Shadow(
                  color: color.withOpacity(0.4),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: AppConstants.textColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required IconData icon,
    required LinearGradient gradient,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: AppConstants.softShadow,
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: gradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: Colors.white, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppConstants.textColor,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: GoogleFonts.outfit(
                      color: AppConstants.subTextColor,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios_rounded, color: AppConstants.subTextColor, size: 16),
          ],
        ),
      ),
    );
  }
}
