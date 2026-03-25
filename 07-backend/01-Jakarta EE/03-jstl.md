# 1-Modul: JSTL, File Upload va Downloads

## 1.1 Jakarta Expression Language (EL)

### EL nima?

**Jakarta Expression Language (EL)** - bu Jakarta EE veb-ilovalarida JSP sahifalariga Java kodini kiritmasdan, ma'lumotlarni chiqarish va ifodalarni hisoblash uchun ishlatiladigan maxsus dasturlash tili.

**Oddiy qilib aytganda:** EL `<%= ... %>` o'rniga `${...}` sintaksisini ishlatish imkonini beradi, bu esa JSP sahifalarini tozalaydi va o'qishni osonlashtiradi.

```jsp
<!-- Skriptlet bilan (eski usul) -->
<%= request.getAttribute("username") %>

<!-- EL bilan (yangi, toza usul) -->
${username}
```

### EL Sintaksisi

EL ifodalari `${...}` yoki `#{...}` bilan yoziladi:

- `${...}` - darhol hisoblanadi (immediate evaluation)
- `#{...}` - kechiktirilgan hisoblanadi (deferred evaluation, JSF da ishlatiladi)

```jsp
<%@page contentType="text/html; charset=UTF-8"%>
<html>
<head>
    <title>EL Misollar</title>
</head>
<body>
    <h2>EL (Expression Language) Misollari</h2>
    
    <h3>1. Oddiy ifodalar</h3>
    <ul>
        <li>${1 + 2} = ${1 + 2}</li>
        <li>${10 / 2} = ${10 / 2}</li>
        <li>${10 > 5} = ${10 > 5}</li>
        <li>${'Hello' == 'Hello'} = ${'Hello' == 'Hello'}</li>
        <li>${empty name} = ${empty name}</li>
    </ul>
    
    <h3>2. Scope bo'yicha ma'lumotlarni olish</h3>
    <%
        // Java kodida ma'lumotlarni o'rnatish
        pageContext.setAttribute("pageVar", "Page Scope");
        request.setAttribute("reqVar", "Request Scope");
        session.setAttribute("sessionVar", "Session Scope");
        application.setAttribute("appVar", "Application Scope");
    %>
    <ul>
        <li>Page Scope: ${pageVar}</li>
        <li>Request Scope: ${reqVar}</li>
        <li>Session Scope: ${sessionVar}</li>
        <li>Application Scope: ${appVar}</li>
        <li>Aniq scope: ${requestScope.reqVar}</li>
        <li>Aniq scope: ${sessionScope.sessionVar}</li>
    </ul>
    
    <h3>3. Ob'ekt xususiyatlariga murojaat</h3>
    <%
        class Person {
            private String name;
            private int age;
            public Person(String name, int age) {
                this.name = name; this.age = age;
            }
            public String getName() { return name; }
            public int getAge() { return age; }
        }
        request.setAttribute("person", new Person("Ali", 25));
    %>
    <ul>
        <li>Ism: ${person.name}</li>
        <li>Yosh: ${person.age}</li>
    </ul>
    
    <h3>4. Map va List bilan ishlash</h3>
    <%
        java.util.Map<String, String> map = new java.util.HashMap<>();
        map.put("uz", "O'zbek");
        map.put("ru", "Rus");
        request.setAttribute("langMap", map);
        
        String[] colors = {"Qizil", "Yashil", "Ko'k"};
        request.setAttribute("colors", colors);
    %>
    <ul>
        <li>UZ: ${langMap.uz}</li>
        <li>RU: ${langMap.ru}</li>
        <li>Birinchi rang: ${colors[0]}</li>
        <li>Ikkinchi rang: ${colors[1]}</li>
    </ul>
    
    <h3>5. Parametrlarni olish</h3>
    <p>name parametri: ${param.name}</p>
    <p>age parametri: ${param.age}</p>
    <p>Barcha parametrlar: ${paramValues}</p>
    
    <h3>6. Header ma'lumotlari</h3>
    <p>User-Agent: ${header['User-Agent']}</p>
    <p>Host: ${header.host}</p>
    
    <h3>7. Cookie ma'lumotlari</h3>
    <p>JSESSIONID: ${cookie.JSESSIONID.value}</p>
</body>
</html>
```

### EL Operatorlari

| Operator | Tavsifi | Misol | Natija |
|----------|---------|-------|-------|
| `+` | Qo'shish | `${5 + 3}` | 8 |
| `-` | Ayirish | `${5 - 3}` | 2 |
| `*` | Ko'paytirish | `${5 * 3}` | 15 |
| `/` yoki `div` | Bo'lish | `${10 / 2}` | 5 |
| `%` yoki `mod` | Qoldiq | `${10 % 3}` | 1 |
| `==` yoki `eq` | Tenglik | `${5 == 5}` | true |
| `!=` yoki `ne` | Teng emas | `${5 != 3}` | true |
| `<` yoki `lt` | Kichik | `${3 < 5}` | true |
| `>` yoki `gt` | Katta | `${5 > 3}` | true |
| `<=` yoki `le` | Kichik yoki teng | `${3 <= 5}` | true |
| `>=` yoki `ge` | Katta yoki teng | `${5 >= 5}` | true |
| `&&` yoki `and` | VA (AND) | `${true && false}` | false |
| `\|\|` yoki `or` | YOKI (OR) | `${true \|\| false}` | true |
| `!` yoki `not` | INKOR (NOT) | `${!true}` | false |
| `empty` | Bo'sh yoki yo'qligi | `${empty name}` | true/false |
| `?:` | Ternary | `${age >= 18 ? 'Katta' : 'Kichik'}` | - |

### EL Implicit Obyektlari

| Obyekt | Tavsifi | Misol |
|--------|---------|-------|
| `pageScope` | Page scope ma'lumotlar | `${pageScope.var}` |
| `requestScope` | Request scope ma'lumotlar | `${requestScope.var}` |
| `sessionScope` | Session scope ma'lumotlar | `${sessionScope.var}` |
| `applicationScope` | Application scope ma'lumotlar | `${applicationScope.var}` |
| `param` | Request parametrlari | `${param.name}` |
| `paramValues` | Request parametrlari massivi | `${paramValues.hobby[0]}` |
| `header` | HTTP headerlar | `${header['User-Agent']}` |
| `headerValues` | HTTP headerlar massivi | `${headerValues}` |
| `cookie` | Cookie'lar | `${cookie.JSESSIONID.value}` |
| `initParam` | Context init parametrlari | `${initParam.appName}` |
| `pageContext` | PageContext obyekti | `${pageContext.request.contextPath}` |

---

## 1.2 JSTL (Jakarta Standard Tag Library)

### JSTL nima?

**JSTL (Jakarta Standard Tag Library)** - JSP sahifalarida umumiy vazifalarni bajarish uchun standart tag (teglar) to'plami. JSTL yordamida Java kodini (scriptlet) sezilarli darajada kamaytirish mumkin.

### JSTL O'rnatish

Maven dependency:

```xml
<dependency>
    <groupId>jakarta.servlet.jsp.jstl</groupId>
    <artifactId>jakarta.servlet.jsp.jstl-api</artifactId>
    <version>3.0.0</version>
</dependency>
<dependency>
    <groupId>org.glassfish.web</groupId>
    <artifactId>jakarta.servlet.jsp.jstl</artifactId>
    <version>3.0.1</version>
</dependency>
```

JSP da taglib'ni ulash:

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="x" uri="jakarta.tags.xml" %>
```

### A) Core Tags (Asosiy teglar)

#### 1. `<c:out>` - Qiymatni chiqarish

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<c:set var="username" value="Ali" scope="session"/>
<c:set var="html" value="<b>Qalin matn</b>"/>

<!-- Oddiy chiqarish -->
Ism: <c:out value="${username}"/><br/>

<!-- Default qiymat bilan -->
<c:out value="${notExist}" default="Mavjud emas"/><br/>

<!-- Escape XML (default: true) -->
<c:out value="${html}" escapeXml="true"/><br/>
<c:out value="${html}" escapeXml="false"/>
```

#### 2. `<c:set>` - O'zgaruvchi o'rnatish

```jsp
<!-- Scope'da o'zgaruvchi o'rnatish -->
<c:set var="counter" value="0" scope="page"/>
<c:set var="user" value="Ali" scope="session"/>

<!-- Ob'ekt xususiyatini o'rnatish -->
<jsp:useBean id="person" class="com.example.Person"/>
<c:set target="${person}" property="name" value="Vali"/>
<c:set target="${person}" property="age" value="25"/>

<!-- Body orqali o'rnatish -->
<c:set var="message">
    Bu ko'p qatorli
    matn bo'lishi mumkin
</c:set>
```

#### 3. `<c:remove>` - O'zgaruvchini o'chirish

```jsp
<c:remove var="username" scope="session"/>
```

#### 4. `<c:if>` - Shartli tekshirish

```jsp
<c:set var="age" value="20"/>

<c:if test="${age >= 18}">
    <p>Siz kattasiz!</p>
</c:if>

<c:if test="${age < 18}">
    <p>Siz hali yoshsiz!</p>
</c:if>
```

#### 5. `<c:choose>`, `<c:when>`, `<c:otherwise>` - Ko'p shartli

```jsp
<c:set var="score" value="85"/>

<c:choose>
    <c:when test="${score >= 90}">
        <p>Baholangiz: A'lo (5)</p>
    </c:when>
    <c:when test="${score >= 80}">
        <p>Baholangiz: Yaxshi (4)</p>
    </c:when>
    <c:when test="${score >= 70}">
        <p>Baholangiz: Qoniqarli (3)</p>
    </c:when>
    <c:otherwise>
        <p>Baholangiz: Qoniqarsiz (2)</p>
    </c:otherwise>
</c:choose>
```

#### 6. `<c:forEach>` - Takrorlash (loop)

```jsp
<!-- 1. Oddiy loop -->
<c:forEach var="i" begin="1" end="10" step="1">
    ${i} 
</c:forEach>

<!-- 2. List bo'ylab loop -->
<%
    List<String> names = Arrays.asList("Ali", "Vali", "Soli");
    request.setAttribute("names", names);
%>
<ul>
<c:forEach var="name" items="${names}" varStatus="status">
    <li>${status.index + 1}. ${name}</li>
</c:forEach>
</ul>

<!-- 3. Map bo'ylab loop -->
<%
    Map<String, String> countries = new HashMap<>();
    countries.put("uz", "O'zbekiston");
    countries.put("ru", "Rossiya");
    countries.put("us", "AQSh");
    request.setAttribute("countries", countries);
%>
<c:forEach var="entry" items="${countries}">
    <p>${entry.key}: ${entry.value}</p>
</c:forEach>

<!-- 4. varStatus atributlari -->
<c:forEach var="item" items="${names}" varStatus="status">
    <p>
        Index: ${status.index} | 
        Count: ${status.count} | 
        First: ${status.first} | 
        Last: ${status.last} |
        Current: ${status.current}
    </p>
</c:forEach>
```

#### 7. `<c:forTokens>` - String ni ajratib takrorlash

```jsp
<c:set var="colors" value="qizil,yashil,ko'k,sariq"/>

<c:forTokens items="${colors}" delims="," var="color">
    <p>Rang: ${color}</p>
</c:forTokens>
```

#### 8. `<c:url>` - URL yaratish

```jsp
<!-- Oddiy URL -->
<c:url value="/user/profile.jsp" var="profileUrl">
    <c:param name="id" value="123"/>
    <c:param name="action" value="view"/>
</c:url>
<a href="${profileUrl}">Profilni ko'rish</a>

<!-- Context path bilan -->
<c:url value="/images/logo.png" var="logoUrl"/>
<img src="${logoUrl}" alt="Logo"/>
```

#### 9. `<c:redirect>` - Qayta yo'naltirish

```jsp
<c:redirect url="/login.jsp">
    <c:param name="error" value="session_expired"/>
</c:redirect>
```

#### 10. `<c:catch>` - Exception tutish

```jsp
<c:catch var="exception">
    <%
        int result = 10 / 0;
    %>
</c:catch>

<c:if test="${not empty exception}">
    <p style="color:red;">Xatolik: ${exception.message}</p>
</c:if>
```

### B) Formatting Tags (Formatlash teglari)

#### `<fmt:formatNumber>` - Sonlarni formatlash

```jsp
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>

<!-- Oddiy son -->
<fmt:formatNumber value="1234567.89" type="number"/><br/>
<fmt:formatNumber value="1234567.89" type="currency"/><br/>
<fmt:formatNumber value="0.75" type="percent"/><br/>

<!-- Pattern bilan -->
<fmt:formatNumber value="1234567.89" pattern="#,###.00"/><br/>
<fmt:formatNumber value="1234567.89" pattern="$#,##0.00"/><br/>
<fmt:formatNumber value="0.75" pattern="#0%"/><br/>
```

#### `<fmt:parseNumber>` - String ni songa o'tkazish

```jsp
<fmt:parseNumber var="num" value="1,234.56" type="number"/>
Son: ${num}<br/>

<fmt:parseNumber var="price" value="$1,234.56" type="currency"/>
Narx: ${price}
```

#### `<fmt:formatDate>` - Sanani formatlash

```jsp
<jsp:useBean id="now" class="java.util.Date"/>

<!-- Type bo'yicha -->
<fmt:formatDate value="${now}" type="date"/><br/>
<fmt:formatDate value="${now}" type="time"/><br/>
<fmt:formatDate value="${now}" type="both"/><br/>

<!-- Date style -->
<fmt:formatDate value="${now}" type="date" dateStyle="full"/><br/>
<fmt:formatDate value="${now}" type="date" dateStyle="long"/><br/>
<fmt:formatDate value="${now}" type="date" dateStyle="medium"/><br/>
<fmt:formatDate value="${now}" type="date" dateStyle="short"/><br/>

<!-- Pattern bilan -->
<fmt:formatDate value="${now}" pattern="dd.MM.yyyy HH:mm:ss"/><br/>
<fmt:formatDate value="${now}" pattern="EEEE, d MMMM yyyy"/>
```

#### `<fmt:parseDate>` - String ni sanaga o'tkazish

```jsp
<fmt:parseDate var="date" value="25.12.2024" pattern="dd.MM.yyyy"/>
Sana: ${date}
```

#### `<fmt:setLocale>` - Locale o'rnatish

```jsp
<fmt:setLocale value="uz_UZ"/>
<fmt:formatNumber value="1234567.89" type="currency"/><br/>

<fmt:setLocale value="en_US"/>
<fmt:formatNumber value="1234567.89" type="currency"/><br/>

<fmt:setLocale value="ru_RU"/>
<fmt:formatNumber value="1234567.89" type="currency"/>
```

#### `<fmt:setBundle>` va `<fmt:message>` - Internasionalizatsiya

```properties
# messages_uz.properties
greeting=Salom
welcome=Xush kelibsiz, {0}
```

```jsp
<fmt:setBundle basename="messages" var="lang"/>
<fmt:message key="greeting" bundle="${lang}"/><br/>
<fmt:message key="welcome" bundle="${lang}">
    <fmt:param value="Ali"/>
</fmt:message>
```

### C) Function Tags (Funksiya teglari)

```jsp
<%@ taglib prefix="fn" uri="jakarta.tags.functions" %>

<c:set var="text" value="   Hello, JSTL!   "/>
<c:set var="words" value="apple,banana,orange"/>
<c:set var="html" value="<p>Hello</p>"/>

<ul>
    <li>Uzunlik: ${fn:length(text)}</li>
    <li>Katta harflar: ${fn:toUpperCase(text)}</li>
    <li>Kichik harflar: ${fn:toLowerCase(text)}</li>
    <li>Trim: ${fn:trim(text)}</li>
    <li>Contains 'JSTL': ${fn:contains(text, 'JSTL')}</li>
    <li>Starts with 'Hello': ${fn:startsWith(text, 'Hello')}</li>
    <li>Ends with '!': ${fn:endsWith(text, '!')}</li>
    <li>Index of 'JSTL': ${fn:indexOf(text, 'JSTL')}</li>
    <li>Replace: ${fn:replace(text, 'JSTL', 'Java')}</li>
    <li>Substring: ${fn:substring(text, 5, 10)}</li>
    <li>Split: ${fn:split(words, ',')[0]}</li>
    <li>Join: ${fn:join(fn:split(words, ','), ' - ')}</li>
    <li>Escape XML: ${fn:escapeXml(html)}</li>
</ul>
```

---

## 1.3 File Upload va Download

### Servlet 3.0+ File Upload

#### MultipartConfig Annotation

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,      // 1MB - xotiraga yozish chegarasi
    maxFileSize = 1024 * 1024 * 5,        // 5MB - bitta fayl maksimal hajmi
    maxRequestSize = 1024 * 1024 * 5 * 5, // 25MB - umumiy so'rov hajmi
    location = "/tmp/uploads"             // Vaqtinchalik saqlash joyi
)
public class FileUploadServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Upload papkasini yaratish
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        // Barcha fayl qismlarini olish
        for (Part part : request.getParts()) {
            String fileName = extractFileName(part);
            
            if (fileName != null && !fileName.isEmpty()) {
                String filePath = uploadPath + File.separator + fileName;
                part.write(filePath);
                
                // Fayl haqida ma'lumot
                System.out.println("Fayl nomi: " + fileName);
                System.out.println("Fayl hajmi: " + part.getSize());
                System.out.println("Content type: " + part.getContentType());
                
                request.setAttribute("message", "Fayl muvaffaqiyatli yuklandi: " + fileName);
                request.setAttribute("fileName", fileName);
                request.setAttribute("fileSize", part.getSize());
            }
        }
        
        request.getRequestDispatcher("upload.jsp").forward(request, response);
    }
    
    private String extractFileName(Part part) {
        String contentDisposition = part.getHeader("content-disposition");
        for (String token : contentDisposition.split(";")) {
            if (token.trim().startsWith("filename")) {
                return token.substring(token.indexOf("=") + 2, token.length() - 1);
            }
        }
        return null;
    }
}
```

### Web.xml da MultipartConfig

```xml
<servlet>
    <servlet-name>FileUploadServlet</servlet-name>
    <servlet-class>com.example.FileUploadServlet</servlet-class>
    <multipart-config>
        <location>/tmp/uploads</location>
        <max-file-size>5242880</max-file-size>      <!-- 5MB -->
        <max-request-size>26214400</max-request-size> <!-- 25MB -->
        <file-size-threshold>1048576</file-size-threshold> <!-- 1MB -->
    </multipart-config>
</servlet>
<servlet-mapping>
    <servlet-name>FileUploadServlet</servlet-name>
    <url-pattern>/upload</url-pattern>
</servlet-mapping>
```

### Upload Formasi

```jsp
<!-- upload.jsp -->
<%@page contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>File Upload</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        .container { max-width: 500px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; }
        .message { padding: 10px; margin: 10px 0; border-radius: 3px; }
        .success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
        .error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        input[type="file"] { margin: 10px 0; }
        input[type="submit"] { background: #007bff; color: white; padding: 10px 20px; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <div class="container">
        <h2>Fayl Yuklash</h2>
        
        <%
            String message = (String) request.getAttribute("message");
            String fileName = (String) request.getAttribute("fileName");
            Long fileSize = (Long) request.getAttribute("fileSize");
            
            if (message != null) {
        %>
            <div class="message success">
                <strong>✅ ${message}</strong><br/>
                Fayl nomi: ${fileName}<br/>
                Fayl hajmi: ${fileSize} bayt
            </div>
        <%
            }
        %>
        
        <form action="upload" method="post" enctype="multipart/form-data">
            <label>Fayl tanlang:</label><br/>
            <input type="file" name="file" required/><br/><br/>
            
            <label>Qo'shimcha ma'lumot:</label><br/>
            <input type="text" name="description" placeholder="Fayl tavsifi"/><br/><br/>
            
            <input type="submit" value="Yuklash"/>
        </form>
        
        <p><a href="download?file=">Yuklangan fayllar ro'yxati</a></p>
    </div>
</body>
</html>
```

### File Download Servlet

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;

@WebServlet("/download")
public class FileDownloadServlet extends HttpServlet {
    
    private static final String UPLOAD_DIR = "uploads";
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String fileName = request.getParameter("file");
        
        if (fileName == null || fileName.isEmpty()) {
            // Fayllar ro'yxatini ko'rsatish
            showFileList(request, response);
            return;
        }
        
        // Xavfsizlik: fayl yo'lini tekshirish
        fileName = Paths.get(fileName).getFileName().toString();
        
        String filePath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR 
                         + File.separator + fileName;
        File file = new File(filePath);
        
        if (!file.exists()) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
            return;
        }
        
        // MIME turini aniqlash
        String mimeType = getServletContext().getMimeType(filePath);
        if (mimeType == null) {
            mimeType = "application/octet-stream";
        }
        
        // Response headerlarini o'rnatish
        response.setContentType(mimeType);
        response.setContentLength((int) file.length());
        response.setHeader("Content-Disposition", "attachment; filename=\"" + fileName + "\"");
        
        // Faylni o'qish va yozish
        try (InputStream in = new FileInputStream(file);
             OutputStream out = response.getOutputStream()) {
            
            byte[] buffer = new byte[8192];
            int bytesRead;
            while ((bytesRead = in.read(buffer)) != -1) {
                out.write(buffer, 0, bytesRead);
            }
        }
    }
    
    private void showFileList(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String uploadPath = getServletContext().getRealPath("") + File.separator + UPLOAD_DIR;
        File uploadDir = new File(uploadPath);
        
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        File[] files = uploadDir.listFiles();
        request.setAttribute("files", files);
        request.getRequestDispatcher("filelist.jsp").forward(request, response);
    }
}
```

### Fayllar Ro'yxati Sahifasi

```jsp
<!-- filelist.jsp -->
<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html>
<head>
    <title>Yuklangan Fayllar</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        table { border-collapse: collapse; width: 100%; }
        th, td { border: 1px solid #ddd; padding: 8px; text-align: left; }
        th { background-color: #f2f2f2; }
        tr:hover { background-color: #f5f5f5; }
        .download { color: #007bff; text-decoration: none; }
        .download:hover { text-decoration: underline; }
        .size { text-align: right; }
    </style>
</head>
<body>
    <h2>Yuklangan Fayllar</h2>
    
    <c:if test="${empty files}">
        <p>Hali hech qanday fayl yuklanmagan.</p>
    </c:if>
    
    <c:if test="${not empty files}">
        <table>
            <thead>
                <tr>
                    <th>№</th>
                    <th>Fayl nomi</th>
                    <th>Hajmi</th>
                    <th>Oxirgi o'zgartirilgan</th>
                    <th>Amal</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="file" items="${files}" varStatus="status">
                    <c:if test="${file.isFile()}">
                        <tr>
                            <td>${status.count}</td>
                            <td>${file.name}</td>
                            <td class="size">
                                <fmt:formatNumber value="${file.length() / 1024}" pattern="#,##0.00"/> KB
                            </td>
                            <td>
                                <fmt:formatDate value="<%= new java.util.Date(file.lastModified()) %>" 
                                    pattern="dd.MM.yyyy HH:mm:ss"/>
                            </td>
                            <td>
                                <a href="download?file=${file.name}" class="download">Yuklab olish</a>
                            </td>
                        </tr>
                    </c:if>
                </c:forEach>
            </tbody>
        </table>
    </c:if>
    
    <p><a href="upload.jsp">Yangi fayl yuklash</a></p>
</body>
</html>
```

---

## To'liq Misol: Profile Image Upload

### ProfileUploadServlet

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;
import java.nio.file.*;
import java.util.UUID;

@WebServlet("/profile/upload")
@MultipartConfig(
    fileSizeThreshold = 1024 * 1024,
    maxFileSize = 1024 * 1024 * 2,    // 2MB
    maxRequestSize = 1024 * 1024 * 4   // 4MB
)
public class ProfileUploadServlet extends HttpServlet {
    
    private static final String PROFILE_DIR = "profiles";
    private static final String[] ALLOWED_TYPES = {"image/jpeg", "image/png", "image/gif"};
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userId = (String) session.getAttribute("userId");
        
        if (userId == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        Part filePart = request.getPart("profileImage");
        
        if (filePart == null || filePart.getSize() == 0) {
            session.setAttribute("uploadError", "Iltimos, rasm tanlang!");
            response.sendRedirect(request.getContextPath() + "/profile.jsp");
            return;
        }
        
        // MIME turini tekshirish
        String contentType = filePart.getContentType();
        boolean isValidType = false;
        for (String allowed : ALLOWED_TYPES) {
            if (allowed.equals(contentType)) {
                isValidType = true;
                break;
            }
        }
        
        if (!isValidType) {
            session.setAttribute("uploadError", "Faqat JPEG, PNG yoki GIF formatdagi rasmlar qabul qilinadi!");
            response.sendRedirect(request.getContextPath() + "/profile.jsp");
            return;
        }
        
        // Fayl nomini generatsiya qilish
        String extension = "";
        if (contentType.equals("image/jpeg")) extension = ".jpg";
        else if (contentType.equals("image/png")) extension = ".png";
        else if (contentType.equals("image/gif")) extension = ".gif";
        
        String fileName = userId + "_" + UUID.randomUUID().toString() + extension;
        
        // Profil papkasini yaratish
        String uploadPath = getServletContext().getRealPath("") + File.separator + PROFILE_DIR;
        File uploadDir = new File(uploadPath);
        if (!uploadDir.exists()) {
            uploadDir.mkdir();
        }
        
        // Faylni saqlash
        String filePath = uploadPath + File.separator + fileName;
        filePart.write(filePath);
        
        // Oldingi rasmni o'chirish
        String oldImage = (String) session.getAttribute("profileImage");
        if (oldImage != null) {
            File oldFile = new File(uploadPath + File.separator + oldImage);
            if (oldFile.exists()) {
                oldFile.delete();
            }
        }
        
        // Sessionga saqlash
        session.setAttribute("profileImage", fileName);
        session.setAttribute("uploadSuccess", "Rasm muvaffaqiyatli yangilandi!");
        
        response.sendRedirect(request.getContextPath() + "/profile.jsp");
    }
}
```

### Profile Sahifasi

```jsp
<!-- profile.jsp -->
<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Profilim</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        .profile { max-width: 500px; margin: auto; text-align: center; }
        .avatar { width: 150px; height: 150px; border-radius: 50%; object-fit: cover; margin-bottom: 20px; }
        .message { padding: 10px; margin: 10px 0; border-radius: 3px; }
        .success { background: #d4edda; color: #155724; }
        .error { background: #f8d7da; color: #721c24; }
        input[type="file"] { margin: 10px 0; }
        button { background: #007bff; color: white; padding: 10px 20px; border: none; cursor: pointer; }
    </style>
</head>
<body>
    <div class="profile">
        <h2>Mening Profilim</h2>
        
        <c:if test="${not empty sessionScope.uploadSuccess}">
            <div class="message success">${sessionScope.uploadSuccess}</div>
            <c:remove var="uploadSuccess" scope="session"/>
        </c:if>
        
        <c:if test="${not empty sessionScope.uploadError}">
            <div class="message error">${sessionScope.uploadError}</div>
            <c:remove var="uploadError" scope="session"/>
        </c:if>
        
        <c:choose>
            <c:when test="${not empty sessionScope.profileImage}">
                <img src="${pageContext.request.contextPath}/profiles/${sessionScope.profileImage}" 
                     class="avatar" alt="Profile Image"/>
            </c:when>
            <c:otherwise>
                <img src="${pageContext.request.contextPath}/images/default-avatar.png" 
                     class="avatar" alt="Default Avatar"/>
            </c:otherwise>
        </c:choose>
        
        <form action="${pageContext.request.contextPath}/profile/upload" 
              method="post" enctype="multipart/form-data">
            <input type="file" name="profileImage" accept="image/*" required/>
            <br/>
            <button type="submit">Rasmni yangilash</button>
        </form>
        
        <p><a href="${pageContext.request.contextPath}/">Bosh sahifaga qaytish</a></p>
    </div>
</body>
</html>
```

---

## Tekshiruv Savollari

1. **Expression Language (EL) nima va u qanday afzalliklarga ega?**
2. **EL implicit obyektlari qaysilar? Har birini tushuntiring.**
3. **JSTL nima va u qanday vazifalarni bajaradi?**
4. **JSTL core tags qaysi teglardan iborat?**
5. **`<c:forEach>` va `<c:forTokens>` o'rtasidagi farq nima?**
6. **`<c:choose>`, `<c:when>`, `<c:otherwise>` qanday ishlaydi?**
7. **`<fmt:formatNumber>` va `<fmt:formatDate>` qanday ishlatiladi?**
8. **`${}` va `#{}` o'rtasidagi farq nima?**
9. **File upload qanday amalga oshiriladi?**
10. **@MultipartConfig annotation'ining atributlari qanday?**
11. **File download qanday amalga oshiriladi?**
12. **File upload va download da xavfsizlik masalalari qanday?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega ilova yarating:

1. **Fayl yuklash formasi** - bir nechta faylni bir vaqtda yuklash imkoniyati
2. **Fayl turlarini cheklash** - faqat rasm, PDF, DOC fayllar qabul qilinsin
3. **Fayl hajmini cheklash** - har bir fayl 5MB dan oshmasin
4. **Yuklangan fayllar ro'yxati** - jadval ko'rinishida, yuklab olish va o'chirish tugmalari bilan
5. **Fayllarni qidirish** - nomi bo'yicha qidirish imkoniyati
6. **Kategoriyalar** - rasm, hujjat, arxiv kabi kategoriyalarga ajratish

---

**Keyingi mavzu:** [JDBC With Jakarta EE](./04_JDBC.md)  
**[Mundarijaga qaytish](../README.md)**

> JSTL va EL - JSP sahifalarini tozalaydi va o'qishni osonlashtiradi. File upload/download esa veb-ilovalarda fayl bilan ishlashning asosidir. 🚀
