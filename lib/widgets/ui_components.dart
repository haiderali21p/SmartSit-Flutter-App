import 'package:flutter/material.dart';
import '../app/smartsit_theme.dart';

class SmartSitLogo extends StatelessWidget {
  const SmartSitLogo({super.key, this.dark = false, this.compact = false});
  final bool dark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    // The reference web UI uses a typographic wordmark rather than a boxed icon.
    return Text(
      compact ? 'SmartSit' : 'SmartSit AI',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: compact ? 20 : 22,
        color: dark ? Colors.white : const Color(0xFF0F172A),
        fontWeight: FontWeight.w900,
        letterSpacing: -0.8,
        height: 1.05,
      ),
    );
  }
}

class PageIntro extends StatelessWidget {
  const PageIntro({super.key, required this.title, required this.subtitle, this.trailing});
  final String title;
  final String subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final titleSize = width < 380 ? 23.0 : (width < 600 ? 25.0 : 29.0);
    final heading = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: titleSize,
            height: 1.12,
            fontWeight: FontWeight.w900,
            letterSpacing: -0.7,
            color: SmartSitColors.text,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          subtitle,
          style: const TextStyle(color: SmartSitColors.muted, fontSize: 13, height: 1.45),
        ),
      ],
    );

    return Padding(
      padding: const EdgeInsets.only(bottom: 18),
      child: LayoutBuilder(builder: (context, constraints) {
        if (trailing == null) return heading;
        if (constraints.maxWidth < 520) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [heading, const SizedBox(height: 10), trailing!],
          );
        }
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [Expanded(child: heading), const SizedBox(width: 8), trailing!],
        );
      }),
    );
  }
}

class SurfaceCard extends StatelessWidget {
  const SurfaceCard({super.key, required this.child, this.padding = const EdgeInsets.all(16), this.color = SmartSitColors.white, this.borderColor = SmartSitColors.border});
  final Widget child;
  final EdgeInsetsGeometry padding;
  final Color color;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: padding,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: const [BoxShadow(color: Color(0x080C0F10), blurRadius: 18, offset: Offset(0, 5))],
      ),
      child: child,
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.trailing});
  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: Text(title, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: SmartSitColors.text))),
      if (trailing != null) trailing!,
    ]);
  }
}

class StatusPill extends StatelessWidget {
  const StatusPill(this.label, {super.key, this.good = true, this.icon});
  final String label;
  final bool good;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final color = good ? SmartSitColors.green : SmartSitColors.red;
    final bg = good ? SmartSitColors.greenLight : SmartSitColors.redLight;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(100)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon ?? (good ? Icons.check_circle_rounded : Icons.warning_rounded), size: 13, color: color),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
      ]),
    );
  }
}

class MetricTile extends StatelessWidget {
  const MetricTile({super.key, required this.label, required this.value, required this.icon, this.note, this.good = true, this.accent = SmartSitColors.green});
  final String label;
  final String value;
  final IconData icon;
  final String? note;
  final bool good;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return SurfaceCard(
      color: SmartSitColors.panel,
      borderColor: SmartSitColors.panel,
      padding: const EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 10,
                    height: 1.25,
                    letterSpacing: .65,
                    fontWeight: FontWeight.w900,
                    color: SmartSitColors.softText,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 30,
                height: 30,
                decoration: const BoxDecoration(
                  color: Color(0xFFE2E8F0),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 15, color: accent.withValues(alpha: .7)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              fontSize: 22,
              height: 1.1,
              fontWeight: FontWeight.w900,
              letterSpacing: -.5,
              color: SmartSitColors.text,
            ),
          ),
          if (note != null) ...[
            const SizedBox(height: 5),
            Text(
              note!,
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: good ? SmartSitColors.green : SmartSitColors.red,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class ScoreRing extends StatelessWidget {
  const ScoreRing({super.key, required this.score, this.size = 132, this.label = 'OF 100'});
  final int score;
  final double size;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(alignment: Alignment.center, children: [
        SizedBox(
          width: size,
          height: size,
          child: CircularProgressIndicator(value: score / 100, strokeWidth: size * .075, backgroundColor: const Color(0xFFEAEFF1), valueColor: const AlwaysStoppedAnimation(SmartSitColors.green), strokeCap: StrokeCap.round),
        ),
        Column(mainAxisSize: MainAxisSize.min, children: [
          Text('$score', style: TextStyle(fontSize: size * .27, height: 1, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
          const SizedBox(height: 5),
          Text(label, style: TextStyle(fontSize: size * .075, fontWeight: FontWeight.w700, color: SmartSitColors.softText, letterSpacing: .5)),
        ]),
      ]),
    );
  }
}

class TrendChart extends StatelessWidget {
  const TrendChart({super.key, this.values = const [70, 75, 65, 85, 78, 90, 82], this.labels = const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'], this.height = 150});
  final List<double> values;
  final List<String> labels;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: CustomPaint(painter: _TrendChartPainter(values: values, labels: labels)),
    );
  }
}

class _TrendChartPainter extends CustomPainter {
  _TrendChartPainter({required this.values, required this.labels});
  final List<double> values;
  final List<String> labels;

  @override
  void paint(Canvas canvas, Size size) {
    const left = 8.0;
    const right = 8.0;
    const top = 10.0;
    const bottom = 24.0;
    final chart = Rect.fromLTRB(left, top, size.width - right, size.height - bottom);
    final gridPaint = Paint()..color = SmartSitColors.border..strokeWidth = 1;
    for (var i = 0; i < 4; i++) {
      final y = chart.top + chart.height * i / 3;
      canvas.drawLine(Offset(chart.left, y), Offset(chart.right, y), gridPaint);
    }
    if (values.isEmpty) return;
    final points = <Offset>[];
    for (var i = 0; i < values.length; i++) {
      final x = chart.left + chart.width * (values.length == 1 ? 0 : i / (values.length - 1));
      final y = chart.bottom - chart.height * ((values[i] - 45) / 55).clamp(0.0, 1.0).toDouble();
      points.add(Offset(x, y));
    }
    final line = Path()..moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final cur = points[i];
      final mid = (prev.dx + cur.dx) / 2;
      line.cubicTo(mid, prev.dy, mid, cur.dy, cur.dx, cur.dy);
    }
    final fill = Path.from(line)..lineTo(points.last.dx, chart.bottom)..lineTo(points.first.dx, chart.bottom)..close();
    canvas.drawPath(fill, Paint()..shader = LinearGradient(colors: [SmartSitColors.green.withValues(alpha: .20), SmartSitColors.green.withValues(alpha: .01)], begin: Alignment.topCenter, end: Alignment.bottomCenter).createShader(chart));
    canvas.drawPath(line, Paint()..color = SmartSitColors.green..style = PaintingStyle.stroke..strokeWidth = 2.6..strokeCap = StrokeCap.round);
    for (final point in points) {
      canvas.drawCircle(point, 3.1, Paint()..color = SmartSitColors.white);
      canvas.drawCircle(point, 2.2, Paint()..color = SmartSitColors.green);
    }
    final textStyle = const TextStyle(fontSize: 9, color: SmartSitColors.softText, fontWeight: FontWeight.w500);
    for (var i = 0; i < labels.length && i < points.length; i++) {
      final tp = TextPainter(text: TextSpan(text: labels[i], style: textStyle), textDirection: TextDirection.ltr)..layout();
      tp.paint(canvas, Offset(points[i].dx - tp.width / 2, size.height - 17));
    }
  }

  @override
  bool shouldRepaint(covariant _TrendChartPainter oldDelegate) => oldDelegate.values != values || oldDelegate.labels != labels;
}

class BarChartMini extends StatelessWidget {
  const BarChartMini({super.key, this.values = const [60, 82, 68, 92, 72, 86, 77], this.labels = const ['M', 'T', 'W', 'T', 'F', 'S', 'S']});
  final List<double> values;
  final List<String> labels;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: Row(crossAxisAlignment: CrossAxisAlignment.end, children: List.generate(values.length, (i) {
        return Expanded(child: Padding(padding: const EdgeInsets.symmetric(horizontal: 4), child: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          Expanded(child: Align(alignment: Alignment.bottomCenter, child: FractionallySizedBox(heightFactor: values[i] / 100, widthFactor: .72, child: Container(decoration: BoxDecoration(color: i == 3 ? SmartSitColors.green : const Color(0xFFB8D9C3), borderRadius: const BorderRadius.vertical(top: Radius.circular(5))))))),
          const SizedBox(height: 7),
          Text(labels[i], style: const TextStyle(fontSize: 10, color: SmartSitColors.softText)),
        ])));
      })),
    );
  }
}

class PrimaryAction extends StatelessWidget {
  const PrimaryAction({super.key, required this.label, required this.onPressed, this.icon});
  final String label;
  final VoidCallback onPressed;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: onPressed, icon: Icon(icon ?? Icons.arrow_forward_rounded, size: 18), label: Text(label)));
  }
}

class PostureSpineIllustration extends StatelessWidget {
  const PostureSpineIllustration({super.key, this.compact = false});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final widths = [20.0, 24.0, 26.0, 24.0, 28.0, 30.0, 26.0, 24.0, 21.0, 18.0];
    return Column(mainAxisSize: MainAxisSize.min, children: List.generate(widths.length, (i) {
      final w = compact ? widths[i] * .75 : widths[i];
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 2),
        width: w,
        height: compact ? 7 : 9,
        decoration: BoxDecoration(color: i == 5 ? const Color(0xFF9EB8AA) : SmartSitColors.green, borderRadius: BorderRadius.circular(99)),
      );
    }));
  }
}

class HeatmapVisual extends StatelessWidget {
  const HeatmapVisual({super.key, this.size = 175});
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * .84,
            height: size * .82,
            decoration: BoxDecoration(
              color: const Color(0xFFE6ECEB),
              borderRadius: BorderRadius.circular(size * .22),
              border: Border.all(color: const Color(0xFFD2DEDA), width: 1.5),
            ),
          ),
          Container(
            width: size * .68,
            height: size * .66,
            decoration: BoxDecoration(
              color: const Color(0xFFE2EBE6),
              borderRadius: BorderRadius.circular(size * .19),
              border: Border.all(color: const Color(0xFFC8D8D0), width: 1.2),
            ),
          ),
          Positioned(
            top: size * .25,
            left: size * .24,
            child: _heatSpot(size * .44, SmartSitColors.green),
          ),
          Positioned(
            top: size * .25,
            right: size * .24,
            child: _heatSpot(size * .44, const Color(0xFF55A66F)),
          ),
          Positioned(
            bottom: size * .21,
            left: size * .35,
            child: _heatSpot(size * .30, const Color(0xFF9BCFA9)),
          ),
        ],
      ),
    );
  }

  Widget _heatSpot(double s, Color color) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: RadialGradient(
            colors: [
              color.withValues(alpha: .88),
              color.withValues(alpha: .52),
              color.withValues(alpha: .05),
            ],
          ),
        ),
      );
}

class InfoRow extends StatelessWidget {
  const InfoRow({super.key, required this.label, required this.value, this.icon});
  final String label;
  final String value;
  final IconData? icon;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 9),
    child: Row(children: [
      if (icon != null) ...[Icon(icon, size: 18, color: SmartSitColors.muted), const SizedBox(width: 10)],
      Expanded(child: Text(label, style: const TextStyle(fontSize: 13, color: SmartSitColors.muted))),
      Text(value, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: SmartSitColors.text)),
    ]),
  );
}

class AppNotice {
  static void show(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message), behavior: SnackBarBehavior.floating, backgroundColor: SmartSitColors.text));
  }
}

class SimpleProgressBar extends StatelessWidget {
  const SimpleProgressBar({super.key, required this.value, this.color = SmartSitColors.green, this.height = 6});
  final double value;
  final Color color;
  final double height;

  @override
  Widget build(BuildContext context) => ClipRRect(
    borderRadius: BorderRadius.circular(99),
    child: LinearProgressIndicator(value: value.clamp(0, 1).toDouble(), minHeight: height, backgroundColor: SmartSitColors.border, color: color),
  );
}

class TinyStat extends StatelessWidget {
  const TinyStat({super.key, required this.label, required this.value, required this.icon, this.tint = SmartSitColors.green});
  final String label;
  final String value;
  final IconData icon;
  final Color tint;
  @override
  Widget build(BuildContext context) => Row(children: [
    Container(width: 38, height: 38, decoration: BoxDecoration(color: tint.withValues(alpha: .10), borderRadius: BorderRadius.circular(11)), child: Icon(icon, color: tint, size: 20)),
    const SizedBox(width: 11),
    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(value, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 16, color: SmartSitColors.text)), const SizedBox(height: 2), Text(label, style: const TextStyle(fontSize: 11, color: SmartSitColors.muted))])),
  ]);
}
