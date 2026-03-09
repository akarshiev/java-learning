# 03 - Concurrency (Parallelik)

## 3.1 - Atomics (Atomlar)

### Atomicity nima?

**Atomicity** - bu multi-threaded dasturlardagi asosiy tushunchalardan biri. Bir qator amallar **atomic** hisoblanadi, agar ular bir butun operatsiya sifatida, bo'linmas tarzda bajarilsa.

```java
// Atomic operatsiya
a = 12; // Bu atomic - bir zumda bajariladi

// Atomic EMAS
// Load accounts[to]
// Add amount
// Move the result back to accounts[to]
// Bu 3 ta alohida operatsiya - thread-safe emas!
```

**Muhim:** Multi-threaded dasturda bir qator amallar ketma-ket bajariladi deb o'ylash noto'g'ri natijalarga olib kelishi mumkin.

### Atomic operatsiyalarni ta'minlash

```java
// Lock yoki synchronized metodlar orqali
lock.lock();
try {
    // Load accounts[to]
    // Add amount
    // Move the result back to accounts[to]
} finally {
    lock.unlock();
}
```

### Java'dagi Atomic Classlar

`java.util.concurrent.atomic` package'i lock-free va wait-free algoritmlar yozishga yordam beruvchi classlarni o'z ichiga oladi (Java 1.5+).

**Asosiy Atomic Classlar:**
- `AtomicBoolean`
- `AtomicInteger`
- `AtomicIntegerArray`
- `AtomicIntegerFieldUpdater`
- `AtomicLong`
- `AtomicLongArray`
- `AtomicLongFieldUpdater`
- `AtomicReference`
- `AtomicReferenceArray`
- `AtomicStampedReference`
- `AtomicMarkableReference`

### AtomicLong

`AtomicLong` - atomik tarzda yangilanishi mumkin bo'lgan `long` qiymat. Asosan atomik oshiriladigan sequence number'lar uchun ishlatiladi.

```java
import java.util.concurrent.atomic.AtomicLong;

public class AtomicLongExample {
    private AtomicLong counter = new AtomicLong(0);
    
    public void increment() {
        long value = counter.incrementAndGet(); // ++counter
        System.out.println("Counter: " + value);
    }
    
    public void addAndGet() {
        long value = counter.addAndGet(10); // counter += 10
        System.out.println("Added 10: " + value);
    }
    
    public void compareAndSet() {
        long expected = 5;
        long newValue = 10;
        boolean success = counter.compareAndSet(expected, newValue);
        // Agar counter == expected bo'lsa, counter = newValue qil va true qaytar
        System.out.println("CAS success: " + success);
    }
}
```

### LongAdder (Java 8+)

`LongAdder` - `AtomicLong` ga o'xshash, lekin yuqori contention (ko'p thread'lar bir vaqtda yangilaganda) holatida ancha samarali.

```java
import java.util.concurrent.atomic.LongAdder;
import java.util.concurrent.ConcurrentHashMap;

public class LongAdderExample {
    private LongAdder stats = new LongAdder();
    
    public void record() {
        stats.increment(); // increment
    }
    
    public long getStats() {
        return stats.sum(); // summa
    }
    
    // ConcurrentHashMap bilan ishlatish
    private ConcurrentHashMap<String, LongAdder> freqs = new ConcurrentHashMap<>();
    
    public void incrementFreq(String key) {
        // Agar key bo'lmasa, yangi LongAdder yaratadi
        freqs.computeIfAbsent(key, k -> new LongAdder()).increment();
    }
}
```

**Qachon ishlatish:** 
- `AtomicLong` - fine-grained synchronization control uchun
- `LongAdder` - statistika yig'ish, high contention holatlarida

### LongAccumulator (Java 8+)

`LongAccumulator` - `LongAdder` ga o'xshash, lekin ixtiyoriy binary operatsiyani qo'llash imkonini beradi.

```java
import java.util.concurrent.atomic.LongAccumulator;

public class LongAccumulatorExample {
    // Maksimum qiymatni saqlovchi accumulator
    private LongAccumulator maxAccumulator = 
        new LongAccumulator(Long::max, Long.MIN_VALUE);
    
    // Yig'indi hisoblovchi accumulator
    private LongAccumulator sumAccumulator = 
        new LongAccumulator((x, y) -> x + y, 0);
    
    public void accumulate(long value) {
        maxAccumulator.accumulate(value);
        sumAccumulator.accumulate(value);
    }
    
    public void printResults() {
        System.out.println("Max: " + maxAccumulator.get());
        System.out.println("Sum: " + sumAccumulator.get());
    }
}
```

### CAS (Compare-And-Swap)

**CAS** - atomic classlarning asosiy mexanizmi. Bu operatsiya hardware darajasida qo'llab-quvvatlanadi.

```java
// CAS ning mantiqiy ishlashi
public boolean compareAndSwap(int expectedValue, int newValue) {
    if (this.value == expectedValue) {
        this.value = newValue;
        return true;
    }
    return false;
}

// AtomicInteger'da ishlatilishi
AtomicInteger atomicInt = new AtomicInteger(10);
boolean success = atomicInt.compareAndSet(10, 20); // true
boolean failed = atomicInt.compareAndSet(10, 30);  // false (hozir 20)
```

**CAS qanday ishlaydi:**
1. Value ni o'qish
2. Expected value bilan solishtirish
3. Agar teng bo'lsa, new value yozish
4. Bularning hammasi bir atomic operatsiyada

### Atomic Classlarning Afzalliklari

1. **Lock-free** - Thread'lar bloklanmaydi, deadlock bo'lmaydi
2. **High performance** - Lock'lardan tezroq (past contention'da)
3. **Scalability** - Ko'p thread'lar bilan yaxshi ishlaydi
4. **Wait-free** - Barcha thread'lar doimiy progress qiladi

```java
//  Lock bilan (sekinroq)
public class CounterWithLock {
    private int count = 0;
    private Lock lock = new ReentrantLock();
    
    public void increment() {
        lock.lock();
        try {
            count++;
        } finally {
            lock.unlock();
        }
    }
}

//  Atomic bilan (tezroq)
public class CounterWithAtomic {
    private AtomicInteger count = new AtomicInteger(0);
    
    public void increment() {
        count.incrementAndGet(); // lock-free!
    }
}
```

---

## 3.2 - Thread-Safe Collections

### Thread-Safety nima?

**Thread safety** - multi-threaded kod tushunchasi. Thread-safe kod shared data structures bilan shunday manipulyatsiya qiladiki, barcha thread'lar to'g'ri ishlaydi va kutilmagan interaksiyalar bo'lmaydi.

```java
// Thread-safe EMAS
public class NotThreadSafe {
    private List<String> list = new ArrayList<>(); // ArrayList thread-safe emas!
    
    public void add(String item) {
        list.add(item); // Race condition!
    }
}

// Thread-safe
public class ThreadSafe {
    private List<String> list = Collections.synchronizedList(new ArrayList<>());
    
    public void add(String item) {
        list.add(item); // Synchronized - thread-safe
    }
}
```

### Thread-Safe Collections turlari

#### 1. Legacy Thread-Safe Collections (Eski)
```java
Vector<String> vector = new Vector<>(); // synchronized
Hashtable<String, String> hashtable = new Hashtable<>(); // synchronized
```

#### 2. Concurrent Collections (Java 5+)
```java
// Concurrent collections
ConcurrentHashMap<String, String> concurrentMap = new ConcurrentHashMap<>();
ConcurrentLinkedQueue<String> queue = new ConcurrentLinkedQueue<>();
ConcurrentSkipListMap<String, String> skipListMap = new ConcurrentSkipListMap<>();
ConcurrentSkipListSet<String> skipListSet = new ConcurrentSkipListSet<>();
CopyOnWriteArrayList<String> copyOnWriteList = new CopyOnWriteArrayList<>();
CopyOnWriteArraySet<String> copyOnWriteSet = new CopyOnWriteArraySet<>();
```

#### 3. Blocking Queues (Bloklanuvchi Queues)
```java
BlockingQueue<String> arrayBlockingQueue = new ArrayBlockingQueue<>(10);
BlockingQueue<String> linkedBlockingQueue = new LinkedBlockingQueue<>();
BlockingQueue<String> priorityBlockingQueue = new PriorityBlockingQueue<>();
BlockingDeque<String> linkedBlockingDeque = new LinkedBlockingDeque<>();
```

#### 4. Synchronized Wrappers
```java
List<String> syncList = Collections.synchronizedList(new ArrayList<>());
Set<String> syncSet = Collections.synchronizedSet(new HashSet<>());
Map<String, String> syncMap = Collections.synchronizedMap(new HashMap<>());
```

### ConcurrentHashMap

`ConcurrentHashMap` - `HashMap` ning thread-safe varianti. Butun map ni lock'lamaydi, segmentlar bo'yicha lock'laydi.

```java
import java.util.concurrent.ConcurrentHashMap;

public class ConcurrentHashMapExample {
    private ConcurrentHashMap<String, Integer> map = new ConcurrentHashMap<>();
    
    public void demonstrate() {
        // putIfAbsent - agar mavjud bo'lmasa qo'shadi
        map.putIfAbsent("key", 1);
        
        // compute - atomik update
        map.compute("key", (k, v) -> v == null ? 1 : v + 1);
        
        // merge - atomik merge
        map.merge("key", 1, Integer::sum);
        
        // forEach - parallel iteration
        map.forEach(2, (k, v) -> System.out.println(k + ": " + v));
        
        // search - parallel search
        String result = map.search(2, (k, v) -> v > 5 ? k : null);
    }
}
```

**Xususiyatlari:**
- Hech qachon whole map ni lock'lamaydi
- `null` key va value'lar qabul qilinmaydi
- Read operatsiyalari odatda lock-free
- Write operatsiyalari faqat kerakli segmentni lock'laydi

### ConcurrentHashSet

`ConcurrentHashSet` to'g'ridan-to'g'ri mavjud emas. `ConcurrentHashMap` orqali yaratiladi:

```java
// ConcurrentHashSet yaratish
Set<String> concurrentSet = ConcurrentHashMap.newKeySet();

// Yoki
Set<String> set = Collections.newSetFromMap(new ConcurrentHashMap<>());
```

### ArrayList ni Thread-Safe qilish

```java
// 1-usul: Collections.synchronizedList
List<String> syncList = Collections.synchronizedList(new ArrayList<>());

// 2-usul: CopyOnWriteArrayList (ko'p o'qish, kam yozish uchun)
List<String> cowList = new CopyOnWriteArrayList<>();

// 3-usul: Collections.synchronizedList with explicit synchronization
List<String> list = Collections.synchronizedList(new ArrayList<>());
synchronized (list) {
    Iterator<String> iterator = list.iterator(); // Synchronized block kerak!
    while (iterator.hasNext()) {
        System.out.println(iterator.next());
    }
}
```

### BlockingQueue

`BlockingQueue` - producer-consumer pattern'ini implement qilish uchun ideal.

```java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.BlockingQueue;

public class BlockingQueueExample {
    private BlockingQueue<String> queue = new ArrayBlockingQueue<>(10);
    
    // Producer thread
    class Producer implements Runnable {
        @Override
        public void run() {
            try {
                for (int i = 0; i < 20; i++) {
                    String item = "Item-" + i;
                    queue.put(item); // Queue full bo'lsa, bloklanadi
                    System.out.println("Produced: " + item);
                    Thread.sleep(100);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    // Consumer thread
    class Consumer implements Runnable {
        @Override
        public void run() {
            try {
                while (true) {
                    String item = queue.take(); // Queue empty bo'lsa, bloklanadi
                    System.out.println("Consumed: " + item);
                    Thread.sleep(200);
                }
            } catch (InterruptedException e) {
                Thread.currentThread().interrupt();
            }
        }
    }
    
    public void start() {
        new Thread(new Producer()).start();
        new Thread(new Consumer()).start();
    }
}
```

### ArrayBlockingQueue

`ArrayBlockingQueue` - array asosidagi bounded blocking queue.

```java
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.TimeUnit;

public class ArrayBlockingQueueDemo {
    private ArrayBlockingQueue<String> queue = 
        new ArrayBlockingQueue<>(5); // Capacity = 5
    
    public void demonstrate() throws InterruptedException {
        // add - queue full bo'lsa, IllegalStateException
        queue.add("item1");
        
        // offer - queue full bo'lsa, false qaytaradi
        boolean offered = queue.offer("item2");
        
        // offer with timeout - vaqtgacha kutadi
        boolean offeredWithTimeout = queue.offer("item3", 1, TimeUnit.SECONDS);
        
        // put - queue full bo'lsa, bo'sh joy bo'lguncha kutadi (bloklanadi)
        queue.put("item4");
        
        // remove - elementni o'chiradi
        String item = queue.remove();
        
        // poll - elementni oladi yoki null qaytaradi
        String polled = queue.poll();
        
        // poll with timeout - vaqtgacha kutadi
        String polledWithTimeout = queue.poll(1, TimeUnit.SECONDS);
        
        // take - element bo'lguncha kutadi (bloklanadi)
        String taken = queue.take();
    }
}
```

---

## 3.3 - Immutable Class (O'zgarmas Class)

### Immutable Class nima?

**Immutable class** - obyekti yaratilgandan so'ng uning content'ini o'zgartirib bo'lmaydigan class.

```java
// Java'dagi immutable classlar
String str = "Hello";
str = str + " World"; // Yangi String yaratiladi, eski o'zgarmaydi

Integer num = 42;
num++; // Yangi Integer yaratiladi

// Qachonki immutable class ishlatsangiz:
List<String> list = List.of("a", "b", "c"); // Java 9+ immutable list
// list.add("d"); // UnsupportedOperationException!
```

### Immutable Class yaratish qoidalari

```java
// 1. Class final bo'lishi kerak - voris olinmasligi uchun
public final class ImmutablePerson {
    
    // 2. Data members private va final bo'lishi kerak
    private final String name;
    private final int age;
    private final List<String> hobbies; // Mutable object!
    
    // 3. Parametrized constructor - deep copy qilish kerak
    public ImmutablePerson(String name, int age, List<String> hobbies) {
        this.name = name;
        this.age = age;
        // Deep copy - original list o'zgarsa ham bizniki o'zgarmasligi uchun
        this.hobbies = new ArrayList<>(hobbies);
    }
    
    // 4. Getter'lar - deep copy qaytarish kerak (mutable objects uchun)
    public String getName() {
        return name; // String immutable, shuning uchun safe
    }
    
    public int getAge() {
        return age; // primitive safe
    }
    
    public List<String> getHobbies() {
        // Return immutable view yoki copy
        return Collections.unmodifiableList(hobbies);
        // yoki
        // return new ArrayList<>(hobbies); // defensive copy
    }
    
    // 5. Setter'lar bo'lmasligi kerak!
}
```

### To'liq misol

```java
import java.util.*;

// 1. Class final
public final class BankAccount {
    
    // 2. Fields private va final
    private final String accountNumber;
    private final String holderName;
    private final double balance;
    private final List<Transaction> transactions;
    private final Map<String, String> metadata;
    
    // 3. Constructor - deep copy
    public BankAccount(String accountNumber, String holderName, 
                      double balance, List<Transaction> transactions,
                      Map<String, String> metadata) {
        this.accountNumber = accountNumber;
        this.holderName = holderName;
        this.balance = balance;
        
        // List uchun defensive copy
        this.transactions = transactions == null ? 
            Collections.emptyList() : 
            List.copyOf(transactions); // Java 10+ immutable copy
        
        // Map uchun defensive copy
        this.metadata = metadata == null ? 
            Collections.emptyMap() : 
            Collections.unmodifiableMap(new HashMap<>(metadata));
    }
    
    // 4. Getter'lar - defensive copies
    public String getAccountNumber() {
        return accountNumber;
    }
    
    public String getHolderName() {
        return holderName;
    }
    
    public double getBalance() {
        return balance;
    }
    
    public List<Transaction> getTransactions() {
        // Immutable view qaytarish
        return transactions; // transactions allaqachon immutable
    }
    
    public Map<String, String> getMetadata() {
        // Unmodifiable view qaytarish
        return metadata; // metadata allaqachon unmodifiable
    }
    
    // 5. Yangi balance bilan yangi obyekt yaratish (with methods)
    public BankAccount withBalance(double newBalance) {
        return new BankAccount(
            this.accountNumber, 
            this.holderName, 
            newBalance, 
            this.transactions, 
            this.metadata
        );
    }
    
    // Transaction immutable bo'lishi kerak
    public static final class Transaction {
        private final LocalDateTime timestamp;
        private final double amount;
        private final String type;
        
        public Transaction(LocalDateTime timestamp, double amount, String type) {
            this.timestamp = timestamp;
            this.amount = amount;
            this.type = type;
        }
        
        // getters...
    }
}
```

### Java'dagi immutable classlar

1. **String**
2. **Wrapper classes**: Integer, Long, Double, Boolean, etc.
3. **BigInteger**, **BigDecimal**
4. **LocalDate**, **LocalTime**, **LocalDateTime** (Java 8 Time API)
5. **Collections.unmodifiable...** view'lar
6. **List.of()**, **Set.of()**, **Map.of()** (Java 9+)
7. **Records** (Java 14+)

```java
// Java Records - immutable class yaratishning oson yo'li
public record Person(String name, int age) {}

// Bu avtomatik ravishda:
// - final class
// - private final fields
// - constructor
// - equals(), hashCode(), toString()
// - getter'lar (name(), age())
```

### Immutable Class'lar nima uchun thread-safe?

```java
public class ImmutabilityExample {
    
    //  Mutable class - thread-safe emas
    public static class MutableCounter {
        private int count = 0;
        
        public void increment() {
            count++; // Race condition!
        }
        
        public int getCount() {
            return count;
        }
    }
    
    //  Immutable class - thread-safe
    public static class ImmutableCounter {
        private final int count;
        
        public ImmutableCounter(int count) {
            this.count = count;
        }
        
        public ImmutableCounter increment() {
            return new ImmutableCounter(count + 1); // Yangi obyekt
        }
        
        public int getCount() {
            return count;
        }
    }
    
    public static void main(String[] args) {
        ImmutableCounter counter = new ImmutableCounter(0);
        
        // Multiple thread'lar bir vaqtda ishlatishi mumkin
        Runnable task = () -> {
            for (int i = 0; i < 1000; i++) {
                counter = counter.increment(); // Har doim yangi obyekt
            }
        };
        
        // Thread-safe - race condition yo'q!
        Thread t1 = new Thread(task);
        Thread t2 = new Thread(task);
        
        t1.start();
        t2.start();
        
        // Synchronization kerak emas!
    }
}
```

### Immutable Class'larning Afzalliklari

1. **Thread-safe** - Syncronization kerak emas
2. **Caching** uchun ideal
3. **Hash-based collections** (HashMap, HashSet) uchun xavfsiz
4. **Failure atomicity** - Hech qachon inconsistent state'da bo'lmaydi
5. **Simple** - State o'zgarmaydi, debugging oson

```java
// Immutable class caching
public final class Color {
    private final int red;
    private final int green;
    private final int blue;
    
    // Cache
    private static final Map<String, Color> CACHE = new HashMap<>();
    
    private Color(int red, int green, int blue) {
        this.red = red;
        this.green = green;
        this.blue = blue;
    }
    
    public static Color valueOf(int red, int green, int blue) {
        String key = red + "," + green + "," + blue;
        
        // Synchronization kerak emas - immutable object'lar safe
        return CACHE.computeIfAbsent(key, 
            k -> new Color(red, green, blue));
    }
}
```

---

## Tekshiruv Savollari

### Lesson 3.1 - Atomics
1. **Atomics nima?**
2. **Nima uchun Atomic Classlar foydalanishimiz kerak?**
3. **Atomic Operation qanday ishlaydi?**
4. **CAS nima? CAS qanday ishlashini tushintirib bering.**
5. **Atomic classlar threadlarni blocklamasdan turib classni thread safe qilishi mumkinmi?**
6. **Atomic classlarni afzalliklari?**

### Lesson 3.2 - Thread-safe collections
1. **Java-da nechi xil yo'l bilan classni thread-safe qilishimiz mumkin?**
2. **Java-da nechta thread safe collectionlar bor?**
3. **ConcurrentHashMap nima?**
4. **ArrayList ni thread-safe qilishimiz mumkinmi?**

### Lesson 3.3 - Immutable class
1. **Immutable class nima?**
2. **Immutable classni o'zimiz yaratishimiz mumkinmi? Mumkin bo'lsa qanday qilib yaratamiz?**
3. **Java-dagi immutable classlarni sanab bering?**
4. **Immutable classlar thread-safemi? Thread-safe bo'lsa nima uchun?**

---

**Keyingi mavzu:** [Locks and Synchronization](./04%20-%20Tasks%20and%20Thread%20Pools.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
