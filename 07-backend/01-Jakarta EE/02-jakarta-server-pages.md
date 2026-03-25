# 1-Modul: Jakarta Server Pages (JSP)

## 1.1 Jakarta Server Pages (JSP) Nima?

**Jakarta Server Pages (JSP)** - bu dinamik veb-sahifalar yaratish uchun mo'ljallangan framework bo'lib, u Jakarta Servlet API ustiga qurilgan va veb-dasturchilarning mahsuldorligini sezilarli darajada oshiradi.

**Oddiy qilib aytganda:** Agar Servlet Java kod ichida HTML yozish bo'lsa, JSP esa HTML ichida Java kodi yozish imkonini beradi. Bu veb-sahifalarni yaratishni ancha tabiiy va oson qiladi.

```jsp
<!-- JSP: HTML ichida Java kodi -->
<html>
<body>
    <h1>Salom, JSP!</h1>
    <p>Hozirgi vaqt: <%= new java.util.Date() %></p>
</body>
</html>
```

### JSP ning Asosiy Xususiyatlari

| Xususiyat | Tavsifi |
|-----------|---------|
| **HTML ichida Java** | HTML kodiga Java kodini qo'shish imkoniyati |
| **Avtomatik kompilyatsiya** | JSP fayllari birinchi so'rovda avtomatik servletga aylantiriladi |
| **Implicit obyektlar** | request, response, session, application kabi obyektlar tayyor holda beriladi |
| **Tag library'lar** | JSTL (Jakarta Standard Tag Library) orqali Java kodini kamaytirish |
| **MVC arxitekturasi** | View (ko'rinish) qatlami sifatida ishlatiladi |

---

## 1.2 JSP ning Hayot Sikli (Life Cycle)

JSP sahifasi birinchi marta so'ralganda quyidagi bosqichlardan o'tadi:

```
1. JSP fayli (example.jsp)
         ↓
2. Translation (JSP → Servlet)
   example.jsp → example_jsp.java
         ↓
3. Compilation (Servlet → Class)
   example_jsp.java → example_jsp.class
         ↓
4. Loading and Initialization
   jspInit() metodi chaqiriladi (bir marta)
         ↓
5. Request Handling
   _jspService() metodi chaqiriladi (har bir so'rovda)
         ↓
6. Destroy (Uchirish)
   jspDestroy() metodi chaqiriladi (bir marta)
```

**Muhim:** JSP birinchi marta so'ralganda sekinroq ishlaydi, chunki kompilyatsiya qilinadi. Keyingi so'rovlarda kompilyatsiya qilingan servlet ishlatiladi.

```java
// JSP ning servlet ko'rinishi (taxminan)
public class example_jsp extends HttpJspBase {
    
    // Bir marta chaqiriladi (JSP yuklanganda)
    public void jspInit() {
        // Initialization code
    }
    
    // Har bir so'rovda chaqiriladi
    public void _jspService(HttpServletRequest request, 
                            HttpServletResponse response) {
        // JSP dagi kod shu metodga joylashadi
    }
    
    // Bir marta chaqiriladi (JSP o'chirilganda)
    public void jspDestroy() {
        // Cleanup code
    }
}
```

---

## 1.3 JSP Elementlari

JSP uch turdagi elementlarni o'z ichiga oladi:

### A) Scripting Elements (Skript Elementlari)

#### 1. Scriptlets (Skriptlet)
`<% ... %>` - Java kod bloki. Har bir so'rovda bajariladi.

```jsp
<%
    // Bu Java kodi
    String name = request.getParameter("name");
    if (name != null && !name.isEmpty()) {
        out.println("Salom, " + name + "!");
    } else {
        out.println("Iltimos, ismingizni kiriting.");
    }
%>
```

#### 2. Expressions (Ifodalar)
`<%= ... %>` - Java ifodasining natijasini HTML ga joylashtiradi.

```jsp
<%@page import="java.util.Date"%>
<html>
<body>
    <h2>Bugungi sana:</h2>
    <p><%= new Date() %></p>
    
    <h2>2 + 3 = ?</h2>
    <p>Javob: <%= 2 + 3 %></p>
    
    <h2>So'rov parametri:</h2>
    <p>Ism: <%= request.getParameter("name") %></p>
</body>
</html>
```

#### 3. Declarations (Deklaratsiyalar)
`<%! ... %>` - Instance o'zgaruvchilar va metodlar e'lon qilish.

```jsp
<%!
    // Instance o'zgaruvchi - barcha so'rovlar uchun umumiy
    private int visitCount = 0;
    
    // Instance metod
    private String formatMessage(String msg) {
        return ">>> " + msg + " <<<";
    }
    
    // Static o'zgaruvchi
    private static int totalVisits = 0;
%>

<%
    // Har bir so'rovda bajariladi
    visitCount++;
    totalVisits++;
%>

<html>
<body>
    <p>Ushbu sahifaga tashriflar soni: <%= visitCount %></p>
    <p>Barcha sahifalarga tashriflar: <%= totalVisits %></p>
    <p><%= formatMessage("Xush kelibsiz!") %></p>
</body>
</html>
```

### B) Directive Elements (Direktiv Elementlar)

Direktiv elementlar JSP konteyneriga (Tomcat) sahifa haqida ma'lumot beradi. Javob HTML'ga chiqmaydi.

#### 1. page direktivi
`<%@page ... %>` - Sahifa xususiyatlarini belgilaydi.

```jsp
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@page import="java.util.*, java.text.*"%>
<%@page session="true"%>
<%@page errorPage="error.jsp"%>
<%@page isErrorPage="true"%>
<%@page buffer="16kb"%>
<%@page autoFlush="true"%>
<%@page isThreadSafe="true"%>

<html>
<body>
    <%
        List<String> items = new ArrayList<>();
        items.add("Olma");
        items.add("Banan");
        items.add("Gilos");
        
        for (String item : items) {
            out.println("<li>" + item + "</li>");
        }
    %>
</body>
</html>
```

**page direktivi atributlari:**

| Atribut | Tavsifi | Misol |
|---------|---------|-------|
| `import` | Import qilinadigan paket/class | `import="java.util.*"` |
| `contentType` | Javobning MIME turi | `contentType="text/html"` |
| `pageEncoding` | Sahifa kodirovkasi | `pageEncoding="UTF-8"` |
| `session` | Session mavjudligi | `session="true"` |
| `errorPage` | Xatolik sahifasi | `errorPage="error.jsp"` |
| `isErrorPage` | Xatolik sahifasi ekanligi | `isErrorPage="true"` |
| `buffer` | Chiqish buferi hajmi | `buffer="16kb"` |
| `autoFlush` | Bufer to'lganda avtomatik yozish | `autoFlush="true"` |

#### 2. include direktivi
`<%@include file="..." %>` - Boshqa faylni sahifaga qo'shadi (kompilyatsiya vaqtida).

```jsp
<!-- header.jsp -->
<header>
    <h1>Saytimga Xush Kelibsiz!</h1>
    <nav>
        <a href="index.jsp">Bosh sahifa</a> |
        <a href="about.jsp">Biz haqimizda</a> |
        <a href="contact.jsp">Aloqa</a>
    </nav>
</header>
<hr/>

<!-- footer.jsp -->
<hr/>
<footer>
    <p>&copy; 2024 Saytim. Barcha huquqlar himoyalangan.</p>
    <p>Email: info@example.com</p>
</footer>

<!-- index.jsp -->
<%@page contentType="text/html; charset=UTF-8"%>
<html>
<body>
    <%@include file="header.jsp"%>
    
    <main>
        <h2>Asosiy kontent</h2>
        <p>Bu yerda sahifaning asosiy mazmuni joylashadi.</p>
    </main>
    
    <%@include file="footer.jsp"%>
</body>
</html>
```

#### 3. taglib direktivi
`<%@taglib prefix="..." uri="..." %>` - JSTL yoki custom tag library'larini ulash.

```jsp
<%@taglib prefix="c" uri="jakarta.tags.core"%>
<%@taglib prefix="fmt" uri="jakarta.tags.fmt"%>
```

### C) Action Elements (Action Elementlar)

Action elementlar sahifa so'ralganda bajariladigan amallarni belgilaydi.

| Action | Tavsifi | Misol |
|--------|---------|-------|
| `jsp:include` | Boshqa resursni qo'shadi (so'rov vaqtida) | `<jsp:include page="header.jsp"/>` |
| `jsp:forward` | So'rovni boshqa resursga yo'naltiradi | `<jsp:forward page="login.jsp"/>` |
| `jsp:useBean` | JavaBean obyektini yaratadi yoki topadi | `<jsp:useBean id="user" class="com.User"/>` |
| `jsp:setProperty` | Bean xususiyatini o'rnatadi | `<jsp:setProperty name="user" property="name"/>` |
| `jsp:getProperty` | Bean xususiyatini oladi | `<jsp:getProperty name="user" property="name"/>` |
| `jsp:param` | Parametr qo'shadi (include/forward bilan) | `<jsp:param name="id" value="123"/>` |

```jsp
<!-- include action -->
<jsp:include page="header.jsp">
    <jsp:param name="title" value="Mening Sahifam"/>
</jsp:include>

<!-- forward action -->
<%
    String role = (String) session.getAttribute("role");
    if ("admin".equals(role)) {
%>
    <jsp:forward page="admin.jsp"/>
<% } else { %>
    <jsp:forward page="user.jsp"/>
<% } %>

<!-- useBean, setProperty, getProperty -->
<jsp:useBean id="employee" class="com.example.Employee" scope="request"/>
<jsp:setProperty name="employee" property="name" value="Ali"/>
<jsp:setProperty name="employee" property="position" value="Dasturchi"/>
<jsp:setProperty name="employee" property="salary" value="5000"/>

<p>Ism: <jsp:getProperty name="employee" property="name"/></p>
<p>Lavozim: <jsp:getProperty name="employee" property="position"/></p>
<p>Maosh: <jsp:getProperty name="employee" property="salary"/></p>
```

---

## 1.4 JSP Implicit Obyektlari

JSP sahifasida tayyor holda mavjud bo'lgan 9 ta implicit obyekt:

| Obyekt | Tipi | Tavsifi |
|--------|------|---------|
| `request` | `HttpServletRequest` | HTTP so'rovi ma'lumotlari |
| `response` | `HttpServletResponse` | HTTP javobi |
| `out` | `JspWriter` | Chiqish oqimi |
| `session` | `HttpSession` | Foydalanuvchi sessiyasi |
| `application` | `ServletContext` | Ilova konteksti |
| `config` | `ServletConfig` | Konfiguratsiya ma'lumotlari |
| `pageContext` | `PageContext` | JSP sahifa konteksti |
| `page` | `Object` | Joriy sahifa obyekti (this) |
| `exception` | `Throwable` | Xatolik obyekti (isErrorPage=true da) |

```jsp
<%@page import="java.util.*"%>
<html>
<body>
    <h2>Implicit Obyektlardan Foydalanish</h2>
    
    <h3>1. request obyekti</h3>
    <p>Metod: <%= request.getMethod() %></p>
    <p>URI: <%= request.getRequestURI() %></p>
    <p>Remote IP: <%= request.getRemoteAddr() %></p>
    
    <h3>2. session obyekti</h3>
    <%
        session.setAttribute("username", "Ali");
        session.setMaxInactiveInterval(1800); // 30 daqiqa
    %>
    <p>Session ID: <%= session.getId() %></p>
    <p>Username: <%= session.getAttribute("username") %></p>
    
    <h3>3. application obyekti</h3>
    <%
        application.setAttribute("siteName", "Mening Saytim");
        application.setAttribute("visitCount", 
            (application.getAttribute("visitCount") == null ? 
             1 : (int)application.getAttribute("visitCount") + 1));
    %>
    <p>Sayt nomi: <%= application.getAttribute("siteName") %></p>
    <p>Umumiy tashriflar: <%= application.getAttribute("visitCount") %></p>
    
    <h3>4. out obyekti</h3>
    <%
        out.println("<p>Bu out obyekti orqali yozilgan.</p>");
        out.flush();
    %>
    
    <h3>5. pageContext obyekti</h3>
    <%
        pageContext.setAttribute("temp", "Vaqtinchalik", PageContext.PAGE_SCOPE);
        pageContext.setAttribute("temp", "So'rov", PageContext.REQUEST_SCOPE);
        pageContext.setAttribute("temp", "Sessiya", PageContext.SESSION_SCOPE);
        pageContext.setAttribute("temp", "Ilova", PageContext.APPLICATION_SCOPE);
    %>
    <p>Page scope: <%= pageContext.getAttribute("temp", PageContext.PAGE_SCOPE) %></p>
    <p>Request scope: <%= pageContext.getAttribute("temp", PageContext.REQUEST_SCOPE) %></p>
    <p>Session scope: <%= pageContext.getAttribute("temp", PageContext.SESSION_SCOPE) %></p>
    <p>Application scope: <%= pageContext.getAttribute("temp", PageContext.APPLICATION_SCOPE) %></p>
    
    <h3>6. config obyekti</h3>
    <p>Servlet nomi: <%= config.getServletName() %></p>
</body>
</html>
```

---

## 1.5 Xatoliklarni Boshqarish (Error Handling)

### Xatolik Sahifasi Yaratish

```jsp
<!-- error.jsp - xatolik sahifasi -->
<%@page isErrorPage="true" contentType="text/html; charset=UTF-8"%>
<html>
<head>
    <title>Xatolik Yuz Berdi</title>
</head>
<body>
    <h1>Kechirasiz, xatolik yuz berdi!</h1>
    
    <h2>Xatolik ma'lumotlari:</h2>
    <p>Xatolik turi: <%= exception.getClass().getName() %></p>
    <p>Xatolik xabari: <%= exception.getMessage() %></p>
    
    <h3>Stack Trace:</h3>
    <pre>
    <%
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        exception.printStackTrace(pw);
        out.println(sw.toString());
    %>
    </pre>
    
    <a href="index.jsp">Bosh sahifaga qaytish</a>
</body>
</html>
```

### Xatolikni Tashlash

```jsp
<!-- calculate.jsp -->
<%@page errorPage="error.jsp"%>
<%
    String num1 = request.getParameter("num1");
    String num2 = request.getParameter("num2");
    
    if (num1 == null || num2 == null) {
        throw new Exception("Ikkala son ham kiritilishi kerak!");
    }
    
    int a = Integer.parseInt(num1);
    int b = Integer.parseInt(num2);
    
    if (b == 0) {
        throw new ArithmeticException("0 ga bo'lish mumkin emas!");
    }
    
    int result = a / b;
%>
<html>
<body>
    <p><%= a %> / <%= b %> = <%= result %></p>
</body>
</html>
```

---

## 1.6 JSP va Servlet: Dispetcher (RequestDispatcher)

### Forward (So'rovni Uzatish)

URL o'zgarmasdan, so'rovni boshqa resursga uzatadi.

```jsp
<!-- dispatcher.jsp -->
<%
    String userRole = (String) session.getAttribute("role");
    
    if (userRole == null) {
        // Login sahifasiga uzatish
        request.getRequestDispatcher("login.jsp").forward(request, response);
    } else if ("admin".equals(userRole)) {
        request.getRequestDispatcher("admin/dashboard.jsp").forward(request, response);
    } else {
        request.getRequestDispatcher("user/home.jsp").forward(request, response);
    }
%>
```

```java
// Servlet'da forward
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    protected void doPost(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        if (authenticate(username, password)) {
            request.getSession().setAttribute("user", username);
            request.getRequestDispatcher("/welcome.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Noto'g'ri username yoki parol!");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
}
```

### Redirect (Qayta Yo'naltirish)

URL o'zgaradi, yangi so'rov yuboriladi.

```jsp
<%
    // Redirect
    response.sendRedirect("https://www.example.com");
    
    // Yoki application ichida
    response.sendRedirect(request.getContextPath() + "/login.jsp");
%>
```

```java
// Servlet'da redirect
@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    protected void doGet(HttpServletRequest request, HttpServletResponse response) 
            throws ServletException, IOException {
        
        request.getSession().invalidate();
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}
```

### Forward vs Redirect

| Xususiyat | Forward | Redirect |
|-----------|---------|----------|
| **URL o'zgarishi** | Yo'q (server ichida) | Ha (client yangi so'rov yuboradi) |
| **Ma'lumot uzatish** | request obyekti saqlanadi | Yo'qoladi (yangi request) |
| **Performance** | Tezroq (bir so'rov) | Sekinroq (ikki so'rov) |
| **Qo'llanish** | MVC pattern, yetkazib berish | Login/logout, tashqi saytga o'tish |

---

## 1.7 JSP va JavaBean

### JavaBean Yaratish

```java
// com/example/User.java
package com.example;

import java.io.Serializable;

public class User implements Serializable {
    private String name;
    private int age;
    private String email;
    
    public User() {
        // Default constructor (required)
    }
    
    // Getters and Setters
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
}
```

### JSP da JavaBean Ishlatish

```jsp
<%@page import="com.example.User"%>
<html>
<body>
    <h2>JavaBean bilan ishlash</h2>
    
    <!-- 1. useBean - Bean yaratish yoki topish -->
    <jsp:useBean id="user" class="com.example.User" scope="session"/>
    
    <!-- 2. setProperty - Qiymat o'rnatish -->
    <jsp:setProperty name="user" property="name" value="Ali"/>
    <jsp:setProperty name="user" property="age" value="25"/>
    <jsp:setProperty name="user" property="email" value="ali@example.com"/>
    
    <!-- 3. getProperty - Qiymat olish -->
    <h3>Foydalanuvchi ma'lumotlari:</h3>
    <p>Ism: <jsp:getProperty name="user" property="name"/></p>
    <p>Yosh: <jsp:getProperty name="user" property="age"/></p>
    <p>Email: <jsp:getProperty name="user" property="email"/></p>
    
    <!-- 4. Request parametrlaridan o'rnatish -->
    <jsp:setProperty name="user" property="*"/>
    
    <!-- 5. Skriptlet orqali -->
    <%
        User userObj = (User) session.getAttribute("user");
        if (userObj != null) {
            out.println("<p>Sessiondagi foydalanuvchi: " + userObj.getName() + "</p>");
        }
    %>
</body>
</html>
```

---

## 1.8 To'liq Misol: Ro'yxatdan O'tish Formasi

### register.jsp (Ro'yxatdan o'tish formasi)

```jsp
<%@page contentType="text/html; charset=UTF-8"%>
<html>
<head>
    <title>Ro'yxatdan O'tish</title>
    <style>
        .error { color: red; }
        .success { color: green; }
    </style>
</head>
<body>
    <h2>Ro'yxatdan O'tish</h2>
    
    <%
        String error = (String) request.getAttribute("error");
        String success = (String) request.getAttribute("success");
        
        if (error != null) {
            out.println("<p class='error'>" + error + "</p>");
        }
        if (success != null) {
            out.println("<p class='success'>" + success + "</p>");
        }
    %>
    
    <form action="process.jsp" method="post">
        <table>
            <tr>
                <td>Ism:</td>
                <td><input type="text" name="name" required/></td>
            </tr>
            <tr>
                <td>Familiya:</td>
                <td><input type="text" name="surname" required/></td>
            </tr>
            <tr>
                <td>Email:</td>
                <td><input type="email" name="email" required/></td>
            </tr>
            <tr>
                <td>Parol:</td>
                <td><input type="password" name="password" required/></td>
            </tr>
            <tr>
                <td>Yosh:</td>
                <td><input type="number" name="age" min="18" max="100"/></td>
            </tr>
            <tr>
                <td colspan="2">
                    <input type="submit" value="Ro'yxatdan O'tish"/>
                    <input type="reset" value="Tozalash"/>
                </td>
            </tr>
        </table>
    </form>
</body>
</html>
```

### process.jsp (Ma'lumotlarni qayta ishlash)

```jsp
<%@page import="java.util.*, java.text.*"%>
<%@page errorPage="error.jsp"%>
<%
    // Parametrlarni olish
    String name = request.getParameter("name");
    String surname = request.getParameter("surname");
    String email = request.getParameter("email");
    String password = request.getParameter("password");
    String ageStr = request.getParameter("age");
    
    // Validatsiya
    if (name == null || name.trim().isEmpty()) {
        request.setAttribute("error", "Ism kiritilishi shart!");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    if (email == null || !email.contains("@")) {
        request.setAttribute("error", "Noto'g'ri email format!");
        request.getRequestDispatcher("register.jsp").forward(request, response);
        return;
    }
    
    int age = 0;
    if (ageStr != null && !ageStr.isEmpty()) {
        age = Integer.parseInt(ageStr);
        if (age < 18) {
            request.setAttribute("error", "Yosh 18 dan katta bo'lishi kerak!");
            request.getRequestDispatcher("register.jsp").forward(request, response);
            return;
        }
    }
    
    // Sessionga saqlash
    session.setAttribute("username", name + " " + surname);
    session.setAttribute("email", email);
    session.setAttribute("age", age);
    session.setAttribute("loginTime", new Date());
    
    // Muvaffaqiyatli ro'yxatdan o'tish
    request.setAttribute("success", "Muvaffaqiyatli ro'yxatdan o'tdingiz!");
    request.getRequestDispatcher("welcome.jsp").forward(request, response);
%>
```

### welcome.jsp (Xush kelibsiz sahifasi)

```jsp
<%@page import="java.util.*, java.text.*"%>
<html>
<head>
    <title>Xush Kelibsiz</title>
    <style>
        body { font-family: Arial, sans-serif; margin: 50px; }
        .info { background: #e3f2fd; padding: 20px; border-radius: 5px; }
    </style>
</head>
<body>
    <%
        String username = (String) session.getAttribute("username");
        String email = (String) session.getAttribute("email");
        Integer age = (Integer) session.getAttribute("age");
        Date loginTime = (Date) session.getAttribute("loginTime");
        
        if (username == null) {
            response.sendRedirect("register.jsp");
            return;
        }
        
        SimpleDateFormat sdf = new SimpleDateFormat("dd.MM.yyyy HH:mm:ss");
    %>
    
    <div class="info">
        <h1>Xush kelibsiz, <%= username %>!</h1>
        
        <h3>Sizning ma'lumotlaringiz:</h3>
        <ul>
            <li><strong>Email:</strong> <%= email %></li>
            <li><strong>Yosh:</strong> <%= age %></li>
            <li><strong>Ro'yxatdan o'tgan vaqt:</strong> <%= sdf.format(loginTime) %></li>
            <li><strong>Session ID:</strong> <%= session.getId() %></li>
        </ul>
        
        <h3>Session ma'lumotlari:</h3>
        <ul>
            <li><strong>Yaratilgan vaqt:</strong> <%= sdf.format(new Date(session.getCreationTime())) %></li>
            <li><strong>Oxirgi faollik:</strong> <%= sdf.format(new Date(session.getLastAccessedTime())) %></li>
        </ul>
        
        <p>
            <a href="logout.jsp">Chiqish</a> | 
            <a href="register.jsp">Yangi ro'yxatdan o'tish</a>
        </p>
    </div>
</body>
</html>
```

### logout.jsp (Chiqish sahifasi)

```jsp
<%
    session.invalidate();
    response.sendRedirect("register.jsp");
%>
```

### error.jsp (Xatolik sahifasi)

```jsp
<%@page isErrorPage="true"%>
<html>
<head>
    <title>Xatolik</title>
</head>
<body>
    <h1>Kutilmagan xatolik yuz berdi!</h1>
    
    <h3>Xatolik tafsilotlari:</h3>
    <p><strong>Xatolik turi:</strong> <%= exception.getClass().getName() %></p>
    <p><strong>Xabar:</strong> <%= exception.getMessage() %></p>
    
    <h3>Stack Trace:</h3>
    <pre>
    <%
        java.io.StringWriter sw = new java.io.StringWriter();
        java.io.PrintWriter pw = new java.io.PrintWriter(sw);
        exception.printStackTrace(pw);
        out.println(sw.toString());
    %>
    </pre>
    
    <a href="register.jsp">Bosh sahifaga qaytish</a>
</body>
</html>
```

---

## Tekshiruv Savollari

1. **JSP nima va u Servlet dan qanday farq qiladi?**
2. **JSP sahifasining hayot sikli (life cycle) qanday bosqichlardan iborat?**
3. **JSP elementlarining turlari qanday? Har birini tushuntiring.**
4. **Scriptlet, Expression va Declaration o'rtasidagi farq nima?**
5. **JSP implicit obyektlari qaysilar? Ularning vazifalarini tushuntiring.**
6. **page direktivining qanday atributlari bor? Har birini tushuntiring.**
7. **include direktiv va include action o'rtasidagi farq nima?**
8. **Forward va redirect o'rtasidagi farq nima? Qachon qaysi birini ishlatish kerak?**
9. **JSP da xatoliklarni qanday boshqarish mumkin?**
10. **JavaBean nima va JSP da qanday ishlatiladi?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega JSP ilovasini yarating:

1. **Ro'yxatdan o'tish formasi** - ism, familiya, email, parol, yosh
2. **Validatsiya** - barcha maydonlarni tekshirish, email formatini tekshirish, yoshni tekshirish
3. **Session boshqaruvi** - login qilgandan keyin ma'lumotlarni sessionda saqlash
4. **Xatolik sahifasi** - barcha xatoliklarni ushlab, chiroyli xatolik sahifasini ko'rsatish
5. **Logout** - sessionni to'xtatish

---

**Keyingi mavzu:** [JSTL, File Upload And Downloads](./03_JSTL_FileUpload.md)  
**[Mundarijaga qaytish](../README.md)**

> JSP - dinamik veb-sahifalar yaratishning asosiy texnologiyasi. Uni o'rganish orqali veb-ilovalarning view (ko'rinish) qatlamini yaratishni o'rganasiz. 🚀
