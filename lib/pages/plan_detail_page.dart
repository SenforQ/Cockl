import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../constants/plan_cover_assets.dart';
import '../data/fitness_repository.dart';
import '../models/plan_item.dart';
import '../widgets/plan_item_cover.dart';

class PlanDetailPage extends StatefulWidget {
  const PlanDetailPage({
    super.key,
    required this.index,
    required this.repository,
  });

  final int index;
  final FitnessRepository repository;

  @override
  State<PlanDetailPage> createState() => _PlanDetailPageState();
}

class _PlanDetailPageState extends State<PlanDetailPage> {
  late TextEditingController _contentController;
  late List<TextEditingController> _actionControllers;
  String? _pendingBackgroundRelativePath;
  bool _explicitlyUseDefaultCover = false;

  @override
  void initState() {
    super.initState();
    final item = widget.repository.weekPlans[widget.index];
    _contentController = TextEditingController(text: item.content);
    _pendingBackgroundRelativePath = item.backgroundRelativePath;
    _explicitlyUseDefaultCover = false;
    if (item.actions.isEmpty) {
      _actionControllers = [TextEditingController()];
    } else {
      _actionControllers = item.actions.map((a) => TextEditingController(text: a)).toList();
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    for (final c in _actionControllers) {
      c.dispose();
    }
    super.dispose();
  }

  void _addActionRow() {
    setState(() {
      _actionControllers.add(TextEditingController());
    });
  }

  void _removeActionRow(int at) {
    if (_actionControllers.length <= 1) {
      _actionControllers[at].clear();
      setState(() {});
      return;
    }
    setState(() {
      _actionControllers[at].dispose();
      _actionControllers.removeAt(at);
    });
  }

  Future<void> _save() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the plan content')),
      );
      return;
    }
    final actions = _actionControllers.map((c) => c.text.trim()).where((s) => s.isNotEmpty).toList();
    final current = widget.repository.weekPlans[widget.index];
    final PlanItem next;
    if (_explicitlyUseDefaultCover) {
      next = current.copyWith(
        content: content,
        actions: actions,
        clearBackgroundRelativePath: true,
      );
    } else {
      next = current.copyWith(
        content: content,
        actions: actions,
        backgroundRelativePath: _pendingBackgroundRelativePath,
      );
    }
    await widget.repository.updatePlanItem(
      widget.index,
      next,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _explicitlyUseDefaultCover = false;
      _pendingBackgroundRelativePath = next.backgroundRelativePath;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Saved')),
    );
  }

  Future<void> _pickBackgroundImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 85);
    if (picked == null || !mounted) {
      return;
    }
    final dir = await getApplicationDocumentsDirectory();
    final sub = Directory('${dir.path}/plan_covers');
    if (!sub.existsSync()) {
      await sub.create(recursive: true);
    }
    final name = 'cover_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final dest = File('${sub.path}/$name');
    final bytes = await File(picked.path).readAsBytes();
    await dest.writeAsBytes(bytes, flush: true);
    if (!mounted) {
      return;
    }
    setState(() {
      _pendingBackgroundRelativePath = 'plan_covers/$name';
      _explicitlyUseDefaultCover = false;
    });
  }

  void _resetToDefaultCover() {
    setState(() {
      _pendingBackgroundRelativePath = null;
      _explicitlyUseDefaultCover = true;
    });
  }

  Future<void> _cycleStatusAndPop() async {
    await widget.repository.cyclePlanStatus(widget.index);
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.repository,
      builder: (context, _) {
        if (widget.index < 0 || widget.index >= widget.repository.weekPlans.length) {
          return Scaffold(
            appBar: AppBar(title: const Text('Plan Details')),
            body: const Center(child: Text('This plan no longer exists')),
          );
        }
        final item = widget.repository.weekPlans[widget.index];
        return Scaffold(
          appBar: AppBar(
            title: Text('Item ${widget.index + 1}'),
            actions: [
              TextButton(
                onPressed: _save,
                child: const Text('Save'),
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                      child: PlanItemCover(
                        item: item.copyWith(
                          backgroundRelativePath: _pendingBackgroundRelativePath,
                          clearBackgroundRelativePath: _explicitlyUseDefaultCover,
                        ),
                        listIndex: widget.index,
                        height: 192,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            'Background Image',
                            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                  fontWeight: FontWeight.w800,
                                ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            'When no custom image is selected, the same rotating built-in covers are used as the list (${PlanCoverAssets.defaultCovers.length} built-in).',
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  height: 1.4,
                                ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              FilledButton.tonalIcon(
                                onPressed: _pickBackgroundImage,
                                icon: const Icon(Icons.photo_library_outlined, size: 20),
                                label: const Text('Choose from Gallery'),
                              ),
                              const SizedBox(width: 10),
                              TextButton(
                                onPressed: _resetToDefaultCover,
                                child: const Text('Use Default Cover'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Order',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Item ${widget.index + 1} (auto-generated from list order)',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                      const SizedBox(height: 18),
                      Text(
                        'Current Status',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                            ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _statusText(item.status),
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Plan Content',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 10),
                      TextField(
                        controller: _contentController,
                        decoration: InputDecoration(
                          hintText: 'Enter training focus or arrangement, e.g. Swimming + Stretching',
                          filled: true,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        maxLines: 3,
                        minLines: 2,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.6),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Action List',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'One action per line. You can add/remove actions and save them to this week plan.',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onSurfaceVariant,
                              height: 1.4,
                            ),
                      ),
                      const SizedBox(height: 14),
                      ...List.generate(_actionControllers.length, (i) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                'Action ${i + 1}',
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: TextField(
                                      controller: _actionControllers[i],
                                      decoration: InputDecoration(
                                        hintText: 'Enter specific action or sets/reps',
                                        filled: true,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                      ),
                                      maxLines: 2,
                                      minLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  IconButton(
                                    onPressed: () => _removeActionRow(i),
                                    icon: const Icon(Icons.delete_outline),
                                    tooltip: 'Delete this row',
                                  ),
                                ],
                              ),
                            ],
                          ),
                        );
                      }),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: TextButton.icon(
                          onPressed: _addActionRow,
                          icon: const Icon(Icons.add_circle_outline),
                          label: const Text('Add Action'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _cycleStatusAndPop,
                child: const Text('Switch Status and Back'),
              ),
            ],
          ),
        );
      },
    );
  }

  String _statusText(PlanStatus status) {
    return switch (status) {
      PlanStatus.completed => 'Completed',
      PlanStatus.active => 'Active',
      PlanStatus.pending => 'Pending',
    };
  }
}
