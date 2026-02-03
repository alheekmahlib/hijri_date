import 'package:flutter/material.dart';
import 'package:hijri_date/hijri.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hijri Date Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const HijriExamplePage(),
    );
  }
}

class HijriExamplePage extends StatelessWidget {
  const HijriExamplePage({super.key});

  @override
  Widget build(BuildContext context) {
    HijriDate.setLocal('ar');
    final today = HijriDate.now();
    final gregorian = DateTime(2024, 3, 10);
    final hijriFromGregorian = HijriDate.fromDate(gregorian);
    final arabicNumber = DigitsConverter.convertNumberToLocale(12345, 'ar');
    final moonPhase = today.getMoonPhaseName();
    final moonInfo = today.getMoonPhase();
    final events = IslamicEventsManager.getTodaysEvents();

    final theme = Theme.of(context);
    final titleStyle = theme.textTheme.titleLarge;
    final subtitleStyle = theme.textTheme.bodyMedium?.copyWith(
      color: theme.colorScheme.onSurfaceVariant,
      fontSize: 18,
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Hijri Date')),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                theme.colorScheme.surface,
                theme.colorScheme.surfaceContainerLowest,
              ],
            ),
          ),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text('اليوم', style: titleStyle),
              const SizedBox(height: 6),
              Text(today.fullDate(), style: theme.textTheme.headlineSmall),
              const SizedBox(height: 4),
              Text(
                'تنسيق مختصر: ${today.toFormat("dd/mm/yyyy")}',
                style: subtitleStyle,
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 0,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('التحويل من الميلادي', style: titleStyle),
                      const SizedBox(height: 8),
                      Text(
                        'ميلادي ${gregorian.day}/${gregorian.month}/${gregorian.year}',
                      ),
                      Text('هجري ${hijriFromGregorian.fullDate()}'),
                      const SizedBox(height: 12),
                      Text('أرقام عربية: $arabicNumber', style: subtitleStyle),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 0,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('طور القمر اليوم', style: titleStyle),
                      const SizedBox(height: 8),
                      Text(moonPhase, style: subtitleStyle),
                      const SizedBox(height: 12),
                      Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Container(
                            decoration: BoxDecoration(
                              color: theme.colorScheme.surfaceContainerHighest,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.1),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: MoonPhaseWidget(
                              moonInfo: moonInfo,
                              size: 180,
                              overlayColor: Colors.black,
                              overlayOpacity: 1.0,
                              backgroundAssetPath: 'assets/moon_background.svg',
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              Card(
                elevation: 0,
                color: theme.colorScheme.primary.withValues(alpha: 0.1),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('مناسبات اليوم', style: titleStyle),
                      const SizedBox(height: 8),
                      Text(
                        events.isEmpty
                            ? 'لا توجد مناسبات اليوم'
                            : events.map((e) => e.getTitle('ar')).join('، '),
                        style: subtitleStyle,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
