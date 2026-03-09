# 05 - Fork-Join Framework va Asinxron Dasturlash

## 5.1 - Fork-Join Framework

### Fork-Join Framework nima?

**Fork-Join Framework** - bu `ExecutorService` interfeysining implementatsiyasi bo'lib, ko'p protsessorli tizimlardan samarali foydalanish imkonini beradi. Bu framework ishni rekursiv ravishda kichik bo'laklarga bo'lib, parallel bajarish uchun mo'ljallangan.

```
Fork (Bo'lish) jarayoni:
         Task
      /    |    \
     /     |     \
SubTask SubTask SubTask
    \     |     /
     \    |    /
      Join (Birlashtirish)
         |
    Final Result
```

### Nima uchun Fork-Join qo'shilgan?

1. **Ko'p yadroli protsessorlardan samarali foydalanish**
2. **Rekursiv parallel algoritmlarni oson implementatsiya qilish**
3. **Work-stealing algoritmi orqali load balancing**

### ForkJoinPool

**ForkJoinPool** - Fork-Join framework'ining thread pool implementatsiyasi.

```java
import java.util.concurrent.ForkJoinPool;

public class ForkJoinPoolExample {
    public static void main(String[] args) {
        // 1. Default pool - availableProcessors() ga teng
        ForkJoinPool commonPool = ForkJoinPool.commonPool();
        System.out.println("Common pool parallelism: " + commonPool.getParallelism());
        
        // 2. Custom pool
        ForkJoinPool customPool = new ForkJoinPool(4); // 4 ta thread
        System.out.println("Custom pool parallelism: " + customPool.getParallelism());
        
        // 3. Pool ma'lumotlari
        System.out.println("Pool size: " + customPool.getPoolSize());
        System.out.println("Active threads: " + customPool.getActiveThreadCount());
        System.out.println("Steal count: " + customPool.getStealCount());
    }
}
```

### Work-Stealing Algorithm

**Work-Stealing** - Fork-Join framework'ining asosiy xususiyati. Har bir worker thread o'zining double-ended queue'siga (deque) ega. Agar bir thread'ning queue'si bo'shab qolsa, u boshqa busy thread'lardan task "o'g'irlaydi".

```
Thread 1 Queue: [Task1, Task2, Task3] <- busy
Thread 2 Queue: [] <- idle, steals from Thread 1
Thread 3 Queue: [Task4, Task5] <- busy
```

### RecursiveAction - Natija qaytarmaydigan task

```java
import java.util.concurrent.RecursiveAction;
import java.util.concurrent.ForkJoinPool;

public class RecursiveActionExample {
    
    // Massiv elementlarini parallel ravishda ikkilantirish
    static class DoubleArrayAction extends RecursiveAction {
        private static final int THRESHOLD = 1000; // Bo'linish chegarasi
        private final double[] array;
        private final int start;
        private final int end;
        
        public DoubleArrayAction(double[] array, int start, int end) {
            this.array = array;
            this.start = start;
            this.end = end;
        }
        
        @Override
        protected void compute() {
            if (end - start <= THRESHOLD) {
                // To'g'ridan-to'g'ri bajarish
                for (int i = start; i < end; i++) {
                    array[i] *= 2;
                }
            } else {
                // Bo'lish
                int mid = (start + end) / 2;
                DoubleArrayAction left = new DoubleArrayAction(array, start, mid);
                DoubleArrayAction right = new DoubleArrayAction(array, mid, end);
                
                // Ikkala subtaskni fork qilish
                left.fork();
                right.fork();
                
                // Subtasklar tugashini kutish
                left.join();
                right.join();
            }
        }
    }
    
    public static void main(String[] args) {
        double[] array = new double[10_000];
        for (int i = 0; i < array.length; i++) {
            array[i] = i;
        }
        
        ForkJoinPool pool = new ForkJoinPool();
        DoubleArrayAction task = new DoubleArrayAction(array, 0, array.length);
        
        long start = System.currentTimeMillis();
        pool.invoke(task);
        long end = System.currentTimeMillis();
        
        System.out.println("Time: " + (end - start) + "ms");
        System.out.println("First element: " + array[0]);
        System.out.println("Last element: " + array[array.length - 1]);
    }
}
```

### RecursiveTask - Natija qaytaradigan task

```java
import java.util.concurrent.RecursiveTask;
import java.util.concurrent.ForkJoinPool;

public class RecursiveTaskExample {
    
    // Massiv yig'indisini parallel hisoblash
    static class SumTask extends RecursiveTask<Long> {
        private static final int THRESHOLD = 1000;
        private final int[] array;
        private final int start;
        private final int end;
        
        public SumTask(int[] array, int start, int end) {
            this.array = array;
            this.start = start;
            this.end = end;
        }
        
        @Override
        protected Long compute() {
            if (end - start <= THRESHOLD) {
                // To'g'ridan-to'g'ri hisoblash
                long sum = 0;
                for (int i = start; i < end; i++) {
                    sum += array[i];
                }
                return sum;
            } else {
                // Bo'lish
                int mid = (start + end) / 2;
                SumTask leftTask = new SumTask(array, start, mid);
                SumTask rightTask = new SumTask(array, mid, end);
                
                // Subtasklarni fork qilish
                leftTask.fork();
                rightTask.fork();
                
                // Natijalarni yig'ish
                long leftResult = leftTask.join();
                long rightResult = rightTask.join();
                
                return leftResult + rightResult;
            }
        }
    }
    
    public static void main(String[] args) {
        int[] array = new int[10_000];
        for (int i = 0; i < array.length; i++) {
            array[i] = i + 1;
        }
        
        ForkJoinPool pool = new ForkJoinPool();
        SumTask task = new SumTask(array, 0, array.length);
        
        long start = System.currentTimeMillis();
        long result = pool.invoke(task);
        long end = System.currentTimeMillis();
        
        System.out.println("Sum: " + result);
        System.out.println("Expected: " + (array.length * (array.length + 1L) / 2));
        System.out.println("Time: " + (end - start) + "ms");
    }
}
```

### Fork-Join vs Executor Framework

| Executor Framework | Fork-Join Framework |
|--------------------|---------------------|
| Fixed thread pool | Work-stealing thread pool |
| Tasklar queue'da navbatda turadi | Har bir thread o'z deque'iga ega |
| Load balancing yo'q | Avtomatik load balancing |
| Rekursiv tasklar uchun qulay emas | Rekursiv tasklar uchun ideal |
| `ExecutorService` | `ForkJoinPool` |

### Amaliy misol: Fibonacci

```java
import java.util.concurrent.ForkJoinPool;
import java.util.concurrent.RecursiveTask;

public class FibonacciExample {
    
    static class FibonacciTask extends RecursiveTask<Integer> {
        private final int n;
        
        public FibonacciTask(int n) {
            this.n = n;
        }
        
        @Override
        protected Integer compute() {
            if (n <= 1) {
                return n;
            }
            
            FibonacciTask f1 = new FibonacciTask(n - 1);
            f1.fork(); // Parallel bajarish
            
            FibonacciTask f2 = new FibonacciTask(n - 2);
            int result2 = f2.compute(); // Shu thread'da bajarish
            
            int result1 = f1.join(); // f1 tugashini kutish
            
            return result1 + result2;
        }
    }
    
    public static void main(String[] args) {
        ForkJoinPool pool = new ForkJoinPool();
        
        for (int i = 0; i <= 10; i++) {
            int n = i;
            FibonacciTask task = new FibonacciTask(n);
            int result = pool.invoke(task);
            System.out.println("fib(" + n + ") = " + result);
        }
    }
}
```

---

## 5.2 - Asynchronous Computations (Asinxron Hisoblashlar)

### Asynchronous Programming nima?

**Asynchronous programming** - bu asosiy thread'ni blocklamasdan, tasklarni alohida thread'larda bajarish usuli. Task tugagach, asosiy thread'ga xabar beriladi.

```java
// ❌ Synchronous (sinxron) - blocking
public String fetchData() {
    String data = httpClient.get("api.example.com/data"); // Blocking call
    return process(data); // Keyingi qatorga o'tmaydi
}

// ✅ Asynchronous (asinxron) - non-blocking
public CompletableFuture<String> fetchDataAsync() {
    return CompletableFuture.supplyAsync(() -> {
        return httpClient.get("api.example.com/data");
    }).thenApply(data -> process(data));
}
```

### CompletableFuture nima?

**CompletableFuture** - Java 8 da qo'shilgan, Future API'sining kengaytmasi. Asinxron programming uchun kuchli imkoniyatlar beradi.

```java
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

public class CompletableFutureExample {
    public static void main(String[] args) throws Exception {
        
        // 1. Oddiy CompletableFuture yaratish
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {}
            return "Hello";
        });
        
        System.out.println("Doing other work...");
        System.out.println("Result: " + future.get()); // Blocking
        
        // 2. completedFuture - tayyor natija
        CompletableFuture<String> completed = CompletableFuture.completedFuture("Done");
        System.out.println(completed.get()); // Block qilmaydi
        
        // 3. runAsync - Runnable task
        CompletableFuture<Void> runFuture = CompletableFuture.runAsync(() -> {
            System.out.println("Running in: " + Thread.currentThread().getName());
        });
        
        // 4. supplyAsync - Supplier task (natija qaytaradi)
        CompletableFuture<Integer> supplyFuture = CompletableFuture.supplyAsync(() -> {
            return 42;
        });
        
        System.out.println("Answer: " + supplyFuture.get());
    }
}
```

### Future vs CompletableFuture

| Future | CompletableFuture |
|--------|-------------------|
| Faqat `get()` orqali natija olish | Ko'p transformation metodlar |
| Manual completion mumkin emas | `complete()` orqali manual completion |
| Chaining qilish mumkin emas | `thenApply`, `thenCompose` orqali chaining |
| Exception handling yo'q | `exceptionally`, `handle` metodlari |
| Combine qilish mumkin emas | `thenCombine`, `allOf`, `anyOf` |

```java
// Future bilan - cheklangan
ExecutorService executor = Executors.newFixedThreadPool(2);
Future<Integer> future1 = executor.submit(() -> 10);
Future<Integer> future2 = executor.submit(() -> 20);

Integer result1 = future1.get(); // Block
Integer result2 = future2.get(); // Block
int sum = result1 + result2;

// CompletableFuture bilan - chaining va combine
CompletableFuture<Integer> cf1 = CompletableFuture.supplyAsync(() -> 10);
CompletableFuture<Integer> cf2 = CompletableFuture.supplyAsync(() -> 20);

CompletableFuture<Integer> sumFuture = cf1.thenCombine(cf2, Integer::sum);
System.out.println("Sum: " + sumFuture.get()); // 30
```

### Transforming va Acting (thenApply, thenAccept, thenRun)

```java
public class TransformingExample {
    public static void main(String[] args) throws Exception {
        
        // 1. thenApply - transform qilish (Function)
        CompletableFuture<String> future = CompletableFuture
            .supplyAsync(() -> "Hello")
            .thenApply(s -> s + " World")
            .thenApply(String::toUpperCase);
        
        System.out.println(future.get()); // HELLO WORLD
        
        // 2. thenAccept - Consumer (natijani iste'mol qilish)
        CompletableFuture.supplyAsync(() -> "Data")
            .thenAccept(result -> System.out.println("Received: " + result))
            .get(); // Void qaytaradi
        
        // 3. thenRun - Runnable (natijaga bog'liq emas)
        CompletableFuture.supplyAsync(() -> {
            return "Processed";
        }).thenRun(() -> {
            System.out.println("Task completed!");
        }).get();
        
        // 4. thenApplyAsync - boshqa thread'da bajarish
        CompletableFuture.supplyAsync(() -> {
            System.out.println("Stage 1: " + Thread.currentThread().getName());
            return 10;
        }).thenApplyAsync(result -> {
            System.out.println("Stage 2: " + Thread.currentThread().getName());
            return result * 2;
        }).thenAccept(result -> {
            System.out.println("Result: " + result);
        }).get();
    }
}
```

### Combining CompletableFutures

```java
public class CombiningExample {
    public static void main(String[] args) throws Exception {
        
        // 1. thenCompose - flatMap (bir future ikkinchisiga bog'liq)
        CompletableFuture<String> future = CompletableFuture
            .supplyAsync(() -> "User")
            .thenCompose(user -> getUserDetails(user));
        
        System.out.println("User details: " + future.get());
        
        // 2. thenCombine - ikkala future tugagach combine qilish
        CompletableFuture<Integer> price = CompletableFuture.supplyAsync(() -> 100);
        CompletableFuture<Integer> tax = CompletableFuture.supplyAsync(() -> 20);
        
        CompletableFuture<Integer> total = price
            .thenCombine(tax, (p, t) -> p + t);
        
        System.out.println("Total: " + total.get()); // 120
        
        // 3. allOf - barcha future'lar tugashini kutish
        CompletableFuture<String> f1 = CompletableFuture.supplyAsync(() -> {
            sleep(1000); return "Task 1";
        });
        CompletableFuture<String> f2 = CompletableFuture.supplyAsync(() -> {
            sleep(2000); return "Task 2";
        });
        CompletableFuture<String> f3 = CompletableFuture.supplyAsync(() -> {
            sleep(1500); return "Task 3";
        });
        
        CompletableFuture<Void> allFutures = CompletableFuture.allOf(f1, f2, f3);
        allFutures.get(); // Hammasi tugashini kutish
        
        System.out.println("All tasks completed");
        System.out.println(f1.get() + ", " + f2.get() + ", " + f3.get());
        
        // 4. anyOf - birinchi tugagan future natijasi
        CompletableFuture<Object> firstCompleted = CompletableFuture.anyOf(f1, f2, f3);
        System.out.println("First completed: " + firstCompleted.get());
    }
    
    private static CompletableFuture<String> getUserDetails(String user) {
        return CompletableFuture.supplyAsync(() -> {
            return user + " details from database";
        });
    }
    
    private static void sleep(int millis) {
        try { Thread.sleep(millis); } catch (InterruptedException e) {}
    }
}
```

### Exception Handling

```java
public class ExceptionHandlingExample {
    public static void main(String[] args) {
        
        // 1. exceptionally - xatolik yuz berganda
        CompletableFuture<Integer> future = CompletableFuture
            .supplyAsync(() -> {
                if (Math.random() > 0.5) {
                    throw new RuntimeException("Something went wrong");
                }
                return 100;
            })
            .exceptionally(ex -> {
                System.out.println("Error: " + ex.getMessage());
                return 0; // Default value
            });
        
        System.out.println("Result: " + future.join()); // 100 yoki 0
        
        // 2. handle - success va failure ikkalasida ham ishlaydi
        CompletableFuture<Integer> handled = CompletableFuture
            .supplyAsync(() -> {
                return 50;
            })
            .handle((result, ex) -> {
                if (ex != null) {
                    System.out.println("Error occurred");
                    return -1;
                }
                return result * 2;
            });
        
        System.out.println("Handled: " + handled.join()); // 100
        
        // 3. whenComplete - side effect uchun
        CompletableFuture.supplyAsync(() -> "Data")
            .whenComplete((result, ex) -> {
                if (ex == null) {
                    System.out.println("Success: " + result);
                } else {
                    System.out.println("Failed: " + ex.getMessage());
                }
            })
            .join();
    }
}
```

### Real-world misol: Web API chaqiruvlari

```java
import java.util.concurrent.CompletableFuture;
import java.util.concurrent.TimeUnit;

public class AsyncWebApiExample {
    
    static class User {
        int id;
        String name;
        public User(int id, String name) { this.id = id; this.name = name; }
    }
    
    static class Order {
        int userId;
        double amount;
        public Order(int userId, double amount) { this.userId = userId; this.amount = amount; }
    }
    
    static class Product {
        String name;
        double price;
        public Product(String name, double price) { this.name = name; this.price = price; }
    }
    
    public static void main(String[] args) {
        
        // Asinxron API chaqiruvlari
        CompletableFuture<User> userFuture = getUserAsync(1);
        CompletableFuture<Order> orderFuture = getOrderAsync(1);
        CompletableFuture<Product> productFuture = getProductAsync(101);
        
        // Barcha ma'lumotlarni parallel yig'ish
        CompletableFuture<String> dashboard = CompletableFuture
            .allOf(userFuture, orderFuture, productFuture)
            .thenApply(v -> {
                try {
                    User user = userFuture.get();
                    Order order = orderFuture.get();
                    Product product = productFuture.get();
                    
                    return String.format(
                        "User: %s, Order: $%.2f, Product: %s ($%.2f)",
                        user.name, order.amount, product.name, product.price
                    );
                } catch (Exception e) {
                    return "Error loading dashboard";
                }
            });
        
        // Timeout bilan
        CompletableFuture<String> withTimeout = dashboard
            .orTimeout(3, TimeUnit.SECONDS)
            .exceptionally(ex -> "Dashboard loading timed out");
        
        System.out.println(withTimeout.join());
    }
    
    private static CompletableFuture<User> getUserAsync(int userId) {
        return CompletableFuture.supplyAsync(() -> {
            sleep(1000);
            return new User(userId, "John Doe");
        });
    }
    
    private static CompletableFuture<Order> getOrderAsync(int userId) {
        return CompletableFuture.supplyAsync(() -> {
            sleep(1500);
            return new Order(userId, 250.50);
        });
    }
    
    private static CompletableFuture<Product> getProductAsync(int productId) {
        return CompletableFuture.supplyAsync(() -> {
            sleep(1200);
            return new Product("Laptop", 999.99);
        });
    }
    
    private static void sleep(int millis) {
        try { Thread.sleep(millis); } catch (InterruptedException e) {}
    }
}
```

---

## 5.3 - Singleton Pattern va MultiThreading

### Singleton Design Pattern nima?

**Singleton** - bu class'ning faqat bitta instance'i bo'lishini ta'minlaydigan design pattern.

```java
// Oddiy Singleton (Thread-safe emas!)
public class SimpleSingleton {
    private static SimpleSingleton instance;
    
    private SimpleSingleton() {} // Private constructor
    
    public static SimpleSingleton getInstance() {
        if (instance == null) {
            instance = new SimpleSingleton(); // Race condition!
        }
        return instance;
    }
}
```

### MultiThreading muammosi

```java
public class SingletonProblem {
    
    static class LazySingleton {
        private static LazySingleton instance;
        
        private LazySingleton() {
            System.out.println("Creating instance in: " + Thread.currentThread().getName());
        }
        
        public static LazySingleton getInstance() {
            if (instance == null) {
                // Race condition - bir nechta thread bir vaqtda kelsa
                instance = new LazySingleton();
            }
            return instance;
        }
    }
    
    public static void main(String[] args) {
        // Bir nechta thread yaratish
        for (int i = 0; i < 10; i++) {
            new Thread(() -> {
                LazySingleton singleton = LazySingleton.getInstance();
            }).start();
        }
        // Natija: Bir nechta instance yaratilishi mumkin!
    }
}
```

### Yechim 1: synchronized metod

```java
class SynchronizedSingleton {
    private static SynchronizedSingleton instance;
    
    private SynchronizedSingleton() {}
    
    // Thread-safe, lekin performance past
    public static synchronized SynchronizedSingleton getInstance() {
        if (instance == null) {
            instance = new SynchronizedSingleton();
        }
        return instance;
    }
}
```

### Yechim 2: Double-Checked Locking

```java
class DoubleCheckedSingleton {
    // volatile - visibility guarantee
    private static volatile DoubleCheckedSingleton instance;
    
    private DoubleCheckedSingleton() {}
    
    public static DoubleCheckedSingleton getInstance() {
        if (instance == null) { // First check (no locking)
            synchronized (DoubleCheckedSingleton.class) {
                if (instance == null) { // Second check (with locking)
                    instance = new DoubleCheckedSingleton();
                }
            }
        }
        return instance;
    }
}
```

### Yechim 3: Eager Initialization

```java
class EagerSingleton {
    // Class loading vaqtida yaratiladi
    private static final EagerSingleton INSTANCE = new EagerSingleton();
    
    private EagerSingleton() {}
    
    public static EagerSingleton getInstance() {
        return INSTANCE;
    }
}
// Thread-safe, lekin lazy initialization emas
```

### Yechim 4: Static Inner Class (Bill Pugh)

```java
class BillPughSingleton {
    
    private BillPughSingleton() {}
    
    // Static inner class - getInstance() chaqirilganda yuklanadi
    private static class SingletonHelper {
        private static final BillPughSingleton INSTANCE = new BillPughSingleton();
    }
    
    public static BillPughSingleton getInstance() {
        return SingletonHelper.INSTANCE;
    }
}
// Thread-safe, lazy, performance yaxshi
```

### Yechim 5: Enum Singleton

```java
enum EnumSingleton {
    INSTANCE;
    
    private String data;
    
    public String getData() {
        return data;
    }
    
    public void setData(String data) {
        this.data = data;
    }
    
    public void doSomething() {
        System.out.println("Doing something in enum singleton");
    }
}

// Foydalanish
public class EnumSingletonExample {
    public static void main(String[] args) {
        EnumSingleton singleton = EnumSingleton.INSTANCE;
        singleton.setData("My data");
        singleton.doSomething();
        
        // Serialization-safe, reflection-safe
    }
}
```

### Singleton implementatsiyalarini solishtirish

| Usul | Thread-Safe | Lazy | Performance | Reflection Safe |
|------|-------------|------|-------------|-----------------|
| Simple Singleton | ❌ | ✅ | Yaxshi | ❌ |
| Synchronized Method | ✅ | ✅ | Past | ❌ |
| Double-Checked Locking | ✅ | ✅ | Yaxshi | ❌ |
| Eager Initialization | ✅ | ❌ | Yaxshi | ❌ |
| Bill Pugh (Static Inner) | ✅ | ✅ | Eng yaxshi | ❌ |
| Enum | ✅ | ❌ | Yaxshi | ✅ |

### Reflection va Serialization muammolari

```java
import java.lang.reflect.Constructor;

public class ReflectionAttack {
    public static void main(String[] args) throws Exception {
        BillPughSingleton instance1 = BillPughSingleton.getInstance();
        
        // Reflection orqali private constructor'ni chaqirish
        Constructor<BillPughSingleton> constructor = 
            BillPughSingleton.class.getDeclaredConstructor();
        constructor.setAccessible(true);
        BillPughSingleton instance2 = constructor.newInstance();
        
        System.out.println(instance1 == instance2); // false! Yangi instance
        
        // Enum bilan bu mumkin emas
        EnumSingleton enum1 = EnumSingleton.INSTANCE;
        Constructor<EnumSingleton> enumConst = 
            EnumSingleton.class.getDeclaredConstructor(String.class, int.class);
        enumConst.setAccessible(true);
        // EnumSingleton enum2 = enumConst.newInstance("FAKE", 2); // Exception!
    }
}
```

---

## Tekshiruv Savollari

### Lesson 5.1 - Fork Join Pool
1. **Fork Join Framework nima?**
2. **Fork Join Framework nima uchun javaga qo'shilgan?**
3. **Fork Join Frameworkni afzalliklari?**
4. **Fork Join Frameworkni tasklari o'chirtga qo'yish uchun qaysi queuedan foydalanadi?**
5. **Fork Join Framework va Executor Framework o'rtasidagi farq?**

### Lesson 5.2 - Asynchronous Computations
1. **Asynchronous programming nima?**
2. **CompletableFuture nima?**
3. **CompletableFuture nima uchun ishlatiladi?**
4. **CompletableFuture va Future o'rtasidagi farq?**
5. **CompletableFuture thenApply() method nima uchun ishlatiladi?**
6. **CompletableFuture thenCompose() method nima uchun ishlatiladi?**

### Lesson 5.3 - Singleton Design Pattern Issue with Multithreading
1. **Singleton Design Pattern nima?**
2. **Singleton pattern'da qanday multi-threading muammolari bor?**
3. **Double-checked locking nima va u qanday ishlaydi?**
4. **Enum singleton nima uchun eng xavfsiz usul hisoblanadi?**

---

**Keyingi mavzu:** [Concurrent Utilities](./06%20-%20Date%20and%20Time%20API.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
