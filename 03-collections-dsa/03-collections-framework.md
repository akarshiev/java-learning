# 03 - Dynamic Array va Collections Framework Kirishi

## Array'lar bilan muammo nima?

Java array'lari bilan quyidagi muammolar mavjud:

1. **Belgilangan o'lcham** - Array e'lon qilinganda uning o'lchami aniqlab qo'yilishi kerak
2. **O'lchamni o'zgartirib bo'lmaydi** - Array o'lchamini oshirish yoki kamaytirish mumkin emas
3. **Xotira isrofı** - Keragidan katta array yaratilsa, xotira isrof bo'ladi
4. **Elementlarni siljitish qiyin** - O'rtadan element o'chirilganda, qolgan elementlarni siljitish kerak

## Dynamic Array Yaratish

### DynamicIntegerArray (Integerlar uchun dinamik massiv)

```java
package dynamicarray;

import java.util.Arrays;
import java.util.Objects;

public class DynamicIntegerArray {
    private Integer[] elementData;
    private int size = 0;

    // Default konstruktor
    public DynamicIntegerArray() {
        this(10); // Boshlang'ich sig'im 10
    }

    // Sig'imni belgilash mumkin bo'lgan konstruktor
    public DynamicIntegerArray(int initialCapacity) {
        this.elementData = new Integer[initialCapacity];
    }

    // Element qo'shish
    public boolean add(Integer item) {
        if (size == elementData.length) {
            grow(); // Sig'im to'lsa, kengaytirish
        }
        elementData[size++] = item;
        return true;
    }

    // Element olish
    public Integer get(int index) {
        Objects.checkIndex(index, elementData.length); // Indexni tekshirish
        return elementData[index];
    }

    // Index bo'yicha element o'chirish
    public Integer remove(int index) {
        Objects.checkIndex(index, elementData.length);
        Integer oldValue = elementData[index];
        int newSize;
        
        // O'rtadan element o'chirilsa, qolgan elementlarni siljitish
        if ((newSize = size - 1) > index) {
            System.arraycopy(elementData, index + 1, elementData, index, newSize - index);
        }
        
        elementData[size = newSize] = null; // So'nggi elementni null qilish
        return oldValue;
    }

    // Qiymat bo'yicha element o'chirish
    public boolean remove(Integer o) {
        int i = 0;
        
        found: {
            if (o == null) {
                // null elementni qidirish
                for (; i < size; i++) {
                    if (elementData[i] == null) {
                        break found;
                    }
                }
            } else {
                // Object elementni qidirish
                for (; i < size; i++) {
                    if (o.equals(elementData[i])) {
                        break found;
                    }
                }
            }
            return false; // Element topilmadi
        }
        
        remove(i); // Elementni o'chirish
        return true;
    }

    // Massivni kengaytirish
    private void grow() {
        // Yangi sig'im: joriy sig'im + 50% + 1
        int newCapacity = elementData.length + elementData.length / 2 + 1;
        elementData = Arrays.copyOf(elementData, newCapacity);
    }

    @Override
    public String toString() {
        return Arrays.toString(Arrays.copyOf(elementData, size));
    }

    public static void main(String[] args) {
        DynamicIntegerArray arr = new DynamicIntegerArray(3);
        arr.add(12);
        arr.add(4);
        arr.add(null);
        arr.add(19); // Avtomatik kengayadi
        arr.add(17);
        arr.add(18);
        
        System.out.println("Massiv: " + arr);
        System.out.println("null o'chirildi: " + arr.remove(null));
        System.out.println("17 o'chirildi: " + arr.remove(new Integer(17)));
        System.out.println("Yangi massiv: " + arr);
    }
}
```

**Vazifasi:** Integer tiplari uchun o'z o'lchamini o'zgartira oladigan dinamik massiv.

## Dynamic Array'ni Generify Qilish (Umumlashtirish)

### DynamicArray<E> (Har qanday tur uchun dinamik massiv)

```java
package dynamicarray;

import java.util.Arrays;
import java.util.Iterator;
import java.util.Objects;
import java.util.UUID;

public class DynamicArray<E> implements Iterable<E> {
    public static final int INITIAL_CAPACITY = 10;
    private Object[] elementData; // Object array - type erasure sababli
    private int size = 0;

    public DynamicArray() {
        this(INITIAL_CAPACITY);
    }

    public DynamicArray(int initialCapacity) {
        this.elementData = new Object[initialCapacity];
    }

    public boolean add(E item) {
        if (size == elementData.length) {
            grow();
        }
        elementData[size++] = item;
        return true;
    }

    @SuppressWarnings("unchecked")
    public E get(int index) {
        Objects.checkIndex(index, elementData.length);
        return (E) elementData[index]; // Cast qilish kerak
    }

    @SuppressWarnings("unchecked")
    public E remove(int index) {
        Objects.checkIndex(index, elementData.length);
        Object oldValue = elementData[index];
        int newSize;
        
        if ((newSize = size - 1) > index) {
            System.arraycopy(elementData, index + 1, elementData, index, newSize - index);
        }
        
        elementData[size = newSize] = null;
        return (E) oldValue; // Cast qilish kerak
    }

    public boolean remove(Object o) {
        int i = 0;
        
        found: {
            if (o == null) {
                for (; i < size; i++) {
                    if (elementData[i] == null) {
                        break found;
                    }
                }
            } else {
                for (; i < size; i++) {
                    if (o.equals(elementData[i])) {
                        break found;
                    }
                }
            }
            return false;
        }
        
        remove(i);
        return true;
    }

    // Iterator implementatsiyasi
    @SuppressWarnings("unchecked")
    @Override
    public Iterator<E> iterator() {
        return (Iterator<E>) Arrays
                .stream(Arrays.copyOf(elementData, size))
                .iterator();
    }

    private void grow() {
        int newCapacity = elementData.length + elementData.length / 2 + 1;
        elementData = Arrays.copyOf(elementData, newCapacity);
    }

    @Override
    public String toString() {
        return Arrays.toString(Arrays.copyOf(elementData, size));
    }

    public static void main(String[] args) {
        // String lar uchun
        DynamicArray<String> languages = new DynamicArray<>(3);
        languages.add("Java");
        languages.add("Scala");
        languages.add("C#");
        languages.add("Python"); // Avtomatik kengayadi
        
        System.out.println("Dasturlash tillari:");
        for (String language : languages) {
            System.out.println("- " + language);
        }
        
        System.out.println("\n-------------------\n");
        
        // Custom class lar uchun
        DynamicArray<Student> students = new DynamicArray<>();
        students.add(new Student("Akbar Akbarov"));
        students.add(new Student("Asliddin Abdullayev"));
        
        System.out.println("Talabalar:");
        for (Student student : students) {
            System.out.println(student);
        }
        
        System.out.println("\n-------------------\n");
        
        // Integer lar uchun (autoboxing)
        DynamicArray<Integer> numbers = new DynamicArray<>();
        numbers.add(1);
        numbers.add(2);
        numbers.add(3);
        
        System.out.println("Sonlar:");
        for (Integer num : numbers) {
            System.out.println(num);
        }
    }
}

class Student {
    private final String id;
    private final String name;

    Student(String name) {
        this.id = UUID.randomUUID().toString();
        this.name = name;
    }

    @Override
    public String toString() {
        return "Student{" +
                "id='" + id + '\'' +
                ", name='" + name + '\'' +
                '}';
    }
}
```

**Muhim Nuqtalar:**
1. **Type Erasure** sababli `Object[]` ishlatiladi
2. **@SuppressWarnings("unchecked")** - Compiler warning'larini o'chirish
3. **Iterable<E> interface'i** - for-each loop uchun
4. **Generic type** - Har qanday tur bilan ishlash

## "G'ildirakni qayta ixtiro qilmang" (Don't Reinvent The Wheel)

### Java Collections Framework nima?

**Collections Framework** - Java'da ma'lumotlar strukturasi va algoritmlar to'plami.

**Tarixi:**
1. **Java 1.0** - `java.util` paketi (Vector, Hashtable)
2. **Java 1.2** - Collections Framework joriy qilindi (Joshua Bloch tomonidan)
3. **Java 1.5** - Generics qo'shildi (Collections & Generics)
4. **Java 8+** - Lambda expressions va Stream API

**Collections Framework Hierarchy (Ierarxiyasi):**

```
                    Iterable
                       |
                    Collection
            ___________|___________
           |           |           |
        List         Queue        Set
           |           |           |
    ArrayList    PriorityQueue   HashSet
    LinkedList   ArrayDeque      TreeSet
    Vector                     LinkedHashSet
    Stack
```

### Collections Framework Interface'lari

1. **Collection** - Asosiy interface (add, remove, size, isEmpty)
2. **List** - Tartiblangan, duplicate'ga ruxsat beradi (ArrayList, LinkedList)
3. **Set** - Takrorlangan elementlarga ruxsat bermaydi (HashSet, TreeSet)
4. **Queue** - Navbat (FIFO - First In First Out)
5. **Map** - Key-Value juftliklari (HashMap, TreeMap) - Collection emas, lekin framework qismi

### Collections Framework Afzalliklari

1. **Dastur ishlab chiqish vaqtini qisqartiradi** - O'z implementingizni yozishingiz shart emas
2. **Kodni saqlash oson** - Standart interfeyslar va metodlar
3. **Dinamik o'lcham** - Avtomatik ravishda kengayadi va qisqaradi
4. **Yuqori samaradorlik** - Optimallashtirilgan algoritmlar
5. **Kodni qayta foydalanish** - Barcha Java loyihalarida ishlatish mumkin

### Nega O'zingizning Dynamic Array'ingizni Yozmaysiz?

```java
//  DynamicArray ni o'zingiz yozishingiz shart emas
DynamicArray<String> myArray = new DynamicArray<>();

//  Java'dagi standart yechim
List<String> standardList = new ArrayList<>(); // O'z-o'zidan kengayadi

// Afzalliklari:
// 1. Sinovdan o'tgan va optimallashtirilgan
// 2. Kengaytirilgan funksionallik (sort, shuffle, reverse)
// 3. Barcha Java developer'lar tushunadi
// 4. Doimiy yangilanishlar va optimizatsiyalar
```

## Collections Framework'dagi Muhim Class'lar

```java
import java.util.*;

public class CollectionsExample {
    public static void main(String[] args) {
        // 1. ArrayList - Eng ko'p ishlatiladigan List
        List<String> arrayList = new ArrayList<>();
        arrayList.add("Java");
        arrayList.add("Python");
        arrayList.add("JavaScript");
        
        // 2. LinkedList - Tez kirish/chiqarish kerak bo'lsa
        List<String> linkedList = new LinkedList<>();
        linkedList.add("First");
        linkedList.add("Last");
        
        // 3. HashSet - Unikal elementlar, tartibsiz
        Set<Integer> hashSet = new HashSet<>();
        hashSet.add(1);
        hashSet.add(2);
        hashSet.add(1); // Qayta qo'shilmaydi
        
        // 4. TreeSet - Tartiblangan va unikal
        Set<String> treeSet = new TreeSet<>();
        treeSet.add("Banana");
        treeSet.add("Apple");
        treeSet.add("Cherry");
        // ["Apple", "Banana", "Cherry"] - alfabetik tartib
        
        // 5. HashMap - Key-Value mapping
        Map<String, Integer> hashMap = new HashMap<>();
        hashMap.put("John", 25);
        hashMap.put("Alice", 30);
        
        System.out.println("ArrayList: " + arrayList);
        System.out.println("HashSet: " + hashSet);
        System.out.println("TreeSet: " + treeSet);
        System.out.println("HashMap: " + hashMap);
    }
}
```

## Collections Framework Design Patterns

Collections Framework quyidagi design pattern'larni qo'llaydi:

1. **Iterator Pattern** - `Iterator<E>` interface'i orqali
2. **Factory Pattern** - `Collections` class'idagi factory metodlar
3. **Adapter Pattern** - `Arrays.asList()` kabi adapter'lar
4. **Strategy Pattern** - Turli sorting algorithm'lar

## Dynamic Array vs ArrayList

```java
// O'zingizning DynamicArray'ingiz
DynamicArray<String> custom = new DynamicArray<>();
custom.add("Custom implementation");

// Java'nin ArrayList'i
ArrayList<String> standard = new ArrayList<>();
standard.add("Standard implementation");

// Taqqoslash:
// 1. O'zgartirish - Custom da o'zingiz boshqarasiz
// 2. Ishonchlilik - Standard Java tomonidan sinovdan o'tgan
// 3. Funksionallik - ArrayList'da ko'proq metodlar mavjud
// 4. Hamkorlik - Standard barcha Java kutubxonalari bilan ishlaydi
```

## Amaliy Maslahatlar

1. **Dynamic array loyihalashda** - O'qish, o'zlashtirish uchun yaxshi mashq
2. **Real loyihalarda** - Har doim Java Collections Framework'dan foydalaning
3. **Initial capacity** - Agar elementlar soni ma'lum bo'lsa, boshlang'ich sig'imni belgilang
4. **Thread safety** - Agar multithreading kerak bo'lsa, `Vector` yoki `Collections.synchronizedList()` ishlating

## Tekshiruv Savollari

1. **Nega oddiy array'lar yetarli emas?**
2. **Dynamic array qanday ishlaydi?**
3. **Type erasure generics da qanday ta'sir ko'rsatadi?**
4. **Java Collections Framework nima va nima uchun kerak?**
5. **ArrayList va DynamicArray farqi nima?**
6. **Collection interface'lari qaysilar?**
7. **Nega o'z implementingizni yozmasligimiz kerak?**

---

**Keyingi qism:** [04 - List Interface](./04_Collections_Framework_List_Interface_2.md)  
**[Mundarijaga qaytish](../README.md)**

---

**Muhim Atamalar:**
- **Dynamic Array** - Dinamik massiv (o'z o'lchamini o'zgartira oladi)
- **Capacity** - Sig'im (massivning joriy o'lchami)
- **Size** - Hajm (foydalanilayotgan elementlar soni)
- **Type Erasure** - Tur o'chirilishi (generics runtime'da yo'qoladi)
- **Collections Framework** - Kolleksiyalar framework'i (ma'lumotlar strukturasi to'plami)
- **Backward Compatibility** - Orqaga moslik (eski kod yangi versiyada ishlashi)

> **Muhim:** Collections Framework Java'ning eng kuchli tomonlaridan biridir. Uni to'liq o'rganish professional Java dasturchi bo'lish uchun zarur.