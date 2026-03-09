# 02 - Generics (Umumlashtirilgan Tiplar)

## Generics nima?

**Generics** (Umumlashtirilgan tiplar) - bu turli xil turlar uchun qayta foydalanilishi mumkin bo'lgan kod yozish usuli. Generics parametrlangan tiplar degan ma'noni anglatadi. G'oya shundaki, metodlar, klasslar va interfeyslar uchun tur parametr sifatida ishlatilishi mumkin. Generics yordamida turli ma'lumot turlari bilan ishlaydigan klasslar yaratish mumkin.

**Generic entity** - parameterized type bilan ishlaydigan klass, interfeys yoki metod (Java 1.5'dan beri).

## Generic Class'lar va Method'lar

```java
// Generic klass
public class Box<T> {
    private T content;
    
    public void set(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

// Foydalanish
Box<String> stringBox = new Box<>();
Box<Integer> integerBox = new Box<>();
```

**Atamalar:**
- **Generic class** - Type parameter qabul qiladigan klass
- **Type parameter** - `<T>` kabi belgi
- **Type argument** - `<String>` kabi aniq tur
- **Angle brackets** - `< >` burchakli qavslar
- **Diamond Operator** - `<>` olmos operatori (Java 7+)

## Generics'ning Afzalliklari

### 1. Kuchliroq Type Checking Compile Time'da
Java compiler generik kod uchun kuchli type checking qo'llaydi va type safety buzilganda xatoliklar chiqaradi. Compile-time xatolarni tuzatish runtime xatolarni tuzatishdan osonroq.

```java
//  Compile-time xato
List<String> list = new ArrayList<>();
list.add("Hello");
// list.add(123); // COMPILE ERROR - Type mismatch

//  Runtime xatosiz
List rawList = new ArrayList(); // Raw type - xavfli!
rawList.add("Hello");
rawList.add(123); // Compile error bo'lmaydi, lekin...
String s = (String) rawList.get(1); // ClassCastException runtime'da
```

### 2. Cast'larni Yo'q Qilish
```java
//  Generics'siz (ko'p cast'lar)
List list = new ArrayList();
list.add("Hello");
String s = (String) list.get(0); // Cast kerak

//  Generics bilan
List<String> list = new ArrayList<>();
list.add("Hello");
String s = list.get(0); // Cast kerak emas
```

### 3. Kodni O'qilishi Osonlashadi va Xavfsizligi Orthadi

## Type Variable'lar uchun Cheklovlar (Bounds)

### Single Bound (Bitta Cheklov)
Type parameter'ni ma'lum klassning subtiplari bilan cheklash uchun bounded type parameter ishlatiladi.

```java
public class NumberBox<T extends Number> {
    private T number;
    
    public double getSquare() {
        return number.doubleValue() * number.doubleValue();
    }
}

// Foydalanish
NumberBox<Integer> intBox = new NumberBox<>(); // 
NumberBox<Double> doubleBox = new NumberBox<>(); // 
// NumberBox<String> stringBox = new NumberBox<>(); //  COMPILE ERROR
```

**Vazifasi:** Faqat Number'ning child class'lari bilan ishlash imkonini beradi.

### Multiple Bounds (Bir nechta Cheklovlar)
Type parameter bir nechta cheklovlarga ega bo'lishi mumkin.

```java
// T must be Comparable AND Serializable
public class SerializableComparable<T extends Comparable<T> & Serializable> {
    private T value;
    
    public boolean isGreaterThan(T other) {
        return value.compareTo(other) > 0;
    }
}

//  To'g'ri klass
class Person implements Comparable<Person>, Serializable {
    // implementation
}
SerializableComparable<Person> personBox = new SerializableComparable<>();

// QOIDA: Agar bound'larda klass bo'lsa, u birinchi bo'lishi kerak
// public class Example<T extends String & Comparable> // 
// public class Example<T extends Comparable & String> //  COMPILE ERROR
```

**Vazifasi:** Bir nechta xususiyatlarga ega bo'lgan tiplarni cheklash.

## Generic Kod va Virtual Mashina

### Type Erasure (Tip O'chirilishi)
Generic type aniqlanganda, avtomatik ravishda raw type yaratiladi. Raw type nomi oddiygina generic type nomi bo'lib, type parameter'lar olib tashlanadi.

```java
// Generic kod
public class Box<T> {
    private T content;
    public void set(T content) { this.content = content; }
    public T get() { return content; }
}

// Type erasure'dan keyin
public class Box {
    private Object content; // T -> Object (bound yo'q)
    public void set(Object content) { this.content = content; }
    public Object get() { return content; }
}

// Bounded type bilan
public class NumberBox<T extends Number> {
    private T number;
}
// Type erasure'dan keyin
public class NumberBox {
    private Number number; // T -> Number (bounded)
}
```

**Vazifasi:** Backward compatibility'ni saqlash va runtime performance'ni yaxshilash.

### Generic Method'lar uchun Type Erasure

```java
// Generic method
public static <T extends Comparable<T>> T min(T[] array) {
    // implementation
}

// Type erasure'dan keyin
public static Comparable min(Comparable[] array) {
    // T -> Comparable ga o'zgardi
}
```

### Raw Type (Xom Tur)
Generic klass yoki interfeysning type argumentsiz nomi.

```java
List rawList = new ArrayList(); // Raw type - AVOID!
List<String> stringList = new ArrayList<>(); // Generic type - USE THIS

// Warning: Raw types bypass generic type checks
@SuppressWarnings("rawtypes") // Warning'ni o'chirish (odatda yomon amaliyot)
List list = new ArrayList();
```

**Xavf:** Raw type'lar runtime'da ClassCastException'ga olib kelishi mumkin.

## Generics uchun Cheklovlar

### 1. Primitive Type'lar bilan Generic Type'lar Instantiate Qilish Mumkin Emas
```java
// List<int> list = new ArrayList<>(); //  COMPILE ERROR
List<Integer> list = new ArrayList<>(); // 
```

### 2. Type Parameter'larining Instance'larini Yaratish Mumkin Emas
```java
public class Box<T> {
    // private T instance = new T(); //  COMPILE ERROR
    
    // Yechim: Reflection yordamida
    public T createInstance(Class<T> clazz) throws Exception {
        return clazz.newInstance(); // 
    }
}
```

### 3. Static Field'lar Type Parameter Turida Bo'lishi Mumkin Emas
```java
public class Box<T> {
    // private static T staticField; //  COMPILE ERROR
    private static int count; // 
}
```

**Sabab:** Static field'lar barcha instance'lar uchun bir xil, type parameter esa har bir instance uchun har xil bo'lishi mumkin.

### 4. instanceof Parameterized Type'lar bilan Ishlatilmaydi
```java
List<String> list = new ArrayList<>();
// if (list instanceof List<String>) { } //  COMPILE ERROR
if (list instanceof List) { } //  Raw type bilan
```

### 5. Parameterized Type'lar Object'larini Yarata/Catch/Throw Qilish Mumkin Emas
```java
// class MyException<T> extends Exception { } //  COMPILE ERROR
// throw new T(); //  COMPILE ERROR
```

### 6. Method Overloading Type Erasure Sababli Cheklangan
```java
// public void print(List<String> list) { }
// public void print(List<Integer> list) { } //  COMPILE ERROR
// Erasure'dan keyin ikkalasi ham: public void print(List list)
```

## Generic Type'lar uchun Inheritance Qoidalari

### Pair<Manager> Pair<Employee> ning Subtype'i Emas
```java
class Employee { }
class Manager extends Employee { }

Pair<Employee> employeePair = new Pair<Employee>();
// Pair<Employee> buddies = new Pair<Manager>(); //  COMPILE ERROR

// Sabab: Type safety buzilishi mumkin
Pair<Manager> managerPair = new Pair<Manager>(ceo, cfo);
// Agar ruxsat berilsa:
// Pair<Employee> employeePair = managerPair; // Type casting
// employeePair.setFirst(new Employee()); // Manager emas, Employee qo'shildi
// Manager m = managerPair.getFirst(); // ClassCastException!
```

### Wildcards (Yovvoyi Kartalar)
Type o'zgaruvchanligini qo'llab-quvvatlash uchun.

```java
// 1. Unbounded Wildcard (?)
public void printList(List<?> list) {
    for (Object item : list) {
        System.out.println(item);
    }
}

// 2. Upper Bounded Wildcard (? extends Type)
public double sum(List<? extends Number> list) {
    double total = 0;
    for (Number num : list) {
        total += num.doubleValue();
    }
    return total;
}

// 3. Lower Bounded Wildcard (? super Type)
public void addNumbers(List<? super Integer> list) {
    for (int i = 1; i <= 10; i++) {
        list.add(i); // Integer qo'shish mumkin
    }
}
```

**PECS (Producer Extends, Consumer Super) printsipi:**
- **Producer** bo'lsa (ma'lumot o'qiydigan) - `? extends T`
- **Consumer** bo'lsa (ma'lumot yozadigan) - `? super T`

## Misollar

### Misol 1: Generic Pair Class
```java
public class Pair<T, U> {
    private T first;
    private U second;
    
    public Pair(T first, U second) {
        this.first = first;
        this.second = second;
    }
    
    public T getFirst() { return first; }
    public U getSecond() { return second; }
    
    public void setFirst(T first) { this.first = first; }
    public void setSecond(U second) { this.second = second; }
    
    @Override
    public String toString() {
        return "Pair{" + first + ", " + second + "}";
    }
}

// Foydalanish
Pair<String, Integer> nameAge = new Pair<>("John", 25);
Pair<Integer, String> idName = new Pair<>(1, "Alice");
```

### Misol 2: Generic Method
```java
public class ArrayUtils {
    // Generic method
    public static <T> T getMiddle(T[] array) {
        if (array == null || array.length == 0) {
            return null;
        }
        return array[array.length / 2];
    }
    
    // Bounded generic method
    public static <T extends Comparable<T>> T max(T[] array) {
        if (array == null || array.length == 0) {
            return null;
        }
        T max = array[0];
        for (T item : array) {
            if (item.compareTo(max) > 0) {
                max = item;
            }
        }
        return max;
    }
}

// Foydalanish
String[] names = {"Alice", "Bob", "Charlie"};
String middle = ArrayUtils.getMiddle(names); // "Bob"

Integer[] numbers = {1, 5, 3, 9, 2};
Integer maxNumber = ArrayUtils.max(numbers); // 9
```

### Misol 3: Generic Interface
```java
// Generic interface
public interface Repository<T, ID> {
    T findById(ID id);
    List<T> findAll();
    void save(T entity);
    void delete(ID id);
}

// Implementation
public class UserRepository implements Repository<User, Long> {
    @Override
    public User findById(Long id) {
        // Database query
        return new User(id, "John Doe");
    }
    
    @Override
    public List<User> findAll() {
        return Arrays.asList(new User(1L, "John"), new User(2L, "Alice"));
    }
    
    // ... other implementations
}

// Entity class
class User {
    private Long id;
    private String name;
    
    // constructor, getters, setters
}
```

### Misol 4: Type Inference (Tur Aniqlash)
```java
import java.util.*;

public class TypeInferenceExample {
    // Diamond operator (Java 7+)
    List<String> list = new ArrayList<>(); // Type inferred as String
    
    // Generic method type inference
    public static <T> List<T> createList(T... elements) {
        List<T> list = new ArrayList<>();
        for (T element : elements) {
            list.add(element);
        }
        return list;
    }
    
    // Foydalanish
    List<String> strings = createList("A", "B", "C"); // T = String
    List<Integer> numbers = createList(1, 2, 3); // T = Integer
}
```

## Tekshiruv Savollari

1. **Generics nima va nima uchun kerak?**
2. **Type erasure nima va qanday ishlaydi?**
3. **Bounded type parameter nima?**
4. **Wildcards (? extends, ? super) qachon ishlatiladi?**
5. **Raw type'lar nima va ularni ishlatish nima uchun xavfli?**
6. **PECS printsipi nimadan iborat?**
7. **Generic method va generic class farqi nima?**

---

**Keyingi mavzu:** [Collections Framework: List Interface](./03_Collections_Framework_List_Interface_1.md)  
**[Mundarijaga qaytish](../README.md)**

---

**Muhim Atamalar:**
- **Generics** - Umumlashtirilgan tiplar
- **Type Parameter** - Tur parametri (T, E, K, V)
- **Type Argument** - Tur argumenti (String, Integer)
- **Bounded Type** - Cheklangan tur
- **Type Erasure** - Tur o'chirilishi
- **Wildcard** - Yovvoyi karta (?)
- **Raw Type** - Xom tur
- **Diamond Operator** - Olmos operatori (<>)

> **Eslatma:** Generics Java'da type safety'ni oshiradi va kodni qayta foydalanish imkonini beradi. Type erasure sababli, generic ma'lumotlar runtime'da yo'qoladi, shuning uchun reflection bilan ishlaganda ehtiyot bo'lish kerak.
