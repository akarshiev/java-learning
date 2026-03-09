# 06 - Date and Time API (Sana va Vaqt API)

## 6.1 - Legacy Date/Time API (Eski Sana/Vaqt API)

### Date Class (Java 1.0)

`Date` class'i - vaqtning ma'lum bir nuqtasini millisekund aniqligida ifodalaydi.

```java
import java.util.Date;

public class DateExample {
    public static void main(String[] args) {
        // 1. Hozirgi vaqt
        Date now = new Date();
        System.out.println("Current date: " + now);
        
        // 2. Specific timestamp bilan
        Date specific = new Date(1672531200000L); // 2023-01-01
        System.out.println("Specific date: " + specific);
        
        // 3. after/before comparison
        Date date1 = new Date();
        Date date2 = new Date(System.currentTimeMillis() + 1000);
        
        System.out.println("date1 after date2? " + date1.after(date2));
        System.out.println("date1 before date2? " + date1.before(date2));
        
        // 4. Comparison
        System.out.println("compareTo: " + date1.compareTo(date2));
    }
}
```

### Date Class Drawbacks (Kamchiliklari)

```java
public class DateDrawbacks {
    public static void main(String[] args) {
        
        // 1. Mutable (Thread-safe emas!)
        Date date = new Date();
        System.out.println("Original: " + date);
        
        date.setTime(0); // Mutable - o'zgartirish mumkin!
        System.out.println("Modified: " + date);
        
        // Multi-thread muammosi
        Date sharedDate = new Date();
        
        Runnable task = () -> {
            // Race condition!
            sharedDate.setTime(System.currentTimeMillis());
        };
        
        // 2. No internationalization
        // 1900-based year, month 0-based
        @SuppressWarnings("deprecation")
        Date badDate = new Date(2023 - 1900, 0, 1); // January 1, 2023
        System.out.println("Confusing: " + badDate);
        
        // 3. No timezone support
        // 4. Poor API design
        @SuppressWarnings("deprecation")
        int month = badDate.getMonth(); // 0 = January, deprecated
        @SuppressWarnings("deprecation")
        int year = badDate.getYear() + 1900; // Must add 1900
    }
}
```

### Calendar Class (Java 1.1)

`Calendar` - abstract class, vaqt va kalendar maydonlari orasida konvertatsiya qilish uchun.

```java
import java.util.Calendar;
import java.util.GregorianCalendar;

public class CalendarExample {
    public static void main(String[] args) {
        // 1. Calendar instance olish
        Calendar cal = Calendar.getInstance();
        System.out.println("Current: " + cal.getTime());
        
        // 2. Specific date o'rnatish
        Calendar specific = new GregorianCalendar(2023, Calendar.JANUARY, 15);
        System.out.println("Specific: " + specific.getTime());
        
        // 3. Fieldlarni olish
        int year = cal.get(Calendar.YEAR);
        int month = cal.get(Calendar.MONTH); // 0-based!
        int day = cal.get(Calendar.DAY_OF_MONTH);
        int hour = cal.get(Calendar.HOUR_OF_DAY);
        int minute = cal.get(Calendar.MINUTE);
        
        System.out.printf("Year: %d, Month: %d, Day: %d%n", year, month + 1, day);
        
        // 4. Manipulyatsiya
        cal.add(Calendar.DAY_OF_MONTH, 5); // 5 kun keyin
        System.out.println("After 5 days: " + cal.getTime());
        
        cal.add(Calendar.MONTH, -2); // 2 oy oldin
        System.out.println("2 months ago: " + cal.getTime());
        
        // 5. Rolling (field chegarasida qoladi)
        cal.roll(Calendar.DAY_OF_MONTH, 10); // Month o'zgarmaydi
    }
}
```

### Calendar Class Drawbacks

```java
public class CalendarDrawbacks {
    public static void main(String[] args) {
        
        // 1. Intuitive emas
        Calendar cal = Calendar.getInstance();
        
        // Month 0-based (JANUARY = 0)
        cal.set(2023, 0, 1); // January 1, 2023
        System.out.println("Date: " + cal.getTime());
        
        // Constants confusing
        cal.set(2023, Calendar.JANUARY, 32); // February 1!
        System.out.println("Auto-roll: " + cal.getTime());
        
        // 2. Mutable (thread-safe emas)
        Calendar shared = Calendar.getInstance();
        
        Runnable task = () -> {
            // Race condition!
            shared.set(Calendar.YEAR, 2024);
        };
        
        // 3. Memory wasting
        Calendar wasteful = Calendar.getInstance();
        // Many internal fields, arrays
        
        // 4. Type safety yo'q
        cal.set(Calendar.MONTH, 13); // No error, auto-rolls to next year!
        cal.set(Calendar.HOUR_OF_DAY, 25); // Auto-rolls!
    }
}
```

### SimpleDateFormat Class

`SimpleDateFormat` - date formatting va parsing uchun.

```java
import java.text.SimpleDateFormat;
import java.text.ParseException;
import java.util.Date;

public class SimpleDateFormatExample {
    public static void main(String[] args) {
        
        // 1. Formatting
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        String formatted = sdf.format(new Date());
        System.out.println("Formatted: " + formatted);
        
        // 2. Parsing
        try {
            Date parsed = sdf.parse("2023-12-01 14:30:00");
            System.out.println("Parsed: " + parsed);
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // 3. Different patterns
        SimpleDateFormat[] formats = {
            new SimpleDateFormat("dd/MM/yyyy"),
            new SimpleDateFormat("MMMM d, yyyy"),
            new SimpleDateFormat("EEE, d MMM yyyy HH:mm:ss Z"),
            new SimpleDateFormat("hh:mm a")
        };
        
        Date now = new Date();
        for (SimpleDateFormat format : formats) {
            System.out.println(format.format(now));
        }
        
        // ⚠️ WARNING: SimpleDateFormat is NOT thread-safe!
        SimpleDateFormat unsafe = new SimpleDateFormat("yyyy-MM-dd");
        
        // Multiple threads using same formatter = problems!
        Runnable task = () -> {
            try {
                // Race condition! May cause incorrect results or exceptions
                String result = unsafe.format(new Date());
                System.out.println(result);
            } catch (Exception e) {
                System.out.println("Thread-safety issue: " + e.getMessage());
            }
        };
    }
}
```

---

## 6.2 - Java 8 Time API

### Time API Xususiyatlari

Java 8 `java.time` package'i:

1. **Immutable** - Thread-safe
2. **Intuitive API** - Oson tushuniladigan metodlar
3. **Timezone support** - Full timezone support
4. **ISO standard** - ISO-8601 asosida
5. **Comprehensive** - Barcha use-cases uchun

### Main Classes

| Class | Description | Example |
|-------|-------------|---------|
| `LocalDate` | Date without time | 2023-12-01 |
| `LocalTime` | Time without date | 14:30:00 |
| `LocalDateTime` | Date and time | 2023-12-01T14:30:00 |
| `Instant` | Timestamp | 2023-12-01T09:30:00Z |
| `ZonedDateTime` | Date/time with timezone | 2023-12-01T19:30:00+05:00[Asia/Tashkent] |
| `Duration` | Time-based amount | PT2H (2 hours) |
| `Period` | Date-based amount | P2Y3M (2 years 3 months) |

### LocalDate

```java
import java.time.LocalDate;
import java.time.Month;
import java.time.DayOfWeek;
import java.time.temporal.ChronoUnit;

public class LocalDateExample {
    public static void main(String[] args) {
        
        // 1. of() - yaratish
        LocalDate date1 = LocalDate.of(2023, 12, 1);
        LocalDate date2 = LocalDate.of(2023, Month.DECEMBER, 1);
        System.out.println("Date: " + date1);
        
        // 2. now() - hozirgi sana
        LocalDate today = LocalDate.now();
        System.out.println("Today: " + today);
        
        // 3. parse() - string dan
        LocalDate parsed = LocalDate.parse("2023-12-01");
        System.out.println("Parsed: " + parsed);
        
        // 4. get() metodlari
        int year = today.getYear();
        int month = today.getMonthValue();
        int day = today.getDayOfMonth();
        DayOfWeek dayOfWeek = today.getDayOfWeek();
        int dayOfYear = today.getDayOfYear();
        
        System.out.printf("Year: %d, Month: %d, Day: %d%n", year, month, day);
        System.out.println("Day of week: " + dayOfWeek);
        System.out.println("Day of year: " + dayOfYear);
        
        // 5. with() - immutable setter
        LocalDate newYear = today.withYear(2024)
                                 .withMonth(1)
                                 .withDayOfMonth(1);
        System.out.println("New Year: " + newYear);
        
        // 6. plus/minus
        LocalDate nextWeek = today.plusWeeks(1);
        LocalDate nextMonth = today.plusMonths(1);
        LocalDate nextYear = today.plusYears(1);
        LocalDate yesterday = today.minusDays(1);
        
        System.out.println("Next week: " + nextWeek);
        System.out.println("Yesterday: " + yesterday);
        
        // 7. Comparison
        System.out.println("Is before? " + date1.isBefore(today));
        System.out.println("Is after? " + date1.isAfter(today));
        System.out.println("Is equal? " + date1.isEqual(today));
        
        // 8. Dates between
        long daysBetween = ChronoUnit.DAYS.between(date1, today);
        long monthsBetween = ChronoUnit.MONTHS.between(date1, today);
        System.out.println("Days between: " + daysBetween);
        System.out.println("Months between: " + monthsBetween);
    }
}
```

### LocalTime

```java
import java.time.LocalTime;
import java.time.temporal.ChronoUnit;

public class LocalTimeExample {
    public static void main(String[] args) {
        
        // 1. of() - yaratish
        LocalTime time1 = LocalTime.of(14, 30);
        LocalTime time2 = LocalTime.of(14, 30, 15);
        LocalTime time3 = LocalTime.of(14, 30, 15, 500_000_000); // nanos
        System.out.println("Time: " + time1);
        
        // 2. now() - hozirgi vaqt
        LocalTime now = LocalTime.now();
        System.out.println("Now: " + now);
        
        // 3. parse()
        LocalTime parsed = LocalTime.parse("14:30:15");
        System.out.println("Parsed: " + parsed);
        
        // 4. get() metodlari
        int hour = now.getHour();
        int minute = now.getMinute();
        int second = now.getSecond();
        int nano = now.getNano();
        
        System.out.printf("Hour: %d, Minute: %d, Second: %d%n", hour, minute, second);
        
        // 5. with()
        LocalTime noon = now.withHour(12)
                           .withMinute(0)
                           .withSecond(0)
                           .withNano(0);
        System.out.println("Noon: " + noon);
        
        // 6. plus/minus
        LocalTime later = now.plusHours(2)
                             .plusMinutes(30)
                             .plusSeconds(15);
        
        LocalTime earlier = now.minusHours(1)
                               .minusMinutes(30);
        
        System.out.println("Later: " + later);
        System.out.println("Earlier: " + earlier);
        
        // 7. Comparison
        System.out.println("Is before? " + time1.isBefore(now));
        System.out.println("Is after? " + time1.isAfter(now));
        
        // 8. Time between
        long hoursBetween = ChronoUnit.HOURS.between(time1, now);
        long minutesBetween = ChronoUnit.MINUTES.between(time1, now);
        System.out.println("Hours between: " + hoursBetween);
        System.out.println("Minutes between: " + minutesBetween);
    }
}
```

### LocalDateTime

```java
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.LocalTime;

public class LocalDateTimeExample {
    public static void main(String[] args) {
        
        // 1. of() - yaratish
        LocalDateTime dt1 = LocalDateTime.of(2023, 12, 1, 14, 30);
        LocalDateTime dt2 = LocalDateTime.of(2023, 12, 1, 14, 30, 15);
        System.out.println("DateTime: " + dt1);
        
        // 2. of with LocalDate and LocalTime
        LocalDate date = LocalDate.of(2023, 12, 1);
        LocalTime time = LocalTime.of(14, 30);
        LocalDateTime dt3 = LocalDateTime.of(date, time);
        System.out.println("Combined: " + dt3);
        
        // 3. now()
        LocalDateTime now = LocalDateTime.now();
        System.out.println("Now: " + now);
        
        // 4. parse()
        LocalDateTime parsed = LocalDateTime.parse("2023-12-01T14:30:15");
        System.out.println("Parsed: " + parsed);
        
        // 5. Conversion
        LocalDate datePart = now.toLocalDate();
        LocalTime timePart = now.toLocalTime();
        System.out.println("Date part: " + datePart);
        System.out.println("Time part: " + timePart);
        
        // 6. Manipulation
        LocalDateTime modified = now.plusDays(5)
                                    .minusHours(3)
                                    .withYear(2024)
                                    .withMinute(0);
        
        System.out.println("Modified: " + modified);
        
        // 7. Specific fields
        int dayOfYear = now.getDayOfYear();
        int hour = now.getHour();
        System.out.println("Day of year: " + dayOfYear);
        System.out.println("Hour: " + hour);
    }
}
```

### Instant (Timestamp)

```java
import java.time.Instant;
import java.time.Duration;
import java.time.temporal.ChronoUnit;

public class InstantExample {
    public static void main(String[] args) {
        
        // 1. now() - hozirgi timestamp
        Instant now = Instant.now();
        System.out.println("Instant now: " + now);
        
        // 2. ofEpochMilli - millisekundlardan
        Instant epoch = Instant.ofEpochMilli(0); // 1970-01-01T00:00:00Z
        Instant specific = Instant.ofEpochMilli(1672531200000L);
        System.out.println("Epoch: " + epoch);
        System.out.println("Specific: " + specific);
        
        // 3. parse()
        Instant parsed = Instant.parse("2023-12-01T09:30:00Z");
        System.out.println("Parsed: " + parsed);
        
        // 4. Manipulation
        Instant later = now.plusSeconds(3600)
                          .plusMillis(500)
                          .plusNanos(1000);
        
        Instant earlier = now.minus(2, ChronoUnit.HOURS);
        
        System.out.println("Later: " + later);
        System.out.println("Earlier: " + earlier);
        
        // 5. Conversion to/from epoch
        long epochMilli = now.toEpochMilli();
        long epochSecond = now.getEpochSecond();
        int nano = now.getNano();
        
        System.out.println("Epoch milli: " + epochMilli);
        System.out.println("Epoch second: " + epochSecond);
        
        // 6. Comparison
        System.out.println("Is after? " + later.isAfter(earlier));
        System.out.println("Is before? " + earlier.isBefore(later));
        
        // 7. Duration between
        Duration duration = Duration.between(earlier, later);
        System.out.println("Seconds between: " + duration.getSeconds());
        System.out.println("Nanos between: " + duration.toNanos());
    }
}
```

### ZonedDateTime (Timezones)

```java
import java.time.ZonedDateTime;
import java.time.ZoneId;
import java.time.ZoneOffset;
import java.time.LocalDateTime;
import java.util.Set;

public class ZonedDateTimeExample {
    public static void main(String[] args) {
        
        // 1. now() with system zone
        ZonedDateTime now = ZonedDateTime.now();
        System.out.println("System zone: " + now);
        
        // 2. Specific zone
        ZonedDateTime tashkent = ZonedDateTime.now(ZoneId.of("Asia/Tashkent"));
        ZonedDateTime newYork = ZonedDateTime.now(ZoneId.of("America/New_York"));
        ZonedDateTime tokyo = ZonedDateTime.now(ZoneId.of("Asia/Tokyo"));
        
        System.out.println("Tashkent: " + tashkent);
        System.out.println("New York: " + newYork);
        System.out.println("Tokyo: " + tokyo);
        
        // 3. of() with zone
        LocalDateTime local = LocalDateTime.of(2023, 12, 1, 14, 30);
        ZonedDateTime zoned = ZonedDateTime.of(local, ZoneId.of("Asia/Tashkent"));
        System.out.println("Zoned: " + zoned);
        
        // 4. Zone conversion
        ZonedDateTime inNewYork = zoned.withZoneSameInstant(ZoneId.of("America/New_York"));
        System.out.println("Same moment in NY: " + inNewYork);
        
        // 5. All available zones
        Set<String> allZones = ZoneId.getAvailableZoneIds();
        System.out.println("Total zones: " + allZones.size());
        
        // 6. ZoneOffset
        ZoneOffset offset = ZoneOffset.of("+05:00");
        System.out.println("Offset: " + offset);
        
        // 7. Get zone info
        ZoneId zone = tashkent.getZone();
        ZoneOffset offset2 = tashkent.getOffset();
        System.out.println("Zone: " + zone);
        System.out.println("Offset: " + offset2);
    }
}
```

### Duration va Period

```java
import java.time.Duration;
import java.time.Period;
import java.time.LocalDateTime;
import java.time.LocalDate;
import java.time.temporal.ChronoUnit;

public class DurationPeriodExample {
    public static void main(String[] args) {
        
        // ========== DURATION (Time-based) ==========
        
        // 1. of methods
        Duration d1 = Duration.ofHours(2);
        Duration d2 = Duration.ofMinutes(30);
        Duration d3 = Duration.of(5, ChronoUnit.HOURS);
        
        System.out.println("2 hours: " + d1);
        System.out.println("30 minutes: " + d2);
        
        // 2. between
        LocalDateTime start = LocalDateTime.of(2023, 12, 1, 10, 0);
        LocalDateTime end = LocalDateTime.of(2023, 12, 1, 15, 30);
        
        Duration between = Duration.between(start, end);
        System.out.println("Between: " + between);
        System.out.println("Hours: " + between.toHours());
        System.out.println("Minutes: " + between.toMinutes());
        System.out.println("Seconds: " + between.getSeconds());
        
        // 3. Manipulation
        Duration added = between.plusHours(1).plusMinutes(30);
        Duration subtracted = between.minusMinutes(15);
        
        System.out.println("Added: " + added.toHoursPart() + "h " + added.toMinutesPart() + "m");
        
        // ========== PERIOD (Date-based) ==========
        
        // 1. of methods
        Period p1 = Period.ofYears(2);
        Period p2 = Period.ofMonths(3);
        Period p3 = Period.of(1, 6, 15); // 1 year, 6 months, 15 days
        
        System.out.println("2 years: " + p1);
        System.out.println("1y 6m 15d: " + p3);
        
        // 2. between
        LocalDate date1 = LocalDate.of(2020, 1, 1);
        LocalDate date2 = LocalDate.of(2023, 12, 1);
        
        Period periodBetween = Period.between(date1, date2);
        System.out.println("Period between: " + periodBetween);
        System.out.println("Years: " + periodBetween.getYears());
        System.out.println("Months: " + periodBetween.getMonths());
        System.out.println("Days: " + periodBetween.getDays());
        System.out.println("Total months: " + periodBetween.toTotalMonths());
        
        // 3. Normalization
        Period p = Period.of(1, 14, 45); // 1 year, 14 months, 45 days
        Period normalized = p.normalized(); // 2 years, 2 months, 45 days
        System.out.println("Normalized: " + normalized);
        
        // 4. Plus/minus
        Period addedPeriod = p1.plusMonths(6).plusDays(10);
        System.out.println("Added: " + addedPeriod);
    }
}
```

### Formatting and Parsing

```java
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.Locale;

public class FormattingExample {
    public static void main(String[] args) {
        
        LocalDateTime now = LocalDateTime.now();
        
        // 1. Predefined formatters
        DateTimeFormatter isoDate = DateTimeFormatter.ISO_DATE;
        DateTimeFormatter isoDateTime = DateTimeFormatter.ISO_DATE_TIME;
        
        System.out.println("ISO Date: " + now.format(isoDate));
        System.out.println("ISO DateTime: " + now.format(isoDateTime));
        
        // 2. Localized formatters
        DateTimeFormatter full = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.FULL);
        DateTimeFormatter longFormat = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.LONG);
        DateTimeFormatter medium = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.MEDIUM);
        DateTimeFormatter shortFormat = DateTimeFormatter.ofLocalizedDateTime(FormatStyle.SHORT);
        
        System.out.println("Full: " + now.format(full));
        System.out.println("Long: " + now.format(longFormat));
        System.out.println("Medium: " + now.format(medium));
        System.out.println("Short: " + now.format(shortFormat));
        
        // 3. Custom patterns
        DateTimeFormatter[] formatters = {
            DateTimeFormatter.ofPattern("yyyy-MM-dd"),
            DateTimeFormatter.ofPattern("dd/MM/yyyy HH:mm"),
            DateTimeFormatter.ofPattern("MMMM d, yyyy 'at' h:mm a"),
            DateTimeFormatter.ofPattern("EEEE, MMMM d, yyyy"),
            DateTimeFormatter.ofPattern("hh:mm:ss a"),
            DateTimeFormatter.ofPattern("yyyy-MM-dd'T'HH:mm:ss.SSSZ")
        };
        
        for (DateTimeFormatter formatter : formatters) {
            System.out.println(formatter.format(now));
        }
        
        // 4. With locale
        DateTimeFormatter germanFormat = DateTimeFormatter
            .ofPattern("EEEE, d. MMMM yyyy")
            .withLocale(Locale.GERMAN);
        
        DateTimeFormatter frenchFormat = DateTimeFormatter
            .ofLocalizedDate(FormatStyle.FULL)
            .withLocale(Locale.FRENCH);
        
        System.out.println("German: " + now.format(germanFormat));
        System.out.println("French: " + now.format(frenchFormat));
        
        // 5. Parsing
        String dateStr = "2023-12-01 14:30:00";
        DateTimeFormatter parser = DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss");
        LocalDateTime parsed = LocalDateTime.parse(dateStr, parser);
        System.out.println("Parsed: " + parsed);
        
        // 6. lenient parsing
        DateTimeFormatter lenient = DateTimeFormatter
            .ofPattern("yyyy-MM-dd")
            .withLenient(); // "2023-02-30" -> March 2
    }
}
```

### Additional Value Types

```java
import java.time.*;

public class AdditionalTypesExample {
    public static void main(String[] args) {
        
        // 1. Month
        Month month = Month.DECEMBER;
        System.out.println("Month: " + month);
        System.out.println("Value: " + month.getValue());
        System.out.println("Max length: " + month.maxLength());
        System.out.println("Min length: " + month.minLength());
        
        // 2. DayOfWeek
        DayOfWeek dayOfWeek = DayOfWeek.MONDAY;
        System.out.println("Day: " + dayOfWeek);
        System.out.println("Value: " + dayOfWeek.getValue()); // 1-7
        System.out.println("Display name: " + dayOfWeek.getDisplayName(
            java.time.format.TextStyle.FULL, java.util.Locale.ENGLISH));
        
        // 3. Year
        Year year = Year.of(2023);
        System.out.println("Year: " + year);
        System.out.println("Is leap? " + year.isLeap());
        System.out.println("Length: " + year.length());
        
        // 4. YearMonth
        YearMonth yearMonth = YearMonth.of(2023, 12);
        System.out.println("YearMonth: " + yearMonth);
        System.out.println("Days in month: " + yearMonth.lengthOfMonth());
        System.out.println("Days in year: " + yearMonth.lengthOfYear());
        
        // 5. MonthDay (birthday)
        MonthDay birthday = MonthDay.of(12, 25);
        System.out.println("Birthday: " + birthday);
        
        Year currentYear = Year.now();
        LocalDate thisYearBirthday = birthday.atYear(currentYear.getValue());
        System.out.println("This year's birthday: " + thisYearBirthday);
        
        // Check if today is birthday
        MonthDay today = MonthDay.now();
        System.out.println("Is birthday today? " + today.equals(birthday));
        
        // 6. OffsetTime
        OffsetTime offsetTime = OffsetTime.of(14, 30, 0, 0, ZoneOffset.ofHours(5));
        System.out.println("OffsetTime: " + offsetTime);
        System.out.println("Hour: " + offsetTime.getHour());
        System.out.println("Offset: " + offsetTime.getOffset());
        
        // 7. OffsetDateTime
        OffsetDateTime offsetDateTime = OffsetDateTime.of(
            LocalDate.of(2023, 12, 1),
            LocalTime.of(14, 30),
            ZoneOffset.ofHours(5)
        );
        System.out.println("OffsetDateTime: " + offsetDateTime);
        
        // Convert to ZonedDateTime
        ZonedDateTime zoned = offsetDateTime.toZonedDateTime();
        System.out.println("To Zoned: " + zoned);
    }
}
```

### Comparison: Legacy vs Java 8 Time API

```java
public class ComparisonExample {
    public static void main(String[] args) {
        
        // ========== LEGACY API ==========
        
        // 1. Date - mutable, confusing
        @SuppressWarnings("deprecation")
        Date legacyDate = new Date(2023 - 1900, 0, 1); // January 1, 2023
        legacyDate.setMonth(1); // Mutable - can change!
        
        // 2. Calendar - mutable, heavy
        Calendar calendar = Calendar.getInstance();
        calendar.set(2023, Calendar.JANUARY, 1);
        calendar.add(Calendar.DAY_OF_MONTH, 5); // Mutable
        
        // 3. SimpleDateFormat - not thread-safe
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        // Can't use same instance across threads!
        
        // ========== JAVA 8 TIME API ==========
        
        // 1. LocalDate - immutable, thread-safe
        LocalDate java8Date = LocalDate.of(2023, 1, 1);
        // java8Date.setYear(2024); // No such method! Compile error
        
        LocalDate newDate = java8Date.plusDays(5); // Returns new instance
        System.out.println("Original: " + java8Date); // Still 2023-01-01
        System.out.println("New: " + newDate); // 2023-01-06
        
        // 2. DateTimeFormatter - immutable, thread-safe
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        // Can safely share across threads
        
        // 3. Clear API
        int month = java8Date.getMonthValue(); // 1-12, not 0-based
        int dayOfWeek = java8Date.getDayOfWeek().getValue(); // 1-7, Monday=1
    }
}
```

### Real-world Examples

```java
import java.time.*;
import java.time.temporal.TemporalAdjusters;
import java.util.Set;

public class RealWorldExamples {
    
    // 1. Calculate age
    public static int calculateAge(LocalDate birthDate) {
        return Period.between(birthDate, LocalDate.now()).getYears();
    }
    
    // 2. Next birthday
    public static LocalDate nextBirthday(MonthDay birthday) {
        LocalDate today = LocalDate.now();
        LocalDate thisYear = birthday.atYear(today.getYear());
        
        if (thisYear.isAfter(today)) {
            return thisYear;
        } else {
            return birthday.atYear(today.getYear() + 1);
        }
    }
    
    // 3. Working days between dates
    public static long workingDaysBetween(LocalDate start, LocalDate end) {
        long days = ChronoUnit.DAYS.between(start, end);
        long workingDays = 0;
        
        for (int i = 0; i <= days; i++) {
            LocalDate current = start.plusDays(i);
            DayOfWeek dow = current.getDayOfWeek();
            if (dow != DayOfWeek.SATURDAY && dow != DayOfWeek.SUNDAY) {
                workingDays++;
            }
        }
        return workingDays;
    }
    
    // 4. First day of month
    public static LocalDate firstDayOfMonth(LocalDate date) {
        return date.with(TemporalAdjusters.firstDayOfMonth());
    }
    
    // 5. Last day of month
    public static LocalDate lastDayOfMonth(LocalDate date) {
        return date.with(TemporalAdjusters.lastDayOfMonth());
    }
    
    // 6. Next Monday
    public static LocalDate nextMonday(LocalDate date) {
        return date.with(TemporalAdjusters.next(DayOfWeek.MONDAY));
    }
    
    // 7. Format for different locales
    public static String formatForLocale(LocalDateTime dateTime, Locale locale) {
        DateTimeFormatter formatter = DateTimeFormatter
            .ofLocalizedDateTime(FormatStyle.FULL, FormatStyle.SHORT)
            .withLocale(locale);
        return dateTime.format(formatter);
    }
    
    public static void main(String[] args) {
        LocalDate today = LocalDate.now();
        
        // Age calculation
        LocalDate birthDate = LocalDate.of(1995, 5, 15);
        System.out.println("Age: " + calculateAge(birthDate));
        
        // Next birthday
        MonthDay birthday = MonthDay.of(5, 15);
        System.out.println("Next birthday: " + nextBirthday(birthday));
        
        // Working days
        LocalDate start = LocalDate.of(2023, 12, 1);
        LocalDate end = LocalDate.of(2023, 12, 31);
        System.out.println("Working days: " + workingDaysBetween(start, end));
        
        // First/last day
        System.out.println("First day: " + firstDayOfMonth(today));
        System.out.println("Last day: " + lastDayOfMonth(today));
        
        // Next Monday
        System.out.println("Next Monday: " + nextMonday(today));
        
        // Format for locales
        LocalDateTime now = LocalDateTime.now();
        System.out.println("US: " + formatForLocale(now, Locale.US));
        System.out.println("French: " + formatForLocale(now, Locale.FRANCE));
        System.out.println("German: " + formatForLocale(now, Locale.GERMANY));
        
        // Timezone conversion
        ZonedDateTime inTashkent = ZonedDateTime.now(ZoneId.of("Asia/Tashkent"));
        ZonedDateTime inNewYork = inTashkent.withZoneSameInstant(ZoneId.of("America/New_York"));
        System.out.println("Tashkent: " + inTashkent);
        System.out.println("New York: " + inNewYork);
    }
}
```

---

## Tekshiruv Savollari

### Lesson 6.1 - Legacy Date/Time API
1. **Date class'ining kamchiliklari nimalar?**
2. **Calendar class'ining kamchiliklari nimalar?**
3. **SimpleDateFormat nima uchun thread-safe emas?**
4. **Legacy API'da sana va vaqt bilan ishlashning qanday muammolari bor?**

### Lesson 6.2 - Java 8 Time API
1. **Java 8 Time API'ning afzalliklari nimalar?**
2. **LocalDate, LocalTime va LocalDateTime o'rtasidagi farq?**
3. **Instant qachon ishlatiladi?**
4. **Duration va Period o'rtasidagi farq?**
5. **ZonedDateTime nima uchun kerak?**
6. **DateTimeFormatter qanday ishlatiladi?**
7. **MonthDay qanday holatlarda ishlatiladi?**

---

**Keyingi mavzu:** [Java I/O](./07%20-%20Input-Output%20Streams.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
