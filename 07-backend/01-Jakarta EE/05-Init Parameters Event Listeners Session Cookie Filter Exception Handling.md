# 1-Modul: Init Parameters, Event Listeners, Session, Cookie, Filter va Exception Handling

## 1.1 Initialization Parameters (Init Parametrlar)

### Init Parametrlar nima?

Init parametrlar - servlet yoki kontekst ishga tushganda bir marta o'qiladigan konfiguratsiya parametrlaridir. Ular kodni o'zgartirmasdan sozlamalarni o'zgartirish imkonini beradi.

### A) Servlet Init Parameters

Servlet init parametrlari - faqat bitta servlet uchun amal qiladi.

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

// 1. Annotation bilan
@WebServlet(
    name = "UserServlet",
    urlPatterns = {"/user"},
    initParams = {
        @WebInitParam(name = "defaultRole", value = "USER"),
        @WebInitParam(name = "pageSize", value = "10"),
        @WebInitParam(name = "uploadPath", value = "/uploads")
    }
)
public class UserServlet extends HttpServlet {
    
    private String defaultRole;
    private int pageSize;
    private String uploadPath;
    
    @Override
    public void init() throws ServletException {
        // Init parametrlarni olish
        ServletConfig config = getServletConfig();
        
        defaultRole = config.getInitParameter("defaultRole");
        pageSize = Integer.parseInt(config.getInitParameter("pageSize"));
        uploadPath = config.getInitParameter("uploadPath");
        
        System.out.println("UserServlet init params:");
        System.out.println("  defaultRole: " + defaultRole);
        System.out.println("  pageSize: " + pageSize);
        System.out.println("  uploadPath: " + uploadPath);
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Servlet Init Parameters</h2>");
        out.println("<p>Default Role: " + defaultRole + "</p>");
        out.println("<p>Page Size: " + pageSize + "</p>");
        out.println("<p>Upload Path: " + uploadPath + "</p>");
        
        // Barcha init parametrlarni ko'rish
        out.println("<h3>All Init Parameters:</h3>");
        ServletConfig config = getServletConfig();
        java.util.Enumeration<String> names = config.getInitParameterNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            out.println("<p>" + name + " = " + config.getInitParameter(name) + "</p>");
        }
    }
}
```

### B) Context Init Parameters

Context init parametrlari - butun application uchun amal qiladi.

```java
// web.xml da konfiguratsiya
/*
<web-app>
    <context-param>
        <param-name>appName</param-name>
        <param-value>My Jakarta EE App</param-value>
    </context-param>
    <context-param>
        <param-name>adminEmail</param-name>
        <param-value>admin@example.com</param-value>
    </context-param>
    <context-param>
        <param-name>maxUploadSize</param-name>
        <param-value>10485760</param-value>
    </context-param>
</web-app>
*/

@WebServlet("/config")
public class ConfigServlet extends HttpServlet {
    
    private String appName;
    private String adminEmail;
    private int maxUploadSize;
    
    @Override
    public void init() throws ServletException {
        ServletContext context = getServletContext();
        
        appName = context.getInitParameter("appName");
        adminEmail = context.getInitParameter("adminEmail");
        maxUploadSize = Integer.parseInt(context.getInitParameter("maxUploadSize"));
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Application Configuration</h2>");
        out.println("<p>App Name: " + appName + "</p>");
        out.println("<p>Admin Email: " + adminEmail + "</p>");
        out.println("<p>Max Upload Size: " + maxUploadSize + " bytes</p>");
    }
}
```

### C) web.xml da Konfiguratsiya

```xml
<?xml version="1.0" encoding="UTF-8"?>
<web-app xmlns="https://jakarta.ee/xml/ns/jakartaee"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="https://jakarta.ee/xml/ns/jakartaee 
         https://jakarta.ee/xml/ns/jakartaee/web-app_6_0.xsd"
         version="6.0">
    
    <!-- Context params -->
    <context-param>
        <param-name>appName</param-name>
        <param-value>My Jakarta EE Application</param-value>
    </context-param>
    <context-param>
        <param-name>appVersion</param-name>
        <param-value>1.0.0</param-value>
    </context-param>
    
    <!-- Servlet with init params -->
    <servlet>
        <servlet-name>UserServlet</servlet-name>
        <servlet-class>com.example.UserServlet</servlet-class>
        <init-param>
            <param-name>defaultRole</param-name>
            <param-value>USER</param-value>
        </init-param>
        <init-param>
            <param-name>pageSize</param-name>
            <param-value>20</param-value>
        </init-param>
    </servlet>
    <servlet-mapping>
        <servlet-name>UserServlet</servlet-name>
        <url-pattern>/user/*</url-pattern>
    </servlet-mapping>
    
</web-app>
```

---

## 1.2 Event Listeners (Hodisa Kuzatuvchilar)

### ServletContextListener - Application Hayot Siklini Kuzatish

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;

@WebListener
public class AppLifecycleListener implements ServletContextListener {
    
    @Override
    public void contextInitialized(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        
        System.out.println("=== Application Starting ===");
        System.out.println("App Name: " + context.getInitParameter("appName"));
        System.out.println("Server Info: " + context.getServerInfo());
        System.out.println("Context Path: " + context.getContextPath());
        
        // Application startda ishga tushiriladigan vazifalar
        // - Ma'lumotlar bazasiga ulanish
        // - Konfiguratsiyani yuklash
        // - Background thread'larni ishga tushirish
        // - Cache'ni to'ldirish
        
        context.setAttribute("startupTime", System.currentTimeMillis());
        context.setAttribute("isApplicationReady", true);
    }
    
    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        ServletContext context = sce.getServletContext();
        
        System.out.println("=== Application Shutting Down ===");
        
        // Application shutdown da bajariladigan vazifalar
        // - Ma'lumotlar bazasi ulanishini yopish
        // - Thread'larni to'xtatish
        // - Cache'ni flush qilish
        // - Log yozish
        
        context.setAttribute("isApplicationReady", false);
    }
}
```

### HttpSessionListener - Session Hayot Siklini Kuzatish

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.util.concurrent.atomic.AtomicInteger;

@WebListener
public class SessionCounterListener implements HttpSessionListener {
    
    private final AtomicInteger activeSessions = new AtomicInteger(0);
    
    @Override
    public void sessionCreated(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        int count = activeSessions.incrementAndGet();
        
        System.out.println("Session created: " + session.getId());
        System.out.println("Active sessions: " + count);
        
        // Session'ga ma'lumot qo'shish
        session.setAttribute("creationTime", System.currentTimeMillis());
        session.setAttribute("userAgent", "Not set yet");
    }
    
    @Override
    public void sessionDestroyed(HttpSessionEvent se) {
        HttpSession session = se.getSession();
        int count = activeSessions.decrementAndGet();
        
        System.out.println("Session destroyed: " + session.getId());
        System.out.println("Active sessions: " + count);
        
        // Session o'chirilganda bajariladigan vazifalar
        // - User logout ma'lumotlarini saqlash
        // - Resurslarni tozalash
    }
    
    public int getActiveSessionsCount() {
        return activeSessions.get();
    }
}

// Session'ni kuzatish uchun servlet
@WebServlet("/session-stats")
public class SessionStatsServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        ServletContext context = getServletContext();
        
        // SessionCounterListener'ga erishish
        SessionCounterListener listener = (SessionCounterListener) 
            context.getAttribute("sessionCounterListener");
        
        if (listener == null) {
            // Listener'ni context'ga saqlash
            listener = new SessionCounterListener();
            context.setAttribute("sessionCounterListener", listener);
        }
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Session Statistics</h2>");
        out.println("<p>Your Session ID: " + session.getId() + "</p>");
        out.println("<p>Session Creation Time: " + 
                   new java.util.Date(session.getCreationTime()) + "</p>");
        out.println("<p>Active Sessions: " + listener.getActiveSessionsCount() + "</p>");
        out.println("<p>Total Active Sessions (from listener): " + 
                   listener.getActiveSessionsCount() + "</p>");
    }
}
```

### ServletContextAttributeListener - Attribute O'zgarishlarini Kuzatish

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;

@WebListener
public class AttributeChangeListener implements ServletContextAttributeListener {
    
    @Override
    public void attributeAdded(ServletContextAttributeEvent event) {
        String name = event.getName();
        Object value = event.getValue();
        
        System.out.println("Attribute Added: " + name + " = " + value);
        
        // Muhim attribute'lar qo'shilganda maxsus ishlov berish
        if ("databaseConnection".equals(name)) {
            System.out.println("Database connection established!");
        }
    }
    
    @Override
    public void attributeRemoved(ServletContextAttributeEvent event) {
        String name = event.getName();
        Object value = event.getValue();
        
        System.out.println("Attribute Removed: " + name + " = " + value);
    }
    
    @Override
    public void attributeReplaced(ServletContextAttributeEvent event) {
        String name = event.getName();
        Object oldValue = event.getValue();
        Object newValue = event.getServletContext().getAttribute(name);
        
        System.out.println("Attribute Replaced: " + name);
        System.out.println("  Old: " + oldValue);
        System.out.println("  New: " + newValue);
    }
}
```

### HttpSessionAttributeListener - Session Attribute O'zgarishlarini Kuzatish

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;

@WebListener
public class SessionAttributeListener implements HttpSessionAttributeListener {
    
    @Override
    public void attributeAdded(HttpSessionBindingEvent event) {
        HttpSession session = event.getSession();
        String name = event.getName();
        Object value = event.getValue();
        
        System.out.println("Session Attribute Added: " + name + " = " + value);
        System.out.println("  Session ID: " + session.getId());
        
        // User login'ni kuzatish
        if ("user".equals(name)) {
            System.out.println("User logged in: " + value);
            // Login event'ini log qilish
            // Audit ma'lumotlarini saqlash
        }
    }
    
    @Override
    public void attributeRemoved(HttpSessionBindingEvent event) {
        String name = event.getName();
        Object value = event.getValue();
        
        System.out.println("Session Attribute Removed: " + name + " = " + value);
        
        if ("user".equals(name)) {
            System.out.println("User logged out: " + value);
        }
    }
    
    @Override
    public void attributeReplaced(HttpSessionBindingEvent event) {
        HttpSession session = event.getSession();
        String name = event.getName();
        Object oldValue = event.getValue();
        Object newValue = session.getAttribute(name);
        
        System.out.println("Session Attribute Replaced: " + name);
        System.out.println("  Old: " + oldValue);
        System.out.println("  New: " + newValue);
    }
}
```

---

## 1.3 Session Management

### Session nima?

Session - bir foydalanuvchining bir nechta so'rovlari davomida ma'lumotlarni saqlash mexanizmi.

```java
@WebServlet("/session-demo")
public class SessionDemoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Session olish (agar mavjud bo'lmasa yaratadi)
        HttpSession session = request.getSession();
        
        // Session ID
        String sessionId = session.getId();
        
        // Session yaratilgan vaqt
        long creationTime = session.getCreationTime();
        
        // Oxirgi kirish vaqti
        long lastAccessedTime = session.getLastAccessedTime();
        
        // Session vaqti (sekundlarda)
        int maxInactiveInterval = session.getMaxInactiveInterval();
        
        // Yangi sessionmi?
        boolean isNew = session.isNew();
        
        // Session'ga ma'lumot qo'shish
        session.setAttribute("username", "Ali");
        session.setAttribute("role", "USER");
        session.setAttribute("loginTime", new java.util.Date());
        
        // Ma'lumot olish
        String username = (String) session.getAttribute("username");
        
        // Ma'lumot o'chirish
        session.removeAttribute("tempData");
        
        // Session'ni invalidate qilish (logout)
        // session.invalidate();
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Session Information</h2>");
        out.println("<p>Session ID: " + sessionId + "</p>");
        out.println("<p>Creation Time: " + new java.util.Date(creationTime) + "</p>");
        out.println("<p>Last Accessed: " + new java.util.Date(lastAccessedTime) + "</p>");
        out.println("<p>Max Inactive Interval: " + maxInactiveInterval + " seconds</p>");
        out.println("<p>Is New Session: " + isNew + "</p>");
        out.println("<p>Username: " + username + "</p>");
        out.println("<p>Role: " + session.getAttribute("role") + "</p>");
        
        // Barcha session attribute'lar
        out.println("<h3>All Session Attributes:</h3>");
        java.util.Enumeration<String> names = session.getAttributeNames();
        while (names.hasMoreElements()) {
            String name = names.nextElement();
            out.println("<p>" + name + " = " + session.getAttribute(name) + "</p>");
        }
    }
}
```

### Login/Logout Misoli

```java
@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        
        // Autentifikatsiya logikasi
        if (authenticate(username, password)) {
            // Session yaratish
            HttpSession session = request.getSession();
            
            // Foydalanuvchi ma'lumotlarini session'ga saqlash
            session.setAttribute("user", username);
            session.setAttribute("role", getUserRole(username));
            session.setAttribute("loginTime", new java.util.Date());
            
            // Login log'ini yozish
            log("User logged in: " + username);
            
            // Muvaffaqiyatli login
            response.sendRedirect(request.getContextPath() + "/dashboard");
            
        } else {
            // Login xatosi
            request.setAttribute("error", "Invalid username or password");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    private boolean authenticate(String username, String password) {
        // Ma'lumotlar bazasidan tekshirish
        return "admin".equals(username) && "admin123".equals(password);
    }
    
    private String getUserRole(String username) {
        if ("admin".equals(username)) return "ADMIN";
        return "USER";
    }
}

@WebServlet("/logout")
public class LogoutServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        if (session != null) {
            // Logout log'ini yozish
            String username = (String) session.getAttribute("user");
            log("User logged out: " + username);
            
            // Session'ni to'xtatish
            session.invalidate();
        }
        
        response.sendRedirect(request.getContextPath() + "/login.jsp");
    }
}

@WebServlet("/dashboard")
public class DashboardServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        
        // Session mavjudligini tekshirish
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect(request.getContextPath() + "/login.jsp");
            return;
        }
        
        String username = (String) session.getAttribute("user");
        String role = (String) session.getAttribute("role");
        java.util.Date loginTime = (java.util.Date) session.getAttribute("loginTime");
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Dashboard</h2>");
        out.println("<p>Welcome, " + username + "!</p>");
        out.println("<p>Role: " + role + "</p>");
        out.println("<p>Logged in at: " + loginTime + "</p>");
        out.println("<a href='" + request.getContextPath() + "/logout'>Logout</a>");
    }
}
```

---

## 1.4 Cookies

### Cookie nima?

Cookie - foydalanuvchi brauzerida saqlanadigan kichik ma'lumotlar.

```java
@WebServlet("/cookie-demo")
public class CookieDemoServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // 1. Cookie yaratish
        Cookie userCookie = new Cookie("username", "Ali");
        userCookie.setMaxAge(60 * 60 * 24);  // 1 kun
        userCookie.setPath("/");
        userCookie.setHttpOnly(true);
        userCookie.setSecure(true);  // Faqat HTTPS da
        response.addCookie(userCookie);
        
        // 2. Cookie'ni o'qish
        Cookie[] cookies = request.getCookies();
        String username = null;
        
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("username".equals(cookie.getName())) {
                    username = cookie.getValue();
                    break;
                }
            }
        }
        
        // 3. Cookie'ni yangilash
        if (username != null) {
            Cookie updateCookie = new Cookie("username", username + "_updated");
            updateCookie.setMaxAge(60 * 60 * 24);
            updateCookie.setPath("/");
            response.addCookie(updateCookie);
        }
        
        // 4. Cookie'ni o'chirish
        // Cookie deleteCookie = new Cookie("username", "");
        // deleteCookie.setMaxAge(0);
        // deleteCookie.setPath("/");
        // response.addCookie(deleteCookie);
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<h2>Cookie Information</h2>");
        out.println("<p>Username from cookie: " + username + "</p>");
        
        out.println("<h3>All Cookies:</h3>");
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                out.println("<p>");
                out.println("Name: " + cookie.getName() + "<br/>");
                out.println("Value: " + cookie.getValue() + "<br/>");
                out.println("Max Age: " + cookie.getMaxAge() + " seconds<br/>");
                out.println("Path: " + cookie.getPath() + "<br/>");
                out.println("HttpOnly: " + cookie.isHttpOnly() + "<br/>");
                out.println("Secure: " + cookie.getSecure() + "<br/>");
                out.println("</p><hr/>");
            }
        } else {
            out.println("<p>No cookies found</p>");
        }
    }
}
```

### "Remember Me" Funksiyasi

```java
@WebServlet("/login-with-remember")
public class LoginWithRememberServlet extends HttpServlet {
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String username = request.getParameter("username");
        String password = request.getParameter("password");
        String rememberMe = request.getParameter("rememberMe");
        
        if (authenticate(username, password)) {
            // Session yaratish
            HttpSession session = request.getSession();
            session.setAttribute("user", username);
            
            // "Remember Me" cookie
            if ("on".equals(rememberMe)) {
                // Xavfsiz token yaratish
                String token = generateToken(username);
                
                Cookie rememberCookie = new Cookie("rememberMe", token);
                rememberCookie.setMaxAge(60 * 60 * 24 * 30); // 30 kun
                rememberCookie.setPath("/");
                rememberCookie.setHttpOnly(true);
                response.addCookie(rememberCookie);
                
                // Token'ni ma'lumotlar bazasiga saqlash
                saveToken(username, token);
            }
            
            response.sendRedirect(request.getContextPath() + "/dashboard");
        } else {
            request.setAttribute("error", "Invalid credentials");
            request.getRequestDispatcher("/login.jsp").forward(request, response);
        }
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // "Remember Me" cookie'ni tekshirish
        Cookie[] cookies = request.getCookies();
        if (cookies != null) {
            for (Cookie cookie : cookies) {
                if ("rememberMe".equals(cookie.getName())) {
                    String token = cookie.getValue();
                    String username = validateToken(token);
                    
                    if (username != null) {
                        // Avtomatik login qilish
                        HttpSession session = request.getSession();
                        session.setAttribute("user", username);
                        response.sendRedirect(request.getContextPath() + "/dashboard");
                        return;
                    }
                }
            }
        }
        
        // Cookie yo'q yoki token noto'g'ri - login sahifasiga
        request.getRequestDispatcher("/login.jsp").forward(request, response);
    }
    
    private boolean authenticate(String username, String password) {
        // Authentication logic
        return "admin".equals(username) && "admin123".equals(password);
    }
    
    private String generateToken(String username) {
        return username + "_" + System.currentTimeMillis() + "_" + Math.random();
    }
    
    private void saveToken(String username, String token) {
        // Token'ni ma'lumotlar bazasiga saqlash
    }
    
    private String validateToken(String token) {
        // Token'ni tekshirish
        if (token != null && token.contains("_")) {
            return token.split("_")[0];
        }
        return null;
    }
}
```

---

## 1.5 Filters

### Filter nima?

Filter - servlet'ga so'rov yuborilishidan oldin va javob qaytarilishidan keyin intervensiya qilish imkonini beruvchi komponent.

```java
import jakarta.servlet.*;
import jakarta.servlet.annotation.*;
import jakarta.servlet.http.*;
import java.io.*;

// 1. Logging Filter
@WebFilter("/*")
public class LoggingFilter implements Filter {
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        System.out.println("LoggingFilter initialized");
    }
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        
        // Request ma'lumotlarini log qilish
        long startTime = System.currentTimeMillis();
        String method = httpRequest.getMethod();
        String uri = httpRequest.getRequestURI();
        String remoteAddr = httpRequest.getRemoteAddr();
        String userAgent = httpRequest.getHeader("User-Agent");
        
        System.out.println("=== Request Started ===");
        System.out.println("Method: " + method);
        System.out.println("URI: " + uri);
        System.out.println("Remote Address: " + remoteAddr);
        System.out.println("User Agent: " + userAgent);
        
        // So'rovni keyingi filter yoki servlet'ga uzatish
        chain.doFilter(request, response);
        
        // Response log qilish
        long duration = System.currentTimeMillis() - startTime;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        int status = httpResponse.getStatus();
        
        System.out.println("=== Request Finished ===");
        System.out.println("Status: " + status);
        System.out.println("Duration: " + duration + " ms");
        System.out.println();
    }
    
    @Override
    public void destroy() {
        System.out.println("LoggingFilter destroyed");
    }
}
```

### Authentication Filter

```java
@WebFilter("/admin/*")
public class AuthenticationFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        HttpSession session = httpRequest.getSession(false);
        
        // Login va register sahifalariga ruxsat
        String uri = httpRequest.getRequestURI();
        if (uri.endsWith("/login") || uri.endsWith("/register") || 
            uri.contains("/css/") || uri.contains("/js/") || uri.contains("/images/")) {
            chain.doFilter(request, response);
            return;
        }
        
        // Session tekshirish
        if (session == null || session.getAttribute("user") == null) {
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp");
            return;
        }
        
        // Role tekshirish (admin sahifalari uchun)
        if (uri.contains("/admin/")) {
            String role = (String) session.getAttribute("role");
            if (!"ADMIN".equals(role)) {
                httpResponse.sendError(HttpServletResponse.SC_FORBIDDEN, "Access Denied");
                return;
            }
        }
        
        chain.doFilter(request, response);
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}
```

### Compression Filter

```java
@WebFilter("/*")
public class CompressionFilter implements Filter {
    
    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        
        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;
        
        // Compression'ni qo'llab-quvvatlashini tekshirish
        String acceptEncoding = httpRequest.getHeader("Accept-Encoding");
        
        if (acceptEncoding != null && acceptEncoding.contains("gzip")) {
            GzipResponseWrapper gzipResponse = new GzipResponseWrapper(httpResponse);
            chain.doFilter(request, gzipResponse);
            gzipResponse.finishResponse();
        } else {
            chain.doFilter(request, response);
        }
    }
    
    // GzipResponseWrapper inner class
    private static class GzipResponseWrapper extends HttpServletResponseWrapper {
        private GzipServletOutputStream gzipOutputStream;
        private PrintWriter writer;
        
        public GzipResponseWrapper(HttpServletResponse response) {
            super(response);
        }
        
        @Override
        public ServletOutputStream getOutputStream() throws IOException {
            if (writer != null) {
                throw new IllegalStateException("getWriter() already called");
            }
            if (gzipOutputStream == null) {
                gzipOutputStream = new GzipServletOutputStream(getResponse().getOutputStream());
            }
            return gzipOutputStream;
        }
        
        @Override
        public PrintWriter getWriter() throws IOException {
            if (gzipOutputStream != null) {
                throw new IllegalStateException("getOutputStream() already called");
            }
            if (writer == null) {
                gzipOutputStream = new GzipServletOutputStream(getResponse().getOutputStream());
                writer = new PrintWriter(new OutputStreamWriter(gzipOutputStream, 
                                          getResponse().getCharacterEncoding()));
            }
            return writer;
        }
        
        public void finishResponse() throws IOException {
            if (writer != null) {
                writer.close();
            } else if (gzipOutputStream != null) {
                gzipOutputStream.close();
            }
        }
    }
    
    private static class GzipServletOutputStream extends ServletOutputStream {
        private final GZIPOutputStream gzipOutputStream;
        
        public GzipServletOutputStream(OutputStream output) throws IOException {
            gzipOutputStream = new GZIPOutputStream(output);
        }
        
        @Override
        public void write(int b) throws IOException {
            gzipOutputStream.write(b);
        }
        
        @Override
        public void write(byte[] b) throws IOException {
            gzipOutputStream.write(b);
        }
        
        @Override
        public void write(byte[] b, int off, int len) throws IOException {
            gzipOutputStream.write(b, off, len);
        }
        
        @Override
        public void close() throws IOException {
            gzipOutputStream.close();
        }
        
        @Override
        public void flush() throws IOException {
            gzipOutputStream.flush();
        }
    }
    
    @Override
    public void init(FilterConfig filterConfig) throws ServletException {}
    
    @Override
    public void destroy() {}
}
```

### web.xml da Filter Konfiguratsiyasi

```xml
<filter>
    <filter-name>LoggingFilter</filter-name>
    <filter-class>com.example.LoggingFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>LoggingFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

<filter>
    <filter-name>AuthenticationFilter</filter-name>
    <filter-class>com.example.AuthenticationFilter</filter-class>
    <init-param>
        <param-name>excludedUrls</param-name>
        <param-value>/login,/register,/css/*,/js/*</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>AuthenticationFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>

<filter>
    <filter-name>CompressionFilter</filter-name>
    <filter-class>com.example.CompressionFilter</filter-class>
</filter>
<filter-mapping>
    <filter-name>CompressionFilter</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

---

## 1.6 Exception Handling

### web.xml da Xatolik Boshqaruvi

```xml
<web-app>
    <!-- HTTP status code error pages -->
    <error-page>
        <error-code>404</error-code>
        <location>/error/404.html</location>
    </error-page>
    
    <error-page>
        <error-code>500</error-code>
        <location>/error/500.html</location>
    </error-page>
    
    <error-page>
        <error-code>403</error-code>
        <location>/error/403.html</location>
    </error-page>
    
    <!-- Exception type error pages -->
    <error-page>
        <exception-type>java.lang.NullPointerException</exception-type>
        <location>/error/nullpointer.jsp</location>
    </error-page>
    
    <error-page>
        <exception-type>java.sql.SQLException</exception-type>
        <location>/error/database.jsp</location>
    </error-page>
    
    <error-page>
        <exception-type>javax.servlet.ServletException</exception-type>
        <location>/error/servlet.jsp</location>
    </error-page>
</web-app>
```

### Custom Error Servlet

```java
@WebServlet("/error-handler")
public class ErrorHandlerServlet extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        // Xatolik ma'lumotlarini olish
        Integer statusCode = (Integer) request.getAttribute("jakarta.servlet.error.status_code");
        String exceptionType = (String) request.getAttribute("jakarta.servlet.error.exception_type");
        String message = (String) request.getAttribute("jakarta.servlet.error.message");
        String requestUri = (String) request.getAttribute("jakarta.servlet.error.request_uri");
        String servletName = (String) request.getAttribute("jakarta.servlet.error.servlet_name");
        
        // Xatolikni log qilish
        log("Error occurred:");
        log("  Status Code: " + statusCode);
        log("  Exception Type: " + exceptionType);
        log("  Message: " + message);
        log("  Request URI: " + requestUri);
        log("  Servlet Name: " + servletName);
        
        response.setContentType("text/html");
        PrintWriter out = response.getWriter();
        
        out.println("<!DOCTYPE html>");
        out.println("<html>");
        out.println("<head><title>Error Page</title>");
        out.println("<style>");
        out.println("body { font-family: Arial; margin: 50px; }");
        out.println(".error { color: red; }");
        out.println(".info { background: #f5f5f5; padding: 20px; border-radius: 5px; }");
        out.println("</style>");
        out.println("</head>");
        out.println("<body>");
        
        if (statusCode != null) {
            out.println("<h1 class='error'>Error " + statusCode + "</h1>");
            
            switch (statusCode) {
                case 404:
                    out.println("<p>The requested resource was not found.</p>");
                    out.println("<p>URI: " + requestUri + "</p>");
                    break;
                case 403:
                    out.println("<p>You don't have permission to access this resource.</p>");
                    break;
                case 500:
                    out.println("<p>Internal server error occurred.</p>");
                    if (message != null) {
                        out.println("<p>Message: " + message + "</p>");
                    }
                    break;
                default:
                    out.println("<p>An error occurred while processing your request.</p>");
            }
        } else if (exceptionType != null) {
            out.println("<h1 class='error'>Exception: " + exceptionType + "</h1>");
            out.println("<div class='info'>");
            out.println("<h3>Exception Details:</h3>");
            out.println("<p>Message: " + message + "</p>");
            out.println("<p>Request URI: " + requestUri + "</p>");
            out.println("<p>Servlet: " + servletName + "</p>");
            out.println("</div>");
        }
        
        out.println("<p><a href='" + request.getContextPath() + "/'>Go to Home Page</a></p>");
        out.println("</body>");
        out.println("</html>");
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        doGet(request, response);
    }
}
```

### Error Pages

```jsp
<!-- error/nullpointer.jsp -->
<%@page isErrorPage="true" contentType="text/html; charset=UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Null Pointer Error</title>
    <style>
        body { font-family: Arial; margin: 50px; }
        .error-box { background: #f8d7da; color: #721c24; padding: 20px; border-radius: 5px; }
        .stack-trace { background: #f5f5f5; padding: 15px; overflow: auto; font-family: monospace; }
    </style>
</head>
<body>
    <div class="error-box">
        <h1>Null Pointer Exception</h1>
        <p>A null reference was encountered.</p>
        <p>Message: <%= exception.getMessage() %></p>
    </div>
    
    <h3>Stack Trace:</h3>
    <div class="stack-trace">
        <%
            java.io.StringWriter sw = new java.io.StringWriter();
            java.io.PrintWriter pw = new java.io.PrintWriter(sw);
            exception.printStackTrace(pw);
            out.println(sw.toString().replace("\n", "<br/>"));
        %>
    </div>
    
    <p><a href="<%= request.getContextPath() %>/">Back to Home</a></p>
</body>
</html>
```

---

## Tekshiruv Savollari

1. **Servlet init parametrlari va context init parametrlari o'rtasidagi farq nima?**
2. **ServletContextListener qachon ishlatiladi?**
3. **HttpSessionListener qanday vazifani bajaradi?**
4. **Session va Cookie o'rtasidagi farq nima?**
5. **Cookie'ni xavfsiz qilish uchun qanday atributlarni o'rnatish kerak?**
6. **Filter nima va u qanday vazifalarni bajaradi?**
7. **Filter chain nima va qanday ishlaydi?**
8. **web.xml da xatoliklarni qanday boshqarish mumkin?**
9. **isErrorPage="true" nima vazifani bajaradi?**
10. **Session invalidation va cookie deletion o'rtasidagi farq nima?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega veb-ilova yarating:

1. **Init parametrlar** - application sozlamalarini (appName, adminEmail, pageSize) init parametrlar orqali sozlash
2. **Event Listeners** - application start/stop, session create/destroy va attribute o'zgarishlarini log qilish
3. **Session Management** - login/logout, session timeout, "remember me" funksiyasi
4. **Cookies** - foydalanuvchi preferensiyalarini (til, theme) cookie'da saqlash
5. **Filters** - logging, authentication, compression, caching filter'lar
6. **Error Handling** - 404, 500 va exception'lar uchun maxsus sahifalar

---

**Keyingi mavzu:** [Object-Relational Mapping (ORM)](./06_ORM.md)  
**[Mundarijaga qaytish](../README.md)**

> Servlet Filter'lar, Session va Cookie - veb-ilovalarning asosiy tarkibiy qismlari. Ularni o'rganish orqali professional veb-ilovalar yaratishni o'zlashtirasiz. 🚀
