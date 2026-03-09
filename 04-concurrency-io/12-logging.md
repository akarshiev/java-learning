# 10 - Logging API (Java Logging Tizimi)

## Logging nima?

**Logging** - kompyuter tizimida sodir bo'layotgan hodisalar (problems, errors, information) haqida qayd yozish jarayoni.

```java
// Oddiy logging misoli
System.out.println("Application started"); // Konsolga chiqarish
// Yoki log fayliga yozish: application.log fayliga "Application started" yoziladi
```

### Nima uchun Logging kerak?

1. **Monitoring** - Tizim ishini kuzatish
2. **Debugging** - Xatoliklarni aniqlash
3. **Audit** - Kim nima qilganini tekshirish
4. **Performance** - Tizim tezligini o'lchash
5. **Multi-user systems** - Markaziy kuzatuv

```java
// ❌ Yomon: System.out.println
public void processOrder(Order order) {
    System.out.println("Processing order: " + order.getId());
    try {
        // biznes logika
        System.out.println("Order processed successfully");
    } catch (Exception e) {
        System.out.println("Error: " + e.getMessage());
        e.printStackTrace();
    }
}
// Muammolar: kontrol yo'q, format yo'q, file ga yozmaydi

// ✅ Yaxshi: Logging API
import java.util.logging.*;

public class OrderProcessor {
    private static final Logger logger = 
        Logger.getLogger(OrderProcessor.class.getName());
    
    public void processOrder(Order order) {
        logger.info("Processing order: " + order.getId());
        try {
            // biznes logika
            logger.info("Order processed successfully");
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to process order", e);
        }
    }
}
```

---

## Java Logging API (Java 1.4+)

### Logging API Architecture

```
                    ┌─────────────────┐
                    │    Logger       │
                    │  (application)  │
                    └────────┬────────┘
                             │
                    ┌────────▼────────┐
                    │   LogRecord     │
                    │  (log entry)    │
                    └────────┬────────┘
                             │
        ┌────────────────────┼────────────────────┐
        ▼                    ▼                    ▼
┌───────────────┐   ┌───────────────┐   ┌───────────────┐
│   Filter      │   │   Handler     │   │  Formatter    │
│ (optional)    │   │ (destination) │   │  (format)     │
└───────────────┘   └───────┬───────┘   └───────────────┘
                            │
              ┌─────────────┼─────────────┐
              ▼             ▼             ▼
      ┌────────────┐ ┌────────────┐ ┌────────────┐
      │ Console    │ │ File       │ │ Socket     │
      │ Handler    │ │ Handler    │ │ Handler    │
      └────────────┘ └────────────┘ └────────────┘
```

### Logging API ning asosiy elementlari

| Element | Vazifasi |
|---------|----------|
| **Logger** | Logging call'lar qilish uchun asosiy obyekt |
| **LogRecord** | Log ma'lumotlarini tashuvchi obyekt |
| **Handler** | Log'larni turli destination'larga yozish |
| **Level** | Log darajalari (SEVERE, WARNING, INFO, etc.) |
| **Filter** | Qaysi log'lar yozilishini nazorat qilish |
| **Formatter** | Log'larni formatlash (text, XML, etc.) |

---

## Log Levels (Log Darajalari)

```java
import java.util.logging.Level;
import java.util.logging.Logger;

public class LogLevelsExample {
    private static final Logger logger = 
        Logger.getLogger(LogLevelsExample.class.getName());
    
    public static void main(String[] args) {
        
        // Log level tartibi (pastdan yuqoriga):
        // FINEST < FINER < FINE < CONFIG < INFO < WARNING < SEVERE
        
        // 1. SEVERE (highest) - Jiddiy xatolar
        logger.severe("Database connection failed - application cannot continue");
        
        // 2. WARNING - Ogohlantirishlar
        logger.warning("Disk space is low (only 10MB left)");
        
        // 3. INFO - Normal operatsiya ma'lumotlari
        logger.info("Application started successfully");
        logger.info("User 'john' logged in");
        
        // 4. CONFIG - Konfiguratsiya ma'lumotlari
        logger.config("Loading configuration from: /etc/app/config.xml");
        logger.config("Max connections: 100");
        
        // 5. FINE - Detailed debug ma'lumotlari
        logger.fine("Processing order #12345");
        
        // 6. FINER - More detailed debug
        logger.finer("Entering method processOrder()");
        
        // 7. FINEST (lowest) - Very detailed debug
        logger.finest("Variable x = 42, y = 100");
        
        // Umumiy log method
        logger.log(Level.INFO, "This is an info message");
        logger.log(Level.SEVERE, "Error processing request", new Exception("Timeout"));
        
        // Level constants
        System.out.println("OFF: " + Level.OFF);     // Turn off logging
        System.out.println("ALL: " + Level.ALL);     // Enable all logging
    }
}
```

### Log Level Comparison

| Level | Qiymat | Qachon ishlatiladi? |
|-------|--------|---------------------|
| OFF | Integer.MAX_VALUE | Logging o'chirilganda |
| SEVERE | 1000 | Application crash, DB error |
| WARNING | 900 | Resource low, deprecation |
| INFO | 800 | Startup, shutdown, major events |
| CONFIG | 700 | Configuration details |
| FINE | 500 | General debug |
| FINER | 400 | Detailed debug |
| FINEST | 300 | Very detailed debug (tracing) |
| ALL | Integer.MIN_VALUE | Barcha level'lar |

---

## Logger

### Logger yaratish

```java
import java.util.logging.Logger;
import java.util.logging.Level;

public class LoggerCreation {
    
    // 1. Class-level logger (tavsiya etiladi)
    private static final Logger logger1 = 
        Logger.getLogger(LoggerCreation.class.getName());
    
    // 2. Package-level logger
    private static final Logger logger2 = 
        Logger.getLogger("com.myapp.service");
    
    // 3. Global logger
    private static final Logger globalLogger = 
        Logger.getGlobal();
    
    // 4. Anonymous logger (root logger)
    private static final Logger rootLogger = 
        Logger.getLogger("");
    
    public static void main(String[] args) {
        logger1.info("This is from class logger");
        logger2.info("This is from package logger");
        globalLogger.info("This is global logger");
        
        // Logger name hierarchy
        Logger parent = Logger.getLogger("com");
        Logger child = Logger.getLogger("com.myapp");
        
        System.out.println("Parent: " + parent.getName());
        System.out.println("Child: " + child.getName());
        System.out.println("Child's parent: " + child.getParent().getName());
    }
}
```

### Logger Configuration

```java
import java.util.logging.*;

public class LoggerConfigExample {
    private static final Logger logger = 
        Logger.getLogger(LoggerConfigExample.class.getName());
    
    public static void main(String[] args) {
        
        // 1. Log level o'rnatish
        logger.setLevel(Level.FINE);
        
        // 2. Parent handler larni o'chirish
        logger.setUseParentHandlers(false);
        
        // 3. Console handler qo'shish
        ConsoleHandler consoleHandler = new ConsoleHandler();
        consoleHandler.setLevel(Level.ALL);
        logger.addHandler(consoleHandler);
        
        // 4. File handler qo'shish
        try {
            FileHandler fileHandler = new FileHandler("app.log");
            fileHandler.setLevel(Level.WARNING);
            logger.addHandler(fileHandler);
        } catch (Exception e) {
            logger.severe("Cannot create file handler: " + e.getMessage());
        }
        
        // Test messages
        logger.fine("This is FINE message");      // Will be logged
        logger.info("This is INFO message");       // Will be logged
        logger.warning("This is WARNING message"); // Will be logged
        
        // 5. Logger off qilish
        // logger.setLevel(Level.OFF);
    }
}
```

---

## Handlers

### Handler Turlari

```java
import java.util.logging.*;
import java.io.IOException;

public class HandlersExample {
    private static final Logger logger = 
        Logger.getLogger(HandlersExample.class.getName());
    
    public static void main(String[] args) {
        
        // 1. ConsoleHandler - konsolga yozish
        ConsoleHandler consoleHandler = new ConsoleHandler();
        consoleHandler.setLevel(Level.ALL);
        consoleHandler.setFormatter(new SimpleFormatter());
        logger.addHandler(consoleHandler);
        
        // 2. FileHandler - faylga yozish
        try {
            // Single file
            FileHandler fileHandler1 = new FileHandler("app.log");
            fileHandler1.setLevel(Level.INFO);
            logger.addHandler(fileHandler1);
            
            // Rotating files (max 5 files, each 1MB)
            FileHandler fileHandler2 = new FileHandler(
                "app_%g.log",  // %g = generation number
                1024 * 1024,   // 1MB
                5,             // 5 files
                true           // append mode
            );
            fileHandler2.setLevel(Level.FINE);
            fileHandler2.setFormatter(new XMLFormatter());
            logger.addHandler(fileHandler2);
            
        } catch (IOException e) {
            logger.severe("Cannot create file handler: " + e.getMessage());
        }
        
        // 3. SocketHandler - network orqali yuborish
        try {
            SocketHandler socketHandler = new SocketHandler("localhost", 9999);
            socketHandler.setLevel(Level.SEVERE);
            // logger.addHandler(socketHandler); // Agar logging server bo'lsa
        } catch (IOException e) {
            logger.warning("Cannot connect to logging server");
        }
        
        // 4. MemoryHandler - buffer da saqlash
        MemoryHandler memoryHandler = new MemoryHandler(
            new FileHandler("buffer.log"), // target handler
            100,                            // buffer size
            Level.WARNING                    // push level
        );
        memoryHandler.setLevel(Level.ALL);
        logger.addHandler(memoryHandler);
        
        // Test messages
        logger.info("This is INFO message");
        logger.warning("This is WARNING message");
        logger.severe("This is SEVERE message");
        
        // Handler larni ro'yxati
        Handler[] handlers = logger.getHandlers();
        System.out.println("Number of handlers: " + handlers.length);
    }
}
```

### StreamHandler

```java
import java.util.logging.*;
import java.io.ByteArrayOutputStream;
import java.io.PrintStream;

public class StreamHandlerExample {
    public static void main(String[] args) {
        
        // 1. StreamHandler with custom stream
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        StreamHandler streamHandler = new StreamHandler(
            baos, 
            new SimpleFormatter()
        );
        streamHandler.setLevel(Level.ALL);
        
        Logger logger = Logger.getLogger("TestLogger");
        logger.addHandler(streamHandler);
        logger.setUseParentHandlers(false);
        
        // Log messages
        logger.info("This goes to byte array");
        logger.warning("This too");
        
        // Flush to ensure all messages are written
        streamHandler.flush();
        
        // Read from byte array
        String logs = baos.toString();
        System.out.println("Captured logs:");
        System.out.println(logs);
        
        // 2. Custom PrintStream
        PrintStream printStream = new PrintStream("custom.log");
        StreamHandler printHandler = new StreamHandler(
            printStream,
            new SimpleFormatter()
        );
        logger.addHandler(printHandler);
    }
}
```

---

## Formatters

### SimpleFormatter

```java
import java.util.logging.*;
import java.util.Date;

public class FormatterExample {
    public static void main(String[] args) {
        
        Logger logger = Logger.getLogger("TestLogger");
        
        // 1. Default SimpleFormatter
        ConsoleHandler defaultHandler = new ConsoleHandler();
        defaultHandler.setFormatter(new SimpleFormatter());
        logger.addHandler(defaultHandler);
        
        // 2. Custom SimpleFormatter pattern
        // System property orqali format o'rnatish
        System.setProperty(
            "java.util.logging.SimpleFormatter.format",
            "[%1$tF %1$tT] [%4$-7s] %5$s %n"
        );
        // Format: [2024-01-15 14:30:45] [INFO   ] Message
        
        ConsoleHandler customHandler = new ConsoleHandler();
        customHandler.setFormatter(new SimpleFormatter());
        logger.addHandler(customHandler);
        
        logger.setUseParentHandlers(false);
        
        // Test messages
        logger.info("Application started");
        logger.warning("Low memory");
        
        // SimpleFormatter format specifiers:
        // %1$tF - date (yyyy-MM-dd)
        // %1$tT - time (HH:mm:ss)
        // %2$s  - source (class.method)
        // %3$s  - logger name
        // %4$s  - level
        // %5$s  - message
        // %6$s  - thrown (exception)
        // %n    - newline
    }
}
```

### XMLFormatter

```java
import java.util.logging.*;
import java.io.IOException;

public class XMLFormatterExample {
    public static void main(String[] args) {
        
        Logger logger = Logger.getLogger("XMLTest");
        
        try {
            // 1. File handler with XML formatter
            FileHandler fileHandler = new FileHandler("log.xml");
            fileHandler.setFormatter(new XMLFormatter());
            logger.addHandler(fileHandler);
            
            // 2. Console with XML formatter
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setFormatter(new XMLFormatter());
            logger.addHandler(consoleHandler);
            
            logger.setUseParentHandlers(false);
            
            // Log messages
            logger.info("User logged in");
            logger.warning("Invalid login attempt");
            
            try {
                throw new NullPointerException("Test exception");
            } catch (Exception e) {
                logger.log(Level.SEVERE, "Error occurred", e);
            }
            
            // XML output example:
            // <record>
            //   <date>2024-01-15T14:30:45</date>
            //   <millis>1705321845000</millis>
            //   <sequence>1234</sequence>
            //   <logger>XMLTest</logger>
            //   <level>INFO</level>
            //   <class>XMLFormatterExample</class>
            //   <method>main</method>
            //   <thread>1</thread>
            //   <message>User logged in</message>
            // </record>
            
        } catch (IOException e) {
            e.printStackTrace();
        }
    }
}
```

### Custom Formatter

```java
import java.util.logging.*;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;

class CustomFormatter extends Formatter {
    
    private static final DateTimeFormatter dtf = 
        DateTimeFormatter.ofPattern("yyyy-MM-dd HH:mm:ss.SSS");
    
    @Override
    public String format(LogRecord record) {
        StringBuilder sb = new StringBuilder();
        
        // Timestamp
        sb.append(dtf.format(LocalDateTime.now()));
        sb.append(" ");
        
        // Level
        sb.append("[");
        sb.append(record.getLevel().getLocalizedName());
        sb.append("] ");
        
        // Class and method
        sb.append(record.getSourceClassName());
        sb.append(".");
        sb.append(record.getSourceMethodName());
        sb.append(": ");
        
        // Message
        sb.append(formatMessage(record));
        sb.append("\n");
        
        // Exception if any
        if (record.getThrown() != null) {
            try {
                StringWriter sw = new StringWriter();
                PrintWriter pw = new PrintWriter(sw);
                record.getThrown().printStackTrace(pw);
                pw.close();
                sb.append(sw.toString());
            } catch (Exception ex) {
                // Ignore
            }
        }
        
        return sb.toString();
    }
    
    @Override
    public String getHead(Handler h) {
        return "=== Log Started at " + 
               dtf.format(LocalDateTime.now()) + " ===\n";
    }
    
    @Override
    public String getTail(Handler h) {
        return "=== Log Ended at " + 
               dtf.format(LocalDateTime.now()) + " ===\n";
    }
}

public class CustomFormatterExample {
    private static final Logger logger = 
        Logger.getLogger(CustomFormatterExample.class.getName());
    
    public static void main(String[] args) {
        
        // Use custom formatter
        ConsoleHandler handler = new ConsoleHandler();
        handler.setFormatter(new CustomFormatter());
        logger.addHandler(handler);
        logger.setUseParentHandlers(false);
        
        // Test
        logger.info("Application starting");
        logger.warning("Configuration file not found, using defaults");
        
        try {
            int x = 10 / 0;
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Calculation error", e);
        }
    }
}
```

---

## Filters

```java
import java.util.logging.*;

// Custom filter
class ImportantOnlyFilter implements Filter {
    @Override
    public boolean isLoggable(LogRecord record) {
        // Only log messages containing "IMPORTANT" or level >= WARNING
        return record.getLevel().intValue() >= Level.WARNING.intValue() ||
               record.getMessage().contains("IMPORTANT");
    }
}

// Class-specific filter
class ClassFilter implements Filter {
    private final String className;
    
    public ClassFilter(String className) {
        this.className = className;
    }
    
    @Override
    public boolean isLoggable(LogRecord record) {
        return className.equals(record.getSourceClassName());
    }
}

// Time-based filter
class TimeBasedFilter implements Filter {
    private final int startHour;
    private final int endHour;
    
    public TimeBasedFilter(int startHour, int endHour) {
        this.startHour = startHour;
        this.endHour = endHour;
    }
    
    @Override
    public boolean isLoggable(LogRecord record) {
        int hour = LocalDateTime.now().getHour();
        return hour >= startHour && hour < endHour;
    }
}

public class FilterExample {
    private static final Logger logger = 
        Logger.getLogger(FilterExample.class.getName());
    
    public static void main(String[] args) {
        
        // 1. Add filter to logger
        logger.setFilter(new ImportantOnlyFilter());
        
        // 2. Add filter to handler
        ConsoleHandler handler = new ConsoleHandler();
        handler.setFilter(new ClassFilter("com.myapp.Main"));
        logger.addHandler(handler);
        
        logger.setUseParentHandlers(false);
        
        // Test messages
        logger.info("This is normal info");        // Won't be logged
        logger.warning("This is IMPORTANT warning"); // Will be logged
        logger.info("IMPORTANT update");            // Will be logged (contains IMPORTANT)
        logger.severe("Critical error");            // Will be logged (SEVERE)
        
        // 3. Compound filter
        logger.setFilter(record -> {
            // Complex logic
            boolean isImportant = record.getMessage().contains("IMPORTANT");
            boolean isSevere = record.getLevel() == Level.SEVERE;
            boolean isBusinessHours = LocalDateTime.now().getHour() >= 9 && 
                                      LocalDateTime.now().getHour() < 17;
            
            return (isImportant || isSevere) && isBusinessHours;
        });
    }
}
```

---

## LogManager va Configuration

### Programmatic Configuration

```java
import java.util.logging.*;
import java.io.IOException;

public class LogManagerExample {
    public static void main(String[] args) {
        
        // 1. Get LogManager instance
        LogManager logManager = LogManager.getLogManager();
        
        // 2. Configure programmatically
        Logger rootLogger = Logger.getLogger("");
        
        // Remove default handlers
        for (Handler handler : rootLogger.getHandlers()) {
            rootLogger.removeHandler(handler);
        }
        
        // Add custom handlers
        try {
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setLevel(Level.ALL);
            consoleHandler.setFormatter(new SimpleFormatter());
            rootLogger.addHandler(consoleHandler);
            
            FileHandler fileHandler = new FileHandler(
                "application_%g.log", 
                1024 * 1024, 
                10, 
                true
            );
            fileHandler.setLevel(Level.FINE);
            fileHandler.setFormatter(new XMLFormatter());
            rootLogger.addHandler(fileHandler);
            
        } catch (IOException e) {
            e.printStackTrace();
        }
        
        // Set log levels
        rootLogger.setLevel(Level.INFO);
        
        // Create child logger
        Logger childLogger = Logger.getLogger("com.myapp");
        childLogger.setLevel(Level.FINE);
        
        // Test
        Logger testLogger = Logger.getLogger("com.myapp.Test");
        testLogger.info("Test message");
        testLogger.fine("Debug message");
        
        // 3. Get logger by name
        Logger existing = logManager.getLogger("com.myapp");
        System.out.println("Found logger: " + existing);
        
        // 4. List all loggers
        java.util.Enumeration<String> loggerNames = logManager.getLoggerNames();
        System.out.println("\nAll loggers:");
        while (loggerNames.hasMoreElements()) {
            System.out.println("  " + loggerNames.nextElement());
        }
        
        // 5. Reset configuration
        // logManager.reset(); // Removes all handlers
    }
}
```

### Configuration File (logging.properties)

```properties
# logging.properties file

# Root logger level
.level=INFO

# Handlers
handlers=java.util.logging.ConsoleHandler,java.util.logging.FileHandler

# ConsoleHandler configuration
java.util.logging.ConsoleHandler.level=ALL
java.util.logging.ConsoleHandler.formatter=java.util.logging.SimpleFormatter
java.util.logging.ConsoleHandler.filter=

# FileHandler configuration
java.util.logging.FileHandler.level=FINE
java.util.logging.FileHandler.formatter=java.util.logging.XMLFormatter
java.util.logging.FileHandler.pattern=logs/app_%g.log
java.util.logging.FileHandler.limit=1048576
java.util.logging.FileHandler.count=10
java.util.logging.FileHandler.append=true

# Specific logger configuration
com.myapp.level=FINE
com.myapp.handlers=java.util.logging.ConsoleHandler

# SimpleFormatter format
java.util.logging.SimpleFormatter.format=[%1$tF %1$tT] %4$s: %5$s%n
```

### Load Configuration from File

```java
import java.util.logging.*;
import java.io.FileInputStream;
import java.io.IOException;

public class LoadConfigExample {
    public static void main(String[] args) {
        
        try {
            // 1. Load from custom properties file
            LogManager.getLogManager()
                .readConfiguration(new FileInputStream("logging.properties"));
            
            System.out.println("Configuration loaded successfully");
            
        } catch (IOException e) {
            System.err.println("Could not load configuration file");
            e.printStackTrace();
        }
        
        // 2. Use system properties
        // java -Djava.util.logging.config.file=logging.properties MyApp
        
        // 3. Use classpath resource
        // try (InputStream is = getClass().getResourceAsStream("/logging.properties")) {
        //     LogManager.getLogManager().readConfiguration(is);
        // }
        
        Logger logger = Logger.getLogger("com.myapp.Main");
        logger.info("This uses the loaded configuration");
        logger.fine("This might be logged if configured");
    }
}
```

---

## Best Practices

### 1. Logger Naming Convention

```java
// ✅ Yaxshi: Class name as logger name
public class UserService {
    private static final Logger logger = 
        Logger.getLogger(UserService.class.getName());
}

// ✅ Yaxshi: Package hierarchy
// Logger.getLogger("com.myapp.database")
// Logger.getLogger("com.myapp.service")
```

### 2. Guard Conditions

```java
// ✅ Yaxshi: Check level before expensive operations
public void processUser(User user) {
    if (logger.isLoggable(Level.FINE)) {
        logger.fine("Processing user: " + user.toDetailedString());
    }
    
    // ❌ Yomon: Always constructs string
    // logger.fine("Processing user: " + user.toDetailedString());
}
```

### 3. Exception Logging

```java
// ✅ Yaxshi: Log exception with stack trace
try {
    // some operation
} catch (SQLException e) {
    logger.log(Level.SEVERE, "Database error", e);
}

// ❌ Yomon: Only message
// logger.severe("Database error: " + e.getMessage());
```

### 4. Log Levels Usage

```java
public class LogLevelGuidelines {
    private static final Logger logger = 
        Logger.getLogger(LogLevelGuidelines.class.getName());
    
    public void demonstrateLevels() {
        
        // SEVERE - Application cannot continue
        if (database == null) {
            logger.severe("Database connection lost - shutting down");
        }
        
        // WARNING - Potential problem, but app continues
        if (diskSpace < MIN_DISK_SPACE) {
            logger.warning("Low disk space: " + diskSpace + "MB");
        }
        
        // INFO - Major lifecycle events
        logger.info("Application started on port " + port);
        logger.info("User " + username + " logged in");
        
        // CONFIG - Configuration details
        logger.config("Using database: " + dbUrl);
        logger.config("Max connections: " + maxConnections);
        
        // FINE - Debug information
        logger.fine("Processing order #" + orderId);
        
        // FINER - Method entry/exit
        logger.finer("Entering processPayment() with amount: " + amount);
        
        // FINEST - Detailed tracing
        logger.finest("Variables: x=" + x + ", y=" + y + ", result=" + result);
    }
}
```

### 5. Performance Considerations

```java
public class PerformanceExample {
    private static final Logger logger = 
        Logger.getLogger(PerformanceExample.class.getName());
    
    // 1. Lazy parameter evaluation
    public void logExpensive(Object obj) {
        if (logger.isLoggable(Level.FINE)) {
            logger.fine("Object: " + obj.toString()); // toString called only if needed
        }
    }
    
    // 2. Avoid string concatenation
    public void logParameters(String name, int id, double value) {
        if (logger.isLoggable(Level.FINE)) {
            logger.fine(String.format("name=%s, id=%d, value=%.2f", 
                                      name, id, value));
        }
    }
    
    // 3. Use lambda (Java 8+)
    // logger.fine(() -> "Expensive: " + computeExpensiveValue());
}
```

---

## Complete Example: Logging Framework

```java
import java.util.logging.*;
import java.io.*;
import java.time.LocalDateTime;
import java.util.concurrent.atomic.AtomicInteger;

// Custom LogManager
class ApplicationLogManager {
    private static final Logger rootLogger;
    private static final AtomicInteger logCounter = new AtomicInteger(0);
    
    static {
        // Initialize logging
        rootLogger = Logger.getLogger("");
        
        // Remove default handlers
        for (Handler handler : rootLogger.getHandlers()) {
            rootLogger.removeHandler(handler);
        }
        
        try {
            // Console handler
            ConsoleHandler consoleHandler = new ConsoleHandler();
            consoleHandler.setLevel(Level.ALL);
            consoleHandler.setFormatter(new CustomConsoleFormatter());
            rootLogger.addHandler(consoleHandler);
            
            // File handler with rotation
            FileHandler fileHandler = new FileHandler(
                "logs/application_%g.log",
                10 * 1024 * 1024, // 10MB
                20,                // 20 files
                true               // append
            );
            fileHandler.setLevel(Level.FINE);
            fileHandler.setFormatter(new XMLFormatter());
            rootLogger.addHandler(fileHandler);
            
            // Error handler (only SEVERE)
            FileHandler errorHandler = new FileHandler(
                "logs/error_%g.log",
                5 * 1024 * 1024, // 5MB
                5
            );
            errorHandler.setLevel(Level.SEVERE);
            errorHandler.setFormatter(new SimpleFormatter());
            rootLogger.addHandler(errorHandler);
            
        } catch (IOException e) {
            System.err.println("Failed to initialize logging: " + e.getMessage());
        }
        
        rootLogger.setLevel(Level.INFO);
    }
    
    public static Logger getLogger(Class<?> clazz) {
        return Logger.getLogger(clazz.getName());
    }
    
    public static void logAccess(String user, String action) {
        Logger accessLogger = Logger.getLogger("security.access");
        accessLogger.info(String.format("USER: %s, ACTION: %s, COUNT: %d", 
                          user, action, logCounter.incrementAndGet()));
    }
}

// Custom formatter
class CustomConsoleFormatter extends Formatter {
    @Override
    public String format(LogRecord record) {
        StringBuilder sb = new StringBuilder();
        
        // Timestamp
        sb.append(LocalDateTime.now().format(
            java.time.format.DateTimeFormatter.ISO_LOCAL_DATE_TIME));
        sb.append(" ");
        
        // Level with color (ANSI codes)
        String levelColor = getLevelColor(record.getLevel());
        sb.append(levelColor);
        sb.append(String.format("%-7s", record.getLevel().getLocalizedName()));
        sb.append("\u001B[0m"); // Reset color
        sb.append(" ");
        
        // Logger name (shortened)
        String loggerName = record.getLoggerName();
        if (loggerName != null && loggerName.length() > 30) {
            loggerName = "..." + loggerName.substring(loggerName.length() - 27);
        }
        sb.append(String.format("%-30s", loggerName));
        sb.append(": ");
        
        // Message
        sb.append(formatMessage(record));
        sb.append("\n");
        
        // Exception
        if (record.getThrown() != null) {
            StringWriter sw = new StringWriter();
            PrintWriter pw = new PrintWriter(sw);
            record.getThrown().printStackTrace(pw);
            sb.append(sw.toString());
        }
        
        return sb.toString();
    }
    
    private String getLevelColor(Level level) {
        if (level == Level.SEVERE) return "\u001B[31m"; // Red
        if (level == Level.WARNING) return "\u001B[33m"; // Yellow
        if (level == Level.INFO) return "\u001B[32m"; // Green
        if (level == Level.CONFIG) return "\u001B[34m"; // Blue
        if (level == Level.FINE) return "\u001B[36m"; // Cyan
        return "\u001B[0m"; // Default
    }
}

// Main application
public class LoggingFrameworkExample {
    private static final Logger logger = 
        ApplicationLogManager.getLogger(LoggingFrameworkExample.class);
    
    public static void main(String[] args) {
        logger.info("Application starting...");
        
        try {
            processUserRequest("john", "LOGIN");
            processUserRequest("jane", "VIEW_PRODUCTS");
            processUserRequest("admin", "DELETE_USER");
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Application error", e);
        }
        
        // Security logging
        ApplicationLogManager.logAccess("john.doe", "LOGIN");
        ApplicationLogManager.logAccess("jane.smith", "LOGOUT");
        
        logger.info("Application shutting down...");
    }
    
    public static void processUserRequest(String user, String action) {
        logger.fine("Processing request: user=" + user + ", action=" + action);
        
        try {
            if ("DELETE_USER".equals(action) && !"admin".equals(user)) {
                logger.warning("Unauthorized delete attempt by user: " + user);
                throw new SecurityException("Unauthorized access");
            }
            
            logger.info("Successfully processed: " + user + " -> " + action);
            
        } catch (Exception e) {
            logger.log(Level.SEVERE, "Failed to process request", e);
            throw e;
        }
    }
}
```

---

## Tekshiruv Savollari

### Lesson 10 - Logging

1. **Logging nima?**
2. **Log tashlash bizga nima uchun kerak?**
3. **Logging Java-ni nechinchi versiyasida qo'shilgan?**
4. **Necha xil log level bor? Har birini tushuntiring.**
5. **Logger, Handler, Formatter, Filter o'rtasidagi munosabat qanday?**
6. **SimpleFormatter va XMLFormatter farqi nima?**
7. **Log level'larni qanday sozlash mumkin?**
8. **FileHandler da rotating files nima?**
9. **System.out.println va logging farqi?**
10. **Logging konfiguratsiyasini qanday o'zgartirish mumkin?**

---

## Qo'shimcha Resurslar

- **[Java Logging Overview](https://docs.oracle.com/javase/8/docs/technotes/guides/logging/overview.html)** - Oracle documentation
- **[SLF4J](http://www.slf4j.org/)** - Simple Logging Facade for Java
- **[Log4j 2](https://logging.apache.org/log4j/2.x/)** - Apache Log4j 2
- **[Logback](http://logback.qos.ch/)** - Logback project

---

**Bu bilan 4-modul yakunlandi!** 🎉

**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
