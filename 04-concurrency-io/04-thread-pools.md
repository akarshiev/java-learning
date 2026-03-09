# 04 - Tasks and Thread Pools (Vazifalar va Thread Havzalari)

## 4.1 - Thread Pools (Thread Havzalari)

### Thread Pools nima?

**Thread Pool** - bu oldindan yaratilgan va ishga tayyor thread'lar to'plami. Yangi thread yaratish operatsion sistema bilan bog'lanishni talab qilgani uchun nisbatan qimmat operatsiya hisoblanadi.

```java
//  Yomon: Har bir task uchun yangi thread
for (int i = 0; i < 1000; i++) {
    new Thread(() -> {
        // task
    }).start(); // 1000 ta thread - resurslar yetmay qolishi mumkin!
}

//  Yaxshi: Thread Pool bilan
ExecutorService executor = Executors.newFixedThreadPool(10);
for (int i = 0; i < 1000; i++) {
    executor.submit(() -> {
        // task
    });
}
```

**Nima uchun Thread Pool kerak?**
- Thread yaratish qimmat operatsiya
- Thread'larni qayta ishlatish imkoniyati
- Thread'lar sonini cheklash (resource management)
- Performance va scalability

### Executor Framework

**Executor Framework** - worker thread'larni samarali boshqarish uchun komponentlar to'plami. Producer-Consumer pattern'ining implementatsiyasi (Java 5+).

```java
// Executor Framework arxitekturasi
public interface Executor {
    void execute(Runnable command);
}

public interface ExecutorService extends Executor {
    // Lifecycle management
    void shutdown();
    List<Runnable> shutdownNow();
    boolean isShutdown();
    boolean isTerminated();
    
    // Submit tasks
    <T> Future<T> submit(Callable<T> task);
    Future<?> submit(Runnable task);
    
    // Batch operations
    <T> List<Future<T>> invokeAll(Collection<? extends Callable<T>> tasks);
    <T> T invokeAny(Collection<? extends Callable<T>> tasks);
}

public interface ScheduledExecutorService extends ExecutorService {
    ScheduledFuture<?> schedule(Runnable command, long delay, TimeUnit unit);
    ScheduledFuture<?> scheduleAtFixedRate(Runnable command, long initialDelay, long period, TimeUnit unit);
}
```

### Executor Turlari

#### 1. newSingleThreadExecutor()
```java
ExecutorService singleExecutor = Executors.newSingleThreadExecutor();

// Bitta thread, tasks navbat bilan bajariladi
for (int i = 0; i < 5; i++) {
    int taskId = i;
    singleExecutor.submit(() -> {
        System.out.println("Task " + taskId + " by " + Thread.currentThread().getName());
        try { Thread.sleep(1000); } catch (InterruptedException e) {}
    });
}
singleExecutor.shutdown();
```

**Xususiyatlari:**
- Faqat bitta thread
- Unbounded queue (cheklanmagan navbat)
- Tasks sequential bajariladi
- Thread o'lsa, yangisi yaratiladi

#### 2. newFixedThreadPool(int nThreads)
```java
ExecutorService fixedExecutor = Executors.newFixedThreadPool(3); // 3 ta thread

// Maksimum 3 ta thread, qolganlari queue'da
for (int i = 0; i < 10; i++) {
    int taskId = i;
    fixedExecutor.submit(() -> {
        System.out.println("Task " + taskId + " started by " + Thread.currentThread().getName());
        try { Thread.sleep(2000); } catch (InterruptedException e) {}
        System.out.println("Task " + taskId + " finished");
    });
}
fixedExecutor.shutdown();
```

**Xususiyatlari:**
- Fixlangan sonli thread'lar
- Unbounded queue
- Thread'lar doim active
- Thread o'lsa, yangisi yaratiladi

#### 3. newCachedThreadPool()
```java
ExecutorService cachedExecutor = Executors.newCachedThreadPool();

// Kerak bo'lganda yangi thread yaratadi
for (int i = 0; i < 100; i++) {
    cachedExecutor.submit(() -> {
        System.out.println("Task by " + Thread.currentThread().getName());
    });
}
cachedExecutor.shutdown();
```

**Xususiyatlari:**
- Dynamic thread creation
- 60 soniya ishlatilmasa thread'lar o'chadi
- Sistem resurslari yetguncha thread yaratadi
- Short-lived tasks uchun ideal

#### 4. Scheduled Executor'lar
```java
ScheduledExecutorService scheduledExecutor = Executors.newSingleThreadScheduledExecutor();

// 1. schedule - bir marta kechiktirib bajarish
scheduledExecutor.schedule(() -> {
    System.out.println("Executed after 3 seconds");
}, 3, TimeUnit.SECONDS);

// 2. scheduleAtFixedRate - fixed rate da bajarish
scheduledExecutor.scheduleAtFixedRate(() -> {
    System.out.println("Executed every 2 seconds");
}, 0, 2, TimeUnit.SECONDS);

// 3. scheduleWithFixedDelay - fixed delay da bajarish
scheduledExecutor.scheduleWithFixedDelay(() -> {
    System.out.println("Executed with 1 second delay after previous");
}, 0, 1, TimeUnit.SECONDS);
```

**Farqlar:**
- `scheduleAtFixedRate` - task boshlanish vaqtlari orasidagi interval
- `scheduleWithFixedDelay` - task tugashi va keyingi boshlanishi orasidagi delay

#### 5. newWorkStealingPool() (Java 8+)
```java
// Work-stealing thread pool
ExecutorService workStealingExecutor = Executors.newWorkStealingPool();

// Parallelism level = available processors
ForkJoinPool forkJoinPool = (ForkJoinPool) workStealingExecutor;

// Yoki specific parallelism level
ExecutorService customParallel = Executors.newWorkStealingPool(4);
```

**Xususiyatlari:**
- Work-stealing algoritmi
- ForkJoinPool asosida
- Parallelism level specifikatsiya qilish mumkin
- CPU intensive tasks uchun ideal

### Executor'larni o'chirish

```java
ExecutorService executor = Executors.newFixedThreadPool(5);

// Submit some tasks
for (int i = 0; i < 20; i++) {
    executor.submit(() -> {
        try { Thread.sleep(1000); } catch (InterruptedException e) {}
    });
}

// 1. shutdown() - orderly shutdown
executor.shutdown(); // Yangi tasklar qabul qilinmaydi
// executor.submit(() -> {}); // RejectedExecutionException!

// 2. awaitTermination() - tugashini kutish
try {
    if (!executor.awaitTermination(5, TimeUnit.SECONDS)) {
        // 3. shutdownNow() - force shutdown
        List<Runnable> notExecuted = executor.shutdownNow();
        System.out.println(notExecuted.size() + " tasks were not executed");
    }
} catch (InterruptedException e) {
    executor.shutdownNow();
}
```

**Shutdown metodlari:**
- `shutdown()` - Yumshoq o'chirish, boshlangan tasklar tugaydi
- `shutdownNow()` - Qattiq o'chirish, interrupt qiladi
- `awaitTermination()` - Bloklanib, tugashini kutadi

---

## 4.2 - Callable and Future

### Callable nima?

**Callable** - natija qaytaradigan va exception tashlashi mumkin bo'lgan task. Runnable'ga o'xshash, lekin:
- `call()` metodi natija qaytaradi
- Checked exception tashlashi mumkin

```java
// Callable interface
@FunctionalInterface
public interface Callable<V> {
    V call() throws Exception;
}

// Misol
Callable<Integer> factorialTask = new Callable<Integer>() {
    @Override
    public Integer call() throws Exception {
        int n = 5;
        int result = 1;
        for (int i = 1; i <= n; i++) {
            result *= i;
            Thread.sleep(100);
        }
        return result;
    }
};

// Lambda bilan
Callable<Integer> factorialLambda = () -> {
    int n = 5;
    int result = 1;
    for (int i = 1; i <= n; i++) {
        result *= i;
        Thread.sleep(100);
    }
    return result;
};
```

### Runnable va Callable farqi

| Runnable | Callable |
|----------|----------|
| `void run()` | `V call()` |
| Natija qaytarmaydi | Natija qaytaradi |
| Checked exception tashlay olmaydi | Checked exception tashlay oladi |
| Thread'ga berish mumkin | Faqat ExecutorService ga |

```java
// Runnable - natija yo'q
Runnable runnable = () -> {
    System.out.println("Working...");
    // throw new IOException(); // COMPILE ERROR!
};

// Callable - natija bor
Callable<String> callable = () -> {
    if (Math.random() > 0.5) {
        throw new IOException("Random error");
    }
    return "Success";
};
```

### Future nima?

**Future** - asinxron hisoblash natijasini ifodalaydi. Task tugashini tekshirish, natijani olish va taskni cancel qilish imkonini beradi.

```java
ExecutorService executor = Executors.newSingleThreadExecutor();

// Submit Callable -> Future qaytaradi
Future<Integer> future = executor.submit(() -> {
    Thread.sleep(2000);
    return 42;
});

// Future metodlari
System.out.println("Task done? " + future.isDone()); // false

// get() - bloklanadi va natijani qaytaradi
try {
    Integer result = future.get(); // 2 soniya block
    System.out.println("Result: " + result);
} catch (InterruptedException | ExecutionException e) {
    e.printStackTrace();
}

// get with timeout
try {
    Integer result = future.get(1, TimeUnit.SECONDS); // 1 soniyada kelmasa TimeoutException
} catch (TimeoutException e) {
    System.out.println("Task took too long");
    future.cancel(true); // cancel qilish
}

executor.shutdown();
```

### Future metodlari

```java
ExecutorService executor = Executors.newCachedThreadPool();

// 1. isDone() - task tugaganligini tekshirish
Future<String> future1 = executor.submit(() -> {
    Thread.sleep(1000);
    return "Done";
});

while (!future1.isDone()) {
    System.out.println("Waiting...");
    Thread.sleep(200);
}
System.out.println("Task completed: " + future1.get());

// 2. cancel() - taskni bekor qilish
Future<Integer> future2 = executor.submit(() -> {
    for (int i = 0; i < 10; i++) {
        if (Thread.currentThread().isInterrupted()) {
            System.out.println("Interrupted!");
            return -1;
        }
        Thread.sleep(1000);
        System.out.println("Processing " + i);
    }
    return 100;
});

Thread.sleep(3000);
boolean cancelled = future2.cancel(true); // mayInterruptIfRunning = true
System.out.println("Cancelled: " + cancelled);
System.out.println("isCancelled: " + future2.isCancelled());

// 3. invokeAll - bir nechta tasklarni bajarish
List<Callable<Integer>> callables = Arrays.asList(
    () -> { Thread.sleep(1000); return 1; },
    () -> { Thread.sleep(2000); return 2; },
    () -> { Thread.sleep(3000); return 3; }
);

List<Future<Integer>> futures = executor.invokeAll(callables);
for (Future<Integer> f : futures) {
    System.out.println(f.get()); // Eng sekin task tugaguncha block
}

// 4. invokeAny - birinchi tugagan task natijasini qaytaradi
Integer firstResult = executor.invokeAny(callables);
System.out.println("First result: " + firstResult);

executor.shutdown();
```

### FutureTask

**FutureTask** - Runnable va Future ni birlashtirgan class. Runnable sifatida submit qilish va Future sifatida natija olish mumkin.

```java
public class FutureTaskExample {
    public static void main(String[] args) throws Exception {
        // 1. Callable yaratish
        Callable<Integer> callable = () -> {
            Thread.sleep(2000);
            return 42;
        };
        
        // 2. FutureTask yaratish
        FutureTask<Integer> futureTask = new FutureTask<>(callable);
        
        // 3. Thread orqali ishga tushirish
        Thread thread = new Thread(futureTask);
        thread.start();
        
        // 4. ExecutorService orqali ishga tushirish
        ExecutorService executor = Executors.newSingleThreadExecutor();
        executor.submit(futureTask); // FutureTask Runnable ham implement qiladi
        
        // 5. Natijani olish
        System.out.println("Result: " + futureTask.get());
        
        executor.shutdown();
    }
}
```

### CompletableFuture (Java 8+)

`CompletableFuture` - Future ning kengaytirilgan varianti, functional programming uslubida ishlash imkonini beradi.

```java
import java.util.concurrent.CompletableFuture;

public class CompletableFutureExample {
    public static void main(String[] args) throws Exception {
        // 1. Async task yaratish
        CompletableFuture<String> future = CompletableFuture.supplyAsync(() -> {
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {}
            return "Hello";
        });
        
        // 2. Chain operations
        CompletableFuture<String> result = future
            .thenApply(s -> s + " World")
            .thenApply(String::toUpperCase)
            .thenCombine(
                CompletableFuture.supplyAsync(() -> "!!!"),
                (s1, s2) -> s1 + s2
            );
        
        System.out.println(result.get()); // HELLO WORLD!!!
        
        // 3. Exception handling
        CompletableFuture<Integer> division = CompletableFuture
            .supplyAsync(() -> 10 / 0)
            .exceptionally(ex -> {
                System.out.println("Error: " + ex.getMessage());
                return 0;
            });
        
        System.out.println(division.get()); // 0
        
        // 4. Multiple futures
        CompletableFuture<Integer> future1 = CompletableFuture.supplyAsync(() -> 100);
        CompletableFuture<Integer> future2 = CompletableFuture.supplyAsync(() -> 200);
        
        CompletableFuture<Integer> sum = future1
            .thenCombine(future2, Integer::sum);
        
        System.out.println("Sum: " + sum.get()); // 300
    }
}
```

---

## 4.3 - ThreadLocal Class

### ThreadLocal nima?

**ThreadLocal** - har bir thread o'zining lokal nusxasiga ega bo'lgan o'zgaruvchilar. Har bir thread o'zining ThreadLocal copy'sini o'qiydi va yozadi.

```java
public class ThreadLocalExample {
    // Thread-local variable
    private static ThreadLocal<Integer> threadLocalValue = new ThreadLocal<>();
    
    public static void main(String[] args) {
        // Thread 1
        new Thread(() -> {
            threadLocalValue.set(100);
            System.out.println(Thread.currentThread().getName() + ": " + 
                             threadLocalValue.get()); // 100
            threadLocalValue.remove();
        }, "Thread-1").start();
        
        // Thread 2
        new Thread(() -> {
            threadLocalValue.set(200);
            System.out.println(Thread.currentThread().getName() + ": " + 
                             threadLocalValue.get()); // 200
            threadLocalValue.remove();
        }, "Thread-2").start();
        
        // Main thread
        threadLocalValue.set(300);
        System.out.println(Thread.currentThread().getName() + ": " + 
                         threadLocalValue.get()); // 300
        threadLocalValue.remove();
    }
}
```

### ThreadLocal qanday ishlaydi?

```java
// ThreadLocal implementatsiyasi (taxminan)
public class SimpleThreadLocal<T> {
    private Map<Thread, T> values = new HashMap<>();
    
    public synchronized void set(T value) {
        values.put(Thread.currentThread(), value);
    }
    
    public synchronized T get() {
        return values.get(Thread.currentThread());
    }
    
    public synchronized void remove() {
        values.remove(Thread.currentThread());
    }
}
```

### ThreadLocal withInitial()

```java
// 1. withInitial - default value bilan yaratish
ThreadLocal<Integer> counter = ThreadLocal.withInitial(() -> 0);

// 2. Complex initialization
ThreadLocal<SimpleDateFormat> dateFormat = 
    ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd"));

// 3. Misol
class UserContext {
    private static ThreadLocal<User> currentUser = ThreadLocal.withInitial(() -> null);
    private static ThreadLocal<String> requestId = ThreadLocal.withInitial(() -> 
        UUID.randomUUID().toString()
    );
    
    public static void setUser(User user) {
        currentUser.set(user);
    }
    
    public static User getUser() {
        return currentUser.get();
    }
    
    public static String getRequestId() {
        return requestId.get();
    }
    
    public static void clear() {
        currentUser.remove();
        requestId.remove();
    }
}
```

### ThreadLocal qanday holatlarda ishlatiladi?

#### 1. User context / Security context
```java
public class SecurityContext {
    private static ThreadLocal<UserPrincipal> currentUser = new ThreadLocal<>();
    
    public static void login(String username, String password) {
        UserPrincipal user = authenticate(username, password);
        currentUser.set(user);
    }
    
    public static UserPrincipal getCurrentUser() {
        UserPrincipal user = currentUser.get();
        if (user == null) {
            throw new SecurityException("No authenticated user");
        }
        return user;
    }
    
    public static void logout() {
        currentUser.remove();
    }
}

// Controller'da ishlatish
@RestController
public class UserController {
    @GetMapping("/profile")
    public UserProfile getProfile() {
        UserPrincipal user = SecurityContext.getCurrentUser();
        return userService.getProfile(user.getId());
    }
}
```

#### 2. Database connections / Transactions
```java
public class ConnectionManager {
    private static ThreadLocal<Connection> connectionHolder = new ThreadLocal<>();
    
    public static Connection getConnection() {
        Connection conn = connectionHolder.get();
        if (conn == null) {
            conn = createNewConnection();
            connectionHolder.set(conn);
        }
        return conn;
    }
    
    public static void closeConnection() {
        Connection conn = connectionHolder.get();
        if (conn != null) {
            try {
                conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
            connectionHolder.remove();
        }
    }
}

// Transaction management
public class TransactionManager {
    public static void beginTransaction() {
        Connection conn = ConnectionManager.getConnection();
        conn.setAutoCommit(false);
    }
    
    public static void commit() {
        Connection conn = ConnectionManager.getConnection();
        conn.commit();
        ConnectionManager.closeConnection();
    }
}
```

#### 3. SimpleDateFormat (Thread-safe emas)
```java
//  Xavfli - SimpleDateFormat thread-safe emas
public class DateService {
    private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd");
    
    public String formatDate(Date date) {
        return format.format(date); // Race condition!
    }
}

//  ThreadLocal bilan
public class DateService {
    private static ThreadLocal<SimpleDateFormat> dateFormat = 
        ThreadLocal.withInitial(() -> new SimpleDateFormat("yyyy-MM-dd"));
    
    public String formatDate(Date date) {
        return dateFormat.get().format(date);
    }
}
```

#### 4. Request tracking / Logging
```java
public class RequestTracker {
    private static ThreadLocal<String> requestId = 
        ThreadLocal.withInitial(() -> UUID.randomUUID().toString());
    private static ThreadLocal<Long> startTime = new ThreadLocal<>();
    
    public static void startRequest() {
        startTime.set(System.currentTimeMillis());
        logger.info("Request {} started", requestId.get());
    }
    
    public static void endRequest() {
        long duration = System.currentTimeMillis() - startTime.get();
        logger.info("Request {} ended, duration: {}ms", requestId.get(), duration);
        requestId.remove();
        startTime.remove();
    }
}

// Filter'da ishlatish
@WebFilter("/*")
public class RequestFilter implements Filter {
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, 
                        FilterChain chain) {
        RequestTracker.startRequest();
        try {
            chain.doFilter(request, response);
        } finally {
            RequestTracker.endRequest();
        }
    }
}
```

### ThreadLocalRandom

**ThreadLocalRandom** - har bir thread uchun alohida random number generator. Math.random() yoki shared Random'dan tezroq va contention kam.

```java
import java.util.concurrent.ThreadLocalRandom;

public class ThreadLocalRandomExample {
    public static void main(String[] args) {
        // 1. Random number olish
        int randomInt = ThreadLocalRandom.current().nextInt(); // any int
        int boundedInt = ThreadLocalRandom.current().nextInt(100); // 0-99
        int rangeInt = ThreadLocalRandom.current().nextInt(10, 20); // 10-19
        
        double randomDouble = ThreadLocalRandom.current().nextDouble(); // 0.0-1.0
        double boundedDouble = ThreadLocalRandom.current().nextDouble(100.0); // 0.0-100.0
        
        long randomLong = ThreadLocalRandom.current().nextLong();
        
        // 2. Parallel tasks da ishlatish
        ExecutorService executor = Executors.newFixedThreadPool(5);
        
        for (int i = 0; i < 10; i++) {
            executor.submit(() -> {
                // Har bir thread o'z random generatoriga ega
                int value = ThreadLocalRandom.current().nextInt(1000);
                System.out.println(Thread.currentThread().getName() + ": " + value);
            });
        }
        
        executor.shutdown();
        
        // 3. Streams bilan
        long sum = ThreadLocalRandom.current()
            .ints(1000, 1, 100) // 1000 ta random son 1-99
            .sum();
    }
}
```

### ThreadLocal va Memory Leaks

```java
public class ThreadLocalMemoryLeak {
    //  Memory leak xavfi
    private static ThreadLocal<byte[]> threadLocal = new ThreadLocal<>();
    
    public void process() {
        // Large object
        threadLocal.set(new byte[10_000_000]); // 10 MB
        
        // Process...
        
        // remove() qilinmasa, thread pool'dagi thread o'lguncha memory'da qoladi
        // threadLocal.remove(); // KERAK!
    }
    
    //  To'g'ri usul
    public void processCorrect() {
        try {
            threadLocal.set(new byte[10_000_000]);
            // Process...
        } finally {
            threadLocal.remove(); // Har doim remove qilish kerak!
        }
    }
}
```

**Muhim:**
- Thread pool ishlatganda, thread'lar qayta ishlatiladi
- ThreadLocal.remove() qilinmasa, oldingi ma'lumotlar qoladi
- Finally blokida remove qilish tavsiya etiladi

---

## Tekshiruv Savollari

### Lesson 4.1 - Thread Pools
1. **Thread Pools nima?**
2. **Executor Framework qanday framework?**
3. **Executor Framework nima maqsadda Javani 5chi versiyasida qo'shilgan?**
4. **Executorlar qanday ishlashini tushintirib bering.**
5. **Executor Framework afzalliklari?**
6. **Javada nechi xil Executor mavjud?**
7. **Executor tasklarni nimada saqlaydi?**
8. **Executorlarni nechi xil usulda o'chirishimiz mumkin?**

### Lesson 4.2 - Callable and Future
1. **Callable nima?**
2. **Future nima?**
3. **Callable va Runnable o'rtasidagi farq?**
4. **FutureTask nima?**
5. **Future class isDone() nima uchun ishlatiladi?**
6. **Future class get() nima uchun ishlatiladi?**

### Lesson 4.3 - ThreadLocal class
1. **ThreadLocal nima?**
2. **ThreadLocalRandom nima?**
3. **ThreadLocal qanday holatlarda foydalanishimiz kerak?**
4. **ThreadLocal withInitial() static method nima uchun ishlatamiz?**

---

## Amaliy Misol: Complete Example

```java
import java.util.concurrent.*;
import java.util.concurrent.atomic.AtomicInteger;

public class ThreadPoolCompleteExample {
    
    // ThreadLocal for request tracking
    private static ThreadLocal<String> requestId = 
        ThreadLocal.withInitial(() -> "REQ-" + ThreadLocalRandom.current().nextInt(1000, 9999));
    
    private static ThreadLocal<Long> startTime = new ThreadLocal<>();
    
    // Stats collection
    private static ConcurrentHashMap<String, AtomicInteger> stats = new ConcurrentHashMap<>();
    
    public static void main(String[] args) throws Exception {
        // Create thread pool
        ExecutorService executor = Executors.newFixedThreadPool(5);
        
        // List to hold futures
        List<Future<String>> futures = new CopyOnWriteArrayList<>();
        
        // Submit tasks
        for (int i = 0; i < 20; i++) {
            int taskId = i;
            
            Callable<String> task = () -> {
                // Track request
                startTime.set(System.currentTimeMillis());
                String reqId = requestId.get();
                
                try {
                    System.out.printf("[%s] Task %d started%n", reqId, taskId);
                    
                    // Simulate work with random delay
                    int workTime = ThreadLocalRandom.current().nextInt(500, 2000);
                    Thread.sleep(workTime);
                    
                    // Update stats
                    stats.computeIfAbsent("completed", k -> new AtomicInteger())
                         .incrementAndGet();
                    
                    return String.format("Task %d completed in %dms", taskId, workTime);
                    
                } finally {
                    long duration = System.currentTimeMillis() - startTime.get();
                    System.out.printf("[%s] Task %d took %dms%n", reqId, taskId, duration);
                    
                    // Clean up ThreadLocal
                    requestId.remove();
                    startTime.remove();
                }
            };
            
            futures.add(executor.submit(task));
        }
        
        // Shutdown executor and wait for completion
        executor.shutdown();
        
        // Monitor progress
        while (!executor.awaitTermination(1, TimeUnit.SECONDS)) {
            long completed = futures.stream().filter(Future::isDone).count();
            System.out.printf("Progress: %d/%d tasks completed%n", completed, futures.size());
        }
        
        // Print results
        System.out.println("\n=== Results ===");
        for (Future<String> future : futures) {
            try {
                System.out.println(future.get());
            } catch (ExecutionException e) {
                System.out.println("Task failed: " + e.getCause().getMessage());
            }
        }
        
        // Print stats
        System.out.println("\n=== Statistics ===");
        stats.forEach((key, value) -> 
            System.out.println(key + ": " + value.get()));
    }
}
```

---

**Keyingi mavzu:** [Fork-Join Framework](./05%20-%20Fork-Join%20Framework%20va%20Asinxron%20Dasturlash.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
