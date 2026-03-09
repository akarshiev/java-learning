# Queue Data Structure

## Kirish

**Queue** (navbat) - bu ikki uchidan ham ochiq bo'lgan linear data structure bo'lib, amallar **First In First Out (FIFO)** yoki "Birinchi kirgan birinchi chiqadi" tartibida bajariladi. Bunga turli jamoat joyidagi navbatlarni misol qilish mumkin - birinchi kelgan birinchi xizmat ko'radi.

## Queue'ning Asosiy Operatsiyalari

1. **enqueue** - Elementni queue'ning oxiriga qo'shish
2. **dequeue** - Elementni queue'ning boshidan olib tashlash
3. **isEmpty** - Queue bo'sh yoki yo'qligini tekshirish
4. **isFull** - Queue to'la yoki yo'qligini tekshirish (fixed size queue uchun)
5. **peek** - Queue boshidagi element qiymatini olib tashlamasdan olish

## Queue Turlari

1. **Simple Queue** (Oddiy navbat) - FIFO tamoyiliga asoslangan oddiy navbat
2. **Priority Queue** (Prioritetli navbat) - Elementlarga prioritet beriladigan navbat
3. **Double Ended Queue (Deque)** (Ikki tomonlama navbat) - Ikkala tomondan ham element qo'shish/olib tashlash mumkin

## Queue Interface va Implementatsiyalari

### Queue Interface Ierarxiyasi

```
        Iterable
            |
        Collection
            |
          Queue---------|
            |           |
          Deque        PriorityQueue
        /       \
LinkedList      ArrayDeque
```

Queue - bu elementlarni qayta ishlashdan oldin saqlash uchun mo'ljallangan kolleksiya. Asosiy Collection operatsiyalaridan tashqari, queue'lar qo'shimcha qo'shish, olish va tekshirish operatsiyalarini ta'minlaydi.

## SimpleQueue Implementatsiyasi

### SimpleQueue<E> Class'i

```java
package collectionsframework.queue;

import java.util.Arrays;
import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.StringJoiner;

/**
 * SimpleQueue - FIFO (First In First Out) tamoyiliga asoslangan oddiy navbat
 * @param <E> navbat elementlarining turi
 */
public class SimpleQueue<E> implements Iterable<E> {
    private Object[] elements;  // Elementlarni saqlash uchun array
    private int size = 0;       // Navbatdagi elementlar soni
    
    /**
     * Constructor - berilgan sig'im bilan queue yaratish
     * @param capacity navbatning maksimal sig'imi
     */
    public SimpleQueue(int capacity) {
        this.elements = new Object[capacity];
    }
    
    /**
     * Elementni navbat oxiriga qo'shish (enqueue)
     * @param element qo'shiladigan element
     * @return true - agar element qo'shilgan bo'lsa, false - agar navbat to'la bo'lsa
     */
    public boolean enqueue(E element) {
        if (isFull()) {
            return false;  // Navbat to'la
        }
        elements[size++] = element;
        return true;
    }
    
    /**
     * Navbat boshidagi elementni olib tashlash (dequeue)
     * @return navbat boshidagi element
     * @throws NoSuchElementException agar navbat bo'sh bo'lsa
     */
    @SuppressWarnings("unchecked")
    public E dequeue() {
        if (isEmpty()) {
            throw new NoSuchElementException("Queue is empty");
        }
        
        // Boshidagi elementni olish
        E frontElement = (E) elements[0];
        
        // Barcha elementlarni bir pozitsiyaga siljitish
        System.arraycopy(elements, 1, elements, 0, size - 1);
        
        // Oxirgi elementni null qilish va size'ni kamaytirish
        elements[size - 1] = null;
        size--;
        
        return frontElement;
    }
    
    /**
     * Navbat boshidagi elementni olib tashlamasdan olish (peek)
     * @return navbat boshidagi element
     * @throws NoSuchElementException agar navbat bo'sh bo'lsa
     */
    @SuppressWarnings("unchecked")
    public E peek() {
        if (isEmpty()) {
            throw new NoSuchElementException("Queue is empty");
        }
        return (E) elements[0];
    }
    
    /**
     * Navbat bo'sh yoki yo'qligini tekshirish
     * @return true - agar navbat bo'sh bo'lsa
     */
    public boolean isEmpty() {
        return size == 0;
    }
    
    /**
     * Navbat to'la yoki yo'qligini tekshirish
     * @return true - agar navbat to'la bo'lsa
     */
    public boolean isFull() {
        return size == elements.length;
    }
    
    /**
     * Navbatdagi elementlar sonini qaytarish
     * @return elementlar soni
     */
    public int size() {
        return size;
    }
    
    /**
     * Navbatni tozalash
     */
    public void clear() {
        // Barcha elementlarni null qilish
        for (int i = 0; i < size; i++) {
            elements[i] = null;
        }
        size = 0;
    }
    
    /**
     * Navbatni string ko'rinishiga o'tkazish
     * @return string formatdagi navbat
     */
    @Override
    public String toString() {
        var sj = new StringJoiner(", ", "[", "]");
        this.forEach(e -> sj.add(String.valueOf(e)));
        return sj.toString();
    }
    
    /**
     * Iterator yaratish - for-each loop uchun
     * @return iterator
     */
    @Override
    public Iterator<E> iterator() {
        return new Iterator<E>() {
            private int currentIndex = 0;
            
            @Override
            public boolean hasNext() {
                return currentIndex < size;
            }
            
            @Override
            @SuppressWarnings("unchecked")
            public E next() {
                if (!hasNext()) {
                    throw new NoSuchElementException();
                }
                return (E) elements[currentIndex++];
            }
        };
    }
    
    /**
     * Test uchun main method
     */
    public static void main(String[] args) {
        // 1. SimpleQueue yaratish
        var queue = new SimpleQueue<Integer>(5);
        
        System.out.println("Yangi queue yaratildi:");
        System.out.println("Is empty? " + queue.isEmpty());
        System.out.println("Is full? " + queue.isFull());
        
        // 2. Elementlar qo'shish
        System.out.println("\nElementlar qo'shish:");
        queue.enqueue(10);
        queue.enqueue(20);
        queue.enqueue(30);
        queue.enqueue(40);
        queue.enqueue(50);
        
        System.out.println("Queue: " + queue);
        System.out.println("Size: " + queue.size());
        System.out.println("Is full? " + queue.isFull());
        
        // 3. Element olib tashlash
        System.out.println("\nElement olib tashlash:");
        System.out.println("Peek (first element): " + queue.peek());
        System.out.println("Dequeue: " + queue.dequeue());
        System.out.println("Queue after dequeue: " + queue);
        
        // 4. For-each bilan iteratsiya
        System.out.println("\nIterating with for-each:");
        for (Integer num : queue) {
            System.out.println("Element: " + num);
        }
        
        // 5. Queue to'ldirish va bo'shatish
        System.out.println("\nQueue operations:");
        while (!queue.isEmpty()) {
            System.out.println("Dequeue: " + queue.dequeue() + ", Remaining size: " + queue.size());
        }
        
        System.out.println("Final queue: " + queue);
        System.out.println("Is empty? " + queue.isEmpty());
    }
}
```

## Patient Class'i (Priority Queue uchun)

```java
package collectionsframework.queue;

/**
 * Patient class - PriorityQueue uchun misol
 * Bemorga qo'yilgan prioritet asosida navbatda joylashadi
 */
public class Patient implements Comparable<Patient> {
    private String fullName;
    private int priority;  // 1 (eng yuqori) - 5 (eng past) gacha
    
    public Patient(String fullName, int priority) {
        if (priority < 1 || priority > 5) {
            throw new IllegalArgumentException("Priority must be between 1 and 5");
        }
        this.fullName = fullName;
        this.priority = priority;
    }
    
    /**
     * Comparable implementatsiyasi - yuqori prioritet birinchi chiqadi
     */
    @Override
    public int compareTo(Patient other) {
        // Yuqori raqamli prioritet (1) past raqamli prioritetdan (5) ustun turadi
        return Integer.compare(this.priority, other.priority);
    }
    
    /**
     * Teskari tartiblangan compareTo (yuqori prioritet birinchi)
     * Agar yuqori prioritet (kichik raqam) birinchi chiqishi kerak bo'lsa:
     */
    /*
    @Override
    public int compareTo(Patient other) {
        // Kichik raqamli prioritetlar (1) katta raqamli prioritetlardan (5) ustun
        return Integer.compare(this.priority, other.priority) * -1;
    }
    */
    
    public String getFullName() {
        return fullName;
    }
    
    public int getPriority() {
        return priority;
    }
    
    public String getPriorityDescription() {
        switch (priority) {
            case 1: return "Emergency (Shoshilinch)";
            case 2: return "Urgent (Zarur)";
            case 3: return "High (Yuqori)";
            case 4: return "Medium (O'rtacha)";
            case 5: return "Low (Past)";
            default: return "Unknown";
        }
    }
    
    @Override
    public String toString() {
        return String.format("Patient{name='%s', priority=%d (%s)}", 
                            fullName, priority, getPriorityDescription());
    }
}
```

## Java PriorityQueue Test

```java
package collectionsframework.queue;

import java.util.Comparator;
import java.util.PriorityQueue;

/**
 * Java PriorityQueue sinfidan foydalanish misollari
 * PriorityQueue - elementlarni prioritet asosida tartiblaydi
 */
public class JavaPriorityQueueTest {
    
    public static void main(String[] args) {
        System.out.println("========== STRING PRIORITY QUEUE ==========");
        
        // 1. String uchun PriorityQueue (natural ordering)
        var stringQueue = new PriorityQueue<String>();
        stringQueue.add("Java");
        stringQueue.add("C++");
        stringQueue.add("AA");
        stringQueue.add("Kotlin");
        stringQueue.add("Python");
        
        System.out.println("Queue (not sorted order): " + stringQueue);
        System.out.println("Peek (highest priority): " + stringQueue.peek());
        
        System.out.println("\nPolling elements in priority order:");
        while (!stringQueue.isEmpty()) {
            System.out.println("Poll: " + stringQueue.poll());
        }
        
        System.out.println("\n========== PATIENT PRIORITY QUEUE ==========");
        
        // 2. Patient uchun PriorityQueue (Comparator bilan)
        var patients = new PriorityQueue<Patient>(
            Comparator.comparingInt(Patient::getPriority)
        );
        
        // Bemorlarni qo'shish
        patients.add(new Patient("Akbar Akbarov", 2));    // Zarur
        patients.add(new Patient("Asliddin Abdullayev", 3)); // Yuqori
        patients.add(new Patient("Karimov Javlon", 5));   // Past
        patients.add(new Patient("Nosirova Malika", 1));  // Shoshilinch
        patients.add(new Patient("Toshmatov Temur", 4));  // O'rtacha
        
        System.out.println("Patients in queue: " + patients.size());
        
        System.out.println("\nTreating patients by priority:");
        int treatmentNumber = 1;
        while (!patients.isEmpty()) {
            Patient patient = patients.poll();
            System.out.printf("%d. %s (Priority: %d - %s)%n",
                treatmentNumber++,
                patient.getFullName(),
                patient.getPriority(),
                patient.getPriorityDescription());
        }
        
        System.out.println("\n========== REVERSE PRIORITY QUEUE ==========");
        
        // 3. Teskari tartibdagi PriorityQueue
        var reversePatients = new PriorityQueue<Patient>(
            Comparator.comparingInt(Patient::getPriority).reversed()
        );
        
        reversePatients.add(new Patient("Ali Valiyev", 2));
        reversePatients.add(new Patient("Bekzod Bekmurodov", 1));
        reversePatients.add(new Patient("Dilnoza Karimova", 4));
        
        System.out.println("Patients in reverse priority order:");
        while (!reversePatients.isEmpty()) {
            System.out.println("Poll: " + reversePatients.poll());
        }
        
        System.out.println("\n========== CUSTOM COMPARATOR ==========");
        
        // 4. Custom Comparator bilan PriorityQueue
        var customQueue = new PriorityQueue<Patient>(
            (p1, p2) -> {
                // Avval prioritet bo'yicha, keyin ism bo'yicha
                int priorityCompare = Integer.compare(p1.getPriority(), p2.getPriority());
                if (priorityCompare != 0) {
                    return priorityCompare;
                }
                return p1.getFullName().compareTo(p2.getFullName());
            }
        );
        
        customQueue.add(new Patient("Zafar Zafarov", 3));
        customQueue.add(new Patient("Akmal Akmalov", 3)); // Bir xil prioritet
        customQueue.add(new Patient("Bahrom Bahromov", 2));
        
        System.out.println("Patients with custom comparator:");
        while (!customQueue.isEmpty()) {
            System.out.println("Poll: " + customQueue.poll());
        }
    }
}
```

## Queue Turli Implementatsiyalari

```java
package collectionsframework.queue;

import java.util.ArrayDeque;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Queue;
import java.util.concurrent.ArrayBlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;

/**
 * Queue'ning turli implementatsiyalari va ularning farqlari
 */
public class QueueImplementations {
    
    public static void main(String[] args) {
        System.out.println("========== LINKEDLIST AS QUEUE ==========");
        
        // 1. LinkedList as Queue (FIFO)
        Queue<String> linkedListQueue = new LinkedList<>();
        linkedListQueue.add("First");
        linkedListQueue.add("Second");
        linkedListQueue.add("Third");
        
        System.out.println("LinkedList Queue: " + linkedListQueue);
        System.out.println("Poll: " + linkedListQueue.poll());
        System.out.println("After poll: " + linkedListQueue);
        
        System.out.println("\n========== ARRAYDEQUE AS QUEUE ==========");
        
        // 2. ArrayDeque as Queue (Tezroq, lekin fixed size emas)
        Queue<Integer> arrayDequeQueue = new ArrayDeque<>();
        arrayDequeQueue.offer(100);
        arrayDequeQueue.offer(200);
        arrayDequeQueue.offer(300);
        
        System.out.println("ArrayDeque Queue: " + arrayDequeQueue);
        System.out.println("Peek: " + arrayDequeQueue.peek());
        System.out.println("Size: " + arrayDequeQueue.size());
        
        System.out.println("\n========== PRIORITYQUEUE ==========");
        
        // 3. PriorityQueue (Natural ordering)
        Queue<Integer> priorityQueue = new PriorityQueue<>();
        priorityQueue.add(30);
        priorityQueue.add(10);
        priorityQueue.add(20);
        priorityQueue.add(5);
        
        System.out.println("PriorityQueue (not sorted): " + priorityQueue);
        System.out.println("Polling in order:");
        while (!priorityQueue.isEmpty()) {
            System.out.println("Poll: " + priorityQueue.poll());
        }
        
        System.out.println("\n========== ARRAYBLOCKINGQUEUE ==========");
        
        // 4. ArrayBlockingQueue (Fixed size, thread-safe)
        Queue<String> blockingQueue = new ArrayBlockingQueue<>(3);
        blockingQueue.offer("A");
        blockingQueue.offer("B");
        blockingQueue.offer("C");
        
        // To'liq queue'ga yana element qo'shish
        boolean added = blockingQueue.offer("D");  // false qaytaradi, lekin exception emas
        System.out.println("Added 'D' to full queue? " + added);
        
        System.out.println("ArrayBlockingQueue: " + blockingQueue);
        
        System.out.println("\n========== LINKEDBLOCKINGQUEUE ==========");
        
        // 5. LinkedBlockingQueue (Unbounded, thread-safe)
        Queue<Double> linkedBlockingQueue = new LinkedBlockingQueue<>();
        linkedBlockingQueue.offer(1.1);
        linkedBlockingQueue.offer(2.2);
        linkedBlockingQueue.offer(3.3);
        
        System.out.println("LinkedBlockingQueue: " + linkedBlockingQueue);
        System.out.println("Take (would block): not shown in this example");
    }
}
```

## Deque (Double Ended Queue)

```java
package collectionsframework.queue;

import java.util.ArrayDeque;
import java.util.Deque;

/**
 * Deque (Double Ended Queue) - ikki tomonlama navbat
 */
public class DequeExample {
    
    public static void main(String[] args) {
        System.out.println("========== DEQUE AS STACK ==========");
        
        // 1. Deque ni Stack sifatida ishlatish
        Deque<String> stack = new ArrayDeque<>();
        
        // Push - element qo'shish (Stack usuli)
        stack.push("First");
        stack.push("Second");
        stack.push("Third");
        
        System.out.println("Stack: " + stack);
        System.out.println("Peek (top): " + stack.peek());
        System.out.println("Pop: " + stack.pop());
        System.out.println("After pop: " + stack);
        
        System.out.println("\n========== DEQUE AS QUEUE ==========");
        
        // 2. Deque ni Queue sifatida ishlatish
        Deque<Integer> dequeAsQueue = new ArrayDeque<>();
        
        // Queue operatsiyalari
        dequeAsQueue.offerLast(10);  // enqueue
        dequeAsQueue.offerLast(20);
        dequeAsQueue.offerLast(30);
        
        System.out.println("Queue: " + dequeAsQueue);
        System.out.println("Peek first: " + dequeAsQueue.peekFirst());
        System.out.println("Poll first: " + dequeAsQueue.pollFirst());
        System.out.println("After poll: " + dequeAsQueue);
        
        System.out.println("\n========== DEQUE BOTH ENDS ==========");
        
        // 3. Ikkala tomondan operatsiyalar
        Deque<Character> deque = new ArrayDeque<>();
        
        // Boshiga va oxiriga element qo'shish
        deque.addFirst('A');
        deque.addLast('Z');
        deque.addFirst('B');
        deque.addLast('Y');
        
        System.out.println("Deque: " + deque);
        System.out.println("First: " + deque.getFirst());
        System.out.println("Last: " + deque.getLast());
        
        // Boshidan va oxiridan element olib tashlash
        System.out.println("Remove first: " + deque.removeFirst());
        System.out.println("Remove last: " + deque.removeLast());
        System.out.println("Deque after removal: " + deque);
        
        System.out.println("\n========== CIRCULAR BUFFER ==========");
        
        // 4. Circular buffer (aylanma buffer) misoli
        Deque<String> circularBuffer = new ArrayDeque<>(3);
        
        // Buffer to'ldirish
        circularBuffer.addLast("Data1");
        circularBuffer.addLast("Data2");
        circularBuffer.addLast("Data3");
        
        System.out.println("Buffer full: " + circularBuffer);
        
        // Yangi ma'lumot - eski ma'lumot chiqib ketadi
        circularBuffer.addLast("Data4");  // Data1 chiqib ketadi
        System.out.println("After adding Data4: " + circularBuffer);
    }
}
```

## Queue Performance Comparison

```java
package collectionsframework.queue;

import java.util.ArrayDeque;
import java.util.LinkedList;
import java.util.PriorityQueue;
import java.util.Queue;

/**
 * Turli Queue implementatsiyalarining performance taqqoslash
 */
public class QueuePerformanceComparison {
    
    public static void main(String[] args) {
        final int operationCount = 100000;
        
        System.out.println("Performance test for " + operationCount + " operations");
        System.out.println("=" .repeat(50));
        
        // 1. LinkedList performance
        Queue<Integer> linkedList = new LinkedList<>();
        long startTime = System.currentTimeMillis();
        
        for (int i = 0; i < operationCount; i++) {
            linkedList.offer(i);
        }
        for (int i = 0; i < operationCount; i++) {
            linkedList.poll();
        }
        
        long endTime = System.currentTimeMillis();
        System.out.println("LinkedList Queue time: " + (endTime - startTime) + "ms");
        
        // 2. ArrayDeque performance
        Queue<Integer> arrayDeque = new ArrayDeque<>();
        startTime = System.currentTimeMillis();
        
        for (int i = 0; i < operationCount; i++) {
            arrayDeque.offer(i);
        }
        for (int i = 0; i < operationCount; i++) {
            arrayDeque.poll();
        }
        
        endTime = System.currentTimeMillis();
        System.out.println("ArrayDeque Queue time: " + (endTime - startTime) + "ms");
        
        // 3. PriorityQueue performance
        Queue<Integer> priorityQueue = new PriorityQueue<>();
        startTime = System.currentTimeMillis();
        
        for (int i = 0; i < operationCount; i++) {
            priorityQueue.offer(i);
        }
        for (int i = 0; i < operationCount; i++) {
            priorityQueue.poll();
        }
        
        endTime = System.currentTimeMillis();
        System.out.println("PriorityQueue time: " + (endTime - startTime) + "ms");
        
        System.out.println("\n" + "=" .repeat(50));
        System.out.println("SUMMARY:");
        System.out.println("- ArrayDeque: Eng tez, lekin fixed size emas");
        System.out.println("- LinkedList: O'rtacha tezlik, barcha operatsiyalar O(1)");
        System.out.println("- PriorityQueue: Eng sekin, chunki har qo'shish/o'chirish O(log n)");
    }
}
```

## Amaliy Maslahatlar

1. **Qachon qaysi Queue ishlatish kerak?**
    - **LinkedList** - Umumiy maqsadli queue, Deque operatsiyalari kerak bo'lsa
    - **ArrayDeque** - Tez queue kerak bo'lsa, Stack sifatida ham ishlatish mumkin
    - **PriorityQueue** - Elementlarni prioritet asosida tartiblash kerak bo'lsa
    - **ArrayBlockingQueue** - Fixed size, thread-safe queue kerak bo'lsa

2. **Queue operatsiyalari:**
    - **add()/offer()** - Element qo'shish (offer to'liq queue'da false qaytaradi)
    - **remove()/poll()** - Element olib tashlash (poll bo'sh queue'da null qaytaradi)
    - **element()/peek()** - Element ko'rish (peek bo'sh queue'da null qaytaradi)

3. **Thread safety:**
    - LinkedList, ArrayDeque, PriorityQueue - thread-safe EMAS
    - ArrayBlockingQueue, LinkedBlockingQueue - thread-safe

4. **Performance:**
    - **ArrayDeque** - Eng tez (array-based)
    - **LinkedList** - Har bir element alohida ob'ekt (memory overhead)
    - **PriorityQueue** - Heap-based, O(log n) operatsiyalar

---

**Keyingi mavzu:** [09_Dictionary_Data_Structure.md](./09_Dictionary_Data_Structure.md)

**Oldingi mavzu:** [07_LinkedHashSet.md](./07_LinkedHashSet.md)

**Asosiy sahifaga qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Queue** - Navbat, FIFO tamoyili
- **FIFO** - First In First Out (Birinchi kirgan birinchi chiqadi)
- **Deque** - Double Ended Queue (Ikki tomonlama navbat)
- **PriorityQueue** - Prioritetli navbat
- **enqueue** - Element qo'shish
- **dequeue** - Element olib tashlash
- **peek** - Element ko'rish (olib tashlamasdan)
- **Stack** - LIFO tamoyili (Last In First Out)

> **Bolalar, o'rganishda davom etamiz!** 🚀