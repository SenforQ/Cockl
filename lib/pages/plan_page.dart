import 'package:flutter/material.dart';

import '../data/fitness_repository.dart';
import '../models/plan_item.dart';
import '../widgets/plan_item_cover.dart';
import 'ai_chat_page.dart';
import 'plan_detail_page.dart';

class PlanPage extends StatelessWidget {
  const PlanPage({super.key, required this.repository});

  final FitnessRepository repository;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'This Week Plan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 12),
              Card(
                clipBehavior: Clip.antiAlias,
                elevation: 0,
                color: Theme.of(context).colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => AiChatPage(repository: repository),
                        ),
                      );
                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Stack(
                          children: [
                            Image.asset(
                              'assets/plan_ai_assistant.png',
                              height: 168,
                              width: double.infinity,
                              fit: BoxFit.cover,
                            ),
                            const Positioned(
                              right: 12,
                              top: 12,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  color: Color(0xD9000000),
                                  borderRadius: BorderRadius.all(Radius.circular(999)),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.chat_bubble_outline, size: 14, color: Colors.white),
                                      SizedBox(width: 6),
                                      Text(
                                        'Tap to Chat',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.smart_toy_outlined,
                                    size: 22,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'AI Workout Assistant',
                                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                          fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const Spacer(),
                                  Icon(
                                    Icons.arrow_forward_ios_rounded,
                                    size: 16,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
                              Text(
                                'This is your AI workout assistant. It provides professional guidance on warm-up and cooldown, training intensity, weekly planning, recovery, and nutrition to help you execute your plan more safely and effectively.',
                                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                      height: 1.45,
                                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ...List.generate(repository.weekPlans.length, (index) {
                final item = repository.weekPlans[index];
                final last = repository.weekPlans.length - 1;
                return _PlanTile(
                  repository: repository,
                  index: index,
                  item: item,
                  sequence: index + 1,
                  canMoveUp: index > 0,
                  canMoveDown: index < last,
                  onOpenDetail: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => PlanDetailPage(
                          index: index,
                          repository: repository,
                        ),
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 12),
              FilledButton.icon(
                onPressed: () => showAddTrainingPlanDialog(context, repository),
                icon: const Icon(Icons.add),
                label: const Text('Add Training Plan'),
              ),
            ],
          );
        },
      ),
    );
  }
}

void showAddTrainingPlanDialog(BuildContext context, FitnessRepository repository) {
  showDialog<void>(
    context: context,
    builder: (ctx) => _AddPlanDialog(repository: repository),
  );
}

class _AddPlanDialog extends StatefulWidget {
  const _AddPlanDialog({required this.repository});

  final FitnessRepository repository;

  @override
  State<_AddPlanDialog> createState() => _AddPlanDialogState();
}

class _AddPlanDialogState extends State<_AddPlanDialog> {
  late final TextEditingController _contentController;
  late final TextEditingController _actionsController;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _actionsController = TextEditingController();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _actionsController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final content = _contentController.text.trim();
    if (content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter the plan content')),
      );
      return;
    }
    final actions = _actionsController.text
        .split('\n')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();
    try {
      await widget.repository.addPlanItem(content: content, actions: actions);
    } on StateError catch (e) {
      if (!mounted) {
        return;
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );
      return;
    }
    if (!mounted) {
      return;
    }
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return AlertDialog(
      title: const Text('Add Training Plan'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'This will be item #${widget.repository.weekPlans.length + 1}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 14),
            Card(
              clipBehavior: Clip.antiAlias,
              elevation: 0,
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Plan Content',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _contentController,
                      decoration: InputDecoration(
                        hintText: 'e.g. Swimming + Stretching',
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
              color: scheme.surfaceContainerHighest.withValues(alpha: 0.65),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Action List',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Optional · one action per line',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                    const SizedBox(height: 10),
                    TextField(
                      controller: _actionsController,
                      decoration: InputDecoration(
                        hintText: 'Enter the first action on line 1, press Enter for next',
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        alignLabelWithHint: true,
                      ),
                      maxLines: 6,
                      minLines: 3,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        FilledButton(
          onPressed: _submit,
          child: const Text('Add'),
        ),
      ],
    );
  }
}

class _PlanTile extends StatelessWidget {
  const _PlanTile({
    required this.repository,
    required this.index,
    required this.item,
    required this.sequence,
    required this.canMoveUp,
    required this.canMoveDown,
    required this.onOpenDetail,
  });

  final FitnessRepository repository;
  final int index;
  final PlanItem item;
  final int sequence;
  final bool canMoveUp;
  final bool canMoveDown;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      margin: const EdgeInsets.only(bottom: 10),
      child: SizedBox(
        height: 166,
        child: Stack(
          fit: StackFit.expand,
          children: [
            PlanItemCover(
              item: item,
              listIndex: index,
              height: 166,
            ),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: onOpenDetail,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 10, 4, 64),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black,
                        child: Text('$sequence', style: const TextStyle(fontWeight: FontWeight.w700)),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.content,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                _statusText(item.status),
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Colors.white.withValues(alpha: 0.88),
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            tooltip: 'Move Up',
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              minimumSize: const Size(36, 36),
                              maximumSize: const Size(36, 36),
                              padding: const EdgeInsets.all(6),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: canMoveUp ? () => repository.movePlanItemUp(index) : null,
                            icon: const Icon(Icons.arrow_upward),
                          ),
                          const SizedBox(width: 4),
                          IconButton(
                            tooltip: 'Move Down',
                            style: IconButton.styleFrom(
                              foregroundColor: Colors.black,
                              backgroundColor: Colors.white,
                              minimumSize: const Size(36, 36),
                              maximumSize: const Size(36, 36),
                              padding: const EdgeInsets.all(6),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            onPressed: canMoveDown ? () => repository.movePlanItemDown(index) : null,
                            icon: const Icon(Icons.arrow_downward),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              left: 10,
              right: 10,
              bottom: 10,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: SegmentedButton<PlanStatus>(
                  style: SegmentedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    selectedForegroundColor: Colors.black,
                    selectedBackgroundColor: Colors.white,
                  ),
                  segments: const [
                    ButtonSegment<PlanStatus>(
                      value: PlanStatus.pending,
                      label: Text('Pending'),
                    ),
                    ButtonSegment<PlanStatus>(
                      value: PlanStatus.active,
                      label: Text('Active'),
                    ),
                    ButtonSegment<PlanStatus>(
                      value: PlanStatus.completed,
                      label: Text('Completed'),
                    ),
                  ],
                  selected: {item.status},
                  onSelectionChanged: (Set<PlanStatus> next) {
                    repository.setPlanStatus(index, next.first);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusText(PlanStatus s) {
    return switch (s) {
      PlanStatus.completed => 'Completed',
      PlanStatus.active => 'Active',
      PlanStatus.pending => 'Pending',
    };
  }
}
