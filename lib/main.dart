import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:carousel_slider/carousel_slider.dart';

// NOTE: Material 2 UI (useMaterial3: false).
// This app is structured for quick demo + easy n8n integration.
// All n8n calls are shown as commented placeholders in ApiService.

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('hi'), Locale('mr')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => AppState()),
        ],
        child: const AgriAdvisorApp(),
      ),
    ),
  );
}

class AppState extends ChangeNotifier {
  String name = "Omkar";
  String role = "farmer"; // farmer | officer | ministry
  bool offline = false;

  // Dummy weather/advisory values
  int tempC = 31;
  int rainProb = 12;
  int soilMoisture = 78;

  void toggleOffline() {
    offline = !offline;
    notifyListeners();
  }

  void setRole(String newRole) {
    role = newRole;
    notifyListeners();
  }
}

class AgriAdvisorApp extends StatelessWidget {
  const AgriAdvisorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: tr('app_name'),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF6F7FB),
        appBarTheme: const AppBarTheme(
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black87,
          iconTheme: IconThemeData(color: Colors.black87),
        ),
        cardTheme: CardTheme(
          color: Colors.white,
          elevation: 1.5,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        ),
        chipTheme: ChipThemeData(
          backgroundColor: Colors.indigo.shade50,
          labelStyle: const TextStyle(color: Colors.indigo),
          shape: StadiumBorder(side: BorderSide(color: Color(0xFFB3B8F5))),
        ),
        textTheme: const TextTheme(
          titleLarge: TextStyle(fontSize: 24, fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          titleSmall: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          bodyLarge: TextStyle(fontSize: 16),
          bodyMedium: TextStyle(fontSize: 14),
          labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
        ),
      ),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      home: const RootScaffold(),
    );
  }
}

class RootScaffold extends StatefulWidget {
  const RootScaffold({super.key});

  @override
  State<RootScaffold> createState() => _RootScaffoldState();
}

class _RootScaffoldState extends State<RootScaffold> {
  int _index = 0;

  final _pages = [
    const DashboardScreen(),
    const ChatScreen(),
    MarketPriceTrackerScreen(),
    const WeatherScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6F7FB), Color(0xFFE3E6F5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(98),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF4F5BD5), Color(0xFFB3B8F5)],
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha((0.07 * 255).toInt()),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: Colors.indigo.shade100,
                      child: Icon(Icons.agriculture_rounded,
                          color: Colors.indigo.shade700, size: 30),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _greeting(context, app.name),
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: Colors.indigo.shade900,
                                  letterSpacing: 0.2,
                                ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                          const SizedBox(height: 2),
                          Text(
                            tr('app_name'),
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge!
                                .copyWith(
                                  fontWeight: FontWeight.w800,
                                  color: Colors.indigo.shade800,
                                  letterSpacing: 0.3,
                                ),
                            overflow: TextOverflow.ellipsis,
                            softWrap: false,
                            maxLines: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    _LangSelector(),
                  ],
                ),
              ),
            ),
          ),
        ),
        body: SafeArea(
          bottom: true,
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 0),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.97 * 255).toInt()),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade100.withAlpha((0.08 * 255).toInt()),
                  blurRadius: 12,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: [
                const SizedBox(height: 2),
                Container(
                  height: 2,
                  margin: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        if (app.offline)
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(8),
                            color: Colors.orange.shade100,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.wifi_off,
                                    size: 18, color: Colors.orange),
                                const SizedBox(width: 6),
                                Text(
                                  tr('offline'),
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: Colors.green.shade900,
                                        letterSpacing: 0.2,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.85,
                          child: _pages[_index],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: _index,
          onTap: (i) => setState(() => _index = i),
          selectedItemColor: Colors.green.shade700,
          unselectedItemColor: Colors.grey.shade500,
          type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(
                icon: const Icon(Icons.dashboard_rounded),
                label: tr('dashboard')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.chat_bubble_outline_rounded),
                label: tr('chat')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.currency_rupee_rounded),
                label: tr('market_prices')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.cloud_rounded), label: tr('weather')),
            BottomNavigationBarItem(
                icon: const Icon(Icons.person_rounded), label: tr('profile')),
          ],
        ),
      ),
    );
  }

  String _greeting(BuildContext context, String name) {
    final hour = DateTime.now().hour;
    if (hour < 12) return tr('greeting_morning');
    if (hour < 18) return tr('greeting_afternoon');
    return tr('greeting_evening');
  }
}

class _LangSelector extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DropdownButtonHideUnderline(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo.shade50, Colors.indigo.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.indigo.shade200, width: 1.2),
          boxShadow: [
            BoxShadow(
              color: Colors.indigo.shade100.withAlpha((0.18 * 255).toInt()),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
        child: DropdownButton<Locale>(
          value: context.locale,
          icon: Icon(Icons.language, color: Colors.indigo.shade700, size: 20),
          style: TextStyle(
            color: Colors.indigo.shade900,
            fontWeight: FontWeight.w600,
            fontSize: 15,
          ),
          dropdownColor: Colors.indigo.shade50,
          onChanged: (loc) => context.setLocale(loc!),
          items: const [
            DropdownMenuItem(value: Locale('en'), child: Text('EN')),
            DropdownMenuItem(value: Locale('hi'), child: Text('हिं')),
            DropdownMenuItem(value: Locale('mr'), child: Text('मा')),
          ],
        ),
      ),
    );
  }
}

// -------------------- DASHBOARD --------------------

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return ListView(
      padding: const EdgeInsets.only(bottom: 16),
      children: [
        _RoleSwitcher(),
        AdvisoryCard(
          title: tr('critical_advisory'),
          content: tr('advisory_example'),
          reasoningTitle: tr('advisory_reasoning_title'),
          reasoningBody: tr('reasoning_text'),
          badges: [
            _InfoBadge(icon: Icons.opacity, label: "${app.soilMoisture}%"),
            _InfoBadge(icon: Icons.umbrella, label: "${app.rainProb}%"),
            _InfoBadge(icon: Icons.thermostat, label: "${app.tempC}°C"),
          ],
        ),
        const QuickActionsRow(),
        const WeatherForecastCard(),
        const NewsCarousel(),
        const SizedBox(height: 8),
      ],
    );
  }
}

class _RoleSwitcher extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Row(
        children: [
          _roleChip(context, 'farmer', tr('role_farmer'), app.role == 'farmer'),
          const SizedBox(width: 8),
          _roleChip(
              context, 'officer', tr('role_officer'), app.role == 'officer'),
          const SizedBox(width: 8),
          _roleChip(
              context, 'ministry', tr('role_ministry'), app.role == 'ministry'),
          const Spacer(),
          IconButton(
            tooltip: "Toggle Offline",
            onPressed: () => context.read<AppState>().toggleOffline(),
            icon: const Icon(Icons.wifi_off),
          ),
        ],
      ),
    );
  }

  Widget _roleChip(
      BuildContext context, String role, String label, bool selected) {
    return ChoiceChip(
      selected: selected,
      onSelected: (_) => context.read<AppState>().setRole(role),
      label: Text(label),
      selectedColor: Colors.green.shade200,
      backgroundColor: Colors.green.shade50,
      labelStyle: TextStyle(
        color: selected ? Colors.green.shade900 : Colors.green.shade700,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  const _InfoBadge({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.green.shade50, Colors.green.shade100],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: Colors.green.shade100),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withAlpha((0.13 * 255).toInt()),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(children: [
        Icon(icon, size: 17, color: Colors.green.shade700),
        const SizedBox(width: 7),
        Text(label,
            style: TextStyle(
                color: Colors.green.shade800, fontWeight: FontWeight.w700)),
      ]),
    );
  }
}

class AdvisoryCard extends StatefulWidget {
  final String title;
  final String content;
  final String reasoningTitle;
  final String reasoningBody;
  final List<Widget> badges;
  const AdvisoryCard({
    super.key,
    required this.title,
    required this.content,
    required this.reasoningTitle,
    required this.reasoningBody,
    required this.badges,
  });

  @override
  State<AdvisoryCard> createState() => _AdvisoryCardState();
}

class _AdvisoryCardState extends State<AdvisoryCard> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFe0ffe7), Color(0xFFf7faf7)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.green.shade100.withAlpha((0.18 * 255).toInt()),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.green.shade100, Colors.green.shade300],
                    ),
                  ),
                  padding: const EdgeInsets.all(8),
                  child: Icon(Icons.agriculture_rounded,
                      color: Colors.green.shade700, size: 28),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(widget.title,
                      style: Theme.of(context).textTheme.titleLarge!.copyWith(
                            fontWeight: FontWeight.w800,
                            color: Colors.green.shade900,
                            letterSpacing: 0.2,
                          )),
                ),
                Wrap(spacing: 8, children: widget.badges),
              ],
            ),
            const SizedBox(height: 14),
            Text(
              widget.content,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                    fontSize: 17,
                    color: Colors.green.shade800,
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.green.shade800,
                  backgroundColor: Colors.green.shade50,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                ),
                onPressed: () => setState(() => expanded = !expanded),
                icon: Icon(expanded ? Icons.expand_less : Icons.info_outline,
                    color: Colors.green.shade700),
                label: Text(tr('why'),
                    style: TextStyle(
                        color: Colors.green.shade800,
                        fontWeight: FontWeight.w700)),
              ),
            ),
            AnimatedCrossFade(
              crossFadeState: expanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              duration: const Duration(milliseconds: 220),
              firstChild: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade50, Colors.green.shade100],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.green.shade100),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(widget.reasoningTitle,
                        style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 6),
                    Text(widget.reasoningBody),
                  ],
                ),
              ),
              secondChild: const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}

class QuickActionsRow extends StatelessWidget {
  const QuickActionsRow({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tr('quick_actions'),
              style: Theme.of(context).textTheme.titleMedium!.copyWith(
                    fontWeight: FontWeight.w800,
                    color: Colors.green.shade900,
                    letterSpacing: 0.2,
                  )),
          const SizedBox(height: 10),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _QuickAction(
                    icon: Icons.chat_bubble_outline,
                    labelKey: 'ask_question',
                    routeBuilder: () => const AdvancedChatbotScreen()),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.currency_rupee,
                    labelKey: 'market_prices',
                    routeBuilder: () => MarketPriceTrackerScreen()),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.cloud,
                    labelKey: 'weather',
                    routeBuilder: () => WeatherScreen()),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.account_balance,
                    labelKey: 'schemes_loans',
                    routeBuilder: () => SchemesFinanceNavigatorScreen()),
                const SizedBox(width: 12),
                _QuickAction(
                    icon: Icons.warning_amber_rounded,
                    labelKey: 'pest_alerts',
                    routeBuilder: () => PestDiseaseAlertsScreen()),
                if (app.role == 'officer' || app.role == 'ministry') ...[
                  const SizedBox(width: 12),
                  _QuickAction(
                      icon: Icons.analytics,
                      labelKey: 'ministry_dashboard',
                      routeBuilder: () => OfficerMinistryDashboardScreen()),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// --- Pest & Disease Alerts Screen (ensure defined) ---
class PestDiseaseAlertsScreen extends StatelessWidget {
  const PestDiseaseAlertsScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    // You can use your existing _dummyAlerts and _PestAlertCard here
    final alerts = _dummyAlerts;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.warning_amber_rounded, color: Colors.red.shade400),
            const SizedBox(width: 10),
            Text('Pest & Disease Alerts',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: alerts.length,
        itemBuilder: (context, i) => _PestAlertCard(alert: alerts[i]),
      ),
    );
  }
}

// --- Officer & Ministry Dashboard Screen (full definition) ---
class OfficerMinistryDashboardScreen extends StatefulWidget {
  const OfficerMinistryDashboardScreen({Key? key}) : super(key: key);
  @override
  State<OfficerMinistryDashboardScreen> createState() =>
      _OfficerMinistryDashboardScreenState();
}

class _OfficerMinistryDashboardScreenState
    extends State<OfficerMinistryDashboardScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String selectedCrop = 'Wheat';
  String selectedRegion = 'Pune';
  DateTimeRange? selectedRange;
  final crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final regions = ['Pune', 'Nashik', 'Nagpur', 'Kolhapur'];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.analytics, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            Text('Officer/Ministry Dashboard',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Map View'),
            Tab(text: 'Analytics'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          // Map View
          _OfficerMapView(),
          // Analytics
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    DropdownButton<String>(
                      value: selectedCrop,
                      items: crops
                          .map(
                              (c) => DropdownMenuItem(value: c, child: Text(c)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedCrop = v!),
                    ),
                    const SizedBox(width: 12),
                    DropdownButton<String>(
                      value: selectedRegion,
                      items: regions
                          .map(
                              (r) => DropdownMenuItem(value: r, child: Text(r)))
                          .toList(),
                      onChanged: (v) => setState(() => selectedRegion = v!),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.date_range),
                      label: const Text('Date Range'),
                      onPressed: () async {
                        final picked = await showDateRangePicker(
                          context: context,
                          firstDate: DateTime(2023, 1, 1),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null)
                          setState(() => selectedRange = picked);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Average Yield (${selectedRegion})',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text('3.8 tons/ha',
                            style: const TextStyle(
                                fontWeight: FontWeight.w700, fontSize: 18)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Market Price Trends',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        SizedBox(height: 120, child: _DummyOfficerLineChart()),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16)),
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Irrigation Requirement Heatmap',
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium!
                                .copyWith(fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        SizedBox(height: 80, child: _DummyHeatmap()),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OfficerMapView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // TODO: Replace with Google Maps widget and real markers
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: Colors.indigo.shade50,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: Colors.indigo.shade100),
            ),
            child: Center(
              child: Text('Map Placeholder\n(Pest, Weather, Market Markers)',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.indigo.shade400)),
            ),
          ),
          const SizedBox(height: 18),
          Text('Markers:',
              style: Theme.of(context)
                  .textTheme
                  .titleMedium!
                  .copyWith(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 12,
            children: [
              Chip(
                  label: const Text('Pest Outbreak'),
                  backgroundColor: Colors.red.shade100,
                  avatar: const Icon(Icons.bug_report, color: Colors.red)),
              Chip(
                  label: const Text('Weather Anomaly'),
                  backgroundColor: Colors.blue.shade100,
                  avatar: const Icon(Icons.cloud, color: Colors.blue)),
              Chip(
                  label: const Text('Market Hotspot'),
                  backgroundColor: Colors.orange.shade100,
                  avatar: const Icon(Icons.local_fire_department,
                      color: Colors.orange)),
            ],
          ),
        ],
      ),
    );
  }
}

// --- Dummy Data and Helper Widgets (top-level, single definition) ---
final List<Map<String, dynamic>> _dummyAlerts = [
  {
    'name': 'Fall Armyworm',
    'risk': 'High',
    'image': 'assets/alerts/armyworm.jpg',
    'prevention': [
      'Regular field monitoring',
      'Use pheromone traps',
    ],
    'treatment': [
      'Spray recommended biopesticide',
      'Remove and destroy infested plants',
    ],
    'gallery': [
      'assets/alerts/armyworm1.jpg',
      'assets/alerts/armyworm2.jpg',
    ],
  },
  {
    'name': 'Powdery Mildew',
    'risk': 'Medium',
    'image': 'assets/alerts/mildew.jpg',
    'prevention': [
      'Ensure good air circulation',
      'Avoid overhead irrigation',
    ],
    'treatment': [
      'Apply sulfur-based fungicide',
    ],
    'gallery': [
      'assets/alerts/mildew1.jpg',
      'assets/alerts/mildew2.jpg',
    ],
  },
];

class _PestAlertCard extends StatelessWidget {
  final Map<String, dynamic> alert;
  const _PestAlertCard({required this.alert});
  @override
  Widget build(BuildContext context) {
    final riskColor = {
      'Low': Colors.green,
      'Medium': Colors.orange,
      'High': Colors.red
    }[alert['risk']]!;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: AssetImage(alert['image']),
                  radius: 28,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(alert['name'],
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium!
                              .copyWith(fontWeight: FontWeight.w800)),
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: riskColor.withOpacity(0.13),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              children: [
                                Icon(Icons.bug_report,
                                    color: riskColor, size: 18),
                                const SizedBox(width: 5),
                                Text(alert['risk'],
                                    style: TextStyle(
                                        color: riskColor,
                                        fontWeight: FontWeight.w700)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text('Prevention',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            ...alert['prevention'].map<Widget>((step) => Row(
                  children: [
                    Icon(Icons.shield, color: Colors.green.shade700, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(step)),
                  ],
                )),
            const SizedBox(height: 8),
            Text('Treatment',
                style: const TextStyle(fontWeight: FontWeight.w700)),
            ...alert['treatment'].map<Widget>((step) => Row(
                  children: [
                    Icon(Icons.healing, color: Colors.blue.shade700, size: 18),
                    const SizedBox(width: 6),
                    Expanded(child: Text(step)),
                  ],
                )),
            const SizedBox(height: 10),
            SizedBox(
              height: 80,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: alert['gallery'].length,
                separatorBuilder: (_, __) => const SizedBox(width: 10),
                itemBuilder: (_, i) => ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.asset(alert['gallery'][i],
                      width: 80, height: 80, fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Move all top-level classes here
class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {'text': 'Hello! How can I help you today?', 'isUser': false},
  ];

  void _sendMessage() {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    setState(() {
      _messages.add({'text': text, 'isUser': true});
      _messages.add({'text': 'This is a demo response.', 'isUser': false});
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF6F7FB), Color(0xFFE3E6F5)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [Colors.indigo.shade100, Colors.indigo.shade200],
                  ),
                ),
                padding: const EdgeInsets.all(6),
                child: Icon(Icons.chat_bubble_rounded,
                    color: Colors.indigo.shade700),
              ),
              const SizedBox(width: 10),
              Text(tr('chat'),
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          elevation: 0,
          backgroundColor: Colors.white.withAlpha((0.95 * 255).toInt()),
        ),
        body: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _PremiumChatBubble(
                      text: msg['text'], isUser: msg['isUser']);
                },
              ),
            ),
            Container(
              padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha((0.95 * 255).toInt()),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.indigo.shade100.withAlpha((0.10 * 255).toInt()),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.indigo.shade50,
                            Colors.indigo.shade100
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.indigo.shade100.withOpacity(0.10),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _controller,
                        decoration: InputDecoration(
                          hintText: tr('type_message'),
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                        style: TextStyle(color: Colors.indigo.shade900),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          Colors.indigo.shade200,
                          Colors.indigo.shade400
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade100
                              .withAlpha((0.18 * 255).toInt()),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: IconButton(
                      icon: Icon(Icons.send, color: Colors.white),
                      onPressed: _sendMessage,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _PremiumChatBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  const _PremiumChatBubble({required this.text, required this.isUser});

  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? LinearGradient(
            colors: [Colors.indigo.shade400, Colors.indigo.shade200])
        : LinearGradient(colors: [Colors.indigo.shade50, Colors.white]);
    final fg = isUser ? Colors.white : Colors.indigo.shade900;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            gradient: bg,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade100.withAlpha((0.13 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(text,
              style: TextStyle(
                  color: fg, fontSize: 15, fontWeight: FontWeight.w500)),
        ),
      ],
    );
  }
}

// Add this class definition before _MarketPriceTrackerScreenState

// Premium Weather Forecast Card
class WeatherForecastCard extends StatelessWidget {
  const WeatherForecastCard({super.key});

  @override
  Widget build(BuildContext context) {
    final week = [
      {'day': 'Mon', 'icon': Icons.wb_sunny, 'temp': '32°C', 'rain': '10%'},
      {'day': 'Tue', 'icon': Icons.cloud, 'temp': '30°C', 'rain': '20%'},
      {'day': 'Wed', 'icon': Icons.grain, 'temp': '29°C', 'rain': '40%'},
      {'day': 'Thu', 'icon': Icons.wb_cloudy, 'temp': '28°C', 'rain': '60%'},
      {'day': 'Fri', 'icon': Icons.wb_sunny, 'temp': '31°C', 'rain': '15%'},
      {'day': 'Sat', 'icon': Icons.cloud, 'temp': '30°C', 'rain': '25%'},
      {'day': 'Sun', 'icon': Icons.grain, 'temp': '27°C', 'rain': '50%'},
    ];
    return Container(
      margin: EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFe3f0ff), Color(0xFFb3c6f5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.18),
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.cloud, color: Colors.blue.shade400, size: 28),
              SizedBox(width: 10),
              Text('7-Day Weather Forecast',
                  style: Theme.of(context).textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.w800,
                        color: Colors.blue.shade900,
                      )),
            ],
          ),
          SizedBox(height: 12),
          SizedBox(
            height: 110,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: week.length,
              separatorBuilder: (_, __) => SizedBox(width: 12),
              itemBuilder: (context, i) {
                final day = week[i];
                return Container(
                  width: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.85),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(day['day'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.blue.shade700,
                              fontSize: 15)),
                      SizedBox(height: 4),
                      Icon(day['icon'] as IconData,
                          color: Colors.blue.shade400, size: 26),
                      SizedBox(height: 4),
                      Text(day['temp'] as String,
                          style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: Colors.blue.shade900,
                              fontSize: 14)),
                      Text(day['rain'] as String,
                          style: TextStyle(
                              fontSize: 11, color: Colors.blue.shade400)),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// Premium News Carousel
class NewsCarousel extends StatelessWidget {
  const NewsCarousel({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> news = [
      {
        'title': 'Govt launches new crop insurance scheme',
        'summary':
            'Farmers to benefit from improved coverage and faster claims.'
      },
      {
        'title': 'Market prices surge for cotton',
        'summary': 'Cotton prices hit a 3-year high amid global demand.'
      },
      {
        'title': 'Pest alert: Armyworm in Maharashtra',
        'summary': 'Farmers advised to monitor crops and report outbreaks.'
      },
    ];
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFb3c6f5), Color(0xFFe3f0ff)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.shade100.withOpacity(0.18),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: CarouselSlider(
          options: CarouselOptions(
            height: 90,
            autoPlay: true,
            enlargeCenterPage: true,
            viewportFraction: 0.92,
            autoPlayInterval: const Duration(seconds: 4),
          ),
          items: news.map((item) {
            return Builder(
              builder: (context) => ListTile(
                leading:
                    Icon(Icons.article, color: Colors.blue.shade700, size: 32),
                title: Text(item['title']!,
                    style: const TextStyle(fontWeight: FontWeight.bold)),
                subtitle: Text(item['summary']!),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class MarketPriceTrackerScreen extends StatefulWidget {
  const MarketPriceTrackerScreen({super.key});

  @override
  State<MarketPriceTrackerScreen> createState() =>
      _MarketPriceTrackerScreenState();
}

class _MarketPriceTrackerScreenState extends State<MarketPriceTrackerScreen> {
  String trendType = '7-day';
  String selectedCrop = 'Wheat';
  String selectedLocation = 'Pune';
  bool showWhy = false;

  final List<String> crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final List<String> locations = ['Pune', 'Mumbai', 'Nagpur', 'Nashik'];

  List<Map<String, dynamic>> get priceData7d => List.generate(7, (i) {
        final d = DateTime.now().subtract(Duration(days: 6 - i));
        return {
          'date': d,
          'min': 1800 + (i % 7) * 10,
          'max': 2100 + (i % 7) * 12,
          'modal': 1950 + (i % 7) * 11,
        };
      });

  List<Map<String, dynamic>> get priceData30d => List.generate(30, (i) {
        final d = DateTime.now().subtract(Duration(days: 29 - i));
        return {
          'date': d,
          'min': 1800 + (i % 7) * 10,
          'max': 2100 + (i % 7) * 12,
          'modal': 1950 + (i % 7) * 11,
        };
      });

  @override
  Widget build(BuildContext context) {
    final data = trendType == '7-day' ? priceData7d : priceData30d;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.currency_rupee_rounded, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            Text(tr('market_prices'),
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // Crop/location dropdowns
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedCrop,
                  decoration: InputDecoration(
                    labelText: 'Crop',
                    filled: true,
                    fillColor: Colors.indigo.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  items: crops
                      .map((c) => DropdownMenuItem(value: c, child: Text(c)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCrop = v!),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedLocation,
                  decoration: InputDecoration(
                    labelText: 'Location',
                    filled: true,
                    fillColor: Colors.indigo.shade50,
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  items: locations
                      .map((l) => DropdownMenuItem(value: l, child: Text(l)))
                      .toList(),
                  onChanged: (v) => setState(() => selectedLocation = v!),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          // Recommendation card
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.lightbulb, color: Colors.indigo.shade400),
                      const SizedBox(width: 10),
                      Text('Recommendation: Hold',
                          style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: Colors.indigo.shade900)),
                      const Spacer(),
                      TextButton.icon(
                        icon: Icon(
                            showWhy ? Icons.expand_less : Icons.info_outline,
                            color: Colors.indigo.shade700),
                        label: Text('Why?',
                            style: TextStyle(
                                color: Colors.indigo.shade800,
                                fontWeight: FontWeight.w700)),
                        onPressed: () => setState(() => showWhy = !showWhy),
                        style: TextButton.styleFrom(
                          backgroundColor: Colors.indigo.shade50,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ],
                  ),
                  AnimatedCrossFade(
                    crossFadeState: showWhy
                        ? CrossFadeState.showFirst
                        : CrossFadeState.showSecond,
                    duration: const Duration(milliseconds: 220),
                    firstChild: Padding(
                      padding: const EdgeInsets.only(top: 10),
                      child: Text(
                          'Prices are rising steadily due to increased demand and lower supply. Holding may yield better returns next week.'),
                    ),
                    secondChild: const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Responsive DataTable
          Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('Date')),
                    DataColumn(label: Text('Min Price')),
                    DataColumn(label: Text('Max Price')),
                    DataColumn(label: Text('Modal Price')),
                  ],
                  rows: data
                      .map(
                        (row) => DataRow(
                          cells: [
                            DataCell(Text(
                                "${row['date'].day}/${row['date'].month}")),
                            DataCell(Text(row['min'].toString())),
                            DataCell(Text(row['max'].toString())),
                            DataCell(Text(row['modal'].toString())),
                          ],
                        ),
                      )
                      .toList(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DummyOfficerLineChart extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Placeholder();
  }
}

// Move these classes to the top-level (outside of any other class):

class _DummyInteractiveLineChart extends StatelessWidget {
  final List<Map<String, dynamic>> data;
  const _DummyInteractiveLineChart({required this.data});
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onScaleUpdate: (details) {}, // Placeholder for pinch zoom
      child: CustomPaint(
        painter: _LineChartPainter(data),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _LineChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;
  _LineChartPainter(this.data);
  @override
  void paint(Canvas canvas, Size size) {
    final paintLine = Paint()
      ..color = Colors.indigo.shade400
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    final paintGrid = Paint()
      ..color = Colors.indigo.shade100
      ..strokeWidth = 1;
    // Draw grid
    for (var i = 1; i < 4; i++) {
      final y = size.height * i / 4;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }
    // Draw line
    final points = List.generate(data.length, (i) {
      final x = size.width * i / (data.length - 1);
      final y = size.height * (1 - ((data[i]['modal'] - 1950) / 100));
      return Offset(x, y);
    });
    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (final p in points.skip(1)) {
      path.lineTo(p.dx, p.dy);
    }
    canvas.drawPath(path, paintLine);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(tr('weather'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFFe0f7fa), Color(0xFFf7faf7)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(22),
              boxShadow: [
                BoxShadow(
                  color: Colors.blue.shade100.withOpacity(0.13),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Icon(Icons.thermostat, color: Colors.red.shade400, size: 28),
                  const SizedBox(width: 14),
                  Text("${app.tempC}°C",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.red.shade400,
                        fontSize: 18,
                      )),
                  const Spacer(),
                  Icon(Icons.umbrella, color: Colors.blue.shade400, size: 24),
                  const SizedBox(width: 8),
                  Text("${app.rainProb}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.blue.shade400,
                        fontSize: 16,
                      )),
                  const SizedBox(width: 14),
                  Icon(Icons.opacity, color: Colors.green.shade400, size: 24),
                  const SizedBox(width: 8),
                  Text("${app.soilMoisture}%",
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade400,
                        fontSize: 16,
                      )),
                ],
              ),
            ),
          ),
          const WeatherForecastCard(),
        ],
      ),
    );
  }
}

class SchemesLoansScreen extends StatelessWidget {
  const SchemesLoansScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(tr('schemes_loans'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
              child: ListTile(
            leading: const Icon(Icons.account_balance_wallet_outlined),
            title: const Text("PM-Kisan Eligibility Checker"),
            subtitle: const Text("Check if you qualify and how to apply."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
          Card(
              child: ListTile(
            leading: const Icon(Icons.credit_card_outlined),
            title: const Text("Kisan Credit Card (KCC)"),
            subtitle: const Text("Low-interest credit line for farmers."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
          Card(
              child: ListTile(
            leading: const Icon(Icons.savings_outlined),
            title: const Text("DBT Subsidies"),
            subtitle: const Text("Fertilizer, machinery & irrigation support."),
            trailing: const Icon(Icons.keyboard_arrow_right),
            onTap: () {},
          )),
        ],
      ),
    );
  }
}

class NewsfeedScreen extends StatelessWidget {
  const NewsfeedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      tr('news_headline_1'),
      tr('news_headline_2'),
      tr('news_headline_3'),
    ];
    return Scaffold(
      appBar: AppBar(title: Text(tr('news'))),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (_, i) => Card(
          child: ListTile(
            leading: const Icon(Icons.newspaper_rounded),
            title: Text(items[i],
                style: const TextStyle(fontWeight: FontWeight.w600)),
            subtitle: const Text("Tap to read more..."),
            onTap: () {},
          ),
        ),
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final app = context.watch<AppState>();
    return Scaffold(
      appBar: AppBar(title: Text(tr('profile'))),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    backgroundColor: Colors.green.shade100,
                    child: const Icon(Icons.person, color: Colors.black54),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(app.name,
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 4),
                        Text("Role: ${app.role}"),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            child: SwitchListTile(
              title: const Text("Offline Mode (simulate)"),
              value: app.offline,
              onChanged: (_) => context.read<AppState>().toggleOffline(),
              secondary: const Icon(Icons.wifi_off),
            ),
          ),
        ],
      ),
    );
  }
}

// --- Schemes & Finance Navigator ---
class SchemesFinanceNavigatorScreen extends StatefulWidget {
  const SchemesFinanceNavigatorScreen({super.key});
  @override
  State<SchemesFinanceNavigatorScreen> createState() =>
      _SchemesFinanceNavigatorScreenState();
}

class _SchemesFinanceNavigatorScreenState
    extends State<SchemesFinanceNavigatorScreen> {
  int step = 0;
  String landSize = '';
  String crop = '';
  String state = '';
  final List<String> crops = ['Wheat', 'Rice', 'Maize', 'Soybean'];
  final List<String> states = ['Maharashtra', 'Punjab', 'UP', 'MP'];
  final List<Map<String, String>> schemes = [
    {
      'title': 'PM-Kisan',
      'eligibility': 'Small/marginal farmers, up to 2 ha land',
      'benefits': '₹6000/year direct benefit',
      'apply': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'Kisan Credit Card (KCC)',
      'eligibility': 'All farmers, valid land records',
      'benefits': 'Low-interest credit line',
      'apply': 'https://pmkisan.gov.in/',
    },
    {
      'title': 'DBT Subsidies',
      'eligibility': 'Registered farmers',
      'benefits': 'Fertilizer, machinery, irrigation support',
      'apply': 'https://dbtbharat.gov.in/',
    },
  ];
  final List<Map<String, String>> loans = [
    {
      'title': 'Agri Gold Loan',
      'branch': 'SBI, Pune',
      'contact': '+91-9876543210',
    },
    {
      'title': 'Crop Loan',
      'branch': 'BOI, Nashik',
      'contact': '+91-9123456780',
    },
  ];
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.account_balance, color: Colors.indigo.shade700),
              const SizedBox(width: 10),
              Text('Schemes & Finance',
                  style: const TextStyle(fontWeight: FontWeight.w700)),
            ],
          ),
          backgroundColor: Colors.white.withOpacity(0.95),
          elevation: 0,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Schemes'),
              Tab(text: 'Loans'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // Schemes wizard
            Padding(
              padding: const EdgeInsets.all(18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Stepper(
                    currentStep: step,
                    onStepContinue: () {
                      if (step == 0 && landSize.isEmpty) return;
                      if (step == 1 && crop.isEmpty) return;
                      if (step == 2 && state.isEmpty) return;
                      if (step < 2) setState(() => step++);
                    },
                    onStepCancel: () {
                      if (step > 0) setState(() => step--);
                    },
                    steps: [
                      Step(
                        title: const Text('Land Size'),
                        content: TextFormField(
                          decoration: const InputDecoration(
                              labelText: 'Land size (hectares)'),
                          keyboardType: TextInputType.number,
                          onChanged: (v) => setState(() => landSize = v),
                        ),
                        isActive: step == 0,
                      ),
                      Step(
                        title: const Text('Crop'),
                        content: DropdownButtonFormField<String>(
                          value: crop.isEmpty ? null : crop,
                          items: crops
                              .map((c) =>
                                  DropdownMenuItem(value: c, child: Text(c)))
                              .toList(),
                          onChanged: (v) => setState(() => crop = v!),
                          decoration: const InputDecoration(labelText: 'Crop'),
                        ),
                        isActive: step == 1,
                      ),
                      Step(
                        title: const Text('State'),
                        content: DropdownButtonFormField<String>(
                          value: state.isEmpty ? null : state,
                          items: states
                              .map((s) =>
                                  DropdownMenuItem(value: s, child: Text(s)))
                              .toList(),
                          onChanged: (v) => setState(() => state = v!),
                          decoration: const InputDecoration(labelText: 'State'),
                        ),
                        isActive: step == 2,
                      ),
                    ],
                  ),
                  if (step == 2)
                    Expanded(
                      child: ListView(
                        children: schemes
                            .map((s) => Card(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16)),
                                  elevation: 2,
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(18),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(s['title']!,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleMedium!
                                                .copyWith(
                                                    fontWeight: FontWeight.w800,
                                                    color: Colors
                                                        .indigo.shade900)),
                                        const SizedBox(height: 6),
                                        Text('Eligibility: ${s['eligibility']}',
                                            style: const TextStyle(
                                                fontWeight: FontWeight.w600)),
                                        const SizedBox(height: 4),
                                        Text('Benefits: ${s['benefits']}'),
                                        const SizedBox(height: 10),
                                        ElevatedButton.icon(
                                          icon: const Icon(Icons.open_in_new),
                                          label: const Text('Apply'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                Colors.indigo.shade400,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12)),
                                          ),
                                          onPressed: () {
                                            // TODO: Open link or call API
                                            // launch(s['apply']!);
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                            .toList(),
                      ),
                    ),
                ],
              ),
            ),
            // Loans tab
            Padding(
              padding: const EdgeInsets.all(18),
              child: ListView(
                children: loans
                    .map((l) => Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16)),
                          elevation: 2,
                          margin: const EdgeInsets.symmetric(vertical: 10),
                          child: ListTile(
                            leading: const Icon(
                                Icons.account_balance_wallet_outlined),
                            title: Text(l['title']!,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700)),
                            subtitle: Text(
                                '${l['branch']}\nContact: ${l['contact']}'),
                            trailing: IconButton(
                              icon: const Icon(Icons.phone),
                              onPressed: () {
                                // TODO: Call branch
                                // launch('tel:${l['contact']}');
                              },
                            ),
                          ),
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Dummy line chart for Officer/Ministry analytics
// Removed unused _DummyOfficerLineChart and _OfficerLineChartPainter classes

// Dummy heatmap for irrigation requirement
class _DummyHeatmap extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(
          8,
          (i) => Expanded(
                child: Container(
                  height: 60,
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: Color.lerp(
                        Colors.green.shade100, Colors.red.shade400, i / 7),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )),
    );
  }
}

// --- Conversational AI Chatbot ---
class AdvancedChatbotScreen extends StatefulWidget {
  const AdvancedChatbotScreen({Key? key}) : super(key: key);
  @override
  State<AdvancedChatbotScreen> createState() => _AdvancedChatbotScreenState();
}

class _AdvancedChatbotScreenState extends State<AdvancedChatbotScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [
    {
      'text': 'Hello! How can I assist you today?',
      'isUser': false,
      'timestamp': DateTime.now().subtract(const Duration(minutes: 2)),
      'type': 'text',
    },
  ];
  final List<String> _smartReplies = ['Why?', 'More details', 'Translate'];

  void _sendMessage({String? text, String type = 'text'}) {
    final messageText = text ?? _controller.text.trim();
    if (messageText.isEmpty) return;
    setState(() {
      _messages.add({
        'text': messageText,
        'isUser': true,
        'timestamp': DateTime.now(),
        'type': type,
      });
      _messages.add({
        'text': 'This is a demo response.',
        'isUser': false,
        'timestamp': DateTime.now(),
        'type': 'text',
      });
      _controller.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.smart_toy, color: Colors.indigo.shade700),
            const SizedBox(width: 10),
            Text('AI Chatbot',
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        backgroundColor: Colors.white.withOpacity(0.95),
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 18),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _ChatMessageBubble(
                  text: msg['text'],
                  isUser: msg['isUser'],
                  timestamp: msg['timestamp'],
                  type: msg['type'],
                );
              },
            ),
          ),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Wrap(
              spacing: 8,
              children: _smartReplies
                  .map((reply) => ActionChip(
                        label: Text(reply),
                        onPressed: () =>
                            _sendMessage(text: reply, type: 'smart'),
                        backgroundColor: Colors.indigo.shade50,
                        labelStyle: TextStyle(
                            color: Colors.indigo.shade700,
                            fontWeight: FontWeight.w600),
                      ))
                  .toList(),
            ),
          ),
          Container(
            padding: const EdgeInsets.fromLTRB(12, 8, 12, 18),
            decoration: BoxDecoration(
              color: Colors.white.withAlpha((0.95 * 255).toInt()),
              boxShadow: [
                BoxShadow(
                  color: Colors.indigo.shade100.withAlpha((0.10 * 255).toInt()),
                  blurRadius: 10,
                  offset: const Offset(0, -2),
                ),
              ],
            ),
            child: Row(
              children: [
                IconButton(
                  icon: Icon(Icons.mic, color: Colors.indigo.shade400),
                  onPressed: () {
                    // TODO: Integrate voice input
                  },
                  tooltip: 'Voice Input',
                ),
                IconButton(
                  icon: Icon(Icons.image, color: Colors.indigo.shade400),
                  onPressed: () {
                    // TODO: Integrate image input
                  },
                  tooltip: 'Image Input',
                ),
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.indigo.shade50, Colors.indigo.shade100],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.indigo.shade100
                              .withAlpha((0.10 * 255).toInt()),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: tr('type_message'),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                      style: TextStyle(color: Colors.indigo.shade900),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      colors: [Colors.indigo.shade200, Colors.indigo.shade400],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.indigo.shade100
                            .withAlpha((0.18 * 255).toInt()),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: Icon(Icons.send, color: Colors.white),
                    onPressed: _sendMessage,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ChatMessageBubble extends StatelessWidget {
  final String text;
  final bool isUser;
  final DateTime timestamp;
  final String type;
  const _ChatMessageBubble(
      {required this.text,
      required this.isUser,
      required this.timestamp,
      required this.type});
  @override
  Widget build(BuildContext context) {
    final bg = isUser
        ? LinearGradient(colors: [Colors.green.shade400, Colors.green.shade200])
        : LinearGradient(colors: [Colors.green.shade50, Colors.white]);
    final fg = isUser ? Colors.white : Colors.green.shade900;
    final align = isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start;
    final radius = isUser
        ? const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          )
        : const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomRight: Radius.circular(18),
            bottomLeft: Radius.circular(6),
          );
    return Column(
      crossAxisAlignment: align,
      children: [
        Container(
          margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 2),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          constraints: const BoxConstraints(maxWidth: 320),
          decoration: BoxDecoration(
            gradient: bg,
            borderRadius: radius,
            boxShadow: [
              BoxShadow(
                color: Colors.indigo.shade100.withAlpha((0.13 * 255).toInt()),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: align,
            children: [
              Text(text,
                  style: TextStyle(
                      color: fg, fontSize: 15, fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text(
                _formatTimestamp(timestamp),
                style: TextStyle(
                    fontSize: 11,
                    color: isUser ? Colors.white70 : Colors.indigo.shade400),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _formatTimestamp(DateTime dt) {
    final now = DateTime.now();
    if (now.difference(dt).inMinutes < 1) return 'Just now';
    if (now.difference(dt).inMinutes < 60)
      return '${now.difference(dt).inMinutes} min ago';
    return '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
  }
}

// --- Quick Action Button Widget (top-level, single definition) ---
class _QuickAction extends StatelessWidget {
  final IconData icon;
  final String labelKey;
  final Widget Function() routeBuilder;
  const _QuickAction(
      {required this.icon, required this.labelKey, required this.routeBuilder});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: () => Navigator.of(context)
          .push(MaterialPageRoute(builder: (_) => routeBuilder())),
      child: Container(
        constraints: const BoxConstraints(minWidth: 90, maxWidth: 120),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.green.shade50, Colors.green.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: Colors.green.shade100),
          boxShadow: [
            BoxShadow(
                color: Colors.green.shade100.withOpacity(0.13),
                blurRadius: 8,
                offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 26, color: Colors.green.shade700),
            const SizedBox(height: 10),
            Text(tr(labelKey),
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
          ],
        ),
      ),
    );
  }
}
