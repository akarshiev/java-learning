# Java Amaliy Mashqlar To'plami - 4-Modul: Concurrency, Time API, IO, NIO

## Mundarija
- [Multithreading (Ko'p tarmoqli dasturlash)](#multithreading-koʻp-tarmoqli-dasturlash)
- [Thread Safety va Synchronization](#thread-safety-va-synchronization)
- [Concurrency Utilities](#concurrency-utilities)
- [Thread Pools (Thread havzalari)](#thread-pools-thread-havzalari)
- [Asynchronous Programming](#asynchronous-programming)
- [Java Time API](#java-time-api)
- [IO Streams](#io-streams)
- [NIO (New I/O)](#nio-new-io)
- [Regular Expressions (Regex)](#regular-expressions-regex)
- [Logging API](#logging-api)

---

## Multithreading (Ko'p tarmoqli dasturlash)

<details>
<summary><b>1. Thread yaratish (Thread class)</b></summary>

**Misol:** Thread class'idan voris olib, yangi thread yarating.

**Berilgan:**
```java
class MyThread extends Thread {
    @Override
    public void run() {
        // 1 dan 10 gacha sonlarni chiqarish
    }
}
```

**Talab:** Asosiy thread va yangi thread bir vaqtda ishlashini kuzating. Har bir thread nomini chiqaring.

</details>

<details>
<summary><b>2. Thread yaratish (Runnable interface)</b></summary>

**Misol:** Runnable interface'ini implement qilib, thread yarating.

**Berilgan:**
```java
class MyRunnable implements Runnable {
    @Override
    public void run() {
        // 1 dan 10 gacha sonlarni chiqarish
    }
}
```

**Talab:** Runnable orqali yaratilgan threadni ishga tushiring. Runnable usulining afzalliklarini tushuntiring.

</details>

<details>
<summary><b>3. Bir nechta thread yaratish</b></summary>

**Misol:** 5 ta thread yarating. Har bir thread o'z nomi va ID sini 10 marta chiqarsin.

**Berilgan:** Har bir thread 1 sekund uxlab, keyin chiqarsin.

**Talab:** Threadlarning parallel ishlashini kuzating. Output tartibi har safar o'zgarishini tekshiring.

</details>

<details>
<summary><b>4. Thread sleep()</b></summary>

**Misol:** Thread.sleep() metodidan foydalanib, har bir soniyada vaqtni chiqaruvchi dastur yozing.

**Berilgan:** 10 soniya davomida har sekundda "Second: X" deb chiqaring.

**Talab:** InterruptedException ni to'g'ri ushlang.

</details>

<details>
<summary><b>5. Thread join()</b></summary>

**Misol:** Bir thread ikkinchi thread tugashini kutishi kerak.

**Berilgan:**
- Thread1: 1 dan 5 gacha sonlarni chiqaradi (har birida 500ms uxlaydi)
- Thread2: 6 dan 10 gacha sonlarni chiqaradi (thread1 tugagandan keyin)

**Talab:** join() metodidan foydalanib, thread1 tugaguncha thread2 ni kuting.

</details>

<details>
<summary><b>6. Thread priority</b></summary>

**Misol:** Turli priority ga ega threadlar yarating.

**Berilgan:**
- 3 ta thread: MIN_PRIORITY, NORM_PRIORITY, MAX_PRIORITY
- Har bir thread 10000 marta counter ni oshirsin

**Talab:** Priority thread scheduling ga qanday ta'sir qilishini kuzating (kafolatlanmagan).

</details>

<details>
<summary><b>7. Daemon thread</b></summary>

**Misol:** Daemon thread yarating va uning xususiyatlarini o'rganing.

**Berilgan:**
- Daemon thread: har sekundda "Daemon is working" deb chiqaradi
- User thread: 5 sekund ishlaydi va tugaydi

**Talab:** User thread tugagach, daemon thread ham avtomatik to'xtashini kuzating.

</details>

<details>
<summary><b>8. Thread states</b></summary>

**Misol:** Threadning hayot siklidagi barcha state'larni ko'rsating.

**Berilgan:**
- NEW, RUNNABLE, BLOCKED, WAITING, TIMED_WAITING, TERMINATED

**Talab:** Har bir state ga misol keltiring va thread.getState() orqali ko'rsating.

</details>

---

## Thread Safety va Synchronization

<details>
<summary><b>9. Race Condition</b></summary>

**Misol:** Race condition muammosini ko'rsatuvchi dastur yozing.

**Berilgan:**
```java
class Counter {
    private int count = 0;
    
    void increment() {
        count++; // NOT THREAD-SAFE!
    }
    
    int getCount() { return count; }
}
```

**Talab:** 1000 ta thread har biri 1000 marta increment() chaqirsin. Natija 1,000,000 bo'lishi kerak, lekin bo'lmaydi. Race condition ni kuzating.

</details>

<details>
<summary><b>10. synchronized method</b></summary>

**Misol:** synchronized keyword yordamida race condition ni hal qiling.

**Berilgan:** Yuqoridagi Counter class'iga synchronized qo'shing.

**Talab:** Natija doim 1,000,000 chiqishini tekshiring.

</details>

<details>
<summary><b>11. synchronized block</b></summary>

**Misol:** synchronized block yordamida kritik sektsiyani himoyalash.

**Berilgan:**
```java
class BankAccount {
    private double balance;
    
    void transfer(BankAccount to, double amount) {
        // Ikkala account ni ham lock qilish kerak
    }
}
```

**Talab:** synchronized block dan foydalanib, transfer metodini thread-safe qiling.

</details>

<details>
<summary><b>12. wait() va notify()</b></summary>

**Misol:** Producer-Consumer muammosini wait() va notify() yordamida hal qiling.

**Berilgan:**
- Producer: 1 dan 10 gacha sonlarni queue ga qo'shadi
- Consumer: queue dan sonlarni olib chiqaradi
- Queue to'lganda producer kutadi, bo'shaganda consumer kutadi

**Talab:** wait() va notify() metodlaridan to'g'ri foydalaning.

</details>

<details>
<summary><b>13. Deadlock</b></summary>

**Misol:** Deadlock holatini yaratib, uni tahlil qiling.

**Berilgan:**
```java
class Resource {
    // ikkita resurs va ikkita thread
}
```

**Talab:** Thread1 lock1 ni oladi, keyin lock2 ni kutadi. Thread2 lock2 ni oladi, keyin lock1 ni kutadi. Deadlock yuz bersin. JConsole yoki jstack yordamida deadlock ni aniqlang.

</details>

<details>
<summary><b>14. Deadlock ni oldini olish</b></summary>

**Misol:** Deadlock ni oldini olish usullarini qo'llang.

**Berilgan:** Yuqoridagi deadlock misolini oling.

**Talab:** 
- Lock'larni bir xil tartibda olish
- tryLock() bilan timeout ishlatish
- Concurrent utililardan foydalanish

</details>

<details>
<summary><b>15. Volatile keyword</b></summary>

**Misol:** volatile keyword nima uchun kerakligini ko'rsating.

**Berilgan:**
```java
class SharedObject {
    private boolean flag = false;
    // volatile bilan va volatiesiz
}
```

**Talab:** Bir thread flag ni o'zgartirganda, ikkinchi thread o'zgarishni ko'rishi kerak. Volatile bu visibility ni ta'minlaydi.

</details>

<details>
<summary><b>16. ReentrantLock</b></summary>

**Misol:** ReentrantLock yordamida thread-safe dastur yozing.

**Berilgan:** Counter misolini ReentrantLock bilan yozing.

**Talab:** lock() va unlock() metodlarini to'g'ri ishlating. try-finally blokida unlock qilishni unutmang.

</details>

<details>
<summary><b>17. ReadWriteLock</b></summary>

**Misol:** Ko'p o'qish, kam yozish bo'lgan scenario uchun ReadWriteLock dan foydalaning.

**Berilgan:**
```java
class DataStructure {
    private Map<String, String> data = new HashMap<>();
    private ReadWriteLock lock = new ReentrantReadWriteLock();
    
    // read metodlari ReadLock dan foydalanadi
    // write metodlari WriteLock dan foydalanadi
}
```

**Talab:** Bir nechta reader thread va bir nechta writer thread yarating. Reader'lar parallel ishlay olishi kerak, writer esa exclusive bo'lishi kerak.

</details>

<details>
<summary><b>18. Condition</b></summary>

**Misol:** Condition interface yordamida producer-consumer muammosini hal qiling.

**Berilgan:** Bounded buffer (cheklangan bufer) yarating.

**Talab:** await() va signal() metodlaridan foydalanib, producer va consumer larni sinxronlang.

</details>

---

## Concurrency Utilities

<details>
<summary><b>19. AtomicInteger</b></summary>

**Misol:** AtomicInteger yordamida thread-safe counter yarating.

**Berilgan:**
```java
AtomicInteger counter = new AtomicInteger(0);
```

**Talab:** 1000 ta thread har biri 1000 marta increment qilsin. AtomicInteger getAndIncrement() yoki incrementAndGet() metodlaridan foydalaning.

</details>

<details>
<summary><b>20. CAS (Compare-And-Swap)</b></summary>

**Misol:** CAS operatsiyasini tushuntiruvchi dastur yozing.

**Berilgan:**
```java
AtomicInteger atomicInt = new AtomicInteger(10);
```

**Talab:** compareAndSet() metodidan foydalanib, qiymatni faqat kutilgan qiymatga teng bo'lganda o'zgartiring.

</details>

<details>
<summary><b>21. ConcurrentHashMap</b></summary>

**Misol:** ConcurrentHashMap yordamida thread-safe map yarating.

**Berilgan:**
- 10 ta thread har biri map ga 1000 ta element qo'shadi
- HashMap va ConcurrentHashMap performance solishtirish

**Talab:** putIfAbsent(), computeIfAbsent(), forEach() kabi metodlardan foydalaning.

</details>

<details>
<summary><b>22. CopyOnWriteArrayList</b></summary>

**Misol:** CopyOnWriteArrayList xususiyatlarini o'rganing.

**Berilgan:**
- Bir vaqtda list ga element qo'shish va list ni aylanish

**Talab:** CopyOnWriteArrayList iterator yaratilgandan keyin list o'zgarsa, iterator eski copy bilan ishlashini ko'rsating.

</details>

<details>
<summary><b>23. BlockingQueue</b></summary>

**Misol:** BlockingQueue yordamida producer-consumer muammosini hal qiling.

**Berilgan:**
- ArrayBlockingQueue (capacity = 5)
- 2 ta producer, 2 ta consumer

**Talab:** put() va take() metodlari queue to'lganda/bo'shaganda bloklanishini kuzating.

</details>

<details>
<summary><b>24. CountDownLatch</b></summary>

**Misol:** CountDownLatch yordamida bir nechta thread tugashini kuting.

**Berilgan:**
- 5 ta thread parallel ishlaydi
- Asosiy thread ularning hammasi tugashini kutadi

**Talab:** CountDownLatch(5) yarating. Har bir thread tugagach latch.countDown() chaqiradi. Asosiy thread latch.await() da kutadi.

</details>

<details>
<summary><b>25. CyclicBarrier</b></summary>

**Misol:** CyclicBarrier yordamida threadlarni sinxronlashtiring.

**Berilgan:**
- 3 ta thread parallel hisoblash bajaradi
- Har bir thread hisoblashni tugatgach, barrier da kutadi
- Barcha thread tugagach, natijalarni birlashtiradi

**Talab:** CyclicBarrier ni bir necha marta qayta ishlatish mumkinligini ko'rsating.

</details>

<details>
<summary><b>26. Semaphore</b></summary>

**Misol:** Semaphore yordamida resurslarga kirishni cheklang.

**Berilgan:**
- 3 ta printer (resurs)
- 10 ta thread printer dan foydalanmoqchi

**Talab:** Semaphore(3) yarating. Har bir thread acquire() qiladi, ish tugagach release().

</details>

<details>
<summary><b>27. Exchanger</b></summary>

**Misol:** Exchanger yordamida ikki thread o'rtasida ma'lumot almashish.

**Berilgan:**
- Thread1: ma'lumot tayyorlaydi
- Thread2: ma'lumotni qayta ishlaydi

**Talab:** Exchanger.exchange() metodi orqali ma'lumotlarni almashing.

</details>

<details>
<summary><b>28. Phaser</b></summary>

**Misol:** Phaser yordamida dinamik thread sinxronizatsiyasi.

**Berilgan:** Bir nechta bosqichli (phase) vazifa.

**Talab:** Phaser ga threadlar register va arrive qilishini ko'rsating.

</details>

---

## Thread Pools (Thread havzalari)

<details>
<summary><b>29. FixedThreadPool</b></summary>

**Misol:** Executors.newFixedThreadPool() yordamida thread pool yarating.

**Berilgan:** 100 ta task, 5 ta threadli pool.

**Talab:** Pool dagi threadlar soni 5 tadan oshmasligini, tasklar navbatda kutishini ko'rsating.

</details>

<details>
<summary><b>30. CachedThreadPool</b></summary>

**Misol:** Executors.newCachedThreadPool() xususiyatlarini o'rganing.

**Berilgan:** 100 ta qisqa muddatli task.

**Talab:** Pool kerak bo'lganda yangi thread yaratishini, 60 sekund ishlatilmasa threadlarni o'chirishini ko'rsating.

</details>

<details>
<summary><b>31. SingleThreadExecutor</b></summary>

**Misol:** Executors.newSingleThreadExecutor() yordamida tasklarni ketma-ket bajarish.

**Berilgan:** 10 ta task (har biri 1 sekund uxlaydi)

**Talab:** Tasklar birin-ketin, navbat bilan bajarilishini ko'rsating.

</details>

<details>
<summary><b>32. ScheduledThreadPool</b></summary>

**Misol:** ScheduledExecutorService yordamida tasklarni vaqtga qarab bajarish.

**Berilgan:**
- 5 sekunddan keyin bir marta bajariladigan task
- Har 2 sekundda takrorlanadigan task
- 1 sekund delay bilan, har 3 sekundda takrorlanadigan task

**Talab:** schedule(), scheduleAtFixedRate(), scheduleWithFixedDelay() metodlaridan foydalaning.

</details>

<details>
<summary><b>33. WorkStealingPool</b></summary>

**Misol:** ForkJoinPool dan foydalanib, work-stealing algoritmini ko'rsating.

**Berilgan:** Katta massivni parallel hisoblash.

**Talab:** Work-stealing pool tasklarni threadlar o'rtasida qanday taqsimlashini tushuntiring.

</details>

<details>
<summary><b>34. ThreadPoolExecutor</b></summary>

**Misol:** ThreadPoolExecutor ni to'g'ridan-to'g'ri konfiguratsiya qilish.

**Berilgan:**
- corePoolSize = 5
- maximumPoolSize = 10
- keepAliveTime = 60 sekund
- BlockingQueue = ArrayBlockingQueue(100)

**Talab:** Queue to'lganda maximumPoolSize gacha thread ko'payishini ko'rsating.

</details>

<details>
<summary><b>35. ExecutorService shutdown</b></summary>

**Misol:** ExecutorService ni to'g'ri to'xtatish usullari.

**Berilgan:** 100 ta task submit qilingan pool.

**Talab:**
- shutdown() - yangi task qabul qilmaydi, boshlanganlar tugaydi
- shutdownNow() - barcha tasklarni to'xtatishga urinadi
- awaitTermination() - tugashini kutish

</details>

---

## Asynchronous Programming

<details>
<summary><b>36. Callable va Future</b></summary>

**Misol:** Callable yordamida natija qaytaruvchi task yarating.

**Berilgan:**
```java
Callable<Integer> task = () -> {
    // 1 dan 100 gacha summani hisoblash
    return sum;
};
```

**Talab:** ExecutorService.submit() orqali task ni ishga tushiring. Future.get() orqali natijani oling.

</details>

<details>
<summary><b>37. Future with timeout</b></summary>

**Misol:** Future.get() ga timeout qo'shish.

**Berilgan:** 10 sekund ishlaydigan task.

**Talab:** Future.get(2, TimeUnit.SECONDS) chaqirib, TimeoutException ni ushlang.

</details>

<details>
<summary><b>38. CompletableFuture - supplyAsync</b></summary>

**Misol:** CompletableFuture.supplyAsync() yordamida asinxron task yarating.

**Berilgan:**
```java
CompletableFuture.supplyAsync(() -> {
    // Uzoq vaqt oladigan hisoblash
    return result;
});
```

**Talab:** thenAccept() orqali natijani chiqaring. Main thread bloklanmasligini ko'rsating.

</details>

<details>
<summary><b>39. CompletableFuture - thenApply</b></summary>

**Misol:** CompletableFuture natijasini transformatsiya qilish.

**Berilgan:**
- supplyAsync() -> String qaytaradi
- thenApply() -> String ni Integer ga o'tkazadi
- thenApply() -> Integer ni kvadratga oshirish

**Talab:** Asinxron transformatsiyalar zanjirini yarating.

</details>

<details>
<summary><b>40. CompletableFuture - thenCompose</b></summary>

**Misol:** thenCompose() yordamida future larni ketma-ket bajarish.

**Berilgan:**
- firstTask() -> CompletableFuture<Integer>
- secondTask(Integer) -> CompletableFuture<String>

**Talab:** thenCompose() yordamida firstTask natijasini secondTask ga uzating.

</details>

<details>
<summary><b>41. CompletableFuture - thenCombine</b></summary>

**Misol:** Ikki mustaqil future natijalarini birlashtirish.

**Berilgan:**
- future1: 1 dan 50 gacha summa
- future2: 51 dan 100 gacha summa

**Talab:** thenCombine() yordamida ikkala natijani qo'shing.

</details>

<details>
<summary><b>42. CompletableFuture - allOf</b></summary>

**Misol:** Bir nechta future tugashini kutish.

**Berilgan:** 5 ta parallel task.

**Talab:** CompletableFuture.allOf() yordamida hamma task tugashini kuting. thenRun() bilan keyingi amalni bajaring.

</details>

<details>
<summary><b>43. CompletableFuture - anyOf</b></summary>

**Misol:** Birinchi tugagan future natijasini olish.

**Berilgan:** 3 ta task, turli vaqtlarda tugaydi.

**Talab:** CompletableFuture.anyOf() birinchi tugagan natijani qaytarishini ko'rsating.

</details>

<details>
<summary><b>44. CompletableFuture - exceptionally</b></summary>

**Misol:** CompletableFuture da xatoliklarni qayta ishlash.

**Berilgan:** 50% ehtimollik bilan exception tashlaydigan task.

**Talab:** exceptionally() yordamida xatolik yuz berganda default qiymat qaytaring.

</details>

<details>
<summary><b>45. CompletableFuture - handle</b></summary>

**Misol:** handle() yordamida success va failure holatlarini bir joyda qayta ishlash.

**Berilgan:** Yuqoridagi misol.

**Talab:** handle() metodi natija va exception ni qabul qilishini ko'rsating.

</details>

---

## Java Time API

<details>
<summary><b>46. LocalDate</b></summary>

**Misol:** LocalDate bilan ishlash.

**Berilgan:**
- Hozirgi sanani olish
- Tug'ilgan kuningizni yaratish (1995-05-15)
- Tug'ilgan kundan hozirgacha necha kun o'tgan?
- Haftaning qaysi kuni ekanligini aniqlash

**Talab:** LocalDate.of(), LocalDate.now(), Period.between() metodlaridan foydalaning.

</details>

<details>
<summary><b>47. LocalTime</b></summary>

**Misol:** LocalTime bilan ishlash.

**Berilgan:**
- Hozirgi vaqtni olish
- 1 soat 30 minut keyingi vaqtni hisoblash
- Ikki vaqt o'rtasidagi farqni hisoblash

**Talab:** plusHours(), plusMinutes(), between() metodlaridan foydalaning.

</details>

<details>
<summary><b>48. LocalDateTime</b></summary>

**Misol:** LocalDateTime bilan ishlash.

**Berilgan:**
- Hozirgi sana va vaqt
- 2024-12-31 23:59:59 dan foydalanib, Yangi yilga qancha qolganini hisoblash
- LocalDate va LocalTime dan LocalDateTime yaratish

</details>

<details>
<summary><b>49. ZonedDateTime</b></summary>

**Misol:** Turli timezone'larda vaqtni ko'rsatish.

**Berilgan:**
- Toshkent, Nyu-York, Tokio vaqtlarini ko'rsatish
- Toshkent vaqti bilan Nyu-York vaqti o'rtasidagi farqni hisoblash

**Talab:** ZoneId.of() va ZonedDateTime.now() dan foydalaning.

</details>

<details>
<summary><b>50. Instant</b></summary>

**Misol:** Instant (timestamp) bilan ishlash.

**Berilgan:**
- Hozirgi timestamp (epoch millis)
- 24 soat oldingi timestamp
- Ikki timestamp o'rtasidagi farq

**Talab:** Instant.now(), Instant.ofEpochMilli(), Duration.between() dan foydalaning.

</details>

<details>
<summary><b>51. Duration va Period</b></summary>

**Misol:** Duration (time-based) va Period (date-based) farqini ko'rsating.

**Berilgan:**
- Duration: 2 soat 30 minut
- Period: 1 yil 3 oy 5 kun

**Talab:** Duration va Period yordamida vaqt qo'shish va ayirish.

</details>

<details>
<summary><b>52. DateTimeFormatter</b></summary>

**Misol:** Sana va vaqtni turli formatlarda chiqarish.

**Berilgan:**
- "dd/MM/yyyy"
- "yyyy-MM-dd HH:mm:ss"
- "EEEE, MMMM d, yyyy"
- O'zbekcha format (locale bilan)

**Talab:** DateTimeFormatter.ofPattern() va format() metodlaridan foydalaning.

</details>

<details>
<summary><b>53. TemporalAdjusters</b></summary>

**Misol:** TemporalAdjusters yordamida sanani manipulyatsiya qilish.

**Berilgan:**
- Oyning birinchi kuni
- Oyning oxirgi kuni
- Keyingi dushanba
- Kelasi oyning birinchi kuni

**Talab:** with(TemporalAdjusters.firstDayOfMonth()) kabi metodlardan foydalaning.

</details>

<details>
<summary><b>54. MonthDay</b></summary>

**Misol:** Tug'ilgan kun (yilsiz) bilan ishlash.

**Berilgan:** 5 ta do'stingizning tug'ilgan kunlari.

**Talab:** MonthDay yordamida bugun kimning tug'ilgan kuni ekanligini aniqlang.

</details>

<details>
<summary><b>55. YearMonth</b></summary>

**Misol:** Kredit karta amal qilish muddati bilan ishlash.

**Berilgan:** "2025-12" formatidagi sana.

**Talab:** YearMonth yordamida bu oy hozirgi oydan keyinmi yoki oldinmi aniqlang.

</details>

---

## IO Streams

<details>
<summary><b>56. FileOutputStream</b></summary>

**Misol:** Faylga matn yozish (byte stream).

**Berilgan:** "Hello, Java IO!" matnini faylga yozing.

**Talab:** FileOutputStream dan foydalaning. write() metodini chaqiring. Faylni yoping.

</details>

<details>
<summary><b>57. FileInputStream</b></summary>

**Misol:** Fayldan matn o'qish (byte stream).

**Berilgan:** Yuqoridagi faylni o'qib, konsolga chiqaring.

**Talab:** FileInputStream dan foydalaning. read() metodini while loop da ishlating.

</details>

<details>
<summary><b>58. FileReader / FileWriter</b></summary>

**Misol:** Faylga matn yozish va o'qish (character stream).

**Berilgan:** "O'zbekiston - vatanim manim" matnini faylga yozing va o'qing.

**Talab:** FileReader va FileWriter dan foydalaning. Unicode bilan ishlashni ko'rsating.

</details>

<details>
<summary><b>59. BufferedReader</b></summary>

**Misol:** BufferedReader yordamida fayldan qator-qator o'qish.

**Berilgan:** 10 qatorli matnli fayl.

**Talab:** readLine() metodidan foydalanib, har bir qatorni chiqaring.

</details>

<details>
<summary><b>60. BufferedWriter</b></summary>

**Misol:** BufferedWriter yordamida faylga yozish.

**Berilgan:** 1000 qatorli matn yozish.

**Talab:** BufferedWriter va FileWriter performance farqini o'lchang.

</details>

<details>
<summary><b>61. DataOutputStream / DataInputStream</b></summary>

**Misol:** Primitive tiplarni faylga yozish va o'qish.

**Berilgan:** int, double, boolean, String ma'lumotlar.

**Talab:** writeInt(), writeDouble(), writeUTF() va mos ravishda readInt(), readDouble(), readUTF() metodlaridan foydalaning.

</details>

<details>
<summary><b>62. ObjectOutputStream / ObjectInputStream</b></summary>

**Misol:** Object larni faylga yozish va o'qish.

**Berilgan:** Serializable Person class (name, age).

**Talab:** ObjectOutputStream.writeObject() va ObjectInputStream.readObject() dan foydalaning.

</details>

<details>
<summary><b>63. File class</b></summary>

**Misol:** File class metodlaridan foydalanish.

**Berilgan:** Papka va fayllar bilan ishlash.

**Talab:**
- Fayl mavjudligini tekshirish
- Fayl yaratish
- Fayl nomini o'zgartirish
- Fayl o'chirish
- Papka ichidagi fayllar ro'yxatini olish

</details>

<details>
<summary><b>64. File copy (byte stream)</b></summary>

**Misol:** Faylni nusxalash (byte stream).

**Berilgan:** Manba fayl va nusxa fayl.

**Talab:** FileInputStream va FileOutputStream yordamida faylni nusxalang. 1024 baytli buffer ishlating.

</details>

<details>
<summary><b>65. File copy (character stream)</b></summary>

**Misol:** Matnli faylni nusxalash (character stream).

**Berilgan:** UTF-8 encoded matnli fayl.

**Talab:** FileReader va FileWriter yordamida nusxalang. BufferedReader va BufferedWriter ishlating.

</details>

---

## NIO (New I/O)

<details>
<summary><b>66. Path va Files</b></summary>

**Misol:** Path va Files classlari bilan ishlash.

**Berilgan:**
```java
Path path = Paths.get("test.txt");
```

**Talab:**
- Fayl mavjudligini tekshirish (Files.exists())
- Fayl yaratish (Files.createFile())
- Fayl o'chirish (Files.delete())
- Fayl ma'lumotlarini o'qish (Files.readAllLines())

</details>

<details>
<summary><b>67. Files.write() va Files.readAllLines()</b></summary>

**Misol:** NIO yordamida faylga yozish va o'qish.

**Berilgan:** List<String> lines.

**Talab:** Files.write() va Files.readAllLines() metodlaridan foydalaning.

</details>

<details>
<summary><b>68. Files.lines() (Stream API)</b></summary>

**Misol:** Files.lines() yordamida faylni stream sifatida o'qish.

**Berilgan:** Katta fayl.

**Talab:** Stream API bilan filter, map, collect ishlating. Stream ni yopishni unutmang.

</details>

<details>
<summary><b>69. Files.walk()</b></summary>

**Misol:** Papka ichidagi barcha fayllarni rekursiv o'qish.

**Berilgan:** Papka yo'li.

**Talab:** Files.walk() yordamida barcha .txt fayllarni toping.

</details>

<details>
<summary><b>70. Files.find()</b></summary>

**Misol:** Fayllarni qidirish.

**Berilgan:** Papka ichida ma'lum shartga mos fayllarni qidirish.

**Talab:** Files.find() yordamida 1MB dan katta fayllarni toping.

</details>

<details>
<summary><b>71. Path resolve va relativize</b></summary>

**Misol:** Path larni birlashtirish va nisbiy yo'lni hisoblash.

**Berilgan:**
- basePath = "/home/user/docs"
- filePath = "projects/java/test.txt"

**Talab:** resolve() yordamida to'liq yo'lni yarating. relativize() yordamida nisbiy yo'lni hisoblang.

</details>

<details>
<summary><b>72. DirectoryStream</b></summary>

**Misol:** Papka ichidagi fayllarni filterlash.

**Berilgan:** Papka yo'li.

**Talab:** DirectoryStream yordamida faqat .java fayllarni chiqaring.

</details>

<details>
<summary><b>73. FileVisitor</b></summary>

**Misol:** Fayl tizimini rekursiv aylanish.

**Berilgan:** Papka yo'li.

**Talab:** SimpleFileVisitor dan voris oling. visitFile() va preVisitDirectory() metodlarini override qiling.

</details>

<details>
<summary><b>74. FileChannel</b></summary>

**Misol:** FileChannel yordamida faylga yozish va o'qish.

**Berilgan:** ByteBuffer bilan ishlash.

**Talab:** FileChannel.open() yordamida channel oching. ByteBuffer.allocate() yordamida buffer yarating. Channel dan buffer ga o'qing va aksincha.

</details>

<details>
<summary><b>75. Memory-mapped file</b></summary>

**Misol:** Katta faylni memory-mapped file sifatida o'qish.

**Berilgan:** 100 MB li fayl.

**Talab:** FileChannel.map() yordamida MappedByteBuffer yarating. Buffer dan to'g'ridan-to'g'ri o'qing.

</details>

<details>
<summary><b>76. WatchService</b></summary>

**Misol:** Fayl tizimi o'zgarishlarini kuzatish.

**Berilgan:** Papka.

**Talab:** WatchService yordamida papkada yaratilgan, o'zgartirilgan, o'chirilgan fayllarni kuzating. Event lar kelganda konsolga chiqaring.

</details>

---

## Regular Expressions (Regex)

<details>
<summary><b>77. Email validation</b></summary>

**Misol:** Regex yordamida email manzilni tekshirish.

**Berilgan:** email@example.com, invalid-email, user.name@domain.co.uk

**Talab:** Quyidagi shartlarni tekshiring:
- @ belgisi bo'lishi kerak
- @ dan keyin domain bo'lishi kerak
- . (dot) dan keyin kamida 2 belgi

</details>

<details>
<summary><b>78. Phone number validation</b></summary>

**Misol:** O'zbekiston telefon raqamlarini tekshirish.

**Berilgan:** +998901234567, +998 90 123 45 67, +998-90-123-45-67, 998901234567

**Talab:** Regex yozing: +998 bilan boshlanadi, keyin 2 xonali kod (90,91,93,94,95,97,98,99), keyin 7 xonali raqam.

</details>

<details>
<summary><b>79. Strong password validation</b></summary>

**Misol:** Parol mustahkamligini tekshirish.

**Berilgan:** "Password123!", "weak", "StrongP@ss1"

**Talab:**
- Kamida 8 belgi
- Kamida 1 katta harf
- Kamida 1 kichik harf
- Kamida 1 raqam
- Kamida 1 maxsus belgi (!@#$%^&*)

</details>

<details>
<summary><b>80. Extract numbers from text</b></summary>

**Misol:** Matndan barcha sonlarni ajratib olish.

**Berilgan:** "Narxi: $100, 25% chegirma, jami 75.50 dollar"

**Talab:** Regex yordamida barcha sonlarni (int va double) toping.

</details>

<details>
<summary><b>81. Replace with regex</b></summary>

**Misol:** Matndagi barcha raqamlarni # bilan almashtirish.

**Berilgan:** "ID: 12345, Phone: +998901234567, Code: 42"

**Talab:** String.replaceAll() bilan regex ishlating.

</details>

<details>
<summary><b>82. Split with regex</b></summary>

**Misol:** Matnni so'zlarga ajratish.

**Berilgan:** "Java - bu ajoyib dasturlash tili!"

**Talab:** String.split() yordamida tinish belgilarini ham hisobga oling (\\W+).

</details>

<details>
<summary><b>83. Pattern and Matcher</b></summary>

**Misol:** Pattern va Matcher classlari bilan ishlash.

**Berilgan:** "Java 8, Java 11, Java 17, Java 21" matnidan barcha Java versiyalarini topish.

**Talab:** Pattern.compile("Java \\d+") va matcher.find() dan foydalaning.

</details>

<details>
<summary><b>84. Grouping in regex</b></summary>

**Misol:** Regex guruhlari bilan ishlash.

**Berilgan:** "John Doe (30 yosh) - john@example.com"

**Talab:** Guruhlar yordamida ism, yosh va email ni ajratib oling: "(\\w+) (\\w+) \\((\\d+).* - (\\S+)"

</details>

<details>
<summary><b>85. URL validation</b></summary>

**Misol:** URL manzilni tekshirish.

**Berilgan:** https://www.example.com, http://example.org, ftp://invalid, example.com

**Talab:** http:// yoki https:// bilan boshlanishi, keyin domain nomi, .com/.org/.net kabi.

</details>

<details>
<summary><b>86. HTML tag removal</b></summary>

**Misol:** Matndan HTML teglarini olib tashlash.

**Berilgan:** "<p>Hello <b>World</b>!</p>"

**Talab:** Regex yordamida <[^>]*> ni bo'sh string ga almashtiring.

</details>

<details>
<summary><b>87. IP address validation</b></summary>

**Misol:** IPv4 manzilni tekshirish.

**Berilgan:** 192.168.1.1, 256.0.0.1, 10.0.0

**Talab:** Har bir oktet 0-255 oralig'ida bo'lishi kerak.

</details>

---

## Logging API

<details>
<summary><b>88. Basic logging</b></summary>

**Misol:** java.util.logging.Logger yordamida oddiy log yozish.

**Berilgan:**
```java
Logger logger = Logger.getLogger(MyClass.class.getName());
```

**Talab:** info(), warning(), severe() metodlari bilan log yozing. Har bir log da vaqt va level ko'rinishi kerak.

</details>

<details>
<summary><b>89. Log levels</b></summary>

**Misol:** Barcha log level larini ko'rsatish.

**Berilgan:** SEVERE, WARNING, INFO, CONFIG, FINE, FINER, FINEST

**Talab:** Har bir level da log yozing. Level larni filterlashni ko'rsating (logger.setLevel()).

</details>

<details>
<summary><b>90. FileHandler</b></summary>

**Misol:** Log larni faylga yozish.

**Berilgan:** ConsoleHandler o'rniga FileHandler ishlating.

**Talab:** FileHandler yarating, formatter o'rnating, logger ga qo'shing. Faylga log yozilishini tekshiring.

</details>

<details>
<summary><b>91. Custom formatter</b></summary>

**Misol:** Log formatini o'zgartirish.

**Berilgan:** SimpleFormatter o'rniga custom formatter yozing.

**Talab:** Formatter yarating: [YYYY-MM-DD HH:MM:SS] [LEVEL] [CLASS] - MESSAGE

</details>

<details>
<summary><b>92. XMLFormatter</b></summary>

**Misol:** Log larni XML formatda saqlash.

**Berilgan:** FileHandler ga XMLFormatter o'rnating.

**Talab:** XML fayl yaratilishini va to'g'ri formatdaligini tekshiring.

</details>

<details>
<summary><b>93. Multiple handlers</b></summary>

**Misol:** Bir nechta handler qo'shish.

**Berilgan:**
- ConsoleHandler (INFO va yuqori)
- FileHandler (ALL)

**Talab:** Ikkala handler ham loglarni qabul qilishini tekshiring.

</details>

<details>
<summary><b>94. Custom filter</b></summary>

**Misol:** Loglarni filterlash.

**Berilgan:** Faqat "ERROR" so'zi bor loglarni chiqarish.

**Talab:** Filter interface'ini implement qiling. isLoggable() metodida log ni tekshiring.

</details>

<details>
<summary><b>95. Logging in multi-threaded app</b></summary>

**Misol:** Ko'p threadli dasturda logging.

**Berilgan:** 10 ta thread bir vaqtda log yozadi.

**Talab:** Logger thread-safe ekanligini tekshiring. Har bir thread o'z nomini log ga qo'shsin.

</details>

<details>
<summary><b>96. Log rotation</b></summary>

**Misol:** Fayl hajmi oshganda yangi fayl yaratish.

**Berilgan:** FileHandler ni limit, count parametrlari bilan yarating.

**Talab:** FileHandler(filePattern, limit, count) konstruktoridan foydalaning. Fayl to'lganda yangi fayl yaratilishini tekshiring.

</details>

<details>
<summary><b>97. Logging configuration (properties)</b></summary>

**Misol:** logging.properties fayli orqali log sozlamalarini o'rnatish.

**Berilgan:** logging.properties fayli yarating.

**Talab:**
```
handlers = java.util.logging.FileHandler
java.util.logging.FileHandler.pattern = app_%g.log
java.util.logging.FileHandler.limit = 1000000
java.util.logging.FileHandler.count = 5
.level = INFO
```

</details>

<details>
<summary><b>98. LogManager</b></summary>

**Misol:** LogManager orqali logger sozlamalarini o'qish.

**Berilgan:** LogManager.getLogManager()

**Talab:** Barcha logger nomlarini chiqaring. Logger level larini o'zgartiring.

</details>

<details>
<summary><b>99. Exception logging</b></summary>

**Misol:** Exception larni log ga yozish.

**Berilgan:** try-catch blokida exception ni ushlang.

**Talab:** logger.log(Level.SEVERE, "Message", exception) yordamida stack trace ni ham log ga yozing.

</details>

<details>
<summary><b>100. Performance logging</b></summary>

**Misol:** Metod bajarilish vaqtini log ga yozish.

**Berilgan:** Biror metodning bajarilish vaqtini o'lchang.

**Talab:** Metod boshlanishi va tugashida log yozing. Fine level dan foydalaning.

</details>

---

## Mashqlar Statistikasi

| Bo'lim | Mashqlar soni |
|--------|---------------|
| Multithreading | 8 ta |
| Thread Safety va Synchronization | 10 ta |
| Concurrency Utilities | 10 ta |
| Thread Pools | 7 ta |
| Asynchronous Programming | 10 ta |
| Java Time API | 10 ta |
| IO Streams | 10 ta |
| NIO | 11 ta |
| Regular Expressions | 11 ta |
| Logging API | 13 ta |
| **Jami** | **100 ta** |

---

**[Mundarijaga qaytish](#-mundarija)**

> Har bir mashqni mustaqil bajarishga harakat qiling! Concurrency va IO ni amaliyotda qo'llash orqali mustahkamlang. 🚀
