# Legacy Collections va Internationalization (i18n)

## Legacy Collections (Eski Kolleksiyalar)

### Property Maps (Xususiyat Xaritalari)

**Property map** - bu maxsus turdagi xarita strukturasi. Uning uchta o'ziga xos xususiyati bor:

1. Kalitlar va qiymatlar string'lar
2. Xarita osongina faylga saqlanishi va fayldan yuklanishi mumkin
3. Java platformasida property map'ni amalga oshiradigan class **Properties** deb ataladi

Property maps dasturlar uchun konfiguratsiya variantlarini belgilashda foydalidir. Properties `.properties` va xml fayllaridan o'qiydi.

#### .properties Fayl Misoli

```properties
# Database konfiguratsiyasi
database.url=jdbc:postgresql://localhost:5432/mydb
database.username=admin
database.password=secret123
database.driver=org.postgresql.Driver

# Ilova sozlamalari
app.name=MyApplication
app.version=1.0.0
app.debug=true

# Xabarlar
welcome.message=Welcome to our application!
error.message=An error occurred

# Ko'p qatorli xabar (backslash bilan davom ettirish)
description=Lorem ipsum dolor sit amet, consectetur adipisicing elit. \
    Autem dignissimos eos eveniet ex fuga hic itaque, laboriosam minus \
    necessitatibus, nesciunt non odit omnis quas quos, repellendus sit vero?
```

#### XML Fayl Misoli

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
    <entry key="database.url">jdbc:postgresql://localhost:5432/mydb</entry>
    <entry key="database.username">admin</entry>
    <entry key="database.password">secret123</entry>
    <entry key="app.name">MyApplication</entry>
</properties>
```

### Hashtable

**Hashtable** class'i HashMap class'i bilan bir xil maqsadga xizmat qiladi va asosan bir xil interfeysga ega. Vector class'ining method'lari kabi, Hashtable method'lari ham **synchronized**. Agar siz legacy code bilan moslik talab qilmasangiz, HashMap ishlatishingiz kerak. Agar concurrent access kerak bo'lsa, ConcurrentHashMap ishlating.

### Stack Data Structure

**Stack** - bu Last In First Out (LIFO) prinsipiga amal qiladigan linear data structure. Bu shuni anglatadiki, stack'ga oxirgi kiritilgan element birinchi o'linadi.

#### Stack Data Structure Method'lari

1. **push** - Elementni stack'ning yuqorisiga qo'yish
2. **pop** - Stack'ning yuqorisidagi elementni olib tashlash
3. **peek** - Stack'ning yuqorisidagi elementni olib tashlamasdan olish

### Stack Class'i

1.0 versiyasidan boshlab, standart kutubxonada push va pop method'lariga ega Stack class'i mavjud. Biroq, Stack class'i Vector class'ini kengaytiradi, bu nazariy nuqtai nazardan qoniqarli emas.

```
List <- AbstractList <- Vector <- Stack
```

## Legacy Collections Amaliyotda

### Custom Stack Implementatsiyasi

#### Stack Class'i

```java
package collectionsframework.legacycollections;

import java.util.Iterator;
import java.util.NoSuchElementException;
import java.util.Objects;
import java.util.StringJoiner;

/**
 * Stack - LIFO (Last In First Out) tamoyiliga asoslangan ma'lumotlar tuzilmasi
 * @param <E> stack elementlarining turi
 */
public class Stack<E> implements Iterable<E> {
    public static final int DEFAULT_CAPACITY = 10;
    private Object[] elements;
    private int size = 0;
    
    /**
     * Default constructor - default capacity bilan
     */
    public Stack() {
        this(DEFAULT_CAPACITY);
    }
    
    /**
     * Berilgan capacity bilan constructor
     * @param capacity stack'ning maksimal sig'imi
     */
    public Stack(int capacity) {
        if (capacity <= 0) {
            throw new IllegalArgumentException("Capacity must be positive");
        }
        this.elements = new Object[capacity];
    }
    
    /**
     * Elementni stack'ning yuqorisiga qo'yish
     * @param element qo'yiladigan element
     * @return qo'yilgan element
     * @throws StackOperationException agar stack to'la bo'lsa
     */
    public E push(E element) {
        if (isFull()) {
            throw new StackOperationException("Stack is full");
        }
        elements[size++] = element;
        return element;
    }
    
    /**
     * Stack'ning yuqorisidagi elementni olib tashlamasdan olish
     * @return stack'ning yuqorisidagi element
     * @throws StackOperationException agar stack bo'sh bo'lsa
     */
    @SuppressWarnings("unchecked")
    public E peek() {
        if (isEmpty()) {
            throw new StackOperationException("Stack is empty");
        }
        return (E) elements[size - 1];
    }
    
    /**
     * Stack'ning yuqorisidagi elementni olib tashlash
     * @return olib tashlangan element
     * @throws StackOperationException agar stack bo'sh bo'lsa
     */
    @SuppressWarnings("unchecked")
    public E pop() {
        if (isEmpty()) {
            throw new StackOperationException("Stack is empty");
        }
        E removedElement = (E) elements[size - 1];
        elements[--size] = null;  // Memory leak'ni oldini olish
        return removedElement;
    }
    
    /**
     * Stack bo'sh yoki yo'qligini tekshirish
     * @return true - agar stack bo'sh bo'lsa
     */
    public boolean isEmpty() {
        return size == 0;
    }
    
    /**
     * Stack to'la yoki yo'qligini tekshirish
     * @return true - agar stack to'la bo'lsa
     */
    public boolean isFull() {
        return size == elements.length;
    }
    
    /**
     * Stack'dagi elementlar soni
     * @return elementlar soni
     */
    public int size() {
        return size;
    }
    
    /**
     * Stack'ni tozalash
     */
    public void clear() {
        for (int i = 0; i < size; i++) {
            elements[i] = null;
        }
        size = 0;
    }
    
    /**
     * Elementning stack'dagi pozitsiyasini topish (1-based)
     * @param element qidirilayotgan element
     * @return elementning pozitsiyasi (yuqoridan pastga) yoki -1 agar topilmasa
     */
    public int search(Object element) {
        for (int i = size - 1; i >= 0; i--) {
            if (Objects.equals(elements[i], element)) {
                return size - i;  // 1-based: yuqoridagi element 1-pozitsiya
            }
        }
        return -1;
    }
    
    /**
     * Stack'ning string ko'rinishi
     * @return string formatdagi stack
     */
    @Override
    public String toString() {
        var sj = new StringJoiner(", ", "[", "]");
        this.forEach(e -> sj.add(Objects.toString(e)));
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
     * Stack operation exception
     */
    public static class StackOperationException extends RuntimeException {
        public StackOperationException(String message) {
            super(message);
        }
    }
}
```

#### CustomStackClassTest

```java
package collectionsframework.legacycollections;

/**
 * Custom Stack sinfini test qilish
 */
public class CustomStackClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== CUSTOM STACK IMPLEMENTATION ==========");
        
        // 1. Stack yaratish
        Stack<String> stack = new Stack<>(10);
        System.out.println("1. Stack created:");
        System.out.println("   Is empty? " + stack.isEmpty());
        System.out.println("   Is full? " + stack.isFull());
        System.out.println("   Size: " + stack.size());
        
        // 2. Elementlar qo'shish (push)
        System.out.println("\n2. Pushing elements:");
        stack.push("Java");
        stack.push("Pascal");
        stack.push("Delphi");
        stack.push("BASIC");
        stack.push("Kotlin");
        
        System.out.println("   Stack: " + stack);
        System.out.println("   Size: " + stack.size());
        System.out.println("   Is empty? " + stack.isEmpty());
        
        // 3. Peek operation
        System.out.println("\n3. Peek operation:");
        System.out.println("   Top element: " + stack.peek());
        System.out.println("   Stack after peek: " + stack);
        
        // 4. Pop operation
        System.out.println("\n4. Pop operation:");
        String popped = stack.pop();
        System.out.println("   Popped element: " + popped);
        System.out.println("   Stack after pop: " + stack);
        System.out.println("   New top: " + stack.peek());
        
        // 5. Search operation
        System.out.println("\n5. Search operation:");
        int position = stack.search("Java");
        System.out.println("   Position of 'Java': " + position + " (from top)");
        
        position = stack.search("Pascal");
        System.out.println("   Position of 'Pascal': " + position + " (from top)");
        
        position = stack.search("NonExistent");
        System.out.println("   Position of 'NonExistent': " + position);
        
        // 6. For-each loop bilan iteratsiya
        System.out.println("\n6. Iterating with for-each:");
        for (String language : stack) {
            System.out.println("   Language: " + language);
        }
        
        // 7. Stack to'ldirish va bo'shatish
        System.out.println("\n7. Emptying the stack:");
        while (!stack.isEmpty()) {
            System.out.println("   Popping: " + stack.pop());
        }
        System.out.println("   Stack after emptying: " + stack);
        System.out.println("   Is empty? " + stack.isEmpty());
        
        // 8. Stack overflow test
        System.out.println("\n8. Stack overflow test:");
        try {
            for (int i = 0; i < 11; i++) {
                stack.push("Element " + i);
            }
        } catch (Stack.StackOperationException e) {
            System.out.println("   Exception caught: " + e.getMessage());
        }
        
        // 9. Real-world example - undo/redo
        System.out.println("\n9. Real-world example - Undo/Redo system:");
        Stack<String> undoStack = new Stack<>(50);
        Stack<String> redoStack = new Stack<>(50);
        
        // Amallar bajarish
        performAction("Type 'Hello'", undoStack, redoStack);
        performAction("Bold text", undoStack, redoStack);
        performAction("Italic text", undoStack, redoStack);
        
        System.out.println("   Current state: " + undoStack.peek());
        
        // Undo
        undo(undoStack, redoStack);
        System.out.println("   After undo: " + undoStack.peek());
        
        // Redo
        redo(undoStack, redoStack);
        System.out.println("   After redo: " + undoStack.peek());
    }
    
    private static void performAction(String action, Stack<String> undoStack, Stack<String> redoStack) {
        undoStack.push(action);
        redoStack.clear();  // Yangi amal - redo stack'ni tozalash
        System.out.println("   Action performed: " + action);
    }
    
    private static void undo(Stack<String> undoStack, Stack<String> redoStack) {
        if (!undoStack.isEmpty()) {
            String action = undoStack.pop();
            redoStack.push(action);
        }
    }
    
    private static void redo(Stack<String> undoStack, Stack<String> redoStack) {
        if (!redoStack.isEmpty()) {
            String action = redoStack.pop();
            undoStack.push(action);
        }
    }
}
```

#### Java StackClass Test

```java
package collectionsframework.legacycollections;

import java.util.Stack;

/**
 * Java standart Stack sinfidan foydalanish
 */
public class JavaStackClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== JAVA STANDARD STACK CLASS ==========");
        
        // 1. Stack yaratish
        Stack<String> stack = new Stack<>();
        
        System.out.println("1. Stack operations:");
        System.out.println("   Initial stack: " + stack);
        System.out.println("   Is empty? " + stack.isEmpty());
        
        // 2. Push operations
        stack.push("Java");
        stack.push("Pascal");
        stack.push("Delphi");
        stack.push("BASIC");
        stack.push("Kotlin");
        
        System.out.println("\n2. After pushing 5 elements:");
        System.out.println("   Stack: " + stack);
        System.out.println("   Size: " + stack.size());
        System.out.println("   Capacity (not available in Stack API)");
        
        // 3. Peek operation
        System.out.println("\n3. Peek operation:");
        String topElement = stack.peek();
        System.out.println("   Top element: " + topElement);
        System.out.println("   Stack after peek (unchanged): " + stack);
        
        // 4. Pop operation
        System.out.println("\n4. Pop operation:");
        String popped = stack.pop();
        System.out.println("   Popped element: " + popped);
        System.out.println("   Stack after pop: " + stack);
        System.out.println("   New top: " + stack.peek());
        
        // 5. Search operation
        System.out.println("\n5. Search operation:");
        int position = stack.search("Java");
        System.out.println("   Position of 'Java': " + position + " (from top, 1-based)");
        
        position = stack.search("Kotlin");
        System.out.println("   Position of 'Kotlin' (not in stack): " + position);
        
        // 6. Vector methods (inherited from Vector)
        System.out.println("\n6. Vector methods (inherited):");
        System.out.println("   Element at index 1: " + stack.get(1));
        System.out.println("   First element: " + stack.firstElement());
        System.out.println("   Last element: " + stack.lastElement());
        
        // Not recommended but possible (breaks stack abstraction)
        stack.add(1, "C++");  // O'rtaga element qo'shish
        System.out.println("   After add(1, 'C++'): " + stack);
        
        // 7. Stack-specific behavior
        System.out.println("\n7. Stack-specific behavior:");
        System.out.println("   Java Stack extends Vector (design flaw)");
        System.out.println("   Better alternatives:");
        System.out.println("   - Deque<Integer> stack = new ArrayDeque<>()");
        System.out.println("   - Deque<String> deque = new LinkedList<>()");
        
        // 8. Real-world example - expression evaluation
        System.out.println("\n8. Real-world example - Expression evaluation:");
        String expression = "((a + b) * (c - d))";
        System.out.println("   Expression: " + expression);
        System.out.println("   Has balanced parentheses? " + hasBalancedParentheses(expression));
        
        String unbalanced = "((a + b) * (c - d)";
        System.out.println("   Expression: " + unbalanced);
        System.out.println("   Has balanced parentheses? " + hasBalancedParentheses(unbalanced));
    }
    
    /**
     * Stack yordamida qavslar muvozanatini tekshirish
     */
    private static boolean hasBalancedParentheses(String expression) {
        Stack<Character> stack = new Stack<>();
        
        for (char ch : expression.toCharArray()) {
            if (ch == '(') {
                stack.push(ch);
            } else if (ch == ')') {
                if (stack.isEmpty()) {
                    return false;  // Yopuvchi qavs ochuvchi qavssiz
                }
                stack.pop();
            }
        }
        
        return stack.isEmpty();  // Barcha ochuvchi qavslar yopilgan bo'lishi kerak
    }
}
```

### Properties Class Test

#### config.properties

```properties
# Database konfiguratsiyasi
datasource.driver=org.postgresql.Driver
datasource.url=jdbc:postgresql://localhost:5432/pdpdb
datasource.username=postgres
datasource.password=123

# Ilova sozlamalari
app.name=Student Management System
app.version=2.1.0
app.debug=false

# Xabarlar
welcome.message=Welcome to our application!
login.success=Login successful
login.failed=Invalid username or password

# Ko'p qatorli xabar
about=Lorem ipsum dolor sit amet, consectetur adipisicing elit. \
    Autem dignissimos eos eveniet ex fuga hic itaque, laboriosam minus \
    necessitatibus, nesciunt non odit omnis quas quos, repellendus sit vero? \
    Beatae blanditiis consequatur consequuntur dignissimos dolor \
    dolore dolorem dolorum enim est exercitationem, facere fuga fugit id

# Ranglarni saqlash
color.background=#FFFFFF
color.foreground=#000000
color.accent=#007BFF
```

#### config.xml

```xml
<?xml version="1.0" encoding="UTF-8" ?>
<!DOCTYPE properties SYSTEM "http://java.sun.com/dtd/properties.dtd">
<properties>
    <entry key="database.url">jdbc:postgresql://localhost:5432/pdpdb</entry>
    <entry key="database.username">postgres</entry>
    <entry key="database.password">123</entry>
    <entry key="database.database_name">pdpdb</entry>
    <entry key="app.name">Student Management System</entry>
    <entry key="app.version">2.1.0</entry>
</properties>
```

#### PropertiesClassTest

```java
package collectionsframework.legacycollections;

import java.io.*;
import java.util.Properties;

/**
 * Properties class'idan foydalanish - configuration management
 */
public class PropertiesClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== PROPERTIES CLASS ==========");
        
        // 1. .properties fayldan o'qish
        System.out.println("1. Reading from .properties file:");
        try {
            readFromPropertiesFile();
        } catch (IOException e) {
            System.err.println("Error reading properties file: " + e.getMessage());
        }
        
        // 2. XML fayldan o'qish
        System.out.println("\n2. Reading from XML file:");
        try {
            readFromXMLFile();
        } catch (IOException e) {
            System.err.println("Error reading XML file: " + e.getMessage());
        }
        
        // 3. Properties yaratish va saqlash
        System.out.println("\n3. Creating and saving properties:");
        try {
            createAndSaveProperties();
        } catch (IOException e) {
            System.err.println("Error saving properties: " + e.getMessage());
        }
        
        // 4. System properties bilan ishlash
        System.out.println("\n4. Working with System properties:");
        displaySystemProperties();
        
        // 5. Default qiymatlar bilan ishlash
        System.out.println("\n5. Working with default values:");
        workWithDefaultValues();
    }
    
    /**
     * .properties fayldan o'qish
     */
    private static void readFromPropertiesFile() throws IOException {
        Properties properties = new Properties();
        String propertiesFilePath = "src/collectionsframework/legacycollections/config.properties";
        
        try (FileReader fileReader = new FileReader(propertiesFilePath)) {
            properties.load(fileReader);
            
            System.out.println("   Database Configuration:");
            System.out.println("     Driver: " + properties.getProperty("datasource.driver"));
            System.out.println("     URL: " + properties.getProperty("datasource.url"));
            System.out.println("     Username: " + properties.getProperty("datasource.username"));
            System.out.println("     Password: " + properties.getProperty("datasource.password"));
            
            System.out.println("\n   Application Configuration:");
            System.out.println("     Name: " + properties.getProperty("app.name"));
            System.out.println("     Version: " + properties.getProperty("app.version"));
            System.out.println("     Debug: " + properties.getProperty("app.debug"));
            
            System.out.println("\n   Messages:");
            System.out.println("     Welcome: " + properties.getProperty("welcome.message"));
            
            System.out.println("\n   All properties:");
            properties.forEach((key, value) -> 
                System.out.println("     " + key + " = " + value)
            );
        }
    }
    
    /**
     * XML fayldan o'qish
     */
    private static void readFromXMLFile() throws IOException {
        Properties properties = new Properties();
        String xmlFilePath = "src/collectionsframework/legacycollections/config.xml";
        
        try (FileInputStream fileInputStream = new FileInputStream(xmlFilePath)) {
            properties.loadFromXML(fileInputStream);
            
            System.out.println("   Database Configuration from XML:");
            System.out.println("     URL: " + properties.getProperty("database.url"));
            System.out.println("     Username: " + properties.getProperty("database.username"));
            System.out.println("     Database: " + properties.getProperty("database.database_name"));
            
            System.out.println("\n   All properties from XML:");
            properties.forEach((key, value) -> 
                System.out.println("     " + key + " = " + value)
            );
        }
    }
    
    /**
     * Properties yaratish va saqlash
     */
    private static void createAndSaveProperties() throws IOException {
        Properties appConfig = new Properties();
        
        // Property'lar qo'shish
        appConfig.setProperty("app.name", "MyNewApp");
        appConfig.setProperty("app.version", "1.0.0");
        appConfig.setProperty("server.port", "8080");
        appConfig.setProperty("server.host", "localhost");
        appConfig.setProperty("logging.level", "INFO");
        
        // Comment bilan saqlash
        String comments = "Application Configuration\nCreated: " + new java.util.Date();
        
        // .properties faylga saqlash
        try (FileWriter writer = new FileWriter("src/collectionsframework/legacycollections/newconfig.properties")) {
            appConfig.store(writer, comments);
            System.out.println("   Saved to newconfig.properties");
        }
        
        // XML faylga saqlash
        try (FileOutputStream fos = new FileOutputStream("src/collectionsframework/legacycollections/newconfig.xml")) {
            appConfig.storeToXML(fos, "Application Configuration XML");
            System.out.println("   Saved to newconfig.xml");
        }
        
        // Ekranga chiqarish
        System.out.println("\n   Created properties:");
        appConfig.forEach((key, value) -> 
            System.out.println("     " + key + " = " + value)
        );
    }
    
    /**
     * System properties bilan ishlash
     */
    private static void displaySystemProperties() {
        Properties systemProps = System.getProperties();
        
        System.out.println("   Java Version: " + systemProps.getProperty("java.version"));
        System.out.println("   Java Home: " + systemProps.getProperty("java.home"));
        System.out.println("   OS Name: " + systemProps.getProperty("os.name"));
        System.out.println("   OS Version: " + systemProps.getProperty("os.version"));
        System.out.println("   User Name: " + systemProps.getProperty("user.name"));
        System.out.println("   User Home: " + systemProps.getProperty("user.home"));
        
        // Environment variables
        System.out.println("\n   Environment variables:");
        System.out.println("     PATH: " + System.getenv("PATH"));
        System.out.println("     HOME: " + System.getenv("HOME"));
    }
    
    /**
     * Default qiymatlar bilan ishlash
     */
    private static void workWithDefaultValues() {
        Properties properties = new Properties();
        
        // Default qiymatlarni belgilash
        properties.setProperty("timeout", "30");
        properties.setProperty("max.connections", "100");
        
        // Get with default value
        String timeout = properties.getProperty("timeout", "60");
        String maxConn = properties.getProperty("max.connections", "50");
        String nonExistent = properties.getProperty("non.existent", "DEFAULT_VALUE");
        
        System.out.println("   Timeout: " + timeout + " (from properties)");
        System.out.println("   Max connections: " + maxConn + " (from properties)");
        System.out.println("   Non-existent: " + nonExistent + " (default)");
        
        // Properties'ni birlashtirish
        Properties defaults = new Properties();
        defaults.setProperty("timeout", "60");
        defaults.setProperty("retry.count", "3");
        
        Properties combined = new Properties(defaults);
        combined.setProperty("timeout", "30");  // Override default
        
        System.out.println("\n   Combined properties:");
        System.out.println("     Timeout: " + combined.getProperty("timeout"));
        System.out.println("     Retry count: " + combined.getProperty("retry.count"));
        System.out.println("     Non-existent: " + combined.getProperty("non.existent", "NOT_FOUND"));
    }
}
```

### HashtableClassTest

```java
package collectionsframework.legacycollections;

import java.util.*;

/**
 * Hashtable vs HashMap taqqoslash
 */
public class HashtableClassTest {
    
    public static void main(String[] args) {
        System.out.println("========== HASHTABLE VS HASHMAP ==========");
        
        // 1. Hashtable yaratish
        System.out.println("1. Creating Hashtable:");
        Hashtable<Integer, String> hashtable = new Hashtable<>();
        
        // Elementlar qo'shish
        hashtable.put(1, "Java");
        hashtable.put(2, "Scala");
        hashtable.put(3, "Groovy");
        hashtable.put(4, "Kotlin");
        
        System.out.println("   Hashtable: " + hashtable);
        System.out.println("   Size: " + hashtable.size());
        
        // 2. HashMap yaratish
        System.out.println("\n2. Creating HashMap:");
        HashMap<Integer, String> hashMap = new HashMap<>();
        
        hashMap.put(1, "Java");
        hashMap.put(2, "Scala");
        hashMap.put(3, "Groovy");
        
        System.out.println("   HashMap: " + hashMap);
        
        // 3. Hashtable xususiyatlari
        System.out.println("\n3. Hashtable characteristics:");
        System.out.println("   - Synchronized (thread-safe)");
        System.out.println("   - Does not allow null keys or values");
        System.out.println("   - Legacy class (since JDK 1.0)");
        System.out.println("   - Slower than HashMap due to synchronization");
        
        // 4. HashMap xususiyatlari
        System.out.println("\n4. HashMap characteristics:");
        System.out.println("   - Not synchronized (not thread-safe)");
        System.out.println("   - Allows one null key and multiple null values");
        System.out.println("   - Since JDK 1.2");
        System.out.println("   - Faster than Hashtable");
        
        // 5. Null qiymatlar bilan sinov
        System.out.println("\n5. Testing with null values:");
        
        try {
            hashtable.put(null, "Test");  // NullPointerException
        } catch (NullPointerException e) {
            System.out.println("   Hashtable.put(null, value): NullPointerException");
        }
        
        try {
            hashtable.put(5, null);  // NullPointerException
        } catch (NullPointerException e) {
            System.out.println("   Hashtable.put(key, null): NullPointerException");
        }
        
        // HashMap null bilan ishlaydi
        hashMap.put(null, "Null Key");
        hashMap.put(6, null);
        System.out.println("   HashMap with nulls: " + hashMap);
        
        // 6. Performance taqqoslash
        System.out.println("\n6. Performance comparison:");
        performanceComparison();
        
        // 7. Hashtable method'lari
        System.out.println("\n7. Hashtable specific methods:");
        
        // Enumeration (legacy)
        Enumeration<Integer> keys = hashtable.keys();
        System.out.println("   Keys (Enumeration):");
        while (keys.hasMoreElements()) {
            System.out.print("     " + keys.nextElement());
        }
        System.out.println();
        
        // elements() method (legacy)
        Enumeration<String> values = hashtable.elements();
        System.out.println("   Values (Enumeration):");
        while (values.hasMoreElements()) {
            System.out.print("     " + values.nextElement());
        }
        System.out.println();
        
        // 8. Zamonaviy alternativlar
        System.out.println("\n8. Modern alternatives:");
        System.out.println("   - HashMap: General purpose, not thread-safe");
        System.out.println("   - ConcurrentHashMap: Thread-safe, better performance");
        System.out.println("   - Collections.synchronizedMap(): Wrapper for HashMap");
        
        // 9. Collections.synchronizedMap() misoli
        System.out.println("\n9. Collections.synchronizedMap() example:");
        Map<Integer, String> syncMap = Collections.synchronizedMap(new HashMap<>());
        syncMap.put(1, "One");
        syncMap.put(2, "Two");
        System.out.println("   Synchronized map: " + syncMap);
    }
    
    /**
     * Hashtable va HashMap performance taqqoslash
     */
    private static void performanceComparison() {
        final int ELEMENT_COUNT = 100000;
        
        // Hashtable performance
        long startTime = System.currentTimeMillis();
        Hashtable<Integer, Integer> ht = new Hashtable<>();
        for (int i = 0; i < ELEMENT_COUNT; i++) {
            ht.put(i, i * 2);
        }
        long endTime = System.currentTimeMillis();
        System.out.println("   Hashtable put time: " + (endTime - startTime) + "ms");
        
        // HashMap performance
        startTime = System.currentTimeMillis();
        HashMap<Integer, Integer> hm = new HashMap<>();
        for (int i = 0; i < ELEMENT_COUNT; i++) {
            hm.put(i, i * 2);
        }
        endTime = System.currentTimeMillis();
        System.out.println("   HashMap put time: " + (endTime - startTime) + "ms");
        
        // Get performance
        startTime = System.currentTimeMillis();
        for (int i = 0; i < ELEMENT_COUNT; i++) {
            ht.get(i);
        }
        endTime = System.currentTimeMillis();
        System.out.println("   Hashtable get time: " + (endTime - startTime) + "ms");
        
        startTime = System.currentTimeMillis();
        for (int i = 0; i < ELEMENT_COUNT; i++) {
            hm.get(i);
        }
        endTime = System.currentTimeMillis();
        System.out.println("   HashMap get time: " + (endTime - startTime) + "ms");
    }
}
```

## Internationalization (i18n)

### Internationalization Kirish

**Internationalization** - bu turli tillar va mintaqalar uchun moslashtirilishi mumkin bo'lgan ilova yaratish mexanizmi. Internationalization I18N deb qisqartiriladi, chunki birinchi 'I' harfi va oxirgi 'N' harfi o'rtasida jami 18 ta belgi bor.

Internationalization Java'ning kuchli tushunchalaridan biri bo'lib, agar siz ilova ishlab chiqayotgan bo'lsangiz va xabarlar, valyutalar, sana, vaqt va h.k. ni muayyan mintaqa yoki tilga mos ravishda ko'rsatishni xohlasangiz.

**Localization** ham I10N deb qisqartiriladi, chunki birinchi 'L' harfi va oxirgi 'N' harfi o'rtasida jami 10 ta belgi bor. Localization - bu locale-spesifik matn va komponent qo'shish orqali muayyan til va mintaqaga moslashtirilishi mumkin bo'lgan ilova yaratish mexanizmi.

### I18N with Date

Sanalar formati bir mintaqadan ikkinchisiga farq qiladi, shuning uchun biz sanalarni internationalizatsiya qilamiz. Biz DateFormat class'ining `getDateInstance()` method'i yordamida sanalarni internationalizatsiya qilishimiz mumkin. Bu locale ob'ektini parametr sifatida qabul qiladi va DateFormat class'ining instance'ini qaytaradi.

### I18N with Number

Raqamlarning ifodalanishi bir locale'dan ikkinchisiga farq qiladi. Raqamlarni internationalizatsiya qilish locale'larga qarab ma'lumotlarni ko'rsatadigan ilova uchun yaxshi yondashuvdir.

NumberFormat class'i raqamlarni muayyan locale'ga mos formatlash uchun ishlatiladi. NumberFormat class'ining instance'ini olish uchun biz `getInstance()` yoki `getNumberInstance()` method'larini chaqirishimiz kerak.

### I18N with Currency

Sana, vaqt va raqamlarni internationalizatsiya qilganimizdek, valyutani ham internationalizatsiya qilishimiz mumkin. Valyuta bir mamlakatdan ikkinchisiga farq qiladi, shuning uchun biz valyutani internationalizatsiya qilishimiz kerak.

NumberFormat class'i valyutani locale'ga mos formatlash uchun method'larni taqdim etadi. NumberFormat class'ining `getCurrencyInstance()` method'i NumberFormat class'ining instance'ini qaytaradi.

### ResourceBundle

Java ResourceBundle class'i, java.util.ResourceBundle, locale sezgir matnlar va komponentlarni saqlash uchun ishlatiladi. Masalan, ilovingiz ichida ishlatiladigan matn yorliqlari hozirda ilovingizdan foydalanayotgan foydalanuvchining tiliga qarab o'zgarishi mumkin. Matn yorliqlari shunday foydalanuvchi locale sezgir deb aytiladi. Foydalanuvchining locale'i, aytgancha, Java Locale class'i bilan ifodalanadi.

### I18N Amaliyotda

#### I18N Test

```java
package i18n;

import java.text.DateFormat;
import java.text.NumberFormat;
import java.util.Currency;
import java.util.Date;
import java.util.Locale;

/**
 * Internationalization (i18n) misollari
 */
public class I18N {
    
    public static void main(String[] args) {
        System.out.println("========== INTERNATIONALIZATION (I18N) ==========");
        
        // Turli locale'lar yaratish
        Locale englishUS = Locale.US;
        Locale french = Locale.FRENCH;
        Locale japan = Locale.JAPAN;
        Locale italian = Locale.ITALIAN;
        Locale uzbek = Locale.forLanguageTag("uz");
        Locale german = Locale.GERMAN;
        Locale chinese = Locale.CHINESE;
        Locale russian = new Locale("ru", "RU");
        
        // 1. Locale class'i bilan ishlash
        System.out.println("1. Working with Locale class:");
        displayLocaleInfo(englishUS, french, japan, italian, uzbek, german, chinese, russian);
        
        // 2. Sana bilan internationalizatsiya
        System.out.println("\n2. Date internationalization:");
        testDateFormatI18N(new Date(), englishUS, french, japan, italian, uzbek, german, russian);
        
        // 3. Vaqt bilan internationalizatsiya
        System.out.println("\n3. Time internationalization:");
        testTimeFormatI18N(new Date(), englishUS, french, japan, italian, uzbek, german, russian);
        
        // 4. Sana va vaqt bilan internationalizatsiya
        System.out.println("\n4. Date and time internationalization:");
        testDateTimeFormatI18N(new Date(), englishUS, french, japan, italian, uzbek, german, russian);
        
        // 5. Raqamlar bilan internationalizatsiya
        System.out.println("\n5. Number internationalization:");
        testNumberI18N(1234567.89123, englishUS, french, japan, italian, uzbek, german, russian);
        
        // 6. Valyuta bilan internationalizatsiya
        System.out.println("\n6. Currency internationalization:");
        testCurrencyI18N(1234.56, englishUS, french, japan, italian, uzbek, german, russian);
        
        // 7. Foizlar bilan internationalizatsiya
        System.out.println("\n7. Percentage internationalization:");
        testPercentageI18N(0.75, englishUS, french, japan, italian, uzbek, german, russian);
        
        // 8. Default locale bilan ishlash
        System.out.println("\n8. Working with default locale:");
        workWithDefaultLocale();
        
        // 9. Amaliy misol - multi-language ilova
        System.out.println("\n9. Practical example - Multi-language application:");
        practicalExample();
    }
    
    /**
     * Turli locale'lar haqida ma'lumot chiqarish
     */
    private static void displayLocaleInfo(Locale... locales) {
        System.out.println("   Locale information:");
        System.out.println("   " + String.format("%-15s %-20s %-10s %-15s", 
                           "Locale", "Language", "Country", "Display Name"));
        System.out.println("   " + "-".repeat(60));
        
        for (Locale locale : locales) {
            System.out.println("   " + String.format("%-15s %-20s %-10s %-15s",
                               locale,
                               locale.getDisplayLanguage(Locale.ENGLISH),
                               locale.getCountry(),
                               locale.getDisplayName(Locale.ENGLISH)));
        }
    }
    
    /**
     * Sana formatini internationalizatsiya qilish
     */
    private static void testDateFormatI18N(Date date, Locale... locales) {
        System.out.println("   Date formats:");
        
        for (Locale locale : locales) {
            // Turli date style'lar
            DateFormat shortFormat = DateFormat.getDateInstance(DateFormat.SHORT, locale);
            DateFormat mediumFormat = DateFormat.getDateInstance(DateFormat.MEDIUM, locale);
            DateFormat longFormat = DateFormat.getDateInstance(DateFormat.LONG, locale);
            DateFormat fullFormat = DateFormat.getDateInstance(DateFormat.FULL, locale);
            
            System.out.println("\n   " + locale.getDisplayName(Locale.ENGLISH) + ":");
            System.out.println("     Short:  " + shortFormat.format(date));
            System.out.println("     Medium: " + mediumFormat.format(date));
            System.out.println("     Long:   " + longFormat.format(date));
            System.out.println("     Full:   " + fullFormat.format(date));
        }
    }
    
    /**
     * Vaqt formatini internationalizatsiya qilish
     */
    private static void testTimeFormatI18N(Date date, Locale... locales) {
        System.out.println("   Time formats:");
        
        for (Locale locale : locales) {
            // Turli time style'lar
            DateFormat shortFormat = DateFormat.getTimeInstance(DateFormat.SHORT, locale);
            DateFormat mediumFormat = DateFormat.getTimeInstance(DateFormat.MEDIUM, locale);
            DateFormat longFormat = DateFormat.getTimeInstance(DateFormat.LONG, locale);
            DateFormat fullFormat = DateFormat.getTimeInstance(DateFormat.FULL, locale);
            
            System.out.println("\n   " + locale.getDisplayName(Locale.ENGLISH) + ":");
            System.out.println("     Short:  " + shortFormat.format(date));
            System.out.println("     Medium: " + mediumFormat.format(date));
            System.out.println("     Long:   " + longFormat.format(date));
            System.out.println("     Full:   " + fullFormat.format(date));
        }
    }
    
    /**
     * Sana va vaqt formatini internationalizatsiya qilish
     */
    private static void testDateTimeFormatI18N(Date date, Locale... locales) {
        System.out.println("   Date-time formats:");
        
        for (Locale locale : locales) {
            // Date-time format
            DateFormat dateTimeFormat = DateFormat.getDateTimeInstance(
                DateFormat.MEDIUM, DateFormat.MEDIUM, locale);
            
            System.out.println("   " + locale.getDisplayName(Locale.ENGLISH) + 
                             ": " + dateTimeFormat.format(date));
        }
    }
    
    /**
     * Raqamlarni internationalizatsiya qilish
     */
    private static void testNumberI18N(double number, Locale... locales) {
        System.out.println("   Number formats:");
        
        for (Locale locale : locales) {
            NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
            String formatted = numberFormat.format(number);
            
            System.out.println("   " + locale.getDisplayName(Locale.ENGLISH) + 
                             ": " + formatted);
            
            // Integer va kasr qismlarini ko'rsatish
            NumberFormat integerFormat = NumberFormat.getIntegerInstance(locale);
            System.out.println("     Integer: " + integerFormat.format(number));
        }
    }
    
    /**
     * Valyutani internationalizatsiya qilish
     */
    private static void testCurrencyI18N(double amount, Locale... locales) {
        System.out.println("   Currency formats:");
        
        for (Locale locale : locales) {
            NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(locale);
            String formatted = currencyFormat.format(amount);
            
            // Valyuta kodini olish
            Currency currency = currencyFormat.getCurrency();
            String currencyCode = currency.getCurrencyCode();
            String currencySymbol = currency.getSymbol(locale);
            
            System.out.println("   " + locale.getDisplayName(Locale.ENGLISH) + 
                             ": " + formatted + 
                             " (Code: " + currencyCode + 
                             ", Symbol: " + currencySymbol + ")");
        }
    }
    
    /**
     * Foizlarni internationalizatsiya qilish
     */
    private static void testPercentageI18N(double percentage, Locale... locales) {
        System.out.println("   Percentage formats:");
        
        for (Locale locale : locales) {
            NumberFormat percentFormat = NumberFormat.getPercentInstance(locale);
            String formatted = percentFormat.format(percentage);
            
            System.out.println("   " + locale.getDisplayName(Locale.ENGLISH) + 
                             ": " + formatted + " (0.75 = 75%)");
        }
    }
    
    /**
     * Default locale bilan ishlash
     */
    private static void workWithDefaultLocale() {
        System.out.println("   Current default locale: " + Locale.getDefault());
        System.out.println("   Default language: " + Locale.getDefault().getDisplayLanguage());
        System.out.println("   Default country: " + Locale.getDefault().getCountry());
        
        // Default locale'ni o'zgartirish
        Locale originalLocale = Locale.getDefault();
        System.out.println("\n   Changing default locale to Japanese...");
        Locale.setDefault(Locale.JAPAN);
        
        System.out.println("   New default locale: " + Locale.getDefault());
        
        // Asl holatga qaytarish
        Locale.setDefault(originalLocale);
        System.out.println("   Restored to original locale: " + Locale.getDefault());
    }
    
    /**
     * Amaliy misol - ko'p tilli ilova
     */
    private static void practicalExample() {
        System.out.println("   Multi-language e-commerce application:");
        
        // Mahsulot narxi
        double productPrice = 299.99;
        Date orderDate = new Date();
        
        // Turli mijozlar uchun formatlash
        Customer[] customers = {
            new Customer("John Doe", Locale.US, "USD"),
            new Customer("Pierre Dupont", Locale.FRENCH, "EUR"),
            new Customer("山田太郎", Locale.JAPAN, "JPY"),
            new Customer("Ali Valiyev", Locale.forLanguageTag("uz"), "UZS"),
            new Customer("Иван Иванов", new Locale("ru", "RU"), "RUB")
        };
        
        for (Customer customer : customers) {
            displayOrderSummary(customer, productPrice, orderDate);
        }
    }
    
    /**
     * Buyurtma xulosasini ko'rsatish
     */
    private static void displayOrderSummary(Customer customer, double price, Date date) {
        Locale locale = customer.getLocale();
        
        // Valyuta formatlash
        NumberFormat currencyFormat = NumberFormat.getCurrencyInstance(locale);
        String formattedPrice = currencyFormat.format(price);
        
        // Sana formatlash
        DateFormat dateFormat = DateFormat.getDateInstance(DateFormat.MEDIUM, locale);
        String formattedDate = dateFormat.format(date);
        
        // Raqam formatlash (miqdor uchun)
        NumberFormat numberFormat = NumberFormat.getNumberInstance(locale);
        String formattedQuantity = numberFormat.format(2);
        
        System.out.println("\n   --- Order for " + customer.getName() + " ---");
        System.out.println("   Product: Laptop");
        System.out.println("   Quantity: " + formattedQuantity);
        System.out.println("   Unit Price: " + formattedPrice);
        System.out.println("   Total: " + currencyFormat.format(price * 2));
        System.out.println("   Order Date: " + formattedDate);
        System.out.println("   Shipping to: " + locale.getDisplayCountry(Locale.ENGLISH));
    }
}

/**
 * Customer class - mijoz ma'lumotlari
 */
class Customer {
    private String name;
    private Locale locale;
    private String preferredCurrency;
    
    public Customer(String name, Locale locale, String preferredCurrency) {
        this.name = name;
        this.locale = locale;
        this.preferredCurrency = preferredCurrency;
    }
    
    public String getName() {
        return name;
    }
    
    public Locale getLocale() {
        return locale;
    }
    
    public String getPreferredCurrency() {
        return preferredCurrency;
    }
}
```

### ResourceBundle bilan ishlash

#### Resource Bundle Fayllari

**messages_en.properties** (Ingliz tili)

```properties
# Navigation
menu.home=Home
menu.products=Products
menu.about=About Us
menu.contact=Contact

# Buttons
button.login=Login
button.signup=Sign Up
button.submit=Submit
button.cancel=Cancel
button.save=Save
button.delete=Delete

# Messages
welcome=Welcome, {0}!
login.success=Login successful
login.failed=Invalid username or password
registration.success=Registration successful
error.general=An error occurred. Please try again.
error.required=This field is required.

# Labels
label.username=Username
label.password=Password
label.email=Email
label.fullname=Full Name
label.phone=Phone Number
label.address=Address

# Validation messages
validation.email.invalid=Please enter a valid email address
validation.password.weak=Password must be at least 8 characters
validation.phone.invalid=Please enter a valid phone number

# Product related
product.name=Product Name
product.price=Price
product.quantity=Quantity
product.total=Total
product.add_to_cart=Add to Cart
product.remove_from_cart=Remove from Cart
```

**messages_uz.properties** (O'zbek tili)

```properties
# Navigation
menu.home=Bosh sahifa
menu.products=Mahsulotlar
menu.about=Biz haqimizda
menu.contact=Bog'lanish

# Buttons
button.login=Kirish
button.signup=Ro'yxatdan o'tish
button.submit=Yuborish
button.cancel=Bekor qilish
button.save=Saqlash
button.delete=O'chirish

# Messages
welcome=Xush kelibsiz, {0}!
login.success=Muvaffaqiyatli kirdingiz
login.failed=Noto'g'ri foydalanuvchi nomi yoki parol
registration.success=Ro'yxatdan muvaffaqiyatli o'tdingiz
error.general=Xatolik yuz berdi. Iltimos, qayta urinib ko'ring.
error.required=Bu maydon majburiy

# Labels
label.username=Foydalanuvchi nomi
label.password=Parol
label.email=Elektron pochta
label.fullname=To'liq ism
label.phone=Telefon raqami
label.address=Manzil

# Validation messages
validation.email.invalid=Iltimos, to'g'ri elektron pochta manzilini kiriting
validation.password.weak=Parol kamida 8 ta belgidan iborat bo'lishi kerak
validation.phone.invalid=Iltimos, to'g'ri telefon raqamini kiriting

# Product related
product.name=Mahsulot nomi
product.price=Narx
product.quantity=Soni
product.total=Jami
product.add_to_cart=Savatga qo'shish
product.remove_from_cart=Savatdan o'chirish
```

**messages_fr.properties** (Fransuz tili)

```properties
# Navigation
menu.home=Accueil
menu.products=Produits
menu.about=À propos
menu.contact=Contact

# Buttons
button.login=Connexion
button.signup=S'inscrire
button.submit=Soumettre
button.cancel=Annuler
button.save=Enregistrer
button.delete=Supprimer

# Messages
welcome=Bienvenue, {0} !
login.success=Connexion réussie
login.failed=Nom d'utilisateur ou mot de passe invalide
registration.success=Inscription réussie
error.general=Une erreur s'est produite. Veuillez réessayer.
error.required=Ce champ est obligatoire

# Labels
label.username=Nom d'utilisateur
label.password=Mot de passe
label.email=E-mail
label.fullname=Nom complet
label.phone=Numéro de téléphone
label.address=Adresse

# Validation messages
validation.email.invalid=Veuillez saisir une adresse e-mail valide
validation.password.weak=Le mot de passe doit comporter au moins 8 caractères
validation.phone.invalid=Veuillez saisir un numéro de téléphone valide

# Product related
product.name=Nom du produit
product.price=Prix
product.quantity=Quantité
product.total=Total
product.add_to_cart=Ajouter au panier
product.remove_from_cart=Retirer du panier
```

#### User Record'i

```java
package i18n;

import java.util.List;
import java.util.Locale;

/**
 * User record - foydalanuvchi ma'lumotlari
 * @param username foydalanuvchi nomi
 * @param locale foydalanuvchi locale'i
 */
public record User(String username, Locale locale) {
    
    /**
     * Namuna foydalanuvchilar
     */
    public static List<User> users = List.of(
        new User("user1", Locale.forLanguageTag("uz")),
        new User("user2", Locale.ENGLISH),
        new User("user3", Locale.FRANCE),
        new User("user4", Locale.JAPAN),
        new User("user5", new Locale("ru", "RU")),
        new User("user6", Locale.GERMAN),
        new User("user7", Locale.ITALIAN)
    );
    
    /**
     * Username bo'yicha foydalanuvchi qidirish
     */
    public static User findByUsername(String username) {
        return users.stream()
            .filter(user -> user.username().equals(username))
            .findFirst()
            .orElse(null);
    }
}
```

#### UI - ResourceBundle bilan ishlash

```java
package i18n;

import java.util.Locale;
import java.util.ResourceBundle;
import java.util.Scanner;

/**
 * UI - ResourceBundle yordamida ko'p tilli interfeys
 */
public class UI {
    
    public static void main(String[] args) {
        System.out.println("========== MULTI-LANGUAGE APPLICATION ==========");
        
        // 1. ResourceBundle bilan ishlash
        System.out.println("1. Working with ResourceBundle:");
        testResourceBundleBasics();
        
        // 2. Interaktiv login tizimi
        System.out.println("\n2. Interactive login system:");
        runInteractiveLogin();
        
        // 3. Mahsulotlar katalogi
        System.out.println("\n3. Product catalog:");
        displayProductCatalog();
        
        // 4. Localization service
        System.out.println("\n4. Localization service:");
        testLocalizationService();
    }
    
    /**
     * ResourceBundle asoslari
     */
    private static void testResourceBundleBasics() {
        // Turli tillar uchun ResourceBundle yaratish
        ResourceBundle enBundle = ResourceBundle.getBundle("messages", Locale.ENGLISH);
        ResourceBundle uzBundle = ResourceBundle.getBundle("messages", Locale.forLanguageTag("uz"));
        ResourceBundle frBundle = ResourceBundle.getBundle("messages", Locale.FRENCH);
        ResourceBundle jaBundle = ResourceBundle.getBundle("messages", Locale.JAPAN);
        
        System.out.println("   English:");
        System.out.println("     Welcome: " + enBundle.getString("welcome"));
        System.out.println("     Login: " + enBundle.getString("button.login"));
        
        System.out.println("\n   Uzbek:");
        System.out.println("     Welcome: " + uzBundle.getString("welcome"));
        System.out.println("     Login: " + uzBundle.getString("button.login"));
        
        System.out.println("\n   French:");
        System.out.println("     Welcome: " + frBundle.getString("welcome"));
        System.out.println("     Login: " + frBundle.getString("button.login"));
        
        System.out.println("\n   Japanese (fallback to English):");
        System.out.println("     Welcome: " + jaBundle.getString("welcome"));
        System.out.println("     Login: " + jaBundle.getString("button.login"));
        
        // Parametrli xabarlar
        System.out.println("\n   Parameterized messages:");
        String welcomeMessage = enBundle.getString("welcome");
        System.out.println("     English: " + java.text.MessageFormat.format(welcomeMessage, "John"));
        
        welcomeMessage = uzBundle.getString("welcome");
        System.out.println("     Uzbek: " + java.text.MessageFormat.format(welcomeMessage, "Ali"));
        
        welcomeMessage = frBundle.getString("welcome");
        System.out.println("     French: " + java.text.MessageFormat.format(welcomeMessage, "Pierre"));
    }
    
    /**
     * Interaktiv login tizimi
     */
    private static void runInteractiveLogin() {
        Scanner scanner = new Scanner(System.in);
        
        while (true) {
            System.out.println("\n   --- Login System ---");
            System.out.print("   Enter username (or 'exit' to quit): ");
            String username = scanner.nextLine();
            
            if (username.equalsIgnoreCase("exit")) {
                break;
            }
            
            // Foydalanuvchini topish
            User user = User.findByUsername(username);
            
            if (user != null) {
                // Foydalanuvchi locale'ini o'rnatish
                Locale.setDefault(user.locale());
                
                // ResourceBundle yaratish
                ResourceBundle bundle = ResourceBundle.getBundle("messages");
                
                // Xush kelibsiz xabarini ko'rsatish
                String welcomeMessage = bundle.getString("welcome");
                String formattedWelcome = java.text.MessageFormat.format(welcomeMessage, username);
                System.out.println("\n   " + formattedWelcome);
                
                // Login formani ko'rsatish
                displayLoginForm(bundle, scanner);
            } else {
                System.out.println("   User not found. Available users: user1, user2, user3, user4, user5, user6, user7");
            }
        }
        
        scanner.close();
        System.out.println("   Goodbye!");
    }
    
    /**
     * Login formani ko'rsatish
     */
    private static void displayLoginForm(ResourceBundle bundle, Scanner scanner) {
        System.out.println("\n   --- " + bundle.getString("button.login") + " ---");
        
        System.out.print("   " + bundle.getString("label.username") + ": ");
        String inputUsername = scanner.nextLine();
        
        System.out.print("   " + bundle.getString("label.password") + ": ");
        String inputPassword = scanner.nextLine();
        
        // Oddiy autentifikatsiya (haqiqiy emas)
        if (!inputUsername.isEmpty() && !inputPassword.isEmpty()) {
            System.out.println("   ✅ " + bundle.getString("login.success"));
            
            // Asosiy menyuni ko'rsatish
            displayMainMenu(bundle, scanner);
        } else {
            System.out.println("   ❌ " + bundle.getString("login.failed"));
        }
    }
    
    /**
     * Asosiy menyuni ko'rsatish
     */
    private static void displayMainMenu(ResourceBundle bundle, Scanner scanner) {
        while (true) {
            System.out.println("\n   --- " + bundle.getString("menu.home") + " ---");
            System.out.println("   1. " + bundle.getString("menu.products"));
            System.out.println("   2. " + bundle.getString("menu.about"));
            System.out.println("   3. " + bundle.getString("menu.contact"));
            System.out.println("   4. " + bundle.getString("button.logout"));
            
            System.out.print("   " + bundle.getString("label.select") + " (1-4): ");
            String choice = scanner.nextLine();
            
            switch (choice) {
                case "1":
                    displayProducts(bundle, scanner);
                    break;
                case "2":
                    System.out.println("\n   " + bundle.getString("about.content"));
                    break;
                case "3":
                    System.out.println("\n   " + bundle.getString("contact.info"));
                    break;
                case "4":
                    System.out.println("   " + bundle.getString("logout.message"));
                    return;
                default:
                    System.out.println("   " + bundle.getString("error.invalid.choice"));
            }
        }
    }
    
    /**
     * Mahsulotlarni ko'rsatish
     */
    private static void displayProducts(ResourceBundle bundle, Scanner scanner) {
        System.out.println("\n   --- " + bundle.getString("menu.products") + " ---");
        
        // Mahsulotlar ro'yxati
        Product[] products = {
            new Product("Laptop", 999.99, "High-performance laptop"),
            new Product("Smartphone", 699.99, "Latest smartphone model"),
            new Product("Tablet", 399.99, "Portable tablet device"),
            new Product("Headphones", 199.99, "Noise-cancelling headphones")
        };
        
        for (int i = 0; i < products.length; i++) {
            Product product = products[i];
            System.out.println("   " + (i + 1) + ". " + product.getName() + 
                             " - " + formatCurrency(product.getPrice(), Locale.getDefault()) +
                             "\n      " + product.getDescription());
        }
        
        System.out.print("\n   " + bundle.getString("product.select") + " (1-" + products.length + "): ");
        String choice = scanner.nextLine();
        
        try {
            int productIndex = Integer.parseInt(choice) - 1;
            if (productIndex >= 0 && productIndex < products.length) {
                Product selected = products[productIndex];
                System.out.println("\n   " + bundle.getString("product.added") + ": " + 
                                 selected.getName() + " - " + 
                                 formatCurrency(selected.getPrice(), Locale.getDefault()));
            }
        } catch (NumberFormatException e) {
            System.out.println("   " + bundle.getString("error.invalid.choice"));
        }
    }
    
    /**
     * Valyutani formatlash
     */
    private static String formatCurrency(double amount, Locale locale) {
        return java.text.NumberFormat.getCurrencyInstance(locale).format(amount);
    }
    
    /**
     * Mahsulotlar katalogini ko'rsatish
     */
    private static void displayProductCatalog() {
        System.out.println("   Product catalog in different languages:");
        
        Product laptop = new Product("Laptop", 999.99, "High-performance laptop");
        
        for (User user : User.users) {
            Locale.setDefault(user.locale());
            ResourceBundle bundle = ResourceBundle.getBundle("messages");
            
            System.out.println("\n   Language: " + user.locale().getDisplayLanguage(Locale.ENGLISH));
            System.out.println("     " + bundle.getString("product.name") + ": " + laptop.getName());
            System.out.println("     " + bundle.getString("product.price") + ": " + 
                             formatCurrency(laptop.getPrice(), user.locale()));
            System.out.println("     " + bundle.getString("product.add_to_cart"));
        }
    }
    
    /**
     * Localization service test
     */
    private static void testLocalizationService() {
        LocalizationService service = new LocalizationService();
        
        System.out.println("   Testing localization service:");
        
        // Turli locale'lar uchun xabarlar
        String[] messageKeys = {"welcome", "button.login", "login.success", "error.general"};
        
        for (String key : messageKeys) {
            System.out.println("\n   Key: " + key);
            System.out.println("     English: " + service.getMessage(key, Locale.ENGLISH, "John"));
            System.out.println("     Uzbek: " + service.getMessage(key, Locale.forLanguageTag("uz"), "Ali"));
            System.out.println("     French: " + service.getMessage(key, Locale.FRENCH, "Pierre"));
        }
        
        // Formatlangan xabarlar
        System.out.println("\n   Formatted order summary:");
        
        Order order = new Order("ORD-12345", 1299.97, new Date());
        System.out.println("     English: " + service.formatOrderSummary(order, Locale.US));
        System.out.println("     French: " + service.formatOrderSummary(order, Locale.FRANCE));
        System.out.println("     Japanese: " + service.formatOrderSummary(order, Locale.JAPAN));
    }
}

/**
 * Product class - mahsulot ma'lumotlari
 */
class Product {
    private String name;
    private double price;
    private String description;
    
    public Product(String name, double price, String description) {
        this.name = name;
        this.price = price;
        this.description = description;
    }
    
    public String getName() {
        return name;
    }
    
    public double getPrice() {
        return price;
    }
    
    public String getDescription() {
        return description;
    }
}

/**
 * Order class - buyurtma ma'lumotlari
 */
class Order {
    private String orderId;
    private double totalAmount;
    private Date orderDate;
    
    public Order(String orderId, double totalAmount, Date orderDate) {
        this.orderId = orderId;
        this.totalAmount = totalAmount;
        this.orderDate = orderDate;
    }
    
    public String getOrderId() {
        return orderId;
    }
    
    public double getTotalAmount() {
        return totalAmount;
    }
    
    public Date getOrderDate() {
        return orderDate;
    }
}

/**
 * Localization service - localization logikasi
 */
class LocalizationService {
    
    /**
     * Xabar olish
     */
    public String getMessage(String key, Locale locale, Object... params) {
        try {
            ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);
            String message = bundle.getString(key);
            
            if (params.length > 0) {
                return java.text.MessageFormat.format(message, params);
            }
            return message;
        } catch (java.util.MissingResourceException e) {
            // Fallback to English
            ResourceBundle defaultBundle = ResourceBundle.getBundle("messages", Locale.ENGLISH);
            String message = defaultBundle.getString(key);
            
            if (params.length > 0) {
                return java.text.MessageFormat.format(message, params);
            }
            return message;
        }
    }
    
    /**
     * Buyurtma xulosasini formatlash
     */
    public String formatOrderSummary(Order order, Locale locale) {
        ResourceBundle bundle = ResourceBundle.getBundle("messages", locale);
        
        // Sana formatlash
        java.text.DateFormat dateFormat = java.text.DateFormat.getDateInstance(
            java.text.DateFormat.MEDIUM, locale);
        String formattedDate = dateFormat.format(order.getOrderDate());
        
        // Valyuta formatlash
        java.text.NumberFormat currencyFormat = java.text.NumberFormat.getCurrencyInstance(locale);
        String formattedAmount = currencyFormat.format(order.getTotalAmount());
        
        // Xabar formatlash
        String template = bundle.getString("order.summary");
        return java.text.MessageFormat.format(template, 
            order.getOrderId(), formattedAmount, formattedDate);
    }
    
    /**
     * Formatlangan sana olish
     */
    public String getFormattedDate(Date date, Locale locale) {
        java.text.DateFormat dateFormat = java.text.DateFormat.getDateInstance(
            java.text.DateFormat.FULL, locale);
        return dateFormat.format(date);
    }
    
    /**
     * Formatlangan raqam olish
     */
    public String getFormattedNumber(double number, Locale locale) {
        java.text.NumberFormat numberFormat = java.text.NumberFormat.getNumberInstance(locale);
        return numberFormat.format(number);
    }
    
    /**
     * Formatlangan valyuta olish
     */
    public String getFormattedCurrency(double amount, Locale locale) {
        java.text.NumberFormat currencyFormat = java.text.NumberFormat.getCurrencyInstance(locale);
        return currencyFormat.format(amount);
    }
}
```

## Amaliy Maslahatlar

### Legacy Collections:

1. **Properties fayllarini ishlatish:**
    - `.properties` fayllar - oddiy format, ko'p qatorli xabarlar uchun backslash
    - XML fayllar - strukturali ma'lumotlar uchun yaxshi
    - System properties - tizim sozlamalarini o'qish

2. **Stack ishlatish:**
    - Java Stack - Vector ni kengaytiradi (dizayn nuqsoni)
    - Zamonaviy alternativ - Deque interfeysi: `Deque<String> stack = new ArrayDeque<>()`
    - Real-world use cases: undo/redo, expression evaluation, backtracking

3. **Hashtable vs HashMap:**
    - Hashtable - synchronized, null qiymatlarni qo'llamaydi, legacy
    - HashMap - not synchronized, null qiymatlarni qo'llaydi, tezroq
    - ConcurrentHashMap - thread-safe va samarali

### Internationalization:

1. **Locale bilan ishlash:**
    - Har bir foydalanuvchi uchun Locale saqlang
    - Locale.getDefault() - tizim default locale'ini olish
    - Locale.setDefault() - default locale'ni o'zgartirish

2. **ResourceBundle bilan ishlash:**
    - Xabarlarni alohida fayllarda saqlang
    - Fallback mexanizmi - agar locale fayli topilmasa, default fayl ishlatiladi
    - Parametrli xabarlar uchun MessageFormat ishlating

3. **Formatlash:**
    - Sana/vaqt - DateFormat
    - Raqamlar - NumberFormat
    - Valyuta - NumberFormat.getCurrencyInstance()
    - Foizlar - NumberFormat.getPercentInstance()

4. **Best practices:**
    - Barcha UI matnlarini resource bundle'larda saqlang
    - Formatlangan xabarlar uchun pattern'lar ishlating
    - Right-to-left tillar (Arabic, Hebrew) uchun alohida e'tibor
    - Plurals (birlik/ko'plik) uchun maxsus yondashuv kerak

---

**Intervyu Savollari:** [Interviews/03_Collections_and_DSA.md](./Interviews/03_Collections_and_DSA.md)

**Loyiha Topshiriqlari:** [assignments/03_Collections_and_DSA.md](./assignments/03_Collections_and_DSA.md)

**Mundarijaga Qaytish:** [README.md](../README.md)

---

**Muhim Atamalar:**
- **Legacy Collections** - Eski kolleksiyalar (Properties, Hashtable, Stack)
- **Properties** - Konfiguratsiya ma'lumotlarini saqlash
- **Stack** - LIFO ma'lumotlar tuzilmasi
- **Hashtable** - Synchronized Map implementatsiyasi
- **Internationalization (i18n)** - Ko'p tilli ilovalar yaratish
- **Localization (l10n)** - Muayyan til/mintaqaga moslashtirish
- **Locale** - Til va mintaqa ma'lumotlari
- **ResourceBundle** - Tilga bog'liq resurslar
- **MessageFormat** - Parametrli xabarlar formatlash

> **Tebriklar! Siz Collections and DSA bo'limini muvaffaqiyatli yakunladingiz!** 🎉

> **Bolalar, o'rganishda davom etamiz!** 🚀