# Collections Framework Ierarxiyasi va Map Interface

## Collections Framework Ierarxiyasi

### Asosiy Interface'lar

1. **Iterable<T>**: Ierarxiya ildizi, iteration imkoniyatini beradi (masalan, for-each loop bilan)
2. **Collection<E>**: Elementlar guruhi uchun asosiy method'larni aniqlaydi (add, remove, size)
3. **List<E>**: Tartiblangan kolleksiyalar, duplicate'larni qo'llaydi (masalan, ArrayList, LinkedList)
4. **Set<E>**: Noyob elementlar, tartib kafolati yo'q (masalan, HashSet, TreeSet)
5. **Queue<E>**: FIFO tamoyilida qayta ishlanadigan elementlar (masalan, PriorityQueue)
6. **Deque<E>**: Ikki tomonlama navbat (masalan, ArrayDeque)
7. **Map<K,V>**: Kalit-qiymat juftliklarini saqlaydi, Collection ierarxiyasiga kirmaydi, lekin framework uchun muhim (
   masalan, HashMap, TreeMap)

### Asosiy Implementatsiyalar

- **List uchun**: ArrayList (dinamik array), LinkedList (ikki yo'nalishli bog'langan ro'yxat)
- **Set uchun**: HashSet (hash-based), LinkedHashSet (qo'shilish tartibida), TreeSet (tartiblangan)
- **Queue/Deque uchun**: PriorityQueue (heap-based), ArrayDeque
- **Map uchun**: HashMap (hash-based), LinkedHashMap (qo'shilish tartibida), TreeMap (kalit bo'yicha tartiblangan)

### Struktura Ko'rinishi

```
Iterable (Root) -> extends to Collection
Collection (Parent) -> extends to List, Set, Queue
Map (Alohida, lekin bog'liq)
Classes (masalan, ArrayList, HashMap) bu Interface'larni implement qiladi
```

## Dictionary (Lug'at)

**Dictionary** - bu ob'ektlar guruhini saqlash uchun umumiy maqsadli data structure. Dictionary'ning kalitlar to'plami
bor va har bir kalitning o'ziga xos bog'langan qiymati bor.


| key | value|
|-----|-------|
| 1|Botirov Javohir|
| 2|Karimov Suhrob|
| 3|Ulachov Husniddin|

## Map Interface va HashMap

### Map Nima?

**Map** - bu kalit va qiymat juftliklari shaklida elementlarni saqlovchi konteyner ob'ekt. Kalit - bu map'da "indeks"
vazifasini o'taydigan noyob element (ob'ekt) (JDK 1.2'dan boshlab).

Kalit bilan bog'langan element **qiymat** deb ataladi. Map kalitlar bilan bog'langan qiymatlarni saqlaydi. Map'da ham
kalitlar, ham qiymatlar ob'ekt bo'lishi kerak, primitive type'lar bo'lishi mumkin emas.

Map'da duplicate kalitlar bo'lishi mumkin emas. Har bir kalit faqat bitta qiymatga yo'naltiriladi. Bu turdagi mapping
Java'da **one-to-one mapping** deb ataladi.

Barcha kalitlar noyob bo'lishi kerak, lekin qiymatlar duplicate bo'lishi mumkin.

Kalit va uning bog'langan qiymati **entry** (kirish) deb ataladi.

### Map.Entry

**Map.Entry** - map entry'si (kalit-qiymat juftligi). Entry o'zgarmas bo'lishi mumkin yoki optional setValue method'i
implement qilingan bo'lsa qiymat o'zgartirilishi mumkin. Entry har qanday map'dan mustaqil bo'lishi yoki map'ning
entry-set ko'rinishining kirishini ifodalashi mumkin (JDK 1.2'dan boshlab).

### HashMap

Java'da **HashMap** - bu tartibsiz kolleksiya bo'lib, elementlarni (ob'ektlarni) kalit-qiymat juftliklari (entry deb
ataladi) shaklida saqlaydi. Kalit ham, qiymat ham ob'ektlardir. HashMap bir ob'ektni olish uchun boshqa ob'ektdan
foydalanadi (JDK 1.2'dan boshlab).

HashMap va Java'dagi boshqa hash table asosidagi Map implementatsiya class'lari collision'larni zanjirli ro'yxat (linked
list) yordamida boshqaradi, map entry'larini bir xil bucket'da saqlaydi. Agar kalit allaqachon saqlangan entry bilan bir
xil bucket joylashuviga tushsa, bu entry faqat u erdagi linked list'ning boshiga qo'shiladi. Eng yomon holatda bu
HashMap'ning get() method'ining performance'ini O(1) dan O(n) ga pasaytiradi. Tez-tez HashMap collision'larida bu
muammoni hal qilish uchun Java 8 linked list o'rniga muvozanatli daraxt (balanced tree) dan foydalana boshladi. Bu shuni
anglatadiki, eng yomon holatda performance O(n) dan O(log n) ga oshadi.

### HashMap Class'ining Xususiyatlari

1. **Asosiy data structure** - HashMap'ning asosiy data structure'i HashTable
2. **Tartib saqlanmaydi** - Qo'shilish tartibi saqlanmaydi
3. **Kalitlarning Hashcode'iga asoslangan** - Qiymatlarning hashcode'iga emas
4. **Noyob kalitlar** - Faqat noyob kalitlar ruxsat etiladi, lekin qiymatlar duplicate bo'lishi mumkin
5. **Heterogen ob'ektlar** - Kalitlar va qiymatlar uchun heterogen ob'ektlar ruxsat etiladi
6. **Bitta null kalit** - HashMap faqat bitta null kalitga ega bo'lishi mumkin
7. **Ko'p null qiymat** - HashMap'da ko'p null qiymatlar ruxsat etiladi
8. **Synchronized emas** - HashMap synchronized emas
9. **Qidirish operatsiyasi** - Agar tez-tez qidirish operatsiyasi bo'lsa, HashMap eng yaxshi tanlov
10. **Ob'ekt referenslari** - Java HashMap faqat ob'ekt referenslarini saqlaydi

### LinkedHashMap va TreeMap

#### LinkedHashMap

Java'da **LinkedHashMap** - bu HashTable va Map interface'ining Linked List implementatsiyasidir. U entry'larni ikki yo'
nalishli bog'langan ro'yxat yordamida saqlaydi (JDK 1.4'dan boshlab).

Java LinkedHashMap class'i HashMap class'ini linked-list implementatsiyasi bilan kengaytiradi, bu map'dagi entry'larning
tartibini qo'llab-quvvatlaydi.

Java LinkedHashMap kalit asosida qiymatlarni o'z ichiga oladi.

Java LinkedHashMap noyob elementlarni o'z ichiga oladi.

Java LinkedHashMap bitta null kalitga ega bo'lishi mumkin va ko'p null qiymatlarga ega bo'lishi mumkin.

Java LinkedHashMap synchronized emas.

Java LinkedHashMap qo'shilish tartibini saqlaydi.

#### TreeMap

Java'da **TreeMap** - bu Map interface'ining qizil-qora daraxt (red-black tree) asosidagi implementatsiyasidir (JDK
1.2'dan boshlab).

U avtomatik ravishda tartiblangan tartibda kalit/qiymat juftliklarini saqlashning samarali usulini ta'minlaydi va tez
olish imkonini beradi.

TreeMap implementatsiyasi tekshirish, qo'shish, olish va olib tashlash operatsiyalari uchun kafolatlangan log(n) vaqt
performance'ini ta'minlaydi.

HashMap va TreeMap o'rtasidagi ikkita asosiy farq:

HashMap elementlarning tartibsiz kolleksiyasi, TreeMap esa kalitlarining o'sish tartibida tartiblangan. Kalitlar
Comparable interface'i yoki Comparator interface'i yordamida tartiblanadi.

HashMap faqat bitta null kalitga ruxsat beradi, TreeMap esa hech qanday null kalitga ruxsat bermaydi.

### References va WeakHashMap

#### Strong References

Bu Reference Object'ning default turi/class'idir. Faol strong reference'ga ega bo'lgan har qanday ob'ekt garbage
collection uchun mos emas. Ob'ekt faqat kuchli referenced o'zgaruvchi null'ga ishora qilganda garbage collected bo'ladi.

#### Weak References

**Weak reference** garbage collector'ga ob'ektni to'plashga ruxsat beradi, shu bilan birga ilovaga ob'ektga kirish
imkonini beradi. Weak reference faqat hech qanday strong reference mavjud bo'lmaganda ob'ekt to'plangan vaqtgacha amal
qiladi.

#### Soft Reference

**Soft reference**, hatto ob'ekt garbage collection uchun bo'sh bo'lsa ham, JVM haqiqatan ham xotiraga muhtoj
bo'lmaguncha, garbage collected bo'lmaydi. Ob'ektlar JVM xotira tugaganda xotiradan tozalanadi. Bunday referenslar
yaratish uchun `java.lang.ref.SoftReference` class'i ishlatiladi.

#### WeakHashMap

Java'da **WeakHashMap** - bu weak kalitlar asosida boshqa Map implementatsiyasini ta'minlovchi class (JDK 1.2'dan
boshlab).

Java WeakHashMap AbstractMap class'ini kengaytiradi, zaif kalitlar bilan HashTable'dan foydalanish uchun.
WeakHashMap'ning kaliti weak reference'ga ega bo'lib, map'dagi entry'ning uning kaliti endi ishlatilmayotganda
garbage-collected bo'lishiga imkon beradi.

Oddiy so'zlar bilan, WeakHashMap'dagi entry map tomonidan avtomatik ravishda olib tashlanadi, uning kaliti endi
ishlatilmayotganda garbage-collector tomonidan.

Garbage-collector kalitlar oddiy foydalanilmayotganda kalitlarga (map ichida va tashqarisida) barcha weak
reference'larni tozalaydi.

#### WeakHashMap Ierarxiyasi

```
Map <- AbstractMap <- WeakHashMap
```

#### WeakHashMap Class'ining Xususiyatlari

1. **Garbage collector** - WeakHashMap'dan kalitlar va ularning bog'langan qiymatlarini har qanday vaqtda olib tashlashi
   mumkin
2. **Kalit-qiymat juftliklari** - Ma'lumotlarni kalit-qiymat juftliklari shaklida saqlash imkonini beradi
3. **Duplicate kalitlar yo'q** - Java WeakHashMap duplicate kalitlarni saqlashga ruxsat bermaydi
4. **Null kalit va qiymat** - Map'da bitta null kalit kiritishga ruxsat beradi, lekin bir nechta null qiymat qo'shilishi
   mumkin
5. **Tartib saqlanmaydi** - WeakHashMap Java'da qo'shilish tartibini saqlamaydi
6. **Synchronized emas** - Java'dagi WeakHashMap synchronized emas

## Dictionary Implementatsiyasi

### SimpleDictionary<K, V>

```java
package collectionsframework.dictionary;

import java.util.Arrays;

/**
 * SimpleDictionary - oddiy dictionary/lug'at implementatsiyasi
 * @param <K> kalit turi
 * @param <V> qiymat turi
 */
public class SimpleDictionary<K, V> {
    private Entry<K, V>[] dictionary;
    private static final int DEFAULT_CAPACITY = 16;

    /**
     * Default constructor - 16 capacity bilan
     */
    public SimpleDictionary() {
        this(DEFAULT_CAPACITY);
    }

    /**
     * Berilgan capacity bilan constructor
     * @param capacity dictionary sig'imi
     */
    @SuppressWarnings("unchecked")
    public SimpleDictionary(int capacity) {
        this.dictionary = new Entry[capacity];
    }

    /**
     * Kalit bo'yicha qiymat olish
     * @param key qidirilayotgan kalit
     * @return kalitga bog'langan qiymat yoki null
     */
    public V get(K key) {
        int hashCode = key.hashCode();
        int index = hashCode % dictionary.length;
        var entry = dictionary[index];
        if (entry == null) {
            return null;
        }
        return entry.value;
    }

    /**
     * Kalit-qiymat juftligini qo'shish
     * @param key kalit
     * @param value qiymat
     * @return qo'shilgan qiymat
     */
    public V put(K key, V value) {
        int hashCode = key.hashCode();
        int index = hashCode % dictionary.length;
        dictionary[index] = new Entry<>(key, value);
        return value;
    }

    /**
     * Dictionary'ning string ko'rinishi
     * @return string formatdagi dictionary
     */
    @Override
    public String toString() {
        return Arrays.toString(dictionary);
    }

    /**
     * Entry ichki class'i - kalit-qiymat juftligi
     * @param <K> kalit turi
     * @param <V> qiymat turi
     */
    public static class Entry<K, V> {
        K key;
        V value;

        public Entry(K key, V value) {
            this.key = key;
            this.value = value;
        }

        @Override
        public String toString() {
            return String.format("%s=%s", key, value);
        }
    }
}
```

### SimpleDictionaryTest

```java
package collectionsframework.dictionary;

/**
 * SimpleDictionary test qilish
 */
public class SimpleDictionaryTest {

    public static void main(String[] args) {
        System.out.println("========== TEST 1: STRING-STRING DICTIONARY ==========");

        var dict = new SimpleDictionary<String, String>();
        dict.put("hello", "Assalom alekum");
        dict.put("cat", "Mushuk");
        dict.put("dog", "It");

        System.out.println("Dictionary: " + dict);
        System.out.println("get('cat'): " + dict.get("cat"));
        System.out.println("get('hello'): " + dict.get("hello"));
        System.out.println("get('dog'): " + dict.get("dog"));
        System.out.println("get('fly'): " + dict.get("fly"));  // null

        System.out.println("\n========== TEST 2: COLLISION DEMONSTRATION ==========");

        // Collision namoyishi
        var dict2 = new SimpleDictionary<Integer, String>();
        dict2.put(0, "Java");   // index -> 0, hash -> 0
        dict2.put(16, "Scala");  // index -> 0, hash -> 16 (collision!)
        dict2.put(32, "Groovy"); // index -> 0, hash -> 32 (collision!)

        System.out.println("Dictionary with collisions: " + dict2);
        System.out.println("get(0): " + dict2.get(0));
        System.out.println("get(16): " + dict2.get(16));   // null - chunki collision yechilmagan
        System.out.println("get(32): " + dict2.get(32));   // null - chunki collision yechilmagan
    }
}
```

### Dictionary<K, V> (To'liqroq Implementatsiya)

```java
package collectionsframework.dictionary;

import java.util.HashSet;
import java.util.Objects;
import java.util.Set;
import java.util.StringJoiner;

/**
 * Dictionary - HashMap ga o'xshash to'liq implementatsiya
 * @param <K> kalit turi
 * @param <V> qiymat turi
 */
public class Dictionary<K, V> {
    public static final int DEFAULT_CAPACITY = 16;
    private Node<K, V>[] table;
    private int size = 0;

    /**
     * Default constructor - 16 capacity bilan
     */
    public Dictionary() {
        this(DEFAULT_CAPACITY);
    }

    /**
     * Berilgan capacity bilan constructor
     * @param capacity dictionary sig'imi
     */
    @SuppressWarnings("unchecked")
    public Dictionary(int capacity) {
        this.table = new Node[capacity];
    }

    /**
     * Kalit-qiymat juftligini qo'shish
     * @param key kalit
     * @param value qiymat
     * @return oldingi qiymat yoki null
     */
    public V put(K key, V value) {
        int hash = hash(key);
        int index = index(hash);
        var newNode = new Node<>(hash, key, value);
        var node = table[index];

        // Agar bucket bo'sh bo'lsa
        if (node == null) {
            table[index] = newNode;
            size++;
            return null;
        }

        Node<K, V> prev = null;
        while (node != null) {
            // Agar kalit topilsa, qiymatni yangilash
            if (node.hash == newNode.hash && Objects.equals(node.key, key)) {
                V oldValue = node.value;
                node.value = value;
                return oldValue;
            }
            prev = node;
            node = node.next;
        }

        // Yangi node ni oxiriga qo'shish
        prev.next = newNode;
        size++;
        return null;
    }

    /**
     * Kalit bo'yicha qiymat olish
     * @param key qidirilayotgan kalit
     * @return kalitga bog'langan qiymat yoki null
     */
    public V get(K key) {
        int hash = hash(key);
        int index = index(hash);
        var node = table[index];

        if (node == null) {
            return null;
        }

        while (node != null) {
            if (node.hash == hash && Objects.equals(node.key, key)) {
                return node.value;
            }
            node = node.next;
        }
        return null;
    }

    /**
     * Kalit bo'yicha entry ni o'chirish
     * @param key o'chiriladigan kalit
     * @return o'chirilgan qiymat yoki null
     */
    public V remove(K key) {
        int hash = hash(key);
        int index = index(hash);
        var node = table[index];

        if (node == null) {
            return null;
        }

        Node<K, V> prev = null;
        while (node != null) {
            if (node.hash == hash && Objects.equals(node.key, key)) {
                if (prev == null) {
                    // Boshidagi node ni o'chirish
                    table[index] = node.next;
                } else {
                    // O'rtadagi node ni o'chirish
                    prev.next = node.next;
                }
                size--;
                return node.value;
            }
            prev = node;
            node = node.next;
        }
        return null;
    }

    /**
     * Barcha entry'larni to'plam shaklida qaytarish
     * @return entry'lar to'plami
     */
    public Set<Entry<K, V>> entrySet() {
        var entrySet = new HashSet<Entry<K, V>>();
        for (Node<K, V> node : table) {
            while (node != null) {
                entrySet.add(new Entry<>(node.key, node.value));
                node = node.next;
            }
        }
        return entrySet;
    }

    /**
     * Dictionary'dagi elementlar soni
     * @return elementlar soni
     */
    public int size() {
        return size;
    }

    /**
     * Dictionary bo'sh yoki yo'qligini tekshirish
     * @return true - agar bo'sh bo'lsa
     */
    public boolean isEmpty() {
        return size == 0;
    }

    /**
     * Kalit mavjudligini tekshirish
     * @param key tekshiriladigan kalit
     * @return true - agar kalit mavjud bo'lsa
     */
    public boolean containsKey(K key) {
        return get(key) != null;
    }

    /**
     * Hash code hisoblash
     * @param key kalit
     * @return hash code
     */
    private int hash(K key) {
        return key == null ? 0 : key.hashCode();
    }

    /**
     * Hash code asosida index hisoblash
     * @param key kalit
     * @return index
     */
    private int index(K key) {
        return hash(key) % table.length;
    }

    /**
     * Hash code asosida index hisoblash
     * @param hash hash code
     * @return index
     */
    private int index(int hash) {
        return hash % table.length;
    }

    /**
     * Dictionary'ning string ko'rinishi
     * @return string formatdagi dictionary
     */
    @Override
    public String toString() {
        var sj = new StringJoiner(", ", "{", "}");
        for (Entry<K, V> kvEntry : entrySet()) {
            sj.add(kvEntry.toString());
        }
        return sj.toString();
    }

    /**
     * Entry record'i - kalit-qiymat juftligi
     * @param <K> kalit turi
     * @param <V> qiymat turi
     */
    public record Entry<K, V>(K key, V value) {
        @Override
        public String toString() {
            return String.format("%s=%s", key, value);
        }
    }

    /**
     * Node ichki class'i - linked list uchun
     * @param <K> kalit turi
     * @param <V> qiymat turi
     */
    private static class Node<K, V> {
        int hash;
        K key;
        V value;
        Node<K, V> next;

        public Node(int hash, K key, V value) {
            this.hash = hash;
            this.key = key;
            this.value = value;
        }
    }
}
```

### DictionaryTest

```java
package collectionsframework.dictionary;

/**
 * Dictionary test qilish
 */
public class DictionaryTest {

    public static void main(String[] args) {
        var dict = new Dictionary<String, String>();

        // Elementlar qo'shish
        dict.put("1", "Java");
        dict.put("2", "Go");
        dict.put("3", "Scala");
        dict.put("4", "Groovy");

        // EntrySet bilan iteratsiya
        System.out.println("All entries:");
        for (Dictionary.Entry<String, String> entry : dict.entrySet()) {
            System.out.println(entry);
        }

        System.out.println("\nDictionary string representation:");
        System.out.println(dict);

        System.out.println("\nSize: " + dict.size());
        System.out.println("Is empty? " + dict.isEmpty());
        System.out.println("Contains key '2'? " + dict.containsKey("2"));
        System.out.println("Contains key '5'? " + dict.containsKey("5"));

        // Get operations
        System.out.println("\nget('3'): " + dict.get("3"));
        System.out.println("get('5'): " + dict.get("5"));

        // Remove operation
        System.out.println("\nremove('2'): " + dict.remove("2"));
        System.out.println("After remove - Dictionary: " + dict);
        System.out.println("Size after remove: " + dict.size());

        // Update existing key
        System.out.println("\nUpdating existing key '1':");
        String oldValue = dict.put("1", "JavaScript");
        System.out.println("Old value: " + oldValue);
        System.out.println("New value: " + dict.get("1"));
        System.out.println("Dictionary after update: " + dict);
    }
}
```

## Java HashMap Class Test

```java
package collectionsframework.map;

import java.util.HashMap;

/**
 * Java HashMap class'idan foydalanish misollari
 */
public class HashMapClassTest {

    public static void main(String[] args) {
        var hm = new HashMap<String, String>();

        // Asosiy operatsiyalar
        hm.put("1", "Java");
        hm.put("3", "Scala");
        hm.put("2", "Kotlin");

        System.out.println("Basic operations:");
        System.out.println("get('1'): " + hm.get("1"));
        System.out.println("get('2'): " + hm.get("2"));
        System.out.println("get('non-existent'): " + hm.get("k"));

        // Compute operations
        System.out.println("\nCompute operations:");
        hm.compute("3", (key, value) -> key + "->" + value);
        hm.computeIfAbsent("4", (key) -> key + " -> new key value inserted");
        hm.computeIfPresent("2", (key, oldValue) -> key + "->" + oldValue);

        System.out.println("After compute operations: " + hm);

        // getOrDefault
        System.out.println("\ngetOrDefault:");
        String defaultValue = hm.getOrDefault("5", "Default Value");
        System.out.println("getOrDefault('5', 'Default Value'): " + defaultValue);

        // Contains checks
        System.out.println("\nContains checks:");
        System.out.println("containsKey('2'): " + hm.containsKey("2"));
        System.out.println("containsKey('k'): " + hm.containsKey("k"));
        System.out.println("containsValue('Java'): " + hm.containsValue("Java"));
        System.out.println("containsValue('3->Scala'): " + hm.containsValue("3->Scala"));

        // KeySet, Values, EntrySet
        System.out.println("\nKeySet:");
        hm.keySet().forEach(System.out::println);

        System.out.println("\nValues:");
        hm.values().forEach(System.out::println);

        System.out.println("\nEntrySet:");
        hm.entrySet().forEach(entry ->
                System.out.println(entry.getKey() + "=" + entry.getValue()));

        // ForEach
        System.out.println("\nForEach:");
        hm.forEach((k, v) -> System.out.println(k + "=" + v));

        // Additional useful methods
        System.out.println("\nAdditional methods:");
        System.out.println("Size: " + hm.size());
        System.out.println("Is empty: " + hm.isEmpty());

        hm.putIfAbsent("5", "Python");
        System.out.println("After putIfAbsent('5', 'Python'): " + hm);

        hm.replace("1", "Java", "Java 17");
        System.out.println("After replace('1', 'Java', 'Java 17'): " + hm);

        hm.remove("3");
        System.out.println("After remove('3'): " + hm);

        hm.clear();
        System.out.println("After clear, size: " + hm.size());
    }
}
```

## LinkedHashMap Class Test

```java
package collectionsframework.map;

import java.util.LinkedHashMap;

/**
 * LinkedHashMap vs HashMap farqlari
 */
public class LinkedHashMapClassTest {

    public static void main(String[] args) {
        System.out.println("========== LINKEDHASHMAP (Insertion Order Preserved) ==========");
        var lhm = new LinkedHashMap<Integer, String>();
        lhm.put(1, "Java");
        lhm.put(3, "Groovy");
        lhm.put(4, "Scala");
        lhm.put(2, "Kotlin");

        System.out.println("LinkedHashMap (maintains insertion order):");
        lhm.forEach((k, v) -> System.out.println(k + "=" + v));

        System.out.println("\n========== HASHMAP (No Order Guarantee) ==========");
        var hm = new java.util.HashMap<Integer, String>();
        hm.put(1, "Java");
        hm.put(3, "Groovy");
        hm.put(4, "Scala");
        hm.put(2, "Kotlin");

        System.out.println("HashMap (no order guarantee):");
        hm.forEach((k, v) -> System.out.println(k + "=" + v));

        System.out.println("\n========== LINKEDHASHMAP WITH ACCESS ORDER ==========");
        // Access order: Eng ko'p kirilgan element oxiriga o'tadi
        var accessOrderMap = new LinkedHashMap<Integer, String>(16, 0.75f, true);
        accessOrderMap.put(1, "A");
        accessOrderMap.put(2, "B");
        accessOrderMap.put(3, "C");

        System.out.println("Initial: " + accessOrderMap);

        // Elementga kirish tartibini o'zgartirish
        accessOrderMap.get(2);  // 2 eng oxiriga o'tadi
        System.out.println("After accessing key 2: " + accessOrderMap);

        accessOrderMap.get(1);  // 1 eng oxiriga o'tadi
        System.out.println("After accessing key 1: " + accessOrderMap);
    }
}
```

## TreeMap Class Test

```java
package collectionsframework.map;

import java.util.Comparator;
import java.util.TreeMap;

/**
 * TreeMap - tartiblangan Map implementatsiyasi
 */
public class TreeMapClassTest {

    public static void main(String[] args) {
        System.out.println("========== TREEMAP WITH STRING KEYS (Natural Ordering) ==========");
        var tm1 = new TreeMap<String, String>();
        tm1.put("3", "groovy");
        tm1.put("2", "Scala");
        tm1.put("1", "Java");
        tm1.put("10", "Kotlin");

        System.out.println("TreeMap sorted by keys (natural order):");
        tm1.forEach((k, v) -> System.out.println(k + "=" + v));

        // NavigableMap methods
        System.out.println("\nNavigableMap methods:");
        System.out.println("First key: " + tm1.firstKey());
        System.out.println("Last key: " + tm1.lastKey());
        System.out.println("Lower key than '2': " + tm1.lowerKey("2"));
        System.out.println("Higher key than '2': " + tm1.higherKey("2"));
        System.out.println("HeadMap ('3'): " + tm1.headMap("3"));
        System.out.println("TailMap ('3'): " + tm1.tailMap("3"));

        System.out.println("\n========== TREEMAP WITH CUSTOM COMPARATOR ==========");
        var tm2 = new TreeMap<Student, String>(
                Comparator.comparingInt(student -> student.age)
        );

        tm2.put(new Student(12, "Akbarov Akbar"), "Excellent");
        tm2.put(new Student(23, "Komilova Nodira"), "Good");
        tm2.put(new Student(11, "Jasur Rahmatov"), "Very Good");

        System.out.println("TreeMap sorted by student age:");
        tm2.forEach((k, v) -> System.out.println(k + " -> " + v));

        System.out.println("\n========== TREEMAP VS HASHMAP ==========");
        System.out.println("TreeMap advantages:");
        System.out.println("- Automatically sorts keys");
        System.out.println("- Provides navigable methods (firstKey, lastKey, etc.)");
        System.out.println("- Guaranteed O(log n) time for operations");

        System.out.println("\nTreeMap disadvantages:");
        System.out.println("- Slower than HashMap for basic operations");
        System.out.println("- Doesn't allow null keys");
        System.out.println("- Requires keys to be Comparable or provide Comparator");
    }
}

/**
 * Student class - TreeMap uchun misol
 */
class Student {
    public int age;
    public String fullName;

    public Student(int age, String fullName) {
        this.age = age;
        this.fullName = fullName;
    }

    @Override
    public String toString() {
        return String.format("Student{age=%d, fullName='%s'}", age, fullName);
    }
}
```

## References (SoftReference, WeakReference)

### SoftReference

```java
package references;

import java.lang.ref.SoftReference;

/**
 * SoftReference - JVM xotira muhtoj bo'lgungacha garbage collected bo'lmaydi
 */
public class SoftRef {

    public static void main(String[] args) {
        System.out.println("========== SOFT REFERENCE DEMONSTRATION ==========");

        // Strong reference yaratish
        String language = new String("english");

        // Soft reference yaratish
        SoftReference<String> softReference = new SoftReference<>(language);

        System.out.println("Before nullifying strong reference:");
        System.out.println("Strong reference: " + language);
        System.out.println("Soft reference: " + softReference.get());

        // Strong reference'ni null qilish
        language = null;

        System.out.println("\nAfter nullifying strong reference:");
        System.out.println("Soft reference still available: " + softReference.get());

        // Xotirani to'ldirishga urinish (soft reference garbage collected bo'lishi mumkin)
        try {
            System.out.println("\nTrying to fill memory...");
            byte[][] memoryFiller = new byte[100][];
            for (int i = 0; i < 100; i++) {
                memoryFiller[i] = new byte[1024 * 1024]; // 1 MB
            }
        } catch (OutOfMemoryError e) {
            System.out.println("OutOfMemoryError caught!");
        }

        System.out.println("\nAfter memory pressure:");
        System.out.println("Soft reference: " + softReference.get());  // null bo'lishi mumkin

        System.gc();
        System.out.println("After System.gc(): " + softReference.get());
    }
}
```

### WeakReference

```java
package references;

import java.lang.ref.WeakReference;

/**
 * WeakReference - Garbage collector keyingi safar ishlaganda tozalanadi
 */
public class WeakRef {

    public static void main(String[] args) {
        System.out.println("========== WEAK REFERENCE DEMONSTRATION ==========");

        // Strong reference yaratish
        String language = new String("english");

        // Weak reference yaratish
        WeakReference<String> weakReference = new WeakReference<>(language);

        System.out.println("Before nullifying strong reference:");
        System.out.println("Strong reference: " + language);
        System.out.println("Weak reference: " + weakReference.get());

        // Strong reference'ni null qilish
        language = null;

        System.out.println("\nAfter nullifying strong reference:");
        System.out.println("Weak reference still available: " + weakReference.get());

        // Garbage collection ni chaqirish
        System.gc();

        System.out.println("\nAfter System.gc():");
        System.out.println("Weak reference: " + weakReference.get());  // null bo'lishi ehtimoli yuqori

        // WeakReference va SoftReference farqi
        System.out.println("\nDifference between WeakReference and SoftReference:");
        System.out.println("- WeakReference: GC keyingi safar ishlaganda tozalanadi");
        System.out.println("- SoftReference: Faqat JVM xotira muhtoj bo'lganda tozalanadi");
    }
}
```

### WeakHashMap Class Test

```java
package references;

import java.util.WeakHashMap;

/**
 * WeakHashMap - Weak reference kalitlar bilan HashMap
 */
public class WeakHashMapClassTest {

    public static void main(String[] args) {
        System.out.println("========== WEAKHASHMAP DEMONSTRATION ==========");

        var whm = new WeakHashMap<String, String>();

        // Strong reference kalit yaratish
        String key1 = new String("1");

        // Elementlar qo'shish
        whm.put(key1, "java");
        whm.put("2", "groovy");
        whm.put("3", "Scala");

        System.out.println("Initial WeakHashMap:");
        whm.forEach((k, v) -> System.out.println(k + "=" + v));
        System.out.println("Size: " + whm.size());

        // Strong reference'ni null qilish
        key1 = null;

        System.out.println("\nAfter nullifying strong reference to key '1':");
        System.out.println("Before GC - Size: " + whm.size());

        // Garbage collection ni chaqirish
        System.gc();

        // Biroz kutish (GC uchun vaqt berish)
        try {
            Thread.sleep(1000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("\nAfter System.gc():");
        whm.forEach((k, v) -> System.out.println(k + "=" + v));
        System.out.println("Size: " + whm.size());

        System.out.println("\n========== PRACTICAL USE CASE ==========");
        System.out.println("WeakHashMap is useful for:");
        System.out.println("- Cache implementations");
        System.out.println("- Temporary mappings");
        System.out.println("- Preventing memory leaks");

        System.out.println("\nExample - Cache with WeakHashMap:");
        var cache = new WeakHashMap<String, byte[]>();

        // Katta ma'lumotlarni cache'ga qo'shish
        for (int i = 0; i < 100; i++) {
            cache.put("key" + i, new byte[1024 * 1024]); // 1 MB har biri
        }

        System.out.println("Cache size before memory pressure: " + cache.size());

        // Xotira bosimi yaratish
        try {
            byte[][] memoryPressure = new byte[50][];
            for (int i = 0; i < 50; i++) {
                memoryPressure[i] = new byte[1024 * 1024 * 10]; // 10 MB
            }
        } catch (OutOfMemoryError e) {
            System.out.println("OutOfMemoryError - cache entries will be cleared");
        }

        System.gc();
        System.out.println("Cache size after memory pressure: " + cache.size());
    }
}
```

## Amaliy Maslahatlar

1. **Qachon qaysi Map ishlatish kerak?**
    - **HashMap** - Tez kirish kerak, tartib muhim emas
    - **LinkedHashMap** - Qo'shilish yoki kirish tartibi saqlanishi kerak
    - **TreeMap** - Kalitlar tartiblangan bo'lishi kerak
    - **WeakHashMap** - Cache yoki vaqtincha mapping uchun

2. **Performance diqqatga olinishi kerak:**
    - **HashMap**: O(1) average, O(n) worst case
    - **LinkedHashMap**: O(1) average, biroz sekinroq HashMap'dan
    - **TreeMap**: O(log n) barcha operatsiyalar uchun
    - **WeakHashMap**: HashMap ga o'xshash, lekin weak reference bilan

3. **Thread safety:**
    - Barcha standard Map'lar synchronized EMAS
    - `Collections.synchronizedMap()` yordamida synchronized qilish mumkin
    - ConcurrentHashMap concurrent ishlash uchun

4. **Null qiymatlar bilan ishlash:**
    - **HashMap**: 1 null kalit, ko'p null qiymat
    - **LinkedHashMap**: 1 null kalit, ko'p null qiymat
    - **TreeMap**: null kalitlar RUXSAT ETILMAYDI
    - **WeakHashMap**: 1 null kalit, ko'p null qiymat

5. **Initial capacity va load factor:**
    - **Default capacity**: 16
    - **Default load factor**: 0.75
    - Load factor 0.75 degani 75% to'lganda avtomatik o'sadi

6. **equals() va hashCode() muhimligi:**
    - HashMap kalitlar uchun hashCode() va equals() dan foydalanadi
    - Agar custom object kalit sifatida ishlatilsa, ikkala method'ni ham override qilish SHART

---

**Keyingi mavzu:** [10_Views, Shallow Coppy and Deep Copy.md](10_Views_Copies.md)

**Oldingi mavzu:** [08_Queue_Data_Structure.md](./08_Queue_Data_Structure.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**

- **Map** - Kalit-qiymat juftliklari saqlovchi
- **HashMap** - Hash table asosidagi Map
- **LinkedHashMap** - Qo'shilish tartibini saqlovchi HashMap
- **TreeMap** - Tartiblangan Map
- **WeakHashMap** - Weak reference kalitlar bilan Map
- **Entry** - Kalit-qiymat juftligi
- **Collision** - Bir xil index'ga tushadigan hash'lar
- **Load Factor** - Map to'lish darajasi
- **SoftReference** - Xotira muhtoj bo'lgandagina tozalanadigan reference
- **WeakReference** - GC ishlaganda tozalanadigan reference

> **Bolalar, o'rganishda davom etamiz!** 🚀