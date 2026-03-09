# Serializatsiya (Serialization)

Serializatsiya - ob'ektni bayt oqimiga aylantirish jarayoni. Deserializatsiya - aksincha jarayon.

## Serializatsiya Ishlatish

```java
import java.io.*;

public class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    private String name;
    private int age;
    
    // constructors, getters, setters
}
```

## Yozish va O'qish

```java
// Yozish (Serialization)
try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream("person.ser"))) {
    oos.writeObject(person);
}

// O'qish (Deserialization)
try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream("person.ser"))) {
    Person person = (Person) ois.readObject();
}
```

## transient Kalit So'z

`transient` bilan belgilangan maydonlar serializatsiya qilinmaydi.

```java
private transient String password; // serializatsiya qilinmaydi
```
