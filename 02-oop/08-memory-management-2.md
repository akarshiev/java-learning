# 08 - Memory Management (Xotira Boshqaruvi) - 2-qism

## Passing by Value vs Passing by Reference

### Passing by Value (Qiymat Orqali Uzatish)
Method parametr qiymatlari boshqa o'zgaruvchiga nusxalanadi va nusxalangan obyekt uzatiladi.

### Passing by Reference (Ma'lumotnoma Orqali Uzatish)
Asl parametrga alias yoki reference uzatiladi.

**Java faqat Pass by Value** ni qo'llab-quvvatlaydi:
- **Primitive typelar** uchun: Qiymat nusxalanadi
- **Non-primitive typelar** uchun: Reference nusxalanadi

### Misollar:

#### 1. Primitive Types (Qiymat nusxalanadi):
```java
public class PassByValuePrimitive {
    public static void main(String[] args) {
        int number = 10;
        System.out.println("Before method: " + number);  // 10
        
        modifyPrimitive(number);
        
        System.out.println("After method: " + number);   // 10 (o'zgarmadi)
    }
    
    public static void modifyPrimitive(int value) {
        value = 100;  // Faqat nusxasi o'zgaradi
        System.out.println("Inside method: " + value);  // 100
    }
}
```

#### 2. Reference Types (Reference nusxalanadi):
```java
class Person {
    String name;
    
    Person(String name) {
        this.name = name;
    }
}

public class PassByValueReference {
    public static void main(String[] args) {
        Person person = new Person("Alice");
        System.out.println("Before method: " + person.name);  // Alice
        
        // Reference nusxalanadi, lekin bir xil obyektga murojaat qiladi
        modifyReference(person);
        
        System.out.println("After method: " + person.name);   // Bob (o'zgardi!)
    }
    
    public static void modifyReference(Person p) {
        p.name = "Bob";  // Asl obyekt o'zgaradi
        
        // Ammo reference'ni o'zgartirish asl reference'ga ta'sir qilmaydi
        p = new Person("Charlie");
        System.out.println("Inside method (after new): " + p.name);  // Charlie
    }
}
```

#### 3. Massiv Misoli:
```java
public class ArrayExample {
    public static void main(String[] args) {
        int[] numbers = {1, 2, 3};
        System.out.println("Before method: " + java.util.Arrays.toString(numbers));
        
        modifyArray(numbers);
        
        System.out.println("After method: " + java.util.Arrays.toString(numbers));
    }
    
    public static void modifyArray(int[] arr) {
        arr[0] = 100;  // Asl massiv elementlari o'zgaradi
        System.out.println("Inside method: " + java.util.Arrays.toString(numbers));
        
        // Ammo yangi massiv yaratish asl reference'ga ta'sir qilmaydi
        arr = new int[]{4, 5, 6};
        System.out.println("Inside method (after new): " + java.util.Arrays.toString(arr));
    }
}
```

### Diagramma:
```
MAIN METHOD                        HEAP
┌─────────────────┐               ┌─────────────────┐
│                 │               │                 │
│ Person person   │──────┐        │ Person object   │
│   = 0x100       │      │        │ name = "Alice"  │
│                 │      │        │   (0x100)       │
└─────────────────┘      │        │                 │
                         │        │                 │
MODIFY METHOD            │        │                 │
┌─────────────────┐      │        │                 │
│                 │      │        │                 │
│ Person p        │──────┘        │                 │
│   = 0x100       │               │                 │
│                 │               │                 │
│ p.name = "Bob"  │──────┐        │                 │
│                 │      │        │ name = "Bob"    │
│ p = new Person()│──────┼──────▶│ Person object   │
│   = 0x200       │      │        │ name = "Charlie"│
│                 │      │        │   (0x200)       │
└─────────────────┘      │        │                 │
                         │        │                 │
                         └───────▶│ Person object   │
                                  │ name = "Alice"  │
                                  │   (0x100)       │
                                  └─────────────────┘
```

---

## Variable Arguments (Varargs)

### Varargs nima?
**Varargs** - o'zgaruvchan sonli argument qabul qiladigan method. Java 1.5 dan beri mavjud.

### Qoidalari:
1. Faqat bitta varargs parametr bo'lishi mumkin
2. Varargs oxirgi parametr bo'lishi kerak
3. Varargs array sifatida ishlaydi

### Misollar:

#### 1. Oddiy Varargs:
```java
public class VarargsExample {
    
    // Varargs method
    public static int sum(int... numbers) {
        int total = 0;
        for (int num : numbers) {
            total += num;
        }
        return total;
    }
    
    // Multiple parameters with varargs (must be last)
    public static void printInfo(String message, int... values) {
        System.out.print(message + ": ");
        for (int val : values) {
            System.out.print(val + " ");
        }
        System.out.println();
    }
    
    // Overloading with varargs
    public static void display(String... messages) {
        System.out.println("String varargs:");
        for (String msg : messages) {
            System.out.println("  - " + msg);
        }
    }
    
    public static void display(int... numbers) {
        System.out.println("Int varargs:");
        for (int num : numbers) {
            System.out.println("  - " + num);
        }
    }
    
    // Main method can also use varargs
    public static void main(String... args) {
        System.out.println("=== VARARGS EXAMPLES ===");
        
        // Different ways to call varargs method
        System.out.println("Sum of no numbers: " + sum());           // 0
        System.out.println("Sum of 1 number: " + sum(5));            // 5
        System.out.println("Sum of 3 numbers: " + sum(1, 2, 3));     // 6
        System.out.println("Sum of 5 numbers: " + sum(1, 2, 3, 4, 5)); // 15
        
        // Using array with varargs
        int[] arr = {10, 20, 30};
        System.out.println("Sum of array: " + sum(arr));             // 60
        
        // Multiple parameters
        printInfo("Numbers", 1, 2, 3, 4, 5);
        printInfo("Empty");
        
        // Overloaded varargs
        display("Hello", "World", "Java");
        display(100, 200, 300, 400);
        
        // Practical example: Logger
        log("INFO", "User logged in", "Session started", "Data loaded");
        log("ERROR", "Database connection failed");
    }
    
    // Practical varargs use case
    public static void log(String level, String... messages) {
        System.out.println("[" + level + "] " + java.time.LocalTime.now());
        for (String msg : messages) {
            System.out.println("  • " + msg);
        }
        System.out.println();
    }
}
```

#### 2. Varargs va Array Farqi:
```java
public class VarargsVsArray {
    
    // Array version
    public static void processArray(String[] items) {
        System.out.println("Array method called");
        for (String item : items) {
            System.out.println(item);
        }
    }
    
    // Varargs version
    public static void processVarargs(String... items) {
        System.out.println("Varargs method called");
        for (String item : items) {
            System.out.println(item);
        }
    }
    
    public static void main(String[] args) {
        String[] array = {"A", "B", "C"};
        
        // Both work with array
        processArray(array);
        processVarargs(array);
        
        // But only varargs works with individual items
        // processArray("X", "Y", "Z");  // ERROR!
        processVarargs("X", "Y", "Z");   // OK
        
        // Empty calls
        // processArray();  // ERROR! Need to pass array
        processVarargs();   // OK - empty varargs
        processArray(new String[0]);  // OK - empty array
    }
}
```

#### 3. Varargs cheklovlari:
```java
public class VarargsLimitations {
    
    // ERROR: Multiple varargs not allowed
    // public static void error1(String... strings, int... numbers) { }
    
    // ERROR: Varargs must be last
    // public static void error2(String... strings, int number) { }
    
    // OK: Varargs last parameter
    public static void correct1(int number, String... strings) {
        System.out.println("Number: " + number);
        System.out.println("Strings: " + strings.length);
    }
    
    // ERROR: Ambiguous overloading
    // public static void ambiguous(String... strings) { }
    // public static void ambiguous(String[] strings) { }  // Same signature!
    
    public static void main(String[] args) {
        correct1(10, "A", "B", "C");
        correct1(20);  // No strings provided
    }
}
```

---

## Garbage Collection (Zarrachalarni Yig'ish)

### Garbage Collection nima?
**Garbage Collection** - heap xotiradagi bo'sh joyni yangi obyektlar uchun ozod qilish jarayoni. Bu Java'ning eng yaxshi xususiyatlaridan biri.

### Garbage Collector nima qiladi?
1. Xotiradagi barcha obyektlarni tekshiradi
2. Hech qanday dastur qismi tomonidan reference qilinmagan obyektlarni aniqlaydi
3. Bu unreferenced obyektlarni o'chiradi
4. Bo'sh joyni boshqa obyektlar uchun qayta tiklaydi

### Garbage Collection 2 bosqichli jarayon:

#### 1. Marking (Belgilash)
Garbage Collector heap'dagi barcha obyektlarni tekshiradi va qaysi obyektlar ishlatilayotganini aniqlaydi.

#### 2. Sweeping (Tozalash)
Ishlatilmayotgan obyektlar o'chiriladi.

### Sweeping Turlari:

#### 1. Normal Sweeping (Oddiy tozalash):
```
Heap (Before)          Heap (After)
┌────────────┐        ┌────────────┐
│ Live       │        │ Live       │
│ Object A   │        │ Object A   │
├────────────┤        ├────────────┤
│ Dead       │        │ Free       │
│ Object B   │  ──→  │ Space      │
├────────────┤        ├────────────┤
│ Live       │        │ Live       │
│ Object C   │        │ Object C   │
├────────────┤        ├────────────┤
│ Dead       │        │ Free       │
│ Object D   │        │ Space      │
└────────────┘        └────────────┘
```

#### 2. Sweeping with Compacting (Siqish bilan tozalash):
```
Heap (Before)          Heap (After)
┌────────────┐        ┌────────────┐
│ Live       │        │ Live       │
│ Object A   │        │ Object A   │
├────────────┤        ├────────────┤
│ Dead       │        │ Live       │
│ Object B   │  ──→  │ Object C   │
├────────────┤        ├────────────┤
│ Live       │        │ Free       │
│ Object C   │        │ Space      │
├────────────┤        │            │
│ Dead       │        │            │
│ Object D   │        │            │
└────────────┘        └────────────┘
```

#### 3. Sweeping with Copying (Nusxalash bilan tozalash):
```
From Space             To Space
┌────────────┐        ┌────────────┐
│ Live       │        │ Live       │
│ Object A   │        │ Object A   │
├────────────┤        ├────────────┤
│ Dead       │  ──→  │ Live       │
│ Object B   │        │ Object C   │
├────────────┤        ├────────────┤
│ Live       │        │ Free       │
│ Object C   │        │ Space      │
├────────────┤        │            │
│ Dead       │        │            │
│ Object D   │        │            │
└────────────┘        └────────────┘
```

### Garbage Collector turlari:
1. **Serial GC** - Bitta thread bilan ishlaydi
2. **Parallel GC** - Bir nechta thread'lar bilan ishlaydi
3. **CMS GC** (Concurrent Mark Sweep) - Ilovalar bilan parallel ishlaydi
4. **G1 GC** (Garbage First) - Java 9+ default, region-based

### Amaliy Misol:
```java
public class GarbageCollectionExample {
    
    public static void main(String[] args) {
        System.out.println("=== GARBAGE COLLECTION DEMO ===");
        
        // Create objects
        for (int i = 1; i <= 5; i++) {
            createAndDiscardObject(i);
        }
        
        // Request garbage collection (suggestion only)
        System.gc();
        
        // Wait a bit
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        // Final message
        System.out.println("\nProgram completed");
    }
    
    public static void createAndDiscardObject(int id) {
        // Object created - will be garbage collected after method ends
        DataObject obj = new DataObject("Object-" + id);
        System.out.println("Created: " + obj);
        
        // obj becomes eligible for GC after this method
    }
    
    // Demonstrate different ways objects become eligible for GC
    public static void demonstrateGCEligibility() {
        System.out.println("\n=== GC ELIGIBILITY SCENARIOS ===");
        
        // 1. Nullifying reference
        DataObject obj1 = new DataObject("Obj1");
        obj1 = null;  // Eligible for GC
        
        // 2. Reassigning reference
        DataObject obj2 = new DataObject("Obj2");
        obj2 = new DataObject("Obj2-New");  // First object eligible for GC
        
        // 3. Local variable - eligible after method ends
        DataObject obj3 = new DataObject("Obj3");
        
        // 4. Isolated island
        DataObject obj4 = new DataObject("Obj4");
        DataObject obj5 = new DataObject("Obj5");
        obj4.next = obj5;
        obj5.next = obj4;  // Circular reference
        obj4 = null;
        obj5 = null;  // Both eligible (Java GC handles circular references)
        
        // 5. System.gc() - suggestion to run GC
        System.gc();
        
        // 6. Runtime.getRuntime().gc() - same as System.gc()
        Runtime.getRuntime().gc();
    }
    
    // Finalizer example (deprecated in Java 9+)
    static class DataObject {
        String name;
        DataObject next;
        
        DataObject(String name) {
            this.name = name;
            System.out.println("Constructing: " + name);
        }
        
        @Override
        protected void finalize() throws Throwable {
            System.out.println("Finalizing: " + name);
            super.finalize();
        }
        
        @Override
        public String toString() {
            return "DataObject{" + name + "}";
        }
    }
}
```

### Obyektlar GC ga qanday mos keladi?
```java
public class GCEligibility {
    public static void main(String[] args) {
        System.out.println("=== WHEN OBJECTS BECOME ELIGIBLE FOR GC ===");
        
        // Case 1: Null reference
        System.out.println("\n1. Nullifying reference:");
        Object obj1 = new Object();
        System.out.println("   Before null: " + obj1);
        obj1 = null;  // Eligible for GC
        
        // Case 2: Reassigning reference
        System.out.println("\n2. Reassigning reference:");
        Object obj2 = new Object();
        System.out.println("   First object created");
        obj2 = new Object();  // First object eligible for GC
        System.out.println("   Second object created");
        
        // Case 3: Method local variable
        System.out.println("\n3. Method local variable:");
        createLocalObject();
        
        // Case 4: Anonymous object
        System.out.println("\n4. Anonymous object:");
        new Object();  // Immediately eligible for GC
        
        // Case 5: Collection cleanup
        System.out.println("\n5. Collection cleanup:");
        java.util.List<Object> list = new java.util.ArrayList<>();
        list.add(new Object());
        list.add(new Object());
        System.out.println("   List size before clear: " + list.size());
        list.clear();  // Objects in list eligible for GC
        System.out.println("   List size after clear: " + list.size());
        
        // Request GC
        System.gc();
        try {
            Thread.sleep(100);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
    }
    
    public static void createLocalObject() {
        Object localObj = new Object();  // Eligible after method returns
        System.out.println("   Local object created in method");
    }
}
```

### Memory Monitoring:
```java
public class MemoryMonitor {
    public static void main(String[] args) {
        System.out.println("=== MEMORY MONITORING ===");
        
        Runtime runtime = Runtime.getRuntime();
        
        // Memory information
        System.out.println("Total memory: " + runtime.totalMemory() / 1024 / 1024 + " MB");
        System.out.println("Free memory: " + runtime.freeMemory() / 1024 / 1024 + " MB");
        System.out.println("Max memory: " + runtime.maxMemory() / 1024 / 1024 + " MB");
        System.out.println("Used memory: " + 
            (runtime.totalMemory() - runtime.freeMemory()) / 1024 / 1024 + " MB");
        
        // Create some objects
        System.out.println("\n=== CREATING OBJECTS ===");
        java.util.List<byte[]> objects = new java.util.ArrayList<>();
        for (int i = 1; i <= 10; i++) {
            byte[] largeArray = new byte[1024 * 1024];  // 1 MB each
            objects.add(largeArray);
            System.out.println("Created object " + i + 
                ", Free memory: " + runtime.freeMemory() / 1024 / 1024 + " MB");
        }
        
        // Clear references
        System.out.println("\n=== CLEARING REFERENCES ===");
        objects.clear();
        System.out.println("After clear, Free memory: " + 
            runtime.freeMemory() / 1024 / 1024 + " MB");
        
        // Request GC
        System.out.println("\n=== REQUESTING GARBAGE COLLECTION ===");
        long beforeGC = runtime.freeMemory();
        System.gc();
        try {
            Thread.sleep(100);  // Give GC some time
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        long afterGC = runtime.freeMemory();
        System.out.println("Memory freed by GC: " + 
            (afterGC - beforeGC) / 1024 / 1024 + " MB");
        
        System.out.println("\n=== FINAL MEMORY STATUS ===");
        System.out.println("Free memory: " + runtime.freeMemory() / 1024 / 1024 + " MB");
        System.out.println("Total memory: " + runtime.totalMemory() / 1024 / 1024 + " MB");
    }
}
```

---

## Xotira Boshqaruvi Bo'yicha Maslahatlar

### 1. Obyektlarni erta ozod qiling:
```java
// Yomon
public void process() {
    LargeObject obj = new LargeObject();
    // ... ko'p kod ...
    // obj hali ham reference qilinmoqda
}

// Yaxshi
public void process() {
    LargeObject obj = new LargeObject();
    obj.use();
    obj = null;  // Early nullification
    // ... qolgan kod ...
}
```

### 2. Katta ma'lumotlarni stream qiling:
```java
// Yomon: Barchasini bir vaqtda xotirada
byte[] allData = readAllData();

// Yaxshi: Stream qiling
try (InputStream stream = new FileInputStream("largefile.dat")) {
    byte[] buffer = new byte[8192];
    int bytesRead;
    while ((bytesRead = stream.read(buffer)) != -1) {
        processChunk(buffer, bytesRead);
    }
}
```

### 3. WeakReference ishlating:
```java
import java.lang.ref.WeakReference;

public class WeakReferenceExample {
    public static void main(String[] args) {
        Object strongRef = new Object();
        WeakReference<Object> weakRef = new WeakReference<>(strongRef);
        
        System.out.println("Before GC - Weak ref: " + weakRef.get());
        
        strongRef = null;  // Strong reference removed
        
        // Request GC
        System.gc();
        
        System.out.println("After GC - Weak ref: " + weakRef.get());  // May be null
    }
}
```

### 4. Cache'larni tozalang:
```java
import java.util.Map;
import java.util.WeakHashMap;

public class CacheExample {
    // WeakHashMap - keys weakly referenced
    private Map<String, byte[]> cache = new WeakHashMap<>();
    
    public byte[] getData(String key) {
        byte[] data = cache.get(key);
        if (data == null) {
            data = loadData(key);
            cache.put(key, data);
        }
        return data;
    }
    
    private byte[] loadData(String key) {
        // Load from source
        return new byte[1024];
    }
}
```

---

## O'z-o'zini Tekshirish

### Savol 1: Java pass by value yoki pass by reference?

### Savol 2: Varargs method'da nechta varargs parametr bo'lishi mumkin?

### Savol 3: Garbage Collection qanday ishlaydi?

---

## Keyingi Qism: [Memory Management_3 - Heap Memory va Method Area](./09_Memory_Management_3.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Xotira boshqaruvi - bu dasturchi sifatida sizning mas'uliyatingiz. Yaxshi xotira boshqaruvi amaliyotlari dasturingizning performansini va barqarorligini sezilarli darajada yaxshilaydi. "Memory is like money, you should know where it goes!"