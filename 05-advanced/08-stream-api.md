# Stream API - To'liq Qo'llanma

## Stream API nima?

**Stream API** - Java 8 da qo'shilgan, ma'lumotlar to'plamlari (collections) ustida murakkab operatsiyalarni sodda va tushunarli qilib bajarish imkonini beradigan vosita.

Tasavvur qiling, sizda bir quti rangli qalamlar bor. Siz:
- Faqat qizil qalamlarni ajratmoqchisiz
- Ularni uzunligi bo'yicha saralamoqchisiz
- Eng uzun 5 tasini olmoqchisiz

Oddiy usulda: qutini ochasiz, har bir qalamni tekshirasiz, qizillarni alohida qutiga solasiz, keyin ularni o'lchaysiz, saralaysiz...

Stream API bilan: "Menga qizil qalamlarni ol, ularni uzunligi bo'yicha sarala va eng uzun 5 tasini qaytar" deysiz. Qanday qilib bajarilishi bilan shug'ullanmaysiz.

---

## Nima uchun Stream API kerak?

### 1. Kodni soddalashtirish

```java
// ❌ Streamsiz - nima bo'layotganini tushunish uchun kodni o'qish kerak
List<String> result = new ArrayList<>();
for (String name : names) {
    if (name != null && name.startsWith("A")) {
        result.add(name.toUpperCase());
    }
}
Collections.sort(result);

// ✅ Stream bilan - bir qarashda tushunasiz
List<String> result = names.stream()
    .filter(name -> name != null && name.startsWith("A"))
    .map(String::toUpperCase)
    .sorted()
    .toList();
```

### 2. Xatolarni kamaytirish

Stream'lar bilan ishlaganda:
- Index xatolari bo'lmaydi
- Off-by-one xatolari bo'lmaydi
- Concurrent modification xatolari bo'lmaydi

### 3. Parallel ishlash oson

```java
// Parallel ishlash - bir qator kod bilan
int sum = numbers.parallelStream()
    .filter(n -> n > 0)
    .mapToInt(n -> n)
    .sum();
```

### 4. Deklarativ yondashuv

**Imperativ (qanday qilishni aytamiz):**
"Men massivni aylanaman, har bir elementni tekshiraman, agar shart bajarilsa, uni ro'yxatga qo'shaman..."

**Deklarativ (nimani xohlaymizni aytamiz):**
"Menga shartga mos keladigan elementlarni ber"

---

## Stream qanday ishlaydi?

Stream'ni suv quvuriga o'xshatish mumkin:

```
Manba (Collection) 
    → [Filter] (faqat qizil to'plarni o'tkaz)
    → [Map] (har bir to'pni qayta ishlab, yangi narsa chiqar)
    → [Collect] (natijalarni yig'ib, yangi kolleksiya yarat)
```

Har bir bosqich:
1. **Source** - Ma'lumotlar qayerdan keladi? (List, Set, array, file)
2. **Intermediate operations** - Ma'lumotlar bilan nima qilamiz? (filtrlash, o'zgartirish)
3. **Terminal operation** - Natijani qanday olamiz? (yig'ish, hisoblash)

---

## Stream tushunchalari

### 1. Stream - bu ma'lumotlar oqimi

```java
// Collection - bu hovuzdagi suv (bir joyda turibdi)
List<String> names = Arrays.asList("Ali", "Vali", "Soli");

// Stream - bu quvurdan oqayotgan suv (bir martalik)
Stream<String> nameStream = names.stream();
```

### 2. Stream bir marta ishlatiladi

```java
Stream<String> stream = names.stream();
stream.forEach(System.out::println);
stream.forEach(System.out::println); // ERROR! Stream already consumed
```

Bu xuddi bir marta ichiladigan suvga o'xshaydi - bir marta oqizib bo'lgach, qayta ishlatib bo'lmaydi.

### 3. Stream manbani o'zgartirmaydi

```java
List<String> original = Arrays.asList("Ali", "Vali", "Soli");

original.stream()
    .map(String::toUpperCase)
    .forEach(System.out::println);

System.out.println(original); // [Ali, Vali, Soli] - o'zgarmadi!
```

Stream asl kolleksiyani o'zgartirmaydi, faqat uning ustida hisoblashlar bajaradi.

---

## Intermediate Operations (Oraliq operatsiyalar)

Oraliq operatsiyalar - "nimani xohlaymiz"ni aytadigan, lekin darhol bajarmaydigan operatsiyalar.

### filter() - Shart bo'yicha tanlash

```java
// filter - berilgan shartga mos keladigan elementlarni olib beradi
// Predicate qabul qiladi (shartni tekshiruvchi funksiya)

List<Employee> employees = getEmployees();

// 30 yoshdan katta xodimlar
Stream<Employee> over30 = employees.stream()
    .filter(emp -> emp.getAge() > 30);
// Bu yerda hech narsa bajarilmaydi! Faqat "rejalashtiriladi"
```

**Nima bo'lyapti?** Stream "eslab qoladi": "Menga faqat yoshi 30 dan katta bo'lgan xodimlarni ber". Lekin hali hech narsa hisoblanmadi.

### map() - O'zgartirish

```java
// map - har bir elementni olib, uni boshqa narsaga aylantiradi
// Function qabul qiladi (bir turni boshqa turga aylantiruvchi)

// Xodimlarning ismlarini olish
Stream<String> names = employees.stream()
    .filter(emp -> emp.getAge() > 30)
    .map(emp -> emp.getFullName());
```

**Nima bo'lyapti?** Stream endi "Menga 30 dan katta xodimlarning ismlarini ber" deb eslab qoldi. Hali hech narsa hisoblanmadi!

### sorted() - Saralash

```java
// sorted - elementlarni tartibga soladi

Stream<String> sortedNames = employees.stream()
    .filter(emp -> emp.getAge() > 30)
    .map(Employee::getFullName)
    .sorted(); // Alfavit bo'yicha saralaydi
```

**Muhim:** `sorted` barcha elementlarni ko'rishi kerak, shuning uchun u "stateful" operatsiya - hamma elementlarni eslab qolishi kerak.

### limit() va skip() - Cheklash

```java
// limit - faqat birinchi n ta elementni oladi
// skip - birinchi n ta elementni tashlab ketadi

Stream<String> top5 = employees.stream()
    .filter(emp -> emp.getAge() > 30)
    .map(Employee::getFullName)
    .sorted()
    .limit(5)  // Faqat birinchi 5 tasini ol
    .skip(2);  // Ulardan ham dastlabki 2 tasini tashla (3,4,5-chilar qoladi)
```

### distinct() - Takrorlanmas elementlar

```java
// distinct - faqat unikal elementlarni olib beradi

Stream<String> uniqueCountries = employees.stream()
    .map(Employee::getCountry)
    .distinct(); // Har bir mamlakat faqat bir marta
```

### peek() - Ko'zdan kechirish

```java
// peek - har bir elementni ko'rish imkonini beradi (debug uchun)

Stream<String> debugged = employees.stream()
    .peek(emp -> System.out.println("Before filter: " + emp))
    .filter(emp -> emp.getAge() > 30)
    .peek(emp -> System.out.println("After filter: " + emp))
    .map(Employee::getFullName)
    .peek(name -> System.out.println("After map: " + name));
```

**Nima uchun peek kerak?** Nima bo'layotganini tushunish uchun. Terminal operatsiyadan keyin natija ko'rinadi.

---

## Terminal Operations (Yakunlovchi operatsiyalar)

Terminal operatsiyalar - stream'ni "ishga tushiradigan", haqiqiy hisoblashlarni boshlaydigan operatsiyalar.

### forEach() - Har bir element uchun amal bajarish

```java
// forEach - har bir element bilan nimadir qilish

employees.stream()
    .filter(emp -> emp.getAge() < 18)
    .forEach(emp -> System.out.println(emp.getFullName() + " is minor"));
```

**Nima bo'lyapti?** Stream endi ishga tushdi. Yuqoridagi barcha rejalashtirilgan operatsiyalar bajariladi va natija konsolga chiqariladi.

### collect() - Natijalarni yig'ish

```java
// collect - stream elementlarini kolleksiyaga yig'adi

// List ga yig'ish
List<String> names = employees.stream()
    .filter(emp -> emp.getAge() > 30)
    .map(Employee::getFullName)
    .collect(Collectors.toList()); // Java 16+ da .toList() ham bor

// Set ga yig'ish
Set<String> countries = employees.stream()
    .map(Employee::getCountry)
    .collect(Collectors.toSet());

// Map ga yig'ish
Map<Integer, String> idToName = employees.stream()
    .collect(Collectors.toMap(
        Employee::getId,      // key ni olish
        Employee::getFullName // value ni olish
    ));
```

### count() - Elementlar soni

```java
// count - nechta element borligini hisoblaydi

long adultsCount = employees.stream()
    .filter(emp -> emp.getAge() >= 18)
    .count();

System.out.println("Kattalar soni: " + adultsCount);
```

### anyMatch(), allMatch(), noneMatch() - Shartlarni tekshirish

```java
// anyMatch - kamida bittasi shartga mos keladimi?
boolean hasAnyFemale = employees.stream()
    .anyMatch(emp -> "FEMALE".equals(emp.getGender()));

// allMatch - hammasi shartga mos keladimi?
boolean allAdults = employees.stream()
    .allMatch(emp -> emp.getAge() >= 18);

// noneMatch - hech biri shartga mos kelmaydimi?
boolean noMinors = employees.stream()
    .noneMatch(emp -> emp.getAge() < 18);
```

**Qanday ishlaydi?** Bu metodlar "short-circuiting" - shart bajarilishi bilan to'xtaydi. Masalan, `anyMatch` birinchi mos keladigan elementni topgach, qolganlarini tekshirmaydi.

### findFirst(), findAny() - Element topish

```java
// findFirst - birinchi elementni qaytaradi
Optional<Employee> firstFemale = employees.stream()
    .filter(emp -> "FEMALE".equals(emp.getGender()))
    .findFirst();

// findAny - ixtiyoriy elementni qaytaradi (parallel stream'da tezroq)
Optional<Employee> anyFemale = employees.parallelStream()
    .filter(emp -> "FEMALE".equals(emp.getGender()))
    .findAny();

// Optional bilan ishlash
firstFemale.ifPresent(emp -> 
    System.out.println("Topildi: " + emp.getFullName()));

// Agar topilmasa, default qiymat
Employee defaultEmp = firstFemale.orElse(new Employee());
```

### reduce() - Qisqartirish

```java
// reduce - barcha elementlarni bittaga "qisqartiradi"

// Yig'indi hisoblash
Optional<Integer> sum = numbers.stream()
    .reduce((a, b) -> a + b);

// Identity bilan (boshlang'ich qiymat)
int sumWithIdentity = numbers.stream()
    .reduce(0, (a, b) -> a + b); // 0 + 1 + 2 + ...

// Maksimum topish
Optional<Integer> max = numbers.stream()
    .reduce(Integer::max);

// String birlashtirish
Optional<String> combined = names.stream()
    .reduce((s1, s2) -> s1 + ", " + s2);
```

---

## Stream'ni nima uchun ishlatamiz?

### 1. Ma'lumotlarni filtrlash (Filter)

```java
// Eski usul - for loop va if
List<Employee> result = new ArrayList<>();
for (Employee emp : employees) {
    if (emp.getAge() > 30 && "Tashkent".equals(emp.getCity())) {
        result.add(emp);
    }
}

// Stream usuli - nima qilayotganingiz aniq
List<Employee> result = employees.stream()
    .filter(emp -> emp.getAge() > 30)
    .filter(emp -> "Tashkent".equals(emp.getCity()))
    .toList();
```

### 2. Ma'lumotlarni o'zgartirish (Map)

```java
// Xodimlar ro'yxatidan ismlar ro'yxatini olish
List<String> names = employees.stream()
    .map(Employee::getFullName)
    .toList();

// Xodimlarning yoshlarini olish
List<Integer> ages = employees.stream()
    .map(Employee::getAge)
    .toList();

// Har bir xodim haqida qisqa ma'lumot
List<String> descriptions = employees.stream()
    .map(emp -> emp.getFullName() + " (" + emp.getAge() + " yosh)")
    .toList();
```

### 3. Ma'lumotlarni guruhlash (Grouping)

```java
// Gender bo'yicha guruhlash
Map<String, List<Employee>> byGender = employees.stream()
    .collect(Collectors.groupingBy(Employee::getGender));

// Mamlakat bo'yicha xodimlar soni
Map<String, Long> countByCountry = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getCountry,
        Collectors.counting()
    ));

// Yosh oralig'i bo'yicha guruhlash
Map<String, List<Employee>> byAgeGroup = employees.stream()
    .collect(Collectors.groupingBy(emp -> {
        if (emp.getAge() < 18) return "Yosh";
        else if (emp.getAge() < 30) return "Yosh kattalar";
        else return "Kattalar";
    }));
```

### 4. Statistika hisoblash (Statistics)

```java
// O'rtacha yosh
double averageAge = employees.stream()
    .mapToInt(Employee::getAge)
    .average()
    .orElse(0);

// Eng yosh va eng keksa xodim
Optional<Employee> youngest = employees.stream()
    .min(Comparator.comparingInt(Employee::getAge));

Optional<Employee> oldest = employees.stream()
    .max(Comparator.comparingInt(Employee::getAge));

// To'liq statistika
IntSummaryStatistics stats = employees.stream()
    .mapToInt(Employee::getAge)
    .summaryStatistics();

System.out.println("Jami: " + stats.getCount());
System.out.println("O'rtacha: " + stats.getAverage());
System.out.println("Min: " + stats.getMin());
System.out.println("Max: " + stats.getMax());
System.out.println("Yig'indi: " + stats.getSum());
```

### 5. Ma'lumotlarni saralash (Sorting)

```java
// Yosh bo'yicha saralash (o'sish)
List<Employee> byAgeAsc = employees.stream()
    .sorted(Comparator.comparingInt(Employee::getAge))
    .toList();

// Yosh bo'yicha saralash (kamayish)
List<Employee> byAgeDesc = employees.stream()
    .sorted(Comparator.comparingInt(Employee::getAge).reversed())
    .toList();

// Ism bo'yicha saralash
List<Employee> byName = employees.stream()
    .sorted(Comparator.comparing(Employee::getFullName))
    .toList();

// Bir necha mezon bo'yicha saralash
List<Employee> sorted = employees.stream()
    .sorted(Comparator
        .comparing(Employee::getCountry)
        .thenComparingInt(Employee::getAge))
    .toList();
```

### 6. Eng kichik/katta qiymatlarni olish (Min/Max)

```java
// Eng katta yosh
int maxAge = employees.stream()
    .mapToInt(Employee::getAge)
    .max()
    .orElse(0);

// Eng uzun ism
Optional<String> longestName = employees.stream()
    .map(Employee::getFullName)
    .max(Comparator.comparingInt(String::length));

// Eng ko'p xodimli mamlakat
Optional<Map.Entry<String, Long>> mostEmployees = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getCountry,
        Collectors.counting()
    ))
    .entrySet().stream()
    .max(Map.Entry.comparingByValue());
```

---

## Stream ishlatishda muhim tushunchalar

### 1. Lazy evaluation (Kechiktirilgan hisoblash)

```java
Stream<String> stream = employees.stream()
    .filter(emp -> {
        System.out.println("Filter: " + emp.getFullName());
        return emp.getAge() > 30;
    })
    .map(emp -> {
        System.out.println("Map: " + emp.getFullName());
        return emp.getFullName();
    });

// Hech narsa chiqmaydi! Stream hali ishga tushmadi

stream.forEach(System.out::println); // ENDI ishlaydi
```

**Nima uchun lazy?** Samaradorlik uchun. Agar terminal operatsiya bo'lmasa, oraliq operatsiyalarni bajarishning ma'nosi yo'q.

### 2. Short-circuiting (Erta to'xtash)

```java
// limit() bilan - 1000000 ta element bo'lsa ham tez ishlaydi
Stream.iterate(1, n -> n + 1)
    .filter(n -> n % 2 == 0)
    .limit(10)  // Faqat 10 ta kerak, qolganini hisoblamaydi
    .forEach(System.out::println);

// findFirst() bilan - birinchi mos keladigan topilgach to'xtaydi
employees.stream()
    .filter(emp -> emp.getAge() > 50)
    .findFirst()  // Topilgach, qolganlarini tekshirmaydi
    .ifPresent(System.out::println);
```

### 3. Parallel streams

```java
// Parallel stream - bir necha yadrodan foydalanadi
long count = employees.parallelStream()
    .filter(emp -> emp.getAge() > 30)
    .count();

// Qachon ishlatish kerak?
// - Katta ma'lumotlar (>10,000 element)
// - CPU intensive operatsiyalar
// - Order muhim bo'lmaganda

// Qachon ishlatmaslik kerak?
// - Kichik ma'lumotlar
// - I/O operatsiyalar (fayl o'qish, network)
// - findFirst() kabi order muhim bo'lganda
```

---

## Oddiy misollar bilan tushunamiz

### Misol 1: Mevalar bilan ishlash

Tasavvur qiling, sizda mevalar ro'yxati bor:

```java
List<String> fruits = Arrays.asList(
    "olma", "banan", "apelsin", "anor", 
    "uzum", "olcha", "shaftoli", "gilos"
);

// 1. Faqat "a" harfi bilan boshlanadigan mevalarni toping
List<String> startsWithA = fruits.stream()
    .filter(fruit -> fruit.startsWith("a"))
    .toList();  // [olma, anor, olcha] (o'zbekchada 'a' bilan boshlanadi)

// 2. Meva nomlarini bosh harf bilan yozing
List<String> capitalized = fruits.stream()
    .map(fruit -> fruit.substring(0, 1).toUpperCase() + fruit.substring(1))
    .toList();  // [Olma, Banan, Apelsin, ...]

// 3. Eng uzun meva nomini toping
Optional<String> longest = fruits.stream()
    .max(Comparator.comparingInt(String::length));

// 4. 5 ta harfdan uzun mevalarni saralab, birinchi 3 tasini oling
List<String> result = fruits.stream()
    .filter(fruit -> fruit.length() > 5)
    .sorted()
    .limit(3)
    .toList();
```

### Misol 2: Talabalar bilan ishlash

```java
class Student {
    private String name;
    private int grade;
    private String group;
    
    // constructor, getters...
}

List<Student> students = getStudents();

// 1. 80 balldan yuqori olgan talabalar
List<Student> excellent = students.stream()
    .filter(s -> s.getGrade() > 80)
    .toList();

// 2. Har bir guruhdagi o'rtacha ball
Map<String, Double> avgByGroup = students.stream()
    .collect(Collectors.groupingBy(
        Student::getGroup,
        Collectors.averagingInt(Student::getGrade)
    ));

// 3. Eng yuqori ball olgan talaba
Optional<Student> bestStudent = students.stream()
    .max(Comparator.comparingInt(Student::getGrade));

// 4. Talabalarni baho bo'yicha saralash (yuqoridan pastga)
List<Student> sortedByGrade = students.stream()
    .sorted((s1, s2) -> Integer.compare(s2.getGrade(), s1.getGrade()))
    .toList();

// 5. "A" guruhidagi talabalarning ismlari
List<String> groupANames = students.stream()
    .filter(s -> "A".equals(s.getGroup()))
    .map(Student::getName)
    .toList();
```

### Misol 3: Ishchilar va maoshlar

```java
class Employee {
    private String name;
    private String department;
    private double salary;
    
    // constructor, getters...
}

List<Employee> employees = getEmployees();

// 1. Maoshi 1000$ dan yuqori bo'lgan ishchilar
List<Employee> highEarners = employees.stream()
    .filter(e -> e.getSalary() > 1000)
    .toList();

// 2. Har bir departamentdagi o'rtacha maosh
Map<String, Double> avgSalaryByDept = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getDepartment,
        Collectors.averagingDouble(Employee::getSalary)
    ));

// 3. Eng ko'p maosh oladigan 3 ta ishchi
List<Employee> top3 = employees.stream()
    .sorted((e1, e2) -> Double.compare(e2.getSalary(), e1.getSalary()))
    .limit(3)
    .toList();

// 4. Barcha ishchilarning umumiy maoshi
double totalSalary = employees.stream()
    .mapToDouble(Employee::getSalary)
    .sum();

// 5. Maoshi o'rtachadan yuqori bo'lgan ishchilar
double avgSalary = employees.stream()
    .mapToDouble(Employee::getSalary)
    .average()
    .orElse(0);

List<Employee> aboveAverage = employees.stream()
    .filter(e -> e.getSalary() > avgSalary)
    .toList();
```

---

## Stream vs Oddiy kod - solishtirish

### 1-topshiriq: 20 yoshdan katta ayollarning ismlarini alfavit bo'yicha saralab, birinchi 5 tasini olish

```java
// Oddiy kod
List<String> result = new ArrayList<>();
for (Employee emp : employees) {
    if (emp.getAge() > 20 && "FEMALE".equals(emp.getGender())) {
        result.add(emp.getFullName());
    }
}
Collections.sort(result);
List<String> finalResult = new ArrayList<>();
for (int i = 0; i < Math.min(5, result.size()); i++) {
    finalResult.add(result.get(i));
}

// Stream kodi
List<String> result = employees.stream()
    .filter(emp -> emp.getAge() > 20)
    .filter(emp -> "FEMALE".equals(emp.getGender()))
    .map(Employee::getFullName)
    .sorted()
    .limit(5)
    .toList();
```

Qaysi biri tushunarli? Stream kodi o'qiladi: "filter qil, filter qil, map qil, sort qil, limit qil, collect qil"

### 2-topshiriq: Har bir mamlakatdagi eng yosh ishchini topish

```java
// Oddiy kod - murakkab
Map<String, Employee> youngestByCountry = new HashMap<>();
for (Employee emp : employees) {
    String country = emp.getCountry();
    Employee current = youngestByCountry.get(country);
    if (current == null || emp.getAge() < current.getAge()) {
        youngestByCountry.put(country, emp);
    }
}

// Stream kodi - aniq
Map<String, Optional<Employee>> youngestByCountry = employees.stream()
    .collect(Collectors.groupingBy(
        Employee::getCountry,
        Collectors.minBy(Comparator.comparingInt(Employee::getAge))
    ));
```

---

## Xulosa

**Stream API** - bu ma'lumotlar bilan ishlashning yangi usuli. U:

1. **Nimani xohlaymiz**ni aytish imkonini beradi, **qanday qilish**ni emas
2. Kodni qisqa va tushunarli qiladi
3. Xatolarni kamaytiradi
4. Parallel ishlashni osonlashtiradi

**Esda tuting:**
- Stream bir marta ishlatiladi
- Stream manbani o'zgartirmaydi
- Stream lazy ishlaydi (terminal operatsiya kerak)
- Stream'lar collection'lar o'rnini bosmaydi, ular bilan birga ishlaydi

**Qachon ishlatish kerak?**
- Ma'lumotlarni filtrlashda
- Ma'lumotlarni o'zgartirishda
- Ma'lumotlarni guruhlashda
- Statistika hisoblashda
- Ma'lumotlarni saralashda

**Qachon ishlatmaslik kerak?**
- Juda oddiy operatsiyalarda (for loop yetarli bo'lsa)
- Exception handling kerak bo'lganda
- Kodni murakkablashtirsa (ba'zida oddiy kod tushunarliroq)

---

**Keyingi mavzu:** [Optional Class](./09-comparator-collectors.md)  
**[Mundarijaga qaytish](../README.md)**

> Stream API - bu vosita, asosiy maqsad - kodingizni tushunarli qilish! 🚀
