# Java Cheat Sheet - To'liq Qo'llanma

## Java nima?

**Java** - 1991 yilda James Gosling tomonidan ishlab chiqilgan yuqori darajali, ob'ektga yo'naltirilgan dasturlash tili. **WORA (Write Once, Run Anywhere)** prinsipi asosida ishlaydi - bir marta yozilgan kod istalgan operatsion tizimda ishlay oladi.

### Java Buzzwords (Asosiy xususiyatlari)

- **Platform-independent** - JVM orqali istalgan operatsion tizimda ishlaydi
- **Object-oriented** - Class va object'larga asoslangan
- **Robust** - Xatoliklardan himoyalangan (exception handling, memory management)
- **Secure** - Xavfsizlik mexanizmlari o'rnatilgan
- **Multi-threaded** - Bir vaqtning o'zida bir nechta vazifalarni bajarish imkoniyati

---

## 1. Java Terminologiyasi

<details>
<summary> **JVM (Java Virtual Machine)**</summary>

**Nima?** Java bytecode'ni bajaruvchi virtual mashina.
**Vazifasi:** Compiler tomonidan generatsiya qilingan bytecode'ni interpretatsiya qiladi va operatsion tizimga mos keladigan kodga o'tkazadi.
</details>

<details>
<summary> **Bytecode**</summary>

**Nima?** JDK dagi javac compiler tomonidan Java source code'dan generatsiya qilinadigan oraliq kod.
**Vazifasi:** JVM tomonidan tushuniladigan va bajariladigan format.
</details>

<details>
<summary> **JDK (Java Development Kit)**</summary>

**Nima?** To'liq Java rivojlantirish to'plami.
**Tarkibi:** Compiler (javac), JRE, debugger, dokumentatsiya vositalari va boshqalar.
</details>

<details>
<summary> **JRE (Java Runtime Environment)**</summary>

**Nima?** Java dasturlarini ishga tushirish muhiti.
**Vazifasi:** Java dasturlarini bajarish imkonini beradi (lekin kompilyatsiya qila olmaydi).
</details>

<details>
<summary> **Garbage Collector**</summary>

**Nima?** JVM tarkibidagi xotirani boshqarish dasturi.
**Vazifasi:** Foydalanilmayotgan object'lar egallagan xotirani avtomatik tozalash.
</details>

<details>
<summary> **finalize() metodi**</summary>

**Nima?** Garbage Collector tomonidan object yo'q qilinishidan oldin chaqiriladigan metod.
**Vazifasi:** Object bilan bog'liq resurslarni tozalash imkoniyati.
</details>

---

## 2. Java Asoslari

### Object (Ob'ekt)

**Nima?** Holat (state) va xatti-harakatga (behavior) ega bo'lgan entity. Masalan: velosiped, stul, ruchka, mashina.

**Object xususiyatlari:**

| Xususiyat | Tavsif |
|-----------|--------|
| **State (Holat)** | Ob'ektning ma'lumotlari (qiymatlari) |
| **Behavior (Xatti-harakat)** | Ob'ektning funksionalligi (metodlari) |
| **Identity (Identifikatsiya)** | Har bir ob'ektning unikal ID si (JVM ichki ishlatadi) |

### Class (Sinf)

**Nima?** O'xshash xususiyatlarga ega ob'ektlar to'plami. Ob'ektlar yaratish uchun shablon (blueprint).

**Class elementi:**

```java
public class Car {                    // class nomi
    // Fields (xususiyatlar)
    private String color;             // state
    private int speed;                // state
    
    // Constructor (konstruktor)
    public Car(String color) {
        this.color = color;
    }
    
    // Methods (metodlar)
    public void accelerate() {        // behavior
        speed += 10;
    }
}
```

### Constructor (Konstruktor)

**Nima?** Yangi ob'ekt yaratilganda chaqiriladigan maxsus metod. Ob'ektga xotira ajratiladi va boshlang'ich qiymatlar o'rnatiladi.

**Konstruktor turlari:**

| Tur | Tavsif | Misol |
|-----|--------|-------|
| **Default Constructor** | Parametrsiz, compiler tomonidan avtomatik yaratiladi | `Car() {}` |
| **Parameterized Constructor** | Parametrli, custom qiymatlar o'rnatish uchun | `Car(String color) {}` |
| **Copy Constructor** | Boshqa ob'ektdan nusxa olish | `Car(Car other) {}` |

### Keyword (Kalit so'zlar)

**Nima?** Java tilida maxsus ma'noga ega bo'lgan so'zlar (61 ta). O'zgaruvchi, metod yoki class nomi sifatida ishlatib bo'lmaydi.

```java
// Java kalit so'zlariga misollar
public class Example {
    private int number;           // private - kalit so'z
    public static void main() {   // public, static, void - kalit so'zlar
        if (number > 0) {         // if - kalit so'z
            // code
        }
    }
}
```

---

## 3. Hello World Dasturi

```java
class GFG {
    public static void main(String[] args) {
        System.out.println("Hello World!");
    }
}
```

**Tushuntirish:**
- `class GFG` - class e'lon qilish
- `public static void main` - dasturning boshlanish nuqtasi
- `String[] args` - komanda qatoridan argumentlar qabul qilish
- `System.out.println` - konsolga chiqarish

---

## 4. Ma'lumot Turlari (Data Types)

### Primitive (Asosiy) Turlar

| Tur | Hajmi | Qiymat oralig'i | Misol |
|-----|-------|-----------------|-------|
| **byte** | 1 bayt | -128 dan 127 gacha | `byte b = 100;` |
| **short** | 2 bayt | -32,768 dan 32,767 gacha | `short s = 10000;` |
| **int** | 4 bayt | ~ -2 milliard dan 2 milliard gacha | `int i = 100000;` |
| **long** | 8 bayt | Juda katta | `long l = 100000L;` |
| **float** | 4 bayt | ~ ±3.4E-38 dan ±3.4E+38 gacha | `float f = 3.14f;` |
| **double** | 8 bayt | ~ ±1.7E-308 dan ±1.7E+308 gacha | `double d = 3.14159;` |
| **char** | 2 bayt | Unicode belgilar | `char c = 'A';` |
| **boolean** | 1 bit | true yoki false | `boolean flag = true;` |

### Non-primitive (Murakkab) Turlar

Primitive turlardan yaratiladi:
- **String** - matnlar
- **Array** - massivlar
- **Class** - sinflar
- **Interface** - interfeyslar

```java
String name = "John";
int[] numbers = {1, 2, 3, 4, 5};
```

---

## 5. Kommentariyalar (Comments)

### 1. Single-line comment
```java
// Bu bitta qatorlik komment
System.out.println("Hello"); // Bu ham komment
```

### 2. Multi-line comment
```java
/*
 Bu bir nechta
 qatorlik
 komment
*/
```

### 3. JavaDoc comment
```java
/**
 * Bu metod ikki sonni qo'shadi
 * @param a birinchi son
 * @param b ikkinchi son
 * @return yig'indi
 */
public int add(int a, int b) {
    return a + b;
}
```

---

## 6. O'zgaruvchilar (Variables)

**Syntax:** `data_type variable_name;`

### O'zgaruvchi turlari:

| Tur | Tavsif | Misol |
|-----|--------|-------|
| **Local** | Metod/block ichida e'lon qilinadi | `void method() { int x = 5; }` |
| **Instance** | Class ichida, metodlardan tashqarida (non-static) | `class Car { String color; }` |
| **Static** | Classga tegishli, barcha ob'ektlar uchun umumiy | `static int count = 0;` |

```java
class GFG {
    static int staticVar = 100;      // static o'zgaruvchi
    int instanceVar = 50;             // instance o'zgaruvchi
    
    public void method() {
        int localVar = 10;             // local o'zgaruvchi
        System.out.println(localVar);
    }
}
```

---

## 7. Access Modifiers (Kirish darajalari)

| Modifier | Class | Package | Subclass | Global |
|----------|-------|---------|----------|--------|
| **private** | ✓ | ✗ | ✗ | ✗ |
| **default** | ✓ | ✓ | ✗ | ✗ |
| **protected** | ✓ | ✓ | ✓ | ✗ |
| **public** | ✓ | ✓ | ✓ | ✓ |

```java
public class Example {
    private int privateVar;      // faqat shu classda
    int defaultVar;              // package ichida
    protected int protectedVar;  // package + subclass
    public int publicVar;        // hamma joyda
}
```

---

## 8. Operatorlar

### Precedence (Ustunlik) jadvali

| Operatorlar | Associativity | Tur |
|-------------|---------------|-----|
| `++, --` | Right to Left | Unary postfix |
| `++, --, +, -, !` | Right to Left | Unary prefix |
| `*, /, %` | Left to Right | Multiplicative |
| `+, -` | Left to Right | Additive |
| `<, <=, >, >=` | Left to Right | Relational |
| `==, !=` | Left to Right | Equality |
| `&` | Left to Right | Boolean AND |
| `^` | Left to Right | Boolean XOR |
| `\|` | Left to Right | Boolean OR |
| `&&` | Left to Right | Conditional AND |
| `\|\|` | Left to Right | Conditional OR |
| `?:` | Right to Left | Conditional |
| `=, +=, -=, *=, /=, %=` | Right to Left | Assignment |

---

## 9. Identifikatorlar (Identifiers)

**Nima?** Class, o'zgaruvchi va metodlarga beriladigan nomlar.

**Qoidalar:**
- Harflar (A-Z, a-z), raqamlar (0-9), `$` va `_` ishlatish mumkin
- Raqam bilan boshlanib bo'lmaydi
- Case-sensitive (`myVar` ≠ `MyVar`)
- Kalit so'zlar ishlatilmaydi (`int`, `while` va h.k.)
- Maxsus belgilar (`@`, `#`) ishlatilmaydi

✅ **To'g'ri:** `myVar`, `_temp`, `$value`, `counter1`
❌ **Noto'g'ri:** `1var`, `my-var`, `class`, `my@var`

---

## 10. Control Flow (Boshqaruv oqimlari)

### If-else if-else

```java
int a = 1, b = 2;
if (a < b) {
    System.out.println(b);           // a < b bo'lsa
} else if (a > b) {
    System.out.println(a);           // a > b bo'lsa
} else {
    System.out.println(a + "==" + b); // teng bo'lsa
}
```

### Nested if (Ichma-ich if)

```java
int i = 1;
if (i == 10 || i < 15) {
    if (i < 15) {
        System.out.println("i is smaller than 15");
    }
    if (i < 12) {
        System.out.println("i is smaller than 12 too");
    }
}
```

### Switch Statement

```java
int day = 5;
String dayString;

switch (day) {
    case 1:  dayString = "Monday";    break;
    case 2:  dayString = "Tuesday";   break;
    case 3:  dayString = "Wednesday"; break;
    case 4:  dayString = "Thursday";  break;
    case 5:  dayString = "Friday";    break;
    case 6:  dayString = "Saturday";  break;
    case 7:  dayString = "Sunday";    break;
    default: dayString = "Invalid day";
}
System.out.println(dayString);  // "Friday"
```

### Loops (Tsikllar)

**For loop:**
```java
for (int i = 1; i <= 5; i++) {
    System.out.println(i);  // 1,2,3,4,5
}
```

**While loop:**
```java
int i = 1;
while (i <= 5) {
    System.out.println(i);
    i++;
}
```

**Do-while loop:**
```java
int i = 1;
do {
    System.out.println(i);
    i++;
} while (i <= 5);
```

---

## 11. Metodlar (Methods)

**Syntax:** `<access_modifier> <return_type> <method_name>(parameters) { body }`

```java
public class GFG {
    // Metod yaratish
    public static int sum(int i, int j) { 
        return i + j; 
    }
    
    // Metodni chaqirish
    public static void main(String[] args) {
        int result = sum(5, 3);  // 8
        System.out.println(result);
    }
}
```

---

## 12. Input/Output (Kiritish/Chiqarish)

### Chiqarish (Output)

```java
System.out.print("Hello");     // Yangi qatorga o'tmaydi
System.out.println("Hello");   // Yangi qatorga o'tadi
System.out.printf("%.2f", 3.14159);  // Formatlangan chiqarish (3.14)
```

### Kiritish (Input)

**1. Command-line argumentlar:**
```java
class GFG {
    public static void main(String args[]) {
        for (int i = 0; i < args.length; i++)
            System.out.println(args[i]);
    }
}
// java GFG Hello World
// Output: Hello World
```

**2. BufferedReader:**
```java
BufferedReader bfn = new BufferedReader(
    new InputStreamReader(System.in));
String str = bfn.readLine();           // String o'qish
int it = Integer.parseInt(bfn.readLine());  // Integer o'qish
```

**3. Scanner:**
```java
Scanner scn = new Scanner(System.in);
String name = scn.nextLine();    // String o'qish
int age = scn.nextInt();          // int o'qish
float marks = scn.nextFloat();    // float o'qish
```

---

## 13. Polymorphism (Polimorfizm)

**Nima?** Bir metod yoki ob'ektning turli shakllarda bo'lish qobiliyati.

### Turlari:

| Tur | Tavsif | Misol |
|-----|--------|-------|
| **Compile-time (Static)** | Method overloading | Bir nomli, turli parametrli metodlar |
| **Runtime (Dynamic)** | Method overriding | Subclassda superclass metodini qayta yozish |

```java
class ABC {
    // Method overloading - bir nom, turli parametrlar
    public int sum(int x, int y) { return x + y; }
    public double sum(double x, double y) { return x + y; }
}

class XYZ extends ABC {
    // Method overriding - subclassda qayta yozish
    @Override
    public int sum(int x, int y) { 
        return x + y + 10;  // parentdan farqli
    }
}
```

---

## 14. Inheritance (Vorislik)

**Nima?** Bir classning boshqa class xususiyatlarini meros qilib olishi.

```java
// Base class
class Employee {
    int salary = 70000;
}

// Derived class
class Engineer extends Employee {
    int benefits = 15000;
}

// Foydalanish
Engineer eng = new Engineer();
System.out.println("Salary: " + eng.salary);      // 70000
System.out.println("Benefits: " + eng.benefits);  // 15000
```

---

## 15. Math Class

```java
import java.lang.Math;  // Avtomatik import qilinadi

Math.abs(-10);          // 10 (absolute)
Math.max(10, 20);       // 20 (maksimum)
Math.min(10, 20);       // 10 (minimum)
Math.sqrt(25);          // 5.0 (kvadrat ildiz)
Math.pow(2, 3);         // 8.0 (daraja)
Math.random();          // 0.0-1.0 oralig'ida random son
Math.round(3.6);        // 4 (yaxlitlash)
Math.floor(3.6);        // 3.0 (pastga yaxlitlash)
Math.ceil(3.2);         // 4.0 (yuqoriga yaxlitlash)
```

---

## 16. Type Casting (Tip o'zgartirish)

### Widening (Kengaytirish) - Avtomatik
```java
int a = 3;
double db = a;           // int -> double (avtomatik)
System.out.println(db);  // 3.0
```

### Narrowing (Toraytirish) - Manual
```java
double db = 3.14;
int a = (int) db;        // double -> int (manual)
System.out.println(a);   // 3
```

---

## 17. Arrays (Massivlar)

### Bir o'lchovli massiv
```java
// Yaratish
int[] arr = new int[5];           // usul 1
int arr2[] = new int[5];          // usul 2

// Qiymat berish
arr[0] = 10;
arr[1] = 20;

// Initializatsiya
int[] numbers = {10, 20, 30, 40, 50};

// O'qish
for (int i = 0; i < arr.length; i++) {
    System.out.println(arr[i]);
}
```

### Ko'p o'lchovli massiv
```java
int[][] matrix = {
    {1, 2, 3},
    {4, 5, 6},
    {7, 8, 9}
};

for (int i = 0; i < 3; i++) {
    for (int j = 0; j < 3; j++) {
        System.out.print(matrix[i][j] + " ");
    }
    System.out.println();
}
```

---

## 18. Strings (Satrlar)

### String yaratish
```java
String s1 = "Hello";                    // String literal
String s2 = new String("Hello");        // String object
```

### String metodlari
```java
String str = "Hello World";

str.length();                    // 11 (uzunlik)
str.charAt(1);                    // 'e' (belgi)
str.substring(0, 5);              // "Hello" (qism)
str.toLowerCase();                 // "hello world"
str.toUpperCase();                 // "HELLO WORLD"
str.trim();                        // bosh/oxirgi bo'shliqlarni olib tashlash
str.replace('l', 'p');             // "Heppo World"
str.contains("World");             // true
str.startsWith("He");              // true
str.endsWith("ld");                // true
str.indexOf('o');                   // 4 (birinchi index)
str.split(" ");                     // ["Hello", "World"]
```

### StringBuffer / StringBuilder
```java
StringBuffer sb = new StringBuffer("Hello");
sb.append(" World");                // "Hello World"
sb.insert(5, " Java");              // "Hello Java World"
sb.delete(5, 10);                   // "HelloWorld"
sb.reverse();                       // "dlroWolleH"
```

---

## 19. Regex (Regular Expressions)

```java
import java.util.regex.*;

Pattern pattern = Pattern.compile("a*b");           // Pattern yaratish
Matcher matcher = pattern.matcher("aaaab");        // Matcher yaratish

boolean found = matcher.find();                    // moslik borligi
boolean matches = matcher.matches();                // to'liq moslik
String replaced = matcher.replaceAll("X");          // almashtirish
```

**Asosiy patternlar:**
- `\d` - raqam
- `\w` - so'z belgisi (a-z, A-Z, 0-9, _)
- `\s` - bo'shliq
- `[a-z]` - a dan z gacha
- `[0-9]` - 0 dan 9 gacha
- `a*` - 0 yoki undan ko'p
- `a+` - 1 yoki undan ko'p
- `a?` - 0 yoki 1 marta

---

## 20. Exception Handling (Xatolarni boshqarish)

**Nima?** Dastur ishlash vaqtidagi kutilmagan xatoliklarni boshqarish.

```java
try {
    // Xatolik yuz berishi mumkin bo'lgan kod
    int result = 10 / 0;
} catch (ArithmeticException e) {
    // Xatolikni qayta ishlash
    System.out.println("Cannot divide by zero: " + e.getMessage());
} finally {
    // Har doim bajariladi
    System.out.println("This always executes");
}
```

### throw vs throws
```java
// throw - exception tashlash
public void validateAge(int age) {
    if (age < 18) {
        throw new IllegalArgumentException("Too young");
    }
}

// throws - exception'ni deklaratsiya qilish
public void readFile() throws IOException {
    FileReader file = new FileReader("test.txt");
}
```

### final vs finally vs finalize()

| Kalit so'z | Qo'llanish | Tavsif |
|------------|------------|--------|
| **final** | class, metod, variable | O'zgarmas |
| **finally** | try-catch bilan | Har doim bajariladi |
| **finalize()** | metod | GC tomonidan chaqiriladi |

---

## 21. Java Komandalari

| Komanda | Tavsif |
|---------|--------|
| `java -version` | JRE versiyasini ko'rsatish |
| `java -help` | Java komandalari ro'yxati |
| `java -cp` | Classpath belgilash |
| `java -jar` | JAR faylni ishga tushirish |
| `java -D` | System property o'rnatish |
| `java -X` | JVM non-standard option |
| `javac` | Java source code'ni kompilyatsiya qilish |
| `javap` | Java class faylni disassembly qilish |
| `jdb` | Java debugger |
| `jconsole` | Java monitoring vositasi |
| `jvisualvm` | Java profiling vositasi |

---

## 22. Generics

**Nima?** Class, interface va metodlarni turli tiplar bilan ishlash imkonini beradi.

### Generic Class
```java
class Box<T> {
    private T content;
    
    public void set(T content) {
        this.content = content;
    }
    
    public T get() {
        return content;
    }
}

Box<String> stringBox = new Box<>();     // String bilan
Box<Integer> intBox = new Box<>();        // Integer bilan
```

### Generic Method
```java
public <T> T genericMethod(T input) {
    return input;
}
```

### Generic Function
```java
static <T> void genericDisplay(T element) {
    System.out.println(element.getClass().getName() 
                       + " = " + element);
}

genericDisplay(11);              // java.lang.Integer = 11
genericDisplay("Geeks");          // java.lang.String = Geeks
```

---

## 23. Multithreading (Ko'p tarmoqli dasturlash)

### Thread yaratish - Thread class extend
```java
class MyThread extends Thread {
    public void run() {
        System.out.println("Thread " + Thread.currentThread().getId() 
                          + " is running");
    }
}

// Foydalanish
MyThread t = new MyThread();
t.start();
```

### Thread yaratish - Runnable implement
```java
class MyRunnable implements Runnable {
    public void run() {
        System.out.println("Thread running");
    }
}

// Foydalanish
Thread t = new Thread(new MyRunnable());
t.start();
```

---

## 24. Collections Framework

### Collection Hierarchy

```
Iterable (interface)
    └── Collection (interface)
            ├── List (interface)
            │       ├── ArrayList
            │       ├── LinkedList
            │       └── Vector
            ├── Set (interface)
            │       ├── HashSet
            │       ├── LinkedHashSet
            │       └── TreeSet
            └── Queue (interface)
                    ├── PriorityQueue
                    └── Deque (interface)
                            └── ArrayDeque
```

### Map Hierarchy

```
Map (interface)
    ├── HashMap
    ├── LinkedHashMap
    ├── TreeMap
    └── Hashtable
```

### Asosiy Collection'lar

| Interface | Tavsif | Implementatsiyalar |
|-----------|--------|---------------------|
| **List** | Tartibli, dublikatga ruxsat | ArrayList, LinkedList |
| **Set** | Dublikatsiz, tartibsiz | HashSet, LinkedHashSet, TreeSet |
| **Queue** | FIFO navbat | PriorityQueue, ArrayDeque |
| **Map** | Key-value juftliklar | HashMap, TreeMap, LinkedHashMap |

---

## Java nima uchun ishlatiladi?

✅ **Mobile Applications** - Android ilovalar
✅ **Desktop GUI Applications** - Swing, JavaFX
✅ **Artificial Intelligence** - AI/ML ilovalar
✅ **Scientific Applications** - Ilmiy hisoblashlar
✅ **Cloud Applications** - Bulutli xizmatlar
✅ **Embedded Systems** - Qurilmalar
✅ **Gaming Applications** - O'yinlar
✅ **Web Applications** - Spring, Jakarta EE
✅ **Big Data** - Hadoop, Spark
✅ **Enterprise Applications** - Korporativ tizimlar

---

**[Mundarijaga qaytish](../README.md)**

> Java - o'rganish oson, ammo cheksiz imkoniyatlarga ega til! 🚀
