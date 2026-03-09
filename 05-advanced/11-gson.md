# 14 - GSON (JSON Parsing Library)

## GSON nima?

**GSON** - Google tomonidan ishlab chiqilgan Java kutubxonasi bo'lib, Java ob'ektlarini JSON formatiga va JSON formatidagi ma'lumotlarni Java ob'ektlariga o'tkazish uchun ishlatiladi.

```java
// Java Ob'ekti -> JSON (Serialization)
Person person = new Person("John", 25);
String json = gson.toJson(person);  // {"name":"John","age":25}

// JSON -> Java Ob'ekti (Deserialization)
String json = "{\"name\":\"John\",\"age\":25}";
Person person = gson.fromJson(json, Person.class);
```

### JSON nima?

**JSON (JavaScript Object Notation)** - ma'lumotlarni saqlash va uzatish uchun ishlatiladigan yengil format. O'qish va tushunish oson.

```json
{
  "firstName": "John",
  "lastName": "Smith",
  "isAlive": true,
  "age": 27,
  "address": {
    "streetAddress": "21 2nd Street",
    "city": "New York",
    "state": "NY",
    "postalCode": "10021-3100"
  },
  "phoneNumbers": [
    {
      "type": "home",
      "number": "212 555-1234"
    },
    {
      "type": "office",
      "number": "646 555-4567"
    }
  ]
}
```

### Nima uchun GSON kerak?

1. **API'lar bilan ishlash** - Ko'pchilik API'lar JSON formatida ma'lumot qaytaradi
2. **Ma'lumotlar almashish** - Turli tizimlar o'rtasida ma'lumot almashish
3. **Konfiguratsiya fayllari** - Sozlamalarni JSON formatida saqlash
4. **Ma'lumotlar bazasi** - NoSQL ma'lumotlar bazalari (MongoDB) JSON ishlatadi

---

## 14.1 - GSON o'rnatish

### Maven dependency

```xml
<dependency>
    <groupId>com.google.code.gson</groupId>
    <artifactId>gson</artifactId>
    <version>2.13.2</version>
</dependency>
```
MVN Repository Link: https://mvnrepository.com/artifact/com.google.code.gson/gson

### Gradle dependency

```groovy
implementation 'com.google.code.gson:gson:2.13.2'
```

### JAR fayl (Maven'siz)

https://repo1.maven.org/maven2/com/google/code/gson/gson/

---

## 14.2 - GSON asoslari

### Gson instance yaratish

```java
import com.google.gson.*;

// 1. Oddiy Gson instance (default sozlamalar)
Gson gson = new Gson();
// Xususiyatlari:
// - compact JSON (white-space larsiz)
// - null field'lar tashlab ketiladi
// - default Date format ishlatiladi
// - @Expose va @Since annotation'lar hisobga olinmaydi

// 2. GsonBuilder bilan (custom sozlamalar)
Gson gson = new GsonBuilder()
    .serializeNulls()                    // null field'larni ham yozish
    .setPrettyPrinting()                  // chiroyli format (indentation)
    .setDateFormat("yyyy-MM-dd")           // Date format
    .setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE) // Field nomlash
    .setVersion(1.0)                       // Version control
    .excludeFieldsWithoutExposeAnnotation() // Faqat @Expose field'larni
    .create();
```

### Serialization (Java -> JSON)

```java
public class SerializationExample {
    public static void main(String[] args) {
        Gson gson = new Gson();
        
        // 1. Primitive tiplar
        int number = 42;
        String jsonNumber = gson.toJson(number);  // "42"
        
        boolean flag = true;
        String jsonBoolean = gson.toJson(flag);   // "true"
        
        String text = "Hello";
        String jsonString = gson.toJson(text);    // "\"Hello\""
        
        // 2. Array
        int[] numbers = {1, 2, 3, 4, 5};
        String jsonArray = gson.toJson(numbers);  // "[1,2,3,4,5]"
        
        // 3. Collection
        List<String> names = Arrays.asList("Ali", "Vali", "Soli");
        String jsonList = gson.toJson(names);     // "[\"Ali\",\"Vali\",\"Soli\"]"
        
        // 4. Map
        Map<String, Integer> map = new HashMap<>();
        map.put("one", 1);
        map.put("two", 2);
        String jsonMap = gson.toJson(map);        // "{\"one\":1,\"two\":2}"
        
        // 5. Custom object
        Person person = new Person("John", 25, "john@example.com");
        String jsonPerson = gson.toJson(person);
        // {"name":"John","age":25,"email":"john@example.com"}
        
        System.out.println("JSON: " + jsonPerson);
    }
}

class Person {
    private String name;
    private int age;
    private String email;
    
    public Person(String name, int age, String email) {
        this.name = name;
        this.age = age;
        this.email = email;
    }
}
```

### Deserialization (JSON -> Java)

```java
public class DeserializationExample {
    public static void main(String[] args) {
        Gson gson = new Gson();
        
        // 1. Primitive tiplar
        String jsonNumber = "42";
        int number = gson.fromJson(jsonNumber, int.class);
        
        String jsonBoolean = "true";
        boolean flag = gson.fromJson(jsonBoolean, boolean.class);
        
        String jsonString = "\"Hello\"";
        String text = gson.fromJson(jsonString, String.class);
        
        // 2. Array
        String jsonArray = "[1,2,3,4,5]";
        int[] numbers = gson.fromJson(jsonArray, int[].class);
        
        // 3. Collection
        String jsonList = "[\"Ali\",\"Vali\",\"Soli\"]";
        Type listType = new TypeToken<List<String>>(){}.getType();
        List<String> names = gson.fromJson(jsonList, listType);
        
        // 4. Map
        String jsonMap = "{\"one\":1,\"two\":2}";
        Type mapType = new TypeToken<Map<String, Integer>>(){}.getType();
        Map<String, Integer> map = gson.fromJson(jsonMap, mapType);
        
        // 5. Custom object
        String jsonPerson = "{\"name\":\"John\",\"age\":25,\"email\":\"john@example.com\"}";
        Person person = gson.fromJson(jsonPerson, Person.class);
        
        System.out.println("Name: " + person.name);
        System.out.println("Age: " + person.age);
        System.out.println("Email: " + person.email);
    }
}
```

---

## 14.3 - Book misoli

### Book class

```java
import lombok.Data;
import lombok.Builder;
import com.google.gson.annotations.Expose;
import com.google.gson.annotations.SerializedName;
import com.google.gson.annotations.Since;
import java.util.Date;
import java.time.LocalDate;

@Data
@Builder
public class Book {
    
    @Expose
    @SerializedName("id")
    private Integer bookId;
    
    @Expose(deserialize = false)  // Serialize qilinadi, lekin deserialize qilinmaydi
    @SerializedName("title")
    protected String bookTitle;
    
    @Expose
    @SerializedName("author")
    private String bookAuthor;
    
    @Since(1.0)
    @Expose
    private volatile Date bookDate;
    
    @Expose
    private LocalDate publishedDate;
}
```

### JSON fayldan o'qish (Books.json)

```json
[
  {
    "id": 1,
    "title": "Reactive Spring",
    "author": "Josh Long",
    "publishedDate": "2021-01-01"
  },
  {
    "id": 2,
    "title": "Modern Java in Action",
    "author": "Raoul-Gabriel Urma",
    "publishedDate": "2022-03-15"
  }
]
```

### Default konfiguratsiya

```java
public class DefaultConfigurationExample {
    private static String booksListAsStringJSON;
    
    static {
        try {
            String file = Main.class.getClassLoader()
                .getResource("Books.json").getFile();
            booksListAsStringJSON = Files.readString(Path.of(file));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    
    public static void main(String[] args) {
        // Default Gson
        Gson gson = new Gson();
        
        // 1. Object -> JSON
        Book book = Book.builder()
            .bookId(1)
            .bookTitle("Reactive Spring")
            .bookAuthor("Josh Long")
            .publishedDate(LocalDate.of(2021, 1, 1))
            .build();
        
        String jsonData = gson.toJson(book);
        System.out.println("JSON: " + jsonData);
        // {"id":1,"title":"Reactive Spring","author":"Josh Long"}
        // publishedDate yo'q - LocalDate default serializer yo'q!
        
        // 2. JSON -> Object
        String jsonData2 = "{\"id\":1,\"title\":\"Reactive Spring\",\"author\":\"Josh Long\"}";
        Book fromJsonBook = gson.fromJson(jsonData2, Book.class);
        System.out.println("Book: " + fromJsonBook);
        
        // 3. List<Book> -> JSON
        Type listType = new TypeToken<List<Book>>() {}.getType();
        List<Book> books = gson.fromJson(booksListAsStringJSON, listType);
        books.forEach(System.out::println);
    }
}
```

---

## 14.4 - Custom konfiguratsiya

### GsonBuilder bilan sozlash

```java
public class CustomConfigurationExample {
    public static void main(String[] args) {
        
        // GsonBuilder bilan custom sozlamalar
        Gson gson = new GsonBuilder()
            .serializeNulls()                          // null field'larni ham yozish
            .setPrettyPrinting()                       // chiroyli format
            .setDateFormat("yyyy-MM-dd HH:mm:ss")      // Date format
            .setFieldNamingPolicy(FieldNamingPolicy.UPPER_CAMEL_CASE) // Field nomlari
            .excludeFieldsWithoutExposeAnnotation()    // Faqat @Expose field'lar
            .excludeFieldsWithModifiers(Modifier.VOLATILE, Modifier.PROTECTED)
            .setVersion(1.2)                           // Version control
            .create();
        
        Book book = Book.builder()
            .bookId(1)
            .bookTitle("Reactive Spring")
            .bookAuthor("Josh Long")
            .publishedDate(LocalDate.of(2021, 1, 1))
            .build();
        
        String json = gson.toJson(book);
        System.out.println(json);
        // Chiroyli formatda, null field'lar bilan, field nomlari UPPER_CAMEL_CASE
    }
}
```

---

## 14.5 - Annotation'lar

### @SerializedName

JSON field nomi bilan Java field nomi farq qilganda ishlatiladi.

```java
public class User {
    @SerializedName("user_id")
    private int userId;
    
    @SerializedName("full_name")
    private String fullName;
    
    @SerializedName("email_address")
    private String email;
}

// JSON: {"user_id":1, "full_name":"John Doe", "email_address":"john@example.com"}
// Java: User(userId=1, fullName=John Doe, email=john@example.com)
```

### @Expose

Qaysi field'lar serialization/deserialization da ishtirok etishini belgilaydi.

```java
public class Product {
    @Expose                    // Serialize va deserialize qilinadi
    private int id;
    
    @Expose(serialize = true, deserialize = false)  // Faqat serialize
    private String name;
    
    @Expose(serialize = false, deserialize = true)  // Faqat deserialize
    private double price;
    
    private String internalCode;  // @Expose yo'q - ignore qilinadi
}

// Ishlatish:
Gson gson = new GsonBuilder()
    .excludeFieldsWithoutExposeAnnotation()
    .create();
```

### @Since

Version control uchun - ma'lum versiyadan keyin qo'shilgan field'larni boshqarish.

```java
public class Employee {
    @Since(1.0)
    private String name;
    
    @Since(1.0)
    private int age;
    
    @Since(1.2)  // 1.2 versiyada qo'shilgan
    private String department;
    
    @Since(2.0)  // 2.0 versiyada qo'shilgan
    private double salary;
}

// Ishlatish:
Gson gson = new GsonBuilder()
    .setVersion(1.2)  // 1.2 versiyagacha bo'lgan field'lar
    .create();
// name, age, department serialize qilinadi, salary emas
```

---

## 14.6 - Field'larni exclude qilish

### 1. @Expose annotation bilan

```java
Gson gson = new GsonBuilder()
    .excludeFieldsWithoutExposeAnnotation()
    .create();
```

### 2. Modifier lar bilan

```java
import java.lang.reflect.Modifier;

Gson gson = new GsonBuilder()
    .excludeFieldsWithModifiers(
        Modifier.VOLATILE, 
        Modifier.PROTECTED,
        Modifier.TRANSIENT
    )
    .create();
```

### 3. transient keyword

```java
public class Data {
    private String name;
    private transient String password;  // Serialize qilinmaydi
}
```

### 4. volatile keyword

```java
public class Counter {
    private int value;
    private volatile boolean flag;  // Exclude qilish mumkin
}
```

---

## 14.7 - Custom Serialization/Deserialization

### JsonSerializer va JsonDeserializer

LocalDate uchun custom serializer va deserializer:

```java
import com.google.gson.*;
import java.time.LocalDate;
import java.time.format.DateTimeFormatter;

// 1. Custom Serializer
public class LocalDateSerializer implements JsonSerializer<LocalDate> {
    @Override
    public JsonElement serialize(LocalDate src, Type typeOfSrc, 
                                 JsonSerializationContext context) {
        return new JsonPrimitive(
            src.format(DateTimeFormatter.ISO_LOCAL_DATE)
        );
    }
}

// 2. Custom Deserializer
public class LocalDateDeserializer implements JsonDeserializer<LocalDate> {
    @Override
    public LocalDate deserialize(JsonElement json, Type typeOfT,
                                JsonDeserializationContext context) 
            throws JsonParseException {
        String dateString = json.getAsString();
        return LocalDate.parse(dateString);
    }
}

// 3. Ishlatish
Gson gson = new GsonBuilder()
    .registerTypeAdapter(LocalDate.class, new LocalDateSerializer())
    .registerTypeAdapter(LocalDate.class, new LocalDateDeserializer())
    .setPrettyPrinting()
    .create();
```

### TypeAdapter (tezroq variant)

```java
import com.google.gson.*;

public class LocalDateTypeAdapter extends TypeAdapter<LocalDate> {
    
    @Override
    public void write(JsonWriter out, LocalDate value) throws IOException {
        if (value == null) {
            out.nullValue();
        } else {
            out.value(value.format(DateTimeFormatter.ISO_LOCAL_DATE));
        }
    }
    
    @Override
    public LocalDate read(JsonReader in) throws IOException {
        if (in.peek() == JsonToken.NULL) {
            in.nextNull();
            return null;
        } else {
            return LocalDate.parse(in.nextString());
        }
    }
}

// Ishlatish
Gson gson = new GsonBuilder()
    .registerTypeAdapter(LocalDate.class, new LocalDateTypeAdapter())
    .setPrettyPrinting()
    .create();
```

---

## 14.8 - To'liq misol

### Main class

```java
import com.google.gson.*;
import com.google.gson.reflect.TypeToken;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.lang.reflect.Type;
import java.time.LocalDate;
import java.util.List;
import java.util.UUID;
import java.util.stream.Stream;

public class Main {
    
    private static String booksListAsStringJSON;
    
    static {
        try {
            String file = Main.class.getClassLoader()
                .getResource("Books.json").getFile();
            booksListAsStringJSON = Files.readString(Path.of(file));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }
    
    public static void main(String[] args) {
        System.out.println("Hello PDP!");
        
        // Custom Gson with LocalDate adapter
        Gson gson = new GsonBuilder()
            .registerTypeAdapter(LocalDate.class, new LocalDateTypeAdapter())
            .serializeNulls()
            .setPrettyPrinting()
            .setFieldNamingPolicy(FieldNamingPolicy.UPPER_CASE_WITH_UNDERSCORES)
            // .excludeFieldsWithoutExposeAnnotation()
            // .excludeFieldsWithModifiers(Modifier.VOLATILE, Modifier.PROTECTED)
            .setVersion(1.2)
            .create();
        
        // UUID generator
        Stream.generate(UUID::randomUUID)
            .limit(5)
            .forEach(System.out::println);
        
        // Object -> JSON
        Book book = Book.builder()
            .bookId(1)
            .bookTitle("Reactive Spring")
            .bookAuthor("Josh Long")
            .publishedDate(LocalDate.of(2021, 1, 1))
            .build();
        
        String jsonData = gson.toJson(book);
        System.out.println("JSON Data:");
        System.out.println(jsonData);
        
        // JSON -> Object
        Book fromJson = gson.fromJson(jsonData, Book.class);
        System.out.println("Java Object:");
        System.out.println(fromJson);
        
        // List of Books from JSON file
        customConfiguration(gson);
        
        // Default configuration example
        // defaultConfiguration();
    }
    
    private static void customConfiguration(Gson gson) {
        Type type = new TypeToken<List<Book>>() {}.getType();
        List<Book> books = gson.fromJson(booksListAsStringJSON, type);
        System.out.println("\nBooks from JSON file:");
        books.forEach(System.out::println);
    }
    
    private static void defaultConfiguration() {
        Gson gson = new Gson();
        
        Book book = Book.builder()
            .bookId(1)
            .bookTitle("Reactive Spring")
            .bookAuthor("Josh Long")
            .build();
        
        String jsonData = gson.toJson(book);
        System.out.println("Default JSON: " + jsonData);
        
        String jsonData2 = "{\"id\":1,\"title\":\"Reactive Spring\",\"author\":\"Josh Long\"}";
        Book fromJsonBook = gson.fromJson(jsonData2, Book.class);
        System.out.println("From JSON: " + fromJsonBook);
        
        Type type = new TypeToken<List<Book>>() {}.getType();
        List<Book> books = gson.fromJson(booksListAsStringJSON, type);
        System.out.println("Books from file:");
        books.forEach(System.out::println);
    }
}
```

---

## 14.9 - GSON sozlamalari

### FieldNamingPolicy

| Policy | Misol |
|--------|-------|
| `IDENTITY` | fieldName (o'zgarishsiz) |
| `LOWER_CASE_WITH_DASHES` | field-name |
| `LOWER_CASE_WITH_UNDERSCORES` | field_name |
| `UPPER_CAMEL_CASE` | FieldName |
| `UPPER_CAMEL_CASE_WITH_SPACES` | Field Name |
| `UPPER_CASE_WITH_UNDERSCORES` | FIELD_NAME |

### GsonBuilder metodlari

| Metod | Vazifasi |
|-------|----------|
| `serializeNulls()` | Null field'larni ham yozish |
| `setPrettyPrinting()` | Chiroyli format (indentation) |
| `setDateFormat(String)` | Date formatini belgilash |
| `setFieldNamingPolicy()` | Field nomlash qoidasi |
| `excludeFieldsWithoutExposeAnnotation()` | Faqat @Expose field'lar |
| `excludeFieldsWithModifiers()` | Modifier lar bo'yicha exclude |
| `setVersion(double)` | Version control |
| `registerTypeAdapter(Type, Object)` | Custom type adapter |
| `registerTypeHierarchyAdapter(Class, Object)` | Class hierarchy adapter |

---

## GSON Cheat Sheet

```java
// 1. Gson instance yaratish
Gson gson = new Gson();

// 2. Java -> JSON
String json = gson.toJson(object);

// 3. JSON -> Java
MyClass obj = gson.fromJson(json, MyClass.class);

// 4. Collection -> JSON
Type listType = new TypeToken<List<MyClass>>(){}.getType();
String json = gson.toJson(list);

// 5. JSON -> Collection
List<MyClass> list = gson.fromJson(json, listType);

// 6. Custom Gson with pretty printing
Gson gson = new GsonBuilder()
    .setPrettyPrinting()
    .serializeNulls()
    .create();

// 7. Custom type adapter
Gson gson = new GsonBuilder()
    .registerTypeAdapter(LocalDate.class, new LocalDateTypeAdapter())
    .create();
```

---

## Tekshiruv Savollari

1. **GSON nima va nima uchun kerak?**
2. **JSON nima va qanday tuzilgan?**
3. **Serialization va deserialization farqi nima?**
4. **GsonBuilder qanday ishlatiladi?**
5. **@SerializedName annotation'i nima uchun kerak?**
6. **@Expose annotation'i qanday ishlaydi?**
7. **@Since annotation'i nima vazifani bajaradi?**
8. **Custom serializer qanday yoziladi?**
9. **TypeAdapter va JsonSerializer farqi nima?**
10. **Field'larni exclude qilishning qanday usullari bor?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega GSON dasturini yozing:

1. **Book class** - @Expose, @SerializedName, @Since annotation'lar bilan
2. **LocalDate adapter** - TypeAdapter yordamida
3. **Custom serializer/deserializer** - murakkab ob'ektlar uchun
4. **JSON fayldan o'qish** - Books.json dan ma'lumotlarni o'qish
5. **JSON ga yozish** - Ob'ektlarni JSON faylga yozish
6. **Pretty printing** - Chiroyli formatda chiqarish

```java
// Tekshirish:
Gson gson = new GsonBuilder()
    .setPrettyPrinting()
    .registerTypeAdapter(LocalDate.class, new LocalDateTypeAdapter())
    .create();

List<Book> books = readBooksFromJson("books.json");
String json = gson.toJson(books);
System.out.println(json);
```

---

**Keyingi mavzu:** [Reflections API](./12-reflection-api.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
