# 09 - Memory Management (Xotira Boshqaruvi) - 3-qism

## Heap Memory Tuzilmasi

Heap xotira fizik jihatdan ikki qismga bo'linadi:

### 1. Young Generation (Yangi Avlod) - Nursery Space
```
      MINOR GC
┌─────────────────────────┐
│      Young Generation    │
│  (Nursery Space)        │
│                         │
│  ┌──────┬──────┬──────┐ │
│  │ Eden │  S0  │  S1  │ │
│  │ Space│ Space│ Space│ │
│  └──────┴──────┴──────┘ │
└─────────────────────────┘
```

### 2. Old Generation (Qari Avlod) - Tenured Space
```
      MAJOR GC
┌─────────────────────────┐
│    Old Generation       │
│   (Tenured Space)       │
│                         │
│  ┌───────────────────┐  │
│  │                   │  │
│  │   Tenured Space   │  │
│  │                   │  │
│  └───────────────────┘  │
└─────────────────────────┘
```

---

## Young Generation (Nursery Space)

### Tuzilmasi:
Young Generation 3 qismdan iborat:
1. **Eden Space** - Yangi obyektlar uchun
2. **Survivor Space 0 (S0)** - Omon qolgan obyektlar uchun
3. **Survivor Space 1 (S1)** - Omon qolgan obyektlar uchun

### Ishlash Jarayoni:

#### 1-bosqich: Obyekt yaratish
```java
public class ObjectCreation {
    public static void main(String[] args) {
        // Barcha yangi obyektlar Eden Space'da yaratiladi
        Object obj1 = new Object();  // → Eden Space
        Object obj2 = new Object();  // → Eden Space
        Object obj3 = new Object();  // → Eden Space
        
        System.out.println("Objects created in Eden Space");
    }
}
```

#### 2-bosqich: Eden Space to'lganda
```
Eden Space to'ldi → Minor GC boshlanadi

BEFORE MINOR GC:
┌────────────────────────────────────────┐
│              Eden Space                │
│  [obj1] [obj2] [obj3] [obj4] [obj5]   │
│                                        │
│   Survivor Space 0      Survivor Space 1│
│   ┌──────────────┐     ┌──────────────┐│
│   │              │     │              ││
│   │              │     │              ││
│   └──────────────┘     └──────────────┘│
└────────────────────────────────────────┘

AFTER MINOR GC:
┌────────────────────────────────────────┐
│              Eden Space                │
│                                        │
│   Survivor Space 0      Survivor Space 1│
│   ┌──────────────┐     ┌──────────────┐│
│   │              │     │ [obj1]       ││
│   │              │     │ [obj3]       ││
│   └──────────────┘     └──────────────┘│
└────────────────────────────────────────┘
```

#### 3-bosqich: Obyekt yoshi (Age)
Har bir obyektning **yoshi** (age) bor:
- **Default yosh chegarasi: 15**
- Har bir GC dan o'tganda obyekt yoshi 1 ga oshadi
- Yosh 15 ga yetganda → Old Generation ga o'tkaziladi

### Minor GC (Kichik Zarrachalarni Yig'ish) Jarayoni:

```java
public class MinorGCDemo {
    
    // Simulate object creation and GC
    public static void simulateMinorGC() {
        System.out.println("=== MINOR GC SIMULATION ===");
        
        // Create objects in Eden
        for (int i = 1; i <= 10; i++) {
            Object obj = new byte[1024 * 1024]; // 1MB each
            System.out.println("Created object " + i + " in Eden");
            
            // Simulate Eden filling up
            if (i % 5 == 0) {
                System.out.println("\nEden is full! Triggering Minor GC...");
                performMinorGC(i);
            }
        }
    }
    
    private static void performMinorGC(int cycle) {
        System.out.println("Cycle " + cycle + " - Minor GC running...");
        System.out.println("Surviving objects moved to Survivor Space");
        System.out.println("Objects age incremented");
        
        // Simulate object aging
        int[] ages = {1, 3, 7, 10, 15};
        for (int age : ages) {
            if (age >= 15) {
                System.out.println("Object with age " + age + " promoted to Old Generation");
            } else {
                System.out.println("Object with age " + age + " moved between Survivor spaces");
            }
        }
        System.out.println("Eden Space cleared\n");
    }
    
    public static void main(String[] args) {
        simulateMinorGC();
    }
}
```

### Survivor Space Qoidalari:
1. **Har doim bitta Survivor Space bo'sh bo'lishi kerak**
2. Obyektlar S0 va S1 o'rtasida har bir GC da ko'chiriladi
3. Bu process **copying garbage collection** deb ataladi

---

## Old Generation (Tenured Space)

### Old Generation ga qachon ko'chiladi?
1. Obyekt yoshi 15 ga yetganda
2. Survivor Space to'lib ketganda
3. Katta obyektlar (to'g'ridan-to'g'ri Old Generation da yaratiladi)

### Major GC (Katta Zarrachalarni Yig'ish):
```java
public class MajorGCDemo {
    
    public static void main(String[] args) {
        System.out.println("=== MAJOR GC DEMO ===");
        
        // Create long-lived objects
        java.util.List<Object> longLivedObjects = new java.util.ArrayList<>();
        
        for (int i = 1; i <= 100; i++) {
            // Create object
            Object obj = new byte[1024 * 100]; // 100KB each
            
            // Simulate object surviving many Minor GCs
            if (i % 10 == 0) {
                longLivedObjects.add(obj);
                System.out.println("Object " + i + " survived, adding to long-lived list");
            }
            
            // Simulate Old Generation filling up
            if (i == 50) {
                System.out.println("\nOld Generation is filling up...");
            }
            
            if (i == 100) {
                System.out.println("\nOld Generation is FULL! Triggering Major GC...");
                performMajorGC(longLivedObjects);
            }
        }
    }
    
    private static void performMajorGC(java.util.List<Object> objects) {
        System.out.println("Major GC running...");
        System.out.println("This takes longer than Minor GC");
        
        // Mark phase
        System.out.println("1. Marking phase: Identifying live objects...");
        
        // Sweep phase
        System.out.println("2. Sweeping phase: Removing dead objects...");
        
        // Compact phase (optional)
        System.out.println("3. Compacting phase: Defragmenting memory...");
        
        System.out.println("Major GC completed. Memory freed: ~" + 
                          (objects.size() * 100) + "KB");
    }
}
```

### Minor GC vs Major GC Taqqoslash:

| Xususiyat | Minor GC | Major GC |
|-----------|----------|----------|
| **Xotira qismi** | Young Generation | Old Generation |
| **Tezlik** | Tez (millisekundlar) | Sekin (sekundlar) |
| **Chastota** | Tez-tez | Kamroq |
| **Maqsad** | Vaqtincha obyektlar | Uzoq yashovchi obyektlar |
| **Ta'sir** | Kichik | Katta (STW - Stop The World) |

---

## Permanent Generation vs Metaspace

### Java 7 va Oldin: Permanent Generation (Perm Gen)
```
┌─────────────────────────────────────────┐
│            JVM Memory                   │
│                                         │
│  ┌─────────────────┐  ┌──────────────┐ │
│  │     Heap        │  │   Perm Gen   │ │
│  │                 │  │              │ │
│  │  Young   Old    │  │  Class       │ │
│  │  Gen     Gen    │  │  Metadata    │ │
│  │                 │  │              │ │
│  └─────────────────┘  └──────────────┘ │
└─────────────────────────────────────────┘
```

**Perm Gen muammolari:**
- Fixed size (o'lchami cheklangan)
- `java.lang.OutOfMemoryError: PermGen space`
- Manual tuning kerak

### Java 8 va Keyin: Metaspace
```
┌─────────────────────────────────────────┐
│            JVM Memory                   │
│                                         │
│  ┌─────────────────┐                    │
│  │     Heap        │                    │
│  │                 │                    │
│  │  Young   Old    │   Metaspace        │
│  │  Gen     Gen    │   (Native Memory)  │
│  │                 │                    │
│  └─────────────────┘                    │
└─────────────────────────────────────────┘
```

**Metaspace afzalliklari:**
- Heap'ning bir qismi EMAS
- Native memory'da joylashgan
- Auto-increase (OS imkoniyaticha kengayadi)
- Classloader lifecycle bilan bog'liq

### Metaspace Misoli:
```java
public class MetaspaceDemo {
    
    public static void main(String[] args) {
        System.out.println("=== METASPACE DEMO ===");
        
        // Demonstrate class loading and metaspace
        try {
            // Load multiple classes dynamically
            for (int i = 0; i < 1000; i++) {
                ClassLoader classLoader = new CustomClassLoader();
                Class<?> loadedClass = classLoader.loadClass("TestClass" + i);
                System.out.println("Loaded class: " + loadedClass.getName());
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        // Check metaspace usage
        printMemoryInfo();
    }
    
    static class CustomClassLoader extends ClassLoader {
        @Override
        public Class<?> loadClass(String name) throws ClassNotFoundException {
            // Create dummy class bytes
            byte[] classBytes = createDummyClassBytes(name);
            return defineClass(name, classBytes, 0, classBytes.length);
        }
        
        private byte[] createDummyClassBytes(String className) {
            // Simplified - in real scenario, would have proper class bytecode
            return new byte[100]; // 100 bytes dummy class
        }
    }
    
    private static void printMemoryInfo() {
        java.lang.management.MemoryMXBean memoryMXBean = 
            java.lang.management.ManagementFactory.getMemoryMXBean();
        
        java.lang.management.MemoryUsage metaspaceUsage = 
            memoryMXBean.getNonHeapMemoryUsage();
        
        System.out.println("\n=== METASPACE USAGE ===");
        System.out.println("Init: " + metaspaceUsage.getInit() / 1024 + " KB");
        System.out.println("Used: " + metaspaceUsage.getUsed() / 1024 + " KB");
        System.out.println("Committed: " + metaspaceUsage.getCommitted() / 1024 + " KB");
        System.out.println("Max: " + metaspaceUsage.getMax() / 1024 + " KB");
    }
}
```

---

## Method Area

### Method Area nima?
**Method Area** - Metaspace'ning bir qismi bo'lib, quyidagilarni saqlaydi:
1. **Class structure** - klass strukturalari
2. **Runtime constants** - runtime konstantalari
3. **Static variables** - static o'zgaruvchilar
4. **Method code** - metodlar kodi
5. **Constructor code** - konstruktorlar kodi

### Method Area da saqlanadigan ma'lumotlar:
```java
public class MethodAreaExample {
    
    // Static variables - Method Area'da saqlanadi
    public static final String CONSTANT = "Constant Value";
    public static int staticCounter = 0;
    
    // Class metadata - Method Area'da
    // - Method signatures
    // - Field information
    // - Constant pool
    // - Class loader reference
    
    // Instance variables - Heap'da (obyekt bilan)
    private String instanceData;
    
    // Constructor - code Method Area'da
    public MethodAreaExample(String data) {
        this.instanceData = data;
        staticCounter++;
    }
    
    // Method - code Method Area'da
    public void process() {
        System.out.println("Processing: " + instanceData);
    }
    
    // Static method - code Method Area'da
    public static void printInfo() {
        System.out.println("Static counter: " + staticCounter);
    }
    
    public static void main(String[] args) {
        System.out.println("=== METHOD AREA EXAMPLE ===");
        
        // Class loading triggers Method Area allocation
        System.out.println("Class loaded, Method Area allocated");
        
        // Access static fields (from Method Area)
        System.out.println("Constant: " + CONSTANT);
        
        // Create instances
        MethodAreaExample obj1 = new MethodAreaExample("Object 1");
        MethodAreaExample obj2 = new MethodAreaExample("Object 2");
        
        // Call static method
        printInfo();
        
        // Call instance methods
        obj1.process();
        obj2.process();
        
        // Demonstrate GC on Method Area
        demonstrateMethodAreaGC();
    }
    
    public static void demonstrateMethodAreaGC() {
        System.out.println("\n=== METHOD AREA GARBAGE COLLECTION ===");
        
        // Method Area GC happens when:
        // 1. Class is unloaded
        // 2. Constant pool entries are cleared
        // 3. Metadata is no longer needed
        
        // Create custom class loader
        CustomLoader loader = new CustomLoader();
        
        try {
            // Load class
            Class<?> loadedClass = loader.loadClass("TempClass");
            System.out.println("Class loaded successfully");
            
            // Unload class (make eligible for GC)
            loader = null;
            System.gc();
            
            System.out.println("Class loader nullified, class may be unloaded");
            
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
    
    static class CustomLoader extends ClassLoader {
        @Override
        public Class<?> loadClass(String name) throws ClassNotFoundException {
            // Simple implementation
            byte[] bytes = new byte[100];
            return defineClass(name, bytes, 0, bytes.length);
        }
    }
}
```

### Method Area Garbage Collection:
Method Area GC quyidagi hollarda sodir bo'ladi:
1. **Class unloading** - klass yuklab olinmaganida
2. **Constant pool cleaning** - konstantalar pool'i tozalanadi
3. **Metadata cleanup** - kerak bo'lmagan metadata o'chiriladi

---

## Amaliy Misol: Memory Monitoring va Tuning

```java
import java.lang.management.*;
import java.util.*;

public class MemoryMonitoringSystem {
    
    public static void main(String[] args) throws Exception {
        System.out.println("=== COMPREHENSIVE MEMORY MONITORING ===");
        
        // Monitor for 30 seconds
        for (int i = 0; i < 30; i++) {
            printMemoryStatistics();
            
            // Create objects to simulate application behavior
            simulateApplicationWorkload();
            
            Thread.sleep(1000); // Wait 1 second
        }
        
        // Print final analysis
        printGCAnalysis();
        printMemoryRecommendations();
    }
    
    private static void printMemoryStatistics() {
        Runtime runtime = Runtime.getRuntime();
        MemoryMXBean memoryBean = ManagementFactory.getMemoryMXBean();
        
        System.out.println("\n" + new Date() + " - MEMORY STATS");
        System.out.println("Heap Usage:");
        System.out.println("  Total: " + formatBytes(runtime.totalMemory()));
        System.out.println("  Free:  " + formatBytes(runtime.freeMemory()));
        System.out.println("  Used:  " + formatBytes(runtime.totalMemory() - runtime.freeMemory()));
        System.out.println("  Max:   " + formatBytes(runtime.maxMemory()));
        
        // Non-heap (Metaspace)
        MemoryUsage nonHeap = memoryBean.getNonHeapMemoryUsage();
        System.out.println("\nNon-Heap (Metaspace):");
        System.out.println("  Used:  " + formatBytes(nonHeap.getUsed()));
        System.out.println("  Committed: " + formatBytes(nonHeap.getCommitted()));
        
        // GC statistics
        List<GarbageCollectorMXBean> gcBeans = ManagementFactory.getGarbageCollectorMXBeans();
        for (GarbageCollectorMXBean gcBean : gcBeans) {
            System.out.println("\nGC: " + gcBean.getName());
            System.out.println("  Count: " + gcBean.getCollectionCount());
            System.out.println("  Time:  " + gcBean.getCollectionTime() + "ms");
        }
    }
    
    private static void simulateApplicationWorkload() {
        // Simulate different types of objects
        
        // 1. Short-lived objects (Eden)
        for (int i = 0; i < 100; i++) {
            byte[] temp = new byte[1024]; // 1KB
            // Let it die (not stored)
        }
        
        // 2. Some long-lived objects (Survivor → Old Gen)
        if (Math.random() > 0.7) {
            List<byte[]> cache = new ArrayList<>();
            for (int i = 0; i < 10; i++) {
                cache.add(new byte[1024 * 10]); // 10KB
            }
            // Keep in static field to prevent GC
            if (longTermCache == null) {
                longTermCache = cache;
            }
        }
        
        // 3. Large object (direct to Old Gen)
        if (Math.random() > 0.9) {
            byte[] largeObject = new byte[1024 * 1024 * 5]; // 5MB
            // Large objects often go directly to Old Generation
        }
    }
    
    private static List<byte[]> longTermCache;
    
    private static String formatBytes(long bytes) {
        if (bytes < 1024) return bytes + " B";
        if (bytes < 1024 * 1024) return (bytes / 1024) + " KB";
        if (bytes < 1024 * 1024 * 1024) return (bytes / (1024 * 1024)) + " MB";
        return (bytes / (1024 * 1024 * 1024)) + " GB";
    }
    
    private static void printGCAnalysis() {
        System.out.println("\n=== GARBAGE COLLECTION ANALYSIS ===");
        
        List<GarbageCollectorMXBean> gcBeans = ManagementFactory.getGarbageCollectorMXBeans();
        
        long totalGCTime = 0;
        long totalGCCount = 0;
        
        for (GarbageCollectorMXBean gcBean : gcBeans) {
            String name = gcBean.getName();
            long count = gcBean.getCollectionCount();
            long time = gcBean.getCollectionTime();
            
            System.out.println(name + ":");
            System.out.println("  Collections: " + count);
            System.out.println("  Total time: " + time + "ms");
            System.out.println("  Avg time per collection: " + 
                (count > 0 ? time / count : 0) + "ms");
            
            totalGCTime += time;
            totalGCCount += count;
            
            // Analyze GC type
            if (name.contains("Young") || name.contains("Eden")) {
                System.out.println("  Type: Minor GC (Young Generation)");
            } else if (name.contains("Old") || name.contains("Tenured")) {
                System.out.println("  Type: Major GC (Old Generation)");
            }
        }
        
        System.out.println("\n=== SUMMARY ===");
        System.out.println("Total GC collections: " + totalGCCount);
        System.out.println("Total GC time: " + totalGCTime + "ms");
        System.out.println("Application uptime: ~30 seconds");
        System.out.println("GC overhead: " + 
            (totalGCTime * 100 / 30000) + "% of total time");
    }
    
    private static void printMemoryRecommendations() {
        System.out.println("\n=== MEMORY TUNING RECOMMENDATIONS ===");
        
        Runtime runtime = Runtime.getRuntime();
        long maxMemory = runtime.maxMemory();
        long usedMemory = runtime.totalMemory() - runtime.freeMemory();
        double usagePercentage = (usedMemory * 100.0) / maxMemory;
        
        System.out.println("Current heap usage: " + 
            String.format("%.1f", usagePercentage) + "%");
        
        if (usagePercentage > 80) {
            System.out.println("⚠️  WARNING: High memory usage!");
            System.out.println("Recommendation: Increase heap size with -Xmx option");
        } else if (usagePercentage < 30) {
            System.out.println("ℹ️  INFO: Low memory usage");
            System.out.println("Recommendation: You might decrease heap size to save resources");
        } else {
            System.out.println("✅ OK: Memory usage is in optimal range");
        }
        
        // Check for frequent GC
        List<GarbageCollectorMXBean> gcBeans = ManagementFactory.getGarbageCollectorMXBeans();
        for (GarbageCollectorMXBean gcBean : gcBeans) {
            if (gcBean.getName().contains("Young") && 
                gcBean.getCollectionCount() > 50) {
                System.out.println("\n⚠️  WARNING: Frequent Young GC detected!");
                System.out.println("Recommendation: Increase Young Generation size (-Xmn)");
                System.out.println("Or reduce short-lived object creation");
            }
        }
        
        System.out.println("\nCommon JVM Options:");
        System.out.println("-Xms512m - Initial heap size");
        System.out.println("-Xmx2g   - Maximum heap size");
        System.out.println("-Xmn256m - Young Generation size");
        System.out.println("-XX:MetaspaceSize=256m - Initial Metaspace size");
        System.out.println("-XX:MaxMetaspaceSize=512m - Max Metaspace size");
    }
}
```

---

## JVM Memory Tuning Flags

### Heap Memory Flags:
```bash
# Initial heap size
-Xms512m

# Maximum heap size  
-Xmx2g

# Young Generation size
-Xmn256m

# Ratio between Young and Old Generation
-XX:NewRatio=2  # Old:Young = 2:1

# Survivor space ratio
-XX:SurvivorRatio=8  # Eden:Survivor = 8:1
```

### GC Algorithm Flags:
```bash
# Serial GC (single-threaded)
-XX:+UseSerialGC

# Parallel GC (multi-threaded, default)
-XX:+UseParallelGC

# CMS GC (concurrent)
-XX:+UseConcMarkSweepGC

# G1 GC (Java 9+ default)
-XX:+UseG1GC
```

### Monitoring Flags:
```bash
# Enable GC logging
-Xlog:gc*:file=gc.log:time

# Print GC details
-XX:+PrintGCDetails
-XX:+PrintGCDateStamps

# Heap dump on OOM
-XX:+HeapDumpOnOutOfMemoryError
-XX:HeapDumpPath=/path/to/dump.hprof
```

---

## O'z-o'zini Tekshirish

### Savol 1: Eden Space to'lganda nima sodir bo'ladi?

### Savol 2: Obyekt qachon Old Generation ga ko'chiriladi?

### Savol 3: Metaspace va Permanent Generation farqi nimada?

---

## Keyingi Mavzu: [Record and Sealed Classes, Static and Instance Block Initializer](./10_Record_Sealed_Classes.md)
**[Mundarijaga qaytish](../README.md)**

> ⚡️ **Eslatma:** Xotira boshqaruvi - bu san'at va fan. Tushunish va to'g'ri sozlash dasturingizning performansini o'zgartiradi. "The bitterness of poor performance remains long after the sweetness of low memory consumption is forgotten!"