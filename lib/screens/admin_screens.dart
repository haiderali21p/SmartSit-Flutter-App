import 'package:flutter/material.dart';
import '../app/smartsit_theme.dart';
import '../widgets/ui_components.dart';
import 'user_screens.dart' show responsiveCards;

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});
  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  final _search = TextEditingController();
  String roleFilter = 'All';
  String statusFilter = 'All';
  int page = 1;

  final users = const [
    _UserRecord('Sher Ghazi', 'ghazi@clinicalcare.com', 'Admin', 'Active', 'Oct 12, 2023', 'SG'),
    _UserRecord('Abdullah', 'adullah@healthmail.org', 'User', 'Active', 'Jan 05, 2024', 'AA'),
    _UserRecord('Shuja', 'shuja@example.com', 'User', 'Blocked', 'Feb 14, 2024', 'SS'),
    _UserRecord('Arham', 'arham@example.com', 'User', 'Active', 'Mar 22, 2024', 'AA'),
    _UserRecord('Bilal', 'bilal@smartsit-clinical.org', 'Admin', 'Active', 'Apr 11, 2024', 'BB'),
    _UserRecord('Nadia Hassan', 'nadia.h@example.com', 'User', 'Active', 'Jun 30, 2024', 'NH'),
    _UserRecord('Saqlain', 'saqlain@example.com', 'User', 'Blocked', 'Aug 18, 2024', 'SQ'),
    _UserRecord('Zain', 'zain@example.com', 'User', 'Active', 'Sep 02, 2024', 'SZ'),
  ];

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  Widget _avatarFor(_UserRecord user) {
    final fallback = CircleAvatar(
      backgroundColor: SmartSitColors.greenLight,
      foregroundColor: SmartSitColors.green,
      child: Text(user.initials, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
    );
    final image = user.avatarUrl == null
        ? fallback
        : Image.network(user.avatarUrl!, fit: BoxFit.cover, errorBuilder: (_, __, ___) => fallback);
    return ClipOval(child: SizedBox(width: 38, height: 38, child: image));
  }

  @override
  Widget build(BuildContext context) {
    final visible = users.where((u) =>
      (u.name.toLowerCase().contains(_search.text.toLowerCase()) || u.email.toLowerCase().contains(_search.text.toLowerCase())) &&
      (roleFilter == 'All' || u.role == roleFilter) &&
      (statusFilter == 'All' || u.status == statusFilter),
    ).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PageIntro(
            title: 'User Management',
            subtitle: 'Oversee platform access, monitor user engagement, and manage clinical permissions.',
            trailing: FilledButton.tonalIcon(
              onPressed: () => AppNotice.show(context, 'CSV export is a UI preview; no file is generated yet.'),
              icon: const Icon(Icons.download_outlined, size: 17),
              label: const Text('Download PDF'),
            ),
          ),
          SurfaceCard(
            color: SmartSitColors.white,
            padding: const EdgeInsets.all(12),
            child: LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth >= 680;
              final fields = <Widget>[
                TextField(
                  controller: _search,
                  onChanged: (_) => setState(() => page = 1),
                  decoration: const InputDecoration(prefixIcon: Icon(Icons.person_search_rounded), hintText: 'Filter by name or email...', filled: true, fillColor: SmartSitColors.panel),
                ),
                _DropdownFilter(label: 'Role', value: roleFilter, values: const ['All', 'Admin', 'User'], onChanged: (v) => setState(() => roleFilter = v)),
                _DropdownFilter(label: 'Status', value: statusFilter, values: const ['All', 'Active', 'Blocked'], onChanged: (v) => setState(() => statusFilter = v)),
              ];
              if (wide) {
                return Row(children: [
                  Expanded(flex: 5, child: fields[0]),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: fields[1]),
                  const SizedBox(width: 10),
                  Expanded(flex: 2, child: fields[2]),
                  const SizedBox(width: 14),
                  Text('Displaying ${visible.length} of 2,450 users', style: const TextStyle(fontSize: 11, color: SmartSitColors.muted)),
                ]);
              }
              return Column(children: [
                fields[0],
                const SizedBox(height: 9),
                Row(children: [Expanded(child: fields[1]), const SizedBox(width: 9), Expanded(child: fields[2])]),
                const SizedBox(height: 10),
                Align(alignment: Alignment.centerLeft, child: Text('Displaying ${visible.length} of 2,450 users', style: const TextStyle(fontSize: 11, color: SmartSitColors.muted))),
              ]);
            }),
          ),
          const SizedBox(height: 14),
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth >= 840) {
              return SurfaceCard(
                padding: EdgeInsets.zero,
                child: Column(children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(SmartSitColors.panel),
                      columnSpacing: 24,
                      columns: const [
                        DataColumn(label: Text('USER PROFILE')),
                        DataColumn(label: Text('EMAIL')),
                        DataColumn(label: Text('ROLE')),
                        DataColumn(label: Text('STATUS')),
                        DataColumn(label: Text('JOINED')),
                        DataColumn(label: Text('ACTIONS')),
                      ],
                      rows: visible.map((user) => DataRow(cells: [
                        DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                          _avatarFor(user),
                          const SizedBox(width: 9),
                          Text(user.name, style: const TextStyle(fontWeight: FontWeight.w700, color: SmartSitColors.text)),
                        ])),
                        DataCell(Text(user.email, style: const TextStyle(color: SmartSitColors.muted, fontSize: 12))),
                        DataCell(StatusPill(user.role.toUpperCase(), good: user.role == 'Admin')),
                        DataCell(Row(mainAxisSize: MainAxisSize.min, children: [
                          Icon(Icons.circle, size: 8, color: user.status == 'Active' ? SmartSitColors.green : SmartSitColors.red),
                          const SizedBox(width: 6),
                          Text(user.status, style: TextStyle(color: user.status == 'Active' ? SmartSitColors.green : SmartSitColors.red, fontSize: 12, fontWeight: FontWeight.w700)),
                        ])),
                        DataCell(Text(user.joined, style: const TextStyle(fontSize: 12, color: SmartSitColors.muted))),
                        DataCell(PopupMenuButton<String>(
                          onSelected: (v) => AppNotice.show(context, '$v is demo-only.'),
                          itemBuilder: (_) => const [PopupMenuItem(value: 'View user', child: Text('View user')), PopupMenuItem(value: 'Change status', child: Text('Change status')), PopupMenuItem(value: 'Delete user', child: Text('Delete user'))],
                        )),
                      ])).toList(),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
                    child: Row(children: [
                      Expanded(child: Text('Showing 1–${visible.length} of 2,450', style: const TextStyle(fontSize: 11, color: SmartSitColors.muted))),
                      OutlinedButton(onPressed: () => setState(() => page = 1), child: const Text('Prev')),
                      const SizedBox(width: 6),
                      FilledButton(onPressed: () => setState(() => page = 1), child: const Text('1')),
                      const SizedBox(width: 6),
                      OutlinedButton(onPressed: () => AppNotice.show(context, 'Page 2 is a demo control.'), child: const Text('2')),
                      const SizedBox(width: 6),
                      OutlinedButton(onPressed: () => AppNotice.show(context, 'Next page is a demo control.'), child: const Text('Next')),
                    ]),
                  ),
                ]),
              );
            }

            return Column(children: visible.map((user) => Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: SurfaceCard(child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    _avatarFor(user),
                    const SizedBox(width: 11),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Text(user.name, style: const TextStyle(fontWeight: FontWeight.w900, color: SmartSitColors.text)),
                      const SizedBox(height: 3),
                      Text(user.email, style: const TextStyle(color: SmartSitColors.muted, fontSize: 11), overflow: TextOverflow.ellipsis),
                    ])),
                    PopupMenuButton<String>(
                      onSelected: (v) => AppNotice.show(context, '$v is demo-only.'),
                      itemBuilder: (_) => const [PopupMenuItem(value: 'View user', child: Text('View user')), PopupMenuItem(value: 'Change status', child: Text('Change status')), PopupMenuItem(value: 'Delete user', child: Text('Delete user'))],
                    ),
                  ]),
                  const Divider(height: 22),
                  Row(children: [
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('ROLE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: SmartSitColors.softText, letterSpacing: .8)), const SizedBox(height: 4), Text(user.role, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700))])),
                    Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [const Text('JOINED', style: TextStyle(fontSize: 9, fontWeight: FontWeight.w900, color: SmartSitColors.softText, letterSpacing: .8)), const SizedBox(height: 4), Text(user.joined, style: const TextStyle(fontSize: 12, color: SmartSitColors.muted))])),
                    StatusPill(user.status.toUpperCase(), good: user.status == 'Active'),
                  ]),
                ],
              )),
            )).toList());
          }),
          const SizedBox(height: 8),
          const Text('Sample UI data only. Role permissions and account actions require backend enforcement.', style: TextStyle(color: SmartSitColors.muted, fontSize: 11)),
        ],
      ),
    );
  }
}

class _UserRecord {
  const _UserRecord(this.name, this.email, this.role, this.status, this.joined, this.initials, {this.avatarUrl});
  final String name, email, role, status, joined, initials;
  final String? avatarUrl;
}

class _DropdownFilter extends StatelessWidget {
  const _DropdownFilter({required this.label, required this.value, required this.values, required this.onChanged});
  final String label, value;
  final List<String> values;
  final ValueChanged<String> onChanged;
  @override
  Widget build(BuildContext context) => DropdownButtonFormField<String>(value: value, isExpanded: true, decoration: InputDecoration(labelText: label, contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11), fillColor: Colors.white), items: values.map((v) => DropdownMenuItem(value: v, child: Text(v))).toList(), onChanged: (v) { if (v != null) onChanged(v); });
}

class AdminProductsScreen extends StatelessWidget {
  const AdminProductsScreen({super.key});

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(builder: (context, constraints) {
              final actions = Wrap(
                spacing: 9,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => AppNotice.show(context, 'Export is a UI preview; no file is generated.'),
                    icon: const Icon(Icons.download_outlined, size: 18),
                    label: const Text('Export'),
                  ),
                  FilledButton.icon(
                    onPressed: () => AppNotice.show(context, 'Add Product form will be connected later.'),
                    icon: const Icon(Icons.add_rounded, size: 18),
                    label: const Text('Add Product'),
                  ),
                ],
              );
              final title = const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('INVENTORY MANAGEMENT', style: TextStyle(color: SmartSitColors.muted, fontSize: 10, fontWeight: FontWeight.w900, letterSpacing: 1.5)),
                  SizedBox(height: 4),
                  Text('Product Catalog', style: TextStyle(color: SmartSitColors.text, fontSize: 30, height: 1.12, fontWeight: FontWeight.w900, letterSpacing: -.8)),
                ],
              );
              if (constraints.maxWidth >= 670) {
                return Row(crossAxisAlignment: CrossAxisAlignment.end, children: [Expanded(child: title), actions]);
              }
              return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [title, const SizedBox(height: 12), actions]);
            }),
            const SizedBox(height: 16),
            SurfaceCard(
              padding: const EdgeInsets.all(12),
              child: LayoutBuilder(builder: (context, constraints) {
                final filters = Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: const [
                    _ProductFilterButton(label: 'All Categories', icon: Icons.filter_list_rounded),
                    _ProductFilterButton(label: 'Stock: All', icon: Icons.keyboard_arrow_down_rounded),
                    _ProductFilterButton(label: 'Price Range', icon: Icons.keyboard_arrow_down_rounded),
                  ],
                );
                if (constraints.maxWidth > 720) {
                  return Row(children: [Expanded(child: filters), const Text('Showing 12 Products', style: TextStyle(fontSize: 11, color: SmartSitColors.muted))]);
                }
                return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  filters,
                  const SizedBox(height: 9),
                  const Align(alignment: Alignment.centerRight, child: Text('Showing 12 Products', style: TextStyle(fontSize: 11, color: SmartSitColors.muted))),
                ]);
              }),
            ),
            const SizedBox(height: 14),
            responsiveCards(
              context,
              const [
                _ProductCard(
                  name: 'SmartSit AI Pro',
                  category: 'Clinical Series',
                  price: '\$299',
                  sku: 'SS-PRO-01',
                  stock: 32,
                  status: 'IN STOCK',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuArmJ-1tn59sb-ZZSMaAaH5V3KA9HnN5oS-7gvBlPQV0-0EuBx4OD9mPBlRDPEq0OSKSZ7W_i96_GgIw6HreQtDH7mA2ebnq7XRUQZYkWk3uANyBjJOlpoIfxZp5Q4B039G-1vAcTZZMkyRwxhi2gFFoGq472jLR8YTBv9JKhKx8SEWrXqJDEXjCiJ8G873OLFkz5GgERudi39Tms_EqNq4V0kWmAUtjF_uHtW4j282KOqgHv_ozoZG2TdyGD9TieaRR4RiSfy2iaQ',
                ),
                _ProductCard(
                  name: 'Basic Sensor Pad',
                  category: 'Accessories',
                  price: '\$129',
                  sku: 'SS-BS-09',
                  stock: 5,
                  status: 'LOW STOCK',
                  imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBZ2VOLqHtmQQJ6fQcerfNMWL8qRW-MI3n-YCOmyrWJd7p1gmFzFKUd47RsAevy2mGCkmnPh6zgqla2SlVGdpnHzYEnritTCeUIsKakG2GLaqrp-7DAQQxIqKUE_MhtmLr0c7IGpx8XDn-GMcBfVG_BFs1LntW0uVzDWFZCAxcrTQeK_09aYVm1nV9R_r9SfkbcHd9cexgWrzLsptS9Gi74VSz7YU0qEvbTMKpi4EVJDyGVr9XfzeZH7e6xl-e6SlzAVfjd6r5pRbo',
                ),
              ],
              minWidth: 250,
              maxColumns: 2,
            ),
          ],
        ),
      );
}

class _ProductFilterButton extends StatelessWidget {
  const _ProductFilterButton({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => OutlinedButton.icon(
        onPressed: () => AppNotice.show(context, '$label is a visual filter only at this stage.'),
        icon: Icon(icon, size: 16),
        label: Text(label),
      );
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.name,
    required this.category,
    required this.price,
    required this.sku,
    required this.stock,
    required this.status,
    required this.imageUrl,
  });

  final String name, category, price, sku, status, imageUrl;
  final int stock;

  @override
  Widget build(BuildContext context) => SurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LayoutBuilder(builder: (context, constraints) => SizedBox(
              height: constraints.maxWidth >= 420 ? 205 : 155,
              width: double.infinity,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Color(0xFF1C2924), Color(0xFF0C0F10)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.chair_alt_rounded, color: Color(0xFFB9C7BF), size: 58),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 12,
                    left: 12,
                    child: StatusPill(status, good: status == 'IN STOCK'),
                  ),
                ],
              ),
            )),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(category.toUpperCase(), style: const TextStyle(color: SmartSitColors.softText, fontSize: 9, letterSpacing: 1.1, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(name, style: const TextStyle(color: SmartSitColors.text, fontSize: 17, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(price, style: const TextStyle(color: SmartSitColors.text, fontSize: 19, fontWeight: FontWeight.w900)),
                  const SizedBox(height: 12),
                  const Divider(height: 1),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Icon(Icons.circle, size: 9, color: status == 'IN STOCK' ? SmartSitColors.green : SmartSitColors.red),
                      const SizedBox(width: 6),
                      Expanded(child: Text('$stock units left', style: const TextStyle(fontSize: 11, color: SmartSitColors.muted))),
                      Text('SKU: $sku', style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: SmartSitColors.muted)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class AdminSupportScreen extends StatefulWidget {
  const AdminSupportScreen({super.key});
  @override
  State<AdminSupportScreen> createState() => _AdminSupportScreenState();
}

class _AdminSupportScreenState extends State<AdminSupportScreen> {
  int active = 0;
  final _reply = TextEditingController();
  final _tickets = const [
    _Ticket('TK-4092', 'Calibration error in lumbar sensor', 'Marcus Thorne', '2h ago', 'PENDING', ['Hello support team. The lumbar sensor is showing a calibration error.', 'Please update your app to the latest version. This should fix the calibration issue.']),
    _Ticket('TK-4088', 'Payment failure on Pro subscription', 'Elena Rodriguez', '5h ago', 'RESOLVED', ['My payment did not complete.', 'The payment issue has been resolved.']),
    _Ticket('TK-4085', 'App crashing on Android 14', 'Julian Vane', '8h ago', 'PENDING', ['The app closes when I open monitoring.', 'We are reviewing the report.']),
  ];

  @override
  void dispose() {
    _reply.dispose();
    super.dispose();
  }

  Widget _ticketCard(int index, {bool horizontal = false}) {
    final ticket = _tickets[index];
    return SizedBox(
      width: horizontal ? 260 : double.infinity,
      child: Padding(
        padding: EdgeInsets.only(right: horizontal ? 10 : 0, bottom: horizontal ? 0 : 9),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: () => setState(() => active = index),
          child: SurfaceCard(
            color: active == index ? const Color(0xFFF0F5F1) : Colors.white,
            borderColor: active == index ? const Color(0xFFB8D9C3) : SmartSitColors.border,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Text('#${ticket.id}', style: const TextStyle(fontSize: 10, color: SmartSitColors.muted, fontWeight: FontWeight.w800)),
                  const Spacer(),
                  StatusPill(ticket.status, good: ticket.status == 'RESOLVED'),
                ]),
                const SizedBox(height: 8),
                Text(ticket.title, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: SmartSitColors.text), maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 5),
                Text('${ticket.user} • ${ticket.time}', style: const TextStyle(fontSize: 11, color: SmartSitColors.muted)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _conversation(_Ticket ticket) => SurfaceCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Wrap(
                    spacing: 7,
                    runSpacing: 7,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      Text('#${ticket.id}', style: const TextStyle(fontSize: 10, color: SmartSitColors.muted, fontWeight: FontWeight.w800)),
                      const Icon(Icons.circle, size: 7, color: SmartSitColors.red),
                      Text(ticket.status == 'PENDING' ? 'Priority: High' : 'Priority: Normal', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: ticket.status == 'PENDING' ? SmartSitColors.red : SmartSitColors.green)),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Text(ticket.title, style: const TextStyle(fontSize: 19, height: 1.2, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
                  const SizedBox(height: 11),
                  Wrap(spacing: 8, runSpacing: 8, children: const [
                    StatusPill('HARDWARE', good: false, icon: Icons.memory_rounded),
                    StatusPill('OPENED 2H AGO', good: false, icon: Icons.history_rounded),
                  ]),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () => AppNotice.show(context, 'Ticket status change is a visual preview.'),
                      icon: const Icon(Icons.check_circle_outline_rounded, size: 17),
                      label: const Text('Resolve Ticket'),
                      style: FilledButton.styleFrom(backgroundColor: SmartSitColors.green),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Container(
              width: double.infinity,
              color: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.all(15),
              child: Column(
                children: [
                  _ChatBubble(name: ticket.user, message: ticket.messages.first, mine: false, time: '10:42 AM'),
                  const SizedBox(height: 16),
                  _ChatBubble(name: 'Dr. Sarah Chen (Admin)', message: ticket.messages.last, mine: true, time: '11:05 AM'),
                ],
              ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  TextField(controller: _reply, minLines: 2, maxLines: 4, decoration: const InputDecoration(hintText: 'Type your reply here...', filled: true, fillColor: Colors.white)),
                  const SizedBox(height: 9),
                  Align(
                    alignment: Alignment.centerRight,
                    child: FilledButton.icon(
                      onPressed: () {
                        if (_reply.text.trim().isEmpty) {
                          AppNotice.show(context, 'Enter a reply first.');
                        } else {
                          AppNotice.show(context, 'Reply is not sent; backend is not connected.');
                          _reply.clear();
                        }
                      },
                      icon: const Icon(Icons.send_rounded, size: 16),
                      label: const Text('Send Reply'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    final ticket = _tickets[active];
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const PageIntro(title: 'Customer Support', subtitle: 'Review support requests and communicate status updates to SmartSit users.'),
          LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth >= 880) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 305,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [const Icon(Icons.inbox_outlined, color: SmartSitColors.green), const SizedBox(width: 8), const Expanded(child: Text('Active Queue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: SmartSitColors.text))), StatusPill('${_tickets.length} TICKETS')]),
                        const SizedBox(height: 12),
                        ...List.generate(_tickets.length, (i) => _ticketCard(i)),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(child: _conversation(ticket)),
                ],
              );
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [const Icon(Icons.inbox_outlined, color: SmartSitColors.green), const SizedBox(width: 8), const Expanded(child: Text('Active Queue', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: SmartSitColors.text))), StatusPill('${_tickets.length} TICKETS')]),
                const SizedBox(height: 10),
                SizedBox(
                  height: 145,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(_tickets.length, (i) => _ticketCard(i, horizontal: true)),
                  ),
                ),
                const SizedBox(height: 12),
                _conversation(ticket),
              ],
            );
          }),
          const SizedBox(height: 10),
          const Text('Ticket list and conversation are UI preview data.', style: TextStyle(fontSize: 11, color: SmartSitColors.muted)),
        ],
      ),
    );
  }
}

class _Ticket {
  const _Ticket(this.id, this.title, this.user, this.time, this.status, this.messages);
  final String id, title, user, time, status;
  final List<String> messages;
}

class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.name, required this.message, required this.mine, required this.time});
  final String name, message, time;
  final bool mine;
  @override
  Widget build(BuildContext context) => Row(mainAxisAlignment: mine ? MainAxisAlignment.end : MainAxisAlignment.start, crossAxisAlignment: CrossAxisAlignment.start, children: [
    if (!mine) const CircleAvatar(radius: 15, backgroundColor: SmartSitColors.panel, child: Icon(Icons.person, size: 16, color: SmartSitColors.muted)),
    if (!mine) const SizedBox(width: 8),
    Flexible(child: Column(crossAxisAlignment: mine ? CrossAxisAlignment.end : CrossAxisAlignment.start, children: [Text('$name • $time', style: const TextStyle(fontSize: 9, color: SmartSitColors.muted)), const SizedBox(height: 5), Container(padding: const EdgeInsets.all(11), decoration: BoxDecoration(color: mine ? SmartSitColors.text : SmartSitColors.panel, borderRadius: BorderRadius.circular(12)), child: Text(message, style: TextStyle(color: mine ? Colors.white : SmartSitColors.text, fontSize: 12, height: 1.4)))])),
    if (mine) const SizedBox(width: 8),
    if (mine) const CircleAvatar(radius: 15, backgroundColor: SmartSitColors.green, child: Icon(Icons.support_agent, size: 16, color: Colors.white)),
  ]);
}

class AdminSettingsScreen extends StatefulWidget {
  const AdminSettingsScreen({super.key});
  @override
  State<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends State<AdminSettingsScreen> {
  String selectedTab = 'Profile';
  bool emailAlerts = true;
  bool securityAlerts = true;
  bool weeklyReport = false;

  final _tabs = const [
    ('Profile', Icons.person_outline_rounded),
    ('Security', Icons.shield_outlined),
    ('Notifications', Icons.notifications_none_rounded),
    ('System Preferences', Icons.tune_rounded),
  ];

  Widget _tabItem(String label, IconData icon, {required bool wide}) {
    final selected = selectedTab == label;
    return Padding(
      padding: EdgeInsets.only(right: wide ? 0 : 6, bottom: wide ? 6 : 0),
      child: Material(
        color: selected ? const Color(0xFFE2E8EB) : Colors.transparent,
        borderRadius: BorderRadius.circular(9),
        child: InkWell(
          borderRadius: BorderRadius.circular(9),
          onTap: () => setState(() => selectedTab = label),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
            child: Row(
              mainAxisSize: wide ? MainAxisSize.max : MainAxisSize.min,
              children: [
                Icon(icon, size: 19, color: selected ? SmartSitColors.text : SmartSitColors.muted),
                const SizedBox(width: 9),
                if (wide)
                  Expanded(child: Text(label, style: TextStyle(fontSize: 12, color: selected ? SmartSitColors.text : SmartSitColors.muted, fontWeight: selected ? FontWeight.w800 : FontWeight.w600)))
                else
                  Text(label, softWrap: false, style: TextStyle(fontSize: 12, color: selected ? SmartSitColors.text : SmartSitColors.muted, fontWeight: selected ? FontWeight.w800 : FontWeight.w600)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _selectedSettingsContent(BuildContext context, {required bool wide}) {
    final profileHeader = Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipOval(
          child: Image.network(
            'https://lh3.googleusercontent.com/aida-public/AB6AXuBz01JGyuECc-SSnizpVqdIbgIIk9NZS8UOBz-Vktk_wanTWDiv8UE_0dWg-48SF56zPpjYOr3z6Xv45M5fsT6xZ26S5jC3G6WKYiqECJiGsbVFZ_VwlTXmsq-Mj0CTeB-7kEYMswqR-dZZgHKou_E8Z1tBfMTGvxJ0RQKT9JtDnzeghQzRRkNda2L77oQeWb4ktHya_yNKk5pCaTZQbfxOoL1yfg8_BCxzv8-3Xl_7Xzq88IT4p2Lq2xN0XEYRJPcY8jGj9AOoH3w',
            width: 76,
            height: 76,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => Container(width: 76, height: 76, color: SmartSitColors.greenLight, alignment: Alignment.center, child: const Text('AT', style: TextStyle(color: SmartSitColors.green, fontWeight: FontWeight.w900, fontSize: 20))),
          ),
        ),
        const SizedBox(width: 14),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Dr. Aris Thorne', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
              SizedBox(height: 5),
              Text('a.thorne@smartsit-clinical.org', style: TextStyle(fontSize: 12, color: SmartSitColors.muted)),
              SizedBox(height: 5),
              Text('Chief Medical Officer & Clinical Intelligence Lead', style: TextStyle(fontSize: 11, color: SmartSitColors.muted, height: 1.4)),
            ],
          ),
        ),
      ],
    );

    return SurfaceCard(
      padding: EdgeInsets.all(wide ? 22 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(selectedTab == 'Profile' ? 'Public Profile' : selectedTab, style: const TextStyle(fontSize: 19, fontWeight: FontWeight.w900, color: SmartSitColors.text)),
                  const SizedBox(height: 4),
                  Text(
                    selectedTab == 'Profile'
                        ? 'This information will be displayed to other clinical staff.'
                        : selectedTab == 'Security'
                            ? 'Manage account security and sign-in protections.'
                            : selectedTab == 'Notifications'
                                ? 'Choose which administrative updates you receive.'
                                : 'Configure how the SmartSit administration workspace behaves.',
                    style: const TextStyle(fontSize: 12, color: SmartSitColors.muted, height: 1.4),
                  ),
                ]),
              ),
              if (wide)
                OutlinedButton(onPressed: () => AppNotice.show(context, 'Settings save is UI-only; no server is connected.'), child: const Text('Save Changes')),
            ],
          ),
          const SizedBox(height: 20),
          if (selectedTab == 'Profile') ...[
            profileHeader,
            const SizedBox(height: 22),
            if (wide)
              Row(children: [
                const Expanded(child: _AdminSettingsField(label: 'Full name', value: 'Dr. Aris Thorne')),
                const SizedBox(width: 14),
                const Expanded(child: _AdminSettingsField(label: 'Email address', value: 'a.thorne@smartsit-clinical.org')),
              ])
            else ...[
              const _AdminSettingsField(label: 'Full name', value: 'Dr. Aris Thorne'),
              const SizedBox(height: 12),
              const _AdminSettingsField(label: 'Email address', value: 'a.thorne@smartsit-clinical.org'),
            ],
            const SizedBox(height: 12),
            const _AdminSettingsField(label: 'Role', value: 'Chief Medical Officer & Clinical Intelligence Lead'),
            const SizedBox(height: 12),
            const _AdminSettingsField(label: 'Specialty', value: 'Ergonomics and postural data analysis'),
          ] else if (selectedTab == 'Security') ...[
            const _AdminSettingsField(label: 'Current password', value: '••••••••'),
            const SizedBox(height: 12),
            const _AdminSettingsField(label: 'New password', value: '••••••••'),
            const SizedBox(height: 14),
            const StatusPill('TWO-FACTOR AUTHENTICATION ENABLED'),
          ] else if (selectedTab == 'Notifications') ...[
            SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, value: emailAlerts, onChanged: (v) => setState(() => emailAlerts = v), title: const Text('Email alerts', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), subtitle: const Text('Receive administrative alerts by email.', style: TextStyle(fontSize: 11, color: SmartSitColors.muted)), activeColor: SmartSitColors.green),
            SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, value: securityAlerts, onChanged: (v) => setState(() => securityAlerts = v), title: const Text('Security notifications', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), subtitle: const Text('Get notified about important security activity.', style: TextStyle(fontSize: 11, color: SmartSitColors.muted)), activeColor: SmartSitColors.green),
            SwitchListTile.adaptive(contentPadding: EdgeInsets.zero, value: weeklyReport, onChanged: (v) => setState(() => weeklyReport = v), title: const Text('Weekly report', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)), subtitle: const Text('Receive weekly product and account summaries.', style: TextStyle(fontSize: 11, color: SmartSitColors.muted)), activeColor: SmartSitColors.green),
          ] else ...[
            const InfoRow(label: 'System version', value: 'SmartSit UI 1.0'),
            const InfoRow(label: 'Default language', value: 'English'),
            const InfoRow(label: 'Data mode', value: 'Demo / local'),
            const InfoRow(label: 'Backend connection', value: 'Not connected'),
            const InfoRow(label: 'Layout preference', value: 'Responsive'),
          ],
          if (!wide) ...[
            const SizedBox(height: 18),
            SizedBox(width: double.infinity, child: FilledButton.icon(onPressed: () => AppNotice.show(context, 'Settings save is UI-only; no server is connected.'), icon: const Icon(Icons.save_outlined), label: const Text('Save Changes'))),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const PageIntro(title: 'Settings', subtitle: 'Configure your clinical environment and administrative preferences.'),
            LayoutBuilder(builder: (context, constraints) {
              final wide = constraints.maxWidth >= 790;
              if (wide) {
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 215,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ..._tabs.map((tab) => _tabItem(tab.$1, tab.$2, wide: true)),
                          const SizedBox(height: 10),
                          OutlinedButton.icon(
                            onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil('/', (_) => false),
                            icon: const Icon(Icons.logout_rounded, color: SmartSitColors.red, size: 18),
                            label: const Text('Logout', style: TextStyle(color: SmartSitColors.red)),
                            style: OutlinedButton.styleFrom(backgroundColor: SmartSitColors.redLight, side: BorderSide.none, alignment: Alignment.centerLeft),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(child: _selectedSettingsContent(context, wide: true)),
                  ],
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(children: _tabs.map((tab) => _tabItem(tab.$1, tab.$2, wide: false)).toList()),
                  ),
                  const SizedBox(height: 12),
                  _selectedSettingsContent(context, wide: false),
                  const SizedBox(height: 14),
                  SurfaceCard(
                    borderColor: const Color(0xFFF5D0D0),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      const Text('Deactivate Admin Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: SmartSitColors.red)),
                      const SizedBox(height: 6),
                      const Text('This demo section represents the high-impact account action shown in the web settings page.', style: TextStyle(fontSize: 12, color: SmartSitColors.muted, height: 1.45)),
                      const SizedBox(height: 12),
                      OutlinedButton(onPressed: () => AppNotice.show(context, 'Account deactivation is not connected.'), style: OutlinedButton.styleFrom(foregroundColor: SmartSitColors.red, side: const BorderSide(color: Color(0xFFF2B8B8))), child: const Text('Deactivate Account')),
                    ]),
                  ),
                ],
              );
            }),
            const SizedBox(height: 14),
            if (MediaQuery.sizeOf(context).width >= 790)
              SurfaceCard(
                borderColor: const Color(0xFFF5D0D0),
                child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  const Icon(Icons.warning_amber_rounded, color: SmartSitColors.red),
                  const SizedBox(width: 10),
                  const Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text('Deactivate Admin Account', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: SmartSitColors.red)),
                    SizedBox(height: 5),
                    Text('High-impact account actions should remain visible only to the owner.', style: TextStyle(fontSize: 12, color: SmartSitColors.muted, height: 1.45)),
                  ])),
                  OutlinedButton(onPressed: () => AppNotice.show(context, 'Account deactivation is not connected.'), style: OutlinedButton.styleFrom(foregroundColor: SmartSitColors.red, side: const BorderSide(color: Color(0xFFF2B8B8))), child: const Text('Deactivate')),
                ]),
              ),
          ],
        ),
      );
}

class _AdminSettingsField extends StatelessWidget {
  const _AdminSettingsField({required this.label, required this.value});
  final String label, value;
  @override
  Widget build(BuildContext context) => TextFormField(initialValue: value, decoration: InputDecoration(labelText: label));
}
