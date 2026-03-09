# Java Amaliy Mashqlar To'plami - 3-Modul: Collections va DSA

## Mundarija
- [Exceptions (Istisnolar)](#exceptions-istisnolar)
- [Generics (Umumlashtirilgan tiplar)](#generics-umumlashtirilgan-tiplar)
- [List Interface](#list-interface)
- [LinkedList Data Structure](#linkedlist-data-structure)
- [Set Interface](#set-interface)
- [Queue Data Structure](#queue-data-structure)
- [Map Interface](#map-interface)
- [Dictionary Data Structure](#dictionary-data-structure)
- [Views (Ko'rinishlar)](#views-koʻrinishlar)
- [Algorithms (Algoritmlar)](#algorithms-algoritmlar)
- [Legacy Collections](#legacy-collections)

---

## Exceptions (Istisnolar)

<details>
<summary><b>1. Oddiy Exception yaratish va tutish</b></summary>

**Misol:** Sonni 0 ga bo'lish xatoligini ushlash.

**Berilgan:** Foydalanuvchi ikkita son kiritadi. Ikkinchi son 0 bo'lsa, xatolikni ushlab, "0 ga bo'lish mumkin emas" xabarini chiqaring.

**Talab:** `try-catch` blokidan foydalaning. `ArithmeticException` ni ushlang.

</details>

<details>
<summary><b>2. Bir nechta Exception turlarini ushlash</b></summary>

**Misol:** Array va String bilan ishlashda uchraydigan xatoliklarni ushlash.

**Berilgan:** 
- 5 elementli massiv yarating. Foydalanuvchi indeks kiritadi va shu indeksdagi elementni chiqaring.
- Foydalanuvchi matn kiritadi va uni integerga o'tkazing.

**Talab:** `ArrayIndexOutOfBoundsException` va `NumberFormatException` larni ushlang. Har bir xatolik uchun alohida catch bloki yozing.

</details>

<details>
<summary><b>3. try-catch-finally bloki</b></summary>

**Misol:** Fayl ochish va yopish operatsiyalarini bajarish.

**Berilgan:** Fayldan ma'lumot o'qishga urinib ko'ring. Fayl mavjud bo'lmasa, xatolikni ushlang. Finally blokida "Dastur yakunlandi" xabarini chiqaring.

**Talab:** Faylni ochishda `FileNotFoundException` ni ushlang. Finally bloki har doim bajarilishini tekshiring.

</details>

<details>
<summary><b>4. try-with-resources</b></summary>

**Misol:** Faylga matn yozish va o'qish operatsiyalarini try-with-resources bilan bajarish.

**Berilgan:** Foydalanuvchi kiritgan matnni faylga yozing va keyin o'qing.

**Talab:** `try-with-resources` dan foydalanib, resurslarni avtomatik yoping. Java 7+ xususiyatidan foydalaning.

</details>

<details>
<summary><b>5. Custom Exception yaratish</b></summary>

**Misol:** Bank hisobidan pul yechish uchun custom exception yarating.

**Berilgan:**
- BankAccount class'i (balance field)
- withdraw(double amount) metodi
- Agar amount > balance bo'lsa, `InsufficientFundsException` ni tashlang

**Talab:** Custom exception class'ingizni yarating (checked yoki unchecked). Exception message'da qancha pul yetishmasligini ko'rsating.

</details>

<details>
<summary><b>6. Exception Propagation</b></summary>

**Misol:** Bir nechta metodlar zanjirida exceptionning tarqalishini ko'rsating.

**Berilgan:**
- methodA() -> methodB() -> methodC() chaqiradi
- methodC() da exception tashlanadi
- methodA() da exception ushlanadi

**Talab:** Exception qanday tarqalishini stack trace orqali ko'rsating.

</details>

<details>
<summary><b>7. Checked vs Unchecked Exceptions</b></summary>

**Misol:** Checked va unchecked exceptionlar farqini ko'rsating.

**Berilgan:**
- Checked exception: `IOException` (fayl o'qish)
- Unchecked exception: `NullPointerException` (null object)

**Talab:** Checked exceptionni ushlash majburiy, unchecked ixtiyoriy ekanligini ko'rsating.

</details>

---

## Generics (Umumlashtirilgan tiplar)

<details>
<summary><b>8. Generic Class yaratish</b></summary>

**Misol:** Generic `Box<T>` class'ini yarating.

**Berilgan:**
- `private T content`
- `void set(T content)`
- `T get()`

**Talab:** Box class'ini String, Integer, Double va boshqa tiplar bilan ishlating.

</details>

<details>
<summary><b>9. Generic Method</b></summary>

**Misol:** Generic metod yaratib, massiv elementlarini chiqaruvchi dastur tuzing.

**Berilgan:**
```java
public static <T> void printArray(T[] array) {
    // massiv elementlarini chiqarish
}
```

**Talab:** Metodni turli tipdagi massivlar bilan ishlating (String[], Integer[], Double[]).

</details>

<details>
<summary><b>10. Bounded Type Parameters</b></summary>

**Misol:** Faqat Number va uning subclasslari bilan ishlaydigan generic class yarating.

**Berilgan:**
```java
class NumberBox<T extends Number> {
    private T number;
    
    double getSquare() {
        // number ni doubleValue() ga o'tkazib, kvadratini hisoblash
    }
}
```

**Talab:** Class'ni Integer, Double bilan ishlating. String bilan ishlatishga urinib, xatolikni ko'ring.

</details>

<details>
<summary><b>11. Multiple Bounds</b></summary>

**Misol:** Bir nechta interfeyslarni implement qilgan generic class yarating.

**Berilgan:**
```java
class Data<T extends Comparable<T> & Serializable> {
    private T data;
    // Comparable va Serializable metodlaridan foydalanish
}
```

**Talab:** Shartga mos keladigan class yarating (masalan, Person class'ini).

</details>

<details>
<summary><b>12. Wildcard Types</b></summary>

**Misol:** Wildcard (? extends, ? super) yordamida generic metodlar yarating.

**Berilgan:**
- `double sumOfNumbers(List<? extends Number> list)`
- `void addNumbers(List<? super Integer> list)`

**Talab:** Birinchi metodda Number subclasslari ro'yxatini, ikkinchisida Integer yoki uning superclasslarini ishlating.

</details>

<details>
<summary><b>13. Type Erasure</b></summary>

**Misol:** Type erasure tushunchasini tushuntiruvchi dastur yozing.

**Berilgan:**
```java
class Node<T> {
    private T data;
    // generic class
}

// Compile va runtime dagi farqni ko'rsatish
```

**Talab:** Generic class va raw type o'rtasidagi farqni ko'rsating. `instanceof` generic tiplar bilan ishlamasligini tekshiring.

</details>

---

## List Interface

<details>
<summary><b>14. ArrayList bilan ishlash</b></summary>

**Misol:** ArrayList yaratib, unda turli operatsiyalar bajaring.

**Berilgan:** 
- 10 ta shahar nomidan iborat ArrayList yarating
- Element qo'shish (add)
- Element o'chirish (remove)
- Elementni o'zgartirish (set)
- Elementni qidirish (indexOf, contains)
- Ro'yxatni aylanish (for, iterator)

**Talab:** Barcha operatsiyalarni bajaring va natijalarni chiqaring.

</details>

<details>
<summary><b>15. ArrayList Capacity</b></summary>

**Misol:** ArrayListning capacity va size tushunchalarini tushuntiring.

**Berilgan:**
- Yangi ArrayList yarating (default capacity 10)
- 15 ta element qo'shing
- `ensureCapacity()` va `trimToSize()` metodlarini ishlating

**Talab:** Har bir bosqichda size va capacity ni ko'rsating (reflection orqali olish mumkin).

</details>

<details>
<summary><b>16. List Convertatsiyasi</b></summary>

**Misol:** List ni array ga va array ni list ga o'tkazish.

**Berilgan:**
- String[] → List<String> (Arrays.asList())
- List<String> → String[] (toArray())

**Talab:** Ikkala yo'nalishda ham o'tkazishni bajaring. Olingan listni o'zgartirish mumkinligini tekshiring.

</details>

<details>
<summary><b>17. List Saralash</b></summary>

**Misol:** List elementlarini turli usullarda saralash.

**Berilgan:** 
- 10 ta butun sonli list
- 10 ta talaba (ism, baho) dan iborat list

**Talab:**
- Collections.sort() yordamida saralash
- List.sort() yordamida saralash
- Comparator yordamida saralash (nested comparator)

</details>

---

## LinkedList Data Structure

<details>
<summary><b>18. LinkedList asoslari</b></summary>

**Misol:** LinkedList yaratib, unda turli operatsiyalar bajaring.

**Berilgan:**
- 5 ta elementdan iborat LinkedList yarating
- Boshiga, oxiriga va o'rtasiga element qo'shing
- Boshidan, oxiridan va o'rtasidan element o'chiring

**Talab:** Har bir operatsiya vaqtida listni chiqarib turing. ArrayList bilan solishtiring.

</details>

<details>
<summary><b>19. LinkedList vs ArrayList Performance</b></summary>

**Misol:** LinkedList va ArrayList ning performance farqini o'lchash.

**Berilgan:**
- 100,000 elementli list yarating
- Boshiga element qo'shish
- Oxiriga element qo'shish
- O'rtasidan element qo'shish
- Element qidirish

**Talab:** Har bir operatsiya vaqtini nanoTime() bilan o'lchab, solishtiring.

</details>

<details>
<summary><b>20. Stack va Queue sifatida LinkedList</b></summary>

**Misol:** LinkedList dan stack (LIFO) va queue (FIFO) sifatida foydalanish.

**Berilgan:**
- Stack: push, pop, peek
- Queue: offer, poll, peek

**Talab:** LinkedList ning `push()`, `pop()`, `poll()`, `offer()` metodlaridan foydalaning.

</details>

<details>
<summary><b>21. Doubly LinkedList Implementatsiyasi</b></summary>

**Misol:** O'z qo'lingiz bilan oddiy doubly linked list yarating.

**Berilgan:**
```java
class Node {
    int data;
    Node prev;
    Node next;
    
    Node(int data) { ... }
}

class MyLinkedList {
    private Node head;
    private Node tail;
    
    void addFirst(int data) { ... }
    void addLast(int data) { ... }
    void removeFirst() { ... }
    void removeLast() { ... }
    void printForward() { ... }
    void printBackward() { ... }
}
```

**Talab:** Barcha metodlarni implement qiling.

</details>

---

## Set Interface

<details>
<summary><b>22. HashSet xususiyatlari</b></summary>

**Misol:** HashSet yaratib, uning xususiyatlarini o'rganing.

**Berilgan:**
- 10 ta element (ba'zilari dublikat) qo'shing
- Elementlarni chiqaring (tartibni kuzating)
- null qo'shib ko'ring

**Talab:** HashSet dublikatlarni saqlamasligini, tartibni kafolatlamasligini tekshiring.

</details>

<details>
<summary><b>23. LinkedHashSet</b></summary>

**Misol:** LinkedHashSet yaratib, uning xususiyatlarini o'rganing.

**Berilgan:**
- 10 ta element qo'shing
- Elementlarni qo'shish tartibida chiqarish
- HashSet bilan solishtiring

**Talab:** LinkedHashSet qo'shish tartibini saqlashini tekshiring.

</details>

<details>
<summary><b>24. TreeSet va Comparable</b></summary>

**Misol:** TreeSet yaratib, elementlarni saralash.

**Berilgan:**
- 10 ta butun son qo'shing
- 10 ta talaba (ism, baho) qo'shing (Comparable implement qilgan)

**Talab:** TreeSet elementlarni natural orderda saqlashini tekshiring. Custom Comparator yordamida saralashni o'zgartiring.

</details>

<details>
<summary><b>25. Set amallari</b></summary>

**Misol:** Ikki set ustida union, intersection, difference amallarini bajarish.

**Berilgan:**
```java
Set<Integer> set1 = new HashSet<>(Arrays.asList(1, 2, 3, 4, 5));
Set<Integer> set2 = new HashSet<>(Arrays.asList(4, 5, 6, 7, 8));
```

**Talab:**
- Union: barcha elementlar
- Intersection: umumiy elementlar
- Difference: set1 - set2
- Symmetric difference: (set1 - set2) ∪ (set2 - set1)

</details>

<details>
<summary><b>26. HashSet internal structure</b></summary>

**Misol:** HashSet ning `add()` metodi qanday ishlashini tushuntiruvchi dastur.

**Berilgan:**
- 10 ta String qo'shing
- `hashCode()` va `equals()` metodlarini override qilingan class yarating

**Talab:** `hashCode()` va `equals()` contract larini buzganda nima bo'lishini ko'rsating.

</details>

---

## Queue Data Structure

<details>
<summary><b>27. Queue asoslari</b></summary>

**Misol:** Queue yaratib, unda asosiy operatsiyalarni bajaring.

**Berilgan:**
- `LinkedList` yordamida Queue yarating
- 5 ta element qo'shing (`offer()`)
- Elementlarni oling (`poll()`)
- Elementlarni ko'ring (`peek()`)

**Talab:** Queue bo'sh bo'lganda poll va peek farqini ko'rsating.

</details>

<details>
<summary><b>28. PriorityQueue</b></summary>

**Misol:** PriorityQueue yaratib, elementlarni priority bo'yicha chiqarish.

**Berilgan:**
- 10 ta butun son qo'shing
- 10 ta vazifa (priority va name) qo'shing

**Talab:** PriorityQueue elementlarni natural orderda chiqarishini ko'rsating. Custom Comparator yordamida priority ni o'zgartiring.

</details>

<details>
<summary><b>29. Deque (Double-ended Queue)</b></summary>

**Misol:** ArrayDeque yaratib, unda turli operatsiyalar bajaring.

**Berilgan:**
- Boshiga va oxiriga element qo'shish (`addFirst`, `addLast`)
- Boshidan va oxiridan element olish (`removeFirst`, `removeLast`)
- Stack (LIFO) sifatida ishlatish
- Queue (FIFO) sifatida ishlatish

**Talab:** ArrayDeque ni stack va queue sifatida ishlatib ko'ring.

</details>

<details>
<summary><b>30. Producer-Consumer</b></summary>

**Misol:** Queue yordamida oddiy producer-consumer tizimi yarating.

**Berilgan:**
- BlockingQueue dan foydalaning
- Producer thread: har sekundda element qo'shadi
- Consumer thread: elementlarni olib, chiqaradi

**Talab:** Queue to'lganda va bo'shaganda threadlar bloklanishini kuzating.

</details>

---

## Map Interface

<details>
<summary><b>31. HashMap asoslari</b></summary>

**Misol:** HashMap yaratib, unda turli operatsiyalar bajaring.

**Berilgan:**
- 10 ta talaba (ID, ism) ni saqlang
- Element qo'shish (`put`)
- Element olish (`get`)
- Element mavjudligini tekshirish (`containsKey`, `containsValue`)
- Element o'chirish (`remove`)
- Barcha keylarni olish (`keySet`)
- Barcha valuelarni olish (`values`)

**Talab:** Har bir operatsiyani bajaring va natijalarni chiqaring.

</details>

<details>
<summary><b>32. HashMap collision</b></summary>

**Misol:** HashMap da collision qanday hal qilinishini ko'rsating.

**Berilgan:**
- `hashCode()` ni doim 1 qaytaradigan class yarating
- 10 ta shunday obyektni HashMap ga qo'shing

**Talab:** Barcha elementlar bitta bucket ga tushishini kuzating. Java 8+ da linked list va tree o'rtasidagi o'tishni kuzating.

</details>

<details>
<summary><b>33. LinkedHashMap</b></summary>

**Misol:** LinkedHashMap yaratib, uning ikki xil tartibini ko'rsating.

**Berilgan:**
- Insertion order (default)
- Access order (`accessOrder=true`)

**Talab:** Access order da elementga murojaat qilish tartibni o'zgartirishini ko'rsating.

</details>

<details>
<summary><b>34. TreeMap</b></summary>

**Misol:** TreeMap yaratib, elementlarni saralangan holda saqlash.

**Berilgan:**
- 10 ta talaba (ID, ism) ni qo'shing
- Key lar bo'yicha saralangan holda chiqaring
- Custom Comparator yordamida value lar bo'yicha saralash

**Talab:** TreeMap Red-Black tree asosida ishlashini tushuntiring.

</details>

<details>
<summary><b>35. WeakHashMap</b></summary>

**Misol:** WeakHashMap da garbage collector qanday ishlashini ko'rsating.

**Berilgan:**
- Key lar uchun weak reference ishlatiladi
- Key larni null qilganda, element avtomatik o'chadi

**Talab:** WeakHashMap va HashMap farqini ko'rsating. GC ishlaganda WeakHashMap dan elementlar o'chishini kuzating.

</details>

<details>
<summary><b>36. Word Count</b></summary>

**Misol:** Matndagi so'zlarning chastotasini hisoblovchi dastur yozing.

**Berilgan:**
```java
String text = "Java is great. Java is powerful. I love Java!";
```

**Talab:** Map<String, Integer> yordamida har bir so'z necha marta takrorlanganini hisoblang.

</details>

<details>
<summary><b>37. Grouping by</b></summary>

**Misol:** Talabalarni baholariga qarab guruhlash.

**Berilgan:**
- 20 ta talaba (ism, baho)
- Map<Integer, List<Student>> yarating

**Talab:** computeIfAbsent() metodidan foydalanib, talabalarni baholariga qarab guruhlang.

</details>

---

## Dictionary Data Structure

<details>
<summary><b>38. Hashtable (Legacy)</b></summary>

**Misol:** Hashtable yaratib, uning xususiyatlarini o'rganing.

**Berilgan:**
- Hashtable<String, String> yarating
- 5 ta element qo'shing
- null key va null value qo'shib ko'ring

**Talab:** Hashtable thread-safe ekanligini, null qiymatlarni qabul qilmasligini tekshiring. HashMap bilan solishtiring.

</details>

<details>
<summary><b>39. Properties class</b></summary>

**Misol:** Properties class yordamida konfiguratsiya faylini o'qish va yozish.

**Berilgan:**
- app.properties fayli yarating (database.url, database.username, database.password)
- Properties class yordamida faylni o'qing
- Yangi property qo'shing va faylga yozing

**Talab:** Properties fayl bilan ishlashni ko'rsating.

</details>

---

## Views (Koʻrinishlar)

<details>
<summary><b>40. Unmodifiable Views</b></summary>

**Misol:** Collections.unmodifiableList() yordamida o'zgarmas view yaratish.

**Berilgan:**
- ArrayList yarating va to'ldiring
- `Collections.unmodifiableList()` orqali view yarating
- View ni o'zgartirishga urinib ko'ring

**Talab:** Unmodifiable view ni o'zgartirishga urinish `UnsupportedOperationException` tashlashini ko'rsating.

</details>

<details>
<summary><b>41. SubList View</b></summary>

**Misol:** List ning subList() metodi orqali view yaratish.

**Berilgan:**
- 10 elementli list yarating
- `subList(3, 7)` orqali view oling
- View ni o'zgartiring va asl listga ta'sirini kuzating

**Talab:** View orqali qilingan o'zgarishlar asl listga ta'sir qilishini ko'rsating.

</details>

<details>
<summary><b>42. Checked Collections</b></summary>

**Misol:** Collections.checkedList() yordamida type-safe view yaratish.

**Berilgan:**
- `Collections.checkedList(new ArrayList(), String.class)` orqali list yarating
- List ga String qo'shing
- List ga Integer qo'shishga urinib ko'ring

**Talab:** Checked collection noto'g'ri tipdagi element qo'shishni `ClassCastException` bilan rad etishini ko'rsating.

</details>

---

## Algorithms (Algoritmlar)

<details>
<summary><b>43. Binary Search</b></summary>

**Misol:** Collections.binarySearch() yordamida qidiruv.

**Berilgan:**
- Saralangan list yarating
- Mavjud va mavjud bo'lmagan elementlarni qidiring

**Talab:** binarySearch() dan oldin list saralangan bo'lishi kerakligini tushuntiring.

</details>

<details>
<summary><b>44. Shuffle va Reverse</b></summary>

**Misol:** Collections.shuffle() va Collections.reverse() metodlaridan foydalanish.

**Berilgan:**
- 1 dan 10 gacha sonlardan iborat list yarating
- List ni aralashtiring (shuffle)
- List ni teskari tartibda chiqaring (reverse)

</details>

<details>
<summary><b>45. Frequency va Disjoint</b></summary>

**Misol:** Collections.frequency() va Collections.disjoint() metodlaridan foydalanish.

**Berilgan:**
```java
List<Integer> list1 = Arrays.asList(1, 2, 3, 4, 5, 2, 3, 2);
List<Integer> list2 = Arrays.asList(6, 7, 8);
List<Integer> list3 = Arrays.asList(3, 4, 5);
```

**Talab:**
- `frequency()` yordamida 2 soni necha marta takrorlanganini toping
- `disjoint()` yordamida list1 va list2 umumiy elementga ega emasligini, list1 va list3 esa ega ekanligini tekshiring

</details>

<details>
<summary><b>46. Min, Max, Swap</b></summary>

**Misol:** Collections.min(), Collections.max(), Collections.swap() metodlaridan foydalanish.

**Berilgan:**
- 10 ta butun sonli list yarating
- Min va max elementlarni toping
- Birinchi va oxirgi elementlarni almashtiring

</details>

<details>
<summary><b>47. Rotate</b></summary>

**Misol:** Collections.rotate() yordamida list elementlarini aylantirish.

**Berilgan:**
- 1 dan 10 gacha sonlardan iborat list
- List ni 3 pozitsiyaga o'ngga aylantiring

**Talab:** rotate() metodidan foydalanib, elementlarni ko'chiring.

</details>

---

## Legacy Collections

<details>
<summary><b>48. Vector vs ArrayList</b></summary>

**Misol:** Vector va ArrayList performance va thread-safety farqini ko'rsating.

**Berilgan:**
- Vector va ArrayList yarating
- Har ikkalasiga 1 million element qo'shing
- Vaqtni o'lchang
- Bir nechta thread bilan ishlang

**Talab:** Vector thread-safe, ArrayList esa not ekanligini ko'rsating. Vector sekinroq ishlashini tushuntiring.

</details>

<details>
<summary><b>49. Stack</b></summary>

**Misol:** Stack (LIFO) ma'lumotlar tuzilmasi bilan ishlash.

**Berilgan:**
- Stack yarating
- 5 ta element qo'shing (`push`)
- Elementlarni oling (`pop`)
- Elementni ko'ring (`peek`)
- Stack bo'shligini tekshiring (`empty`)

**Talab:** Qavslarni tekshiruvchi dastur yozing: "({[]})" -> true, "({[)]}" -> false

</details>

<details>
<summary><b>50. Dictionary (Legacy)</b></summary>

**Misol:** Dictionary abstract class'idan foydalanish (Hashtable).

**Berilgan:**
- Dictionary<String, String> dictionary = new Hashtable<>()
- Element qo'shish (`put`)
- Element olish (`get`)
- Elementlarni chiqarish

**Talab:** Dictionary legacy ekanligini, uning o'rniga Map ishlatilishini tushuntiring.

</details>

<details>
<summary><b>51. Enumeration vs Iterator</b></summary>

**Misol:** Enumeration va Iterator farqini ko'rsating.

**Berilgan:**
- Vector yarating va to'ldiring
- `elements()` orqali Enumeration oling
- `iterator()` orqali Iterator oling
- Har ikkalasi bilan elementlarni aylaning

**Talab:** Iterator da remove() metodi borligini, Enumeration da esa yo'qligini ko'rsating.

</details>

<details>
<summary><b>52. BitSet</b></summary>

**Misol:** BitSet yordamida bitlarni boshqarish.

**Berilgan:**
- BitSet yarating
- 2, 4, 6, 8, 10 indekslaridagi bitlarni 1 ga o'rnating
- 1 dan 10 gacha bo'lgan toq sonlarni boshqa BitSet ga o'rnating
- AND, OR, XOR operatsiyalarini bajaring

**Talab:** BitSet dan foydalanib, tub sonlarni topuvchi dastur yozing (Eratosthen elagi).

</details>

---

## Mashqlar Statistikasi

| Bo'lim | Mashqlar soni |
|--------|---------------|
| Exceptions | 7 ta |
| Generics | 6 ta |
| List Interface | 4 ta |
| LinkedList | 4 ta |
| Set Interface | 5 ta |
| Queue | 4 ta |
| Map Interface | 7 ta |
| Dictionary | 2 ta |
| Views | 3 ta |
| Algorithms | 5 ta |
| Legacy Collections | 5 ta |
| **Jami** | **52 ta** |

---

**[Mundarijaga qaytish](#-mundarija)**

> Har bir mashqni mustaqil bajarishga harakat qiling! Collections va DSA ni amaliyotda qo'llash orqali mustahkamlang. 🚀
