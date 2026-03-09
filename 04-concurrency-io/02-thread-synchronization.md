# 02 - Thread Synchronization (Thread Sinxronizatsiyasi)

## Mundarija
1. [Race Condition](#race-condition)
2. [Lock Objects](#lock-objects)
3. [Condition Objects](#condition-objects)
4. [Synchronized Method va Blocks](#synchronized-method-va-blocks)
5. [Volatile](#volatile)
6. [Deadlock](#deadlock)
7. [Tekshiruv Savollari](#tekshiruv-savollari)

---

## Race Condition

### Race Condition nima?

**Race Condition** (Musobaqa holati) - ikki yoki undan ortiq thread bir vaqtda umumiy ma'lumotga murojaat qilganda va uni o'zgartirganda yuzaga keladigan muammo. Thread'lar bir-birining ishiga xalaqit berishi natijasida ma'lumotlar buzilishi mumkin.

```java
// Race Condition misoli
class BankAccount {
    private int balance = 100;
    
    public void withdraw(int amount) {
        if (balance >= amount) {
            // Thread bu yerda to'xtab qolishi mumkin
            System.out.println(Thread.currentThread().getName() + " pul yechmoqda...");
            
            try {
                Thread.sleep(100); // Race condition'ni ko'rsatish uchun
            } catch (InterruptedException e) {}
            
            balance -= amount;
            System.out.println(Thread.currentThread().getName() + " yechdi. Qoldiq: " + balance);
        } else {
            System.out.println(Thread.currentThread().getName() + " uchun mablag' yetarli emas!");
        }
    }
    
    public int getBalance() { return balance; }
}

public class RaceConditionExample {
    public static void main(String[] args) {
        BankAccount account = new BankAccount();
        
        // Ikki thread bir vaqtda pul yechishga harakat qiladi
        Thread t1 = new Thread(() -> account.withdraw(80), "Thread-1");
        Thread t2 = new Thread(() -> account.withdraw(80), "Thread-2");
        
        t1.start();
        t2.start();
    }
}
```

**Natija:** Ikkala thread ham pul yechishga muvaffaq bo'lishi mumkin (balance -60 bo'lib ketadi), yoki bittasi yechib, ikkinchisi muvaffaqiyatsizlikka uchraydi - bu oldindan aytib bo'lmaydi.

---

## Lock Objects

### Lock nima?

**Lock** - bu thread'lar o'rtasida resurslarni himoyalash mexanizmi. Lock yordamida bir vaqtning o'zida faqat bitta thread kritik sektsiyaga kirishi mumkin.

### ReentrantLock

`ReentrantLock` - Java 5 da qo'shilgan, `synchronized` keyword'iga alternativa.

```java
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class SafeBankAccount {
    private int balance = 100;
    private final Lock lock = new ReentrantLock();
    
    public void withdraw(int amount) {
        lock.lock(); // Lock olish
        try {
            if (balance >= amount) {
                System.out.println(Thread.currentThread().getName() + " pul yechmoqda...");
                Thread.sleep(100);
                balance -= amount;
                System.out.println(Thread.currentThread().getName() + " yechdi. Qoldiq: " + balance);
            } else {
                System.out.println(Thread.currentThread().getName() + " uchun mablag' yetarli emas!");
            }
        } catch (InterruptedException e) {
            e.printStackTrace();
        } finally {
            lock.unlock(); // LOCK DOIMO FINALLY BLOKIDA OCHILISHI KERAK!
        }
    }
}
```

**MUHIM:** `unlock()` har doim `finally` blokida chaqirilishi kerak, aks holda exception sodir bo'lsa, lock ochilmay qoladi va boshqa thread'lar bloklanadi.

### ReentrantLock(boolean fair)

```java
// Fair lock - thread'lar navbat bilan ishlaydi
Lock fairLock = new ReentrantLock(true); // Fair lock (sekinroq)

// Unfair lock - thread'lar ustunlik olishi mumkin
Lock unfairLock = new ReentrantLock(false); // Default - tezroq
```

**Fair lock:** Thread'lar navbat bilan ishlaydi (first-in-first-out). Bu adolatli, lekin sekinroq.
**Unfair lock:** Thread'lar ustunlik olishi mumkin. Bu tezroq, lekin ba'zi thread'lar och qolishi mumkin.

### ReentrantLock va Synchronized farqi

| Xususiyat | ReentrantLock | synchronized |
|-----------|---------------|--------------|
| **Try lock** | `tryLock()` bilan mavjud | Yo'q |
| **Timeout** | `tryLock(timeout)` bilan mavjud | Yo'q |
| **Interruptible** | `lockInterruptibly()` bilan mavjud | Faqat `wait()` bilan |
| **Fairness** | Ha (constructor'da sozlash mumkin) | Yo'q |
| **Condition** | Bir nechta condition | Bitta intrinsic condition |
| **Sintaksis** | Murakkabroq | Sodda |

```java
// ReentrantLock afzalliklari - tryLock()
if (lock.tryLock(1, TimeUnit.SECONDS)) {
    try {
        // Lock olindi
    } finally {
        lock.unlock();
    }
} else {
    // Lock olish imkoni bo'lmadi
    System.out.println("Lock olish imkoni yo'q, boshqa ish qilamiz");
}
```

---

## Condition Objects

### Condition nima?

**Condition** - thread'lar uchun kutish va signal berish mexanizmi. Bir thread ma'lum shart bajarilishini kutishi, boshqa thread esa shart bajarilganda signal berishi mumkin.

```java
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

class BoundedBuffer {
    private final Lock lock = new ReentrantLock();
    private final Condition notFull = lock.newCondition();
    private final Condition notEmpty = lock.newCondition();
    
    private final Object[] items = new Object[10];
    private int putIndex, takeIndex, count;
    
    public void put(Object item) throws InterruptedException {
        lock.lock();
        try {
            while (count == items.length) {
                // Buffer to'la - kutish
                notFull.await();
            }
            
            items[putIndex] = item;
            if (++putIndex == items.length) putIndex = 0;
            count++;
            
            // Bufferda element bor - iste'molchilarga xabar
            notEmpty.signalAll();
        } finally {
            lock.unlock();
        }
    }
    
    public Object take() throws InterruptedException {
        lock.lock();
        try {
            while (count == 0) {
                // Buffer bo'sh - kutish
                notEmpty.await();
            }
            
            Object item = items[takeIndex];
            if (++takeIndex == items.length) takeIndex = 0;
            count--;
            
            // Bufferda joy bor - ishlab chiqaruvchilarga xabar
            notFull.signalAll();
            
            return item;
        } finally {
            lock.unlock();
        }
    }
}
```

### Condition metodlari

- `await()` - Thread'ni kutishga qo'yadi
- `signal()` - Kutayotgan thread'lardan biriga signal beradi
- `signalAll()` - Barcha kutayotgan thread'larga signal beradi

**MUHIM:** `signalAll()` biror thread tomonidan chaqirilishi kerak. Agar hech kim chaqirmasa, kutayotgan thread'lar abadiy kutib qoladi (deadlock).

---

## Synchronized Method va Blocks

### Synchronized nima?

**Synchronized** - Java'dagi intrinsic locking mexanizmi. Har bir obyekt o'ziga xos intrinsic lock'ga ega.

### Necha xil levelda synchronized ishlatish mumkin?

#### 1. Instance Method
```java
public class Counter {
    private int count = 0;
    
    // Butun metod synchronized
    public synchronized void increment() {
        count++;
    }
    
    // Bu bilan bir xil:
    public void increment2() {
        synchronized(this) {
            count++;
        }
    }
}
```

#### 2. Static Method
```java
public class StaticCounter {
    private static int count = 0;
    
    // Class-level lock
    public static synchronized void increment() {
        count++;
    }
    
    // Bu bilan bir xil:
    public static void increment2() {
        synchronized(StaticCounter.class) {
            count++;
        }
    }
}
```

#### 3. Code Block
```java
public class BlockExample {
    private final Object lock = new Object(); // Maxsus lock obyekti
    private int count = 0;
    
    public void increment() {
        // Faqat kerakli qism synchronized
        synchronized(lock) {
            count++;
        }
        
        // Boshqa ishlar (synchronized emas)
        System.out.println("Bajarildi");
    }
}
```

### Nima uchun wait() va notify() synchronized blokdan chaqiriladi?

`wait()`, `notify()` va `notifyAll()` metodlari faqat synchronized blok yoki metod ichida chaqirilishi mumkin. Sababi:

1. **Thread safety** - Kutish va xabar berish operatsiyalari atomic bo'lishi kerak
2. **Lost wakeup problem** - Signal kutayotgan threaddan oldin kelsa, signal yo'qoladi

```java
//  To'g'ri
synchronized(lock) {
    while(!condition) {
        lock.wait(); // Lockni vaqtincha bo'shatadi
    }
    // Condition bajarildi
}

//  Xato - wait() synchronized emas
lock.wait(); // IllegalMonitorStateException!
```

### Synchronized method va block farqi

| Xususiyat | Synchronized Method | Synchronized Block |
|-----------|---------------------|---------------------|
| **Lock scope** | Butun metod | Faqat blok ichidagi kod |
| **Performance** | Sekinroq (butun metod lock) | Tezroq (faqat kerakli qism) |
| **Lock object** | `this` yoki `Class` | Har qanday obyekt |
| **Flexibility** | Cheklangan | Moslashuvchan |

```java
// Method - butun metod lock
public synchronized void update() {
    // QISM 1
    doSomething1();
    // QISM 2
    doSomething2();
    // QISM 3
    doSomething3();
}

// Block - faqat kerakli qism lock
public void update() {
    doSomething1(); // synchronized emas
    synchronized(this) {
        doSomething2(); // synchronized
    }
    doSomething3(); // synchronized emas
}
```

### Static synchronized method vs instance synchronized method

```java
public class Example {
    // Class-level lock
    public static synchronized void staticMethod() {
        // Barcha instance'lar uchun bitta lock
    }
    
    // Instance-level lock
    public synchronized void instanceMethod() {
        // Har bir instance uchun alohida lock
    }
}
```

**Farqi:**
- **Static synchronized** - `Example.class` obyekti lock'lanadi. Bir vaqtda faqat bitta thread static synchronized metodlarni ishlata oladi
- **Instance synchronized** - `this` obyekti lock'lanadi. Turli instance'lar uchun turli lock'lar

```java
Example obj1 = new Example();
Example obj2 = new Example();

// Bu ikki thread bir vaqtda ishlay oladi (turli instance'lar)
new Thread(() -> obj1.instanceMethod()).start();
new Thread(() -> obj2.instanceMethod()).start();

// Bu ikki thread bir vaqtda ishlamaydi (bir xil class lock)
new Thread(() -> Example.staticMethod()).start();
new Thread(() -> Example.staticMethod()).start();
```

---

## Volatile

### Volatile nima?

**Volatile** - Java'dagi keyword bo'lib, o'zgaruvchining qiymati CPU cache'da emas, balki to'g'ridan-to'g'ri main memory'da saqlanishini ta'minlaydi.

### Visibility muammosi (Ko'rinish muammosi)

```
Core 1 (Thread 1)      Core 2 (Thread 2)
     |                       |
   cache                   cache
   a = 100                 a = 100
     |                       |
     +--------- bus ---------+
                |
          Main Memory
           a = 100
```

Thread'lar o'zgaruvchilarni CPU cache'ga nusxalab oladi. Bitta thread o'zgartirgan qiymat boshqa thread'ga ko'rinmasligi mumkin.

```java
//  Visibility muammosi
class VisibilityProblem {
    private boolean running = true;
    
    public void run() {
        while (running) {
            // Bu thread running o'zgaruvchisini cache'da saqlashi mumkin
        }
        System.out.println("Stopped!");
    }
    
    public void stop() {
        running = false; // Main memory'ga yoziladi, lekin...
    }
}
```

### Volatile bilan yechim

```java
//  Volatile bilan
class VolatileExample {
    private volatile boolean running = true;
    
    public void run() {
        while (running) {
            // volatile: har doim main memory'dan o'qiladi
        }
        System.out.println("Stopped!");
    }
    
    public void stop() {
        running = false; // To'g'ridan-to'g'ri main memory'ga yoziladi
    }
}
```

### Volatile qayerda ishlatiladi?

1. **Status flag'lar**
2. **Singleton pattern (double-checked locking)**
3. **Read-mostly o'zgaruvchilar**

```java
// Singleton pattern with volatile
class Singleton {
    private static volatile Singleton instance;
    
    public static Singleton getInstance() {
        if (instance == null) {
            synchronized(Singleton.class) {
                if (instance == null) {
                    instance = new Singleton();
                }
            }
        }
        return instance;
    }
}
```

### Volatile thread-safe qiladimi?

**VOLATILE THREAD-SAFE EMAS!**

```java
//  Volatile race condition'ni oldini olmaydi
class Counter {
    private volatile int count = 0;
    
    public void increment() {
        count++; // BU ATOMIC EMAS!
        // 1. count ni o'qish (read)
        // 2. +1 qilish (modify)
        // 3. count ni yozish (write)
        // Bu uch operatsiya orasida boshqa thread kelib qolishi mumkin
    }
}

//  To'g'ri yechim
class SafeCounter {
    private AtomicInteger count = new AtomicInteger(0);
    
    public void increment() {
        count.incrementAndGet(); // Atomic operatsiya
    }
}
```

### Volatile afzalliklari va kamchiliklari

| Afzalliklari | Kamchiliklari |
|--------------|---------------|
| Visibility kafolatlaydi | Race condition'ni oldini olmaydi |
| Synchronized'dan tezroq | Atomic operatsiyalarni qo'llab-quvvatlamaydi |
| Locksiz | Compound actions (read-modify-write) uchun yaroqsiz |

---

## Deadlock

### Deadlock nima?

**Deadlock** - ikki yoki undan ortiq thread bir-birining resurslarini kutib qolgan holat. Hech qaysi thread davom eta olmaydi.

```java
// Deadlock misoli
class DeadlockExample {
    private final Object lock1 = new Object();
    private final Object lock2 = new Object();
    
    public void method1() {
        synchronized(lock1) {
            System.out.println("Thread 1: lock1 ni oldi");
            
            try { Thread.sleep(100); } catch (Exception e) {}
            
            synchronized(lock2) {
                System.out.println("Thread 1: lock2 ni oldi");
            }
        }
    }
    
    public void method2() {
        synchronized(lock2) {
            System.out.println("Thread 2: lock2 ni oldi");
            
            try { Thread.sleep(100); } catch (Exception e) {}
            
            synchronized(lock1) {
                System.out.println("Thread 2: lock1 ni oldi");
            }
        }
    }
    
    public static void main(String[] args) {
        DeadlockExample deadlock = new DeadlockExample();
        
        new Thread(() -> deadlock.method1()).start();
        new Thread(() -> deadlock.method2()).start();
        
        // Ikkala thread ham bir-birini kutib qoladi!
    }
}
```

### Deadlockning 4 sharti

Deadlock yuz berishi uchun quyidagi 4 shart bajarilishi kerak:

1. **Mutual Exclusion** - Resurs faqat bitta thread tomonidan ishlatilishi mumkin
2. **Hold and Wait** - Thread bir resursni ushlab turib, boshqa resursni kutadi
3. **No Preemption** - Resursni thread ixtiyoriy ravishda qo'yib bermaguncha, undan tortib olish mumkin emas
4. **Circular Wait** - Thread'lar aylana bo'ylab bir-birini kutadi

### Deadlock'ni oldini olish

```java
// 1-usul: Lock'larni doim bir xil tartibda olish
public void safeMethod1() {
    synchronized(lock1) {
        synchronized(lock2) {
            // ish
        }
    }
}

public void safeMethod2() {
    synchronized(lock1) { // Bir xil tartib
        synchronized(lock2) {
            // ish
        }
    }
}

// 2-usul: tryLock() bilan
import java.util.concurrent.locks.ReentrantLock;

class SafeDeadlockPrevention {
    private final ReentrantLock lock1 = new ReentrantLock();
    private final ReentrantLock lock2 = new ReentrantLock();
    
    public void method1() {
        while(true) {
            if (lock1.tryLock()) {
                try {
                    if (lock2.tryLock()) {
                        try {
                            // Ikkala lock ham olindi
                            break;
                        } finally {
                            lock2.unlock();
                        }
                    }
                } finally {
                    lock1.unlock();
                }
            }
            // Bir oz kutib, qayta urinish
            try { Thread.sleep(100); } catch (Exception e) {}
        }
    }
}
```

### Livelock nima?

**Livelock** - thread'lar deadlock'dagi kabi bloklanmaydi, lekin bir-biriga yo'l berishga urinib, hech qanday progress qilmaydi.

```java
// Livelock misoli
class LivelockExample {
    static class Worker {
        private boolean active = true;
        
        public void work(Resource resource, Worker other) {
            while(active) {
                if (resource.isLocked()) {
                    // Boshqa worker ga yo'l berish
                    System.out.println(Thread.currentThread().getName() + " yo'l beradi");
                    continue;
                }
                
                // Resursni olishga urinish
            }
        }
    }
}
```

### Deadlock vs Livelock

| Xususiyat | Deadlock | Livelock |
|-----------|----------|----------|
| **Thread holati** | BLOCKED/WAITING | RUNNABLE |
| **CPU usage** | Minimal | Yuqori (doim harakat) |
| **Progress** | Hech qanday | Hech qanday |
| **Yechish** | Qiyin (restart kerak) | Mumkin (backoff strategy) |

---

## Tekshiruv Savollari

### Lesson 2.1 (Race Condition)
1. **Race condition qanday muammo?**
   - Bir nechta thread umumiy ma'lumotga bir vaqtda murojaat qilganda yuzaga keladigan muammo

2. **Race condition qanday qilib oldini olishimiz mumkin?**
   - Synchronized, Lock, Atomic class'lar yordamida

3. **Lock nima?**
   - Thread'lar o'rtasida resurslarni himoyalash mexanizmi

4. **ReentrantLock qanday class?**
   - Java 5 da qo'shilgan, synchronized ga alternativa lock class

5. **ReentrantLock va Synchronized keyword o'rtasidagi farqi?**
   - Fairness, tryLock(), interruptible lock, multiple conditions

6. **Synchronized keywordidan ReetrantLock class qanday afzalliklari bor?**
   - Moslashuvchanlik, tryLock, timeout, fairness

### Lesson 2.2 (Condition Objects)
1. **Condition nima?**
   - Thread'larni kutish va signal berish mexanizmi

2. **Condition interface nima uchun ishlatilishi?**
   - Bir lock uchun bir nechta kutish set'larini yaratish, producer-consumer pattern

### Lesson 2.3 (Synchronized Method and Blocks)
1. **Synchronized nima?**
   - Intrinsic locking mexanizmi

2. **Nechi xil levelda synchronized keyword ishlatishimiz mumkin?**
   - Instance method, static method, code block

3. **Nima uchun wait() va notify() methodlar synchronized blockdan chaqiriladi?**
   - Thread safety va lost wakeup problem oldini olish

4. **Synchronized method va block farqi?**
   - Scope, performance, flexibility

5. **Static synchronized method bilan synchronized method farqi?**
   - Class-level vs instance-level lock

### Lesson 2.4 (Volatile)
1. **Volatile nima?**
   - O'zgaruvchini main memory'da saqlashni ta'minlovchi keyword

2. **Volatile keywordni nimalarga nisbatan qo'llashimiz mumkin?**
   - O'zgaruvchilarga (fields)

3. **Volatile keyword class thread safe qiladimi?**
   - Yo'q, faqat visibility muammosini hal qiladi

4. **Volatile keyword afzalliklari va kamchiliklari?**
   - Afzalliklari: tez, visibility kafolatlaydi
   - Kamchiliklari: atomic emas, compound actions uchun yaroqsiz

### Lesson 2.5 (Deadlock)
1. **Deadlock nima? misol keltiring.**
   - Thread'lar bir-birini kutib qolgan holat

2. **Thread Deadlock holatiga tushib qolmasligi uchun nima qilishimz kerak?**
   - Lock'larni doim bir xil tartibda olish, tryLock() ishlatish

3. **Livelock va Deadlock o'rtasidagi farq?**
   - Deadlock: thread'lar bloklangan, CPU ishlatmaydi
   - Livelock: thread'lar ishlayapti lekin progress yo'q

---

**Keyingi mavzu:** [03 - Thread Pools and Executors](./03-Concurrency.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
