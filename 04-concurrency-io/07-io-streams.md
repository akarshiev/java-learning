# 07 - Input/Output Streams (Kiritish/Chiqarish Oqimlari)

## 7.1 - Input/Output Streams (Kiritish/Chiqarish Oqimlari)

### Input/Output Stream nima?

**Input stream** - baytlar ketma-ketligini o'qish mumkin bo'lgan ob'ekt.  
**Output stream** - baytlar ketma-ketligini yozish mumkin bo'lgan ob'ekt.

```
Source (Fayl, Network, Memory) 
    → [Input Stream] 
    → Java Program 
    → [Output Stream] 
    → Destination (Fayl, Network, Memory)
```

```java
import java.io.*;

public class StreamConcept {
    public static void main(String[] args) {
        // Input Stream - ma'lumotlarni o'qish
        // Output Stream - ma'lumotlarni yozish
        
        // Byte-oriented streams (8-bit)
        InputStream inputStream = null;
        OutputStream outputStream = null;
        
        // Character-oriented streams (16-bit Unicode)
        Reader reader = null;
        Writer writer = null;
    }
}
```

### I/O Stream Hierarchy

```
                   InputStream (abstract)
                  /      |       |       \
          FileInputStream  |   ByteArrayInputStream  ...
                 /         |
      BufferedInputStream  |
                      DataInputStream


                   OutputStream (abstract)
                  /       |       |       \
          FileOutputStream |   ByteArrayOutputStream  ...
                 /          |
      BufferedOutputStream |
                      DataOutputStream


                   Reader (abstract)
                  /       |       \
          FileReader    |    BufferedReader
                InputStreamReader


                   Writer (abstract)
                  /       |       \
          FileWriter    |    BufferedWriter
                OutputStreamWriter
```

### File Class

`File` class - fayl va directory yo'llarini abstrakt ifodalaydi.

```java
import java.io.File;
import java.io.IOException;
import java.util.Date;

public class FileExample {
    public static void main(String[] args) {
        
        // 1. File ob'ekti yaratish
        File file = new File("test.txt");
        File directory = new File("myfolder");
        File path = new File("/home/user/documents/file.txt");
        
        // 2. File ma'lumotlari
        System.out.println("File name: " + file.getName());
        System.out.println("Path: " + file.getPath());
        System.out.println("Absolute path: " + file.getAbsolutePath());
        System.out.println("Parent: " + file.getParent());
        
        // 3. File status
        System.out.println("Exists? " + file.exists());
        System.out.println("Is file? " + file.isFile());
        System.out.println("Is directory? " + file.isDirectory());
        System.out.println("Is hidden? " + file.isHidden());
        System.out.println("Can read? " + file.canRead());
        System.out.println("Can write? " + file.canWrite());
        System.out.println("Can execute? " + file.canExecute());
        
        // 4. File size and time
        System.out.println("Size: " + file.length() + " bytes");
        System.out.println("Last modified: " + new Date(file.lastModified()));
        
        // 5. File operations
        try {
            // Create new file
            File newFile = new File("newfile.txt");
            if (newFile.createNewFile()) {
                System.out.println("File created: " + newFile.getName());
            }
            
            // Create directory
            File newDir = new File("newdir");
            if (newDir.mkdir()) {
                System.out.println("Directory created");
            }
            
            // Create directories (including parents)
            File nestedDir = new File("parent/child/grandchild");
            if (nestedDir.mkdirs()) {
                System.out.println("Nested directories created");
            }
            
            // List files in directory
            File currentDir = new File(".");
            String[] files = currentDir.list();
            System.out.println("\nFiles in current directory:");
            for (String f : files) {
                System.out.println("  " + f);
            }
            
            // Filtered list
            File[] textFiles = currentDir.listFiles((dir, name) -> 
                name.endsWith(".txt"));
            System.out.println("\nText files:");
            for (File f : textFiles) {
                System.out.println("  " + f.getName());
            }
            
            // Rename
            File oldFile = new File("old.txt");
            File newFile2 = new File("renamed.txt");
            if (oldFile.renameTo(newFile2)) {
                System.out.println("File renamed");
            }
            
            // Delete
            if (newFile.delete()) {
                System.out.println("File deleted");
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### FileInputStream va FileOutputStream

**FileInputStream** - fayldan bayt o'qish uchun.  
**FileOutputStream** - faylga bayt yozish uchun.

```java
import java.io.*;

public class FileStreamExample {
    public static void main(String[] args) {
        
        // 1. Faylga yozish (FileOutputStream)
        try (FileOutputStream fos = new FileOutputStream("output.txt")) {
            String text = "Hello, World!";
            byte[] bytes = text.getBytes();
            
            fos.write(bytes); // Butun byte array'ni yozish
            fos.write('\n');  // Yangi qator
            fos.write(65);    // 'A' ni yozish (ASCII 65)
            
            System.out.println("Data written to file");
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. Fayldan o'qish (FileInputStream)
        try (FileInputStream fis = new FileInputStream("output.txt")) {
            
            // Bir bayt o'qish
            int byteData;
            System.out.println("File content:");
            while ((byteData = fis.read()) != -1) {
                System.out.print((char) byteData);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 3. File copy misoli
        copyFile("source.txt", "destination.txt");
    }
    
    public static void copyFile(String source, String destination) {
        try (FileInputStream fis = new FileInputStream(source);
             FileOutputStream fos = new FileOutputStream(destination)) {
            
            byte[] buffer = new byte[1024]; // 1KB buffer
            int bytesRead;
            
            while ((bytesRead = fis.read(buffer)) != -1) {
                fos.write(buffer, 0, bytesRead);
            }
            
            System.out.println("File copied successfully");
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### DataInputStream va DataOutputStream

**DataInputStream/DataOutputStream** - primitive Java typelarini platform-independent usulda o'qish/yozish.

```java
import java.io.*;

public class DataStreamExample {
    public static void main(String[] args) {
        
        String filename = "data.dat";
        
        // 1. Ma'lumotlarni yozish
        try (DataOutputStream dos = new DataOutputStream(
                new FileOutputStream(filename))) {
            
            dos.writeInt(42);           // int
            dos.writeDouble(3.14159);   // double
            dos.writeBoolean(true);     // boolean
            dos.writeUTF("Hello Java"); // String (UTF-8)
            dos.writeLong(123456789L);  // long
            
            System.out.println("Data written to " + filename);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. Ma'lumotlarni o'qish (bir xil tartibda!)
        try (DataInputStream dis = new DataInputStream(
                new FileInputStream(filename))) {
            
            int intValue = dis.readInt();
            double doubleValue = dis.readDouble();
            boolean boolValue = dis.readBoolean();
            String stringValue = dis.readUTF();
            long longValue = dis.readLong();
            
            System.out.println("\nData read from file:");
            System.out.println("int: " + intValue);
            System.out.println("double: " + doubleValue);
            System.out.println("boolean: " + boolValue);
            System.out.println("String: " + stringValue);
            System.out.println("long: " + longValue);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 3. Student ma'lumotlarini saqlash misoli
        saveStudentData();
        readStudentData();
    }
    
    public static void saveStudentData() {
        try (DataOutputStream dos = new DataOutputStream(
                new FileOutputStream("students.dat"))) {
            
            // 3 ta student ma'lumoti
            String[] names = {"Ali", "Vali", "Soli"};
            int[] ages = {20, 22, 21};
            double[] gpas = {3.5, 3.8, 3.2};
            
            for (int i = 0; i < names.length; i++) {
                dos.writeUTF(names[i]);
                dos.writeInt(ages[i]);
                dos.writeDouble(gpas[i]);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    public static void readStudentData() {
        try (DataInputStream dis = new DataInputStream(
                new FileInputStream("students.dat"))) {
            
            System.out.println("\nStudent data:");
            while (dis.available() > 0) {
                String name = dis.readUTF();
                int age = dis.readInt();
                double gpa = dis.readDouble();
                System.out.printf("Name: %s, Age: %d, GPA: %.2f%n", 
                                 name, age, gpa);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### FileReader va FileWriter

**FileReader/FileWriter** - character-oriented data (matn) bilan ishlash uchun.

```java
import java.io.*;

public class FileReaderWriterExample {
    public static void main(String[] args) {
        
        // 1. Faylga matn yozish (FileWriter)
        try (FileWriter fw = new FileWriter("notes.txt")) {
            
            fw.write("Hello, this is line 1\n");
            fw.write("This is line 2\n");
            fw.write("And this is line 3\n");
            
            // Append mode
            FileWriter fwAppend = new FileWriter("notes.txt", true);
            fwAppend.write("This line is appended\n");
            fwAppend.close();
            
            System.out.println("Text written to file");
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. Fayldan matn o'qish (FileReader)
        try (FileReader fr = new FileReader("notes.txt")) {
            
            int charData;
            System.out.println("\nFile content:");
            while ((charData = fr.read()) != -1) {
                System.out.print((char) charData);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 3. Character array bilan o'qish
        try (FileReader fr = new FileReader("notes.txt")) {
            
            char[] buffer = new char[100];
            int charsRead = fr.read(buffer);
            
            System.out.println("\nRead " + charsRead + " characters:");
            System.out.println(new String(buffer, 0, charsRead));
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### BufferedReader va BufferedWriter

**BufferedReader/BufferedWriter** - buffering orqali samarali I/O.

```java
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class BufferedExample {
    public static void main(String[] args) {
        
        // 1. BufferedWriter bilan yozish
        try (BufferedWriter bw = new BufferedWriter(
                new FileWriter("largefile.txt"))) {
            
            for (int i = 1; i <= 1000; i++) {
                bw.write("Line " + i + ": This is some sample text");
                bw.newLine(); // Platform-independent newline
            }
            
            System.out.println("1000 lines written");
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. BufferedReader bilan o'qish (line by line)
        try (BufferedReader br = new BufferedReader(
                new FileReader("largefile.txt"))) {
            
            String line;
            int lineCount = 0;
            
            System.out.println("\nReading first 10 lines:");
            while ((line = br.readLine()) != null && lineCount < 10) {
                System.out.println(line);
                lineCount++;
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 3. readLine() - eng qulay usul
        List<String> lines = new ArrayList<>();
        try (BufferedReader br = new BufferedReader(
                new FileReader("data.txt"))) {
            
            String line;
            while ((line = br.readLine()) != null) {
                lines.add(line);
            }
            
            System.out.println("\nTotal lines: " + lines.size());
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 4. lines() - Stream API bilan (Java 8+)
        try (BufferedReader br = new BufferedReader(
                new FileReader("data.txt"))) {
            
            long count = br.lines()
                .filter(l -> l.contains("Java"))
                .count();
            
            System.out.println("Lines containing 'Java': " + count);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### File(Reader/Writer) vs Buffered(Reader/Writer) farqi

```java
public class ComparisonExample {
    public static void main(String[] args) {
        
        // ❌ Unbuffered - sekin
        long start = System.currentTimeMillis();
        try (FileWriter fw = new FileWriter("unbuffered.txt")) {
            for (int i = 0; i < 100000; i++) {
                fw.write("Line " + i + "\n");
                // Har bir write() da diskka yozadi!
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        long end = System.currentTimeMillis();
        System.out.println("Unbuffered time: " + (end - start) + "ms");
        
        // ✅ Buffered - tez
        start = System.currentTimeMillis();
        try (BufferedWriter bw = new BufferedWriter(
                new FileWriter("buffered.txt"))) {
            for (int i = 0; i < 100000; i++) {
                bw.write("Line " + i + "\n");
                // Buffer to'lganida diskka yozadi
            }
        } catch (IOException e) {
            e.printStackTrace();
        }
        end = System.currentTimeMillis();
        System.out.println("Buffered time: " + (end - start) + "ms");
        
        // Buffer size sozlash
        try (BufferedWriter bw = new BufferedWriter(
                new FileWriter("custom.txt"), 8192 * 8)) { // 64KB buffer
            // ...
        } catch (IOException e) {}
    }
}
```

**Asosiy farqlar:**

| Feature | FileReader/Writer | BufferedReader/Writer |
|---------|-------------------|----------------------|
| **Buffer** | Yo'q (direct I/O) | Ha (8KB default) |
| **Performance** | Sekin (small files) | Tez (large files) |
| **readLine()** | Yo'q | Ha |
| **newLine()** | Yo'q | Ha |
| **Use case** | Kichik fayllar | Katta fayllar, line-by-line |

---

## 7.2 - NIO (New I/O, Java 7+)

### NIO nima?

**NIO (New Input/Output)** - Java 7 da qo'shilgan yangi I/O API. Legacy I/O muammolarini hal qilish uchun.

```java
import java.nio.file.*;
import java.nio.channels.*;
import java.io.IOException;
import java.util.List;

public class NIOExample {
    public static void main(String[] args) {
        
        // Legacy File class drawbacks
        File oldFile = new File("test.txt");
        boolean deleted = oldFile.delete(); // true/false - no exception!
        // Nima sababdan o'chmagan? No idea!
        
        // NIO Path/Files - better error handling
        Path path = Paths.get("test.txt");
        try {
            Files.delete(path); // Throws IOException with details
        } catch (NoSuchFileException e) {
            System.out.println("File doesn't exist: " + e.getFile());
        } catch (DirectoryNotEmptyException e) {
            System.out.println("Directory not empty");
        } catch (IOException e) {
            System.out.println("Other I/O error: " + e.getMessage());
        }
    }
}
```

### Path Class

`Path` - fayl/directory yo'lini ifodalaydi (File o'rniga).

```java
import java.nio.file.Path;
import java.nio.file.Paths;

public class PathExample {
    public static void main(String[] args) {
        
        // 1. Path yaratish
        Path path1 = Paths.get("/home/user/docs/file.txt");
        Path path2 = Paths.get("home", "user", "docs", "file.txt");
        Path path3 = Path.of("myfolder", "subfolder", "file.txt"); // Java 11+
        
        // 2. Path info
        System.out.println("Path: " + path1);
        System.out.println("File name: " + path1.getFileName());
        System.out.println("Parent: " + path1.getParent());
        System.out.println("Root: " + path1.getRoot());
        
        // 3. Path components
        for (int i = 0; i < path1.getNameCount(); i++) {
            System.out.println("Name " + i + ": " + path1.getName(i));
        }
        
        // 4. Subpath
        Path subpath = path1.subpath(1, 3); // user/docs
        System.out.println("Subpath: " + subpath);
        
        // 5. Resolve (combine paths)
        Path base = Paths.get("/home/user");
        Path resolved = base.resolve("docs/file.txt");
        System.out.println("Resolved: " + resolved);
        
        // 6. Relativize
        Path p1 = Paths.get("/home/user/docs");
        Path p2 = Paths.get("/home/user/pics/photo.jpg");
        Path relative = p1.relativize(p2);
        System.out.println("Relative: " + relative); // ../pics/photo.jpg
        
        // 7. Normalize (remove . and ..)
        Path messy = Paths.get("/home/./user/../user/docs/./file.txt");
        Path clean = messy.normalize();
        System.out.println("Normalized: " + clean);
        
        // 8. Convert between Path and File
        Path path = Paths.get("test.txt");
        File file = path.toFile();
        Path back = file.toPath();
    }
}
```

### Files Class

`Files` - fayl operatsiyalari uchun static metodlar.

```java
import java.nio.file.*;
import java.nio.charset.StandardCharsets;
import java.io.IOException;
import java.util.List;
import java.util.stream.Stream;

public class FilesExample {
    public static void main(String[] args) {
        
        Path path = Paths.get("nio_example.txt");
        
        // 1. Write to file
        try {
            // Write bytes
            byte[] data = "Hello NIO".getBytes();
            Files.write(path, data);
            
            // Write lines
            List<String> lines = List.of("Line 1", "Line 2", "Line 3");
            Files.write(path, lines, StandardCharsets.UTF_8);
            
            // Append
            Files.write(path, "Appended line\n".getBytes(), 
                       StandardOpenOption.APPEND);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. Read from file
        try {
            // Read all bytes
            byte[] allBytes = Files.readAllBytes(path);
            System.out.println("Bytes: " + allBytes.length);
            
            // Read all lines
            List<String> allLines = Files.readAllLines(path);
            System.out.println("Lines: " + allLines);
            
            // Read as stream (lazy)
            try (Stream<String> lines = Files.lines(path)) {
                lines.filter(l -> l.contains("Java"))
                     .forEach(System.out::println);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 3. File operations
        try {
            // Copy
            Path source = Paths.get("source.txt");
            Path target = Paths.get("target.txt");
            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
            
            // Move/Rename
            Files.move(target, Paths.get("renamed.txt"), 
                      StandardCopyOption.REPLACE_EXISTING);
            
            // Delete
            Files.deleteIfExists(Paths.get("temp.txt"));
            
            // Create directories
            Files.createDirectories(Paths.get("a/b/c/d"));
            
            // Create temp file
            Path tempFile = Files.createTempFile("prefix", ".tmp");
            System.out.println("Temp file: " + tempFile);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 4. File attributes
        try {
            Path file = Paths.get("test.txt");
            
            System.out.println("Size: " + Files.size(file));
            System.out.println("Is directory? " + Files.isDirectory(file));
            System.out.println("Is regular file? " + Files.isRegularFile(file));
            System.out.println("Is readable? " + Files.isReadable(file));
            System.out.println("Is writable? " + Files.isWritable(file));
            System.out.println("Is executable? " + Files.isExecutable(file));
            
            // Last modified
            FileTime lastModified = Files.getLastModifiedTime(file);
            System.out.println("Last modified: " + lastModified);
            
            // Set attributes
            Files.setAttribute(file, "dos:hidden", true);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 5. Directory operations
        try (DirectoryStream<Path> stream = 
                Files.newDirectoryStream(Paths.get("."))) {
            
            System.out.println("\nFiles in current directory:");
            for (Path entry : stream) {
                System.out.println("  " + entry.getFileName());
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 6. Walk file tree
        try (Stream<Path> walk = Files.walk(Paths.get("."), 2)) {
            System.out.println("\nWalking directory tree:");
            walk.forEach(System.out::println);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 7. Find files
        try (Stream<Path> find = Files.find(
                Paths.get("."), 
                Integer.MAX_VALUE,
                (p, attr) -> p.toString().endsWith(".java"))) {
            
            System.out.println("\nJava files:");
            find.forEach(System.out::println);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### File I/O Comparison

```java
public class IOComparison {
    public static void main(String[] args) {
        
        // ===== Legacy I/O =====
        try (BufferedReader br = new BufferedReader(
                new FileReader("data.txt"));
             BufferedWriter bw = new BufferedWriter(
                new FileWriter("output.txt"))) {
            
            String line;
            while ((line = br.readLine()) != null) {
                bw.write(line);
                bw.newLine();
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // ===== NIO (Java 7+) =====
        Path source = Paths.get("data.txt");
        Path target = Paths.get("output.txt");
        
        try {
            // Simple file copy
            Files.copy(source, target, StandardCopyOption.REPLACE_EXISTING);
            
            // Read all lines
            List<String> lines = Files.readAllLines(source);
            
            // Write all lines
            Files.write(target, lines);
            
            // Process with streams
            try (Stream<String> stream = Files.lines(source)) {
                stream.map(String::toUpperCase)
                      .forEach(System.out::println);
            }
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // ===== Performance comparison =====
        long start, end;
        
        // Legacy I/O
        start = System.currentTimeMillis();
        try (BufferedReader br = new BufferedReader(
                new FileReader("large.txt"))) {
            while (br.readLine() != null) {}
        } catch (IOException e) {}
        end = System.currentTimeMillis();
        System.out.println("Legacy I/O: " + (end - start) + "ms");
        
        // NIO
        start = System.currentTimeMillis();
        try (Stream<String> lines = Files.lines(Paths.get("large.txt"))) {
            lines.count();
        } catch (IOException e) {}
        end = System.currentTimeMillis();
        System.out.println("NIO: " + (end - start) + "ms");
    }
}
```

---

## 7.3 - Serialization and Deserialization

### Serialization nima?

**Serialization** - ob'ekt holatini byte stream'ga aylantirish jarayoni.  
**Deserialization** - byte stream'dan ob'ekt holatini tiklash.

```
[Object in Memory] 
    → Serialization 
    → [Byte Stream] 
    → File/Network/Database
    → Deserialization 
    → [Object in Memory]
```

```java
import java.io.*;

// 1. Serializable interface'ni implement qilish kerak
class Person implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String name;
    private int age;
    private transient String password; // Serialize bo'lmaydi!
    private static String species = "Homo Sapiens"; // Static - serialize bo'lmaydi!
    
    public Person(String name, int age, String password) {
        this.name = name;
        this.age = age;
        this.password = password;
    }
    
    @Override
    public String toString() {
        return String.format("Person{name='%s', age=%d, password='%s', species='%s'}", 
                           name, age, password, species);
    }
}

public class SerializationExample {
    public static void main(String[] args) {
        
        String filename = "person.ser";
        
        // 1. Serialization - ob'ektni faylga saqlash
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(filename))) {
            
            Person person = new Person("Ali", 25, "secret123");
            System.out.println("Before serialization: " + person);
            
            oos.writeObject(person);
            System.out.println("Object serialized to " + filename);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // 2. Deserialization - fayldan ob'ektni o'qish
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(filename))) {
            
            Person deserialized = (Person) ois.readObject();
            System.out.println("After deserialization: " + deserialized);
            // password = null (transient), species = "Homo Sapiens" (static)
            
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

### serialVersionUID nima?

**serialVersionUID** - serialization version control uchun unique ID.

```java
class Employee implements Serializable {
    // Agar o'zgartirilmasa, JVM automatically generates
    private static final long serialVersionUID = 123456789L;
    
    private String name;
    private String department;
    // private double salary; // Agar field qo'shilsa, UID o'zgarmasa?
    
    // Agar UID bir xil bo'lsa, eski serialized object'lar yangi class bilan
    // deserialize bo'ladi (default values for new fields)
}

public class SerialVersionUIDExample {
    public static void main(String[] args) {
        // Scenario: Class o'zgargan, lekin UID bir xil
        // No InvalidClassException, new field default value oladi
        
        // Scenario: UID farq qilsa
        // InvalidClassException: local class incompatible
    }
}
```

### transient Keyword

`transient` - serialize qilinmasligi kerak bo'lgan field'lar uchun.

```java
class User implements Serializable {
    private String username;
    private transient String password;      // Serialize bo'lmaydi
    private transient Logger logger;        // Serialize bo'lmaydi
    private transient Thread thread;        // Serialize bo'lmaydi
    
    // Constructor, getters, setters...
}

// transient ishlatiladigan holatlar:
// 1. Sensitive ma'lumotlar (password, tokens)
// 2. Serializable bo'lmagan field'lar (Thread, Stream, Connection)
// 3. Reconstructed qilish mumkin bo'lgan field'lar (cache)
```

### static va serialization

```java
class TestClass implements Serializable {
    private static int staticCounter = 0;  // Serialize bo'lmaydi!
    private int instanceCounter;
    
    public TestClass() {
        instanceCounter = ++staticCounter;
    }
    
    @Override
    public String toString() {
        return String.format("static=%d, instance=%d", 
                           staticCounter, instanceCounter);
    }
}

public class StaticSerialization {
    public static void main(String[] args) throws Exception {
        TestClass obj1 = new TestClass();
        TestClass obj2 = new TestClass();
        
        System.out.println("obj1: " + obj1); // static=2, instance=1
        System.out.println("obj2: " + obj2); // static=2, instance=2
        
        // Serialize obj1
        ObjectOutputStream oos = new ObjectOutputStream(
            new FileOutputStream("test.ser"));
        oos.writeObject(obj1);
        oos.close();
        
        // staticCounter = 10 deserialization oldidan
        TestClass.staticCounter = 10;
        
        // Deserialize
        ObjectInputStream ois = new ObjectInputStream(
            new FileInputStream("test.ser"));
        TestClass deserialized = (TestClass) ois.readObject();
        ois.close();
        
        System.out.println("deserialized: " + deserialized); 
        // static=10, instance=1 (static current value, instance old value)
    }
}
```

### Externalization

**Externalization** - serialization jarayonini to'liq nazorat qilish.

```java
import java.io.*;

class Student implements Externalizable {
    private String name;
    private int age;
    private double gpa;
    private transient String tempData;
    
    // Public no-arg constructor required for Externalizable!
    public Student() {}
    
    public Student(String name, int age, double gpa) {
        this.name = name;
        this.age = age;
        this.gpa = gpa;
    }
    
    @Override
    public void writeExternal(ObjectOutput out) throws IOException {
        // Faqat kerakli field'larni yozish
        out.writeUTF(name);
        out.writeInt(age);
        // gpa ni yozmaymiz - custom logic
    }
    
    @Override
    public void readExternal(ObjectInput in) throws IOException, ClassNotFoundException {
        name = in.readUTF();
        age = in.readInt();
        gpa = 0.0; // Default value
    }
    
    @Override
    public String toString() {
        return String.format("Student{name='%s', age=%d, gpa=%.2f}", 
                           name, age, gpa);
    }
}

public class ExternalizationExample {
    public static void main(String[] args) {
        
        Student student = new Student("Ali", 20, 3.8);
        System.out.println("Original: " + student);
        
        // Serialize
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream("student.ext"))) {
            oos.writeObject(student);
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // Deserialize
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream("student.ext"))) {
            Student deserialized = (Student) ois.readObject();
            System.out.println("Deserialized: " + deserialized);
            // gpa = 0.0 - chunki biz uni yozmadik!
            
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }
    }
}
```

### Serializable vs Externalizable

| Feature | Serializable | Externalizable |
|---------|--------------|----------------|
| **Control** | JVM controlled | Programmer controlled |
| **Performance** | Slower (reflection) | Faster |
| **Methods** | No methods | `writeExternal()`, `readExternal()` |
| **Constructor** | Not required | Public no-arg constructor required |
| **All fields** | All non-transient | Choose what to serialize |
| **Versioning** | Automatic (UID) | Manual |

### Custom Serialization

```java
class CustomSerialization implements Serializable {
    private String data;
    private transient String computed;
    
    // Custom serialization logic
    private void writeObject(ObjectOutputStream out) throws IOException {
        out.defaultWriteObject(); // Default serialization
        out.writeUTF(computed);   // Custom field
    }
    
    private void readObject(ObjectInputStream in) throws IOException, ClassNotFoundException {
        in.defaultReadObject();   // Default deserialization
        computed = in.readUTF();  // Custom field
    }
    
    // For backward compatibility
    private void readObjectNoData() throws ObjectStreamException {
        // Called when no data in stream
        computed = "default";
    }
}
```

### Complete Example: Object CRUD with Serialization

```java
import java.io.*;
import java.util.*;

class Book implements Serializable {
    private static final long serialVersionUID = 1L;
    
    private String isbn;
    private String title;
    private String author;
    private transient double price; // Serialize qilinmaydi
    private static int totalBooks = 0;
    
    public Book(String isbn, String title, String author, double price) {
        this.isbn = isbn;
        this.title = title;
        this.author = author;
        this.price = price;
        totalBooks++;
    }
    
    // Getters and setters
    public String getIsbn() { return isbn; }
    public String getTitle() { return title; }
    public String getAuthor() { return author; }
    public double getPrice() { return price; }
    
    @Override
    public String toString() {
        return String.format("Book[%s] %s by %s - $%.2f (total: %d)", 
                           isbn, title, author, price, totalBooks);
    }
}

public class BookDatabase {
    private static final String FILE_NAME = "books.dat";
    
    // Save all books
    public static void saveBooks(List<Book> books) {
        try (ObjectOutputStream oos = new ObjectOutputStream(
                new FileOutputStream(FILE_NAME))) {
            oos.writeObject(books);
            System.out.println("Saved " + books.size() + " books");
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
    
    // Load all books
    @SuppressWarnings("unchecked")
    public static List<Book> loadBooks() {
        File file = new File(FILE_NAME);
        if (!file.exists()) {
            return new ArrayList<>();
        }
        
        try (ObjectInputStream ois = new ObjectInputStream(
                new FileInputStream(FILE_NAME))) {
            return (List<Book>) ois.readObject();
        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
            return new ArrayList<>();
        }
    }
    
    // Add a book
    public static void addBook(Book book) {
        List<Book> books = loadBooks();
        books.add(book);
        saveBooks(books);
    }
    
    // Find book by ISBN
    public static Book findByIsbn(String isbn) {
        return loadBooks().stream()
            .filter(b -> b.getIsbn().equals(isbn))
            .findFirst()
            .orElse(null);
    }
    
    // Delete book
    public static boolean deleteBook(String isbn) {
        List<Book> books = loadBooks();
        boolean removed = books.removeIf(b -> b.getIsbn().equals(isbn));
        if (removed) {
            saveBooks(books);
        }
        return removed;
    }
    
    public static void main(String[] args) {
        // Add books
        addBook(new Book("123", "Java Programming", "John Doe", 45.99));
        addBook(new Book("456", "Python Basics", "Jane Smith", 35.50));
        
        // List all books
        System.out.println("\nAll books:");
        loadBooks().forEach(System.out::println);
        
        // Find by ISBN
        System.out.println("\nFind by ISBN 123:");
        System.out.println(findByIsbn("123"));
        
        // Delete book
        System.out.println("\nDeleting ISBN 456...");
        deleteBook("456");
        
        // List after deletion
        System.out.println("\nRemaining books:");
        loadBooks().forEach(System.out::println);
    }
}
```

---

## Tekshiruv Savollari

### Lesson 7.1 - Input/Output Streams
1. **Input/Output Stream nima?**
2. **File class nima va qanday ishlatiladi?**
3. **FileInputStream va FileOutputStream classlarni tushintirib bering?**
4. **DataInputStream va DataOutputStream classlarni tushintirib bering?**
5. **FileReader va FileWriter classlari nima uchun ishlatiladi?**
6. **BufferedReader va BufferedWriter classlari nima uchun ishlatiladi?**
7. **File(Reader/Writer) va Buffered(Reader/Writer) o'rtasidagi farq?**

### Lesson 7.2 - NIO
1. **NIO nima?**
2. **NIO nima uchun Java-ni 7chi versiyasida o'zgartirishlar kiritildi?**
3. **Oddiy I/O stream bilan NIO nima farqi bor?**
4. **Path va Files classlari qanday afzalliklarga ega?**

### Lesson 7.3 - Serialization and Deserialization
1. **Serialization nima?**
2. **Deserialization nima?**
3. **Externalization nima?**
4. **Externalizable va Serializable interfacelari o'rtasidagi farq?**
5. **SerialVersionUID nima va nima uchun kerak?**
6. **Marker interface nima? Serializable shundaymi?**
7. **transient nima va qachon ishlatiladi?**
8. **static o'zgaruvchilar serialize bo'ladimi?**

---

**Keyingi mavzu:** [Java Networking](./08%20-%20Regular%20Expressions.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
