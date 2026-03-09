# 04 - List Interface

## List Interface nima?

**List Interface** - bu elementlarni tartiblangan (ordered) tarzda saqlash uchun mo'ljallangan interface. Foydalanuvchi har bir element qaerga joylashishini aniq nazorat qilishi mumkin.

**Asosiy xususiyatlari:**
- Elementlar indeks (tartib raqami) bo'yicha mavjud
- Takrorlangan elementlarga ruxsat beriladi
- Elementlarni qidirish mumkin

**Concrete implementation'lar:**
1. **ArrayList** - Dinamik array asosida
2. **LinkedList** - Linked list asosida
3. **Vector** - Thread-safe dynamic array (eski, deprecated)
4. **Stack** - LIFO (Last In First Out) strukturasi

**Eslatma:** Vector class'i JDK 1.5 dan beri deprecated hisoblanadi.

## ListInterfaceTest - List Interface Misoli

```java
package collectionsframework.list;

import java.util.Comparator;
import java.util.List;

public class ListInterfaceTest {
    public static void main(String[] args) {
        // List.of() - Java 9+ da immutable list yaratish
        List<Integer> integers = List.of(12, 45, 90, 12);
        
        // Asosiy metodlar:
        System.out.println("Element 0: " + integers.get(0));        // 12
        System.out.println("Contains 1: " + integers.contains(1));  // false
        System.out.println("First index of 12: " + integers.indexOf(12));     // 0
        System.out.println("Last index of 12: " + integers.lastIndexOf(12));  // 3
        System.out.println("Is empty: " + integers.isEmpty());      // false
        System.out.println("Size: " + integers.size());             // 4
        
        // Immutable list - sort qilish mumkin emas
        // integers.sort(Comparator.naturalOrder()); //  UnsupportedOperationException
    }
}
```

**Vazifasi:** List interface'ning asosiy metodlarini ko'rsatish.

**Muhim:** `List.of()` Java 9+ da immutable (o'zgartirib bo'lmaydigan) list yaratadi.

## ArrayList Class

**ArrayList** - xotirada kerak bo'lganda kengayadigan yoki qisqaydigan dinamik massiv.

**Xususiyatlari:**
- **Dinamik massiv** - Ichki ko'rinishda array ishlatadi (Java 1.2 dan beri)
- **Zero-based index** - Elementlar 0 dan boshlangan indeks bilan joylashadi
- **Avtomatik kengayish** - Sig'im oshsa, yangi katta massiv yaratiladi
- **Capacity va Size** - Capacity avtomatik qisqarmaydi, faqat size qisqaradi

## ArrayListTest - ArrayList Misollari

```java
package collectionsframework.list;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.UUID;

public class ArrayListTest {
    public static void main(String[] args) {
        // 1. ArrayList yaratish
        ArrayList<Integer> integers1 = new ArrayList<>();
        integers1.add(123);
        integers1.add(188);
        integers1.add(8);
        integers1.add(176);
        
        // 2. Boshqa listdan ArrayList yaratish (copy constructor)
        ArrayList<Integer> integers2 = new ArrayList<>(integers1);
        integers2.add(34);
        
        System.out.println("integers2: " + integers2); // [123, 188, 8, 176, 34]
        
        // 3. Index bo'yicha element qo'shish
        integers2.add(0, 45); // Boshiga qo'shish
        System.out.println("0-indexga 45 qo'shildi: " + integers2);
        
        // 4. Elementni o'zgartirish (replace)
        integers2.set(0, 90); // 0-indexdagi elementni 90 ga o'zgartiradi
        System.out.println("0-index 90 ga o'zgardi: " + integers2);
        
        // 5. Index bo'yicha element o'chirish
        integers2.remove(0); // 0-indexdagi element o'chirildi
        System.out.println("0-index o'chirildi: " + integers2);
        
        // 6. Qiymat bo'yicha element o'chirish
        integers2.remove(new Integer(34)); // 34 qiymatli element o'chirildi
        System.out.println("34 qiymati o'chirildi: " + integers2);
        
        // 7. Barcha elementlarni o'chirish (removeAll)
        integers2.removeAll(integers1);
        System.out.println("integers1 elementlari o'chirildi: " + integers2);
        
        // 8. Boshqa metodlar
        System.out.println("\n--- Boshqa Metodlar ---");
        
        // forEach - har bir element uchun amal bajarish
        integers1.forEach(o -> System.out.print(o + " "));
        System.out.println();
        
        // Method reference bilan
        integers1.forEach(System.out::print);
        System.out.println();
        
        // Sort qilish
        System.out.println("\n--- Sort qilish ---");
        ArrayList<Integer> numbers = new ArrayList<>(List.of(5, 2, 8, 1, 9));
        System.out.println("Avval: " + numbers);
        numbers.sort(Comparator.naturalOrder()); // O'sish tartibida
        System.out.println("Natural order: " + numbers);
        numbers.sort(Comparator.reverseOrder()); // Kamayish tartibida
        System.out.println("Reverse order: " + numbers);
        
        // 9. Custom class bilan ishlash
        ArrayList<User> users = new ArrayList<>();
        
        users.add(new User(30, "User 1"));
        users.add(new User(32, "User 2"));
        users.add(new User(16, "User 3"));
        users.add(new User(13, "User 4"));
        
        System.out.println("\n--- Users (Unsorted) ---");
        showUsers(users);
        
        // Comparable interface'i bo'yicha sort
        users.sort(Comparator.naturalOrder());
        System.out.println("\n--- Users (Sorted by age - descending) ---");
        showUsers(users);
        
        // Custom comparator bilan sort
        users.sort((u1, u2) -> u1.toString().compareTo(u2.toString()));
        System.out.println("\n--- Users (Sorted by toString) ---");
        showUsers(users);
        
        // 10. ArrayList method'lari
        System.out.println("\n--- ArrayList Method'lari ---");
        ArrayList<String> fruits = new ArrayList<>();
        
        // add() - element qo'shish
        fruits.add("Apple");
        fruits.add("Banana");
        fruits.add("Cherry");
        System.out.println("Fruits: " + fruits);
        
        // get() - element olish
        System.out.println("Element at index 1: " + fruits.get(1));
        
        // contains() - element borligini tekshirish
        System.out.println("Contains 'Apple': " + fruits.contains("Apple"));
        
        // indexOf() - element indeksini topish
        System.out.println("Index of 'Banana': " + fruits.indexOf("Banana"));
        
        // isEmpty() - bo'shlikni tekshirish
        System.out.println("Is empty: " + fruits.isEmpty());
        
        // size() - elementlar soni
        System.out.println("Size: " + fruits.size());
        
        // clear() - barcha elementlarni o'chirish
        fruits.clear();
        System.out.println("After clear - Size: " + fruits.size());
        
        // 11. Capacity bilan ishlash
        System.out.println("\n--- Capacity Management ---");
        ArrayList<Integer> withCapacity = new ArrayList<>(100); // Initial capacity = 100
        System.out.println("Initial capacity 100 bilan yaratildi");
        
        // trimToSize() - capacity ni size ga moslashtirish
        withCapacity.add(1);
        withCapacity.add(2);
        withCapacity.add(3);
        withCapacity.trimToSize(); // Capacity ni 3 ga qisqartiradi
        System.out.println("trimToSize() dan keyin");
    }
    
    private static void showUsers(ArrayList<User> users) {
        for (User user : users) {
            System.out.println(user);
        }
    }
}

// Comparable interface'ni implement qilgan class
class User implements Comparable<User> {
    private final String id;
    private final int age;
    private final String name;
    
    User(int age, String name) {
        this.id = UUID.randomUUID().toString();
        this.age = age;
        this.name = name;
    }
    
    // CompareTo - yosh bo'yicha kamayish tartibida (descending)
    @Override
    public int compareTo(User user) {
        // Teskari tartib: katta yosh -> kichik
        return Integer.compare(user.age, this.age);
        // Yoki: return -1 * Integer.compare(this.age, user.age);
    }
    
    @Override
    public String toString() {
        return "User{" +
                "id='" + id + '\'' +
                ", age=" + age +
                ", name='" + name + '\'' +
                '}';
    }
    
    // Getter metodlari
    public int getAge() { return age; }
    public String getName() { return name; }
}
```

## JavaVectorTest - Vector Class'i

```java
package collectionsframework.list;

import java.util.Vector;

public class JavaVectorTest {
    public static void main(String[] args) {
        // Vector - Thread-safe ArrayList (eski versiya)
        Vector<String> languages = new Vector<>();
        languages.add("Java");
        languages.add("Python");
        languages.add("JavaScript");
        
        System.out.println("Languages: " + languages);
        System.out.println("Size: " + languages.size());
        System.out.println("Capacity: " + languages.capacity()); // Vector'da capacity metod bor
        
        // Vector'ning o'ziga xos metodlari
        languages.addElement("C++"); // add() ga o'xshash
        languages.insertElementAt("Ruby", 1); // Index bo'yicha qo'shish
        
        System.out.println("After additions: " + languages);
        System.out.println("First element: " + languages.firstElement());
        System.out.println("Last element: " + languages.lastElement());
        
        // Element o'chirish
        languages.removeElement("Python");
        System.out.println("After removing Python: " + languages);
        
        // Vector vs ArrayList
        System.out.println("\n--- Vector vs ArrayList ---");
        
        //  Vector - Thread-safe (synchronized)
        //  Vector - Performance pastroq
        //  ArrayList - Performance yaxshi
        //  ArrayList - Thread-safe emas
        
        // Zamonaviy yondashuv: ArrayList + Collections.synchronizedList()
        // List<String> syncList = Collections.synchronizedList(new ArrayList<>());
    }
}
```

## ArrayList Performance Tahlili

```java
package collectionsframework.list;

import java.util.ArrayList;
import java.util.LinkedList;

public class PerformanceTest {
    public static void main(String[] args) {
        int size = 100000;
        
        // 1. ArrayList - Tez random access
        ArrayList<Integer> arrayList = new ArrayList<>();
        
        long start = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            arrayList.add(i); // Oxiriga qo'shish - O(1)
        }
        long arrayListAddTime = System.currentTimeMillis() - start;
        
        start = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            arrayList.get(i); // Random access - O(1)
        }
        long arrayListGetTime = System.currentTimeMillis() - start;
        
        // 2. LinkedList - Tez insert/delete
        LinkedList<Integer> linkedList = new LinkedList<>();
        
        start = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            linkedList.add(i); // Oxiriga qo'shish - O(1)
        }
        long linkedListAddTime = System.currentTimeMillis() - start;
        
        start = System.currentTimeMillis();
        for (int i = 0; i < size; i++) {
            linkedList.get(i); // Random access - O(n) - YOMON!
        }
        long linkedListGetTime = System.currentTimeMillis() - start;
        
        System.out.println("Performance Natijalari:");
        System.out.println("ArrayList add (" + size + " element): " + arrayListAddTime + "ms");
        System.out.println("ArrayList get (" + size + " element): " + arrayListGetTime + "ms");
        System.out.println("LinkedList add (" + size + " element): " + linkedListAddTime + "ms");
        System.out.println("LinkedList get (" + size + " element): " + linkedListGetTime + "ms");
        
        // Qoida: Random access kerak bo'lsa -> ArrayList
        //        Ko'p insert/delete kerak bo'lsa -> LinkedList
    }
}
```

## ArrayList va LinkedList Taqqoslash

| Xususiyat | ArrayList | LinkedList |
|-----------|-----------|------------|
| **Asosiy tuzilma** | Dynamic array | Doubly linked list |
| **Random access** | O(1) - Juda tez | O(n) - Sekin |
| **Element qo'shish** | Oxiriga: O(1), O'rtaga: O(n) | Har qaerda: O(1) |
| **Element o'chirish** | Oxiridan: O(1), O'rtadan: O(n) | Har qaerda: O(1) |
| **Memory usage** | Kamroq (faqat data) | Ko'proq (node + pointer) |
| **Use case** | Ko'p o'qish, kam o'zgartirish | Ko'p o'zgartirish |

## ArrayList bilan Ishlash Bo'yicha Maslahatlar

### 1. Initial Capacity belgilash
```java
// Agar elementlar soni ma'lum bo'lsa
List<String> list = new ArrayList<>(1000); // Capacity = 1000
```

### 2. Immutable list yaratish
```java
// Java 9+ - List.of()
List<String> immutable1 = List.of("A", "B", "C");

// Java 8+ - Collections.unmodifiableList()
List<String> immutable2 = Collections.unmodifiableList(new ArrayList<>());
```

### 3. ArrayList'ni massivga o'tkazish
```java
ArrayList<String> list = new ArrayList<>();
list.add("A");
list.add("B");

// To array - 1-usul
String[] array1 = list.toArray(new String[0]);

// To array - 2-usul (size ni oldindan bilinsa)
String[] array2 = list.toArray(new String[list.size()]);
```

### 4. Sublist yaratish (view)
```java
ArrayList<Integer> numbers = new ArrayList<>();
for (int i = 0; i < 10; i++) numbers.add(i);

// Sublist - original list'ning view'ini yaratadi
List<Integer> sublist = numbers.subList(3, 7); // [3, 4, 5, 6]
sublist.clear(); // Original list'dan ham o'chadi
```

## ArrayList Method'lari

| Method | Tavsif | Time Complexity |
|--------|---------|-----------------|
| `add(E e)` | Oxiriga element qo'shish | O(1) |
| `add(int index, E e)` | Index bo'yicha qo'shish | O(n) |
| `get(int index)` | Element olish | O(1) |
| `set(int index, E e)` | Elementni o'zgartirish | O(1) |
| `remove(int index)` | Index bo'yicha o'chirish | O(n) |
| `remove(Object o)` | Qiymat bo'yicha o'chirish | O(n) |
| `contains(Object o)` | Mavjudligini tekshirish | O(n) |
| `indexOf(Object o)` | Birinchi indeksni topish | O(n) |
| `lastIndexOf(Object o)` | Oxirgi indeksni topish | O(n) |
| `size()` | Elementlar soni | O(1) |
| `isEmpty()` | Bo'shligini tekshirish | O(1) |
| `clear()` | Barchasini o'chirish | O(n) |
| `toArray()` | Massivga o'tkazish | O(n) |
| `sort(Comparator)` | Tartiblash | O(n log n) |

## Tekshiruv Savollari

1. **List interface'ning asosiy xususiyatlari nima?**
2. **ArrayList qanday ishlaydi?**
3. **ArrayList va LinkedList farqlari nima?**
4. **Nega Vector deprecated hisoblanadi?**
5. **ArrayList'da get() va remove() metodlari qanday ishlaydi?**
6. **Initial capacity nima uchun muhim?**
7. **Immutable list qanday yaratiladi?**
8. **ArrayList performance ta'sir qiluvchi omillar nima?**

---

**Keyingi mavzu:** [05 - LinkedList Data Structure](./05_LinkedList_Data_Structure.md)  
**[Mundarijaga qaytish](../README.md)**

---

**Muhim Atamalar:**
- **List Interface** - Ro'yxat interfeysi (tartiblangan kolleksiya)
- **ArrayList** - Massiv asosidagi ro'yxat
- **LinkedList** - Bog'langan ro'yxat
- **Vector** - Thread-safe massiv (eski)
- **Capacity** - Sig'im (massiv o'lchami)
- **Size** - Hajm (elementlar soni)
- **Immutable** - O'zgarmas (o'zgartirib bo'lmaydigan)
- **Random Access** - Tasodifiy kirish (har qanday elementga tez kirish)

> **Muhim:** ArrayList Java'da eng ko'p ishlatiladigan collection class'idir. Uni to'liq o'rganish va qachon ishlatish kerakligini bilish muhim.
---

# LinkedList Ma'lumotlar Tuzilmasi

## Array (Massiv)

**Array** - bu kompyuter xotirasida bir guruh elementlarni saqlashning eng oddiy usuli. U ketma-ket xotira joyini ajratish va elementlarni ketma-ket yozishdan iborat bo'lib, ketma-ketlik oxiri maxsus NULL token bilan belgilanadi.

```
          A     B    C   D   NULL
10   11   12   13   14   15   16   17 
```

### Array Muammolari

#### 1. Ketma-ket Joylashish Talabi
Array elementlari doim ketma-ket joylashgan bo'lishi shart.

#### 2. O'lcham O'zgarganda Qiyinchilik
Array yangi element qo'shilganda va sig'imi oshganda yangi bo'sh joy izlaydi. Topgandan keyin barcha elementlar yangi xotira manziliga ko'chiriladi.

```
5    8    2    3    9    87
10   11   12   13   14   15   16   17 
```

**Muammo:** Yangi element qo'shish uchun bo'sh joy bo'lmasa, butun massiv ko'chirilishi kerak.

#### 3. Element O'chirishda Qiyinchilik
Arraydan birinchi element (5) o'chirilganda, uning o'rnini to'ldirish uchun keyingi barcha elementlar bitta pozitsiyaga siljishi kerak.

```
O'chirishdan oldin: [5, 8, 2, 3, 9]
O'chirishdan keyin: [8, 2, 3, 9]
```

**Muammo:** Agar 1000 ta element bo'lsa, 999 marta ko'chirish amalga oshirilishi kerak.

## Muammo Yechimi: LinkedList

Array'lardan farqli o'laroq, **Linked List** - bu linear data structure bo'lib, uning elementlari ketma-ket joylashmaydi. Elementlar pointer'lar yordamida bog'lanadi. Har bir node ma'lumot va keyingi node manzilini saqlaydi.

**Xususiyatlar:**
- Oxirgi node NULL saqlaydi
- Random access (tasodifiy kirish) mumkin emas

### LinkedList Turlari

#### 1. Singly Linked List (Bir yo'nalishli bog'langan ro'yxat)
```java
Node1 -> Node2 -> Node3 -> NULL
```
Faqat bitta yo'nalishda harakat qilish mumkin.

#### 2. Doubly Linked List (Ikki yo'nalishli bog'langan ro'yxat)
```java
NULL <- Node1 <-> Node2 <-> Node3 -> NULL
```
Ikkala yo'nalishda ham harakat qilish mumkin.

#### 3. Circular Linked List (Aylanma bog'langan ro'yxat)
```java
Node1 -> Node2 -> Node3 -> Node1 (back to start)
```
Oxirgi node birinchi node'ga ishora qiladi.

### LinkedList'ning Array'larga nisbatan Afzalliklari

#### 1. Dynamic Array (Dinamik massiv)
O'lcham avvaldan belgilanishi shart emas, kerak bo'lganda o'sadi.

#### 2. Oson Qo'shish/O'chirish
```java
// Qo'shish - O(1) complexity
newNode.next = current.next;
current.next = newNode;

// O'chirish - O(1) complexity
prev.next = current.next;
```

### LinkedList'ning Kamchiliklari

#### 1. Random Access Yo'q
Elementlarga ketma-ket kirish kerak. Binary search samarali emas.

#### 2. Qo'shimcha Xotira
Har bir element uchun pointer saqlash uchun qo'shimcha xotira kerak.

## Singly Linked List Amaliyoti

### SinglyLinkedList<E> Implementatsiyasi

```java
package collectionsframework.linkedlist;

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.StringJoiner;

/**
 * SinglyLinkedList - bir yo'nalishli bog'langan ro'yxat implementatsiyasi
 * @param <E> ro'yxat elementlarining turi
 */
public class SinglyLinkedList<E> implements Iterable<E> {

    private Node<E> head;  // Ro'yxat boshi
    private int size;      // Elementlar soni

    /**
     * Elementni ro'yxat oxiriga qo'shish
     * @param element qo'shiladigan element
     * @return true - har doim true qaytaradi
     */
    public boolean add(E element) {
        var newNode = new Node<>(element);
        if (this.head == null) {
            this.head = newNode;
        } else {
            var current = this.head;
            while (current.next != null)
                current = current.next;
            current.next = newNode;
        }
        this.size++;
        return true;
    }

    /**
     * Index bo'yicha elementni olish
     * @param index element indeksi
     * @return element
     * @throws IndexOutOfBoundsException agar index noto'g'ri bo'lsa
     */
    public E get(int index) {
        Objects.checkIndex(index, size);
        if (index == 0)
            return head.element;

        var current = head;
        for (int i = 1; i <= index; i++)
            current = current.next;

        return current.element;
    }

    /**
     * Elementni ro'yxat boshiga qo'shish
     * @param element qo'shiladigan element
     * @return true
     */
    public boolean addAtBeginning(E element) {
        var newNode = new Node<>(element);
        if (head != null)
            newNode.next = head;
        head = newNode;
        size++;
        return true;
    }

    /**
     * Ro'yxat boshidan elementni o'chirish
     * @return o'chirilgan element
     * @throws NoSuchElementException agar ro'yxat bo'sh bo'lsa
     */
    public E removeFromBeginning() {
        if (head == null)
            throw new NoSuchElementException("LinkedList is empty");
        E element = head.element;
        head = head.next;
        size--;
        return element;
    }

    /**
     * Index bo'yicha elementni o'chirish
     * @param index o'chiriladigan element indeksi
     * @return o'chirilgan element
     * @throws IndexOutOfBoundsException agar index noto'g'ri bo'lsa
     */
    public E remove(int index) {
        Objects.checkIndex(index, size);
        if (index == 0) return removeFromBeginning();
        
        var current = head;
        for (int i = 1; i < index; i++)
            current = current.next;
        
        var element = current.next.element;
        current.next = current.next.next;
        return element;
    }

    /**
     * Ob'ekt bo'yicha elementni o'chirish
     * @param o o'chiriladigan ob'ekt
     * @return true - agar element topilib o'chirilsa, aks holda false
     */
    public boolean remove(Object o) {
        if (head == null) return false;
        Node<E> prev = null;
        Node<E> current = head;

        while (current != null) {
            if (Objects.equals(o, current.element)) {
                if (prev == null)
                    head = current.next;
                else
                    prev.next = current.next;
                size--;
                return true;
            }
            prev = current;
            current = current.next;
        }
        return false;
    }

    /**
     * Ro'yxatdagi elementlar sonini qaytarish
     * @return elementlar soni
     */
    public int size() {
        return size;
    }

    /**
     * Node ichki klassi - ro'yxatdagi har bir element
     * @param <E> element turi
     */
    private static class Node<E> {
        E element;      // Elementning o'zi
        Node<E> next;   // Keyingi elementga pointer

        public Node(E element) {
            this.element = element;
        }
    }

    /**
     * Ro'yxatni string ko'rinishiga o'tkazish
     * @return string formatdagi ro'yxat
     */
    @Override
    public String toString() {
        var sj = new StringJoiner(", ", "[", "]");
        var current = this.head;
        while (current != null) {
            sj.add(String.valueOf(current.element));
            current = current.next;
        }
        return sj.toString();
    }

    /**
     * Iterator yaratish - for-each loop uchun
     * @return iterator
     */
    @Override
    public Iterator<E> iterator() {
        return new Iterator<>() {
            private Node<E> current = head;

            @Override
            public boolean hasNext() {
                return current != null;
            }

            @Override
            public E next() {
                E element = current.element;
                current = current.next;
                return element;
            }
        };
    }

    /**
     * Asosiy method - sinov uchun
     */
    public static void main(String[] args) {
        var sll = new SinglyLinkedList<String>();
        sll.add("Java");
        sll.add("Scala");
        sll.add("Python");
        
        System.out.println("Ro'yxat: " + sll);
        System.out.println("Elementlar soni: " + sll.size());
        System.out.println("2-indexdagi element: " + sll.get(2));
        
        sll.addAtBeginning("C++");
        System.out.println("Boshiga qo'shgandan keyin: " + sll);
        
        sll.remove("Scala");
        System.out.println("'Scala' o'chirilgandan keyin: " + sll);
    }
}
```

## Doubly Linked List Amaliyoti

### DoublyLinkedList<E> Implementatsiyasi

```java
package collectionsframework.linkedlist;

import java.util.Iterator;
import java.util.Objects;
import java.util.StringJoiner;

/**
 * DoublyLinkedList - ikki yo'nalishli bog'langan ro'yxat implementatsiyasi
 * @param <E> ro'yxat elementlarining turi
 */
public class DoublyLinkedList<E> implements Iterable<E> {

    private Node<E> head;  // Ro'yxat boshi
    private Node<E> tail;  // Ro'yxat oxiri
    private int size;      // Elementlar soni

    /**
     * Elementni ro'yxat oxiriga qo'shish
     * @param element qo'shiladigan element
     * @return true
     */
    public boolean add(E element) {
        var l = tail;
        var newNode = new Node<>(element);
        tail = newNode;
        
        if (l == null) {
            head = newNode;
        } else {
            l.next = newNode;
            newNode.prev = l;
        }
        size++;
        return true;
    }

    /**
     * Index bo'yicha elementni olish - optimallashtirilgan
     * @param index element indeksi
     * @return element
     * @throws IndexOutOfBoundsException agar index noto'g'ri bo'lsa
     */
    public E get(int index) {
        Objects.checkIndex(index, size);
        if (index == 0)
            return head.element;

        Node<E> current = null;
        // Index ro'yxatning qaysi yarmida ekanligiga qarab optimallashtirish
        if (index < size / 2) {
            // Boshidan boshlab qidirish
            current = head;
            for (int i = 0; i < index; i++) {
                current = current.next;
            }
        } else {
            // Oxiridan boshlab qidirish
            current = tail;
            for (int i = size - 1; i > index; i--) {
                current = current.prev;
            }
        }
        return current.element;
    }

    /**
     * Iterator yaratish - for-each loop uchun
     * @return iterator
     */
    @Override
    public Iterator<E> iterator() {
        return new Iterator<E>() {
            private Node<E> current = head;

            @Override
            public boolean hasNext() {
                return current != null;
            }

            @Override
            public E next() {
                E element = current.element;
                current = current.next;
                return element;
            }
        };
    }

    /**
     * Ro'yxatni string ko'rinishiga o'tkazish
     * @return string formatdagi ro'yxat
     */
    @Override
    public String toString() {
        var sj = new StringJoiner(", ", "[", "]");
        this.forEach(lang -> sj.add(String.valueOf(lang)));
        return sj.toString();
    }

    /**
     * Node ichki klassi - ikki pointer'li
     * @param <E> element turi
     */
    private static class Node<E> {
        E element;      // Elementning o'zi
        Node<E> prev;   // Oldingi elementga pointer
        Node<E> next;   // Keyingi elementga pointer

        public Node(E element) {
            this.element = element;
        }

        public Node(E element, Node<E> prev, Node<E> next) {
            this.element = element;
            this.prev = prev;
            this.next = next;
        }
    }

    /**
     * Asosiy method - sinov uchun
     */
    public static void main(String[] args) {
        var dll = new DoublyLinkedList<String>();
        dll.add("Java");
        dll.add("C++");
        dll.add("Python");
        dll.add("Go");
        dll.add("Scala");
        dll.add("Kotlin");
        
        System.out.println("Ro'yxat: " + dll);
        System.out.println("4-indexdagi element: " + dll.get(4));
        System.out.println("Elementlar soni: " + dll.size);
    }
}
```

## Java LinkedList Class

Java'da **LinkedList** classi linear data structure bo'lib, ichki qatlamda doubly linked list yordamida elementlarni saqlaydi (JDK 1.2'dan beri).

### JavaLinkedListTest - Amaliy Misol

```java
package collectionsframework.linkedlist;

import java.util.Arrays;
import java.util.LinkedList;

/**
 * Java standart LinkedList sinfidan foydalanish misollari
 */
public class JavaLinkedListTest {
    public static void main(String[] args) {
        // LinkedList yaratish
        var programmingLanguages = new LinkedList<String>();
        programmingLanguages.add("Python");
        programmingLanguages.add("Java");

        // Ikkinchi LinkedList yaratish
        var languages = new LinkedList<String>();
        languages.add(0, "Scala");        // Boshiga qo'shish
        languages.add("Kotlin");          // Oxiriga qo'shish
        languages.add("Groovy");
        languages.addAll(2, programmingLanguages); // Index'ga boshqa list qo'shish
        
        System.out.println("Birlashtirilgan ro'yxat: " + languages);

        // Maxsus method'lar
        languages.addFirst("Go");        // Boshiga qo'shish
        languages.addLast("C");          // Oxiriga qo'shish
        languages.add("Kotlin");         // Duplikat qo'shish
        
        System.out.println("Maxsus method'lardan keyin: " + languages);

        // Element o'chirish
        languages.removeLastOccurrence("Kotlin"); // Oxirgi topilganini o'chirish
        System.out.println("O'chirilgandan keyin: " + languages);

        // Array'ga o'tkazish
        String[] objects = languages.toArray(String[]::new);
        System.out.println("Array ko'rinishi: " + Arrays.toString(objects));

        // Boshqa foydali method'lar
        System.out.println("Birinchi element: " + languages.getFirst());
        System.out.println("Oxirgi element: " + languages.getLast());
        System.out.println("Elementlar soni: " + languages.size());
        
        // Element mavjudligini tekshirish
        System.out.println("Java bor mi? " + languages.contains("Java"));
    }
}
```

## LinkedList vs ArrayList Tezlik Tahlili

### AnalyzeLinkedListAndArrayList - Performance Test

```java
package collectionsframework.linkedlist;

import java.util.ArrayList;
import java.util.LinkedList;

/**
 * LinkedList va ArrayList tezligini taqqoslash
 */
public class AnalyzeLinkedListAndArrayList {
    public static void main(String[] args) {
        var arrayList = new ArrayList<Integer>();
        var linkedList = new LinkedList<Integer>();

        final var maxElementCount = 100_000;

        // ArrayList'ga qo'shish (boshiga)
        var start = System.currentTimeMillis();
        addToArrayList(arrayList, maxElementCount);
        var end = System.currentTimeMillis();
        System.out.println("ArrayList qo'shish (boshiga) - " + (end - start) + "ms");

        // LinkedList'ga qo'shish (boshiga)
        start = System.currentTimeMillis();
        addToLinkedList(linkedList, maxElementCount);
        end = System.currentTimeMillis();
        System.out.println("LinkedList qo'shish (boshiga) - " + (end - start) + "ms");

        // ArrayList'dan o'chirish (boshidan)
        start = System.currentTimeMillis();
        removeFromBeginningArrayList(arrayList);
        end = System.currentTimeMillis();
        System.out.println("ArrayList o'chirish (boshidan) - " + (end - start) + "ms");

        // LinkedList'dan o'chirish (boshidan)
        start = System.currentTimeMillis();
        removeFromBeginningLinkedList(linkedList);
        end = System.currentTimeMillis();
        System.out.println("LinkedList o'chirish (boshidan) - " + (end - start) + "ms");
    }

    /**
     * ArrayList'ga boshiga element qo'shish
     * Time Complexity: O(n) - har safar elementlarni siljitish kerak
     */
    private static void addToArrayList(ArrayList<Integer> arrayList, int maxElementCount) {
        for (int i = 0; i < maxElementCount; i++) {
            arrayList.add(0, i);
        }
    }

    /**
     * LinkedList'ga boshiga element qo'shish
     * Time Complexity: O(1) - faqat pointer'ni o'zgartirish
     */
    private static void addToLinkedList(LinkedList<Integer> linkedList, int maxElementCount) {
        for (int i = 0; i < maxElementCount; i++) {
            linkedList.addFirst(i);
        }
    }

    /**
     * ArrayList'dan boshidan o'chirish
     * Time Complexity: O(n) - elementlarni siljitish kerak
     */
    private static void removeFromBeginningArrayList(ArrayList<Integer> arrayList) {
        for (int i = 0; i < 10000; i++) {
            arrayList.remove(0);
        }
    }

    /**
     * LinkedList'dan boshidan o'chirish
     * Time Complexity: O(1) - faqat pointer'larni o'zgartirish
     */
    private static void removeFromBeginningLinkedList(LinkedList<Integer> linkedList) {
        for (int i = 0; i < 10000; i++) {
            linkedList.removeFirst();
        }
    }
}
```

### Natijalar Tahlili

**Qo'shish (boshiga):**
- **ArrayList:** O(n) - Har safar barcha elementlarni siljitish kerak
- **LinkedList:** O(1) - Faqat pointer'larni o'zgartirish

**O'chirish (boshidan):**
- **ArrayList:** O(n) - Elementlarni siljitish kerak
- **LinkedList:** O(1) - Faqat pointer'larni o'zgartirish

**Random Access:**
- **ArrayList:** O(1) - Index bo'yicha to'g'ridan-to'g'ri kirish
- **LinkedList:** O(n) - Ketma-ket qidirish kerak

## Vector Class

**Vector** classi object'larning o'suvchi array'ini implement qiladi. Array kabi, u integer index yordamida kirish mumkin bo'lgan component'larni o'z ichiga oladi. Biroq, Vector o'lchami Vector yaratilgandan keyin qo'shiladigan va o'chiriladigan elementlarga moslashish uchun o'sishi yoki qisqarishi mumkin (JDK 1.0'dan beri).

### List Interface Hierarchy

```
List (Interface)
├── ArrayList
├── LinkedList
├── Vector
└── Stack
```

### Vector va ArrayList Farqlari

| Xususiyat | Vector | ArrayList |
|-----------|--------|-----------|
| **Sinxronizatsiya** | Thread-safe (synchronized) | Thread-unsafe |
| **Performance** | Sekinroq | Tezroq |
| **O'sish strategiyasi** | 2 marta o'sadi | 50% o'sadi |
| **Iterator** | Fail-safe | Fail-fast |
| **Tarix** | JDK 1.0 | JDK 1.2 |

### Vector Misoli

```java
import java.util.Vector;

public class VectorExample {
    public static void main(String[] args) {
        // Vector yaratish
        Vector<String> vector = new Vector<>();
        
        // Element qo'shish
        vector.add("Java");
        vector.add("Python");
        vector.add("C++");
        
        // Capacity va size
        System.out.println("Capacity: " + vector.capacity());
        System.out.println("Size: " + vector.size());
        
        // Element olish
        System.out.println("Element at index 1: " + vector.get(1));
        
        // Sinxronizatsiya - thread-safe
        synchronized(vector) {
            for (String lang : vector) {
                System.out.println(lang);
            }
        }
        
        // Legacy method'lar
        vector.addElement("JavaScript");  // add() bilan bir xil
        vector.insertElementAt("Go", 1);  // add(index, element) bilan bir xil
        
        System.out.println("Updated vector: " + vector);
    }
}
```

## Qachon Qaysisini Ishlatish Kerak?

### ArrayList Ishlatish:
- Ko'p o'qish amallari kerak bo'lsa
- Random access kerak bo'lsa
- Thread safety kerak bo'lmasa
- Ro'yxat o'lchami ko'p o'zgarmasa

### LinkedList Ishlatish:
- Ko'p qo'shish/o'chirish amallari kerak bo'lsa
- Boshiga/Oxiriga tez-tez element qo'shish kerak bo'lsa
- Queue yoki Deque amallari kerak bo'lsa

### Vector Ishlatish:
- Legacy code bilan ishlashda
- Thread safety zarur bo'lsa (lekin zamonaviy Collections.synchronizedList() yoki CopyOnWriteArrayList afzal)

## Amaliy Maslahatlar

1. **Default sifatida ArrayList ishlating** - Ko'p hollarda eng yaxshi performance
2. **LinkedList faqat boshiga/oxiriga tez-tez qo'shish/o'chirish kerak bo'lsa**
3. **Vector'dan qoching** - Legacy, Collections.synchronizedList() afzal
4. **Initial capacity belgilang** - Agar o'lcham ma'lum bo'lsa
5. **For-each yoki Iterator ishlating** - LinkedList uchun optimal

## Tekshiruv Savollari

1. **Array va LinkedList farqlari nima?**
2. **Singly va Doubly LinkedList farqi?**
3. **LinkedList qachon ArrayList'dan yaxshi?**
4. **Vector nima va nima uchun eskirgan hisoblanadi?**
5. **Random access complexity LinkedList va ArrayList uchun qanday?**

---

**Keyingi mavzu:** [06_Set_Interface.md](./06_Set_Interface.md)

**Oldingi mavzu:** [04_Collections_Framework_List_Interface_2.md](./04_Collections_Framework_List_Interface_2.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Array** - Massiv, ketma-ket joylashgan elementlar
- **LinkedList** - Bog'langan ro'yxat, pointer'lar bilan bog'langan
- **Node** - Tugun, element va pointer(lar)ni saqlovchi birlik
- **Singly Linked** - Bir yo'nalishli bog'langan
- **Doubly Linked** - Ikki yo'nalishli bog'langan
- **Random Access** - Tasodifiy kirish, index orqali to'g'ridan-to'g'ri kirish
- **Sequential Access** - Ketma-ket kirish, boshidan boshlab qidirish
- **Thread-safe** - Thread'lar uchun xavfsiz, sinxronizatsiyalangan

> **Eslatma:** Data structure tanlash - bu trade-off. Har bir structure o'zining kuchli va zaif tomonlariga ega. Vazifaga qarab eng mosini tanlash muhim.

> **Bolalar, o'rganishda davom etamiz!** 🚀