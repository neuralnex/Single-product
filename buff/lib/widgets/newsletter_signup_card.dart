import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Collects email for the newsletter. Submission is wired when the backend exposes
/// `POST /api/newsletter/subscribe` (see repo `docs/BACKEND.md`).
class NewsletterSignupCard extends StatefulWidget {
  const NewsletterSignupCard({super.key});

  @override
  State<NewsletterSignupCard> createState() => _NewsletterSignupCardState();
}

class _NewsletterSignupCardState extends State<NewsletterSignupCard> {
  final _formKey = GlobalKey<FormState>();
  final _email = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Thanks — we\'ll notify ${_email.text.trim()} when drops and offers go live.',
        ),
      ),
    );
    _email.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tt = Theme.of(context).textTheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
        color: AppTheme.surfaceElevated,
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18, 20, 18, 18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.mark_email_unread_outlined,
                      color: AppTheme.neon.withValues(alpha: 0.95), size: 22),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Newsletter',
                      style: tt.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.2,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Email for product updates, restocks, and launch-only perks. '
                'No spam — unsubscribe anytime.',
                style: tt.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.62),
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _email,
                keyboardType: TextInputType.emailAddress,
                autocorrect: false,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: InputDecoration(
                  hintText: 'you@example.com',
                  filled: true,
                  fillColor: AppTheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: AppTheme.neon.withValues(alpha: 0.65),
                      width: 1.5,
                    ),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Enter your email';
                  final e = v.trim();
                  if (!e.contains('@') || !e.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    elevation: 3,
                    shadowColor: Colors.black.withValues(alpha: 0.45),
                    backgroundColor: LandingPalette.cta,
                    foregroundColor: LandingPalette.ctaForeground,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    textStyle: const TextStyle(
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                  child: const Text('Subscribe'),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'By subscribing you agree to receive marketing emails. Backend storage '
                'and double opt-in will be enforced server-side.',
                style: tt.labelSmall?.copyWith(
                  color: Colors.white.withValues(alpha: 0.45),
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
