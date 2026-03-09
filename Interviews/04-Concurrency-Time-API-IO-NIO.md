# 4-Modul: Concurrency, Time API, IO, NIO - Intervyu Savollari

## Lesson 1 - Multithreading (Ko'p tarmoqli dasturlash)

### Lesson 1.1 (Multithreading asoslari)
<details>
<summary>Lesson 1.1 (Multithreading asoslari)</summary>

- **Multitasking nima?**
- **Multitasking va Multithreading o'rtasidagi farq?**
- **Concurrency nima?**
- **Thread nima?**
- **Process nima?**
- **Thread va Process o'rtasidagi farq?**

</details>

### Lesson 1.2 (Threads)
<details>
<summary>Lesson 1.2 (Threads - Tarmoqlar)</summary>

- **Java-da necha xil usulda thread yaratish mumkin?**
- **Runnable nima?**
- **Threadni Runnable bilan yaratish yaxshimi yoki Thread class orqalimi?**
- **Thread classning join() metodi nima uchun ishlatiladi?**
- **Thread classning stop() metodi nima uchun ishlatiladi? (deprecated)**
- **Thread classning getState() metodi nima uchun ishlatiladi?**
- **Thread classning yield() metodi nima qiladi?**
- **Java-da 2 ta thread o'rtasida ma'lumotlarni qanday almashish mumkin?**

</details>

### Lesson 1.3 (Life Cycle of a Thread)
<details>
<summary>Lesson 1.3 (Life Cycle of a Thread - Threadning hayot sikli)</summary>

- **Threadning life cycle ini tushuntirib bering?**
- **sleep() va wait() metodlari o'rtasidagi farq?**
- **Threadning state qachon RUNNABLE ga o'zgaradi?**
- **Threadning state qachon TERMINATED (DEAD) ga o'zgaradi?**
- **Threadni to'xtatish (o'chirish) mumkinmi? Agar mumkin bo'lsa, qanday?**

</details>

### Lesson 1.4 (Thread Properties)
<details>
<summary>Lesson 1.4 (Thread Properties - Thread xususiyatlari)</summary>

- **Thread classning currentThread() metodi nima uchun kerak?**
- **Daemon thread qanday thread?**
- **Daemon thread qachon foydalanish kerak?**
- **Thread priority nima?**
- **Thread priority yuqori bo'lgan threadlar bilan past bo'lgan threadlar o'rtasidagi farq?**

</details>

---

## Lesson 2 - Synchronization (Sinxronizatsiya)

### Lesson 2.1 (Race Condition)
<details>
<summary>Lesson 2.1 (Race Condition - Musobaqa holati)</summary>

- **Race condition qanday muammo?**
- **Race condition qanday qilib oldini olishimiz mumkin?**
- **Lock nima?**
- **ReentrantLock qanday class?**
- **ReentrantLock va synchronized keyword o'rtasidagi farq?**
- **ReentrantLock classning synchronized keyworddan qanday afzalliklari bor?**

</details>

### Lesson 2.2 (Condition Objects)
<details>
<summary>Lesson 2.2 (Condition Objects - Shart ob'ektlari)</summary>

- **Condition nima?**
- **Condition interface nima uchun ishlatilishini tushuntirib bering.**

</details>

### Lesson 2.3 (Synchronized Method and Blocks)
<details>
<summary>Lesson 2.3 (Synchronized Method and Blocks - Sinxronlashgan metod va bloklar)</summary>

- **Synchronized nima?**
- **Necha xil levelda synchronized keyword ishlatishimiz mumkin?**
- **Nima uchun wait() va notify() metodlar synchronized blokdan chaqiriladi?**
- **Synchronized method va synchronized block farqi?**
- **Static synchronized method bilan synchronized method farqi?**

</details>

### Lesson 2.4 (Volatile)
<details>
<summary>Lesson 2.4 (Volatile - O'zgaruvchan)</summary>

- **Volatile nima?**
- **Volatile keywordni nimalarga nisbatan qo'llashimiz mumkin?**
- **Volatile keyword classni thread-safe qiladimi?**
- **Volatile keywordning afzalliklari va kamchiliklari?**

</details>

### Lesson 2.5 (Deadlock)
<details>
<summary>Lesson 2.5 (Deadlock - Blokirovka)</summary>

- **Deadlock nima? Misol keltiring.**
- **Thread Deadlock holatiga tushib qolmasligi uchun nima qilishimiz kerak?**
- **Livelock va Deadlock o'rtasidagi farq?**

</details>

---

## Lesson 3 - Concurrency Utilities (Parallelik vositalari)

### Lesson 3.1 (Atomics)
<details>
<summary>Lesson 3.1 (Atomics - Atomik operatsiyalar)</summary>

- **Atomics nima?**
- **Nima uchun Atomic Classlardan foydalanishimiz kerak?**
- **Atomic Operation qanday ishlaydi?**
- **CAS nima? CAS qanday ishlashini tushuntirib bering.**
- **Atomic classlar threadlarni blocklamasdan turib classni thread-safe qila oladimi?**
- **Atomic classlarning afzalliklari?**

</details>

### Lesson 3.2 (Thread-safe collections)
<details>
<summary>Lesson 3.2 (Thread-safe collections - Thread-xavfsiz to'plamlar)</summary>

- **Java-da necha xil yo'l bilan classni thread-safe qilishimiz mumkin?**
- **Java-da qanday thread-safe collectionlar bor?**
- **ConcurrentHashMap nima?**
- **ArrayList ni thread-safe qilishimiz mumkinmi?**

</details>

### Lesson 3.3 (Immutable class)
<details>
<summary>Lesson 3.3 (Immutable class - O'zgarmas class)</summary>

- **Immutable class nima?**
- **Immutable classni o'zimiz yaratishimiz mumkinmi?**
- **Mumkin bo'lsa, qanday qilib yaratamiz?**
- **Java-dagi immutable classlarni sanab bering?**
- **Immutable classlar thread-safe mi?**
- **Thread-safe bo'lsa, nima uchun?**

</details>

---

## Lesson 4 - Thread Pools (Thread havzalari)

### Lesson 4.1 (Tasks and Thread Pools)
<details>
<summary>Lesson 4.1 (Tasks and Thread Pools - Vazifalar va Thread havzalari)</summary>

- **Thread Pools nima?**
- **Executor Framework qanday framework?**
- **Executor Framework nima maqsadda Java 5 versiyasida qo'shilgan?**
- **Executorlar qanday ishlashini tushuntirib bering.**
- **Executor Framework afzalliklari?**
- **Java-da necha xil Executor mavjud?**
- **Executor tasklarni nimada saqlaydi?**
- **Executorlarni necha xil usulda o'chirishimiz mumkin?**

</details>

### Lesson 4.2 (Callable and Future)
<details>
<summary>Lesson 4.2 (Callable and Future)</summary>

- **Callable nima?**
- **Future nima?**
- **Callable va Runnable o'rtasidagi farq?**
- **FutureTask nima?**
- **Future classning isDone() metodi nima uchun ishlatiladi?**
- **Future classning get() metodi nima uchun ishlatiladi?**

</details>

### Lesson 4.3 (ThreadLocal class)
<details>
<summary>Lesson 4.3 (ThreadLocal class)</summary>

- **ThreadLocal nima?**
- **ThreadLocalRandom nima?**
- **ThreadLocal qanday holatlarda foydalanishimiz kerak?**
- **ThreadLocal withInitial() static method nima uchun ishlatiladi?**

</details>

---

## Lesson 5 - Advanced Concurrency (Murakkab parallelik)

### Lesson 5.1 (Fork Join Pool)
<details>
<summary>Lesson 5.1 (Fork Join Pool - Bo'lish va birlashtirish havzasi)</summary>

- **Fork Join Framework nima?**
- **Fork Join Framework nima uchun Java-ga qo'shilgan?**
- **Fork Join Frameworkning afzalliklari?**
- **Fork Join Framework tasklarni navbatga qo'yish uchun qaysi queue dan foydalanadi?**
- **Fork Join Framework va Executor Framework o'rtasidagi farq?**

</details>

### Lesson 5.2 (Asynchronous Computations)
<details>
<summary>Lesson 5.2 (Asynchronous Computations - Asinxron hisoblashlar)</summary>

- **Asynchronous programming nima?**
- **CompletableFuture nima?**
- **CompletableFuture nima uchun ishlatiladi?**
- **CompletableFuture va Future o'rtasidagi farq?**
- **CompletableFuture thenApply() metodi nima uchun ishlatiladi?**
- **CompletableFuture thenCompose() metodi nima uchun ishlatiladi?**

</details>

### Lesson 5.3 (Singleton Design Pattern Issue with Multithreading)
<details>
<summary>Lesson 5.3 (Singleton Design Pattern Issue with Multithreading - Singleton pattern va multithreading muammolari)</summary>

- **Singleton Design Pattern nima?**
- **Singleton patternni multithreading muhitida qanday xavfsiz qilish mumkin?**

</details>

---

## Lesson 6 - Date and Time API (Sana va vaqt API)

### Lesson 6.1 (Date and Calendar classes)
<details>
<summary>Lesson 6.1 (Date and Calendar classes - Eski sana va vaqt classlari)</summary>

- **Date nima?**
- **Calendar nima?**
- **Calendar va Date classlarini nima uchun ishlatamiz?**
- **Date classning kamchiliklari?**
- **Calendar classning kamchiliklari?**
- **SimpleDateFormat nima?**
- **SimpleDateFormat format() metodi nima uchun ishlatiladi?**

</details>

### Lesson 6.2 (Time API)
<details>
<summary>Lesson 6.2 (Time API - Java 8 vaqt API)</summary>

- **Time API nima?**
- **Time API nima uchun Java 8 ga qo'shilgan?**
- **Duration nima?**
- **Period nima?**
- **Date va LocalDate o'rtasidagi farq?**
- **Date va ZonedDateTime o'rtasidagi farq?**
- **Time va LocalTime o'rtasidagi farq?**

</details>

---

## Lesson 7 - Input/Output (Kiritish/Chiqarish)

### Lesson 7.1 (Input/Output Streams)
<details>
<summary>Lesson 7.1 (Input/Output Streams - Kiritish/chiqarish oqimlari)</summary>

- **Input/Output Stream nima?**
- **File class nima?**
- **FileInputStream va FileOutputStream classlarini tushuntirib bering?**
- **DataInputStream va DataOutputStream classlarini tushuntirib bering?**
- **FileReader va FileWriter classlari nima uchun ishlatiladi?**
- **BufferedReader va BufferedWriter classlari nima uchun ishlatiladi?**
- **FileReader/FileWriter va BufferedReader/BufferedWriter o'rtasidagi farq?**

</details>

### Lesson 7.2 (NIO)
<details>
<summary>Lesson 7.2 (NIO - New I/O)</summary>

- **NIO nima?**
- **NIO nima uchun Java 7 da o'zgartirishlar kiritildi?**
- **Oddiy I/O stream bilan NIO o'rtasidagi farq?**

</details>

### Lesson 7.3 (Serialization and Deserialization)
<details>
<summary>Lesson 7.3 (Serialization and Deserialization)</summary>

- **Serialization nima?**
- **Deserialization nima?**
- **Externalization nima?**
- **Externalizable va Serializable interfacelari o'rtasidagi farq?**
- **SerialVersionUID nima?**
- **Marker interface nima?**
- **transient nima?**
- **static o'zgaruvchilar serialize bo'ladimi?**

</details>

---

## Lesson 8 - Regular Expressions (Regex)

### Lesson 8.1 (Regexp)
<details>
<summary>Lesson 8.1 (Regexp - Regular Expressions)</summary>

- **Regular Expression nima?**
- **Regular Expression nima uchun ishlatiladi?**
- **Pattern nima?**
- **Matcher nima?**
- **Pattern classining matcher() metodi nima uchun ishlatiladi?**
- **Matcher classining matches() metodi nima uchun ishlatiladi?**
- **Matcher classining find() metodi nima uchun ishlatiladi?**

</details>

---

## Lesson 9 - Version Control (Versiya nazorati)

### Lesson 9.1 (Git)
<details>
<summary>Lesson 9.1 (Git - Versiya nazorat tizimi)</summary>

- **Git nima? Uni qanday ishlatishimiz mumkin?**
- **Version control nima?**
- **Git bizga nima uchun kerak?**
- **Git 'pull request' va 'push request' o'rtasida qanday farq bor?**

</details>

### Lesson 9.2 (Github)
<details>
<summary>Lesson 9.2 (Github)</summary>

- **GitHub nima?**
- **Git va GitHub o'rtasidagi farq?**
- **Git da merge qilish nima?**
- **Git repository nima?**
- **Git clone nima qiladi?**

</details>

---

## Lesson 10 - Logging

### Lesson 10 (Logging)
<details>
<summary>Lesson 10 (Logging - Qayd yozish)</summary>

- **Logging nima?**
- **Log tashlash bizga nima uchun kerak?**
- **Logging Java nechinchi versiyasida qo'shilgan?**
- **Necha xil log level bor?**

</details>

---

**Keyingi modul:** [5-Modul Intervyu Savollari](../Module%205/README.md)  
**[Mundarijaga qaytish](../../README.md)**

> O'rganishda davom etamiz! 🚀
