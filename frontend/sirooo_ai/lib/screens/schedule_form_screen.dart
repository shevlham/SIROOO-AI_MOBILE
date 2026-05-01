import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/schedule.dart';
import '../services/schedule_service.dart';

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
      _startTime = TimeOfDay.now();
      _endTime = TimeOfDay.now();
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
            SnackBar(content: Text('Error saving schedule: $e')),
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
      appBar: AppBar(
        title: Text(widget.schedule == null ? 'Add Schedule' : 'Edit Schedule'),
        actions: [
          if (widget.schedule != null)
            IconButton(icon: const Icon(Icons.delete), onPressed: _delete),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Activity Name'),
                validator: (value) => value!.isEmpty ? 'Please enter a name' : null,
              ),
              const SizedBox(height: 16),
              ListTile(
                title: Text('Date: ${DateFormat('yyyy-MM-dd').format(_selectedDate)}'),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (date != null) setState(() => _selectedDate = date);
                },
              ),
              Row(
                children: [
                  Expanded(
                    child: ListTile(
                      title: Text('Start: ${_formatTime(_startTime)}'),
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _startTime);
                        if (time != null) setState(() => _startTime = time);
                      },
                    ),
                  ),
                  Expanded(
                    child: ListTile(
                      title: Text('End: ${_formatTime(_endTime)}'),
                      onTap: () async {
                        final time = await showTimePicker(context: context, initialTime: _endTime);
                        if (time != null) setState(() => _endTime = time);
                      },
                    ),
                  ),
                ],
              ),
              TextFormField(
                controller: _locationController,
                decoration: const InputDecoration(labelText: 'Location'),
                validator: (value) => value!.isEmpty ? 'Please enter a location' : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: 'Event Type'),
                validator: (value) => value!.isEmpty ? 'Please enter a type' : null,
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: _save,
                child: const Text('Save Schedule'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
