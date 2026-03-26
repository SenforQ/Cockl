import 'package:flutter/material.dart';

import '../models/discover_post.dart';

class ReportPage extends StatefulWidget {
  const ReportPage({super.key, required this.post});

  final DiscoverPost post;

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {
  final TextEditingController _reasonController = TextEditingController();
  final TextEditingController _detailController = TextEditingController();
  String _category = 'Spam or misleading';
  bool _submitting = false;

  static const List<String> _categories = [
    'Spam or misleading',
    'Harassment or hate',
    'Violence or dangerous acts',
    'Nudity or sexual content',
    'Intellectual property',
    'Other',
  ];

  @override
  void dispose() {
    _reasonController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() => _submitting = true);
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (!mounted) {
      return;
    }
    setState(() => _submitting = false);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Report submitted. Thank you.')),
    );
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final post = widget.post;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Report'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            'Target',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Text(
            '${post.user} · ${post.title}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 24),
          Text(
            'Category',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: _category,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            items: _categories
                .map(
                  (c) => DropdownMenuItem<String>(
                    value: c,
                    child: Text(c),
                  ),
                )
                .toList(),
            onChanged: (v) {
              if (v != null) {
                setState(() => _category = v);
              }
            },
          ),
          const SizedBox(height: 24),
          Text(
            'Reason (short)',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _reasonController,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              hintText: 'Brief reason',
            ),
          ),
          const SizedBox(height: 24),
          Text(
            'Details',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _detailController,
            minLines: 5,
            maxLines: 10,
            decoration: const InputDecoration(
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
              hintText: 'Describe what happened',
            ),
          ),
          const SizedBox(height: 28),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: _submitting ? null : _submit,
              style: FilledButton.styleFrom(
                shape: const StadiumBorder(),
                padding: const EdgeInsets.symmetric(vertical: 14),
              ),
              child: _submitting
                  ? const SizedBox(
                      height: 22,
                      width: 22,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                    )
                  : const Text('Submit report'),
            ),
          ),
        ],
      ),
    );
  }
}
