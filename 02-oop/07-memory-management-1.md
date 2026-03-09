# 07 - Memory Management (Xotira Boshqaruvi) - 1-qism

## Memory Management nima?

**Memory Management** - obyektlar yaratish, ular uchun xotira joy ajratish va ishlatilmayotgan (unreachable) obyektlarni xotiradan o'chirish jarayoni.

### Java'da Xotira Boshqaruvi:
- **C/C++** da: Manuel (qo'lda) boshqariladi
- **Java** da: Avtomatik (`Garbage Collector` orqali)

---

## Java Virtual Machine (JVM) Xotira Tuzilmasi

JVM 5 turdagi xotiraga ega:

1. **Heap** (Dinamik xotira) - Obyektlar uchun
2. **Method Area** (Metodlar maydoni) - Klass ma'lumotlari uchun
3. **Stack** (Stek) - Lokal o'zgaruvchilar va method chaqiruqlari uchun
4. **Native Method Stack** (Mahalliy metodlar steki) - Native kodlar uchun
5. **PC Registers** (Dastur hisoblagich registrlari) - Thread'lar uchun

Eng muhim va murakkab strukturaga ega bo'lgani **Heap** xotirasidir.

---

## Stack Xotirasi

### Stack nima?
**Stack** - method chaqiruvchilar va lokal o'zgaruvchilar uchun ishlatiladigan xotira. Har bir thread o'z stack'iga ega.

### Stack Frame (Stek Freym)
Har bir method chaqiruvchida **Stack Frame** yaratiladi va stack'ga qo'shiladi.

```java
public class App {
    public static void main(String[] args) {
        App app = new App();
        app.m2();
        int w = 9;
    }

    public void m1() {
        int a = 13;
        Integer b2 = 12;
        double b = 90;
        m2();
        int q = 12;
    }

    public void m2() {
        int c = 91;
        float f = 90;
    }
}
```

### Kod Ish Jarayoni:

![](../Images/Stack%20Frame.png)

**Ish tartibi:**
1. `main()` methodi chaqiriladi -> Stack Frame yaratiladi
2. `m1()` chaqiriladi -> Yangi Stack Frame yaratiladi
3. `m2()` chaqiriladi -> Yangi Stack Frame yaratiladi
4. `m2()` tugagach -> Stack Frame o'chiriladi
5. `m1()` tugagach -> Stack Frame o'chiriladi
6. `main()` tugagach -> Stack Frame o'chiriladi

### LIFO (Last In, First Out) Prinsipi:
**Oxiri kirgan - birinchi chiqadi**  
Method chaqirilganda stack'ga qo'shiladi, ishi tugaganda stack'dan o'chiriladi.

---

## Stack Frame Tuzilmasi

Har bir Stack Frame 3 qismdan iborat:

### 1. Local Variable Array (Lokal o'zgaruvchilar massivi)
- Method parametrlari
- Lokal o'zgaruvchilar

**Misol:**
```java
public void calculate(int x, double y) {
    int result = x * 10;
    double total = result + y;
}
```

```
Local Variable Array:
┌─────────────┐
│ index 0: x  │ <- int parametr
│ index 1: y  │ <- double parametr  
│ index 2: result │ <- lokal o'zgaruvchi
│ index 3: total  │ <- lokal o'zgaruvchi
└─────────────┘
```

### 2. Operand Stack (Operand steki)
- Oraliq (intermediate) natijalar
- Arifmetik operatsiyalar natijalari

**Misol:**
```java
int result = (a + b) * c;
```

```
Operand Stack ishlashi:
1. a qiymati stack'ga
2. b qiymati stack'ga  
3. + amali -> a+b natijasi stack'da
4. c qiymati stack'ga
5. * amali -> (a+b)*c natijasi
6. Natija result ga saqlanadi
```

### 3. Frame Data (Freym ma'lumotlari)
- Istisnolar (exceptions) haqida ma'lumot
- Debug ma'lumotlari

---

## Obyektlar va Xotira

### Primitive vs Reference Types:

```java
// Primitive type - qiymati stack'da
int primitiveValue = 42;

// Reference type - manzili stack'da, qiymati heap'da
Integer referenceValue = 42;
String text = "Hello";
```

### Xotirada joylashishi:

```
STACK                          HEAP
┌─────────────────┐          ┌─────────────────┐
│                 │          │                 │
│ primitiveValue  │          │                 │
│   = 42          │          │                 │
│                 │          │     42          │
│ referenceValue  │──────┐   │    (Integer)    │
│   = 0x100       │      │   │                 │
│                 │      │   │                 │
│ text            │──────┼──▶│    "Hello"      │
│   = 0x200       │      │   │    (String)     │
│                 │      │   │                 │
└─────────────────┘      │   │                 │
                         │   │                 │
                         │   │                 │
                         └──▶│     42          │
                             │    (Integer)    │
                             │                 │
                             └─────────────────┘
```

### Amaliy Misol:

```java
public class MemoryExample {
    public static void main(String[] args) {
        // Primitive - stack'da
        int age = 25;
        double salary = 1000.50;
        
        // Reference - manzili stack'da, qiymati heap'da
        String name = "Alice";
        Integer bonus = 500;
        Person person = new Person("Bob", 30);
        
        // Method chaqiruq
        calculateTax(salary, bonus);
    }
    
    public static double calculateTax(double income, Integer deduction) {
        // Local variables - stack'da
        double taxableIncome = income - deduction;
        double tax = taxableIncome * 0.2;
        
        return tax;
    }
}

class Person {
    String name;
    int age;
    
    Person(String name, int age) {
        this.name = name;
        this.age = age;
    }
}
```

### Xotirada joylashish diagrammasi:

```
STACK (main method)          HEAP
┌─────────────────┐        ┌─────────────────┐
│ age = 25        │        │                 │
│ salary = 1000.5 │        │   "Alice"       │
│ name = 0x100    │──────┐ │   (String)      │
│ bonus = 0x200   │──────┼─│                 │
│ person = 0x300  │──────┼─│   500           │
│                 │      │ │   (Integer)     │
│                 │      │ │                 │
│                 │      │ │                 │
└─────────────────┘      │ │   Person object │
                         │ │   name="Bob"    │
                         │ │   age=30        │
                         │ │                 │
                         │ └─────────────────┘
                         │
STACK (calculateTax)     │
┌─────────────────┐      │
│ income = 1000.5 │      │
│ deduction=0x200 │──────┘
│ taxableIncome   │
│ tax             │
└─────────────────┘
```

---

## StackOverflowError

### StackOverflowError nima?
**StackOverflowError** - stack xotira to'lib ketganda yuzaga keladigan xato.

### Sabablari:
1. **Cheksiz rekursiya** (infinite recursion)
2. Juda ko'p method chaqiruqlari
3. Juda katta lokal o'zgaruvchilar

### Misol:
```java
public class StackOverflowExample {
    // Cheksiz rekursiya - StackOverflowError
    public static void infiniteRecursion() {
        infiniteRecursion();  // Har chaqiruvda yangi Stack Frame
    }
    
    // Katta lokal o'zgaruvchi
    public static void largeLocalVariables() {
        // Har chaqiruvda katta massiv yaratiladi
        int[] largeArray = new int[1000000];
        System.out.println("Array created");
    }
    
    // Deep recursion
    public static int factorial(int n) {
        if (n <= 1) return 1;
        return n * factorial(n - 1);  // Har qadamda yangi Stack Frame
    }
    
    public static void main(String[] args) {
        // infiniteRecursion();  // StackOverflowError
        
        // Deep recursion
        try {
            System.out.println("Factorial of 10000: " + factorial(10000));
        } catch (StackOverflowError e) {
            System.out.println("StackOverflowError: Recursion too deep!");
        }
        
        // Multiple calls
        try {
            for (int i = 0; i < 10000; i++) {
                largeLocalVariables();
            }
        } catch (StackOverflowError e) {
            System.out.println("StackOverflowError: Too many method calls!");
        }
    }
}
```

---

## Stack Xotiraning Afzalliklari va Kamchiliklari

### Afzalliklari:
1. **Thread-safe** - Har bir thread o'z stack'iga ega
2. **Tez** - Push/pop operatsiyalari juda tez
3. **Avtomatik boshqariladi** - Method tugagach avtomatik tozalanadi
4. **Oddiy** - LIFO prinsipi oddiy va samarali

### Kamchiliklari:
1. **Cheklangan hajm** - Stack kengaya olmaydi
2. **LIFO cheklovi** - Random elementni o'chirib bo'lmaydi
3. **StackOverflow** - Cheksiz rekursiyada xatolik
4. **Katta ma'lumotlar uchun yaroqsiz** - Katta massivlar stack'da saqlanmaydi

---

## Amaliy Misol: Stack Kattaligini O'lchash

```java
public class StackSizeMeasurement {
    private static int depth = 0;
    
    public static void measureStackDepth() {
        depth++;
        try {
            measureStackDepth();
        } catch (StackOverflowError e) {
            System.out.println("Maximum stack depth: " + depth);
        }
    }
    
    // Different local variables affect stack size
    public static void methodWithVariables() {
        int a = 1;
        int b = 2;
        int c = 3;
        int d = 4;
        int e = 5;
        // More variables = larger stack frame
    }
    
    public static void methodWithoutVariables() {
        // Smaller stack frame
    }
    
    public static void main(String[] args) {
        System.out.println("=== Stack Size Measurement ===");
        
        // Measure default stack size
        depth = 0;
        measureStackDepth();
        
        // Compare different methods
        System.out.println("\n=== Stack Frame Size Comparison ===");
        
        long startTime = System.currentTimeMillis();
        for (int i = 0; i < 10000; i++) {
            methodWithoutVariables();
        }
        long time1 = System.currentTimeMillis() - startTime;
        
        startTime = System.currentTimeMillis();
        for (int i = 0; i < 10000; i++) {
            methodWithVariables();
        }
        long time2 = System.currentTimeMillis() - startTime;
        
        System.out.println("Method without variables: " + time1 + "ms");
        System.out.println("Method with variables: " + time2 + "ms");
        System.out.println("Difference: " + (time2 - time1) + "ms");
        
        // Demonstrate object vs primitive
        System.out.println("\n=== Object vs Primitive Memory ===");
        primitiveTest();
        objectTest();
    }
    
    public static void primitiveTest() {
        int[] numbers = new int[1000000];  // In heap
        // Local primitive variables in stack
        int count = 0;
        for (int i = 0; i < numbers.length; i++) {
            numbers[i] = i;
            count++;
        }
        System.out.println("Primitive array test completed");
    }
    
    public static void objectTest() {
        Integer[] numbers = new Integer[1000000];  // References in heap
        // Each Integer object separately in heap
        for (int i = 0; i < numbers.length; i++) {
            numbers[i] = Integer.valueOf(i);  // Auto-boxing
        }
        System.out.println("Object array test completed");
    }
}
```

---

## Xotira Samaradorligi Bo'yicha Maslahatlar

### 1. Lokal o'zgaruvchilarni optimallashtirish:
```java
// Yomon: Ko'p lokal o'zgaruvchilar
public void inefficient() {
    int a = 1;
    int b = 2;
    int c = 3;
    int d = 4;
    int e = 5;
    int result = a + b + c + d + e;
}

// Yaxshi: Kamroq lokal o'zgaruvchilar
public void efficient() {
    int result = 1 + 2 + 3 + 4 + 5;
}
```

### 2. Rekursiyani optimallashtirish:
```java
// Yomon: Chuqur rekursiya
public int factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);  // StackOverflow risk
}

// Yaxshi: Iteratsiya
public int factorialIterative(int n) {
    int result = 1;
    for (int i = 2; i <= n; i++) {
        result *= i;
    }
    return result;
}

// Yaxshi: Tail recursion (Java 8+ optimizatsiya)
public int factorialTailRec(int n, int accumulator) {
    if (n <= 1) return accumulator;
    return factorialTailRec(n - 1, n * accumulator);
}
```

### 3. Method chaqiruqlarini optimallashtirish:
```java
// Yomon: Ko'p method chaqiruqlari
public void processData(int[] data) {
    for (int value : data) {
        validate(value);
        transform(value);
        save(value);
    }
}

// Yaxshi: Kamroq method chaqiruqlari
public void processDataOptimized(int[] data) {
    for (int value : data) {
        // Barcha operatsiyalar bir methodda
        if (isValid(value)) {
            int transformed = transformValue(value);
            saveValue(transformed);
        }
    }
}
```

### 4. Obyekt yaratishni optimallashtirish:
```java
// Yomon: Loop ichida yangi obyektlar
public void processItems(List<String> items) {
    for (String item : items) {
        Processor processor = new Processor();  // Har iteratsiyada yangi
        processor.process(item);
    }
}

// Yaxshi: Bir marta yaratish
public void processItemsOptimized(List<String> items) {
    Processor processor = new Processor();  // Bir marta
    for (String item : items) {
        processor.process(item);
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Quyidagi kodda nechta Stack Frame yaratiladi?
```java
public class Test {
    public static void main(String[] args) {
        method1();
    }
    
    static void method1() {
        method2();
    }
    
    static void method2() {
        method3();
    }
    
    static void method3() {
        System.out.println("Hello");
    }
}
```

### Savol 2: Primitive va Reference type'lar qayerda saqlanadi?

### Savol 3: StackOverflowError nima va qachon yuzaga keladi?

---

## Keyingi Qism: [Memory Management_2 - Heap, Garbage Collection](./08_Memory_Management_2.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Xotira boshqaruvi - bu dasturchining eng muhim vazifalaridan biri. Yaxshi xotira boshqaruvi dasturning tezligi, barqarorligi va ishonchliligini ta'minlaydi. "Premature optimization is the root of all evil" - Deyl Karnegi, lekin xotira haqida har doim o'ylashingiz kerak!