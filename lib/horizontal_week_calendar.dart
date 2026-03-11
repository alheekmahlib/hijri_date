import 'dart:developer' show log;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'convert_number_extension.dart';
import 'hijri_date.dart';

enum WeekStartFrom {
  sunday,
  monday,
  friday,
}

class HorizontalWeekCalendar extends StatefulWidget {
  /// week start from Monday, Sunday, or Friday
  ///
  /// default value is
  /// ```dart
  /// [WeekStartFrom.monday]
  /// ```
  final WeekStartFrom? weekStartFrom;

  ///get DateTime on date select
  ///
  /// ```dart
  /// onDateChange: (DateTime date){
  ///    log(date);
  /// }
  /// ```
  final Function(DateTime)? onDateChange;

  ///get the list of DateTime on week change
  ///
  /// ```dart
  /// onWeekChange: (List<DateTime> list){
  ///    log("First date: ${list.first}");
  ///    log("Last date: ${list.last}");
  /// }
  /// ```
  final Function(List<DateTime>)? onWeekChange;

  /// Active background color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeBackgroundColor;

  /// In-Active background color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withValues(alpha: .2)
  /// ```
  final Color? inactiveBackgroundColor;

  /// Disable background color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? disabledBackgroundColor;

  /// Active text color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeTextColor;

  /// In-Active text color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withValues(alpha: .2)
  /// ```
  final Color? inactiveTextColor;

  /// Disable text color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? disabledTextColor;

  /// Active Navigator color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor
  /// ```
  final Color? activeNavigatorColor;

  /// In-Active Navigator color
  ///
  /// Default value is
  /// ```dart
  /// Colors.grey
  /// ```
  final Color? inactiveNavigatorColor;

  /// Month Color
  ///
  /// Default value is
  /// ```dart
  /// Theme.of(context).primaryColor.withValues(alpha: .2)
  /// ```
  final Color? monthColor;

  /// border radius of date card
  ///
  /// Default value is `null`
  final BorderRadiusGeometry? borderRadius;

  /// scroll physics
  ///
  /// Default value is
  /// ```
  /// scrollPhysics: const ClampingScrollPhysics(),
  /// ```
  final ScrollPhysics? scrollPhysics;

  /// showNavigationButtons
  ///
  /// Default value is `true`
  final bool? showNavigationButtons;

  /// monthFormat
  ///
  /// If it's current year then
  /// Default value will be ```MMMM```
  ///
  /// Otherwise
  /// Default value will be `MMMM yyyy`
  final String? monthFormat;

  final DateTime minDate;

  final DateTime maxDate;

  final DateTime initialDate;

  final bool showTopNavbar;

  final HorizontalWeekCalenderController? controller;

  final double? carouselHeight;
  final double? itemMarginHorizontal;
  final Color? itemBorderColor;

  /// Whether to translate numbers according to the specified language
  ///
  /// Default value is `false`
  final bool translateNumbers;

  /// Language code for number translation
  ///
  /// Supported languages: 'ar', 'en', 'bn', 'ur'
  /// Default value is `'en'`
  final String languageCode;

  /// Custom day names starting from Sunday
  /// Must contain exactly 7 names: [Sunday, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday]
  /// If null, default Arabic names will be used
  /// Example: ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat']
  final List<String>? customDayNames;

  /// Custom month names for Hijri calendar starting from Muharram
  /// Must contain exactly 12 names: [Muharram, Safar, Rabi' al-awwal, ...]
  /// If null, default Arabic names will be used
  final List<String>? customMonthNames;

  /// Text style for day numbers
  ///
  /// Default value is `null` (uses theme default)
  final TextStyle? dayTextStyle;

  /// Text style for day names (Sun, Mon, etc.)
  ///
  /// Default value is `null` (uses theme default)
  final TextStyle? dayNameTextStyle;

  /// Text style for month display in top navbar
  ///
  /// Default value is `null` (uses theme default)
  final TextStyle? monthTextStyle;

  /// Whether to show the Gregorian day under the Hijri day
  ///
  /// Default value is `false`
  final bool showGregorianUnderHijri;

  /// Gregorian day format when [showGregorianUnderHijri] is true
  ///
  /// Default value is `d`
  final String gregorianDayFormat;

  /// Text style for the Gregorian day under Hijri
  ///
  /// Default value is `null` (derived from day text style)
  final TextStyle? gregorianDayTextStyle;

  /// Opacity applied to the Gregorian day text
  ///
  /// Default value is `0.6`
  final double gregorianDayOpacity;

  /// Whether to use Hijri dates instead of Gregorian dates
  ///
  /// When true, the calendar will use Hijri calendar system with hijriMinDate, hijriMaxDate, hijriInitialDate
  /// When false (default), the calendar will use Gregorian calendar system with minDate, maxDate, initialDate
  /// Default value is `false`
  final bool useHijriDates;

  /// Minimum Hijri date for the calendar (only used when useHijriDates is true)
  ///
  /// This date should be provided when useHijriDates is true
  final HijriDate? hijriMinDate;

  /// Maximum Hijri date for the calendar (only used when useHijriDates is true)
  ///
  /// This date should be provided when useHijriDates is true
  final HijriDate? hijriMaxDate;

  /// Initial Hijri date to be selected (only used when useHijriDates is true)
  ///
  /// This date should be provided when useHijriDates is true
  final HijriDate? hijriInitialDate;

  ///controll the date jump
  ///
  /// ```dart
  /// jumpPre()
  /// Jump scoll calender to left
  ///
  /// jumpNext()
  /// Jump calender to right date
  /// ```

  HorizontalWeekCalendar({
    super.key,
    this.onDateChange,
    this.onWeekChange,
    this.activeBackgroundColor,
    this.controller,
    this.inactiveBackgroundColor,
    this.disabledBackgroundColor = Colors.grey,
    this.activeTextColor = Colors.white,
    this.inactiveTextColor = Colors.white,
    this.disabledTextColor = Colors.white,
    this.activeNavigatorColor,
    this.inactiveNavigatorColor,
    this.monthColor,
    this.weekStartFrom = WeekStartFrom.monday,
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
    this.scrollPhysics = const ClampingScrollPhysics(),
    this.showNavigationButtons = true,
    this.monthFormat,
    required this.minDate,
    required this.maxDate,
    required this.initialDate,
    this.showTopNavbar = true,
    this.carouselHeight,
    this.itemMarginHorizontal,
    this.itemBorderColor,
    this.translateNumbers = false,
    this.languageCode = 'en',
    this.customDayNames,
    this.customMonthNames,
    this.dayTextStyle,
    this.dayNameTextStyle,
    this.monthTextStyle,
    this.showGregorianUnderHijri = false,
    this.gregorianDayFormat = 'd',
    this.gregorianDayTextStyle,
    this.gregorianDayOpacity = 0.6,
    this.useHijriDates = false,
    this.hijriMinDate,
    this.hijriMaxDate,
    this.hijriInitialDate,
  })  :
        // Gregorian calendar validations
        assert(minDate.isBefore(maxDate)),
        assert(
            minDate.isBefore(initialDate) && (initialDate).isBefore(maxDate)),
        // Hijri calendar validations
        assert(
            !useHijriDates ||
                (hijriMinDate != null &&
                    hijriMaxDate != null &&
                    hijriInitialDate != null),
            'When useHijriDates is true, hijriMinDate, hijriMaxDate, and hijriInitialDate must be provided'),
        super();

  @override
  State<HorizontalWeekCalendar> createState() => _HorizontalWeekCalendarState();
}

class _HorizontalWeekCalendarState extends State<HorizontalWeekCalendar> {
  late final CarouselController carouselController;

  final int _initialPage = 1;
  int _lastLeadingIndex = 1;
  double _cachedItemExtent = 0;

  DateTime today = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<DateTime> currentWeek = [];
  int currentWeekIndex = 0;

  List<List<DateTime>> listOfWeeks = [];

  HijriDate dateTimeToHijri(DateTime date) {
    return HijriDate.fromDate(date);
  }

  // Get day index based on week start from
  int getDayIndex(DateTime date, WeekStartFrom weekStartFrom) {
    int weekday = date.weekday; // 1 = Monday, 7 = Sunday
    switch (weekStartFrom) {
      case WeekStartFrom.monday:
        return (weekday - 1) % 7;
      case WeekStartFrom.sunday:
        return weekday % 7;
      case WeekStartFrom.friday:
        return (weekday - 5) % 7;
    }
  }

  // Get adjusted day names based on week start from
  List<String>? getAdjustedDayNames() {
    if (widget.customDayNames == null || widget.customDayNames!.length != 7) {
      return null;
    }
    int startIndex;
    switch (widget.weekStartFrom ?? WeekStartFrom.monday) {
      case WeekStartFrom.sunday:
        startIndex = 0;
        break;
      case WeekStartFrom.monday:
        startIndex = 1;
        break;
      case WeekStartFrom.friday:
        startIndex = 5;
        break;
    }
    return widget.customDayNames!.sublist(startIndex) +
        widget.customDayNames!.sublist(0, startIndex);
  }

  // Helper functions for Hijri calendar
  String getHijriDayName(DateTime date) {
    int dayIndex =
        getDayIndex(date, widget.weekStartFrom ?? WeekStartFrom.monday);

    // Use adjusted custom day names if provided
    List<String>? adjustedDayNames = getAdjustedDayNames();
    if (adjustedDayNames != null) {
      return adjustedDayNames[dayIndex];
    }

    // Fallback to adjusted default Arabic names
    final List<String> arabicDayNames = [
      'الأحد', // 0
      'الإثنين', // 1
      'الثلاثاء', // 2
      'الأربعاء', // 3
      'الخميس', // 4
      'الجمعة', // 5
      'السبت' // 6
    ];
    int startIndex;
    switch (widget.weekStartFrom ?? WeekStartFrom.monday) {
      case WeekStartFrom.sunday:
        startIndex = 0;
        break;
      case WeekStartFrom.monday:
        startIndex = 1;
        break;
      case WeekStartFrom.friday:
        startIndex = 5;
        break;
    }
    List<String> adjustedArabic = arabicDayNames.sublist(startIndex) +
        arabicDayNames.sublist(0, startIndex);
    return adjustedArabic[dayIndex];
  }

  String getHijriMonthName(HijriDate hijriDate) {
    // Use custom month names if provided
    if (widget.customMonthNames != null &&
        widget.customMonthNames!.length == 12) {
      return widget.customMonthNames![hijriDate.hMonth - 1];
    }

    // Fallback to default Arabic names
    final List<String> arabicMonthNames = [
      'محرم',
      'صفر',
      'ربيع الأول',
      'ربيع الآخر',
      'جمادى الأولى',
      'جمادى الآخرة',
      'رجب',
      'شعبان',
      'رمضان',
      'شوال',
      'ذو القعدة',
      'ذو الحجة'
    ];
    return arabicMonthNames[hijriDate.hMonth - 1];
  }

  @override
  void initState() {
    carouselController = CarouselController(initialItem: _initialPage);
    _lastLeadingIndex = _initialPage;
    initCalender();
    super.initState();
  }

  @override
  void didUpdateWidget(HorizontalWeekCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);

    bool datesChanged = false;

    if (widget.useHijriDates) {
      datesChanged = oldWidget.hijriInitialDate?.hDay !=
              widget.hijriInitialDate?.hDay ||
          oldWidget.hijriInitialDate?.hMonth !=
              widget.hijriInitialDate?.hMonth ||
          oldWidget.hijriInitialDate?.hYear != widget.hijriInitialDate?.hYear;
    } else {
      datesChanged = oldWidget.initialDate != widget.initialDate;
    }

    if (datesChanged) {
      currentWeek.clear();
      listOfWeeks.clear();
      currentWeekIndex = 0;
      initCalender();
    }
  }

  DateTime getDate(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Get the effective initial date based on calendar type
  DateTime getEffectiveInitialDate() {
    if (widget.useHijriDates) {
      return widget.hijriInitialDate!.hijriToGregorian(
        widget.hijriInitialDate!.hYear,
        widget.hijriInitialDate!.hMonth,
        widget.hijriInitialDate!.hDay,
      );
    }
    return widget.initialDate;
  }

  /// Get the effective min date based on calendar type
  DateTime getEffectiveMinDate() {
    if (widget.useHijriDates) {
      return widget.hijriMinDate!.hijriToGregorian(
        widget.hijriMinDate!.hYear,
        widget.hijriMinDate!.hMonth,
        widget.hijriMinDate!.hDay,
      );
    }
    return widget.minDate;
  }

  /// Get the effective max date based on calendar type
  DateTime getEffectiveMaxDate() {
    if (widget.useHijriDates) {
      return widget.hijriMaxDate!.hijriToGregorian(
        widget.hijriMaxDate!.hYear,
        widget.hijriMaxDate!.hMonth,
        widget.hijriMaxDate!.hDay,
      );
    }
    return widget.maxDate;
  }

  initCalender() {
    final date = getEffectiveInitialDate();
    selectedDate = getEffectiveInitialDate();

    DateTime startOfCurrentWeek;

    WeekStartFrom effectiveWeekStart =
        widget.weekStartFrom ?? WeekStartFrom.monday;
    switch (effectiveWeekStart) {
      case WeekStartFrom.monday:
        startOfCurrentWeek =
            getDate(date.subtract(Duration(days: date.weekday - 1)));
        break;
      case WeekStartFrom.sunday:
        startOfCurrentWeek =
            getDate(date.subtract(Duration(days: date.weekday % 7)));
        break;
      case WeekStartFrom.friday:
        // Friday is weekday 5, we need to calculate days back to Friday
        // weekday: 1=Monday, 2=Tuesday, 3=Wednesday, 4=Thursday, 5=Friday, 6=Saturday, 7=Sunday
        int daysBackToFriday;
        if (date.weekday >= 5) {
          // If today is Friday, Saturday, or Sunday
          daysBackToFriday = date.weekday - 5;
        } else {
          // If today is Monday-Thursday, go back to previous Friday
          daysBackToFriday = date.weekday + 2;
        }
        startOfCurrentWeek =
            getDate(date.subtract(Duration(days: daysBackToFriday)));
        break;
    }

    currentWeek.add(startOfCurrentWeek);
    for (int index = 0; index < 6; index++) {
      DateTime addDate = startOfCurrentWeek.add(Duration(days: (index + 1)));
      currentWeek.add(addDate);
    }

    listOfWeeks.add(currentWeek);

    _getMorePreviousWeeks();

    _getMoreNextWeeks();

    if (widget.controller != null) {
      widget.controller!._stateChangerPre.addListener(() {
        log("previous");
        _onBackClick();
      });

      widget.controller!._stateChangerNex.addListener(() {
        log("next");
        _onNextClick();
      });
    }
  }

  _getMorePreviousWeeks() {
    List<DateTime> minus7Days = [];
    DateTime startFrom = listOfWeeks[currentWeekIndex].first;

    bool canAdd = false;
    for (int index = 0; index < 7; index++) {
      DateTime minusDate = startFrom.add(Duration(days: -(index + 1)));
      minus7Days.add(minusDate);
      // if (widget.minDate != null) {
      if (minusDate
          .add(const Duration(days: 1))
          .isAfter(getEffectiveMinDate())) {
        canAdd = true;
      }
      // } else {
      //   canAdd = true;
      // }
    }
    if (canAdd == true) {
      listOfWeeks.add(minus7Days.reversed.toList());
    }
    setState(() {});
  }

  _getMoreNextWeeks() {
    List<DateTime> plus7Days = [];
    // DateTime startFrom = currentWeek.last;
    DateTime startFrom = listOfWeeks[currentWeekIndex].last;

    // bool canAdd = false;
    // int newCurrentWeekIndex = 1;
    for (int index = 0; index < 7; index++) {
      DateTime addDate = startFrom.add(Duration(days: (index + 1)));
      plus7Days.add(addDate);
      // if (widget.maxDate != null) {
      //   if (addDate.isBefore(widget.maxDate!)) {
      //     canAdd = true;
      //     newCurrentWeekIndex = 1;
      //   } else {
      //     newCurrentWeekIndex = 0;
      //   }
      // } else {
      //   canAdd = true;
      //   newCurrentWeekIndex = 1;
      // }
    }
    // log("canAdd: $canAdd");
    // log("newCurrentWeekIndex: $newCurrentWeekIndex");

    // if (canAdd == true) {
    listOfWeeks.insert(0, plus7Days);
    // }
    currentWeekIndex = 1;
    setState(() {});
  }

  _onDateSelect(DateTime date) {
    setState(() {
      selectedDate = date;
    });
    widget.onDateChange?.call(selectedDate);
  }

  _onBackClick() {
    _scrollToIndex(currentWeekIndex + 1);
  }

  _onNextClick() {
    _scrollToIndex(currentWeekIndex - 1);
  }

  void _scrollToIndex(int index, {bool animate = true}) {
    if (!carouselController.hasClients || listOfWeeks.isEmpty) {
      return;
    }
    final int targetIndex = index.clamp(0, listOfWeeks.length - 1);
    if (animate) {
      carouselController.animateToItem(
        targetIndex,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
      );
    } else if (_cachedItemExtent > 0) {
      final double targetPixels = targetIndex * _cachedItemExtent;
      carouselController.jumpTo(targetPixels);
    }
  }

  onWeekChange(index) {
    if (currentWeekIndex < index) {
      // on back
    }
    if (currentWeekIndex > index) {
      // on next
    }

    currentWeekIndex = index;
    currentWeek = listOfWeeks[currentWeekIndex];

    if (currentWeekIndex + 1 == listOfWeeks.length) {
      _getMorePreviousWeeks();
    }

    if (index == 0) {
      _getMoreNextWeeks();
      _scrollToIndex(1, animate: false);
    }

    widget.onWeekChange?.call(currentWeek);
    setState(() {});
  }

  // =================

  bool _isReachMinimum(DateTime dateTime) {
    return getEffectiveMinDate()
        .add(const Duration(days: -1))
        .isBefore(dateTime);
  }

  bool _isReachMaximum(DateTime dateTime) {
    return getEffectiveMaxDate().add(const Duration(days: 1)).isAfter(dateTime);
  }

  bool _isNextDisabled() {
    DateTime lastDate = listOfWeeks[currentWeekIndex].last;
    // if (widget.maxDate != null) {
    String lastDateFormatted = DateFormat('yyyy/MM/dd').format(lastDate);
    String maxDateFormatted =
        DateFormat('yyyy/MM/dd').format(getEffectiveMaxDate());
    if (lastDateFormatted == maxDateFormatted) return true;
    // }

    bool isAfter =
        // widget.maxDate == null ? false :
        lastDate.isAfter(getEffectiveMaxDate());

    return isAfter;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  bool isBackDisabled() {
    DateTime firstDate = listOfWeeks[currentWeekIndex].first;
    // if (widget.minDate != null) {
    String firstDateFormatted = DateFormat('yyyy/MM/dd').format(firstDate);
    String minDateFormatted =
        DateFormat('yyyy/MM/dd').format(getEffectiveMinDate());
    if (firstDateFormatted == minDateFormatted) return true;
    // }

    bool isBefore =
        // widget.minDate == null ? false :
        firstDate.isBefore(getEffectiveMinDate());

    return isBefore;
    // return listOfWeeks[currentWeekIndex].last.isBefore(DateTime.now());
  }

  isCurrentYear() {
    if (widget.useHijriDates) {
      return dateTimeToHijri(currentWeek.first).hYear ==
          dateTimeToHijri(today).hYear;
    } else {
      return currentWeek.first.year == today.year;
    }
  }

  /// Get month display text based on calendar type
  String getMonthDisplayText() {
    if (widget.monthFormat?.isNotEmpty == true) {
      return DateFormat(widget.monthFormat).format(currentWeek.first);
    }

    if (widget.useHijriDates) {
      // Use Hijri calendar
      if (isCurrentYear()) {
        return getHijriMonthName(dateTimeToHijri(currentWeek.first));
      } else {
        final hijriDate = dateTimeToHijri(currentWeek.first);
        final yearText = widget.translateNumbers
            ? "${hijriDate.hYear}".convertNumbers(widget.languageCode)
            : "${hijriDate.hYear}";
        return "${getHijriMonthName(hijriDate)} $yearText";
      }
    } else {
      // Use Gregorian calendar
      if (isCurrentYear()) {
        return DateFormat('MMMM').format(currentWeek.first);
      } else {
        final yearText = widget.translateNumbers
            ? "${currentWeek.first.year}".convertNumbers(widget.languageCode)
            : "${currentWeek.first.year}";
        return "${DateFormat('MMMM').format(currentWeek.first)} $yearText";
      }
    }
  }

  /// Get day number display text based on calendar type
  String getDayDisplayText(DateTime date) {
    String dayText;
    if (widget.useHijriDates) {
      dayText = "${dateTimeToHijri(date).hDay}";
    } else {
      dayText = "${date.day}";
    }

    return widget.translateNumbers
        ? dayText.convertNumbers(widget.languageCode)
        : dayText;
  }

  String getGregorianDayDisplayText(DateTime date) {
    final String dayText = DateFormat(widget.gregorianDayFormat).format(date);
    return widget.translateNumbers
        ? dayText.convertNumbers(widget.languageCode)
        : dayText;
  }

  /// Get day name display text based on calendar type
  String getDayNameDisplayText(DateTime date) {
    // If custom day names are provided, use them regardless of calendar type
    List<String>? adjustedDayNames = getAdjustedDayNames();
    if (adjustedDayNames != null) {
      int dayIndex =
          getDayIndex(date, widget.weekStartFrom ?? WeekStartFrom.monday);
      return adjustedDayNames[dayIndex];
    }

    if (widget.useHijriDates) {
      return getHijriDayName(date);
    } else {
      return DateFormat('E').format(date);
    }
  }

  @override
  void dispose() {
    carouselController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    // var withOfScreen = MediaQuery.of(context).size.width;

    // double boxHeight = withOfScreen / 7;

    return currentWeek.isEmpty
        ? const SizedBox()
        : Column(
            children: [
              if (widget.showTopNavbar)
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: isBackDisabled()
                                ? null
                                : () {
                                    _onBackClick();
                                  },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.arrow_back_ios_new,
                                  size: 17,
                                  color: isBackDisabled()
                                      ? (widget.inactiveNavigatorColor ??
                                          Colors.grey)
                                      : theme.primaryColor,
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Text(
                                  "Back",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: isBackDisabled()
                                        ? (widget.inactiveNavigatorColor ??
                                            Colors.grey)
                                        : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                    Text(
                      getMonthDisplayText(),
                      style: (widget.monthTextStyle ??
                              theme.textTheme.titleMedium!)
                          .copyWith(
                        fontWeight: FontWeight.bold,
                        color: widget.monthColor ?? theme.primaryColor,
                      ),
                    ),
                    widget.showNavigationButtons == true
                        ? GestureDetector(
                            onTap: _isNextDisabled()
                                ? null
                                : () {
                                    _onNextClick();
                                  },
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Next",
                                  style: theme.textTheme.bodyLarge!.copyWith(
                                    color: _isNextDisabled()
                                        ? (widget.inactiveNavigatorColor ??
                                            Colors.grey)
                                        : theme.primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(
                                  width: 4,
                                ),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 17,
                                  color: _isNextDisabled()
                                      ? (widget.inactiveNavigatorColor ??
                                          Colors.grey)
                                      : theme.primaryColor,
                                ),
                              ],
                            ),
                          )
                        : const SizedBox(),
                  ],
                ),
              if (widget.showTopNavbar) const SizedBox(height: 12),
              SizedBox(
                height: widget.carouselHeight ?? 75,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final scrollBehavior = ScrollConfiguration.of(context)
                        .copyWith(physics: widget.scrollPhysics);
                    final double itemExtent = constraints.maxWidth;
                    return ScrollConfiguration(
                      behavior: scrollBehavior,
                      child: NotificationListener<ScrollNotification>(
                        onNotification: (notification) {
                          if (notification.metrics.axis != Axis.horizontal) {
                            return false;
                          }
                          _cachedItemExtent =
                              notification.metrics.viewportDimension;
                          if (_cachedItemExtent <= 0) {
                            return false;
                          }
                          final int leadingIndex =
                              (notification.metrics.pixels / _cachedItemExtent)
                                  .round();
                          if (leadingIndex != _lastLeadingIndex) {
                            _lastLeadingIndex = leadingIndex;
                            onWeekChange(leadingIndex);
                          }
                          return false;
                        },
                        child: CarouselView(
                          controller: carouselController,
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.zero,
                          ),
                          itemClipBehavior: Clip.none,
                          enableSplash: false,
                          itemSnapping: true,
                          shrinkExtent: itemExtent,
                          itemExtent: itemExtent,
                          reverse: true,
                          children: [
                            if (listOfWeeks.isNotEmpty)
                              for (int ind = 0; ind < listOfWeeks.length; ind++)
                                SizedBox(
                                  width: double.infinity,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      for (int weekIndex = 0;
                                          weekIndex < listOfWeeks[ind].length;
                                          weekIndex++)
                                        Builder(builder: (_) {
                                          DateTime currentDate =
                                              listOfWeeks[ind][weekIndex];
                                          final bool isSelected =
                                              DateFormat('dd-MM-yyyy')
                                                      .format(currentDate) ==
                                                  DateFormat('dd-MM-yyyy')
                                                      .format(selectedDate);
                                          final bool isEnabled =
                                              _isReachMaximum(currentDate) &&
                                                  _isReachMinimum(currentDate);
                                          final Color dayColor = isSelected
                                              ? (widget.activeTextColor ??
                                                  Colors.white)
                                              : isEnabled
                                                  ? (widget.inactiveTextColor ??
                                                      Colors.white.withValues(
                                                          alpha: .2))
                                                  : (widget.disabledTextColor ??
                                                      Colors.white);
                                          final double secondaryOpacity = widget
                                              .gregorianDayOpacity
                                              .clamp(0.0, 1.0)
                                              .toDouble();
                                          final Color secondaryColor =
                                              dayColor.withValues(
                                            alpha:
                                                (dayColor.a * secondaryOpacity)
                                                    .clamp(0.0, 1.0),
                                          );
                                          final TextStyle baseGregorianStyle =
                                              widget.gregorianDayTextStyle ??
                                                  widget.dayTextStyle ??
                                                  theme.textTheme.bodyMedium!;
                                          final double baseSize =
                                              baseGregorianStyle.fontSize ??
                                                  theme.textTheme.bodyMedium!
                                                      .fontSize ??
                                                  14;
                                          final double gregorianSize =
                                              (baseSize - 2)
                                                  .clamp(10.0, 30.0)
                                                  .toDouble();
                                          final TextStyle gregorianStyle =
                                              baseGregorianStyle.copyWith(
                                            fontSize: gregorianSize,
                                            color: secondaryColor,
                                            fontWeight: FontWeight.w600,
                                          );
                                          return Expanded(
                                            child: GestureDetector(
                                              onTap: isEnabled
                                                  ? () {
                                                      _onDateSelect(
                                                        listOfWeeks[ind]
                                                            [weekIndex],
                                                      );
                                                    }
                                                  : null,
                                              child: Container(
                                                alignment: Alignment.center,
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: widget
                                                            .itemMarginHorizontal ??
                                                        2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      widget.borderRadius,
                                                  color: isSelected
                                                      ? widget.activeBackgroundColor ??
                                                          theme.primaryColor
                                                      : isEnabled
                                                          ? widget.inactiveBackgroundColor ??
                                                              theme.primaryColor
                                                                  .withValues(
                                                                      alpha: .2)
                                                          : widget.disabledBackgroundColor ??
                                                              Colors.grey,
                                                  border: Border.all(
                                                    color: widget
                                                            .itemBorderColor ??
                                                        theme
                                                            .scaffoldBackgroundColor,
                                                  ),
                                                ),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      getDayDisplayText(
                                                          currentDate),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: (widget
                                                                  .dayTextStyle ??
                                                              theme.textTheme
                                                                  .titleLarge!)
                                                          .copyWith(
                                                        color: dayColor,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    if (widget.useHijriDates &&
                                                        widget
                                                            .showGregorianUnderHijri)
                                                      const SizedBox(height: 2),
                                                    if (widget.useHijriDates &&
                                                        widget
                                                            .showGregorianUnderHijri)
                                                      Text(
                                                        getGregorianDayDisplayText(
                                                            currentDate),
                                                        textAlign:
                                                            TextAlign.center,
                                                        style: gregorianStyle,
                                                      ),
                                                    Text(
                                                      getDayNameDisplayText(
                                                          listOfWeeks[ind]
                                                              [weekIndex]),
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: (widget
                                                                  .dayNameTextStyle ??
                                                              theme.textTheme
                                                                  .bodyLarge!)
                                                          .copyWith(
                                                        color: dayColor,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        }),
                                    ],
                                  ),
                                ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}

class HorizontalWeekCalenderController {
  final ValueNotifier<int> _stateChangerPre = ValueNotifier<int>(0);
  final ValueNotifier<int> _stateChangerNex = ValueNotifier<int>(0);

  void jumpPre() {
    _stateChangerPre.value = _stateChangerPre.value + 1;
  }

  void jumpNext() {
    _stateChangerNex.value = _stateChangerNex.value + 1;
  }
}
