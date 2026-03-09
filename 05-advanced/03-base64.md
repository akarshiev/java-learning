# 5-Modul: Base64 Encoding and Decoding

## Base64 nima?

**Base64** - binary ma'lumotlarni matn ko'rinishiga o'tkazish sxemasi. Kiruvchi baytlarni radix-64 ko'rinishida ifodalaydi, bunda A-Z, a-z, 0-9, +, / va = belgilaridan foydalanadi.

```java
// Binary data:  [0x4D, 0x61, 0x6E] (3 bayt)
// Base64:       "TWFu" (4 belgi)
```

### Nima uchun Base64 kerak?

1. **Binary ma'lumotlarni matn orqali uzatish** - Email, JSON, XML orqali
2. **Ma'lumotlarni URL xavfsiz qilish** - URL parametrlarida ishlatish
3. **Basic authentication** - HTTP Basic Auth
4. **Ma'lumotlarni saqlash** - Ma'lumotlar bazasida binary saqlash

```java
// ✅ Yaxshi: Base64 ishlatish
String original = "Hello World";
String encoded = Base64.getEncoder().encodeToString(original.getBytes());
// "SGVsbG8gV29ybGQ="

// ❌ Yomon: Binary ma'lumotlarni to'g'ridan-to'g'ri JSON ga qo'yish
// JSON da binary ma'lumotlar buzilishi mumkin
```

---

## 5.1 - Java 8 Base64 Class

### Base64 classi

Java 8 `java.util.Base64` classi orqali Base64 encoding/decoding imkoniyatini taqdim etadi.

```java
import java.util.Base64;
import java.util.Base64.Encoder;
import java.util.Base64.Decoder;

public class Base64Example {
    public static void main(String[] args) {
        
        // 1. Encoder olish
        Encoder encoder = Base64.getEncoder();
        
        // 2. String ni encode qilish
        String original = "Hello, World!";
        String encoded = encoder.encodeToString(original.getBytes());
        System.out.println("Original: " + original);
        System.out.println("Encoded: " + encoded);
        
        // 3. Decoder olish va decode qilish
        Decoder decoder = Base64.getDecoder();
        byte[] decodedBytes = decoder.decode(encoded);
        String decoded = new String(decodedBytes);
        System.out.println("Decoded: " + decoded);
        
        // 4. Byte array bilan ishlash
        byte[] data = {0x48, 0x65, 0x6C, 0x6C, 0x6F}; // "Hello"
        String encodedData = encoder.encodeToString(data);
        byte[] decodedData = decoder.decode(encodedData);
    }
}
```

---

## 5.2 - Base64 Turlari

### 1. Basic Base64

Standart Base64 alfavitidan foydalanadi: `A-Za-z0-9+/`

```java
import java.util.Base64;

public class BasicBase64Example {
    public static void main(String[] args) {
        
        // 1. Basic encoder/decoder
        Base64.Encoder encoder = Base64.getEncoder();
        Base64.Decoder decoder = Base64.getDecoder();
        
        // 2. Oddiy matn
        String text = "Java 8 Base64";
        String encoded = encoder.encodeToString(text.getBytes());
        System.out.println("Encoded: " + encoded); // "SmF2YSA4IEJhc2U2NA=="
        
        // 3. Decode
        String decoded = new String(decoder.decode(encoded));
        System.out.println("Decoded: " + decoded); // "Java 8 Base64"
        
        // 4. Byte array
        byte[] data = {1, 2, 3, 4, 5};
        String encodedData = encoder.encodeToString(data);
        System.out.println("Bytes encoded: " + encodedData); // "AQIDBAU="
        
        // 5. Padding (=) bilan ishlash
        String withPadding = "SGVsbG8="; // "Hello"
        String withoutPadding = "SGVsbG8"; // Padding yo'q - decoder xato beradi!
        try {
            decoder.decode(withoutPadding); // IllegalArgumentException
        } catch (IllegalArgumentException e) {
            System.out.println("Error: Missing padding");
        }
    }
}
```

### 2. URL and Filename Safe Base64

URL va fayl nomlarida xavfsiz ishlatish uchun: `+` -> `-`, `/` -> `_`

```java
import java.util.Base64;

public class UrlBase64Example {
    public static void main(String[] args) {
        
        // 1. URL safe encoder
        Base64.Encoder urlEncoder = Base64.getUrlEncoder();
        Base64.Decoder urlDecoder = Base64.getUrlDecoder();
        
        // 2. Oddiy Base64 vs URL Base64
        String text = "Hello+World/How are you?";
        
        // Basic Base64
        String basicEncoded = Base64.getEncoder().encodeToString(text.getBytes());
        System.out.println("Basic: " + basicEncoded);
        // "SGVsbG8rV29ybGQvSG93IGFyZSB5b3U/"
        
        // URL Safe Base64
        String urlEncoded = urlEncoder.encodeToString(text.getBytes());
        System.out.println("URL:   " + urlEncoded);
        // "SGVsbG8rV29ybGQvSG93IGFyZSB5b3U_" (/ -> _, + unchanged)
        
        // 3. URL parametrida ishlatish
        String value = "param value with spaces & symbols";
        String safeValue = urlEncoder.encodeToString(value.getBytes());
        String url = "https://api.example.com/data?value=" + safeValue;
        System.out.println("URL: " + url);
        
        // 4. Decode
        String decoded = new String(urlDecoder.decode(safeValue));
        System.out.println("Decoded: " + decoded);
        
        // 5. Filename safe
        String filename = "my/file:name?.txt";
        String safeFilename = urlEncoder.encodeToString(filename.getBytes());
        System.out.println("Safe filename: " + safeFilename);
    }
}
```

### 3. MIME Base64

MIME (Multipurpose Internet Mail Extensions) formatiga mos keladi: har bir qator 76 belgidan oshmaydi, qator oxirida `\r\n`

```java
import java.util.Base64;

public class MimeBase64Example {
    public static void main(String[] args) {
        
        // 1. MIME encoder
        Base64.Encoder mimeEncoder = Base64.getMimeEncoder();
        Base64.Decoder mimeDecoder = Base64.getMimeDecoder();
        
        // 2. Katta ma'lumot (1000 belgi)
        StringBuilder sb = new StringBuilder();
        for (int i = 0; i < 200; i++) {
            sb.append("This is line " + i + ". ");
        }
        String longText = sb.toString();
        
        // Basic encoding (bitta qator)
        String basicEncoded = Base64.getEncoder()
            .encodeToString(longText.getBytes());
        System.out.println("Basic length: " + basicEncoded.length());
        System.out.println("Basic first 50: " + basicEncoded.substring(0, 50) + "...");
        
        // MIME encoding (76 belgili qatorlar)
        String mimeEncoded = mimeEncoder.encodeToString(longText.getBytes());
        System.out.println("\nMIME encoded:");
        String[] lines = mimeEncoded.split("\r\n");
        System.out.println("Number of lines: " + lines.length);
        System.out.println("First line (" + lines[0].length() + " chars): " + lines[0]);
        System.out.println("Second line (" + lines[1].length() + " chars): " + lines[1]);
        
        // 3. MIME decoder (qatorlarni avtomatik birlashtiradi)
        byte[] decodedBytes = mimeDecoder.decode(mimeEncoded);
        String decoded = new String(decodedBytes);
        System.out.println("\nDecoded length: " + decoded.length());
        System.out.println("Decoded equals original: " + longText.equals(decoded));
        
        // 4. Custom line length
        Base64.Encoder customMime = Base64.getMimeEncoder(50, "\n".getBytes());
        String customEncoded = customMime.encodeToString(longText.getBytes());
        System.out.println("\nCustom MIME (50 chars/line):");
        for (String line : customEncoded.split("\n")) {
            System.out.println("  " + line);
            break; // just show first line
        }
    }
}
```

---

## 5.3 - Base64 bilan ishlash usullari

### 1. String dan Base64 ga

```java
import java.util.Base64;
import java.nio.charset.StandardCharsets;

public class StringToBase64 {
    public static void main(String[] args) {
        
        // 1. String -> Base64
        String original = "Hello, Java 8!";
        
        // getBytes() default charset
        String encoded1 = Base64.getEncoder()
            .encodeToString(original.getBytes());
        
        // Specific charset
        String encoded2 = Base64.getEncoder()
            .encodeToString(original.getBytes(StandardCharsets.UTF_8));
        
        System.out.println("Original: " + original);
        System.out.println("Encoded: " + encoded1); // "SGVsbG8sIEphdmEgOCE="
        
        // 2. Base64 -> String
        byte[] decodedBytes = Base64.getDecoder().decode(encoded1);
        String decoded = new String(decodedBytes, StandardCharsets.UTF_8);
        System.out.println("Decoded: " + decoded);
        
        // 3. One-liner
        String result = new String(
            Base64.getDecoder().decode(
                Base64.getEncoder().encodeToString(
                    "Hello".getBytes()
                )
            )
        );
        System.out.println("Round trip: " + result); // "Hello"
    }
}
```

### 2. Byte array dan Base64 ga

```java
import java.util.Base64;
import java.util.Arrays;

public class ByteArrayToBase64 {
    public static void main(String[] args) {
        
        // 1. Byte array yaratish
        byte[] originalBytes = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9};
        System.out.println("Original bytes: " + Arrays.toString(originalBytes));
        
        // 2. Encode
        String encoded = Base64.getEncoder().encodeToString(originalBytes);
        System.out.println("Encoded: " + encoded); // "AAECAwQFBgcICQ=="
        
        // 3. Decode
        byte[] decodedBytes = Base64.getDecoder().decode(encoded);
        System.out.println("Decoded bytes: " + Arrays.toString(decodedBytes));
        
        // 4. Binary data (image, file) ni encode qilish
        byte[] imageBytes = getImageBytes(); // imaginary method
        String imageBase64 = Base64.getEncoder().encodeToString(imageBytes);
        
        // 5. HTML/JSON ga embed qilish
        String htmlImg = "<img src='data:image/png;base64," + imageBase64 + "'/>";
    }
    
    private static byte[] getImageBytes() {
        // Simulated image bytes
        return new byte[100];
    }
}
```

### 3. Stream bilan ishlash

```java
import java.util.Base64;
import java.io.*;

public class Base64StreamExample {
    public static void main(String[] args) throws IOException {
        
        // 1. Wrap output stream
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        OutputStream encodedStream = Base64.getEncoder().wrap(baos);
        
        encodedStream.write("Hello".getBytes());
        encodedStream.close();
        
        String encoded = baos.toString();
        System.out.println("Stream encoded: " + encoded); // "SGVsbG8="
        
        // 2. Wrap input stream
        byte[] data = "SGVsbG8=".getBytes();
        InputStream is = new ByteArrayInputStream(data);
        InputStream decodedStream = Base64.getDecoder().wrap(is);
        
        byte[] result = decodedStream.readAllBytes();
        System.out.println("Stream decoded: " + new String(result)); // "Hello"
        
        // 3. File bilan ishlash
        File inputFile = new File("input.bin");
        File outputFile = new File("output.b64");
        
        // Encode file to Base64
        try (InputStream fileIn = new FileInputStream(inputFile);
             OutputStream fileOut = new FileOutputStream(outputFile);
             OutputStream base64Out = Base64.getEncoder().wrap(fileOut)) {
            
            fileIn.transferTo(base64Out);
        }
        
        // Decode Base64 file
        try (InputStream fileIn = new FileInputStream(outputFile);
             InputStream base64In = Base64.getDecoder().wrap(fileIn);
             OutputStream fileOut = new FileOutputStream("decoded.bin")) {
            
            base64In.transferTo(fileOut);
        }
    }
}
```

---

## 5.4 - Amaliy misollar

### Misol 1: Basic Authentication

```java
import java.util.Base64;
import java.nio.charset.StandardCharsets;

public class BasicAuthExample {
    
    public static String createBasicAuthHeader(String username, String password) {
        // 1. username:password formatida birlashtirish
        String credentials = username + ":" + password;
        
        // 2. Base64 encode
        String encoded = Base64.getEncoder()
            .encodeToString(credentials.getBytes(StandardCharsets.UTF_8));
        
        // 3. "Basic " prefix qo'shish
        return "Basic " + encoded;
    }
    
    public static String[] decodeBasicAuthHeader(String authHeader) {
        // 1. "Basic " prefix ni olib tashlash
        if (!authHeader.startsWith("Basic ")) {
            throw new IllegalArgumentException("Not Basic Auth");
        }
        
        String base64Credentials = authHeader.substring(6);
        
        // 2. Base64 decode
        byte[] decodedBytes = Base64.getDecoder().decode(base64Credentials);
        String credentials = new String(decodedBytes, StandardCharsets.UTF_8);
        
        // 3. username:password ni ajratish
        return credentials.split(":", 2);
    }
    
    public static void main(String[] args) {
        String username = "admin";
        String password = "secret123";
        
        // Create header
        String authHeader = createBasicAuthHeader(username, password);
        System.out.println("Auth Header: " + authHeader);
        // "Basic YWRtaW46c2VjcmV0MTIz"
        
        // Decode header
        String[] decoded = decodeBasicAuthHeader(authHeader);
        System.out.println("Username: " + decoded[0]); // "admin"
        System.out.println("Password: " + decoded[1]); // "secret123"
        
        // HTTP request simulation
        // GET /api/data HTTP/1.1
        // Authorization: Basic YWRtaW46c2VjcmV0MTIz
    }
}
```

### Misol 2: Faylni Base64 ga o'tkazish

```java
import java.util.Base64;
import java.nio.file.*;
import java.io.IOException;

public class FileToBase64Example {
    
    // Faylni Base64 string ga o'tkazish
    public static String fileToBase64(String filePath) throws IOException {
        byte[] fileContent = Files.readAllBytes(Paths.get(filePath));
        return Base64.getEncoder().encodeToString(fileContent);
    }
    
    // Base64 string dan fayl yaratish
    public static void base64ToFile(String base64, String outputPath) 
            throws IOException {
        byte[] decodedBytes = Base64.getDecoder().decode(base64);
        Files.write(Paths.get(outputPath), decodedBytes);
    }
    
    // Katta fayllar uchun (stream)
    public static void encodeLargeFile(String inputPath, String outputPath) 
            throws IOException {
        try (InputStream in = Files.newInputStream(Paths.get(inputPath));
             OutputStream out = Files.newOutputStream(Paths.get(outputPath));
             OutputStream base64Out = Base64.getEncoder().wrap(out)) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                base64Out.write(buffer, 0, bytesRead);
            }
        }
    }
    
    public static void main(String[] args) {
        try {
            // 1. Image ni Base64 ga
            String imageBase64 = fileToBase64("profile.jpg");
            System.out.println("Image Base64 length: " + imageBase64.length());
            
            // 2. Base64 dan image yaratish
            base64ToFile(imageBase64, "profile_copy.jpg");
            
            // 3. HTML da ishlatish
            String html = "<img src='data:image/jpeg;base64," + 
                          imageBase64.substring(0, 50) + "...'/>";
            
            // 4. JSON da ishlatish
            String json = """
                {
                    "name": "John Doe",
                    "photo": "%s"
                }
                """.formatted(imageBase64);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Misol 3: JWT Token

```java
import java.util.Base64;
import java.nio.charset.StandardCharsets;

public class JWTExample {
    
    // JWT header
    static class Header {
        String alg = "HS256";
        String typ = "JWT";
        
        @Override
        public String toString() {
            return "{\"alg\":\"" + alg + "\",\"typ\":\"" + typ + "\"}";
        }
    }
    
    // JWT payload
    static class Payload {
        String sub = "1234567890";
        String name = "John Doe";
        long iat = System.currentTimeMillis() / 1000;
        
        @Override
        public String toString() {
            return "{\"sub\":\"" + sub + "\",\"name\":\"" + name + 
                   "\",\"iat\":" + iat + "}";
        }
    }
    
    // Base64 URL encode (JWT standarti)
    public static String base64UrlEncode(String input) {
        String encoded = Base64.getUrlEncoder()
            .withoutPadding()
            .encodeToString(input.getBytes(StandardCharsets.UTF_8));
        return encoded;
    }
    
    // Base64 URL decode
    public static String base64UrlDecode(String input) {
        byte[] decoded = Base64.getUrlDecoder().decode(input);
        return new String(decoded, StandardCharsets.UTF_8);
    }
    
    public static void main(String[] args) {
        // 1. Header encode
        String headerJson = new Header().toString();
        String headerEncoded = base64UrlEncode(headerJson);
        System.out.println("Header: " + headerJson);
        System.out.println("Header B64: " + headerEncoded);
        
        // 2. Payload encode
        String payloadJson = new Payload().toString();
        String payloadEncoded = base64UrlEncode(payloadJson);
        System.out.println("\nPayload: " + payloadJson);
        System.out.println("Payload B64: " + payloadEncoded);
        
        // 3. JWT token (without signature)
        String jwt = headerEncoded + "." + payloadEncoded;
        System.out.println("\nJWT: " + jwt);
        
        // 4. Decode
        String[] parts = jwt.split("\\.");
        String decodedHeader = base64UrlDecode(parts[0]);
        String decodedPayload = base64UrlDecode(parts[1]);
        
        System.out.println("\nDecoded Header: " + decodedHeader);
        System.out.println("Decoded Payload: " + decodedPayload);
    }
}
```

### Misol 4: Image Embedding

```java
import java.util.Base64;
import java.nio.file.*;
import java.io.IOException;

public class ImageEmbedExample {
    
    public static void main(String[] args) throws IOException {
        
        // 1. Image ni Base64 ga o'tkazish
        byte[] imageBytes = Files.readAllBytes(Paths.get("logo.png"));
        String base64Image = Base64.getEncoder().encodeToString(imageBytes);
        
        // 2. HTML da embed
        String html = """
            <!DOCTYPE html>
            <html>
            <head>
                <title>Base64 Image</title>
            </head>
            <body>
                <h1>Embedded Image</h1>
                <img src="data:image/png;base64,%s" 
                     alt="Logo" width="200"/>
            </body>
            </html>
            """.formatted(base64Image);
        
        Files.writeString(Paths.get("image.html"), html);
        System.out.println("HTML file created: image.html");
        
        // 3. CSS da background image
        String css = """
            .logo {
                width: 200px;
                height: 100px;
                background-image: url('data:image/png;base64,%s');
                background-size: contain;
            }
            """.formatted(base64Image);
        
        Files.writeString(Paths.get("style.css"), css);
        System.out.println("CSS file created: style.css");
        
        // 4. Markdown da rasm
        String markdown = "![Logo](data:image/png;base64," + 
                          base64Image + ")";
        Files.writeString(Paths.get("README.md"), markdown);
        System.out.println("Markdown file created: README.md");
    }
}
```

### Misol 5: Encryption bilan birga

```java
import javax.crypto.*;
import javax.crypto.spec.SecretKeySpec;
import java.security.*;
import java.util.Base64;

public class EncryptedBase64Example {
    
    private static final String ALGORITHM = "AES";
    private static final byte[] KEY = "MySecretKey12345".getBytes(); // 16 bytes
    
    public static String encryptAndEncode(String data) throws Exception {
        // 1. Encrypt
        SecretKeySpec key = new SecretKeySpec(KEY, ALGORITHM);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.ENCRYPT_MODE, key);
        byte[] encryptedBytes = cipher.doFinal(data.getBytes());
        
        // 2. Base64 encode
        return Base64.getEncoder().encodeToString(encryptedBytes);
    }
    
    public static String decodeAndDecrypt(String encryptedBase64) throws Exception {
        // 1. Base64 decode
        byte[] encryptedBytes = Base64.getDecoder().decode(encryptedBase64);
        
        // 2. Decrypt
        SecretKeySpec key = new SecretKeySpec(KEY, ALGORITHM);
        Cipher cipher = Cipher.getInstance(ALGORITHM);
        cipher.init(Cipher.DECRYPT_MODE, key);
        byte[] decryptedBytes = cipher.doFinal(encryptedBytes);
        
        return new String(decryptedBytes);
    }
    
    public static void main(String[] args) throws Exception {
        String original = "Sensitive data: Password123!";
        
        // Encrypt + Encode
        String encoded = encryptAndEncode(original);
        System.out.println("Encoded: " + encoded);
        
        // Decode + Decrypt
        String decoded = decodeAndDecrypt(encoded);
        System.out.println("Decoded: " + decoded);
    }
}
```

---

## 5.5 - Base64 Encoding/Decoding Comparison

### Encoding Turli xil turlari

| Tur | Alfavit | Padding | Qator | Ishlatilishi |
|-----|---------|---------|-------|--------------|
| **Basic** | `A-Za-z0-9+/` | `=` | Yo'q | Umumiy |
| **URL** | `A-Za-z0-9-_` | `=` | Yo'q | URL, filename |
| **MIME** | `A-Za-z0-9+/` | `=` | 76 belgi/qator | Email, multipart |

### Performance Comparison

```java
public class Base64Performance {
    public static void main(String[] args) {
        
        byte[] data = new byte[10_000_000]; // 10MB
        new Random().nextBytes(data);
        
        // Basic Base64
        long start = System.nanoTime();
        String basicEncoded = Base64.getEncoder().encodeToString(data);
        long basicTime = System.nanoTime() - start;
        
        // URL Safe Base64
        start = System.nanoTime();
        String urlEncoded = Base64.getUrlEncoder().encodeToString(data);
        long urlTime = System.nanoTime() - start;
        
        // MIME Base64
        start = System.nanoTime();
        String mimeEncoded = Base64.getMimeEncoder().encodeToString(data);
        long mimeTime = System.nanoTime() - start;
        
        System.out.printf("Basic: %.2f ms%n", basicTime / 1_000_000.0);
        System.out.printf("URL:   %.2f ms%n", urlTime / 1_000_000.0);
        System.out.printf("MIME:  %.2f ms%n", mimeTime / 1_000_000.0);
        
        // Size comparison
        System.out.println("\nEncoded sizes:");
        System.out.println("Basic length: " + basicEncoded.length());
        System.out.println("URL length:   " + urlEncoded.length());
        System.out.println("MIME length:  " + mimeEncoded.length());
    }
}
```

---

## 5.6 - Common Use Cases

### 1. HTTP Basic Authentication
```java
String auth = "username:password";
String encoded = Base64.getEncoder().encodeToString(auth.getBytes());
HttpURLConnection connection = (HttpURLConnection) url.openConnection();
connection.setRequestProperty("Authorization", "Basic " + encoded);
```

### 2. JSON Web Tokens (JWT)
```java
String header = "{\"alg\":\"HS256\"}";
String payload = "{\"sub\":\"123\"}";
String encodedHeader = Base64.getUrlEncoder().withoutPadding()
    .encodeToString(header.getBytes());
String encodedPayload = Base64.getUrlEncoder().withoutPadding()
    .encodeToString(payload.getBytes());
String jwt = encodedHeader + "." + encodedPayload + ".signature";
```

### 3. Email Attachments
```java
String base64Content = Base64.getMimeEncoder()
    .encodeToString(fileContent);
String emailContent = "Content-Type: image/jpeg; name=\"image.jpg\"\r\n" +
    "Content-Transfer-Encoding: base64\r\n" +
    "Content-Disposition: attachment\r\n\r\n" +
    base64Content;
```

### 4. Data URLs
```java
String dataUrl = "data:image/png;base64," + 
    Base64.getEncoder().encodeToString(imageBytes);
```

### 5. Database BLOB Storage
```java
String base64Data = Base64.getEncoder().encodeToString(binaryData);
preparedStatement.setString(1, base64Data); // TEXT column
```

---

## Tekshiruv Savollari

1. **Base64 nima va nima uchun ishlatiladi?**
2. **Java 8 da Base64 qanday turlari mavjud?**
3. **Basic va URL safe Base64 o'rtasidagi farq nima?**
4. **MIME Base64 qachon ishlatiladi?**
5. **Padding (=) nima uchun kerak?**
6. **Base64 encoding qanday ishlaydi?**
7. **Base64 dan foydalanishga misollar keltiring.**
8. **Base64 ning kamchiliklari qanday?**
9. **Base64 vs Hexadecimal farqi?**
10. **Java 8 dan oldin Base64 qanday ishlatilgan?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega Base64 Utility class yozing:

1. **String** ni encode/decode qilish
2. **File** ni encode/decode qilish (katta fayllar uchun stream bilan)
3. **URL safe** encoding
4. **MIME** encoding (qatorlarga ajratish)
5. **Image** ni Base64 ga va aksincha
6. **Basic Authentication** header yaratish
7. **Custom** line length bilan encoding

```java
// Misol:
Base64Util.encode("Hello");                 // "SGVsbG8="
Base64Util.encodeUrl("Hello+World");         // "SGVsbG8rV29ybGQ="
Base64Util.encodeFile("image.jpg");          // Base64 string
Base64Util.createBasicAuth("admin", "pass"); // "Basic YWRtaW46cGFzcw=="
```

---

## Xulosa

| Encoding Type | Use Case | Example |
|--------------|----------|---------|
| **Basic** | Umumiy ma'lumotlar | `Base64.getEncoder()` |
| **URL** | URL parametrlari | `Base64.getUrlEncoder()` |
| **MIME** | Email, multipart | `Base64.getMimeEncoder()` |

```java
// Quick reference
Base64.Encoder encoder = Base64.getEncoder();
Base64.Decoder decoder = Base64.getDecoder();

String encoded = encoder.encodeToString(data);
byte[] decoded = decoder.decode(encoded);
```

---

**Keyingi mavzu:** [Web Servisler](./06_Web_Services.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
