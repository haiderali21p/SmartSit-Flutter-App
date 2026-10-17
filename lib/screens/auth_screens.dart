import 'package:flutter/material.dart';
import '../app/smartsit_theme.dart';
import '../widgets/ui_components.dart';
import 'dashboard_shell.dart';

void _push(BuildContext context, Widget screen) {
  Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => screen));
}

void _replace(BuildContext context, Widget screen) {
  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute<void>(builder: (_) => screen), (_) => false);
}

class AuthFrame extends StatelessWidget {
  const AuthFrame({
    super.key,
    required this.child,
    this.heroTitle = 'Clinical precision for the modern workspace.',
    this.heroSubtitle = 'Posture is the silent architect of performance. Build your foundation with intelligence.',
  });

  final Widget child;
  final String heroTitle;
  final String heroSubtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartSitColors.canvas,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth >= 850) {
              return Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: _AuthHero(title: heroTitle, subtitle: heroSubtitle),
                  ),
                  Expanded(
                    flex: 5,
                    child: Center(
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 38, vertical: 28),
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 410),
                          child: child,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }


            return SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SizedBox(
                    height: constraints.maxHeight < 690 ? 178 : 208,
                    child: _AuthHero(
                      title: heroTitle,
                      subtitle: heroSubtitle,
                      compact: true,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(24, 27, 24, 34),
                    child: Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 440),
                        child: child,
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AuthHero extends StatelessWidget {
  const _AuthHero({required this.title, required this.subtitle, this.compact = false});
  final String title;
  final String subtitle;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SmartSitColors.ink,
      child: Stack(
        fit: StackFit.expand,
        children: [
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment(-.55, -.25),
                radius: 1.4,
                colors: [Color(0xFF333A3C), SmartSitColors.ink],
              ),
            ),
          ),
          Opacity(
            opacity: compact ? .38 : .62,
            child: ColorFiltered(
              colorFilter: const ColorFilter.mode(Colors.grey, BlendMode.saturation),
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuC4gx9eIrulNbrALN9aHz11cZPofn8RNKceSt1iu2XKb3xk9El5Nj4fpJjdbyRXij_LkkZe1FXuH8kjjwyEgZuo8qwDKle2rX39Auf67XrKl1JhZmUIcKlBCdtW35vA-td5JGng_plQrbj7Jv_p1h8s_yw0UBssF_H-COPIHxos27KBeNYQgd_KhWdaTdeSQGXtZTWvtzCnc8c5icJAtTf0mp27sX-4akz0aKTTOTG9q96yBtFB7hPquQOnSA2wnnaAmNYT6QozkE',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.expand(),
              ),
            ),
          ),
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomLeft,
                end: Alignment.topRight,
                colors: [Color(0xD90C0F10), Color(0x250C0F10), Color(0x660C0F10)],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(compact ? 22 : 52),
            child: compact
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmartSitLogo(dark: true, compact: true),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 36, height: 3, color: SmartSitColors.green),
                          const SizedBox(height: 12),
                          Text(
                            title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 21, height: 1.12, fontWeight: FontWeight.w400, color: Colors.white, letterSpacing: -.35),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            subtitle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 11, height: 1.35, color: Color(0xFFD1D5D6)),
                          ),
                        ],
                      ),
                    ],
                  )
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SmartSitLogo(dark: true, compact: true),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(width: 50, height: 3, color: SmartSitColors.green),
                          const SizedBox(height: 30),
                          Text(title, style: const TextStyle(fontSize: 38, height: 1.16, fontWeight: FontWeight.w300, color: Colors.white, letterSpacing: -.8)),
                          const SizedBox(height: 22),
                          Text(subtitle, style: const TextStyle(fontSize: 16, height: 1.5, fontStyle: FontStyle.italic, color: Color(0xFFB6B9BA))),
                        ],
                      ),
                      const Row(
                        children: [
                          _HeroStat(value: '98%', label: 'POSTURAL ACCURACY'),
                          SizedBox(width: 20),
                          SizedBox(height: 38, child: VerticalDivider(color: Colors.white24, width: 1)),
                          SizedBox(width: 20),
                          _HeroStat(value: '24/7', label: 'ACTIVE MONITORING'),
                        ],
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({required this.value, required this.label});
  final String value;
  final String label;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(value, style: const TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
          const SizedBox(height: 3),
          Text(label, style: const TextStyle(color: Color(0xFF9B9D9E), fontSize: 10, letterSpacing: 1.1, fontWeight: FontWeight.w600)),
        ],
      );
}

class AuthLineField extends StatelessWidget {
  const AuthLineField({super.key, required this.label, this.controller, this.obscureText = false, this.keyboardType, this.suffix, this.onSubmitted});
  final String label;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType? keyboardType;
  final Widget? suffix;
  final ValueChanged<String>? onSubmitted;

  @override
  Widget build(BuildContext context) => TextField(
    controller: controller,
    obscureText: obscureText,
    keyboardType: keyboardType,
    onSubmitted: onSubmitted,
    style: const TextStyle(fontSize: 15, color: SmartSitColors.text),
    decoration: InputDecoration(
      labelText: label,
      filled: false,
      contentPadding: const EdgeInsets.only(top: 18, bottom: 12),
      suffixIcon: suffix,
      border: const UnderlineInputBorder(borderSide: BorderSide(color: SmartSitColors.border)),
      enabledBorder: const UnderlineInputBorder(borderSide: BorderSide(color: SmartSitColors.border)),
      focusedBorder: const UnderlineInputBorder(borderSide: BorderSide(color: SmartSitColors.text, width: 1.5)),
    ),
  );
}

class _AuthHeading extends StatelessWidget {
  const _AuthHeading({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(fontSize: 29, height: 1.15, fontWeight: FontWeight.w900, letterSpacing: -.8, color: SmartSitColors.text)),
    const SizedBox(height: 9),
    Text(subtitle, style: const TextStyle(color: SmartSitColors.muted, fontSize: 13, height: 1.45)),
    const SizedBox(height: 30),
  ]);
}

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});
  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _showPassword = false;
  bool _remember = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AuthFrame(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const _AuthHeading(title: 'Welcome back', subtitle: 'Please enter your credentials to access your posture analytics.'),
            AuthLineField(label: 'Email address', controller: _email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            AuthLineField(
              label: 'Password',
              controller: _password,
              obscureText: !_showPassword,
              suffix: IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19, color: SmartSitColors.muted),
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                SizedBox(height: 24, width: 24, child: Checkbox(value: _remember, onChanged: (v) => setState(() => _remember = v ?? false), activeColor: SmartSitColors.green, side: const BorderSide(color: SmartSitColors.muted))),
                const SizedBox(width: 7),
                const Expanded(child: Text('Remember me', style: TextStyle(fontSize: 13, color: SmartSitColors.muted))),
                TextButton(onPressed: () => _push(context, const ForgotPasswordScreen()), child: const Text('Forgot password?', style: TextStyle(color: SmartSitColors.green, fontWeight: FontWeight.w700, fontSize: 13))),
              ],
            ),
            const SizedBox(height: 14),
            SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _replace(context, const DashboardShell(role: DashboardRole.user, authenticatedRole: DashboardRole.user)), child: const Text('Sign in  →'))),
            const SizedBox(height: 23),
            Center(
              child: Wrap(
                alignment: WrapAlignment.center,
                children: [
                  const Text("Don't have an account? ", style: TextStyle(color: SmartSitColors.muted, fontSize: 13)),
                  GestureDetector(onTap: () => _push(context, const SignUpScreen()), child: const Text('Sign up', style: TextStyle(color: SmartSitColors.text, fontSize: 13, fontWeight: FontWeight.w800))),
                ],
              ),
            ),
            const SizedBox(height: 12),
            Center(
              child: TextButton.icon(
                onPressed: () => _push(context, const AdminSignInScreen()),
                icon: const Icon(Icons.admin_panel_settings_outlined, size: 17),
                label: const Text('Admin / Owner sign in'),
                style: TextButton.styleFrom(foregroundColor: SmartSitColors.green, textStyle: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
              ),
            ),
            const SizedBox(height: 14),
            const Center(child: Text('PRIVACY POLICY     TERMS OF SERVICE     HELP CENTER', textAlign: TextAlign.center, style: TextStyle(color: Color(0xFFABB3B7), fontSize: 9, fontWeight: FontWeight.w700, letterSpacing: .45))),
          ],
        ),
      );
}

/// Separate owner/admin entry point. With no backend yet, this only selects the
/// correct demo panel; the server must enforce these permissions before release.
class AdminSignInScreen extends StatefulWidget {
  const AdminSignInScreen({super.key});
  @override
  State<AdminSignInScreen> createState() => _AdminSignInScreenState();
}

class _AdminSignInScreenState extends State<AdminSignInScreen> {
  bool _showPassword = false;
  final _email = TextEditingController();
  final _password = TextEditingController();

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  void _openAdmin() {
    // Temporary local demo gate, not production authentication. Move this
    // check to a trusted backend before exposing the app to real users.
    final email = _email.text.trim().toLowerCase();
    if (email != 'owner@smartsit.local' || _password.text != 'SmartSitOwner2026!') {
      AppNotice.show(context, 'Owner credentials do not match the local demo account.');
      return;
    }
    _replace(context, const DashboardShell(role: DashboardRole.admin, authenticatedRole: DashboardRole.admin));
  }

  @override
  Widget build(BuildContext context) => AuthFrame(
        heroTitle: 'Secure access for SmartSit owners.',
        heroSubtitle: 'Manage accounts, inventory and support from the administration workspace.',
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Row(
              children: [
                Icon(Icons.admin_panel_settings_outlined, color: SmartSitColors.green, size: 25),
                SizedBox(width: 9),
                Text('ADMIN / OWNER ACCESS', style: TextStyle(color: SmartSitColors.green, fontSize: 10, letterSpacing: 1.1, fontWeight: FontWeight.w900)),
              ],
            ),
            const SizedBox(height: 16),
            const _AuthHeading(title: 'Administrator sign in', subtitle: 'Use your owner account to open the SmartSit administration panel.'),
            AuthLineField(label: 'Admin email address', controller: _email, keyboardType: TextInputType.emailAddress),
            const SizedBox(height: 14),
            AuthLineField(
              label: 'Password',
              controller: _password,
              obscureText: !_showPassword,
              suffix: IconButton(
                onPressed: () => setState(() => _showPassword = !_showPassword),
                icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19, color: SmartSitColors.muted),
              ),
            ),
            const SizedBox(height: 12),
            const Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.lock_outline_rounded, size: 16, color: SmartSitColors.muted),
                SizedBox(width: 8),
                Expanded(child: Text('Owner access includes both Admin and User panels. User accounts will not see the Admin panel.', style: TextStyle(fontSize: 11, color: SmartSitColors.muted, height: 1.45))),
              ],
            ),
            const SizedBox(height: 22),
            SizedBox(width: double.infinity, child: FilledButton.icon(
              onPressed: _openAdmin,
              icon: const Icon(Icons.lock_open_rounded, size: 18),
              label: const Text('Sign in to Admin Panel'),
            )),
            const SizedBox(height: 18),
            Center(child: TextButton.icon(onPressed: () => _replace(context, const SignInScreen()), icon: const Icon(Icons.arrow_back_rounded, size: 16), label: const Text('Back to User Sign in'), style: TextButton.styleFrom(foregroundColor: SmartSitColors.green))),
            const SizedBox(height: 10),
            const Center(child: Text('Demo UI only • Use the local owner demo account', textAlign: TextAlign.center, style: TextStyle(fontSize: 10, color: SmartSitColors.softText))),
          ],
        ),
      );
}

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _showPassword = false;
  bool _showConfirm = false;
  bool _agree = false;
  @override
  Widget build(BuildContext context) => AuthFrame(
    heroTitle: 'Start your journey to a healthier posture.',
    heroSubtitle: 'Create your account and unlock intelligent posture tracking.',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AuthHeading(title: 'Create account', subtitle: 'Join SmartSit and improve your posture today.'),
      const AuthLineField(label: 'Full Name'),
      const SizedBox(height: 11),
      const AuthLineField(label: 'Email address', keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 11),
      AuthLineField(label: 'Password', obscureText: !_showPassword, suffix: IconButton(onPressed: () => setState(() => _showPassword = !_showPassword), icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19))),
      const SizedBox(height: 11),
      AuthLineField(label: 'Confirm Password', obscureText: !_showConfirm, suffix: IconButton(onPressed: () => setState(() => _showConfirm = !_showConfirm), icon: Icon(_showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19))),
      const SizedBox(height: 20),
      Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SizedBox(width: 24, height: 24, child: Checkbox(value: _agree, onChanged: (v) => setState(() => _agree = v ?? false), activeColor: SmartSitColors.green, side: const BorderSide(color: SmartSitColors.muted))),
        const SizedBox(width: 8),
        const Expanded(child: Padding(padding: EdgeInsets.only(top: 3), child: Text('By creating an account you agree to the Terms & Conditions and Privacy Policy', style: TextStyle(color: SmartSitColors.muted, fontSize: 12.5, height: 1.55)))),
      ]),
      const SizedBox(height: 18),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _push(context, const VerifyOtpScreen()), child: const Text('Create Account  →'))),
      const SizedBox(height: 26),
      Center(child: Wrap(alignment: WrapAlignment.center, children: [const Text('Already have an account? ', style: TextStyle(color: SmartSitColors.muted, fontSize: 13)), GestureDetector(onTap: () => Navigator.pop(context), child: const Text('Sign in', style: TextStyle(color: SmartSitColors.text, fontSize: 13, fontWeight: FontWeight.w800)))])),
    ]),
  );
}

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});
  @override
  Widget build(BuildContext context) => AuthFrame(
    heroTitle: 'Reset your password.',
    heroSubtitle: 'Secure your account and get back to improving your posture.',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AuthHeading(title: 'Forgot password?', subtitle: 'Enter the email associated with your account. We will guide you through resetting your password.'),
      const AuthLineField(label: 'Email address', keyboardType: TextInputType.emailAddress),
      const SizedBox(height: 30),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _push(context, const VerifyOtpScreen()), child: const Text('Send verification code  →'))),
      const SizedBox(height: 18),
      Center(child: TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 17), label: const Text('Back to Sign in'), style: TextButton.styleFrom(foregroundColor: SmartSitColors.green))),
      const SizedBox(height: 20),
      const Center(child: Text('Demo interface only • No email is sent', style: TextStyle(fontSize: 11, color: SmartSitColors.muted))),
    ]),
  );
}

class VerifyOtpScreen extends StatefulWidget {
  const VerifyOtpScreen({super.key});
  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  final List<TextEditingController> _digits = List.generate(6, (_) => TextEditingController());
  @override
  void dispose() { for (final c in _digits) { c.dispose(); } super.dispose(); }

  @override
  Widget build(BuildContext context) => AuthFrame(
    heroTitle: 'Verify your account.',
    heroSubtitle: 'Enter the one-time code to continue securely.',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AuthHeading(title: 'Verify OTP', subtitle: 'Enter the 6-digit verification code to continue.'),
      const Text('We sent a code to', style: TextStyle(color: SmartSitColors.muted, fontSize: 13)),
      const SizedBox(height: 4),
      const Text('your email address', style: TextStyle(color: SmartSitColors.green, fontWeight: FontWeight.w700, fontSize: 13)),
      const SizedBox(height: 26),
      Row(children: List.generate(6, (i) => Expanded(child: Padding(padding: EdgeInsets.only(right: i == 5 ? 0 : 7), child: TextField(
        controller: _digits[i],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        maxLength: 1,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        decoration: InputDecoration(counterText: '', filled: true, fillColor: Colors.white, contentPadding: const EdgeInsets.symmetric(vertical: 13), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: SmartSitColors.border))),
        onChanged: (value) { if (value.isNotEmpty && i < 5) FocusScope.of(context).nextFocus(); if (value.isEmpty && i > 0) FocusScope.of(context).previousFocus(); },
      ))))),
      const SizedBox(height: 26),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _push(context, const SetNewPasswordScreen()), child: const Text('Verify and continue  →'))),
      const SizedBox(height: 18),
      Center(child: TextButton(onPressed: () => AppNotice.show(context, 'Demo only: a new code was not sent.'), child: const Text('Resend code', style: TextStyle(color: SmartSitColors.green, fontWeight: FontWeight.w700)))),
      Center(child: TextButton.icon(onPressed: () => Navigator.pop(context), icon: const Icon(Icons.arrow_back, size: 16), label: const Text('Back'), style: TextButton.styleFrom(foregroundColor: SmartSitColors.muted))),
    ]),
  );
}

class SetNewPasswordScreen extends StatefulWidget {
  const SetNewPasswordScreen({super.key});
  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen> {
  bool _showPassword = false;
  bool _showConfirm = false;
  @override
  Widget build(BuildContext context) => AuthFrame(
    heroTitle: 'Set a new password.',
    heroSubtitle: 'Choose a strong password to keep your SmartSit account secure.',
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const _AuthHeading(title: 'Set a new password', subtitle: 'Create a new password for your SmartSit account.'),
      AuthLineField(label: 'New password', obscureText: !_showPassword, suffix: IconButton(onPressed: () => setState(() => _showPassword = !_showPassword), icon: Icon(_showPassword ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19))),
      const SizedBox(height: 15),
      AuthLineField(label: 'Confirm new password', obscureText: !_showConfirm, suffix: IconButton(onPressed: () => setState(() => _showConfirm = !_showConfirm), icon: Icon(_showConfirm ? Icons.visibility_off_outlined : Icons.visibility_outlined, size: 19))),
      const SizedBox(height: 28),
      SizedBox(width: double.infinity, child: FilledButton(onPressed: () => _replace(context, const SignInScreen()), child: const Text('Update password  →'))),
      const SizedBox(height: 16),
      Center(child: TextButton(onPressed: () => _replace(context, const SignInScreen()), child: const Text('Return to Sign in', style: TextStyle(color: SmartSitColors.green, fontWeight: FontWeight.w700)))),
    ]),
  );
}
