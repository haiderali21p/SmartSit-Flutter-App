import 'package:flutter/material.dart';
import '../app/smartsit_theme.dart';
import '../widgets/ui_components.dart';

Widget responsiveCards(BuildContext context, List<Widget> children, {double minWidth = 245, double spacing = 12, int maxColumns = 3}) {
  return LayoutBuilder(builder: (context, constraints) {
    final raw = ((constraints.maxWidth + spacing) / (minWidth + spacing)).floor();
    final columns = raw.clamp(1, maxColumns).toInt();
    final width = (constraints.maxWidth - spacing * (columns - 1)) / columns;
    return Wrap(spacing: spacing, runSpacing: spacing, children: children.map((w) => SizedBox(width: width, child: w)).toList());
  });
}

/// Desktop/tablet layouts mirror the web page's asymmetric grid. On phones the
/// same cards stack vertically, keeping each chart and metric full-width.
Widget responsiveSplitCards(
  BuildContext context,
  List<Widget> children, {
  int firstFlex = 2,
  int secondFlex = 1,
  double breakpoint = 850,
  double spacing = 12,
}) {
  assert(children.length == 2, 'responsiveSplitCards expects exactly two cards.');
  return LayoutBuilder(builder: (context, constraints) {
    if (constraints.maxWidth >= breakpoint) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: firstFlex, child: children[0]),
          SizedBox(width: spacing),
          Expanded(flex: secondFlex, child: children[1]),
        ],
      );
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [children[0], SizedBox(height: spacing), children[1]],
    );
  });
}

class OverviewScreen extends StatelessWidget {
  const OverviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const PageIntro(title: 'Overview', subtitle: 'Your daily posture insights at a glance. Keep your spine aligned and build healthier sitting habits.'),
        responsiveCards(context, [
          SurfaceCard(child: Column(children: [
            Row(children: [const Expanded(child: Text('DAILY POSTURE SCORE', style: TextStyle(fontSize: 10, color: SmartSitColors.softText, fontWeight: FontWeight.w900, letterSpacing: 1))), Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5), decoration: BoxDecoration(color: SmartSitColors.greenLight, borderRadius: BorderRadius.circular(30)), child: const Text('+5% today', style: TextStyle(fontSize: 10, color: SmartSitColors.green, fontWeight: FontWeight.w800)))]),
            const SizedBox(height: 20),
            const ScoreRing(score: 85, size: 142),
            const SizedBox(height: 18),
            const Text('Your spinal alignment is Excellent', textAlign: TextAlign.center, style: TextStyle(color: SmartSitColors.muted, fontSize: 12)),
          ]), padding: const EdgeInsets.all(18)),
          SurfaceCard(color: SmartSitColors.panel, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [const Expanded(child: Text('LIVE STATUS', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: SmartSitColors.softText, letterSpacing: 1))), const StatusPill('LIVE')]),
            const SizedBox(height: 10),
            const Text('Excellent', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
            const SizedBox(height: 20),
            Row(children: [const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('Cervical alignment', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)), SizedBox(height: 4), Text('Neutral & centered', style: TextStyle(color: SmartSitColors.muted, fontSize: 11)), SizedBox(height: 14), Text('Lumbar support', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)), SizedBox(height: 4), Text('Active pressure detected', style: TextStyle(color: SmartSitColors.muted, fontSize: 11))])), const PostureSpineIllustration()],),
          ]), padding: const EdgeInsets.all(18)),
          SurfaceCard(color: const Color(0xFFE2E8F0), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('DISTRIBUTION', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: SmartSitColors.softText, letterSpacing: 1)),
            const SizedBox(height: 16),
            const SizedBox(height: 94, child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Expanded(child: _DistributionBar(value: .80, color: SmartSitColors.green)),
              SizedBox(width: 8), Expanded(child: _DistributionBar(value: .15, color: Color(0xFFF5B2B5))),
              SizedBox(width: 8), Expanded(child: _DistributionBar(value: .05, color: Color(0xFFCBD5F5))),
            ])),
            const SizedBox(height: 12),
            const InfoRow(label: 'Correct posture', value: '80%'),
            const InfoRow(label: 'Slumped posture', value: '15%'),
            const InfoRow(label: 'Other', value: '5%'),
          ]), padding: const EdgeInsets.all(18)),
        ], minWidth: 260),
        const SizedBox(height: 12),
        responsiveCards(context, [
          const MetricTile(label: 'Active Hours', value: '6h 12m', icon: Icons.schedule_rounded, note: '+8%'),
          const MetricTile(label: 'Focus Time', value: '4h 45m', icon: Icons.center_focus_strong_rounded, note: '+12%'),
          const MetricTile(label: 'Posture Breaks', value: '8 / 10', icon: Icons.self_improvement_rounded, note: 'On track'),
        ], minWidth: 190, maxColumns: 3),
        const SizedBox(height: 18),
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('PERFORMANCE METRICS', style: TextStyle(color: SmartSitColors.softText, fontSize: 10, letterSpacing: 1, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Row(children: [const Expanded(child: Text('Posture over time', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: SmartSitColors.text))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: SmartSitColors.panel, borderRadius: BorderRadius.circular(8)), child: const Text('Week', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)))]),
          const SizedBox(height: 18),
          const TrendChart(height: 170),
        ])),
        const SizedBox(height: 12),
        responsiveCards(context, [
          SurfaceCard(color: SmartSitColors.panel, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const SectionTitle('Recent posture alerts'),
            const SizedBox(height: 12),
            const _AlertRow(title: 'Lateral leaning detected', details: '2:14 PM • Duration: 12 minutes', bad: true),
            const SizedBox(height: 8),
            const _AlertRow(title: 'Minor forward slump', details: '11:05 AM • Duration: 5 minutes', bad: false),
          ])),
          SurfaceCard(color: const Color(0xFF606060), borderColor: const Color(0xFF606060), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('Posture Recommendation', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w900)),
            const SizedBox(height: 9),
            const Text('Based on your focus patterns today, we recommend a 3-minute “Scapular Squeeze” session to reset your thoracic spine.', style: TextStyle(color: Color(0xFFE2E5E6), height: 1.5, fontSize: 12)),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: () => AppNotice.show(context, 'Exercise guide is a UI preview.'),
              icon: const Icon(Icons.play_arrow_rounded, size: 18),
              label: const Text('Start Exercise Now'),
              style: FilledButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF424242), minimumSize: const Size(0, 42)),
            ),
          ])),
        ], minWidth: 280, maxColumns: 2),
      ]),
    );
  }
}

class _DistributionBar extends StatelessWidget {
  const _DistributionBar({required this.value, required this.color});
  final double value;
  final Color color;
  @override
  Widget build(BuildContext context) => Align(alignment: Alignment.bottomCenter, child: FractionallySizedBox(heightFactor: value.clamp(.05, 1).toDouble(), widthFactor: .78, child: Container(decoration: BoxDecoration(color: color, borderRadius: const BorderRadius.vertical(top: Radius.circular(6))))));
}

class _AlertRow extends StatelessWidget {
  const _AlertRow({required this.title, required this.details, required this.bad});
  final String title;
  final String details;
  final bool bad;
  @override
  Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(12), decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(11)), child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Container(width: 4, height: 38, decoration: BoxDecoration(color: bad ? const Color(0xFFFD4E4D) : const Color(0xFFCBD5E1), borderRadius: BorderRadius.circular(4))), const SizedBox(width: 10), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: SmartSitColors.text)), const SizedBox(height: 4), Text(details, style: const TextStyle(fontSize: 10, color: SmartSitColors.softText))]))]));
}

class MonitoringScreen extends StatelessWidget {
  const MonitoringScreen({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageIntro(title: 'Live Monitoring', subtitle: 'Monitor your sitting posture and pressure balance during the current session.', trailing: StatusPill('SESSION ACTIVE')),
      SurfaceCard(padding: const EdgeInsets.all(14), child: Row(children: [
        Container(width: 42, height: 42, decoration: BoxDecoration(color: SmartSitColors.greenLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.sensors_rounded, color: SmartSitColors.green)),
        const SizedBox(width: 12),
        const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('SmartSit Cushion V1', style: TextStyle(fontWeight: FontWeight.w900, color: SmartSitColors.text)), SizedBox(height: 3), Text('Connected • Session duration 42m 15s', style: TextStyle(fontSize: 11, color: SmartSitColors.muted))])),
        const StatusPill('GOOD'),
      ])),
      const SizedBox(height: 12),
      responsiveSplitCards(context, [
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Posture visualization', trailing: StatusPill('LIVE')),
          const SizedBox(height: 12),
          Container(height: 240, decoration: BoxDecoration(color: SmartSitColors.panel, borderRadius: BorderRadius.circular(14), border: Border.all(color: SmartSitColors.border)), child: Stack(children: [
            Positioned.fill(child: CustomPaint(painter: _DotGridPainter())),
            Center(
              child: Image.network(
                'https://lh3.googleusercontent.com/aida-public/AB6AXuAL-9_U7uZbgm7LHyRnSVmtG6OKWzq3fNQPJFy7gfQPctyfg5StzKuRoXZOaStbn7ME5MaWq7ti1-h3vSsA05YzXt-j2-HGUxLWbgCWUgw5VGyUF5VMzzbwegj0QCCGFymPIgBUT3Htqlnz6bzTgyl5Ac4Q4YpezgbfjtQEgdZhv0O5GClGG-yLJCnBD5WWsWCF9Roe5vBVVIxrcR8Xv4z3tBQ3XLJLV3MVnc9sSOBqaQYa6vY3rjtwJGz3l6_n3_SuSWO7SyhthVw',
                width: 230,
                height: 190,
                fit: BoxFit.contain,
                opacity: const AlwaysStoppedAnimation(.82),
                errorBuilder: (_, __, ___) => Container(
                  width: 116,
                  height: 190,
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCE8E0).withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(60),
                  ),
                  child: const Center(child: PostureSpineIllustration()),
                ),
              ),
            ),
            const Positioned(left: 12, bottom: 12, child: Text('SPINAL ALIGNMENT', style: TextStyle(color: SmartSitColors.softText, fontSize: 9, letterSpacing: 1, fontWeight: FontWeight.w900))),
            Positioned(right: 10, top: 10, child: Column(children: [IconButton(onPressed: () => AppNotice.show(context, '3D controls are visual placeholders.'), icon: const Icon(Icons.rotate_90_degrees_ccw_rounded, size: 18), style: IconButton.styleFrom(backgroundColor: Colors.white)), IconButton(onPressed: () => AppNotice.show(context, 'Zoom is a UI preview.'), icon: const Icon(Icons.zoom_in, size: 18), style: IconButton.styleFrom(backgroundColor: Colors.white))])),
          ])),
          const SizedBox(height: 12),
          const Row(children: [Icon(Icons.check_circle, color: SmartSitColors.green, size: 17), SizedBox(width: 7), Expanded(child: Text('Your spinal alignment looks neutral and centered.', style: TextStyle(fontSize: 12, color: SmartSitColors.muted)))]),
        ]), padding: const EdgeInsets.all(14)),
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Live Metrics'),
          const SizedBox(height: 7),
          const _LiveMetricRow(label: 'Spine Alignment', detail: 'Stable', reading: '0.4°', state: 'STABLE', good: true),
          const Divider(height: 1),
          const _LiveMetricRow(label: 'Neck Angle', detail: 'Normal', reading: '12.1°', state: 'NORMAL', good: true),
          const Divider(height: 1),
          const _LiveMetricRow(label: 'Pelvic Tilt', detail: 'Optimal', reading: '4.2°', state: 'OPTIMAL', good: true),
        ]), padding: const EdgeInsets.all(14)),
      ], firstFlex: 2, secondFlex: 1),
      const SizedBox(height: 12),
      responsiveSplitCards(context, [
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Seat pressure distribution', trailing: StatusPill('BALANCED')),
          const SizedBox(height: 16),
          Center(child: HeatmapVisual(size: 190)),
          const SizedBox(height: 14),
          const InfoRow(label: 'Balance score', value: '94%'),
          const SimpleProgressBar(value: .94),
          const SizedBox(height: 10),
          const Text('Weight appears evenly distributed across the seat. No significant lateral lean is shown in this UI preview.', style: TextStyle(color: SmartSitColors.muted, fontSize: 12, height: 1.5)),
        ])),
        SurfaceCard(color: SmartSitColors.panel, borderColor: SmartSitColors.panel, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Suggested correction'),
          const SizedBox(height: 15),
          Container(width: 42, height: 42, decoration: BoxDecoration(color: SmartSitColors.greenLight, borderRadius: BorderRadius.circular(12)), child: const Icon(Icons.accessibility_new, color: SmartSitColors.green)),
          const SizedBox(height: 12),
          const Text('Keep your shoulders relaxed', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, color: SmartSitColors.text)),
          const SizedBox(height: 7),
          const Text('Sit back in the chair, maintain a neutral spine and keep both feet flat on the floor.', style: TextStyle(color: SmartSitColors.muted, fontSize: 12, height: 1.5)),
          const SizedBox(height: 14),
          const StatusPill('LOW RISK'),
          const SizedBox(height: 16),
          const SectionTitle('Postural trend'),
          const SizedBox(height: 8),
          const TrendChart(height: 130, values: [82, 88, 86, 92, 87, 94], labels: ['1', '2', '3', '4', '5', '6']),
        ])),
      ], firstFlex: 2, secondFlex: 1),
    ]),
  );
}

class _LiveMetricRow extends StatelessWidget {
  const _LiveMetricRow({
    required this.label,
    required this.detail,
    required this.reading,
    required this.state,
    this.good = true,
  });

  final String label;
  final String detail;
  final String reading;
  final String state;
  final bool good;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(label, style: const TextStyle(fontSize: 12, color: SmartSitColors.muted)),
                  const SizedBox(height: 4),
                  Text(detail, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: SmartSitColors.text)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(reading, style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: good ? SmartSitColors.green : SmartSitColors.red)),
                const SizedBox(height: 2),
                Text(state, style: TextStyle(fontSize: 9, letterSpacing: .6, fontWeight: FontWeight.w900, color: good ? SmartSitColors.green : SmartSitColors.red)),
              ],
            ),
          ],
        ),
      );
}

class _DotGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = const Color(0xFFABB3B7).withValues(alpha: .5);
    for (double x = 12; x < size.width; x += 18) {
      for (double y = 12; y < size.height; y += 18) {
        canvas.drawCircle(Offset(x, y), .65, paint);
      }
    }
  }
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});
  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String period = 'Weekly';
  @override
  Widget build(BuildContext context) => SingleChildScrollView(
    padding: const EdgeInsets.all(16),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const PageIntro(title: 'Posture History', subtitle: 'Detailed biometric insights and long-term performance tracking of your spinal health.'),
      Wrap(spacing: 6, children: ['Daily', 'Weekly', 'Monthly', 'Custom'].map((p) => ChoiceChip(label: Text(p), selected: period == p, onSelected: (_) => setState(() => period = p), selectedColor: SmartSitColors.greenLight, labelStyle: TextStyle(fontSize: 12, color: period == p ? SmartSitColors.green : SmartSitColors.muted, fontWeight: FontWeight.w700))).toList()),
      const SizedBox(height: 14),
      responsiveCards(context, [
        const _HistorySummaryCard(title: 'Worst hour of day', value: '14:00–15:00', subtitle: 'Peak strain period detected', badge: '-18% quality', progress: .75, bad: true),
        const _HistorySummaryCard(title: 'Most consistent day', value: 'Wednesday', subtitle: 'Highest stability score', badge: '94% core score', progress: .94),
        const _HistorySummaryCard(title: 'Improvement trend', value: '+12.4%', subtitle: 'Compared with last week', badge: 'Positive', progress: .60),
      ], minWidth: 235, maxColumns: 3),
      const SizedBox(height: 12),
      responsiveSplitCards(context, [
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('POSTURE QUALITY TREND', style: TextStyle(fontSize: 10, color: SmartSitColors.softText, letterSpacing: 1, fontWeight: FontWeight.w900)),
          const SizedBox(height: 5),
          Text('$period performance', style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
          const SizedBox(height: 16),
          TrendChart(values: period == 'Daily' ? const [70, 80, 72, 90, 84, 94] : period == 'Monthly' ? const [62, 66, 71, 74, 82, 86, 91] : const [70, 75, 65, 85, 78, 90, 82], height: 190),
        ])),
        SurfaceCard(color: SmartSitColors.panel, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Correction Events'),
          const SizedBox(height: 5),
          const Text('Daily interventions per session', style: TextStyle(color: SmartSitColors.muted, fontSize: 11)),
          const SizedBox(height: 16),
          const _CorrectionEventsBars(),
          const Divider(height: 18),
          const InfoRow(label: 'Peak strain', value: '15:22 PM'),
          const InfoRow(label: 'Total daily average', value: '12.4 events'),
        ])),
       ], firstFlex: 2, secondFlex: 1),
      const SizedBox(height: 12),
      const SectionTitle('Timeline Insights'),
      const SizedBox(height: 10),
      responsiveSplitCards(context, [
        SurfaceCard(color: SmartSitColors.panel, child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const _HistoryEvent(title: 'SEVERE SLUMP', time: '10:45 AM', message: 'Sustained forward head posture detected during focus block.', duration: '3m 12s duration', bad: true),
          const SizedBox(height: 10),
          const _HistoryEvent(title: 'CORRECTION APPLIED', time: '11:02 AM', message: 'User corrected spinal alignment after alert.', duration: '', bad: false),
        ])),
        SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const SectionTitle('Posture sessions', trailing: StatusPill('3 SESSIONS')),
          const SizedBox(height: 12),
          const _SessionRow(time: 'Oct 24, 09:15 AM', subtitle: 'Morning session', duration: '2h 15m', score: '88%', status: 'OPTIMAL', good: true),
          const Divider(height: 1),
          const _SessionRow(time: 'Oct 24, 01:45 PM', subtitle: 'Afternoon session', duration: '3h 40m', score: '62%', status: 'WARNING', good: false),
          const Divider(height: 1),
          const _SessionRow(time: 'Oct 23, 10:05 AM', subtitle: 'Study session', duration: '1h 55m', score: '91%', status: 'OPTIMAL', good: true),
        ])),
       ], firstFlex: 1, secondFlex: 2),
    ]),
  );
}

class _CorrectionEventsBars extends StatelessWidget {
  const _CorrectionEventsBars();

  @override
  Widget build(BuildContext context) {
    const days = ['M', 'T', 'W', 'T', 'F'];
    const heights = [0.48, 0.72, 0.42, 0.95, 0.63];
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(days.length, (i) => Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FractionallySizedBox(
                      heightFactor: heights[i],
                      widthFactor: .72,
                      child: Container(
                        decoration: BoxDecoration(
                          color: const Color(0xFFDDE4E7),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        alignment: Alignment.bottomCenter,
                        child: FractionallySizedBox(
                          heightFactor: i == 3 ? .72 : .42,
                          widthFactor: 1,
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF9FA8AD),
                              borderRadius: BorderRadius.circular(40),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(days[i], style: const TextStyle(fontSize: 10, color: SmartSitColors.muted)),
              ],
            ),
          ),
        )),
      ),
    );
  }
}

class _HistoryEvent extends StatelessWidget {
  const _HistoryEvent({required this.title, required this.time, required this.message, required this.duration, required this.bad});
  final String title, time, message, duration;
  final bool bad;

  @override
  Widget build(BuildContext context) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 9,
            height: 9,
            margin: const EdgeInsets.only(top: 4),
            decoration: BoxDecoration(color: bad ? SmartSitColors.red : SmartSitColors.green, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [Expanded(child: Text(title, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: bad ? SmartSitColors.red : SmartSitColors.green))), Text(time, style: const TextStyle(fontSize: 10, color: SmartSitColors.muted))]),
                const SizedBox(height: 7),
                Text(message, style: const TextStyle(fontSize: 12, color: SmartSitColors.text, height: 1.4)),
                if (duration.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(duration, style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: bad ? SmartSitColors.red : SmartSitColors.green)),
                ],
              ]),
            ),
          ),
        ],
      );
}

class _HistorySummaryCard extends StatelessWidget {
  const _HistorySummaryCard({required this.title, required this.value, required this.subtitle, required this.badge, required this.progress, this.bad = false});
  final String title, value, subtitle, badge;
  final double progress;
  final bool bad;
  @override
  Widget build(BuildContext context) => SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Text(title, style: const TextStyle(color: SmartSitColors.muted, fontSize: 12, fontWeight: FontWeight.w600)),
    const SizedBox(height: 9),
    Text(value, style: const TextStyle(color: SmartSitColors.text, fontSize: 18, fontWeight: FontWeight.w900)),
    const SizedBox(height: 5),
    Text(badge, style: TextStyle(color: bad ? SmartSitColors.red : SmartSitColors.green, fontSize: 10, fontWeight: FontWeight.w800)),
    const SizedBox(height: 4),
    Text(subtitle, style: const TextStyle(color: SmartSitColors.muted, fontSize: 11)),
    const SizedBox(height: 13),
    SimpleProgressBar(value: progress, color: bad ? const Color(0xFFFD4E4D) : SmartSitColors.green),
  ]));
}

class _SessionRow extends StatelessWidget {
  const _SessionRow({required this.time, required this.subtitle, required this.duration, required this.score, required this.status, required this.good});
  final String time, subtitle, duration, score, status;
  final bool good;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(time, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13, color: SmartSitColors.text)), const SizedBox(height: 4), Text(subtitle, style: const TextStyle(fontSize: 11, color: SmartSitColors.muted))])), StatusPill(status, good: good)]),
    const SizedBox(height: 10),
    Row(children: [Expanded(child: InfoRow(label: 'Duration', value: duration)), const SizedBox(width: 14), Expanded(child: InfoRow(label: 'Average quality', value: score))]),
  ]));
}

class ReportsScreen extends StatelessWidget {
  const ReportsScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const PageIntro(title: 'Posture Reports', subtitle: 'Review summaries of your posture performance and prepare reports for your records.'),
    SurfaceCard(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Icon(Icons.description_outlined, color: Color(0xFF9AD6AC), size: 28),
      const SizedBox(height: 14),
      const Text('Your posture at a glance', style: TextStyle(fontSize: 21, fontWeight: FontWeight.w900, color: Colors.white)),
      const SizedBox(height: 7),
      const Text('Weekly summary • Oct 19 – Oct 25', style: TextStyle(color: Color(0xFFCCD2D4), fontSize: 12)),
      const SizedBox(height: 16),
      const Row(children: [Expanded(child: _ReportStat(value: '85%', label: 'Average score')), Expanded(child: _ReportStat(value: '18h 42m', label: 'Monitored')), Expanded(child: _ReportStat(value: '12', label: 'Alerts'))]),
      const SizedBox(height: 18),
      SizedBox(width: double.infinity, child: OutlinedButton.icon(onPressed: () => AppNotice.show(context, 'PDF export will be connected later.'), icon: const Icon(Icons.download_outlined), label: const Text('Generate PDF report'), style: OutlinedButton.styleFrom(foregroundColor: Colors.white, side: const BorderSide(color: Colors.white38)))),
    ]), padding: const EdgeInsets.all(20), color: SmartSitColors.ink, borderColor: SmartSitColors.ink),
    const SizedBox(height: 16),
    const SectionTitle('Available reports'),
    const SizedBox(height: 10),
    ...[
      ('Weekly posture summary', '7-day overview of posture score, active hours and alerts.', 'OCT 19–25', Icons.calendar_view_week_rounded),
      ('Monthly performance', 'Compare posture quality and improvement trends over time.', 'OCTOBER 2026', Icons.insert_chart_outlined_rounded),
      ('Session detail report', 'Review duration, average posture score and session events.', 'RECENT SESSIONS', Icons.history_rounded),
    ].map((report) => Padding(padding: const EdgeInsets.only(bottom: 10), child: SurfaceCard(child: Row(children: [Container(width: 46, height: 46, decoration: BoxDecoration(color: SmartSitColors.panel, borderRadius: BorderRadius.circular(12)), child: Icon(report.$4, color: SmartSitColors.green)), const SizedBox(width: 12), Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(report.$1, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: SmartSitColors.text)), const SizedBox(height: 4), Text(report.$2, style: const TextStyle(fontSize: 11, height: 1.4, color: SmartSitColors.muted)), const SizedBox(height: 6), Text(report.$3, style: const TextStyle(fontSize: 9, letterSpacing: .8, fontWeight: FontWeight.w900, color: SmartSitColors.softText))])), IconButton(onPressed: () => AppNotice.show(context, 'Report is a UI placeholder; PDF generation is not connected.'), icon: const Icon(Icons.download_outlined, color: SmartSitColors.green))])))),
    const SizedBox(height: 8),
    const Text('Note: this report screen is a UI prototype because the original web report page contains only placeholder text.', style: TextStyle(color: SmartSitColors.muted, fontSize: 11, height: 1.4)),
  ]));
}

class _ReportStat extends StatelessWidget {
  const _ReportStat({required this.value, required this.label});
  final String value, label;
  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.only(right: 5), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(label, style: const TextStyle(color: Color(0xFFCCD2D4), fontSize: 10))]));
}

class ExercisesScreen extends StatelessWidget {
  const ExercisesScreen({super.key});
  @override
  Widget build(BuildContext context) => SingleChildScrollView(padding: const EdgeInsets.all(16), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    const PageIntro(title: 'Back Relief & Posture Guide', subtitle: 'Simple stretches and posture tips to support a comfortable sitting routine.'),
    const SizedBox(height: 4),
    const SectionTitle('Relief Exercises'),
    const SizedBox(height: 10),
    responsiveCards(context, [
      const _ExerciseCard(title: 'Cat-Cow Stretch', desc: 'Improves spine flexibility and relieves tension.', asset: 'assets/exercises/cat_cow.webp', minutes: '2–3 min'),
      const _ExerciseCard(title: "Child’s Pose", desc: 'Gently stretches the lower back and relaxes muscles.', asset: 'assets/exercises/child_pose.webp', minutes: '1–2 min'),
      const _ExerciseCard(title: 'Bird Dog', desc: 'Strengthens the core and stabilizes the spine.', asset: 'assets/exercises/bird_dog.jpg', minutes: '8 reps'),
      const _ExerciseCard(title: 'Pelvic Tilt', desc: 'Helps align the spine and strengthen the lower back.', asset: 'assets/exercises/pelvic_tilt.gif', minutes: '10 reps'),
    ], minWidth: 235, maxColumns: 4),
    const SizedBox(height: 20),
    const SectionTitle('Correct Postures'),
    const SizedBox(height: 10),
    const _ExerciseCard(title: 'Neutral Spine Sitting', desc: 'Keep your back straight, shoulders relaxed and feet flat on the floor.', asset: 'assets/exercises/neutral_spine.jpg', minutes: 'Daily habit', wide: true),
    const SizedBox(height: 14),
    SurfaceCard(color: SmartSitColors.greenLight, borderColor: SmartSitColors.greenLight, child: const Row(crossAxisAlignment: CrossAxisAlignment.start, children: [Icon(Icons.info_outline, color: SmartSitColors.green), SizedBox(width: 10), Expanded(child: Text('Move gently and stop if a movement causes pain. These are general posture tips, not medical advice.', style: TextStyle(fontSize: 12, color: SmartSitColors.green, height: 1.45)))])),
  ]));
}

class _ExerciseCard extends StatelessWidget {
  const _ExerciseCard({required this.title, required this.desc, required this.asset, required this.minutes, this.wide = false});
  final String title, desc, asset, minutes;
  final bool wide;

  @override
  Widget build(BuildContext context) => SurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: SizedBox(
                height: wide ? 180 : 155,
                width: double.infinity,
                child: Image.asset(
                  asset,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: SmartSitColors.panel,
                    child: const Center(child: Icon(Icons.self_improvement_rounded, color: SmartSitColors.green, size: 48)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: SmartSitColors.text)),
                  const SizedBox(height: 7),
                  Text(desc, style: const TextStyle(fontSize: 12, height: 1.45, color: SmartSitColors.muted)),
                ],
              ),
            ),
          ],
        ),
      );
}

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({super.key});

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  bool _editing = false;
  final TextEditingController _name = TextEditingController(text: 'Sher Ghazi');
  final TextEditingController _email = TextEditingController(text: 'sherghazi@example.com');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageIntro(title: 'Settings', subtitle: 'Manage your account and preferences.'),
            SurfaceCard(
              padding: EdgeInsets.zero,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 82,
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(colors: [Color(0xFFE7F2EB), Color(0xFFF4F7F5)]),
                    ),
                    child: const Align(
                      alignment: Alignment.topRight,
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: Icon(Icons.person_outline_rounded, color: Color(0xFFB1C8B9), size: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
                    child: Transform.translate(
                      offset: const Offset(0, -27),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 74,
                            height: 74,
                            decoration: BoxDecoration(
                              color: SmartSitColors.green,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: Colors.white, width: 4),
                              boxShadow: const [BoxShadow(color: Color(0x120C0F10), blurRadius: 10, offset: Offset(0, 4))],
                            ),
                            alignment: Alignment.center,
                            child: const Text('SG', style: TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: Colors.white)),
                          ),
                          const SizedBox(height: 10),
                          LayoutBuilder(builder: (context, constraints) {
                            final editButton = OutlinedButton.icon(
                              onPressed: () {
                                if (_editing) {
                                  AppNotice.show(context, 'Profile changes are local UI preview only.');
                                }
                                setState(() => _editing = !_editing);
                              },
                              icon: Icon(_editing ? Icons.check_rounded : Icons.edit_outlined, size: 16),
                              label: Text(_editing ? 'Save' : 'Edit Profile'),
                            );
                            return constraints.maxWidth < 390
                                ? Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _profileFields(),
                                      const SizedBox(height: 10),
                                      editButton,
                                    ],
                                  )
                                : Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [Expanded(child: _profileFields()), editButton],
                                  );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            responsiveCards(
              context,
              const [
                SurfaceCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SettingsIconBox(icon: Icons.shield_outlined),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Account Status', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: SmartSitColors.text)),
                            SizedBox(height: 7),
                            Text('Your account is secure and active', style: TextStyle(fontSize: 12, color: SmartSitColors.muted, height: 1.4)),
                            SizedBox(height: 10),
                            StatusPill('ACTIVE'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SurfaceCard(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SettingsIconBox(icon: Icons.person_outline_rounded),
                      SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('User Role', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: SmartSitColors.text)),
                            SizedBox(height: 7),
                            Text('Your account permissions and access level', style: TextStyle(fontSize: 12, color: SmartSitColors.muted, height: 1.4)),
                            SizedBox(height: 10),
                            StatusPill('DEVELOPER'),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              minWidth: 270,
              maxColumns: 2,
            ),
            const SizedBox(height: 14),
            SurfaceCard(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SectionTitle('Account Information'),
                  const SizedBox(height: 8),
                  _AccountInfoRow(label: 'Full Name', value: _name.text),
                  _AccountInfoRow(label: 'Email Address', value: _email.text),
                  const _AccountInfoRow(label: 'Account Type', value: 'Premium User'),
                  const _AccountInfoRow(label: 'Member Since', value: 'January 15, 2024'),
                ],
              ),
            ),
            const SizedBox(height: 14),
            SurfaceCard(
              borderColor: const Color(0xFFF5D0D0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(children: [Icon(Icons.logout_rounded, color: SmartSitColors.red), SizedBox(width: 10), Text('Logout', style: TextStyle(color: SmartSitColors.red, fontWeight: FontWeight.w900, fontSize: 16))]),
                  const SizedBox(height: 6),
                  const Text('You will need to sign in again to access your dashboard. Make sure you have saved your work.', style: TextStyle(color: SmartSitColors.muted, fontSize: 12, height: 1.45)),
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
                    icon: const Icon(Icons.logout_rounded),
                    label: const Text('Logout Now'),
                    style: OutlinedButton.styleFrom(foregroundColor: SmartSitColors.red, side: const BorderSide(color: Color(0xFFF5D0D0))),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _profileFields() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_editing)
            TextField(controller: _name, decoration: const InputDecoration(labelText: 'Full Name'))
          else
            Text(_name.text, style: const TextStyle(fontSize: 25, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
          const SizedBox(height: 5),
          if (_editing)
            TextField(controller: _email, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email Address'))
          else
            Row(
              children: [
                const Icon(Icons.mail_outline_rounded, size: 15, color: SmartSitColors.muted),
                const SizedBox(width: 6),
                Expanded(child: Text(_email.text, style: const TextStyle(fontSize: 12, color: SmartSitColors.muted), overflow: TextOverflow.ellipsis)),
              ],
            ),
        ],
      );
}

class _SettingsIconBox extends StatelessWidget {
  const _SettingsIconBox({required this.icon});
  final IconData icon;

  @override
  Widget build(BuildContext context) => Container(
        width: 46,
        height: 46,
        decoration: BoxDecoration(color: SmartSitColors.greenLight, borderRadius: BorderRadius.circular(13)),
        child: Icon(icon, color: SmartSitColors.green, size: 23),
      );
}

class _AccountInfoRow extends StatelessWidget {
  const _AccountInfoRow({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 12, color: SmartSitColors.muted)),
            const SizedBox(height: 7),
            Text(value, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: SmartSitColors.text)),
            const SizedBox(height: 13),
            const Divider(height: 1),
          ],
        ),
      );
}

