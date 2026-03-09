# 17 - Annotations (Annotationlar)

## Annotation nima?

**Annotation** - Java kodiga metadata (qo'shimcha ma'lumot) qo'shish mexanizmi. JDK5 da qo'shilgan bo'lib, XML deskriptorlar va marker interfeyslarga alternativa sifatida xizmat qiladi.

```java
// Annotation - kod haqida qo'shimcha ma'lumot
@Override  // Bu metod parent class metodini override qilayotganini bildiradi
public String toString() {
    return "This is annotated method";
}
```

### Annotation xususiyatlari

1. **Metadata qo'shadi** - Kod haqida qo'shimcha ma'lumot beradi
2. **Programma bajarilishiga ta'sir qilmaydi** - Annotation'lar o'z-o'zidan kodni o'zgartirmaydi
3. **Kompilyator va framework'lar uchun** - Kompilyatorga yordam beradi, framework'lar esa ish vaqtida o'qiydi

```java
// Annotation'lar qayerda ishlatiladi?
// - Package'lar, class'lar, interfeyslar
// - Metodlar, konstruktorlar
// - Field'lar (o'zgaruvchilar)
// - Parametrlar, local o'zgaruvchilar
```

---

## 17.1 - Annotation turlari

### 1. Predefined Annotations (Oldindan belgilangan)

| Annotation | Vazifasi |
|------------|----------|
| `@Override` | Metodni override qilishni bildiradi |
| `@Deprecated` | Eski, ishlatilmaydigan elementlarni belgilaydi |
| `@SuppressWarnings` | Kompilyator warning'larini bostirish |
| `@SafeVarargs` | Varargs bilan bog'liq xavfsizlikni bildiradi |
| `@FunctionalInterface` | Functional interface ekanligini bildiradi |

### 2. Meta-annotations (Annotation'lar uchun annotation'lar)

| Meta-annotation | Vazifasi |
|-----------------|----------|
| `@Retention` | Annotation qachon saqlanishini belgilaydi |
| `@Target` | Annotation qayerda ishlatilishini belgilaydi |
| `@Documented` | Javadoc'ga kiritilishini bildiradi |
| `@Inherited` | Subclass'larga meros qolishini bildiradi |
| `@Repeatable` | Bir joyda bir necha marta ishlatish imkonini beradi |

### 3. Custom Annotations (Foydalanuvchi tomonidan yaratilgan)

```java
// Custom annotation yaratish
public @interface MyAnnotation {
    String value() default "";
    int count() default 1;
}
```

---

## 17.2 - Predefined Annotations

### @Override

```java
public class Parent {
    public void display() {
        System.out.println("Parent class");
    }
}

public class Child extends Parent {
    
    @Override  // Bu metod parent class'dagi metodni override qiladi
    public void display() {
        System.out.println("Child class");
    }
    
    // @Override  // ERROR! Parent'da bunday metod yo'q
    // public void show() {
    //     System.out.println("Show");
    // }
}

// @Override nima uchun kerak?
// 1. Kodni o'qish oson bo'ladi
// 2. Xatolarni oldini oladi (parent class o'zgarsa, compiler xato beradi)
// 3. Intentni bildiradi (men bu metodni override qilayotganimni)
```

### @Deprecated

```java
public class OldClass {
    
    @Deprecated
    public void oldMethod() {
        System.out.println("This method is deprecated");
    }
    
    @Deprecated(since = "2.0", forRemoval = true)
    public void veryOldMethod() {
        System.out.println("Will be removed in next version");
    }
    
    public void newMethod() {
        System.out.println("Use this instead");
    }
}

// Foydalanish
public class Main {
    public static void main(String[] args) {
        OldClass obj = new OldClass();
        
        obj.oldMethod();  // Compiler warning beradi
        obj.veryOldMethod(); // Stronger warning
        obj.newMethod();  // OK
    }
}

// Javadoc'da ham belgilash kerak
/**
 * @deprecated Use {@link #newMethod()} instead
 */
@Deprecated
public void oldMethod() {
}
```

### @SuppressWarnings

```java
import java.util.*;

public class SuppressWarningsExample {
    
    @SuppressWarnings("unchecked")
    public void uncheckedWarning() {
        List rawList = new ArrayList();  // Raw type warning
        rawList.add("Hello");            // Unchecked warning
    }
    
    @SuppressWarnings("deprecation")
    public void deprecationWarning() {
        OldClass obj = new OldClass();
        obj.oldMethod();  // Deprecation warning
    }
    
    @SuppressWarnings({"unchecked", "rawtypes", "deprecation"})
    public void multipleWarnings() {
        List rawList = new ArrayList();
        rawList.add("Hello");
        
        OldClass obj = new OldClass();
        obj.oldMethod();
    }
    
    @SuppressWarnings("all")  // Barcha warning'larni bostiradi
    public void suppressAll() {
        // All warnings suppressed
    }
}
```

### Warning turlari

| Warning | Ma'nosi |
|---------|---------|
| `"unchecked"` | Type safety bo'lmagan operatsiyalar |
| `"deprecation"` | Deprecated elementlarni ishlatish |
| `"rawtypes"` | Raw type ishlatish |
| `"serial"` | Serializable class da serialVersionUID yo'q |
| `"fallthrough"` | Switch da break yo'q |
| `"path"` | Classpath bilan bog'liq muammolar |
| `"all"` | Barcha warning'lar |

### @SafeVarargs

```java
import java.util.*;

public class SafeVarargsExample {
    
    // Varargs bilan ishlashda xavfsizlik muammosi
    @SafeVarargs
    public static <T> List<T> asList(T... elements) {
        return Arrays.asList(elements);
    }
    
    @SafeVarargs
    public static void printAll(List<String>... lists) {
        for (List<String> list : lists) {
            System.out.println(list);
        }
    }
    
    // Not safe - heap pollution bo'lishi mumkin
    @SafeVarargs
    public static void notActuallySafe(List<String>... stringLists) {
        Object[] array = stringLists;          // List<String>[] -> Object[]
        List<Integer> tmpList = List.of(42);   
        array[0] = tmpList;                    // Heap pollution!
        String s = stringLists[0].get(0);       // ClassCastException
    }
    
    public static void main(String[] args) {
        List<String> list1 = asList("a", "b", "c");
        List<String> list2 = asList("x", "y", "z");
        
        printAll(list1, list2);  // OK
    }
}
```

### @FunctionalInterface

```java
@FunctionalInterface
interface Calculator {
    int calculate(int a, int b);  // Single abstract method
    
    // default methods - ko'p bo'lishi mumkin
    default void print() {
        System.out.println("Calculator");
    }
    
    // static methods - ko'p bo'lishi mumkin
    static void info() {
        System.out.println("Functional Interface");
    }
}

// @FunctionalInterface
// interface InvalidInterface {
//     void method1();  // ERROR! Two abstract methods
//     void method2();
// }

// Lambda expressions bilan ishlatish
Calculator add = (a, b) -> a + b;
Calculator multiply = (a, b) -> a * b;

System.out.println(add.calculate(5, 3));     // 8
System.out.println(multiply.calculate(5, 3)); // 15
```

---

## 17.3 - Meta-annotations

### @Retention - Annotation qachon saqlanishi

```java
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;

// 1. SOURCE - Faqat source code'da, compiler tashlab ketadi
@Retention(RetentionPolicy.SOURCE)
@interface SourceAnnotation {
    String value();
}

// 2. CLASS - .class faylida saqlanadi, lekin runtime'da mavjud emas
@Retention(RetentionPolicy.CLASS)
@interface ClassAnnotation {
    String value();
}

// 3. RUNTIME - Runtime'da ham mavjud (reflection orqali o'qish mumkin)
@Retention(RetentionPolicy.RUNTIME)
@interface RuntimeAnnotation {
    String value();
}

// Misol
public class RetentionExample {
    
    @SourceAnnotation("source")
    public void sourceMethod() {}
    
    @ClassAnnotation("class")
    public void classMethod() {}
    
    @RuntimeAnnotation("runtime")
    public void runtimeMethod() {}
    
    public static void main(String[] args) throws Exception {
        RetentionExample obj = new RetentionExample();
        
        // Faqat RUNTIME annotation'larni ko'rish mumkin
        RuntimeAnnotation anno = obj.getClass()
            .getMethod("runtimeMethod")
            .getAnnotation(RuntimeAnnotation.class);
        
        System.out.println(anno.value());  // "runtime"
        
        // SOURCE va CLASS annotation'lar reflection'da ko'rinmaydi
    }
}
```

### @Target - Annotation qayerda ishlatilishi

```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Target;

// 1. METHOD - faqat metodlarda
@Target(ElementType.METHOD)
@interface MethodAnnotation {
    String value();
}

// 2. FIELD - faqat field'larda
@Target(ElementType.FIELD)
@interface FieldAnnotation {
    String value();
}

// 3. TYPE - class, interface, enum'larda
@Target(ElementType.TYPE)
@interface TypeAnnotation {
    String value();
}

// 4. PARAMETER - metod parametrlarida
@Target(ElementType.PARAMETER)
@interface ParamAnnotation {
    String value();
}

// 5. CONSTRUCTOR - konstruktorlarda
@Target(ElementType.CONSTRUCTOR)
@interface ConstructorAnnotation {
    String value();
}

// 6. Multiple targets
@Target({ElementType.METHOD, ElementType.FIELD, ElementType.TYPE})
@interface MultipleAnnotation {
    String value();
}

// Foydalanish
@TypeAnnotation("class")
public class TargetExample {
    
    @FieldAnnotation("field")
    private String name;
    
    @ConstructorAnnotation("constructor")
    public TargetExample() {}
    
    @MethodAnnotation("method")
    public void testMethod(
        @ParamAnnotation("parameter") String param
    ) {
        // method body
    }
    
    // @FieldAnnotation("field")  // ERROR! Method'da ishlatib bo'lmaydi
    public void wrongUsage() {}
}
```

### @Documented - Javadoc'ga qo'shish

```java
import java.lang.annotation.Documented;

@Documented
@interface DocumentedAnnotation {
    String value();
}

// Bu annotation Javadoc'da ko'rinadi
@DocumentedAnnotation("test")
public class DocumentedExample {
    // class body
}
```

### @Inherited - Subclass'larga meros qolishi

```java
import java.lang.annotation.Inherited;

@Inherited
@interface InheritedAnnotation {
    String value();
}

@InheritedAnnotation("parent")
class ParentClass {}

// ChildClass ham @InheritedAnnotation ga ega bo'ladi
class ChildClass extends ParentClass {}

public class InheritedExample {
    public static void main(String[] args) {
        // Parent'da annotation bor
        System.out.println(ParentClass.class
            .getAnnotation(InheritedAnnotation.class));  // @InheritedAnnotation("parent")
        
        // Child'da ham annotation bor (meros qolgan)
        System.out.println(ChildClass.class
            .getAnnotation(InheritedAnnotation.class));  // @InheritedAnnotation("parent")
    }
}
```

### @Repeatable - Bir necha marta ishlatish

```java
import java.lang.annotation.Repeatable;

// 1. Container annotation yaratish
@interface Schedules {
    Schedule[] value();
}

// 2. Repeatable annotation
@Repeatable(Schedules.class)
@interface Schedule {
    String day();
    String time();
}

// 3. Bir necha marta ishlatish
@Schedule(day = "Monday", time = "10:00")
@Schedule(day = "Wednesday", time = "14:00")
@Schedule(day = "Friday", time = "09:00")
class MeetingClass {
    // class body
}

public class RepeatableExample {
    public static void main(String[] args) {
        Schedule[] schedules = MeetingClass.class
            .getAnnotationsByType(Schedule.class);
        
        for (Schedule schedule : schedules) {
            System.out.println(schedule.day() + " at " + schedule.time());
        }
    }
}
```

---

## 17.4 - Custom Annotations

### Oddiy custom annotation

```java
import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

// Custom annotation yaratish
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.METHOD)
@interface TestInfo {
    String author() default "Unknown";
    String date();
    int version() default 1;
    String[] tags() default {};
}

// Foydalanish
public class TestClass {
    
    @TestInfo(
        author = "Ali",
        date = "2024-01-15",
        version = 2,
        tags = {"unit", "integration"}
    )
    public void testMethod() {
        System.out.println("Testing...");
    }
    
    @TestInfo(
        date = "2024-01-20",
        tags = "performance"
    )
    public void anotherTest() {
        System.out.println("Another test...");
    }
}

// Annotation'larni o'qish
public class AnnotationReader {
    public static void main(String[] args) throws Exception {
        TestClass obj = new TestClass();
        
        TestInfo info = obj.getClass()
            .getMethod("testMethod")
            .getAnnotation(TestInfo.class);
        
        System.out.println("Author: " + info.author());
        System.out.println("Date: " + info.date());
        System.out.println("Version: " + info.version());
        System.out.println("Tags: " + Arrays.toString(info.tags()));
    }
}
```

### Field validation uchun annotation

```java
import java.lang.annotation.*;
import java.lang.reflect.Field;

// Validation annotation
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface NotNull {
    String message() default "Field cannot be null";
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface Min {
    int value();
    String message() default "Value is too small";
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface Max {
    int value();
    String message() default "Value is too large";
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface Email {
    String message() default "Invalid email format";
}

// Model class
class User {
    @NotNull(message = "Name is required")
    private String name;
    
    @Min(value = 18, message = "Age must be at least 18")
    @Max(value = 100, message = "Age must be at most 100")
    private int age;
    
    @Email(message = "Invalid email address")
    @NotNull
    private String email;
    
    // constructor, getters, setters
}

// Validator
class Validator {
    public static void validate(Object obj) throws Exception {
        Class<?> clazz = obj.getClass();
        Field[] fields = clazz.getDeclaredFields();
        
        for (Field field : fields) {
            field.setAccessible(true);
            Object value = field.get(obj);
            
            // @NotNull tekshirish
            if (field.isAnnotationPresent(NotNull.class)) {
                if (value == null) {
                    NotNull anno = field.getAnnotation(NotNull.class);
                    throw new Exception(anno.message());
                }
            }
            
            // @Min tekshirish
            if (field.isAnnotationPresent(Min.class) && value != null) {
                Min anno = field.getAnnotation(Min.class);
                if (value instanceof Number) {
                    if (((Number) value).intValue() < anno.value()) {
                        throw new Exception(anno.message());
                    }
                }
            }
            
            // @Max tekshirish
            if (field.isAnnotationPresent(Max.class) && value != null) {
                Max anno = field.getAnnotation(Max.class);
                if (value instanceof Number) {
                    if (((Number) value).intValue() > anno.value()) {
                        throw new Exception(anno.message());
                    }
                }
            }
            
            // @Email tekshirish (oddiy)
            if (field.isAnnotationPresent(Email.class) && value != null) {
                String email = (String) value;
                if (!email.contains("@") || !email.contains(".")) {
                    Email anno = field.getAnnotation(Email.class);
                    throw new Exception(anno.message());
                }
            }
        }
    }
}

// Foydalanish
public class ValidationExample {
    public static void main(String[] args) {
        User user = new User();
        user.setName("Ali");
        user.setAge(25);
        user.setEmail("ali@example.com");
        
        try {
            Validator.validate(user);
            System.out.println("✅ Validation passed");
        } catch (Exception e) {
            System.out.println("❌ Validation failed: " + e.getMessage());
        }
        
        // Invalid user
        User invalidUser = new User();
        invalidUser.setName(null);
        invalidUser.setAge(15);
        invalidUser.setEmail("invalid-email");
        
        try {
            Validator.validate(invalidUser);
            System.out.println("✅ Validation passed");
        } catch (Exception e) {
            System.out.println("❌ Validation failed: " + e.getMessage());
        }
    }
}
```

### Dependency Injection uchun annotation

```java
import java.lang.annotation.*;
import java.lang.reflect.Field;
import java.util.HashMap;
import java.util.Map;

// Annotation'lar
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface Inject {}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@Component
@interface Component {}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.TYPE)
@interface Service {}

// Service'lar
@Component
class DatabaseService {
    public void connect() {
        System.out.println("Connected to database");
    }
}

@Service
class UserService {
    @Inject
    private DatabaseService dbService;
    
    public void saveUser() {
        dbService.connect();
        System.out.println("User saved");
    }
}

@Service
class EmailService {
    @Inject
    private DatabaseService dbService;
    
    public void sendEmail() {
        dbService.connect();
        System.out.println("Email sent");
    }
}

// Simple DI Container
class Container {
    private static Map<Class<?>, Object> instances = new HashMap<>();
    
    static {
        instances.put(DatabaseService.class, new DatabaseService());
    }
    
    public static void injectDependencies(Object target) throws Exception {
        Class<?> clazz = target.getClass();
        Field[] fields = clazz.getDeclaredFields();
        
        for (Field field : fields) {
            if (field.isAnnotationPresent(Inject.class)) {
                Class<?> fieldType = field.getType();
                Object dependency = instances.get(fieldType);
                
                if (dependency == null) {
                    // Create new instance
                    dependency = fieldType.getDeclaredConstructor().newInstance();
                    instances.put(fieldType, dependency);
                }
                
                field.setAccessible(true);
                field.set(target, dependency);
            }
        }
    }
    
    public static <T> T getService(Class<T> serviceClass) throws Exception {
        T instance = serviceClass.getDeclaredConstructor().newInstance();
        injectDependencies(instance);
        return instance;
    }
}

// Foydalanish
public class DIExample {
    public static void main(String[] args) throws Exception {
        UserService userService = Container.getService(UserService.class);
        userService.saveUser();
        
        EmailService emailService = Container.getService(EmailService.class);
        emailService.sendEmail();
    }
}
```

### JSON Serialization uchun annotation

```java
import java.lang.annotation.*;
import java.lang.reflect.Field;
import java.util.StringJoiner;

// Annotation'lar
@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface JsonField {
    String name() default "";
}

@Retention(RetentionPolicy.RUNTIME)
@Target(ElementType.FIELD)
@interface JsonIgnore {}

// Model
class Person {
    @JsonField(name = "full_name")
    private String name;
    
    @JsonField
    private int age;
    
    @JsonIgnore
    private String password;
    
    public Person(String name, int age, String password) {
        this.name = name;
        this.age = age;
        this.password = password;
    }
}

// JSON Serializer
class JsonSerializer {
    
    public static String toJson(Object obj) throws Exception {
        Class<?> clazz = obj.getClass();
        Field[] fields = clazz.getDeclaredFields();
        
        StringJoiner sj = new StringJoiner(",", "{", "}");
        
        for (Field field : fields) {
            // @JsonIgnore bo'lsa, tashlab ketish
            if (field.isAnnotationPresent(JsonIgnore.class)) {
                continue;
            }
            
            field.setAccessible(true);
            Object value = field.get(obj);
            
            if (value != null) {
                // Field nomini aniqlash
                String fieldName = field.getName();
                if (field.isAnnotationPresent(JsonField.class)) {
                    JsonField jsonField = field.getAnnotation(JsonField.class);
                    if (!jsonField.name().isEmpty()) {
                        fieldName = jsonField.name();
                    }
                }
                
                // JSON formatida qo'shish
                String jsonPart = String.format("\"%s\":", fieldName);
                
                if (value instanceof String) {
                    jsonPart += String.format("\"%s\"", value);
                } else {
                    jsonPart += value.toString();
                }
                
                sj.add(jsonPart);
            }
        }
        
        return sj.toString();
    }
}

// Foydalanish
public class JsonExample {
    public static void main(String[] args) throws Exception {
        Person person = new Person("Ali Valiyev", 25, "secret123");
        
        String json = JsonSerializer.toJson(person);
        System.out.println(json);
        // {"full_name":"Ali Valiyev","age":25}
    }
}
```

---

## 17.5 - Annotation'lar va Reflection

### Annotation'larni o'qish

```java
import java.lang.annotation.*;
import java.lang.reflect.*;

@Retention(RetentionPolicy.RUNTIME)
@Target({ElementType.TYPE, ElementType.METHOD, ElementType.FIELD})
@interface Info {
    String author();
    String date();
    String description() default "";
}

@Info(author = "Ali", date = "2024-01-15", description = "Main class")
public class AnnotationReflection {
    
    @Info(author = "Vali", date = "2024-01-16")
    private String field;
    
    @Info(author = "Soli", date = "2024-01-17", description = "Test method")
    public void testMethod() {}
    
    public static void main(String[] args) {
        Class<?> clazz = AnnotationReflection.class;
        
        // Class annotation
        if (clazz.isAnnotationPresent(Info.class)) {
            Info classInfo = clazz.getAnnotation(Info.class);
            System.out.println("Class Info:");
            System.out.println("  Author: " + classInfo.author());
            System.out.println("  Date: " + classInfo.date());
            System.out.println("  Description: " + classInfo.description());
        }
        
        // Field annotations
        Field[] fields = clazz.getDeclaredFields();
        for (Field field : fields) {
            if (field.isAnnotationPresent(Info.class)) {
                Info fieldInfo = field.getAnnotation(Info.class);
                System.out.println("\nField " + field.getName() + ":");
                System.out.println("  Author: " + fieldInfo.author());
                System.out.println("  Date: " + fieldInfo.date());
            }
        }
        
        // Method annotations
        Method[] methods = clazz.getDeclaredMethods();
        for (Method method : methods) {
            if (method.isAnnotationPresent(Info.class)) {
                Info methodInfo = method.getAnnotation(Info.class);
                System.out.println("\nMethod " + method.getName() + ":");
                System.out.println("  Author: " + methodInfo.author());
                System.out.println("  Date: " + methodInfo.date());
                System.out.println("  Description: " + methodInfo.description());
            }
        }
    }
}
```

---

## Annotation Cheat Sheet

```java
// 1. Annotation yaratish
public @interface MyAnnotation {
    String value() default "";
    int count() default 1;
}

// 2. Meta-annotations
@Retention(RetentionPolicy.RUNTIME)  // SOURCE, CLASS, RUNTIME
@Target(ElementType.METHOD)           // TYPE, FIELD, METHOD, PARAMETER, etc.
@Documented
@Inherited
@Repeatable(Container.class)

// 3. Predefined annotations
@Override
@Deprecated(since = "2.0", forRemoval = true)
@SuppressWarnings({"unchecked", "deprecation"})
@SafeVarargs
@FunctionalInterface

// 4. Annotation ishlatish
@MyAnnotation(value = "test", count = 5)
public void annotatedMethod() {}

// 5. Annotation o'qish
MyAnnotation anno = obj.getClass()
    .getMethod("annotatedMethod")
    .getAnnotation(MyAnnotation.class);
```

---

## Tekshiruv Savollari

1. **Annotation nima va nima uchun kerak?**
2. **Predefined annotation'lar qaysilar? Har birini tushuntiring.**
3. **@Override nima uchun ishlatiladi?**
4. **@Deprecated va @deprecated farqi nima?**
5. **@SuppressWarnings qanday ishlatiladi?**
6. **@SafeVarargs qachon ishlatiladi?**
7. **@FunctionalInterface nima uchun kerak?**
8. **Meta-annotation'lar qaysilar?**
9. **@Retention turlari va farqlari?**
10. **@Target nima uchun kerak?**
11. **Custom annotation qanday yaratiladi?**
12. **Annotation'larni reflection orqali qanday o'qish mumkin?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega annotation'lar yarating:

1. **@NotNull** - Field null bo'lmasligi kerak
2. **@Min** / **@Max** - Sonli qiymatlar uchun cheklov
3. **@Size** - String uzunligi uchun cheklov
4. **@Email** - Email formatini tekshirish
5. **@Cache** - Method natijasini cache qilish
6. **@Log** - Method chaqirilishini log qilish

```java
// Tekshirish:
public class TestClass {
    @NotNull
    @Size(min = 2, max = 50)
    private String name;
    
    @Min(18)
    @Max(100)
    private int age;
    
    @Email
    private String email;
    
    @Cache(timeout = 60000)
    public String expensiveOperation() {
        // ...
    }
    
    @Log
    public void userAction() {
        // ...
    }
}
```

---

**5-modul yakunlandi!**

**[Mundarijaga qaytish](../README.md)**

> Annotation'lar - Java dasturlashning kuchli vositasi! 🚀
