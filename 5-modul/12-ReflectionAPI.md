# 12 - Reflection API

## Reflection API nima?

**Reflection API** - Java dasturlarida ish vaqti (runtime) davomida sinflar (classes), metodlar, konstruktorlar va field'larni tekshirish va ular bilan ishlash imkonini beruvchi vosita.

```java
// Oddiy usulda obyekt yaratish
Person person = new Person("Ali", 25);

// Reflection orqali - ish vaqtida sinf haqida ma'lumot olish
Class<?> personClass = Class.forName("Person");
Object person = personClass.getDeclaredConstructor().newInstance();
```

Tasavvur qiling, sizda qora quti bor. Oddiy usulda qutining ichida nima borligini bilmaysiz. Reflection esa sizga qutini ochib, ichidagi narsalarni ko'rish va ular bilan ishlash imkonini beradi.

---

## Nima uchun Reflection kerak?

1. **Framework'lar** - Spring, Hibernate, JUnit kabi framework'lar Reflection dan foydalanadi
2. **IDE'lar** - IntelliJ IDEA, Eclipse kodni tahlil qilish uchun Reflection ishlatadi
3. **Debugging tools** - Xatoliklarni aniqlash vositalari
4. **Testing** - Private metodlarni test qilish
5. **Serialization** - Ob'ektlarni saqlash va tiklash
6. **Dependency injection** - Spring kabi container'lar

```java
// ❌ Oddiy usulda - sinf haqida ma'lumotni kompilyatsiya vaqtida bilish kerak
String className = person.getClass().getName(); // "Person"

// ✅ Reflection bilan - ish vaqtida sinf haqida to'liq ma'lumot olish
Class<?> clazz = person.getClass();
Method[] methods = clazz.getDeclaredMethods(); // Barcha metodlar
Field[] fields = clazz.getDeclaredFields();     // Barcha field'lar
Constructor<?>[] constructors = clazz.getConstructors(); // Konstruktorlar
```

---

## 15.1 - java.lang.reflect package asosiy sinflari

| Sinf | Vazifasi |
|------|----------|
| **Class** | Sinf haqida ma'lumot olish (nomi, modifierlari, parent sinfi, interfeyslari) |
| **Field** | Field'lar (o'zgaruvchilar) haqida ma'lumot va ularni o'zgartirish |
| **Method** | Metodlar haqida ma'lumot va ularni chaqirish |
| **Constructor** | Konstruktorlar haqida ma'lumot va yangi ob'ekt yaratish |
| **Modifier** | Access modifier'lar haqida ma'lumot (public, private, static, final) |
| **Array** | Massivlar bilan ishlash |
| **Proxy** | Dinamik proxy yaratish |

---

## 15.2 - Class sinfi bilan ishlash

### Class ob'ektini olish usullari

```java
public class GetClassExample {
    public static void main(String[] args) throws Exception {
        
        // 1-usul: .class dan
        Class<String> stringClass = String.class;
        Class<Integer> intClass = int.class;
        Class<int[]> arrayClass = int[].class;
        
        // 2-usul: getClass() metodi orqali
        Person person = new Person("Ali", 25);
        Class<? extends Person> personClass = person.getClass();
        
        // 3-usul: Class.forName() orqali (to'liq paket nomi bilan)
        Class<?> forNameClass = Class.forName("java.lang.String");
        Class<?> personForName = Class.forName("com.example.Person");
        
        System.out.println("Class name: " + personClass.getName());
        System.out.println("Simple name: " + personClass.getSimpleName());
        System.out.println("Package: " + personClass.getPackageName());
        System.out.println("Modifiers: " + Modifier.toString(personClass.getModifiers()));
    }
}
```

### Class ma'lumotlarini olish

```java
import java.lang.annotation.Annotation;
import java.lang.reflect.*;

public class ClassInfoExample {
    public static void main(String[] args) {
        Class<?> clazz = Person.class;
        
        System.out.println("=== Class Information ===");
        System.out.println("Name: " + clazz.getName());
        System.out.println("Simple Name: " + clazz.getSimpleName());
        System.out.println("Package: " + clazz.getPackage());
        System.out.println("Modifiers: " + Modifier.toString(clazz.getModifiers()));
        
        // Superclass
        Class<?> superclass = clazz.getSuperclass();
        System.out.println("Superclass: " + superclass.getName());
        
        // Interfaces
        Class<?>[] interfaces = clazz.getInterfaces();
        System.out.println("Interfaces:");
        for (Class<?> iface : interfaces) {
            System.out.println("  - " + iface.getName());
        }
        
        // Annotations
        Annotation[] annotations = clazz.getAnnotations();
        System.out.println("Annotations:");
        for (Annotation ann : annotations) {
            System.out.println("  - " + ann.annotationType().getSimpleName());
        }
    }
}
```

---

## 15.3 - Field'lar bilan ishlash

### Field ma'lumotlarini olish

```java
import java.lang.reflect.Field;

public class FieldInfoExample {
    public static void main(String[] args) {
        Class<?> clazz = Person.class;
        
        // Barcha public field'lar (shu jumladan voris olinganlar)
        Field[] publicFields = clazz.getFields();
        
        // Barcha field'lar (private, protected, package)
        Field[] allFields = clazz.getDeclaredFields();
        
        System.out.println("=== Field Information ===");
        for (Field field : allFields) {
            System.out.println("Field name: " + field.getName());
            System.out.println("  Type: " + field.getType().getSimpleName());
            System.out.println("  Modifiers: " + Modifier.toString(field.getModifiers()));
            
            // Annotations
            Annotation[] annotations = field.getAnnotations();
            if (annotations.length > 0) {
                System.out.println("  Annotations:");
                for (Annotation ann : annotations) {
                    System.out.println("    - " + ann.annotationType().getSimpleName());
                }
            }
            System.out.println();
        }
    }
}
```

### Field qiymatlarini olish va o'zgartirish

```java
import java.lang.reflect.Field;

public class FieldAccessExample {
    public static void main(String[] args) throws Exception {
        Person person = new Person("Ali", 25);
        
        System.out.println("Before: " + person);
        
        // 1. Field nomi orqali olish
        Field nameField = Person.class.getDeclaredField("name");
        
        // Private field'ga kirish uchun
        nameField.setAccessible(true);
        
        // Qiymatni olish
        String name = (String) nameField.get(person);
        System.out.println("Name from reflection: " + name);
        
        // Qiymatni o'zgartirish
        nameField.set(person, "Vali");
        
        // 2. Age field
        Field ageField = Person.class.getDeclaredField("age");
        ageField.setAccessible(true);
        
        int age = ageField.getInt(person);
        System.out.println("Age from reflection: " + age);
        
        ageField.setInt(person, 30);
        
        System.out.println("After: " + person);
        
        // 3. Static field
        Field counterField = Person.class.getDeclaredField("counter");
        counterField.setAccessible(true);
        
        int counter = counterField.getInt(null); // static field uchun null
        System.out.println("Static counter: " + counter);
        
        counterField.setInt(null, 100);
        System.out.println("New counter: " + Person.counter);
    }
}
```

---

## 15.4 - Metodlar bilan ishlash

### Metod ma'lumotlarini olish

```java
import java.lang.reflect.Method;
import java.lang.reflect.Parameter;

public class MethodInfoExample {
    public static void main(String[] args) {
        Class<?> clazz = Person.class;
        
        // Public metodlar (voris olinganlar bilan)
        Method[] publicMethods = clazz.getMethods();
        
        // Barcha metodlar (faqat shu sinfga tegishli)
        Method[] declaredMethods = clazz.getDeclaredMethods();
        
        System.out.println("=== Method Information ===");
        for (Method method : declaredMethods) {
            System.out.println("Method: " + method.getName());
            System.out.println("  Return type: " + method.getReturnType().getSimpleName());
            System.out.println("  Modifiers: " + Modifier.toString(method.getModifiers()));
            
            // Parametrlar
            Parameter[] parameters = method.getParameters();
            if (parameters.length > 0) {
                System.out.println("  Parameters:");
                for (Parameter param : parameters) {
                    System.out.println("    - " + param.getType().getSimpleName() + " " + param.getName());
                }
            }
            
            // Exception'lar
            Class<?>[] exceptionTypes = method.getExceptionTypes();
            if (exceptionTypes.length > 0) {
                System.out.println("  Exceptions:");
                for (Class<?> ex : exceptionTypes) {
                    System.out.println("    - " + ex.getSimpleName());
                }
            }
            System.out.println();
        }
    }
}
```

### Metodlarni chaqirish

```java
import java.lang.reflect.Method;

public class MethodInvokeExample {
    public static void main(String[] args) throws Exception {
        Person person = new Person("Ali", 25);
        
        // 1. Parametrsiz metod
        Method sayHelloMethod = Person.class.getDeclaredMethod("sayHello");
        sayHelloMethod.setAccessible(true);
        
        String result = (String) sayHelloMethod.invoke(person);
        System.out.println("sayHello result: " + result);
        
        // 2. Parametrli metod
        Method greetMethod = Person.class.getDeclaredMethod("greet", String.class);
        greetMethod.setAccessible(true);
        
        String greetResult = (String) greetMethod.invoke(person, "Java");
        System.out.println("greet result: " + greetResult);
        
        // 3. Private metod
        Method privateMethod = Person.class.getDeclaredMethod("privateMethod");
        privateMethod.setAccessible(true);
        
        privateMethod.invoke(person);
        
        // 4. Static metod
        Method staticMethod = Person.class.getDeclaredMethod("staticMethod");
        staticMethod.setAccessible(true);
        
        staticMethod.invoke(null); // static metod uchun null
        
        // 5. Return type void
        Method voidMethod = Person.class.getDeclaredMethod("voidMethod");
        voidMethod.setAccessible(true);
        
        Object voidResult = voidMethod.invoke(person);
        System.out.println("Void method result: " + voidResult); // null
    }
}
```

---

## 15.5 - Konstruktorlar bilan ishlash

### Konstruktor ma'lumotlarini olish

```java
import java.lang.reflect.Constructor;

public class ConstructorInfoExample {
    public static void main(String[] args) {
        Class<?> clazz = Person.class;
        
        // Public konstruktorlar
        Constructor<?>[] constructors = clazz.getConstructors();
        
        // Barcha konstruktorlar (private, protected)
        Constructor<?>[] declaredConstructors = clazz.getDeclaredConstructors();
        
        System.out.println("=== Constructor Information ===");
        for (Constructor<?> constructor : declaredConstructors) {
            System.out.println("Constructor: " + constructor.getName());
            System.out.println("  Modifiers: " + Modifier.toString(constructor.getModifiers()));
            
            // Parametrlar
            Class<?>[] paramTypes = constructor.getParameterTypes();
            if (paramTypes.length > 0) {
                System.out.println("  Parameters:");
                for (Class<?> paramType : paramTypes) {
                    System.out.println("    - " + paramType.getSimpleName());
                }
            }
            System.out.println();
        }
    }
}
```

### Konstruktor orqali ob'ekt yaratish

```java
import java.lang.reflect.Constructor;

public class ConstructorCreateExample {
    public static void main(String[] args) throws Exception {
        
        // 1. Default konstruktor
        Constructor<Person> defaultConstructor = Person.class.getDeclaredConstructor();
        defaultConstructor.setAccessible(true);
        
        Person person1 = defaultConstructor.newInstance();
        System.out.println("Default constructor: " + person1);
        
        // 2. Parametrli konstruktor
        Constructor<Person> paramConstructor = Person.class.getDeclaredConstructor(
            String.class, int.class
        );
        paramConstructor.setAccessible(true);
        
        Person person2 = paramConstructor.newInstance("Ali", 25);
        System.out.println("Parameter constructor: " + person2);
        
        // 3. Private konstruktor
        Constructor<Person> privateConstructor = Person.class.getDeclaredConstructor(String.class);
        privateConstructor.setAccessible(true);
        
        Person person3 = privateConstructor.newInstance("Secret");
        System.out.println("Private constructor: " + person3);
        
        // 4. Class.forName orqali
        Class<?> clazz = Class.forName("Person");
        Constructor<?> constructor = clazz.getDeclaredConstructor(String.class, int.class);
        constructor.setAccessible(true);
        
        Object person4 = constructor.newInstance("Vali", 30);
        System.out.println("Via Class.forName: " + person4);
    }
}
```

---

## 15.6 - Modifier'lar bilan ishlash

```java
import java.lang.reflect.Modifier;

public class ModifierExample {
    public static void main(String[] args) {
        Class<?> clazz = Person.class;
        
        // Class modifierlari
        int classModifiers = clazz.getModifiers();
        System.out.println("Class modifiers: " + Modifier.toString(classModifiers));
        System.out.println("  isPublic: " + Modifier.isPublic(classModifiers));
        System.out.println("  isAbstract: " + Modifier.isAbstract(classModifiers));
        System.out.println("  isFinal: " + Modifier.isFinal(classModifiers));
        System.out.println("  isInterface: " + Modifier.isInterface(classModifiers));
        
        // Field modifierlari
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            int fieldModifiers = field.getModifiers();
            System.out.println(field.getName() + ": " + Modifier.toString(fieldModifiers));
            System.out.println("  isPrivate: " + Modifier.isPrivate(fieldModifiers));
            System.out.println("  isStatic: " + Modifier.isStatic(fieldModifiers));
            System.out.println("  isFinal: " + Modifier.isFinal(fieldModifiers));
            System.out.println("  isVolatile: " + Modifier.isVolatile(fieldModifiers));
            System.out.println("  isTransient: " + Modifier.isTransient(fieldModifiers));
        }
    }
}
```

---

## 15.7 - Array'lar bilan ishlash

```java
import java.lang.reflect.Array;
import java.util.Arrays;

public class ArrayReflectionExample {
    public static void main(String[] args) {
        
        // 1. Massiv yaratish
        int[] intArray = (int[]) Array.newInstance(int.class, 5);
        String[] stringArray = (String[]) Array.newInstance(String.class, 3);
        
        // 2. Qiymat o'rnatish
        Array.set(intArray, 0, 10);
        Array.set(intArray, 1, 20);
        Array.set(intArray, 2, 30);
        
        Array.set(stringArray, 0, "Java");
        Array.set(stringArray, 1, "Reflection");
        Array.set(stringArray, 2, "API");
        
        // 3. Qiymat olish
        for (int i = 0; i < 3; i++) {
            int value = Array.getInt(intArray, i);
            System.out.println("intArray[" + i + "] = " + value);
        }
        
        for (int i = 0; i < 3; i++) {
            String value = (String) Array.get(stringArray, i);
            System.out.println("stringArray[" + i + "] = " + value);
        }
        
        // 4. Massiv uzunligi
        int length = Array.getLength(intArray);
        System.out.println("Array length: " + length);
        
        // 5. Ikki o'lchovli massiv
        int[][] matrix = (int[][]) Array.newInstance(int.class, 3, 3);
        
        for (int i = 0; i < 3; i++) {
            for (int j = 0; j < 3; j++) {
                Array.set(Array.get(matrix, i), j, i + j);
            }
        }
        
        System.out.println("Matrix:");
        for (int i = 0; i < 3; i++) {
            int[] row = (int[]) Array.get(matrix, i);
            System.out.println(Arrays.toString(row));
        }
    }
}
```

---

## 15.8 - Amaliy misollar

### Misol 1: Object to JSON converter

```java
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

public class SimpleJsonConverter {
    
    public static String toJson(Object obj) throws Exception {
        if (obj == null) return "null";
        
        Class<?> clazz = obj.getClass();
        Field[] fields = clazz.getDeclaredFields();
        
        Map<String, Object> valueMap = new HashMap<>();
        
        for (Field field : fields) {
            field.setAccessible(true);
            String fieldName = field.getName();
            Object value = field.get(obj);
            
            if (value != null) {
                valueMap.put(fieldName, value);
            }
        }
        
        return mapToJson(valueMap);
    }
    
    private static String mapToJson(Map<String, Object> map) {
        StringBuilder sb = new StringBuilder("{");
        
        boolean first = true;
        for (Map.Entry<String, Object> entry : map.entrySet()) {
            if (!first) {
                sb.append(",");
            }
            first = false;
            
            sb.append("\"").append(entry.getKey()).append("\":");
            
            Object value = entry.getValue();
            if (value instanceof String) {
                sb.append("\"").append(value).append("\"");
            } else if (value instanceof Number || value instanceof Boolean) {
                sb.append(value);
            } else {
                // Recursive for nested objects
                try {
                    sb.append(toJson(value));
                } catch (Exception e) {
                    sb.append("\"<error>\"");
                }
            }
        }
        
        sb.append("}");
        return sb.toString();
    }
    
    public static void main(String[] args) throws Exception {
        Person person = new Person("Ali", 25);
        String json = toJson(person);
        System.out.println("JSON: " + json);
    }
}
```

### Misol 2: Dependency Injection (oddiy)

```java
import java.lang.annotation.*;
import java.lang.reflect.Field;

// Custom annotation
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface Inject {}

// Service classes
class UserService {
    public void serve() {
        System.out.println("UserService is working");
    }
}

class EmailService {
    public void sendEmail() {
        System.out.println("EmailService is sending email");
    }
}

// Client class
class UserController {
    @Inject
    private UserService userService;
    
    @Inject
    private EmailService emailService;
    
    public void processUser() {
        if (userService != null) {
            userService.serve();
        } else {
            System.out.println("UserService is null");
        }
        
        if (emailService != null) {
            emailService.sendEmail();
        } else {
            System.out.println("EmailService is null");
        }
    }
}

// Simple DI Container
class SimpleContainer {
    private static Map<Class<?>, Object> instances = new HashMap<>();
    
    static {
        instances.put(UserService.class, new UserService());
        instances.put(EmailService.class, new EmailService());
    }
    
    public static void injectDependencies(Object target) throws Exception {
        Class<?> clazz = target.getClass();
        Field[] fields = clazz.getDeclaredFields();
        
        for (Field field : fields) {
            if (field.isAnnotationPresent(Inject.class)) {
                Class<?> fieldType = field.getType();
                Object dependency = instances.get(fieldType);
                
                if (dependency != null) {
                    field.setAccessible(true);
                    field.set(target, dependency);
                    System.out.println("Injected " + fieldType.getSimpleName() + " into " + target.getClass().getSimpleName());
                }
            }
        }
    }
}

// Usage
public class DIExample {
    public static void main(String[] args) throws Exception {
        UserController controller = new UserController();
        
        // Before injection
        System.out.println("Before injection:");
        controller.processUser();
        
        // Inject dependencies
        SimpleContainer.injectDependencies(controller);
        
        // After injection
        System.out.println("\nAfter injection:");
        controller.processUser();
    }
}
```

### Misol 3: Unit Test Framework (oddiy)

```java
import java.lang.annotation.*;
import java.lang.reflect.Method;

// Test annotations
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface Test {}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface Before {}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface After {}

// Test class
class CalculatorTest {
    
    private Calculator calc;
    
    @Before
    public void setUp() {
        calc = new Calculator();
        System.out.println("  Setup completed");
    }
    
    @After
    public void tearDown() {
        calc = null;
        System.out.println("  Cleanup completed");
    }
    
    @Test
    public void testAdd() {
        int result = calc.add(2, 3);
        if (result == 5) {
            System.out.println("  ✅ testAdd passed");
        } else {
            System.out.println("  ❌ testAdd failed: expected 5 but got " + result);
        }
    }
    
    @Test
    public void testSubtract() {
        int result = calc.subtract(5, 3);
        if (result == 2) {
            System.out.println("  ✅ testSubtract passed");
        } else {
            System.out.println("  ❌ testSubtract failed: expected 2 but got " + result);
        }
    }
    
    @Test
    public void testMultiply() {
        int result = calc.multiply(2, 3);
        if (result == 6) {
            System.out.println("  ✅ testMultiply passed");
        } else {
            System.out.println("  ❌ testMultiply failed: expected 6 but got " + result);
        }
    }
}

class Calculator {
    public int add(int a, int b) { return a + b; }
    public int subtract(int a, int b) { return a - b; }
    public int multiply(int a, int b) { return a * b; }
}

// Simple Test Runner
class TestRunner {
    public static void runTests(Class<?> testClass) throws Exception {
        System.out.println("Running tests for " + testClass.getSimpleName());
        System.out.println("================================");
        
        Object testInstance = testClass.getDeclaredConstructor().newInstance();
        Method[] methods = testClass.getDeclaredMethods();
        
        Method beforeMethod = null;
        Method afterMethod = null;
        List<Method> testMethods = new ArrayList<>();
        
        // Find annotated methods
        for (Method method : methods) {
            if (method.isAnnotationPresent(Before.class)) {
                beforeMethod = method;
            }
            if (method.isAnnotationPresent(After.class)) {
                afterMethod = method;
            }
            if (method.isAnnotationPresent(Test.class)) {
                testMethods.add(method);
            }
        }
        
        // Run tests
        int passed = 0;
        for (Method testMethod : testMethods) {
            System.out.println("\nTest: " + testMethod.getName());
            
            try {
                // Before
                if (beforeMethod != null) {
                    beforeMethod.invoke(testInstance);
                }
                
                // Test
                testMethod.invoke(testInstance);
                passed++;
                
                // After
                if (afterMethod != null) {
                    afterMethod.invoke(testInstance);
                }
            } catch (Exception e) {
                System.out.println("  ❌ Exception: " + e.getCause().getMessage());
            }
        }
        
        System.out.println("\n================================");
        System.out.println("Results: " + passed + "/" + testMethods.size() + " passed");
    }
    
    public static void main(String[] args) throws Exception {
        runTests(CalculatorTest.class);
    }
}
```

---

## 15.9 - Reflection cheklovlari va xavflari

### Xavflari

```java
public class ReflectionDangers {
    public static void main(String[] args) throws Exception {
        
        // 1. Performance muammosi
        // Reflection oddiy usuldan sekinroq
        Person person = new Person();
        
        long start = System.nanoTime();
        person.setName("Ali");  // Oddiy usul
        long end = System.nanoTime();
        System.out.println("Normal: " + (end - start) + "ns");
        
        start = System.nanoTime();
        Method method = Person.class.getMethod("setName", String.class);
        method.invoke(person, "Ali");  // Reflection
        end = System.nanoTime();
        System.out.println("Reflection: " + (end - start) + "ns");
        
        // 2. Security muammosi
        // Private field'larga kirish mumkin
        Field field = Person.class.getDeclaredField("password");
        field.setAccessible(true);
        field.set(person, "hacked");  // Private field o'zgartirildi!
        
        // 3. Encapsulation buzilishi
        // OOP prinsiplariga zid
        
        // 4. Compile-time xavfsizlik yo'q
        // Xatolar runtime'da aniqlanadi
    }
}
```

### Cheklovlari

```java
public class ReflectionLimitations {
    public static void main(String[] args) {
        
        // 1. Security Manager cheklovlari
        // Agar Security Manager o'rnatilgan bo'lsa, ba'zi operatsiyalar cheklanishi mumkin
        
        // 2. Final field'lar
        // Java 12+ da final field'larni o'zgartirish qiyin
        
        // 3. Inner class'lar
        // Inner class'lar bilan ishlash murakkab
        
        // 4. Generic type'lar
        // Type erasure sababli generic ma'lumotlarni olish qiyin
    }
}
```

---

## Reflection API Cheat Sheet

```java
// 1. Class olish
Class<?> clazz = Class.forName("com.example.Person");
Class<?> clazz = Person.class;
Class<?> clazz = obj.getClass();

// 2. Field'lar
Field[] fields = clazz.getDeclaredFields();
Field field = clazz.getDeclaredField("name");
field.setAccessible(true);
Object value = field.get(obj);
field.set(obj, newValue);

// 3. Metodlar
Method[] methods = clazz.getDeclaredMethods();
Method method = clazz.getDeclaredMethod("methodName", paramTypes);
method.setAccessible(true);
Object result = method.invoke(obj, args);

// 4. Konstruktorlar
Constructor<?>[] constructors = clazz.getDeclaredConstructors();
Constructor<?> constructor = clazz.getDeclaredConstructor(paramTypes);
constructor.setAccessible(true);
Object obj = constructor.newInstance(args);

// 5. Modifier tekshirish
int mod = field.getModifiers();
boolean isPrivate = Modifier.isPrivate(mod);
boolean isStatic = Modifier.isStatic(mod);

// 6. Array
Object array = Array.newInstance(componentType, length);
Array.set(array, index, value);
Object value = Array.get(array, index);
```

---

## Tekshiruv Savollari

1. **Reflection API nima va nima uchun kerak?**
2. **Class sinfining vazifasi nima?**
3. **Field, Method, Constructor sinflari qanday ishlatiladi?**
4. **setAccessible(true) nima uchun kerak?**
5. **Private field va metodlarga qanday kirish mumkin?**
6. **Reflection orqali ob'ekt yaratishning qanday usullari bor?**
7. **Modifier sinfi nima uchun kerak?**
8. **Array sinfi bilan qanday ishlash mumkin?**
9. **Reflection ning kamchiliklari va xavflari qanday?**
10. **Framework'lar Reflection dan qanday foydalanadi?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Reflection asosidagi vosita yarating:

1. **Object to JSON converter** - Har qanday ob'ektni JSON ga o'tkazish
2. **Dependency Injector** - @Inject annotation bilan field'larga qiymat o'rnatish
3. **Test Runner** - @Test annotation bilan metodlarni ishga tushirish
4. **Bean Inspector** - Sinf haqida to'liq ma'lumot chiqaruvchi vosita

```java
// Tekshirish:
MyFramework.inspect(Person.class);
MyFramework.toJson(person);
MyFramework.injectDependencies(controller);
MyFramework.runTests(CalculatorTest.class);
```

---

**Keyingi mavzu:** [Telegram Bot](./16_Telegram_Bot.md)  
**[Mundarijaga qaytish](../README.md)**

> Reflection - kuchli vosita, lekin ehtiyotkorlik bilan ishlatish kerak! 🚀
