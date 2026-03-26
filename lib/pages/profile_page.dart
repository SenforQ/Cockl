import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:share_plus/share_plus.dart';

import '../data/fitness_repository.dart';
import '../widgets/profile_user_avatar.dart';
import 'about_me_page.dart';
import 'editor_page.dart';
import 'feedback_page.dart';
import 'privacy_policy_page.dart';
import 'user_agreement_page.dart';
import 'wallet_recharge_page.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key, required this.repository});

  final FitnessRepository repository;

  static Future<void> _rateApp() async {
    final review = InAppReview.instance;
    if (await review.isAvailable()) {
      await review.requestReview();
    }
  }

  static Future<void> _shareApp() async {
    await SharePlus.instance.share(
      ShareParams(text: 'Check out Cockl — your fitness companion.'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedBuilder(
        animation: repository,
        builder: (context, _) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      ProfileUserAvatar(repository: repository, radius: 32),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              repository.profileNickname,
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              repository.profileSignature.isEmpty
                                  ? 'Tap Edit Information to add a signature'
                                  : repository.profileSignature,
                              style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
              const SizedBox(height: 12),
              _SectionCard(
                children: [
                  ListTile(
                    leading: Icon(
                      Icons.account_balance_wallet_outlined,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    title: const Text('Wallet'),
                    subtitle: Text('Balance: ${repository.walletCoins} Coins'),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => WalletRechargePage(repository: repository),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _ProfileMenuTile(
                    icon: Icons.edit_outlined,
                    title: 'Edit Information',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => EditorPage(repository: repository),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                children: [
                  _ProfileMenuTile(
                    icon: Icons.star_outline_rounded,
                    title: 'Rate App',
                    onTap: () => _rateApp(),
                  ),
                  const Divider(height: 1),
                  _ProfileMenuTile(
                    icon: Icons.ios_share_rounded,
                    title: 'Share App',
                    onTap: () => _shareApp(),
                  ),
                  const Divider(height: 1),
                  _ProfileMenuTile(
                    icon: Icons.feedback_outlined,
                    title: 'Feedback',
                    onTap: () async {
                      final submitted = await Navigator.of(context).push<bool>(
                        MaterialPageRoute<bool>(
                          builder: (_) => const FeedbackPage(),
                        ),
                      );
                      if (context.mounted && submitted == true) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Submitted successfully')),
                        );
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _SectionCard(
                children: [
                  _ProfileMenuTile(
                    icon: Icons.privacy_tip_outlined,
                    title: 'Privacy Policy',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const PrivacyPolicyPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _ProfileMenuTile(
                    icon: Icons.description_outlined,
                    title: 'User Agreement',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const UserAgreementPage(),
                        ),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  _ProfileMenuTile(
                    icon: Icons.info_outline_rounded,
                    title: 'About Me',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const AboutMePage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
    );
  }
}

class _ProfileMenuTile extends StatelessWidget {
  const _ProfileMenuTile({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: Theme.of(context).colorScheme.primary),
      title: Text(title),
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
