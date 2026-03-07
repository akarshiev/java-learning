# 11 - Stream API (Oqimlar API)

## Stream nima?

**Stream** - Java 8 ning eng muhim xususiyatlaridan biri bo'lib, ma'lumotlar bilan deklarativ usulda ishlash imkonini beradi. Stream - bu ma'lumotlar manbasidan (collection, array, generator) keladigan elementlar ketma-ketligi.

```java
// Imperative vs Declarative

// ❌ Imperative (qanday qilishni aytamiz)
List<String> result = new ArrayList<>();
for (String name : names) {
    if (name.startsWith("A")) {
        result.add(name.toUpperCase());
    }
}

// ✅ Declarative (nimani xohlaymizni aytamiz)
List<String> result = names.stream()
    .filter(name -> name.startsWith("A"))
    .map(String::toUpperCase)
    .toList();
```

### Stream'ning asosiy xususiyatlari

1. **No storage** - Ma'lumotlarni saqlamaydi, faqat hisoblashlarni bajaradi
2. **Functional in nature** - Stream operatsiyalari manbani o'zgartirmaydi
3. **Lazy execution** - Terminal operatsiya chaqirilguncha bajarilmaydi
4. **Possibly unbounded** - Cheksiz bo'lishi mumkin
5. **Consumable** - Bir marta ishlatiladi, qayta ishlatib bo'lmaydi

---

## 11.1 - Stream va Collection

### Stream vs Collection

| Xususiyat | Collection | Stream |
|-----------|------------|--------|
| **Ma'lumot saqlash** | Ha (fizik ma'lumotlar) | Yo'q (mantiqiy view) |
| **O'zgartirish** | O'zgartirish mumkin | O'zgartirmaydi |
| **Ishlash vaqti** | Eager (darhol) | Lazy (kechikkan) |
| **Cheksizlik** | Cheklangan | Cheksiz bo'lishi mumkin |
| **Qayta ishlatish** | Ko'p marta | Bir marta |

```java
public class StreamVsCollection {
    public static void main(String[] args) {
        List<String> collection = Arrays.asList("a", "b", "c");
        
        // Collection - ko'p marta ishlatish mumkin
        collection.forEach(System.out::println);
        collection.forEach(System.out::println);  // OK
        
        // Stream - bir marta ishlatiladi
        Stream<String> stream = collection.stream();
        stream.forEach(System.out::println);
        // stream.forEach(System.out::println);  // IllegalStateException!
        
        // Stream manbani o'zgartirmaydi
        Stream<String> upperStream = collection.stream()
            .map(String::toUpperCase);
        
        System.out.println(collection);  // [a, b, c] - o'zgarmadi
    }
}
```

---

## 11.2 - Stream manbalari (Sources)

### Stream yaratish usullari

```java
import java.util.stream.*;
import java.nio.file.*;
import java.util.*;

public class StreamSources {
    public static void main(String[] args) throws IOException {
        
        // 1. Collection dan
        List<String> list = Arrays.asList("a", "b", "c");
        Stream<String> stream1 = list.stream();
        Stream<String> parallelStream = list.parallelStream();
        
        // 2. Array dan
        int[] numbers = {1, 2, 3, 4, 5};
        IntStream stream2 = Arrays.stream(numbers);
        Stream<String> stream3 = Stream.of("a", "b", "c");
        
        // 3. Static factory metodlar
        IntStream range = IntStream.range(1, 10);      // 1-9
        IntStream rangeClosed = IntStream.rangeClosed(1, 10); // 1-10
        
        Stream<Integer> iterate = Stream.iterate(0, n -> n + 2)
            .limit(5);  // 0,2,4,6,8
        
        Stream<Double> generate = Stream.generate(Math::random)
            .limit(5);
        
        // 4. File dan
        Stream<String> lines = Files.lines(Paths.get("file.txt"));
        
        // 5. Random dan
        IntStream randomInts = new Random().ints(5, 1, 100);
        
        // 6. StringBuilder/BufferedReader dan
        String str = "hello\nworld";
        Stream<String> lines2 = str.lines();
        
        // 7. Pattern dan
        Stream<String> words = Pattern.compile(" ")
            .splitAsStream("Java Stream API");
    }
}
```

### Employee ma'lumotlari bilan ishlash

```java
// employees.json faylidan ma'lumotlarni o'qish
Path path = Path.of("employees.json");
String jsonData = Files.readString(path);
Gson gson = new Gson();
Type type = new TypeToken<List<Employee>>(){}.getType();
List<Employee> employees = gson.fromJson(jsonData, type);

// Employee class
@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
class Employee {
    private int id;
    private String full_name;
    private String gender;
    private int age;
    private String country;
}
```

---

## 11.3 - Stream operatsiyalari

### Intermediate vs Terminal operations

```
Source (Collection) 
    -> [Intermediate ops] (0..n) 
    -> [Terminal op] 
    -> Result
```

| Intermediate (Lazy) | Terminal (Eager) |
|---------------------|------------------|
| `filter()` | `forEach()` |
| `map()` | `collect()` |
| `flatMap()` | `toList()` |
| `distinct()` | `reduce()` |
| `sorted()` | `count()` |
| `limit()` | `anyMatch()` |
| `skip()` | `allMatch()` |
| `peek()` | `noneMatch()` |
| | `findFirst()` |
| | `findAny()` |
| | `min()`/`max()` |
| | `toArray()` |

---

## 11.4 - Filtrlash (Filtering)

### filter() - Predicate asosida filtrlash

```java
public class FilteringExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. Oddiy filter
        List<Employee> females = employees.stream()
            .filter(emp -> "FEMALE".equals(emp.getGender()))
            .toList();
        
        // 2. Mantiqiy operatorlar bilan
        Predicate<Employee> isFemale = emp -> "FEMALE".equals(emp.getGender());
        Predicate<Employee> isAdult = emp -> emp.getAge() > 18;
        Predicate<Employee> isFemaleAdult = isFemale.and(isAdult);
        
        List<Employee> femaleAdults = employees.stream()
            .filter(isFemaleAdult)
            .toList();
        
        // 3. Bir nechta filter
        List<Employee> result = employees.stream()
            .filter(emp -> emp.getAge() > 25)
            .filter(emp -> "MALE".equals(emp.getGender()))
            .filter(emp -> emp.getCountry().equals("uzb"))
            .toList();
        
        // 4. Predicate composition
        Predicate<Employee> ageRange = emp -> emp.getAge() >= 20 && emp.getAge() <= 30;
        Predicate<Employee> isUzbOrPak = emp -> 
            "uzb".equals(emp.getCountry()) || "pak".equals(emp.getCountry());
        
        employees.stream()
            .filter(ageRange.and(isUzbOrPak))
            .forEach(System.out::println);
    }
}
```

---

## 11.5 - Kesish (Truncating)

### limit() va skip()

```java
public class TruncatingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. limit - boshidan n ta element
        List<Employee> first10 = employees.stream()
            .limit(10)
            .toList();
        
        // 2. skip - boshidan n ta elementni tashlab ketish
        List<Employee> afterFirst10 = employees.stream()
            .skip(10)
            .limit(10)  // 11-20 gacha
            .toList();
        
        // 3. Pagination misoli
        int pageSize = 20;
        int pageNumber = 2;
        
        List<Employee> page = employees.stream()
            .skip((pageNumber - 1) * pageSize)
            .limit(pageSize)
            .toList();
        
        // 4. Cheksiz stream ni cheklash
        Stream.iterate(1, n -> n + 1)
            .filter(n -> n % 2 == 0)
            .limit(10)
            .forEach(System.out::println);
    }
}
```

---

## 11.6 - Iste'mol qilish (Consuming)

### peek() va forEach()

```java
public class ConsumingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. peek - intermediate, debugging uchun
        List<String> names = employees.stream()
            .peek(emp -> System.out.println("Original: " + emp))
            .filter(emp -> emp.getAge() > 25)
            .peek(emp -> System.out.println("After filter: " + emp))
            .map(Employee::getFull_name)
            .peek(name -> System.out.println("After map: " + name))
            .toList();
        
        // 2. forEach - terminal, har bir element uchun action
        employees.stream()
            .filter(emp -> emp.getAge() < 18)
            .forEach(emp -> 
                System.out.println(emp.getFull_name() + " is minor"));
        
        // 3. forEachOrdered - parallel stream'da tartibni saqlash
        employees.parallelStream()
            .forEachOrdered(System.out::println);
        
        // 4. peek bilan o'zgartirish (tavsiya etilmaydi!)
        List<Employee> modified = employees.stream()
            .peek(emp -> emp.setAge(emp.getAge() + 1))  // Side-effect!
            .toList();
        // ❌ Yomon - stream manbani o'zgartirmasligi kerak
    }
}
```

---

## 11.7 - Matching (Tekshirish)

### anyMatch(), allMatch(), noneMatch()

```java
public class MatchingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. anyMatch - kamida bitta element shartga mos keladimi?
        boolean hasAnyFemale = employees.stream()
            .anyMatch(emp -> "FEMALE".equals(emp.getGender()));
        
        boolean hasAnyMinor = employees.stream()
            .anyMatch(emp -> emp.getAge() < 18);
        
        // 2. allMatch - hamma elementlar shartga mos keladimi?
        boolean allAdults = employees.stream()
            .allMatch(emp -> emp.getAge() >= 18);
        
        boolean allHaveName = employees.stream()
            .allMatch(emp -> emp.getFull_name() != null);
        
        // 3. noneMatch - hech bir element shartga mos kelmaydimi?
        boolean noneUnder18 = employees.stream()
            .noneMatch(emp -> emp.getAge() < 18);
        
        boolean noneInvalid = employees.stream()
            .noneMatch(emp -> emp.getId() <= 0);
        
        // 4. Short-circuiting misoli
        boolean result = employees.stream()
            .peek(emp -> System.out.println("Checking: " + emp.getId()))
            .anyMatch(emp -> emp.getAge() > 30);
        // 30 dan katta topilgach, to'xtaydi
        
        // 5. Mantiqiy kombinatsiyalar
        Predicate<Employee> isFemale = emp -> "FEMALE".equals(emp.getGender());
        Predicate<Employee> isUzb = emp -> "uzb".equals(emp.getCountry());
        
        boolean anyFemaleUzb = employees.stream()
            .anyMatch(isFemale.and(isUzb));
    }
}
```

---

## 11.8 - Mapping (Akslantirish)

### map()

```java
public class MappingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. Oddiy map - bir turdan ikkinchi turga
        List<String> names = employees.stream()
            .map(Employee::getFull_name)
            .toList();
        
        List<Integer> ages = employees.stream()
            .map(Employee::getAge)
            .toList();
        
        // 2. Object yaratish
        record EmpInfo(String name, int age) {}
        
        List<EmpInfo> empInfos = employees.stream()
            .map(emp -> new EmpInfo(emp.getFull_name(), emp.getAge()))
            .toList();
        
        // 3. Primitive stream'larga map
        IntStream ageStream = employees.stream()
            .mapToInt(Employee::getAge);
        
        DoubleStream averageAge = employees.stream()
            .mapToDouble(Employee::getAge)
            .average()
            .stream();
        
        // 4. map bilan hisoblash
        int totalAge = employees.stream()
            .mapToInt(Employee::getAge)
            .sum();
        
        double avgAge = employees.stream()
            .mapToInt(Employee::getAge)
            .average()
            .orElse(0);
    }
}
```

### flatMap()

```java
public class FlatMapExample {
    public static void main(String[] args) {
        
        // 1. Stream of streams ni birlashtirish
        List<List<String>> listOfLists = Arrays.asList(
            Arrays.asList("a", "b", "c"),
            Arrays.asList("d", "e", "f"),
            Arrays.asList("g", "h", "i")
        );
        
        // map -> Stream<Stream<String>>
        Stream<Stream<String>> mapped = listOfLists.stream()
            .map(list -> list.stream());
        
        // flatMap -> Stream<String>
        Stream<String> flatMapped = listOfLists.stream()
            .flatMap(List::stream);
        
        // 2. Matn faylidagi so'zlar
        List<String> lines = Arrays.asList(
            "Hello world",
            "Java stream api",
            "flatMap example"
        );
        
        List<String> words = lines.stream()
            .flatMap(line -> Arrays.stream(line.split(" ")))
            .distinct()
            .toList();  // [Hello, world, Java, stream, api, flatMap, example]
        
        // 3. Ikki o'lchovli massiv
        int[][] matrix = {{1, 2}, {3, 4}, {5, 6}};
        
        int[] flattened = Arrays.stream(matrix)
            .flatMapToInt(Arrays::stream)
            .toArray();  // [1,2,3,4,5,6]
        
        // 4. Optional'lar bilan
        List<Optional<String>> optionals = Arrays.asList(
            Optional.of("a"),
            Optional.empty(),
            Optional.of("b"),
            Optional.of("c")
        );
        
        List<String> values = optionals.stream()
            .flatMap(Optional::stream)
            .toList();  // [a, b, c]
        
        // 5. Employee misoli - kitoblar
        record Book(String id, String name) {}
        
        List<Employee> employees = Arrays.asList(
            new Employee(1, "Ali", Arrays.asList(
                new Book("1", "Java"), 
                new Book("2", "Python"))),
            new Employee(2, "Vali", Arrays.asList(
                new Book("3", "SQL")))
        );
        
        List<Book> allBooks = employees.stream()
            .flatMap(emp -> emp.getBooks().stream())
            .distinct()
            .toList();
    }
}
```

---

## 11.9 - Finding (Topish)

### findFirst() va findAny()

```java
public class FindingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. findFirst - birinchi element
        Optional<Employee> first = employees.stream()
            .filter(emp -> emp.getAge() > 25)
            .findFirst();
        
        first.ifPresent(emp -> 
            System.out.println("First over 25: " + emp));
        
        // 2. findAny - ixtiyoriy element (parallel stream'da muhim)
        Optional<Employee> anyFemale = employees.parallelStream()
            .filter(emp -> "FEMALE".equals(emp.getGender()))
            .findAny();  // Parallel'da tezroq
        
        // 3. Optional bilan ishlash
        Employee result = employees.stream()
            .filter(emp -> emp.getAge() > 50)
            .findFirst()
            .orElse(new Employee());  // Default
        
        Employee result2 = employees.stream()
            .filter(emp -> emp.getAge() > 50)
            .findFirst()
            .orElseThrow(() -> new RuntimeException("No employee found"));
        
        // 4. ifPresentOrElse
        employees.stream()
            .filter(emp -> emp.getCountry().equals("uzb"))
            .findFirst()
            .ifPresentOrElse(
                emp -> System.out.println("Found: " + emp),
                () -> System.out.println("No Uzbek employee")
            );
    }
}
```

---

## 11.10 - Reducing (Qisqartirish)

### reduce()

```java
public class ReducingExample {
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
        
        // 1. Identity bilan reduce
        int sum = numbers.stream()
            .reduce(0, (a, b) -> a + b);  // 15
        
        int product = numbers.stream()
            .reduce(1, (a, b) -> a * b);  // 120
        
        // 2. Identity siz reduce (Optional qaytaradi)
        Optional<Integer> max = numbers.stream()
            .reduce(Integer::max);  // Optional[5]
        
        Optional<Integer> min = numbers.stream()
            .reduce(Integer::min);  // Optional[1]
        
        // 3. String concat
        List<String> words = Arrays.asList("Java", "Stream", "API");
        
        Optional<String> sentence = words.stream()
            .reduce((s1, s2) -> s1 + " " + s2);
        
        sentence.ifPresent(System.out::println);  // "Java Stream API"
        
        // 4. Employee misoli - eng yosh employee
        Optional<Employee> youngest = employees.stream()
            .reduce((e1, e2) -> e1.getAge() < e2.getAge() ? e1 : e2);
        
        // 5. Complex reduction
        Employee combined = employees.stream()
            .reduce(
                new Employee(0, "", "", 0, ""),  // identity
                (result, emp) -> {
                    result.setAge(result.getAge() + emp.getAge());
                    return result;
                },  // accumulator
                (r1, r2) -> {
                    r1.setAge(r1.getAge() + r2.getAge());
                    return r1;
                }  // combiner (parallel uchun)
            );
    }
}
```

---

## 11.11 - Collecting (Yig'ish)

### collect() bilan to'plash

```java
import java.util.stream.Collectors;

public class CollectingExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. toList() (Java 16+)
        List<String> names = employees.stream()
            .map(Employee::getFull_name)
            .toList();
        
        // 2. Collectors.toList()
        List<Employee> adults = employees.stream()
            .filter(emp -> emp.getAge() >= 18)
            .collect(Collectors.toList());
        
        // 3. toSet()
        Set<String> countries = employees.stream()
            .map(Employee::getCountry)
            .collect(Collectors.toSet());
        
        // 4. toMap()
        Map<Integer, String> idToName = employees.stream()
            .collect(Collectors.toMap(
                Employee::getId,
                Employee::getFull_name,
                (v1, v2) -> v1  // conflict resolver
            ));
        
        // 5. GroupingBy
        Map<String, List<Employee>> byGender = employees.stream()
            .collect(Collectors.groupingBy(Employee::getGender));
        
        // 6. PartitioningBy (boolean condition)
        Map<Boolean, List<Employee>> partitioned = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getAge() >= 18
            ));
        
        List<Employee> minors = partitioned.get(false);
        List<Employee> adults2 = partitioned.get(true);
        
        // 7. Counting
        Map<String, Long> countByGender = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getGender,
                Collectors.counting()
            ));
        
        // 8. Averaging
        Map<String, Double> avgAgeByGender = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getGender,
                Collectors.averagingInt(Employee::getAge)
            ));
        
        // 9. Joining
        String allNames = employees.stream()
            .map(Employee::getFull_name)
            .collect(Collectors.joining(", "));
        
        // 10. Summarizing
        IntSummaryStatistics stats = employees.stream()
            .collect(Collectors.summarizingInt(Employee::getAge));
        
        System.out.println("Count: " + stats.getCount());
        System.out.println("Sum: " + stats.getSum());
        System.out.println("Min: " + stats.getMin());
        System.out.println("Max: " + stats.getMax());
        System.out.println("Average: " + stats.getAverage());
    }
}
```

---

## 11.12 - Primitive Streams

### IntStream, LongStream, DoubleStream

```java
public class PrimitiveStreams {
    public static void main(String[] args) {
        
        // 1. IntStream yaratish
        IntStream intStream1 = IntStream.range(1, 10);      // 1-9
        IntStream intStream2 = IntStream.rangeClosed(1, 10); // 1-10
        IntStream intStream3 = IntStream.of(1, 2, 3, 4, 5);
        
        // 2. Max/Min/Sum/Average
        int max = IntStream.range(1, 100)
            .max()
            .orElse(0);
        
        int sum = IntStream.range(1, 100)
            .sum();
        
        double avg = IntStream.range(1, 100)
            .average()
            .orElse(0);
        
        // 3. Statistics
        IntSummaryStatistics stats = IntStream.range(1, 100)
            .summaryStatistics();
        
        // 4. Boxed - primitive stream'ni Stream<Integer> ga
        Stream<Integer> boxed = IntStream.range(1, 10)
            .boxed();
        
        // 5. mapToObj
        Stream<String> strings = IntStream.range(1, 5)
            .mapToObj(i -> "Number: " + i);
        
        // 6. map operations
        IntStream doubled = IntStream.range(1, 10)
            .map(i -> i * 2);
        
        IntStream evenNumbers = IntStream.range(1, 20)
            .filter(i -> i % 2 == 0);
        
        // 7. Range with custom step
        IntStream.iterate(0, i -> i + 3)
            .limit(10)
            .forEach(System.out::println);  // 0,3,6,9,12,15,18,21,24,27
    }
}
```

---

## 11.13 - Cheksiz Stream'lar (Infinite Streams)

### iterate() va generate()

```java
public class InfiniteStreams {
    public static void main(String[] args) {
        
        // 1. Stream.iterate - oldingi qiymat asosida
        Stream<Integer> evenNumbers = Stream.iterate(0, n -> n + 2)
            .limit(10);
        
        // 2. Fibonacci with iterate
        Stream.iterate(new int[]{0, 1}, f -> new int[]{f[1], f[0] + f[1]})
            .limit(10)
            .map(f -> f[0])
            .forEach(System.out::println);
        
        // 3. Stream.generate - Supplier asosida
        Stream<Double> randomNumbers = Stream.generate(Math::random)
            .limit(5);
        
        Stream<UUID> uuids = Stream.generate(UUID::randomUUID)
            .limit(5);
        
        // 4. Infinite stream'ni cheklash
        Stream.iterate(1, n -> n + 1)
            .filter(n -> n % 2 == 0)
            .skip(10)  // first 10 even numbers
            .limit(5)   // next 5 even numbers
            .forEach(System.out::println);
        
        // 5. Java 9+ iterate with predicate
        Stream.iterate(0, n -> n < 100, n -> n + 7)
            .forEach(System.out::println);
    }
}
```

---

## 11.14 - Parallel Streams

### parallel() va parallelStream()

```java
public class ParallelStreams {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. parallelStream() yaratish
        employees.parallelStream()
            .filter(emp -> emp.getAge() > 25)
            .forEach(System.out::println);
        
        // 2. Stream ni parallel ga o'tkazish
        employees.stream()
            .parallel()
            .map(Employee::getFull_name)
            .forEach(System.out::println);
        
        // 3. Performance comparison
        long start = System.currentTimeMillis();
        
        long sequential = employees.stream()
            .filter(emp -> emp.getAge() > 20)
            .count();
        
        long sequentialTime = System.currentTimeMillis() - start;
        
        start = System.currentTimeMillis();
        
        long parallel = employees.parallelStream()
            .filter(emp -> emp.getAge() > 20)
            .count();
        
        long parallelTime = System.currentTimeMillis() - start;
        
        System.out.println("Sequential: " + sequentialTime + "ms");
        System.out.println("Parallel: " + parallelTime + "ms");
        
        // 4. Qachon parallel ishlatish kerak?
        // - Katta hajmdagi ma'lumotlar (>10,000)
        // - CPU intensive operations
        // - Order muhim bo'lmaganda
        
        // 5. Qachon parallel ishlatmaslik kerak?
        // - Kichik ma'lumotlar
        // - I/O operations
        // - findFirst() kabi order muhim bo'lganda
    }
}
```

---

## Amaliy misollar

### Misol 1: Employee analitikasi

```java
public class EmployeeAnalytics {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. 30 yoshdan katta ayollar
        List<Employee> matureFemales = employees.stream()
            .filter(emp -> "FEMALE".equals(emp.getGender()))
            .filter(emp -> emp.getAge() > 30)
            .toList();
        
        // 2. Har bir yoshdagi employee'lar soni
        Map<Integer, Long> countByAge = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getAge,
                Collectors.counting()
            ));
        
        // 3. Eng ko'p employee bo'lgan 3 ta mamlakat
        List<Map.Entry<String, Long>> topCountries = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getCountry,
                Collectors.counting()
            ))
            .entrySet().stream()
            .sorted(Map.Entry.<String, Long>comparingByValue().reversed())
            .limit(3)
            .toList();
        
        // 4. Gender bo'yicha o'rtacha yosh
        Map<String, Double> avgAgeByGender = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getGender,
                Collectors.averagingInt(Employee::getAge)
            ));
        
        // 5. Yosh oralig'i bo'yicha guruhlash
        Map<String, List<Employee>> byAgeGroup = employees.stream()
            .collect(Collectors.groupingBy(emp -> {
                if (emp.getAge() < 18) return "Minor";
                else if (emp.getAge() < 30) return "Young Adult";
                else if (emp.getAge() < 50) return "Adult";
                else return "Senior";
            }));
    }
}
```

### Misol 2: Stream operations pipeline

```java
public class PipelineExample {
    public static void main(String[] args) {
        List<Employee> employees = loadEmployees();
        
        // 1. Complex pipeline
        List<String> result = employees.stream()
            .filter(emp -> emp.getAge() >= 20 && emp.getAge() <= 40)
            .filter(emp -> "MALE".equals(emp.getGender()))
            .map(emp -> emp.getFull_name().toUpperCase())
            .sorted()
            .skip(5)
            .limit(10)
            .toList();
        
        // 2. With grouping and mapping
        Map<String, List<String>> namesByCountry = employees.stream()
            .filter(emp -> emp.getAge() > 25)
            .collect(Collectors.groupingBy(
                Employee::getCountry,
                Collectors.mapping(
                    Employee::getFull_name,
                    Collectors.toList()
                )
            ));
        
        // 3. Find oldest in each country
        Map<String, Optional<Employee>> oldestByCountry = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getCountry,
                Collectors.maxBy(Comparator.comparingInt(Employee::getAge))
            ));
        
        // 4. Partition and transform
        Map<Boolean, List<String>> partitionedNames = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getAge() >= 30,
                Collectors.mapping(Employee::getFull_name, Collectors.toList())
            ));
    }
}
```

---

## Stream API Reference

### Intermediate Operations

| Operation | Return | Description |
|-----------|--------|-------------|
| `filter(Predicate)` | `Stream` | Shartga mos elementlar |
| `map(Function)` | `Stream` | Transformatsiya |
| `flatMap(Function)` | `Stream` | Stream'larni birlashtirish |
| `distinct()` | `Stream` | Unikal elementlar |
| `sorted()` | `Stream` | Saralash |
| `sorted(Comparator)` | `Stream` | Custom saralash |
| `peek(Consumer)` | `Stream` | Side-effect (debug) |
| `limit(long)` | `Stream` | Birinchi n ta element |
| `skip(long)` | `Stream` | Birinchi n ta elementni tashlash |

### Terminal Operations

| Operation | Return | Description |
|-----------|--------|-------------|
| `forEach(Consumer)` | `void` | Har bir element uchun |
| `toArray()` | `Object[]` | Array ga yig'ish |
| `reduce(...)` | `Optional/T` | Reduction |
| `collect(Collector)` | `R` | Yig'ish |
| `min(Comparator)` | `Optional` | Minimal |
| `max(Comparator)` | `Optional` | Maksimal |
| `count()` | `long` | Elementlar soni |
| `anyMatch(Predicate)` | `boolean` | Kamida bitta mos |
| `allMatch(Predicate)` | `boolean` | Hammasi mos |
| `noneMatch(Predicate)` | `boolean` | Hech biri mos emas |
| `findFirst()` | `Optional` | Birinchi element |
| `findAny()` | `Optional` | Ixtiyoriy element |

---

## Tekshiruv Savollari

### Stream API Asoslari

1. **Stream nima va u qanday xususiyatlarga ega?**
2. **Stream va Collection o'rtasidagi farq nima?**
3. **Stream qanday yaratiladi? (5 xil usul)**
4. **Intermediate va terminal operations farqi nima?**
5. **Lazy evaluation nima va nima uchun muhim?**

### Stream Operations

6. **filter() va map() o'rtasidagi farq nima?**
7. **flatMap() qachon ishlatiladi? Misol keltiring.**
8. **limit() va skip() qanday ishlaydi?**
9. **peek() va forEach() farqi nima?**
10. **anyMatch(), allMatch(), noneMatch() farqlari?**

### Terminal Operations

11. **reduce() qanday ishlaydi? Identity nima?**
12. **collect() va toList() farqi nima?**
13. **findFirst() va findAny() farqi nima?**
14. **Optional nima va nima uchun kerak?**

### Parallel va Primitive Streams

15. **Parallel stream qachon ishlatiladi?**
16. **Primitive stream'lar (IntStream) nima uchun kerak?**
17. **Cheksiz stream qanday yaratiladi?**
18. **iterate() va generate() farqi nima?**

---

## Amaliy topshiriq

Berilgan `employees.json` fayli asosida quyidagi topshiriqlarni bajaring:

1. **30 yoshdan katta barcha ayollarni toping**
2. **Har bir mamlakatdagi employee'lar sonini hisoblang**
3. **Eng yosh va eng keksa employee'larni toping**
4. **Mamlakat bo'yicha o'rtacha yoshni hisoblang**
5. **Gender bo'yicha employee'lar ro'yxatini guruhlang**
6. **Ismi uzunligi 15 dan katta bo'lgan employee'larni toping**
7. **Employee'larni yosh bo'yicha saralang**
8. **Barcha employee'larning yoshlari yig'indisini hisoblang**
9. **20-30 yosh oralig'idagi employee'lar soni**
10. **Mamlakatlar bo'yicha eng ko'p uchraydigan yoshni toping**

---

**Keyingi mavzu:** [Optional Class](./12_Optional_Class.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
