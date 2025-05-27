// ignore_for_file: unnecessary_null_comparison
import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';

class MedicineScreen extends StatefulWidget {
  const MedicineScreen({super.key});

  @override
  State<MedicineScreen> createState() => _MedicineScreenState();
}

class _MedicineScreenState extends State<MedicineScreen> {
  final DatabaseReference _databaseRef = FirebaseDatabase.instance.ref(
    'user_test/remedios',
  );
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _dosageController = TextEditingController();
  final TextEditingController _instructionsController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _timeController.dispose();
    _dosageController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: const ColorScheme.light(
              primary: CupertinoColors.systemBlue,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _formatTimeOfDay(picked);
      });
    }
  }

  String _formatTimeOfDay(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return DateFormat('HH:mm').format(dt);
  }

  String _formatTimeOfDayAsIso8601(TimeOfDay tod) {
    final now = DateTime.now();
    final dt = DateTime(now.year, now.month, now.day, tod.hour, tod.minute);
    return dt.toUtc().toIso8601String(); // Format as ISO 8601 UTC string
  }

  void _showModernNotification(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    final overlay = Overlay.of(context);
    final overlayEntry = OverlayEntry(
      builder:
          (context) => Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            left: 20,
            right: 20,
            child: Material(
              color: Colors.transparent,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color:
                      isError
                          ? CupertinoColors.destructiveRed.withOpacity(0.9)
                          : CupertinoColors.systemGreen.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      isError
                          ? CupertinoIcons.exclamationmark_circle
                          : CupertinoIcons.checkmark_circle,
                      color: CupertinoColors.white,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        message,
                        style: const TextStyle(
                          color: CupertinoColors.white,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
    );

    overlay.insert(overlayEntry);
    Future.delayed(const Duration(seconds: 3), () {
      overlayEntry.remove();
    });
  }

  TimeOfDay _parseTimeOfDayFromIso8601(String iso8601String) {
    final dateTime =
        DateTime.parse(iso8601String).toLocal(); // Convert to local time
    return TimeOfDay.fromDateTime(dateTime);
  }

  Future<void> _addMedicine() async {
    if (_nameController.text.isEmpty || _timeController.text.isEmpty) {
      _showModernNotification(
        context,
        'Preencha todos os campos',
        isError: true,
      );
      return;
    }

    try {
      await _databaseRef.push().set({
        'name': _nameController.text,
        'dosage': _dosageController.text,
        'scheduled_time': _formatTimeOfDayAsIso8601(
          _selectedTime!,
        ), // Format selected time
        'instructions': _instructionsController.text,
        'status': 'on-time', // Default status
        // 'createdAt': ServerValue.timestamp, // Removed as per new structure
        // 'bit': false, // Removed as per new structure
      });

      _nameController.clear();
      _timeController.clear();
      _dosageController.clear();
      _instructionsController.clear();
      _selectedTime = null;

      if (!mounted) return;
      Navigator.of(context, rootNavigator: true).pop();
      _showModernNotification(context, 'Medicamento adicionado com sucesso');
    } catch (e) {
      if (!mounted) return;
      _showModernNotification(context, 'Erro ao adicionar: $e', isError: true);
    }
  }

  Future<void> _deleteMedicine(String key) async {
    try {
      await _databaseRef.child(key).remove();
      if (!mounted) return;
      _showModernNotification(context, 'Medicamento removido com sucesso');
    } catch (e) {
      if (!mounted) return;
      _showModernNotification(context, 'Erro ao remover: $e', isError: true);
    }
  }

  Future<void> _editMedicine(
    String key,
    Map<dynamic, dynamic> currentMedicine,
  ) async {
    // Retrieve the new fields
    final currentName = currentMedicine['name'] ?? '';
    final currentScheduledTime = currentMedicine['scheduled_time'] ?? '';
    final currentDosage = currentMedicine['dosage'] ?? '';
    final currentInstructions = currentMedicine['instructions'] ?? '';

    _nameController.text = currentName;
    _dosageController.text = currentDosage;
    _instructionsController.text = currentInstructions;

    if (currentScheduledTime.isNotEmpty) {
      _selectedTime = _parseTimeOfDayFromIso8601(currentScheduledTime);
      _timeController.text = _formatTimeOfDay(
        _selectedTime!,
      ); // Format for display in the text field
    } else {
      _selectedTime = null;
      _timeController.text = '';
    }

    if (!mounted) return;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Editar Remédio'),
          message: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Nome do Remédio',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _dosageController,
                  placeholder: 'Dosagem',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _instructionsController,
                  placeholder: 'Instruções',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _timeController,
                  placeholder: 'Horário',
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(CupertinoIcons.time),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: () async {
                try {
                  // Only update name and scheduled_time for now
                  await _databaseRef.child(key).update({
                    'name': _nameController.text,
                    'dosage': _dosageController.text,
                    'scheduled_time':
                        _selectedTime != null
                            ? _formatTimeOfDayAsIso8601(_selectedTime!)
                            : '',
                    'instructions': _instructionsController.text,
                    // status is not updated here
                  });
                  _nameController.clear();
                  _timeController.clear();
                  _dosageController.clear();
                  _instructionsController.clear();
                  _selectedTime = null;
                  if (!mounted) return;
                  Navigator.of(context, rootNavigator: true).pop();
                  _showModernNotification(
                    context,
                    'Medicamento atualizado com sucesso',
                  );
                } catch (e) {
                  if (!mounted) return;
                  _showModernNotification(
                    context,
                    'Erro ao atualizar: $e',
                    isError: true,
                  );
                }
              },
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(CupertinoIcons.pencil),
                  SizedBox(width: 8),
                  Text('Salvar'),
                ],
              ),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('Cancelar'),
          ),
        );
      },
    );
  }

  Future<void> _showDeleteConfirmation(String key) async {
    if (!mounted) return;
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Confirmar exclusão'),
          message: const Text(
            'Tem certeza que deseja excluir este medicamento?',
          ),
          actions: [
            CupertinoActionSheetAction(
              isDestructiveAction: true,
              onPressed: () {
                Navigator.of(context, rootNavigator: true).pop();
                _deleteMedicine(key);
              },
              child: const Text('Excluir'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('Cancelar'),
          ),
        );
      },
    );
  }

  void _showAddMedicineDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: const Text('Adicionar Remédio'),
          message: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CupertinoTextField(
                  controller: _nameController,
                  placeholder: 'Nome do Remédio',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _dosageController,
                  placeholder: 'Dosagem',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _instructionsController,
                  placeholder: 'Instruções',
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                const SizedBox(height: 16),
                CupertinoTextField(
                  controller: _timeController,
                  placeholder: 'Horário',
                  readOnly: true,
                  onTap: () => _selectTime(context),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: CupertinoColors.systemGrey4),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  suffix: const Padding(
                    padding: EdgeInsets.only(right: 8.0),
                    child: Icon(CupertinoIcons.time),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            CupertinoActionSheetAction(
              onPressed: _addMedicine,
              child: const Text('Adicionar'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () => Navigator.of(context, rootNavigator: true).pop(),
            child: const Text('Cancelar'),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      appBar: AppBar(title: const Text('Lembretes de Medicamentos')),
      body: StreamBuilder<DatabaseEvent>(
        stream: _databaseRef.onValue,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (!snapshot.hasData) {
            return const Center(child: CupertinoActivityIndicator());
          }

          final medicinesMap =
              snapshot.data!.snapshot.value as Map<dynamic, dynamic>?;
          if (medicinesMap == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    CupertinoIcons.heart,
                    size: 64,
                    color: CupertinoColors.systemGrey,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhum medicamento cadastrado',
                    style: TextStyle(
                      fontSize: 18,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Card(
                    margin: EdgeInsets.zero,
                    color: Colors.transparent,
                    elevation: 0,
                    child: ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const SizedBox(width: 40),
                      title: Center(
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: CupertinoColors.systemBlue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            CupertinoIcons.plus,
                            color: CupertinoColors.systemBlue,
                          ),
                        ),
                      ),
                      trailing: const SizedBox(width: 40),
                      onTap: _showAddMedicineDialog,
                    ),
                  ),
                ],
              ),
            );
          }

          final medicinesList =
              medicinesMap.entries.map((entry) {
                return {
                  'key': entry.key,
                  'name': entry.value['name'] ?? '',
                  'dosage': entry.value['dosage'] ?? '',
                  'scheduled_time': entry.value['scheduled_time'] ?? '',
                  'instructions': entry.value['instructions'] ?? '',
                  'status':
                      entry.value['status'] ??
                      'unknown', // Default status if not present
                  // 'time': entry.value['time'] ?? '', // Removed old field
                  // 'bit': entry.value['bit'] ?? false, // Removed old field
                };
              }).toList();

          medicinesList.sort((a, b) {
            final timeA = a['scheduled_time'] as String;
            final timeB = b['scheduled_time'] as String;
            if (timeA.isEmpty && timeB.isEmpty) return 0;
            if (timeA.isEmpty) return 1;
            if (timeB.isEmpty) return -1;
            return timeA.compareTo(timeB);
          });

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: medicinesList.length + 1,
            itemBuilder: (context, index) {
              if (index == medicinesList.length) {
                return Card(
                  margin: EdgeInsets.zero,
                  color: Colors.transparent,
                  elevation: 0,
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const SizedBox(width: 40),
                    title: Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          CupertinoIcons.plus,
                          color: CupertinoColors.systemBlue,
                        ),
                      ),
                    ),
                    trailing: const SizedBox(width: 40),
                    onTap: _showAddMedicineDialog,
                  ),
                );
              }

              final medicine = medicinesList[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  leading: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color:
                          medicine['status'] == 'on-time'
                              ? CupertinoColors.systemGreen.withOpacity(0.1)
                              : CupertinoColors.systemRed.withOpacity(
                                0.1,
                              ), // Assuming 'on-time' is the success status
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      medicine['status'] == 'on-time'
                          ? CupertinoIcons.checkmark_circle_fill
                          : CupertinoIcons
                              .circle, // Assuming 'on-time' is the success status
                      color:
                          medicine['status'] == 'on-time'
                              ? CupertinoColors.systemGreen
                              : CupertinoColors.systemRed,
                      size: 30.0, // Explicitly set icon size
                    ),
                  ),
                  title: Text(
                    medicine['name'],
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if ((medicine['scheduled_time'] as String).isNotEmpty)
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.time,
                              size: 14,
                              color: CupertinoColors.systemGrey,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              _formatTimeOfDay(
                                _parseTimeOfDayFromIso8601(
                                  medicine['scheduled_time'],
                                ),
                              ), // Display formatted time
                              style: TextStyle(
                                fontSize: 15,
                                color: CupertinoColors.systemGrey,
                              ),
                            ),
                          ],
                        ),
                      if ((medicine['dosage'] as String).isNotEmpty)
                        Text(
                          'Dosagem: ${medicine['dosage']}',
                          style: TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                      if ((medicine['instructions'] as String).isNotEmpty)
                        Text(
                          'Instruções: ${medicine['instructions']}',
                          style: TextStyle(
                            fontSize: 15,
                            color: CupertinoColors.systemGrey,
                          ),
                        ),
                    ],
                  ),
                  trailing: CupertinoButton(
                    padding: EdgeInsets.zero,
                    onPressed: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (BuildContext context) {
                          return CupertinoActionSheet(
                            title: Text(medicine['name']),
                            message: const Text('Escolha uma opção'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () {
                                  Navigator.pop(context);
                                  _editMedicine(
                                    medicine['key'],
                                    medicinesMap[medicine['key']]
                                        as Map<dynamic, dynamic>,
                                  );
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.pencil),
                                    SizedBox(width: 8),
                                    Text('Editar'),
                                  ],
                                ),
                              ),
                              CupertinoActionSheetAction(
                                isDestructiveAction: true,
                                onPressed: () {
                                  Navigator.pop(context);
                                  _showDeleteConfirmation(medicine['key']);
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(CupertinoIcons.delete),
                                    SizedBox(width: 8),
                                    Text('Excluir'),
                                  ],
                                ),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () => Navigator.pop(context),
                              child: const Text('Cancelar'),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(
                      CupertinoIcons.ellipsis,
                      color: CupertinoColors.systemGrey,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
