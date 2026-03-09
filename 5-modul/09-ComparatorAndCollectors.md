# Comparator va Collectors

## 9.1 - Comparator (Taqqoslovchi)

### Comparator nima?

**Comparator** - bu ikki ob'ektni solishtirish va tartiblash uchun ishlatiladigan interfeys. Java 8 dan boshlab Comparator interfeysiga yangi metodlar qo'shildi, bu esa solishtirishni yanada oson va ifodali qiladi.

```java
// Comparator - ikki ob'ektni solishtirish qoidasi
// a < b  -> manfiy son
// a == b -> 0
// a > b  -> musbat son
```

### Nima uchun Comparator kerak?

1. **Ob'ektlarni saralash** - Ro'yxatdagi ob'ektlarni ma'lum qoida bo'yicha tartiblash
2. **Murakkab solishtirish** - Bir necha mezon bo'yicha solishtirish
3. **Dinamik tartiblash** - Ish vaqtida tartiblash qoidasini o'zgartirish

```java
// ❌ Comparator'siz - faqat natural tartibda
List<String> names = Arrays.asList("Ali", "Vali", "Soli");
Collections.sort(names); // Alfavit bo'yicha

// ✅ Comparator bilan - istalgan tartibda
Collections.sort(names, (a, b) -> b.compareTo(a)); // Teskari alfavit

// Ob'ektlarni solishtirish
List<Employee> employees = getEmployees();

// Yoshi bo'yicha tartiblash
employees.sort((e1, e2) -> Integer.compare(e1.getAge(), e2.getAge()));

// Java 8+ da
employees.sort(Comparator.comparingInt(Employee::getAge));
```

---

## 12.2 - Comparator yangi metodlari

### comparing() - Solishtirish kaliti yaratish

`comparing()` metodi berilgan funksiya orqali solishtirish kalitini yaratadi.

```java
import java.util.*;

public class ComparingExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Ali", 25, 2000),
            new Employee("Vali", 30, 2500),
            new Employee("Soli", 25, 2200),
            new Employee("Guli", 28, 2000)
        );
        
        // 1. Ism bo'yicha tartiblash
        Comparator<Employee> byName = Comparator.comparing(Employee::getName);
        employees.sort(byName);
        
        // 2. Yosh bo'yicha tartiblash
        employees.sort(Comparator.comparing(Employee::getAge));
        
        // 3. Maosh bo'yicha tartiblash (teskari)
        employees.sort(Comparator.comparing(Employee::getSalary).reversed());
        
        // 4. Natural tartib (Comparable bo'lishi kerak)
        List<String> names = Arrays.asList("Ali", "Vali", "Soli");
        names.sort(Comparator.naturalOrder()); // Alfavit bo'yicha
        names.sort(Comparator.reverseOrder()); // Teskari alfavit
        
        // 5. Null qiymatlarni boshqarish
        employees.add(new Employee(null, 35, 3000));
        employees.sort(Comparator.comparing(
            Employee::getName, 
            Comparator.nullsLast(String::compareTo)
        ));
    }
}
```

### comparing() - Custom Comparator bilan

```java
public class CustomComparatorExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Ali", 25, 2000),
            new Employee("vali", 30, 2500), // kichik harf
            new Employee("Soli", 25, 2200),
            new Employee("Guli", 28, 2000)
        );
        
        // 1. Case-insensitive solishtirish
        employees.sort(Comparator.comparing(
            Employee::getName,
            String.CASE_INSENSITIVE_ORDER
        ));
        
        // 2. O'zbekcha solishtirish (locale bilan)
        Comparator<String> uzbekComparator = (s1, s2) -> 
            Collator.getInstance(new Locale("uz")).compare(s1, s2);
            
        employees.sort(Comparator.comparing(
            Employee::getName,
            uzbekComparator
        ));
        
        // 3. Maosh bo'yicha, agar maosh null bo'lsa
        employees.sort(Comparator.comparing(
            Employee::getSalary,
            Comparator.nullsLast(Integer::compare)
        ));
    }
}
```

### comparingInt(), comparingLong(), comparingDouble()

Primitive tiplar uchun maxsus metodlar - boxing/unboxing dan saqlaydi.

```java
public class PrimitiveComparingExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Ali", 25, 2000),
            new Employee("Vali", 30, 2500),
            new Employee("Soli", 25, 2200)
        );
        
        // ❌ Boxing qiladi
        employees.sort(Comparator.comparing(Employee::getAge));
        
        // ✅ Primitive - boxing yo'q, tezroq
        employees.sort(Comparator.comparingInt(Employee::getAge));
        employees.sort(Comparator.comparingDouble(Employee::getSalary));
        
        // Qachon ishlatish kerak?
        // - Katta ma'lumotlar bilan ishlaganda
        // - Performance muhim bo'lganda
        // - Parallel sorting da
    }
}
```

### thenComparing() - Murakkab solishtirish

Bir necha mezon bo'yicha solishtirish kerak bo'lganda.

```java
public class ThenComparingExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Ali", 25, 2000),
            new Employee("Vali", 30, 2500),
            new Employee("Soli", 25, 2200),
            new Employee("Guli", 28, 2000),
            new Employee("Zebo", 25, 2000)
        );
        
        // 1. Yosh bo'yicha, keyin maosh bo'yicha
        employees.sort(Comparator
            .comparingInt(Employee::getAge)
            .thenComparingDouble(Employee::getSalary)
        );
        
        // 2. Yosh bo'yicha, keyin maosh, keyin ism
        employees.sort(Comparator
            .comparingInt(Employee::getAge)
            .thenComparingDouble(Employee::getSalary)
            .thenComparing(Employee::getName)
        );
        
        // 3. Maosh bo'yicha (teskari), keyin yosh bo'yicha
        employees.sort(Comparator
            .comparingDouble(Employee::getSalary)
            .reversed()
            .thenComparingInt(Employee::getAge)
        );
        
        // 4. Murakkab misol
        employees.sort(Comparator
            .comparing(Employee::getDepartment)
            .thenComparingInt(Employee::getAge)
            .thenComparing(Employee::getName, String.CASE_INSENSITIVE_ORDER)
        );
        
        // Natijani ko'rish
        employees.forEach(System.out::println);
    }
}
```

### nullsFirst() va nullsLast()

Null qiymatlarni boshqarish.

```java
public class NullHandlingExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee("Ali", 25, 2000),
            new Employee(null, 30, 2500),
            new Employee("Soli", null, 2200),
            new Employee(null, null, null)
        );
        
        // 1. Null larni boshida ko'rsatish
        employees.sort(Comparator
            .nullsFirst(Comparator.comparing(Employee::getName))
        );
        
        // 2. Null larni oxirida ko'rsatish
        employees.sort(Comparator
            .nullsLast(Comparator.comparingInt(Employee::getAge))
        );
        
        // 3. Bir necha darajali null boshqarish
        employees.sort(Comparator
            .nullsFirst(Comparator.comparing(
                Employee::getName,
                Comparator.nullsLast(String::compareTo)
            ))
            .thenComparingInt(Employee::getAge)
        );
    }
}
```

---

## 12.3 - Collectors (Yig'uvchilar)

### Collectors nima?

**Collectors** - Stream elementlarini turli xil ma'lumot tuzilmalariga yig'ish uchun ishlatiladigan utility class.

```java
// Collectors - stream natijalarini "yig'ib" oladi

List<String> names = employees.stream()
    .map(Employee::getName)
    .collect(Collectors.toList()); // List ga yig'adi

Map<String, List<Employee>> byDept = employees.stream()
    .collect(Collectors.groupingBy(Employee::getDepartment)); // Guruhlaydi
```

### Collector qanday ishlaydi?

Collector 5 qismdan iborat:

```java
interface Collector<T, A, R> {
    // 1. Yangi bo'sh konteyner yaratadi
    Supplier<A> supplier();
    
    // 2. Elementni konteynerga qo'shadi
    BiConsumer<A, T> accumulator();
    
    // 3. Ikki konteynerni birlashtiradi (parallel uchun)
    BinaryOperator<A> combiner();
    
    // 4. Yakuniy o'zgartirish (ixtiyoriy)
    Function<A, R> finisher();
    
    // 5. Collector xususiyatlari
    Set<Characteristics> characteristics();
}

// Misol: StringBuilder ga yig'uvchi collector
Collector<String, StringBuilder, String> toStringCollector = 
    Collector.of(
        StringBuilder::new,           // supplier
        StringBuilder::append,         // accumulator
        StringBuilder::append,         // combiner
        StringBuilder::toString,       // finisher
        Collector.Characteristics.CONCURRENT
    );
```

---

## 12.4 - Kolleksiyalarga yig'ish

### toList(), toSet(), toCollection()

```java
public class CollectingToCollections {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. toList() - ArrayList ga yig'adi
        List<String> names = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.toList());
        
        // 2. toSet() - HashSet ga yig'adi
        Set<String> departments = employees.stream()
            .map(Employee::getDepartment)
            .collect(Collectors.toSet());
        
        // 3. toCollection() - specific kolleksiya
        LinkedList<String> linkedList = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.toCollection(LinkedList::new));
        
        TreeSet<String> sortedNames = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.toCollection(TreeSet::new));
        
        Vector<String> vector = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.toCollection(Vector::new));
        
        // 4. Unmodifiable collections (Java 10+)
        List<String> unmodifiableList = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.toUnmodifiableList());
        
        // unmodifiableList.add("Yangi"); // UnsupportedOperationException!
    }
}
```

### toMap() - Map ga yig'ish

```java
public class CollectingToMap {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee(1, "Ali", 25, 2000, "IT"),
            new Employee(2, "Vali", 30, 2500, "HR"),
            new Employee(3, "Soli", 28, 2200, "IT"),
            new Employee(4, "Guli", 26, 2000, "HR")
        );
        
        // 1. Oddiy toMap - id -> employee
        Map<Integer, Employee> idToEmp = employees.stream()
            .collect(Collectors.toMap(
                Employee::getId,      // key ni olish
                emp -> emp            // value ni olish
            ));
        
        // 2. id -> name
        Map<Integer, String> idToName = employees.stream()
            .collect(Collectors.toMap(
                Employee::getId,
                Employee::getName
            ));
        
        // 3. Duplicate key muammosi
        // Departament bo'yicha xodim nomlari - duplicate key bo'lishi mumkin!
        Map<String, String> deptToName = employees.stream()
            .collect(Collectors.toMap(
                Employee::getDepartment,
                Employee::getName,
                (name1, name2) -> name1 + ", " + name2 // merge function
            ));
        // IT -> "Ali, Soli"
        // HR -> "Vali, Guli"
        
        // 4. Specific map implementation
        TreeMap<String, String> sortedMap = employees.stream()
            .collect(Collectors.toMap(
                Employee::getDepartment,
                Employee::getName,
                (n1, n2) -> n1 + ", " + n2,
                TreeMap::new
            ));
        
        // 5. Hisoblashlar bilan
        Map<String, Integer> totalSalaryByDept = employees.stream()
            .collect(Collectors.toMap(
                Employee::getDepartment,
                Employee::getSalary,
                Integer::sum
            ));
        
        System.out.println("Total salary by dept: " + totalSalaryByDept);
    }
}
```

---

## 12.5 - String joining

### joining() - String larni birlashtirish

```java
public class JoiningExample {
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Ali", "Vali", "Soli", "Guli");
        List<Employee> employees = getEmployees();
        
        // 1. Oddiy birlashtirish
        String joined = names.stream()
            .collect(Collectors.joining());
        // "AliValiSoliGuli"
        
        // 2. Delimiter bilan
        String withComma = names.stream()
            .collect(Collectors.joining(", "));
        // "Ali, Vali, Soli, Guli"
        
        // 3. Prefix va suffix bilan
        String withBrackets = names.stream()
            .collect(Collectors.joining(", ", "[", "]"));
        // "[Ali, Vali, Soli, Guli]"
        
        // 4. Employee ismlarini birlashtirish
        String employeeNames = employees.stream()
            .map(Employee::getName)
            .filter(Objects::nonNull)
            .collect(Collectors.joining("; "));
        
        // 5. CSV yaratish
        String csv = employees.stream()
            .map(emp -> String.format("%d,%s,%d",
                emp.getId(), emp.getName(), emp.getSalary()))
            .collect(Collectors.joining("\n"));
        
        System.out.println("CSV:\n" + csv);
        
        // 6. SQL IN clause
        String inClause = employees.stream()
            .map(emp -> "'" + emp.getName() + "'")
            .collect(Collectors.joining(", ", "(", ")"));
        // "('Ali', 'Vali', 'Soli')"
    }
}
```

---

## 12.6 - Grouping (Guruhlash)

### groupingBy() - Ma'lumotlarni guruhlash

```java
public class GroupingByExample {
    public static void main(String[] args) {
        List<Employee> employees = Arrays.asList(
            new Employee(1, "Ali", 25, 2000, "IT"),
            new Employee(2, "Vali", 30, 2500, "HR"),
            new Employee(3, "Soli", 28, 2200, "IT"),
            new Employee(4, "Guli", 26, 2000, "HR"),
            new Employee(5, "Zebo", 35, 3000, "IT"),
            new Employee(6, "Anvar", 22, 1500, "IT")
        );
        
        // 1. Oddiy guruhlash - departament bo'yicha
        Map<String, List<Employee>> byDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::getDepartment));
        
        // 2. Guruhlab, keyin mapping
        Map<String, List<String>> namesByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.mapping(Employee::getName, Collectors.toList())
            ));
        
        // 3. Guruhlab, keyin hisoblash
        Map<String, Long> countByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.counting()
            ));
        
        Map<String, Integer> totalSalaryByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.summingInt(Employee::getSalary)
            ));
        
        Map<String, Double> avgSalaryByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.averagingInt(Employee::getSalary)
            ));
        
        // 4. Murakkab guruhlash - yosh oralig'i bo'yicha
        Map<String, List<Employee>> byAgeGroup = employees.stream()
            .collect(Collectors.groupingBy(emp -> {
                if (emp.getAge() < 25) return "Yosh";
                else if (emp.getAge() < 35) return "O'rta";
                else return "Katta";
            }));
        
        // 5. Ikki darajali guruhlash
        Map<String, Map<String, List<Employee>>> byDeptAndAgeGroup = 
            employees.stream()
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.groupingBy(emp -> {
                        if (emp.getAge() < 25) return "Yosh";
                        else return "Katta";
                    })
                ));
        
        // 6. Guruhlab, eng yaxshi xodimni topish
        Map<String, Optional<Employee>> highestSalaryByDept = 
            employees.stream()
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.maxBy(Comparator.comparingInt(Employee::getSalary))
                ));
        
        // 7. Guruhlab, ma'lumotlarni to'plash
        Map<String, IntSummaryStatistics> statsByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.summarizingInt(Employee::getSalary)
            ));
        
        // Natijalarni chiqarish
        System.out.println("=== Department Statistics ===");
        statsByDept.forEach((dept, stats) -> {
            System.out.println(dept + ":");
            System.out.println("  Count: " + stats.getCount());
            System.out.println("  Sum: " + stats.getSum());
            System.out.println("  Avg: " + stats.getAverage());
            System.out.println("  Min: " + stats.getMin());
            System.out.println("  Max: " + stats.getMax());
        });
    }
}
```

### groupingByConcurrent() - Parallel guruhlash

```java
public class GroupingByConcurrentExample {
    public static void main(String[] args) {
        List<Employee> employees = getLargeEmployeeList();
        
        // Parallel guruhlash - tezroq
        Map<String, List<Employee>> byDept = employees.parallelStream()
            .collect(Collectors.groupingByConcurrent(Employee::getDepartment));
        
        // ConcurrentMap qaytaradi
        ConcurrentMap<String, List<Employee>> concurrentMap = 
            employees.parallelStream()
                .collect(Collectors.groupingByConcurrent(Employee::getDepartment));
    }
}
```

---

## 12.7 - Partitioning (Bo'lish)

### partitioningBy() - Shart bo'yicha ikki guruhga ajratish

```java
public class PartitioningByExample {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. Oddiy partitioning - yoshi 30 dan katta/kichik
        Map<Boolean, List<Employee>> byAge = employees.stream()
            .collect(Collectors.partitioningBy(emp -> emp.getAge() > 30));
        
        List<Employee> young = byAge.get(false);  // <=30
        List<Employee> old = byAge.get(true);     // >30
        
        // 2. Partitioning with downstream collector
        Map<Boolean, Long> countByAgeGroup = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getAge() > 30,
                Collectors.counting()
            ));
        
        System.out.println(">30 count: " + countByAgeGroup.get(true));
        System.out.println("<=30 count: " + countByAgeGroup.get(false));
        
        // 3. Partitioning with mapping
        Map<Boolean, List<String>> namesByAgeGroup = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getAge() > 30,
                Collectors.mapping(Employee::getName, Collectors.toList())
            ));
        
        // 4. Partitioning with summarizing
        Map<Boolean, IntSummaryStatistics> statsByAgeGroup = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getAge() > 30,
                Collectors.summarizingInt(Employee::getSalary)
            ));
        
        // 5. Maosh bo'yicha partitioning
        Map<Boolean, List<Employee>> bySalary = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getSalary() > 2000
            ));
        
        System.out.println("\n=== High salary employees ===");
        bySalary.get(true).forEach(System.out::println);
        
        System.out.println("\n=== Low salary employees ===");
        bySalary.get(false).forEach(System.out::println);
    }
}
```

---

## 12.8 - Reducing collectors

### reducing() - Qisqartirish operatsiyalari

```java
public class ReducingCollectorsExample {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. Stream.reduce() bilan solishtirish
        // Stream.reduce()
        Optional<Integer> totalSalary1 = employees.stream()
            .map(Employee::getSalary)
            .reduce(Integer::sum);
        
        // Collectors.reducing()
        Optional<Integer> totalSalary2 = employees.stream()
            .collect(Collectors.reducing(
                Employee::getSalary,
                Integer::sum
            ));
        
        // 2. Identity bilan
        int totalSalary3 = employees.stream()
            .collect(Collectors.reducing(
                0,                       // identity
                Employee::getSalary,      // mapper
                Integer::sum              // accumulator
            ));
        
        // 3. Murakkab reducing
        Optional<Employee> highestSalary = employees.stream()
            .collect(Collectors.reducing(
                (e1, e2) -> e1.getSalary() > e2.getSalary() ? e1 : e2
            ));
        
        // 4. Grouping bilan reducing
        Map<String, Optional<Employee>> highestByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.reducing((e1, e2) -> 
                    e1.getSalary() > e2.getSalary() ? e1 : e2)
            ));
        
        // 5. String concat with reducing
        String allNames = employees.stream()
            .map(Employee::getName)
            .collect(Collectors.reducing(
                "", 
                (s1, s2) -> s1 + ", " + s2
            ));
    }
}
```

---

## 12.9 - Arithmetic va Summarizing

### minBy(), maxBy(), summingInt(), averagingInt()

```java
public class ArithmeticCollectorsExample {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. minBy() - eng kichik
        Optional<Employee> youngest = employees.stream()
            .collect(Collectors.minBy(Comparator.comparingInt(Employee::getAge)));
        
        Optional<Employee> lowestSalary = employees.stream()
            .collect(Collectors.minBy(Comparator.comparingInt(Employee::getSalary)));
        
        // 2. maxBy() - eng katta
        Optional<Employee> oldest = employees.stream()
            .collect(Collectors.maxBy(Comparator.comparingInt(Employee::getAge)));
        
        // 3. summingInt() - yig'indi
        int totalAge = employees.stream()
            .collect(Collectors.summingInt(Employee::getAge));
        
        int totalSalary = employees.stream()
            .collect(Collectors.summingInt(Employee::getSalary));
        
        // 4. averagingInt() - o'rtacha
        double avgAge = employees.stream()
            .collect(Collectors.averagingInt(Employee::getAge));
        
        double avgSalary = employees.stream()
            .collect(Collectors.averagingInt(Employee::getSalary));
        
        // 5. Grouping bilan
        Map<String, Double> avgSalaryByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.averagingInt(Employee::getSalary)
            ));
        
        System.out.println("=== Average Salary by Department ===");
        avgSalaryByDept.forEach((dept, avg) -> 
            System.out.println(dept + ": $" + avg));
    }
}
```

### summarizingInt() - To'liq statistika

```java
public class SummarizingExample {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. Yoshlar bo'yicha statistika
        IntSummaryStatistics ageStats = employees.stream()
            .collect(Collectors.summarizingInt(Employee::getAge));
        
        System.out.println("=== Age Statistics ===");
        System.out.println("Count: " + ageStats.getCount());
        System.out.println("Sum: " + ageStats.getSum());
        System.out.println("Min: " + ageStats.getMin());
        System.out.println("Max: " + ageStats.getMax());
        System.out.println("Average: " + ageStats.getAverage());
        
        // 2. Maosh bo'yicha statistika
        IntSummaryStatistics salaryStats = employees.stream()
            .collect(Collectors.summarizingInt(Employee::getSalary));
        
        System.out.println("\n=== Salary Statistics ===");
        System.out.println("Total salary: " + salaryStats.getSum());
        System.out.println("Average salary: " + salaryStats.getAverage());
        System.out.println("Min salary: " + salaryStats.getMin());
        System.out.println("Max salary: " + salaryStats.getMax());
        
        // 3. Guruhlar bo'yicha statistika
        Map<String, IntSummaryStatistics> statsByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.summarizingInt(Employee::getSalary)
            ));
        
        System.out.println("\n=== Department Statistics ===");
        statsByDept.forEach((dept, stats) -> {
            System.out.println(dept + ":");
            System.out.println("  Count: " + stats.getCount());
            System.out.println("  Total: $" + stats.getSum());
            System.out.println("  Avg: $" + stats.getAverage());
            System.out.println("  Min: $" + stats.getMin());
            System.out.println("  Max: $" + stats.getMax());
        });
        
        // 4. LongSummaryStatistics
        LongSummaryStatistics longStats = employees.stream()
            .collect(Collectors.summarizingLong(Employee::getId));
        
        // 5. DoubleSummaryStatistics
        DoubleSummaryStatistics doubleStats = employees.stream()
            .collect(Collectors.summarizingDouble(Employee::getSalary));
    }
}
```

---

## 12.10 - Amaliy misollar

### Misol 1: Employee analitikasi

```java
public class EmployeeAnalytics {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. Departamentlar bo'yicha xodimlar ro'yxati
        Map<String, List<Employee>> byDept = employees.stream()
            .collect(Collectors.groupingBy(Employee::getDepartment));
        
        // 2. Har bir departamentdagi xodimlar soni
        Map<String, Long> countByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.counting()
            ));
        
        // 3. Har bir departamentdagi o'rtacha maosh
        Map<String, Double> avgSalaryByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.averagingInt(Employee::getSalary)
            ));
        
        // 4. Eng ko'p maosh oladigan xodim har bir departamentda
        Map<String, Optional<Employee>> topEarnerByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.maxBy(Comparator.comparingInt(Employee::getSalary))
            ));
        
        // 5. Yosh oralig'i bo'yicha guruhlash
        Map<String, List<Employee>> byAgeGroup = employees.stream()
            .collect(Collectors.groupingBy(emp -> {
                if (emp.getAge() < 25) return "Junior";
                if (emp.getAge() < 35) return "Middle";
                return "Senior";
            }));
        
        // 6. To'liq statistika
        Map<String, IntSummaryStatistics> statsByDept = employees.stream()
            .collect(Collectors.groupingBy(
                Employee::getDepartment,
                Collectors.summarizingInt(Employee::getSalary)
            ));
        
        // 7. Maosh darajasi bo'yicha partitioning
        Map<Boolean, List<Employee>> bySalaryLevel = employees.stream()
            .collect(Collectors.partitioningBy(
                emp -> emp.getSalary() > 2500
            ));
        
        // Natijalarni chiqarish
        System.out.println("=== High Salary Employees ===");
        bySalaryLevel.get(true).forEach(System.out::println);
        
        System.out.println("\n=== Department Statistics ===");
        statsByDept.forEach((dept, stats) -> {
            System.out.println(dept + ": avg=" + stats.getAverage() + 
                               ", total=" + stats.getSum());
        });
    }
}
```

### Misol 2: Composite report

```java
public class CompositeReport {
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // 1. Departament va gender bo'yicha guruhlash
        Map<String, Map<String, List<Employee>>> byDeptAndGender = 
            employees.stream()
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.groupingBy(Employee::getGender)
                ));
        
        // 2. Departament va gender bo'yicha statistika
        Map<String, Map<String, Double>> avgSalaryByDeptAndGender = 
            employees.stream()
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.groupingBy(
                        Employee::getGender,
                        Collectors.averagingInt(Employee::getSalary)
                    )
                ));
        
        // 3. Departament va yosh oralig'i bo'yicha
        Map<String, Map<String, Long>> countByDeptAndAgeGroup = 
            employees.stream()
                .collect(Collectors.groupingBy(
                    Employee::getDepartment,
                    Collectors.groupingBy(
                        emp -> {
                            if (emp.getAge() < 25) return "Young";
                            if (emp.getAge() < 35) return "Mid";
                            return "Senior";
                        },
                        Collectors.counting()
                    )
                ));
        
        // 4. Report yaratish
        System.out.println("=== Department Report ===");
        avgSalaryByDeptAndGender.forEach((dept, genderMap) -> {
            System.out.println(dept + ":");
            genderMap.forEach((gender, avg) -> 
                System.out.println("  " + gender + " avg salary: $" + avg));
        });
    }
}
```

### Misol 3: Custom Collector

```java
public class CustomCollectorExample {
    
    // XML yaratuvchi custom collector
    public static Collector<Employee, StringBuilder, String> toXmlCollector() {
        return Collector.of(
            StringBuilder::new,                    // supplier
            (sb, emp) -> {                          // accumulator
                sb.append("  <employee>\n");
                sb.append("    <id>").append(emp.getId()).append("</id>\n");
                sb.append("    <name>").append(emp.getName()).append("</name>\n");
                sb.append("    <age>").append(emp.getAge()).append("</age>\n");
                sb.append("    <salary>").append(emp.getSalary()).append("</salary>\n");
                sb.append("    <department>").append(emp.getDepartment()).append("</department>\n");
                sb.append("  </employee>\n");
            },
            (sb1, sb2) -> sb1.append(sb2),         // combiner
            sb -> {                                  // finisher
                StringBuilder result = new StringBuilder();
                result.append("<employees>\n");
                result.append(sb);
                result.append("</employees>");
                return result.toString();
            }
        );
    }
    
    public static void main(String[] args) {
        List<Employee> employees = getEmployees();
        
        // Custom collector bilan XML yaratish
        String xml = employees.stream()
            .collect(toXmlCollector());
        
        System.out.println(xml);
        
        // JSON yaratuvchi custom collector
        String json = employees.stream()
            .collect(Collector.of(
                StringBuilder::new,
                (sb, emp) -> {
                    if (sb.length() > 0) sb.append(",\n");
                    sb.append("  {")
                      .append("\"id\":").append(emp.getId()).append(", ")
                      .append("\"name\":\"").append(emp.getName()).append("\", ")
                      .append("\"age\":").append(emp.getAge())
                      .append("}");
                },
                StringBuilder::append,
                sb -> "[\n" + sb + "\n]"
            ));
        
        System.out.println(json);
    }
}
```

---

## Collectors Reference

| Collector | Vazifasi | Misol |
|-----------|----------|-------|
| `toList()` | List ga yig'ish | `stream.collect(toList())` |
| `toSet()` | Set ga yig'ish | `stream.collect(toSet())` |
| `toMap()` | Map ga yig'ish | `stream.collect(toMap(k, v))` |
| `joining()` | String birlashtirish | `stream.collect(joining(", "))` |
| `groupingBy()` | Guruhlash | `stream.collect(groupingBy(Function))` |
| `partitioningBy()` | Shart bo'yicha bo'lish | `stream.collect(partitioningBy(Predicate))` |
| `counting()` | Sanash | `stream.collect(counting())` |
| `summingInt()` | Yig'indi | `stream.collect(summingInt(f))` |
| `averagingInt()` | O'rtacha | `stream.collect(averagingInt(f))` |
| `summarizingInt()` | Statistika | `stream.collect(summarizingInt(f))` |
| `minBy()` | Minimal | `stream.collect(minBy(comp))` |
| `maxBy()` | Maksimal | `stream.collect(maxBy(comp))` |
| `reducing()` | Qisqartirish | `stream.collect(reducing(op))` |
| `mapping()` | Mapping | `stream.collect(mapping(f, collector))` |
| `filtering()` | Filtrlash | `stream.collect(filtering(p, collector))` |
| `flatMapping()` | Flat mapping | `stream.collect(flatMapping(f, collector))` |

---

## Tekshiruv Savollari

### Comparator
1. **Comparator nima va nima uchun kerak?**
2. **comparing() metodi qanday ishlaydi?**
3. **thenComparing() qachon ishlatiladi?**
4. **comparingInt() va comparing() farqi nima?**
5. **nullsFirst() va nullsLast() nima uchun kerak?**

### Collectors
6. **Collectors nima va u qanday ishlaydi?**
7. **toList(), toSet(), toCollection() farqlari?**
8. **toMap() da duplicate key muammosi qanday hal qilinadi?**
9. **groupingBy() va partitioningBy() farqi nima?**
10. **joining() metodi qanday ishlatiladi?**
11. **summarizingInt() nima qaytaradi?**
12. **Custom collector qanday yaratiladi?**
13. **Collector ning 5 komponenti nima?**

---

## Amaliy topshiriq

Berilgan `Employee` ob'ektlari ro'yxati ustida quyidagi operatsiyalarni bajaring:

1. **Xodimlarni departament bo'yicha guruhlab, har bir departamentdagi o'rtacha maoshni hisoblang**
2. **Har bir departamentdagi eng yuqori va eng past maoshli xodimlarni toping**
3. **Yosh oralig'i (20-30, 31-40, 41+) bo'yicha xodimlar sonini hisoblang**
4. **Departament va gender bo'yicha o'rtacha maosh jadvalini tuzing**
5. **Maoshi o'rtachadan yuqori bo'lgan xodimlar ro'yxatini oling**
6. **Xodimlar ma'lumotlaridan JSON va XML formatlar yarating**
7. **Har bir departament uchun to'liq statistika (count, sum, min, max, avg) hisoblang**

---

**Keyingi mavzu:** [HTTP Client](./13_HTTP_Client.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
