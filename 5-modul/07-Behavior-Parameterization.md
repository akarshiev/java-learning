# 8-Modul: Behavior Parameterization va Lambda Expressions

## 8.1 - Behavior Parameterization (Xulq-atvorni Parametrlashtirish)

### Behavior Parameterization nima?

**Behavior Parameterization** - metodga turli xil xulq-atvorni parametr sifatida qabul qilish va ularni ichki tarzda ishlatish qobiliyati. Bu kodni o'zgaruvchan talablarga moslashuvchan qiladi va bir xil kodni qayta-qayta yozishdan saqlaydi.

```java
// ❌ Behavior Parameterization'siz - har bir filter uchun alohida metod
public static List<Apple> filterGreenApples(List<Apple> inventory) {
    List<Apple> result = new ArrayList<>();
    for (Apple apple : inventory) {
        if ("green".equals(apple.getColor())) {
            result.add(apple);
        }
    }
    return result;
}

public static List<Apple> filterHeavyApples(List<Apple> inventory) {
    List<Apple> result = new ArrayList<>();
    for (Apple apple : inventory) {
        if (apple.getWeight() > 150) {
            result.add(apple);
        }
    }
    return result;
}

// ✅ Behavior Parameterization bilan
public static List<Apple> filterApples(List<Apple> inventory, 
                                        Predicate<Apple> predicate) {
    List<Apple> result = new ArrayList<>();
    for (Apple apple : inventory) {
        if (predicate.test(apple)) {
            result.add(apple);
        }
    }
    return result;
}

// Foydalanish:
List<Apple> greenApples = filterApples(inventory, 
    apple -> "green".equals(apple.getColor()));
List<Apple> heavyApples = filterApples(inventory, 
    apple -> apple.getWeight() > 150);
```

### Behavior Parameterization qanday muammolarni hal qiladi?

1. **DRY (Don't Repeat Yourself) printsipi** - Takrorlanuvchi kodni kamaytiradi
2. **Open/Closed printsipi** - Kodni o'zgartirmasdan yangi funksionallik qo'shish
3. **Strategy pattern** - Algoritmlarni parametr sifatida uzatish
4. **Code reuse** - Kodni qayta ishlatish

```java
// Strategy pattern misoli
interface SortingStrategy {
    void sort(int[] array);
}

class BubbleSort implements SortingStrategy {
    public void sort(int[] array) { /* bubble sort implementation */ }
}

class QuickSort implements SortingStrategy {
    public void sort(int[] array) { /* quick sort implementation */ }
}

// Behavior parameterization bilan
public void processArray(int[] array, SortingStrategy strategy) {
    strategy.sort(array);
    // other processing
}
```

---

## 8.2 - Lambda Expressions

### Lambda expression nima?

**Lambda expression** - bu parametrlar qabul qiladigan va qiymat qaytaradigan qisqa kod bloki. Bu bizga kod blokini bir birlik sifatida encapsulate qilish va boshqa kodga uzatish imkonini beradi.

```java
// Lambda syntax: (args) -> {}
//           (parameters) -> { body }

// 1. Parameterlarsiz
Runnable r1 = () -> System.out.println("Hello");
Runnable r2 = () -> {
    System.out.println("Hello");
    System.out.println("World");
};

// 2. Bitta parameterli
Consumer<String> c1 = s -> System.out.println(s);
Consumer<String> c2 = (s) -> System.out.println(s);

// 3. Bir nechta parameterli
Comparator<Integer> comp = (a, b) -> a.compareTo(b);
BiFunction<Integer, Integer, Integer> sum = (a, b) -> a + b;

// 4. Return qiymatli
Function<String, Integer> length = s -> s.length();
Function<String, Integer> lengthWithBraces = s -> {
    return s.length();
};
```

### Lambda qoidalari

```java
public class LambdaRules {
    public static void main(String[] args) {
        
        // 1. Parameter turlari optional
        Comparator<Integer> comp1 = (Integer a, Integer b) -> a.compareTo(b);
        Comparator<Integer> comp2 = (a, b) -> a.compareTo(b);  // Type inference
        
        // 2. Bitta parameter bo'lsa, qavslar optional
        Consumer<String> c1 = (s) -> System.out.println(s);
        Consumer<String> c2 = s -> System.out.println(s);      // Qavssiz
        
        // 3. Bir nechta parameter bo'lsa, qavslar majburiy
        BiFunction<Integer, Integer, Integer> f1 = (a, b) -> a + b;
        // BiFunction<Integer, Integer, Integer> f2 = a, b -> a + b;  // ERROR!
        
        // 4. Bir nechta statement bo'lsa, {} va return majburiy
        Function<Integer, Integer> f3 = x -> x * 2;  // Single statement
        Function<Integer, Integer> f4 = x -> {
            int y = x * 2;
            return y + 10;  // {} va return kerak
        };
        
        // 5. Lambda o'zgaruvchilarni "capture" qila oladi
        int localVar = 10;  // effectively final
        Function<Integer, Integer> f5 = x -> x + localVar;  // OK
        
        // int localVar2 = 20;
        // localVar2 = 30;  // NOT effectively final
        // Function<Integer, Integer> f6 = x -> x + localVar2;  // ERROR!
    }
}
```

### Lambda ishlatiladigan joylar

```java
public class LambdaUseCases {
    public static void main(String[] args) {
        
        // 1. Variable declarations
        Predicate<String> isEmpty = s -> s.isEmpty();
        
        // 2. Return statements
        return (x, y) -> x + y;
        
        // 3. Method arguments
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
        numbers.stream()
            .filter(n -> n % 2 == 0)           // Lambda as argument
            .map(n -> n * n)
            .forEach(n -> System.out.println(n));
        
        // 4. Ternary expressions
        Function<Integer, String> func = x -> 
            x > 0 ? "Positive" : "Non-positive";
    }
}
```

### final va effectively final

```java
public class FinalVsEffectivelyFinal {
    public static void main(String[] args) {
        
        // final variable - explicit final
        final int x = 10;
        Predicate<Integer> p1 = n -> n > x;  // OK
        
        // effectively final - o'zgartirilmagan
        int y = 20;
        Predicate<Integer> p2 = n -> n > y;  // OK
        
        // NOT effectively final
        int z = 30;
        z = 40;  // O'zgartirildi!
        // Predicate<Integer> p3 = n -> n > z;  // ERROR!
        
        // Lambda ichida o'zgaruvchi o'zgartirish mumkin emas
        int[] counter = {0};
        Runnable r = () -> {
            // counter++;  // ERROR! Can't modify
            counter[0]++;  // OK - array element o'zgaradi
        };
    }
}
```

### Callable nima?

**Callable** - Runnable'ga o'xshash, lekin natija qaytaradigan va exception tashlay oladigan functional interface.

```java
import java.util.concurrent.Callable;

public class CallableExample {
    public static void main(String[] args) {
        
        // Runnable vs Callable
        Runnable runnable = () -> System.out.println("Hello");
        Callable<Integer> callable = () -> {
            return "Hello PDP!".length();  // Natija qaytaradi
        };
        
        // Callable exception tashlay oladi
        Callable<String> riskyCallable = () -> {
            if (Math.random() > 0.5) {
                throw new IOException("Network error");
            }
            return "Success";
        };
        
        // ExecutorService bilan ishlatish
        ExecutorService executor = Executors.newSingleThreadExecutor();
        Future<Integer> future = executor.submit(callable);
        
        try {
            Integer result = future.get();  // Natijani olish
            System.out.println("Result: " + result);
        } catch (Exception e) {
            e.printStackTrace();
        }
        
        executor.shutdown();
    }
}
```

---

## 8.3 - Functional Interfaces

### Functional Interface nima?

**Functional Interface** - bu aniq bitta abstract methodga ega bo'lgan interface. Lambda expression'lar va method reference'lar uchun target type vazifasini o'taydi.

```java
@FunctionalInterface
interface MyFunctionalInterface {
    void execute();  // Single abstract method
    
    // Default methods - ko'p bo'lishi mumkin
    default void before() {
        System.out.println("Before execution");
    }
    
    default void after() {
        System.out.println("After execution");
    }
    
    // Static methods - ko'p bo'lishi mumkin
    static void info() {
        System.out.println("Functional interface");
    }
}

// Foydalanish
MyFunctionalInterface func = () -> System.out.println("Executing...");
func.execute();
func.before();
func.after();
MyFunctionalInterface.info();
```

### @FunctionalInterface annotatsiyasi

**@FunctionalInterface** - interface'ning functional interface qoidalariga mos kelishini tekshiradi.

```java
@FunctionalInterface
interface ValidFunctionalInterface {
    void doSomething();
}

@FunctionalInterface
interface AnotherValidInterface {
    void doSomething();
    
    // default methods are fine
    default void doDefault() {}
    
    // static methods are fine
    static void doStatic() {}
}

// @FunctionalInterface
// interface InvalidInterface {
//     void doSomething();
//     void doAnother();  // ERROR! Two abstract methods
// }

// @FunctionalInterface
// interface NoMethodInterface {}  // ERROR! No abstract method
```

### Asosiy Functional Interface'lar

#### Predicate
```java
@FunctionalInterface
public interface Predicate<T> {
    boolean test(T t);
}

// Foydalanish
Predicate<String> isEmpty = s -> s.isEmpty();
Predicate<Integer> isPositive = n -> n > 0;
Predicate<Apple> isGreen = apple -> "green".equals(apple.getColor());

// Composition
Predicate<String> notEmpty = isEmpty.negate();
Predicate<Integer> isEven = n -> n % 2 == 0;
Predicate<Integer> isPositiveAndEven = isPositive.and(isEven);
Predicate<Integer> isPositiveOrEven = isPositive.or(isEven);

List<Integer> numbers = Arrays.asList(-5, 0, 2, 5, 8);
numbers.stream()
    .filter(isPositiveAndEven)
    .forEach(System.out::println);  // 2, 8
```

#### Consumer
```java
@FunctionalInterface
public interface Consumer<T> {
    void accept(T t);
}

// Foydalanish
Consumer<String> print = s -> System.out.println(s);
Consumer<Apple> printApple = a -> System.out.println(a.getColor());

// Chaining
Consumer<String> printUpperCase = s -> System.out.println(s.toUpperCase());
Consumer<String> printLowerCase = s -> System.out.println(s.toLowerCase());
Consumer<String> printBoth = printUpperCase.andThen(printLowerCase);

printBoth.accept("Hello");  // HELLO \n hello

// Real misol
List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
names.forEach(name -> System.out.println("Hello, " + name));
```

#### Function
```java
@FunctionalInterface
public interface Function<T, R> {
    R apply(T t);
}

// Foydalanish
Function<String, Integer> length = s -> s.length();
Function<Integer, String> intToString = i -> "Number: " + i;

// Composition
Function<String, String> toUpperCase = s -> s.toUpperCase();
Function<String, Integer> getLength = s -> s.length();

Function<String, Integer> composed = toUpperCase.andThen(getLength);
// yoki
Function<String, Integer> composed2 = getLength.compose(toUpperCase);

int result = composed.apply("hello");  // "HELLO" -> 5

// Real misol
Map<String, Function<String, String>> operations = new HashMap<>();
operations.put("upper", String::toUpperCase);
operations.put("lower", String::toLowerCase);
operations.put("reverse", s -> new StringBuilder(s).reverse().toString());

String input = "Hello";
String output = operations.get("reverse").apply(input);  // "olleH"
```

#### Supplier
```java
@FunctionalInterface
public interface Supplier<T> {
    T get();
}

// Foydalanish
Supplier<String> helloSupplier = () -> "Hello";
Supplier<Double> randomSupplier = () -> Math.random();
Supplier<UUID> uuidSupplier = UUID::randomUUID;

// Lazy initialization
public class LazyInitializer {
    private Supplier<ExpensiveObject> expensive = () -> createExpensive();
    
    private ExpensiveObject createExpensive() {
        return new ExpensiveObject();  // Faqat kerak bo'lganda yaratiladi
    }
    
    public ExpensiveObject getExpensive() {
        return expensive.get();
    }
}

// Real misol
Optional<String> optional = Optional.of("value");
String result = optional.orElseGet(() -> "default");  // Lazy evaluation
```

#### UnaryOperator
```java
@FunctionalInterface
public interface UnaryOperator<T> extends Function<T, T> {
    // T apply(T t) - same type
}

// Foydalanish
UnaryOperator<String> toUpperCase = s -> s.toUpperCase();
UnaryOperator<Integer> square = n -> n * n;
UnaryOperator<Integer> increment = n -> n + 1;

// Chaining
UnaryOperator<Integer> multiplyBy2 = n -> n * 2;
UnaryOperator<Integer> add3 = n -> n + 3;
UnaryOperator<Integer> composed = multiplyBy2.andThen(add3);

int result = composed.apply(5);  // (5*2)+3 = 13
```

#### BinaryOperator
```java
@FunctionalInterface
public interface BinaryOperator<T> extends BiFunction<T, T, T> {
    // T apply(T t1, T t2) - same type
}

// Foydalanish
BinaryOperator<Integer> sum = (a, b) -> a + b;
BinaryOperator<Integer> max = (a, b) -> a > b ? a : b;
BinaryOperator<Integer> multiply = (a, b) -> a * b;

// Reduction
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5);
int total = numbers.stream()
    .reduce(0, sum);  // 15

int maxValue = numbers.stream()
    .reduce(Integer.MIN_VALUE, max);  // 5

// Min va max
BinaryOperator<Integer> min = BinaryOperator.minBy(Integer::compare);
BinaryOperator<Integer> maxBy = BinaryOperator.maxBy(Integer::compare);
```

### Functional Interface'lar jadvali

| Interface | Method | Purpose | Example |
|-----------|--------|---------|---------|
| **Predicate\<T>** | `boolean test(T t)` | Tekshirish | `s -> s.isEmpty()` |
| **Consumer\<T>** | `void accept(T t)` | Iste'mol qilish | `s -> System.out.println(s)` |
| **Function\<T,R>** | `R apply(T t)` | Transformatsiya | `s -> s.length()` |
| **Supplier\<T>** | `T get()` | Ta'minlash | `() -> UUID.randomUUID()` |
| **UnaryOperator\<T>** | `T apply(T t)` | Bir xil tur | `n -> n * n` |
| **BinaryOperator\<T>** | `T apply(T t1, T t2)` | Ikki parametr | `(a,b) -> a + b` |
| **BiFunction\<T,U,R>** | `R apply(T t, U u)` | Ikki tur | `(a,b) -> a + " " + b` |
| **BiPredicate\<T,U>** | `boolean test(T t, U u)` | Ikki parametrli test | `(s,i) -> s.length() > i` |
| **BiConsumer\<T,U>** | `void accept(T t, U u)` | Ikki parametrli iste'mol | `(k,v) -> map.put(k,v)` |

---

## 8.4 - Primitive Functional Interfaces

### Nima uchun primitive functional interface'lar kerak?

Generic functional interface'lar primitive tiplar bilan ishlaganda boxing/unboxing qiladi, bu esa performance'ni pasaytiradi.

```java
// ❌ Generic - boxing/unboxing
Predicate<Integer> isEven = n -> n % 2 == 0;
// n % 2 da n int ga unbox qilinadi

// ✅ Primitive - boxing/unboxing yo'q
IntPredicate isEvenPrimitive = n -> n % 2 == 0;
```

### Primitive Functional Interface turlari

#### 1. XXX (Input primitive, Output reference)
```java
// IntFunction<R> - int -> R
IntFunction<String> intToString = i -> "Number: " + i;
String result = intToString.apply(10);  // "Number: 10"

// DoubleFunction<R> - double -> R
DoubleFunction<Integer> doubleToInt = d -> (int) d;

// LongFunction<R> - long -> R
LongFunction<Date> longToDate = Date::new;
```

#### 2. ToXXX (Input reference, Output primitive)
```java
// ToIntFunction<T> - T -> int
ToIntFunction<String> stringLength = s -> s.length();
int len = stringLength.applyAsInt("Hello");  // 5

// ToLongFunction<T> - T -> long
ToLongFunction<Date> dateToLong = Date::getTime;

// ToDoubleFunction<T> - T -> double
ToDoubleFunction<Integer> intToDouble = i -> i * 1.5;
```

#### 3. XXXToYYY (Input primitive, Output primitive)
```java
// IntToLongFunction - int -> long
IntToLongFunction intToLong = i -> i * 1000L;

// IntToDoubleFunction - int -> double
IntToDoubleFunction intToDouble = i -> i / 2.0;

// LongToIntFunction - long -> int
LongToIntFunction longToInt = l -> (int) l;

// LongToDoubleFunction - long -> double
LongToDoubleFunction longToDouble = l -> l / 3.0;

// DoubleToIntFunction - double -> int
DoubleToIntFunction doubleToInt = d -> (int) d;

// DoubleToLongFunction - double -> long
DoubleToLongFunction doubleToLong = d -> (long) d;
```

#### 4. Primitive Predicates
```java
// IntPredicate - int test
IntPredicate isEven = n -> n % 2 == 0;
IntPredicate isPositive = n -> n > 0;

IntPredicate isEvenAndPositive = isEven.and(isPositive);

// LongPredicate - long test
LongPredicate isBig = n -> n > 1_000_000L;

// DoublePredicate - double test
DoublePredicate isValid = d -> d > 0.0 && d < 1.0;
```

#### 5. Primitive Consumers
```java
// IntConsumer
IntConsumer printInt = n -> System.out.println("Int: " + n);

// LongConsumer
LongConsumer printLong = l -> System.out.println("Long: " + l);

// DoubleConsumer
DoubleConsumer printDouble = d -> System.out.println("Double: " + d);
```

#### 6. Primitive Suppliers
```java
// IntSupplier
IntSupplier randomInt = () -> (int) (Math.random() * 100);

// LongSupplier
LongSupplier currentTime = System::currentTimeMillis;

// DoubleSupplier
DoubleSupplier randomDouble = Math::random;

// BooleanSupplier
BooleanSupplier isLucky = () -> Math.random() > 0.5;
```

#### 7. Primitive Unary/Binary Operators
```java
// IntUnaryOperator - int -> int
IntUnaryOperator square = n -> n * n;
IntUnaryOperator increment = n -> n + 1;

// IntBinaryOperator - (int, int) -> int
IntBinaryOperator sum = (a, b) -> a + b;

// LongUnaryOperator, LongBinaryOperator
// DoubleUnaryOperator, DoubleBinaryOperator
```

### Primitive vs Generic Performance

```java
public class PerformanceComparison {
    public static void main(String[] args) {
        int iterations = 10_000_000;
        
        // Generic with boxing/unboxing
        long start = System.nanoTime();
        Predicate<Integer> genericPredicate = n -> n % 2 == 0;
        for (int i = 0; i < iterations; i++) {
            genericPredicate.test(i);  // Boxing + unboxing
        }
        long genericTime = System.nanoTime() - start;
        
        // Primitive - no boxing/unboxing
        start = System.nanoTime();
        IntPredicate primitivePredicate = n -> n % 2 == 0;
        for (int i = 0; i < iterations; i++) {
            primitivePredicate.test(i);  // Direct primitive
        }
        long primitiveTime = System.nanoTime() - start;
        
        System.out.printf("Generic: %.2f ms%n", genericTime / 1_000_000.0);
        System.out.printf("Primitive: %.2f ms%n", primitiveTime / 1_000_000.0);
        // Primitive odatda 2-3 marta tezroq
    }
}
```

---

## 8.5 - Method References

### Method Reference nima?

**Method Reference** - lambda expression'larni yanada qisqa va o'qilishi oson qilish uchun ishlatiladigan sintaksis.

```java
// Lambda
Function<String, Integer> f1 = s -> s.length();

// Method reference
Function<String, Integer> f2 = String::length;

// Lambda
Consumer<String> c1 = s -> System.out.println(s);

// Method reference
Consumer<String> c2 = System.out::println;
```

### Method Reference turlari

#### 1. Static method reference
```java
public class StaticMethodReference {
    
    public static void main(String[] args) {
        // Lambda
        Function<String, Integer> parseInt1 = s -> Integer.parseInt(s);
        
        // Method reference
        Function<String, Integer> parseInt2 = Integer::parseInt;
        
        // Lambda
        Consumer<List<Integer>> sort1 = list -> Collections.sort(list);
        
        // Method reference
        Consumer<List<Integer>> sort2 = Collections::sort;
        
        // Lambda
        Supplier<Long> currentTime1 = () -> System.currentTimeMillis();
        
        // Method reference
        Supplier<Long> currentTime2 = System::currentTimeMillis;
    }
}
```

#### 2. Instance method reference of a particular object
```java
public class InstanceMethodReference {
    
    public static void main(String[] args) {
        List<String> list = new ArrayList<>();
        
        // Lambda
        Consumer<String> addToList1 = s -> list.add(s);
        
        // Method reference
        Consumer<String> addToList2 = list::add;
        
        // Lambda
        Supplier<String> toString1 = () -> list.toString();
        
        // Method reference
        Supplier<String> toString2 = list::toString;
        
        // Real misol
        String prefix = "Hello, ";
        Function<String, String> addPrefix = prefix::concat;
        System.out.println(addPrefix.apply("World"));  // "Hello, World"
    }
}
```

#### 3. Instance method reference of an arbitrary object of a particular type
```java
public class ArbitraryObjectReference {
    
    public static void main(String[] args) {
        // Lambda
        Function<String, String> toLowerCase1 = s -> s.toLowerCase();
        
        // Method reference
        Function<String, String> toLowerCase2 = String::toLowerCase;
        
        // Lambda
        BiPredicate<String, String> equals1 = (s1, s2) -> s1.equals(s2);
        
        // Method reference
        BiPredicate<String, String> equals2 = String::equals;
        
        // Lambda
        Function<String, Integer> length1 = s -> s.length();
        
        // Method reference
        Function<String, Integer> length2 = String::length;
        
        // List'da ishlatish
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
        names.stream()
            .map(String::toUpperCase)  // Arbitrary object method reference
            .forEach(System.out::println);
    }
}
```

#### 4. Constructor reference
```java
public class ConstructorReference {
    
    static class Employee {
        private String id;
        private String name;
        
        public Employee() {
            this.id = UUID.randomUUID().toString();
        }
        
        public Employee(String id) {
            this.id = id;
        }
        
        public Employee(String id, String name) {
            this.id = id;
            this.name = name;
        }
    }
    
    public static void main(String[] args) {
        // Zero-argument constructor
        Supplier<Employee> supplier1 = () -> new Employee();
        Supplier<Employee> supplier2 = Employee::new;
        Employee emp = supplier2.get();
        
        // One-argument constructor
        Function<String, Employee> function1 = id -> new Employee(id);
        Function<String, Employee> function2 = Employee::new;
        Employee empWithId = function2.apply("EMP001");
        
        // Two-argument constructor
        BiFunction<String, String, Employee> biFunc1 = 
            (id, name) -> new Employee(id, name);
        BiFunction<String, String, Employee> biFunc2 = Employee::new;
        Employee empWithIdName = biFunc2.apply("EMP002", "John Doe");
        
        // Array constructor
        IntFunction<Employee[]> arrayCreator = Employee[]::new;
        Employee[] employees = arrayCreator.apply(10);
    }
}
```

### Method Reference Conversion Table

| Lambda | Method Reference | Description |
|--------|-----------------|-------------|
| `s -> Integer.parseInt(s)` | `Integer::parseInt` | Static method |
| `list -> list.add(e)` | `list::add` | Particular object |
| `s -> s.toLowerCase()` | `String::toLowerCase` | Arbitrary object |
| `() -> new Employee()` | `Employee::new` | Constructor |
| `len -> new int[len]` | `int[]::new` | Array constructor |

---

## Amaliy misollar

### Misol 1: Filtering with Predicate

```java
public class FilteringExample {
    
    public static <T> List<T> filter(List<T> list, Predicate<T> predicate) {
        List<T> result = new ArrayList<>();
        for (T item : list) {
            if (predicate.test(item)) {
                result.add(item);
            }
        }
        return result;
    }
    
    public static void main(String[] args) {
        List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);
        
        // Lambda bilan
        List<Integer> evens = filter(numbers, n -> n % 2 == 0);
        List<Integer> odds = filter(numbers, n -> n % 2 != 0);
        List<Integer> greaterThan5 = filter(numbers, n -> n > 5);
        
        // Predicate composition
        Predicate<Integer> isEven = n -> n % 2 == 0;
        Predicate<Integer> isGreaterThan5 = n -> n > 5;
        
        List<Integer> evenGreaterThan5 = filter(numbers, 
            isEven.and(isGreaterThan5));
        
        System.out.println("Even > 5: " + evenGreaterThan5);  // [6, 8, 10]
    }
}
```

### Misol 2: Processing with Consumer

```java
public class ProcessingExample {
    
    public static <T> void process(List<T> list, Consumer<T> consumer) {
        for (T item : list) {
            consumer.accept(item);
        }
    }
    
    public static void main(String[] args) {
        List<String> names = Arrays.asList("Alice", "Bob", "Charlie");
        
        // Different consumers
        Consumer<String> print = System.out::println;
        Consumer<String> saveToFile = s -> {
            try {
                Files.writeString(Path.of("names.txt"), s + "\n", 
                    StandardOpenOption.APPEND);
            } catch (IOException e) {
                e.printStackTrace();
            }
        };
        
        // Chain consumers
        Consumer<String> printAndSave = print.andThen(saveToFile);
        process(names, printAndSave);
    }
}
```

### Misol 3: Transformation with Function

```java
public class TransformationExample {
    
    public static <T, R> List<R> map(List<T> list, Function<T, R> function) {
        List<R> result = new ArrayList<>();
        for (T item : list) {
            result.add(function.apply(item));
        }
        return result;
    }
    
    public static void main(String[] args) {
        List<String> words = Arrays.asList("hello", "world", "java");
        
        // Different transformations
        List<Integer> lengths = map(words, String::length);
        List<String> upperCase = map(words, String::toUpperCase);
        List<String> reversed = map(words, 
            s -> new StringBuilder(s).reverse().toString());
        
        // Chain functions
        Function<String, String> toUpper = String::toUpperCase;
        Function<String, String> reverse = s -> new StringBuilder(s).reverse().toString();
        Function<String, String> upperThenReverse = toUpper.andThen(reverse);
        
        List<String> transformed = map(words, upperThenReverse);
        // "hello" -> "HELLO" -> "OLLEH"
    }
}
```

### Misol 4: Lazy initialization with Supplier

```java
public class LazyInitializationExample {
    
    static class HeavyResource {
        public HeavyResource() {
            System.out.println("HeavyResource created");
            // Expensive initialization
        }
        
        public void process() {
            System.out.println("Processing...");
        }
    }
    
    static class ResourceManager {
        private Supplier<HeavyResource> resourceSupplier = 
            this::createHeavyResource;
        
        private HeavyResource resource;
        
        private HeavyResource createHeavyResource() {
            resource = new HeavyResource();
            return resource;
        }
        
        public HeavyResource getResource() {
            return resourceSupplier.get();
        }
    }
    
    public static void main(String[] args) {
        ResourceManager manager = new ResourceManager();
        System.out.println("Manager created, resource not yet initialized");
        
        // Resource faqat kerak bo'lganda yaratiladi
        manager.getResource().process();
    }
}
```

---

## Tekshiruv Savollari

### Lesson 8 - Behavior Parameterization

1. **Behaviour parametrization nima?**
2. **Behaviour parametrization qanday muammolarni hal qiladi?**
3. **Lambda expression nima?**
4. **Lambda expression larda qanday qoidalar mavjud?**
5. **Final hamda Effectively final o'zgaruvchilarning farqi nimada?**
6. **Qayerlarda Lambda ni ishlatgan to'gri bo'ladi?**

### Interview Questions

1. **Functional Interface qanday interface?**
2. **@FunctionalInterface annotatsiyasini vazifasi nima?**
3. **Predicate vazifasi nima?**
4. **Consumer vazifasi nima?**
5. **Function vazifasi nima?**
6. **Supplier vazifasi nima?**
7. **UnaryOperator vazifasi nima?**
8. **BinaryOperator vazifasi nima?**
9. **Primitive Functional Interface nima uchun kerak?**
10. **Primitive Functional Interface qanday vaziyatlarda ishlatiladi?**
11. **Method Reference nima?**
12. **Method Reference ni qanday turlari bor?**
13. **Constructor as method reference nima?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega loyiha yarating:

1. **Filter operations** - Predicate bilan turli xil filterlash
2. **Map operations** - Function bilan transformatsiya
3. **Reduce operations** - BinaryOperator bilan yig'ish
4. **Lazy evaluation** - Supplier bilan
5. **Custom functional interface** - O'zingizning functional interface'ingizni yarating

```java
// Tekshirish:
List<Integer> numbers = Arrays.asList(1, 2, 3, 4, 5, 6, 7, 8, 9, 10);

// Filter even numbers
List<Integer> evens = filter(numbers, n -> n % 2 == 0);

// Square them
List<Integer> squares = map(evens, n -> n * n);

// Sum them
int sum = reduce(squares, 0, Integer::sum);
```

---

**Keyingi mavzu:** [Stream API](./09_Stream_API.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
