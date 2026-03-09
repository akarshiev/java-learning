# 01 - MultiThreading (Ko'p Tarmoqli Dasturlash)

## MultiTasking va MultiThreading

### CPU va Yadrolar (Cores)
```
   ____________
  |            |
===            ===
  |    CPU     |
===            ===
  |            |
   ------------
```

**1 ta Core = 1 ta yadro**. Agar CPU 1 yadroli bo'lsa, u bir vaqtda faqat bitta vazifani bajara oladi.

### MultiTasking (Ko'p Vazifalilik)
MultiTasking - bu bitta CPU bir nechta vazifalarni bajarish usuli.

**Misol:** 3 ta dastur ishlamoqda:
- 1-dastur 10 ms ishlaydi
- Keyin 2-dastur ishlaydi
- 2-dastur tugagach, 3-dastur ishlaydi

Dasturlar bir-birini kutib, navbat bilan ishlaydi. Bu vaqt bo'lish (time sharing) printsipi asosida ishlaydi.

### MultiThreading (Ko'p Tarmoqli Dasturlash)
**Thread** - bu bitta vazifa (task). 
**MultiThreading** - bir jarayon (process) ichida bir nechta vazifalarni bir vaqtda bajarish.

**Misol:** Brauzer ochilgan:
- YouTube orqali musiqa tinglash (Task 1)
- Medium'da maqola o'qish (Task 2)
- Notion'da qayd yozish (Task 3)

Barchasi bir vaqtda amalga oshadi. Background'da musiqa ijro etilayotganda, foydalanuvchi maqola o'qiy oladi.

### Nima uchun MultiThreading kerak?
1. **CPU'dan maksimal foydalanish** - Bir vazifa kutish holatida bo'lganda, CPU bo'sh turmasdan boshqa vazifani bajaradi

2. **Real-life misol:** 
   - API request yuborildi, response kelishiga 15 ms ketadi
   - Shu 15 ms davomida CPU bo'sh turmasdan boshqa vazifani bajaradi

3. **User Experience misoli:**
   - Foydalanuvchi Sign in qildi
   - Ma'lumotlar DB'ga yoziladi (10 ms)
   - Bu vaqt ichida foydalanuvchi kutib qolmasligi uchun, background thread DB operatsiyasini bajaradi
   - Foydalanuvchi darhol Home page'ga o'tkaziladi

---

## Thread (Tarmoq)

**Muhim:** Javada 1 ta thread = Operatsion Sistemadagi 1 ta thread.

### Thread ni ko'rish:
```java
System.out.println(Thread.currentThread().getName());
```

### 1-usul: Thread class'idan voris olish (Tavsiya qilinmaydi)

```java
class Main {
    public static void main(String[] args) {
        MyTask myTask = new MyTask();
        myTask.run();  // Alohida thread yaratilmaydi
        System.out.println("Hello World!");
    }
}

class MyTask extends Thread {
    @Override
    public void run() {
        for(int i = 1; i < 15; i++) {
            System.out.println(Thread.currentThread().getName() + " -> " + i);
        }
    }
}
```

**Natija:** 
```
Thread-0 -> 1
Thread-0 -> 2
...
Thread-0 -> 14
Hello World!
```

**Muammo:** `run()` metodini to'g'ridan-to'g'ri chaqirish yangi thread yaratmaydi. Bu oddiy metod chaqiruvi kabi ishlaydi.

### To'g'ri usul: start() metodidan foydalanish

```java
class Main {
    public static void main(String[] args) {
        MyTask myTask = new MyTask();
        myTask.start();  //  Yangi thread yaratiladi
        System.out.println("Hello World!");
    }
}
```

**Natija:**
```
Hello World!
Thread-0 -> 1
Thread-0 -> 2
...
Thread-0 -> 14
```

**Sabab:** Yangi thread yaratilayotgan vaqt ketganligi sababli, CPU bo'sh turmasdan "Hello World!" ni chiqarib yuboradi.

---

### 2-usul: Runnable interface'ini implement qilish (Tavsiya etiladi)

```java
class MyRunnableTask implements Runnable {
    @Override
    public void run() {
        for(int i = 1; i < 15; i++) {
            System.out.println(Thread.currentThread().getName() + " -> " + i);
        }
    }
}

class Main {
    public static void main(String[] args) {
        MyRunnableTask myRunnableTask = new MyRunnableTask();
        Thread thread = new Thread(myRunnableTask); // Runnable'ni Thread'ga o'tkazish
        thread.start();
        System.out.println("Hello World!");
    }
}
```

### Nima uchun Runnable Thread'dan yaxshiroq?

1. **Kompozitsiya (Composition)** - Thread class'iga Runnable obyektini berish orqali kompozitsiyadan foydalanamiz, bu inheritance'dan ko'ra moslashuvchanroq
2. **Multiple inheritance muammosi yo'q** - Thread'dan voris olinsa, boshqa class'dan voris olish imkoniyati yo'qoladi
3. **Resurs tejamkorligi** - Ko'p tasklar bo'lsa, har biri uchun alohida thread yaratish qimmat
4. **Lambda expressions** - Java 8 dan boshlab Runnable lambda orqali ifodalanishi mumkin

---

### Java 8+ Runnable yaratish usullari

#### 1. Lambda expression
```java
Runnable runnable = () -> {
    for(int i = 1; i < 15; i++) {
        System.out.println(Thread.currentThread().getName() + " -> " + i);
    }
};

Thread thread = new Thread(runnable);
thread.start();
```

#### 2. Anonim thread yaratish
```java
new Thread(() -> {
    for(int i = 1; i < 15; i++) {
        System.out.println(Thread.currentThread().getName() + " -> " + i);
    }
}).start();
```

#### 3. Thread nomi bilan
```java
new Thread(() -> {
    for(int i = 1; i < 15; i++) {
        System.out.println(Thread.currentThread().getName() + " -> " + i);
    }
}, "MyCustomThread").start();
```

---

### Thread.sleep() - Thread'ni uxlatish

```java
public class SleepExample {
    public static void main(String[] args) {
        Runnable task = () -> {
            for(int i = 1; i <= 5; i++) {
                System.out.println(Thread.currentThread().getName() + ": " + i);
                
                try {
                    Thread.sleep(1000); // 1 soniya uxlatish
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };
        
        new Thread(task, "SleepThread").start();
    }
}
```

**Natija:** Har bir soniya oralig'ida raqamlar chiqadi.

**InterruptedException** - sleep vaqtida thread to'xtatilsa, bu exception tashlanadi.

---

### Thread Class'ining Muhim Metodlari

| Metod | Tavsifi |
|-------|---------|
| `void start()` | Thread'ni ishga tushiradi |
| `void run()` | Thread bajaradigan vazifa |
| `void join()` | Thread tugashini kutadi |
| `void join(long millis)` | Thread tugashini yoki berilgan vaqt o'tishini kutadi |
| `Thread.State getState()` | Thread holatini qaytaradi |
| `void stop()` | Thread'ni to'xtatadi (**deprecated**) |
| `void suspend()` | Thread'ni vaqtincha to'xtatadi (**deprecated**) |
| `void resume()` | Suspend qilingan thread'ni davom ettiradi (**deprecated**) |
| `void sleep(long millis)` | Thread'ni berilgan vaqtga uxlatadi |
| `void yield()` | CPU'ni boshqa thread'ga berish imkoniyati |

---

### join() metodining ishlashi

```java
public class JoinExample {
    public static void main(String[] args) throws InterruptedException {
        Runnable task = () -> {
            for(int i = 1; i <= 5; i++) {
                System.out.println(Thread.currentThread().getName() + " -> " + i);
                try {
                    Thread.sleep(500);
                } catch (InterruptedException e) {
                    e.printStackTrace();
                }
            }
        };
        
        Thread thread1 = new Thread(task, "Thread 1");
        Thread thread2 = new Thread(task, "Thread 2");
        
        thread1.start();
        thread1.join(); // thread1 tugashini kutadi
        
        thread2.start();
        thread2.join(); // thread2 tugashini kutadi
        
        System.out.println("Main thread continues...");
    }
}
```

**Natija:**
```
Thread 1 -> 1
Thread 1 -> 2
Thread 1 -> 3
Thread 1 -> 4
Thread 1 -> 5
Thread 2 -> 1
Thread 2 -> 2
Thread 2 -> 3
Thread 2 -> 4
Thread 2 -> 5
Main thread continues...
```

---

### Thread States (Thread Holatlari)

```
NEW -> RUNNABLE -> BLOCKED/WAITING/TIMED_WAITING -> TERMINATED
```

| State | Tavsifi |
|-------|---------|
| **NEW** | Thread yaratildi, lekin start() chaqirilmadi |
| **RUNNABLE** | Thread ishga tushdi, bajarilmoqda |
| **BLOCKED** | Monitor lock'ni kutmoqda |
| **WAITING** | Boshqa thread'ni kutmoqda |
| **TIMED_WAITING** | Vaqtli kutish (sleep, join with timeout) |
| **TERMINATED** | Thread tugadi |

```java
public class ThreadStateExample {
    public static void main(String[] args) throws InterruptedException {
        Thread thread = new Thread(() -> {
            try {
                Thread.sleep(2000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        });
        
        System.out.println("State after creation: " + thread.getState()); // NEW
        
        thread.start();
        System.out.println("State after start: " + thread.getState()); // RUNNABLE
        
        Thread.sleep(500);
        System.out.println("State during sleep: " + thread.getState()); // TIMED_WAITING
        
        thread.join();
        System.out.println("State after completion: " + thread.getState()); // TERMINATED
    }
}
```

---

### Thread Priority (Thread Ustuvorligi)

Thread'larga 1 dan 10 gacha priority berish mumkin:
- `Thread.MIN_PRIORITY` = 1
- `Thread.NORM_PRIORITY` = 5
- `Thread.MAX_PRIORITY` = 10

```java
public class PriorityExample {
    public static void main(String[] args) {
        Runnable task = () -> {
            for(int i = 1; i <= 5; i++) {
                System.out.println(Thread.currentThread().getName() + 
                                 " (priority=" + Thread.currentThread().getPriority() + 
                                 "): " + i);
            }
        };
        
        Thread lowThread = new Thread(task, "Low Priority");
        lowThread.setPriority(Thread.MIN_PRIORITY);
        
        Thread highThread = new Thread(task, "High Priority");
        highThread.setPriority(Thread.MAX_PRIORITY);
        
        lowThread.start();
        highThread.start();
    }
}
```

**Eslatma:** Priority faqat maslahat (hint) sifatida ishlaydi. Operatsion sistema har doim priority'ga amal qilmasligi mumkin.

---

### Daemon Thread'lar

Daemon thread'lar background'da ishlaydi va barcha user thread'lar tugagach, JVM tomonidan avtomatik to'xtatiladi.

```java
public class DaemonExample {
    public static void main(String[] args) {
        Thread daemonThread = new Thread(() -> {
            while(true) {
                System.out.println("Daemon thread is working...");
                try {
                    Thread.sleep(1000);
                } catch (InterruptedException e) {
                    break;
                }
            }
        });
        
        daemonThread.setDaemon(true); // Daemon qilish
        daemonThread.start();
        
        // Main thread bir oz uxlaydi
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }
        
        System.out.println("Main thread finished. Daemon will also stop.");
    }
}
```

---

## Amaliy Misol: Parallel Hisoblash

```java
import java.util.concurrent.atomic.AtomicLong;

public class ParallelSumExample {
    public static void main(String[] args) throws InterruptedException {
        // 1 dan 1000 gacha bo'lgan sonlar yig'indisini 4 ta thread da hisoblash
        int numberOfThreads = 4;
        int totalNumbers = 1000;
        int rangePerThread = totalNumbers / numberOfThreads;
        
        AtomicLong sum = new AtomicLong(0);
        Thread[] threads = new Thread[numberOfThreads];
        
        // Thread'lar yaratish
        for(int i = 0; i < numberOfThreads; i++) {
            final int start = i * rangePerThread + 1;
            final int end = (i == numberOfThreads - 1) ? totalNumbers : (i + 1) * rangePerThread;
            
            threads[i] = new Thread(() -> {
                long localSum = 0;
                for(int j = start; j <= end; j++) {
                    localSum += j;
                }
                sum.addAndGet(localSum);
                System.out.println(Thread.currentThread().getName() + 
                                 " computed sum from " + start + " to " + end + 
                                 " = " + localSum);
            }, "Thread-" + (i + 1));
            
            threads[i].start();
        }
        
        // Barcha thread'lar tugashini kutish
        for(Thread thread : threads) {
            thread.join();
        }
        
        System.out.println("Total sum from 1 to " + totalNumbers + " = " + sum.get());
        
        // Tekshirish: 1 dan n gacha sum = n*(n+1)/2
        long expectedSum = (long)totalNumbers * (totalNumbers + 1) / 2;
        System.out.println("Expected sum: " + expectedSum);
        System.out.println("Result is " + (sum.get() == expectedSum ? "correct" : "wrong"));
    }
}
```

---

## Xatolar va Ularni Oldini Olish

### 1. Race Condition (Musobaqa holati)
```java
// Xavfli - race condition
class Counter {
    private int count = 0;
    
    public void increment() {
        count++; // Thread-safe emas!
    }
}

// To'g'ri - synchronized
class SafeCounter {
    private int count = 0;
    
    public synchronized void increment() {
        count++; // Thread-safe
    }
}

// Atomic class'lar bilan
import java.util.concurrent.atomic.AtomicInteger;

class AtomicCounter {
    private AtomicInteger count = new AtomicInteger(0);
    
    public void increment() {
        count.incrementAndGet(); // Thread-safe
    }
}
```

### 2. Deadlock (Blokirovka)

```java
//  Deadlock muammosi
class DeadlockExample {
    private final Object lock1 = new Object();
    private final Object lock2 = new Object();
    
    public void method1() {
        synchronized(lock1) {
            synchronized(lock2) {
                // code
            }
        }
    }
    
    public void method2() {
        synchronized(lock2) {
            synchronized(lock1) { // Teskari tartib - deadlock!
                // code
            }
        }
    }
}
```

### 3. ThreadPool ishlatish (Resurs tejamkorligi)
```java
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

//  Yaxshi - ThreadPool bilan
ExecutorService executor = Executors.newFixedThreadPool(5);

for(int i = 0; i < 100; i++) {
    final int taskId = i;
    executor.submit(() -> {
        System.out.println("Task " + taskId + " executed by " + 
                         Thread.currentThread().getName());
    });
}

executor.shutdown();
```

---

## Tekshiruv Savollari

1. **Thread va Process farqi nima?**
2. **MultiTasking va MultiThreading farqi nima?**
3. **Thread yaratishning qanday usullari bor?**
4. **Nima uchun Runnable Thread'dan afzal?**
5. **join() metodi nima qiladi?**
6. **Daemon thread nima va qachon ishlatiladi?**
7. **Thread'larning qanday holatlari (states) bor?**

---

## Xulosa

MultiThreading - bu zamonaviy dasturlashda muhim tushuncha bo'lib, u:

- CPU dan samarali foydalanish imkonini beradi
- Responsive ilovalar yaratishga yordam beradi
- Parallel hisoblashlarni amalga oshiradi
- Resurslardan unumli foydalanadi

**Eslatma:** Thread'lar bilan ishlashda ehtiyot bo'lish kerak - race condition, deadlock kabi muammolar dasturni ishdan chiqarishi mumkin.

---

**Keyingi mavzu:** [Thread Synchronization](./02-java-synchronization.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
