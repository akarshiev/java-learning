# 13 - HTTP Client (Java 11+)

## HTTP Client nima?

**HTTP Client** - Java dasturi orqali tashqi servislarga (API'larga) so'rov yuborish va javob olish imkonini beruvchi vosita.

Oddiy misol: Bank.uz dan valyuta kursini olish:

Application (sizning dasturingiz) ---**(HTTP Request)**---> Bank.uz API (tashqi service)

Application <---**(HTTP Response)**--- Bank.uz API

Tasavvur qiling, sizda ob-havo ma'lumotlarini ko'rsatadigan ilova bor. Bu ilova har safar tashqi ob-havo servisiga so'rov yuborib, ma'lumotlarni oladi. Aynan shu so'rovlarni yuborish uchun HTTP Client kerak.

---

## Nima uchun HTTP Client kerak?

1. **Tashqi API'lar bilan ishlash** - Bank, ob-havo, to'lov tizimlari
2. **Mikroservislar** - Servislar o'rtasida ma'lumot almashish
3. **Ma'lumotlarni sinxronlash** - Boshqa serverlardan ma'lumot olish
4. **Integratsiya** - Turli tizimlarni birlashtirish

```java
// ❌ Eski usul (Java 11 dan oldin) - URLConnection
URL url = new URL("http://api.example.com/data");
HttpURLConnection conn = (HttpURLConnection) url.openConnection();
conn.setRequestMethod("GET");
conn.setRequestProperty("Accept", "application/json");
// ... ko'p kod, murakkab

// ✅ Yangi usul (Java 11+) - HTTP Client
HttpClient client = HttpClient.newHttpClient();
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("http://api.example.com/data"))
    .build();
HttpResponse<String> response = client.send(request, HttpResponse.BodyHandlers.ofString());
```

---

## 13.1 - HTTP Client arxitekturasi

### Asosiy komponentlar

```
┌─────────────────────────────────────────────────┐
│                  HttpClient                      │
│  (sozlamalar: timeout, redirect, authenticator)  │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│                  HttpRequest                     │
│  (method: GET/POST/PUT/DELETE, headers, body)   │
└─────────────────────┬───────────────────────────┘
                      │
┌─────────────────────▼───────────────────────────┐
│                 HttpResponse                     │
│  (status code, headers, body)                    │
└─────────────────────────────────────────────────┘
```

### 1. HttpClient - konfiguratsiya

```java
HttpClient client = HttpClient.newBuilder()
    .version(HttpClient.Version.HTTP_2)        // HTTP/2 ishlatish
    .followRedirects(HttpClient.Redirect.NORMAL) // Redirectlarni kuzatish
    .connectTimeout(Duration.ofSeconds(10))    // Ulanish vaqti
    .authenticator(new Authenticator() {        // Autentifikatsiya
        @Override
        protected PasswordAuthentication getPasswordAuthentication() {
            return new PasswordAuthentication("user", "password".toCharArray());
        }
    })
    .build();
```

### 2. HttpRequest - so'rov

```java
HttpRequest request = HttpRequest.newBuilder()
    .uri(URI.create("http://localhost:8080/api/data"))
    .header("Content-Type", "application/json")
    .header("Accept", "application/json")
    .timeout(Duration.ofSeconds(5))
    .GET()  // yoki POST(), PUT(), DELETE()
    .build();
```

### 3. HttpResponse - javob

```java
HttpResponse<String> response = client.send(request, 
    HttpResponse.BodyHandlers.ofString());

int statusCode = response.statusCode();  // 200, 404, 500
String body = response.body();            // Javob tanasi
HttpHeaders headers = response.headers(); // Javob sarlavhalari
```

---

## 13.2 - So'rov turlari (HTTP Methods)

### GET - Ma'lumot o'qish

```java
public class GetExample {
    public static void main(String[] args) throws Exception {
        // 1. HttpClient yaratish
        HttpClient client = HttpClient.newHttpClient();
        
        // 2. So'rov yaratish
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/current-time"))
            .GET()
            .build();
        
        // 3. So'rov yuborish (sinxron)
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        // 4. Javobni o'qish
        System.out.println("Status code: " + response.statusCode());
        System.out.println("Response body: " + response.body());
        System.out.println("Version: " + response.version());
        
        // 5. Barcha postlarni olish
        HttpRequest postsRequest = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/posts/"))
            .header("Accept", "application/json")
            .GET()
            .build();
        
        HttpResponse<String> postsResponse = client.send(postsRequest, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Posts: " + postsResponse.body());
    }
}
```

### POST - Ma'lumot yaratish

```java
import com.google.gson.Gson;

public class PostExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        
        // 1. Yangi post yaratish
        Post newPost = new Post();
        newPost.setTitle("Java HTTP Client");
        newPost.setBody("This is a post about HTTP Client in Java 11+");
        
        // 2. JSON ga o'tkazish
        Gson gson = new Gson();
        String json = gson.toJson(newPost);
        
        // 3. POST so'rov yaratish
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/post/create/"))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(json))
            .build();
        
        // 4. So'rov yuborish
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Status: " + response.statusCode());
        System.out.println("Created post: " + response.body());
    }
}
```

### PUT - Ma'lumot yangilash

```java
public class PutExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newBuilder().authenticator(new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("user", "password".toCharArray());
            }}).build();

        // Yangilangan ma'lumot
        Post updatedPost = new Post();
        updatedPost.setId(UUID.fromString("7f1af8f7-1192-4ca3-b9df-25fc660c874f"));
        updatedPost.setTitle("Updated Title");
        updatedPost.setBody("Updated body content");
        
        Gson gson = new Gson();
        String json = gson.toJson(updatedPost);
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/post/update/"))
            .header("Content-Type", "application/json")
            .PUT(HttpRequest.BodyPublishers.ofString(json))
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            System.out.println("Post updated successfully");
        } else {
            System.out.println("Failed to update: " + response.statusCode());
        }
    }
}
```

### DELETE - Ma'lumot o'chirish

```java
public class DeleteExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        
        String postId = "7f1af8f7-1192-4ca3-b9df-25fc660c874f";
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/post/delete/" + postId))
            .header("Content-Type", "application/json")
            .DELETE()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            System.out.println("Post deleted successfully");
        } else if (response.statusCode() == 404) {
            System.out.println("Post not found");
        } else {
            System.out.println("Error: " + response.statusCode());
        }
    }
}
```

---

## 13.3 - BodyPublisher turlari

BodyPublisher - so'rov bilan birga yuboriladigan ma'lumotni tayyorlaydi.

```java
public class BodyPublisherExamples {
    public static void main(String[] args) {
        
        // 1. String dan
        HttpRequest.BodyPublisher stringPublisher = 
            HttpRequest.BodyPublishers.ofString("{\"name\":\"John\"}");
        
        // 2. Byte array dan
        byte[] bytes = "Hello".getBytes();
        HttpRequest.BodyPublisher bytePublisher = 
            HttpRequest.BodyPublishers.ofByteArray(bytes);
        
        // 3. Fayldan
        Path filePath = Path.of("data.json");
        HttpRequest.BodyPublisher filePublisher = 
            HttpRequest.BodyPublishers.ofFile(filePath);
        
        // 4. InputStream dan
        InputStream inputStream = new ByteArrayInputStream(bytes);
        HttpRequest.BodyPublisher streamPublisher = 
            HttpRequest.BodyPublishers.ofInputStream(() -> inputStream);
        
        // 5. Bo'sh body
        HttpRequest.BodyPublisher emptyPublisher = 
            HttpRequest.BodyPublishers.noBody();  // DELETE uchun
    }
}
```

---

## 13.4 - Asinxron so'rovlar (sendAsync)

Sinxron so'rovlarda dastur javob kelguncha bloklanadi. Asinxron so'rovlarda esa boshqa ishlarni bajarishda davom etadi.

```java
import java.util.concurrent.CompletableFuture;

public class AsyncExample {
    public static void main(String[] args) {
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/current-time"))
            .GET()
            .build();
        
        // Asinxron so'rov - dastur bloklanmaydi
        CompletableFuture<HttpResponse<String>> future = 
            client.sendAsync(request, HttpResponse.BodyHandlers.ofString());
        
        // Boshqa ishlarni bajarish
        System.out.println("So'rov yuborildi, javob kutilmoqda...");
        
        // Javob kelganda nima qilish kerak
        future.thenAccept(response -> {
            System.out.println("Status: " + response.statusCode());
            System.out.println("Body: " + response.body());
        });
        
        // Bir necha parallel so'rov
        List<HttpRequest> requests = Arrays.asList(
            HttpRequest.newBuilder().uri(URI.create("http://localhost:8080/current-time")).build(),
            HttpRequest.newBuilder().uri(URI.create("http://localhost:8080/posts/")).build()
        );
        
        List<CompletableFuture<HttpResponse<String>>> futures = requests.stream()
            .map(req -> client.sendAsync(req, HttpResponse.BodyHandlers.ofString()))
            .toList();
        
        // Hammasi tugashini kutish
        CompletableFuture.allOf(futures.toArray(new CompletableFuture[0]))
            .thenAccept(v -> {
                futures.forEach(f -> {
                    HttpResponse<String> resp = f.join();
                    System.out.println(resp.body());
                });
            });
        
        // Asosiy thread uxlab qolmasligi uchun
        Thread.sleep(5000);
    }
}
```

---

## 13.5 - Timeout sozlash

Timeout - so'rovni qancha vaqt kutish kerakligini belgilaydi.

```java
public class TimeoutExample {
    public static void main(String[] args) {
        
        // 1. Ulanish vaqti (connect timeout)
        HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(5))
            .build();
        
        // 2. So'rov vaqti (request timeout)
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/timeout/request/"))
            .timeout(Duration.ofSeconds(2))
            .GET()
            .build();
        
        try {
            HttpResponse<String> response = client.send(request, 
                HttpResponse.BodyHandlers.ofString());
            System.out.println("Response: " + response.body());
        } catch (HttpTimeoutException e) {
            System.out.println("Timeout! Server javob bermadi");
        } catch (IOException | InterruptedException e) {
            e.printStackTrace();
        }
    }
}
```

---

## 13.6 - Autentifikatsiya

Ba'zi API'lar foydalanuvchi nomi va parol talab qiladi.

### 1. Authenticator bilan

```java
public class AuthenticatorExample {
    public static void main(String[] args) throws Exception {
        
        // Authenticator yaratish
        Authenticator authenticator = new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication("user", "password".toCharArray());
            }
        };
        
        HttpClient client = HttpClient.newBuilder()
            .authenticator(authenticator)
            .build();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/post/delete/123"))
            .DELETE()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Status: " + response.statusCode());
    }
}
```

### 2. Header bilan (Basic Auth)

```java
public class BasicAuthExample {
    public static void main(String[] args) throws Exception {
        
        // Basic Authentication header yaratish
        String username = "user";
        String password = "password";
        String auth = username + ":" + password;
        String encodedAuth = Base64.getEncoder().encodeToString(auth.getBytes());
        
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/post/delete/123"))
            .header("Authorization", "Basic " + encodedAuth)
            .DELETE()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            System.out.println("Deleted successfully");
        } else if (response.statusCode() == 401) {
            System.out.println("Unauthorized - wrong credentials");
        }
    }
}
```

### 3. Token bilan (Bearer Auth)

```java
public class TokenAuthExample {
    public static void main(String[] args) throws Exception {
        
        String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...";
        
        HttpClient client = HttpClient.newHttpClient();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/protected/data"))
            .header("Authorization", "Bearer " + token)
            .GET()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Response: " + response.body());
    }
}
```

---

## 13.7 - HTTP versiyalari

### HTTP/1.1 vs HTTP/2

```java
public class HttpVersionExample {
    public static void main(String[] args) throws Exception {
        
        // HTTP/2 so'rash (agar server qo'llab-quvvatlasa)
        HttpClient http2Client = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_2)
            .build();
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/current-time"))
            .GET()
            .build();
        
        HttpResponse<String> response = http2Client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Requested version: HTTP_2");
        System.out.println("Actual version: " + response.version());
        
        // Agar server HTTP/2 qo'llab-quvvatlamasa, avtomatik HTTP/1.1 ga tushadi
        // HTTPS bo'lmasa, HTTP/2 ishlamaydi (ko'p hollarda)
        
        // HTTP/1.1 majburiy
        HttpClient http1Client = HttpClient.newBuilder()
            .version(HttpClient.Version.HTTP_1_1)
            .build();
        
        response = http1Client.send(request, HttpResponse.BodyHandlers.ofString());
        System.out.println("Version: " + response.version()); // HTTP_1_1
    }
}
```

### HTTP versiyalari farqi

| Xususiyat | HTTP/1.1 | HTTP/2 | HTTP/3 |
|-----------|----------|--------|--------|
| **Asos** | TCP | TCP | QUIC (UDP) |
| **Multipleks** | Yo'q | Ha | Ha |
| **Header compression** | Yo'q | HPACK | QPACK |
| **Server push** | Yo'q | Ha | Ha |
| **TLS majburiy?** | Yo'q | Ha | Ha |
| **Yili** | 1997 | 2015 | 2022 |

---

## 13.8 - HTTP Status kodlari

Status kodlari server javobining holatini ko'rsatadi.

```java
public class StatusCodeHandler {
    
    public static void handleResponse(HttpResponse<String> response) {
        int statusCode = response.statusCode();
        
        if (statusCode >= 200 && statusCode < 300) {
            // 2xx - Muvaffaqiyatli
            switch (statusCode) {
                case 200 -> System.out.println("OK - So'rov muvaffaqiyatli");
                case 201 -> System.out.println("Created - Yangi resurs yaratildi");
                case 204 -> System.out.println("No Content - Javob yo'q");
                default -> System.out.println("Success: " + statusCode);
            }
            System.out.println("Body: " + response.body());
            
        } else if (statusCode >= 300 && statusCode < 400) {
            // 3xx - Redirection
            System.out.println("Redirected to: " + response.headers().firstValue("Location").orElse("unknown"));
            
        } else if (statusCode >= 400 && statusCode < 500) {
            // 4xx - Client error
            switch (statusCode) {
                case 400 -> System.out.println("Bad Request - So'rov noto'g'ri");
                case 401 -> System.out.println("Unauthorized - Autentifikatsiya kerak");
                case 403 -> System.out.println("Forbidden - Ruxsat yo'q");
                case 404 -> System.out.println("Not Found - Resurs topilmadi");
                case 408 -> System.out.println("Request Timeout - Vaqt tugadi");
                case 429 -> System.out.println("Too Many Requests - Ko'p so'rov");
                default -> System.out.println("Client Error: " + statusCode);
            }
            
        } else if (statusCode >= 500 && statusCode < 600) {
            // 5xx - Server error
            switch (statusCode) {
                case 500 -> System.out.println("Internal Server Error");
                case 502 -> System.out.println("Bad Gateway");
                case 503 -> System.out.println("Service Unavailable");
                case 504 -> System.out.println("Gateway Timeout");
                default -> System.out.println("Server Error: " + statusCode);
            }
        }
    }
}
```

---

## 13.9 - Amaliy misollar

### Misol 1: REST Client

```java
import com.google.gson.*;
import java.net.URI;
import java.net.http.*;
import java.util.List;

public class RestClient {
    private final HttpClient client;
    private final Gson gson;
    private final String baseUrl;
    
    public RestClient(String baseUrl) {
        this.client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(10))
            .build();
        this.gson = new Gson();
        this.baseUrl = baseUrl;
    }
    
    // GET - hamma postlarni olish
    public List<Post> getAllPosts() throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/posts/"))
            .header("Accept", "application/json")
            .GET()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            Type listType = new TypeToken<List<Post>>(){}.getType();
            return gson.fromJson(response.body(), listType);
        } else {
            throw new RuntimeException("Failed to get posts: " + response.statusCode());
        }
    }
    
    // GET - bitta postni olish
    public Post getPost(String id) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/posts/" + id))
            .header("Accept", "application/json")
            .GET()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            return gson.fromJson(response.body(), Post.class);
        } else if (response.statusCode() == 404) {
            return null;
        } else {
            throw new RuntimeException("Error: " + response.statusCode());
        }
    }
    
    // POST - yangi post yaratish
    public Post createPost(Post post) throws Exception {
        String json = gson.toJson(post);
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/post/create/"))
            .header("Content-Type", "application/json")
            .POST(HttpRequest.BodyPublishers.ofString(json))
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 201 || response.statusCode() == 200) {
            return gson.fromJson(response.body(), Post.class);
        } else {
            throw new RuntimeException("Failed to create post: " + response.statusCode());
        }
    }
    
    // PUT - postni yangilash
    public Post updatePost(Post post) throws Exception {
        String json = gson.toJson(post);
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/post/update/"))
            .header("Content-Type", "application/json")
            .header("Authorization", getBasicAuth())
            .PUT(HttpRequest.BodyPublishers.ofString(json))
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        if (response.statusCode() == 200) {
            return gson.fromJson(response.body(), Post.class);
        } else {
            throw new RuntimeException("Failed to update: " + response.statusCode());
        }
    }
    
    // DELETE - postni o'chirish
    public boolean deletePost(String id) throws Exception {
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create(baseUrl + "/post/delete/" + id))
            .header("Authorization", getBasicAuth())
            .DELETE()
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        return response.statusCode() == 200;
    }
    
    private String getBasicAuth() {
        String auth = "user:password";
        String encoded = Base64.getEncoder().encodeToString(auth.getBytes());
        return "Basic " + encoded;
    }
    
    public static void main(String[] args) throws Exception {
        RestClient client = new RestClient("http://localhost:8080");
        
        // 1. Hozirgi vaqtni olish
        HttpRequest timeRequest = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/current-time"))
            .GET()
            .build();
        
        HttpResponse<String> timeResponse = client.client.send(timeRequest, 
            HttpResponse.BodyHandlers.ofString());
        System.out.println("Current time: " + timeResponse.body());
        
        // 2. Barcha postlarni olish
        List<Post> posts = client.getAllPosts();
        System.out.println("Total posts: " + posts.size());
        
        // 3. Yangi post yaratish
        Post newPost = new Post();
        newPost.setTitle("HTTP Client Tutorial");
        newPost.setBody("Learning Java HTTP Client");
        
        Post created = client.createPost(newPost);
        System.out.println("Created post with ID: " + created.getId());
        
        // 4. Postni o'chirish
        boolean deleted = client.deletePost(created.getId().toString());
        System.out.println("Deleted: " + deleted);
    }
}
```

### Misol 2: File upload

```java
public class FileUploadExample {
    public static void main(String[] args) throws Exception {
        HttpClient client = HttpClient.newHttpClient();
        
        // Faylni o'qish
        Path filePath = Path.of("test.txt");
        byte[] fileBytes = Files.readAllBytes(filePath);
        
        // Multi-part form data yaratish (oddiy usul)
        String boundary = "---" + System.currentTimeMillis() + "---";
        String lineSeparator = "\r\n";
        
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        byteArrayOutputStream.write(("--" + boundary + lineSeparator).getBytes());
        byteArrayOutputStream.write(("Content-Disposition: form-data; name=\"file\"; filename=\"" + 
            filePath.getFileName() + "\"" + lineSeparator).getBytes());
        byteArrayOutputStream.write(("Content-Type: application/octet-stream" + lineSeparator + lineSeparator).getBytes());
        byteArrayOutputStream.write(fileBytes);
        byteArrayOutputStream.write((lineSeparator + "--" + boundary + "--" + lineSeparator).getBytes());
        
        HttpRequest request = HttpRequest.newBuilder()
            .uri(URI.create("http://localhost:8080/file/upload/?file=" + filePath.getFileName()))
            .header("Content-Type", "multipart/form-data; boundary=" + boundary)
            .POST(HttpRequest.BodyPublishers.ofByteArray(byteArrayOutputStream.toByteArray()))
            .build();
        
        HttpResponse<String> response = client.send(request, 
            HttpResponse.BodyHandlers.ofString());
        
        System.out.println("Upload status: " + response.statusCode());
        System.out.println("Response: " + response.body());
    }
}
```

---

## HTTP Client Cheat Sheet

```java
// 1. HttpClient yaratish
HttpClient client = HttpClient.newHttpClient();

// 2. GET so'rov
HttpRequest getRequest = HttpRequest.newBuilder()
    .uri(URI.create("http://localhost:8080/api/data"))
    .header("Accept", "application/json")
    .GET()
    .build();

// 3. POST so'rov (JSON)
String json = "{\"name\":\"John\"}";
HttpRequest postRequest = HttpRequest.newBuilder()
    .uri(URI.create("http://localhost:8080/api/create"))
    .header("Content-Type", "application/json")
    .POST(HttpRequest.BodyPublishers.ofString(json))
    .build();

// 4. So'rov yuborish (sinxron)
HttpResponse<String> response = client.send(request, 
    HttpResponse.BodyHandlers.ofString());

// 5. So'rov yuborish (asinxron)
CompletableFuture<HttpResponse<String>> future = 
    client.sendAsync(request, HttpResponse.BodyHandlers.ofString());

// 6. Basic Auth
String auth = "user:pass";
String encoded = Base64.getEncoder().encodeToString(auth.getBytes());
HttpRequest authRequest = HttpRequest.newBuilder()
    .header("Authorization", "Basic " + encoded)
    .build();
```

---

## Tekshiruv Savollari

1. **HTTP Client nima va nima uchun kerak?**
2. **HttpClient, HttpRequest va HttpResponse o'rtasidagi munosabat qanday?**
3. **GET, POST, PUT, DELETE metodlari qachon ishlatiladi?**
4. **Sinxron va asinxron so'rovlar farqi nima?**
5. **Timeout nima va qanday sozlanadi?**
6. **HTTP status kodlari qanday guruhlarga bo'linadi?**
7. **Basic authentication qanday ishlaydi?**
8. **HTTP/2 va HTTP/1.1 farqi nima?**
9. **BodyPublisher nima va qanday turlari bor?**
10. **send() va sendAsync() farqi nima?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega HTTP Client dasturini yozing:

1. **GET** - /posts/ dan barcha postlarni olish
2. **POST** - /post/create/ ga yangi post yaratish
3. **PUT** - /post/update/ da postni yangilash
4. **DELETE** - /post/delete/{id} orqali postni o'chirish
5. **Async** - parallel so'rovlar yuborish
6. **Auth** - Basic authentication bilan ishlash
7. **Timeout** - 2 sekundlik timeout bilan ishlash

---

**Keyingi mavzu:** [Microservices Overview](./11-gson.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
