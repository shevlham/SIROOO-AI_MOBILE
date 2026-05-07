import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';
import '../utils/constants.dart';

class ScheduleFormScreen extends StatefulWidget {
  final Schedule? schedule;
  final DateTime? initialDate;

  const ScheduleFormScreen({super.key, this.schedule, this.initialDate});

  @override
  State<ScheduleFormScreen> createState() => _ScheduleFormScreenState();
}

class _ScheduleFormScreenState extends State<ScheduleFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ScheduleService _scheduleService = ScheduleService();

  late TextEditingController _nameController;
  late TextEditingController _locationController;
  late TextEditingController _typeController;
  late DateTime _selectedDate;
  late TimeOfDay _startTime;
  late TimeOfDay _endTime;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.schedule?.name ?? '');
    _locationController = TextEditingController(text: widget.schedule?.location ?? '');
    _typeController = TextEditingController(text: widget.schedule?.eventType ?? '');
    _selectedDate = widget.schedule?.date ?? widget.initialDate ?? DateTime.now();
    
    if (widget.schedule != null) {
      _startTime = _parseTime(widget.schedule!.startTime);
      _endTime = _parseTime(widget.schedule!.endTime);
    } else {
      _startTime = const TimeOfDay(hour: 9, minute: 0);
      _endTime = const TimeOfDay(hour: 10, minute: 0);
    }
  }

  TimeOfDay _parseTime(String timeStr) {
    final parts = timeStr.split(':');
    return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
  }

  String _formatTime(TimeOfDay time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }

  Future<void> _save() async {
    if (_formKey.currentState!.validate()) {
      final schedule = Schedule(
        id: widget.schedule?.id,
        name: _nameController.text,
        date: _selectedDate,
        startTime: _formatTime(_startTime),
        endTime: _formatTime(_endTime),
        location: _locationController.text,
        eventType: _typeController.text,
      );

      try {
        if (widget.schedule == null) {
          await _scheduleService.createSchedule(schedule);
        } else {
          await _scheduleService.updateSchedule(widget.schedule!.id!, schedule);
        }
        if (mounted) Navigator.pop(context, true);
      } catch (e) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Error saving schedule: $e'),
              backgroundColor: Colors.redAccent,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    }
  }

  Future<void> _delete() async {
    try {
      await _scheduleService.deleteSchedule(widget.schedule!.id!);
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error deleting schedule: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppConstants.backgroundColor,
      appBar: AppBar(
        title: Text(
          widget.schedule == null ? 'New Event' : 'Edit Event',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded, color: AppConstants.textColor),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          if (widget.schedule != null)
            IconButton(
              icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
              onPressed: _delete,
            ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildLabel('Activity Name'),
              _buildTextField(_nameController, 'Enter activity name', Icons.edit_rounded),
              const SizedBox(height: 24),
              _buildLabel('Date'),
              _buildSelector(
                DateFormat('EEEE, MMMM d, y').format(_selectedDate),
                Icons.calendar_today_rounded,
                () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('Start Time'),
                        _buildSelector(
                          _formatTime(_startTime),
                          Icons.access_time_rounded,
                          () async {
                            final time = await showTimePicker(context: context, initialTime: _startTime);
                            if (time != null) setState(() => _startTime = time);
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildLabel('End Time'),
                        _buildSelector(
                          _formatTime(_endTime),
                          Icons.access_time_rounded,
                          () async {
                            final time = await showTimePicker(context: context, initialTime: _endTime);
                            if (time != null) setState(() => _endTime = time);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _buildLabel('Location'),
              _buildTextField(_locationController, 'Enter location', Icons.location_on_rounded),
              const SizedBox(height: 24),
              _buildLabel('Event Type'),
              _buildTextField(_typeController, 'e.g. Work, Personal, Meeting', Icons.category_rounded),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                height: 56,
                child: ElevatedButton(
                  onPressed: _save,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppConstants.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    elevation: 0,
                  ),
                  child: Text(
                    widget.schedule == null ? 'Create Schedule' : 'Save Changes',
                    style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8),
      child: Text(
        text,
        style: GoogleFonts.outfit(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppConstants.subTextColor,
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint, IconData icon) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: AppConstants.softShadow,
      ),
      child: TextFormField(
        controller: controller,
        style: GoogleFonts.outfit(),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.outfit(color: Colors.grey[400]),
          prefixIcon: Icon(icon, color: AppConstants.primaryColor, size: 20),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
        validator: (value) => value!.isEmpty ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildSelector(String value, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: AppConstants.softShadow,
        ),
        child: Row(
          children: [
            Icon(icon, color: AppConstants.primaryColor, size: 20),
            const SizedBox(width: 12),
            Text(
              value,
              style: GoogleFonts.outfit(fontSize: 16, color: AppConstants.textColor),
            ),
          ],
        ),
      ),
    );
  }
}
