# 1-Modul: JDBC (Java Database Connectivity)

## 1.1 JDBC Nima?

**JDBC (Java Database Connectivity)** - Java dasturlari va ma'lumotlar bazalari o'rtasidagi aloqani ta'minlaydigan API (Application Programming Interface). JDBC yordamida Java ilovalari SQL so'rovlar yuborib, ma'lumotlar bazasidan ma'lumot olishi va yangilashi mumkin.

**Oddiy qilib aytganda:** JDBC - bu Java dasturi bilan ma'lumotlar bazasi (PostgreSQL, MySQL, Oracle va boshqalar) o'rtasidagi ko'prik.

```
Java Application
       ↓
    JDBC API
       ↓
  JDBC Driver
       ↓
   Database
```

---

## 1.2 JDBC Arkitekturasi

```
┌─────────────────────────────────────────────────────────────┐
│                    Java Application                          │
├─────────────────────────────────────────────────────────────┤
│                    JDBC API (java.sql)                      │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ DriverManager | Connection | Statement | ResultSet  │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                  JDBC Driver (Vendor specific)               │
│  ┌─────────────────────────────────────────────────────┐    │
│  │  PostgreSQL Driver | MySQL Driver | Oracle Driver   │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                      Database                               │
└─────────────────────────────────────────────────────────────┘
```

### JDBC Driver Turlari

| Driver Type | Tavsifi |
|-------------|---------|
| **Type 1: JDBC-ODBC Bridge** | ODBC driver orqali ulanish. Java 8 da olib tashlangan. |
| **Type 2: Native-API Driver** | Database-ga xos native kod ishlatadi. |
| **Type 3: Network Protocol Driver** | Middleware server orqali ulanish. |
| **Type 4: Thin Driver** | To'g'ridan-to'g'ri database protokoli bilan ishlaydi. PostgreSQL, MySQL, Oracle uchun eng ko'p ishlatiladi. |

---

## 1.3 PostgreSQL JDBC Driver

### Maven Dependency

```xml
<dependency>
    <groupId>org.postgresql</groupId>
    <artifactId>postgresql</artifactId>
    <version>42.5.3</version>
</dependency>
```

### PostgreSQL Connection URL

```
jdbc:postgresql://host:port/database_name

// Lokal database uchun:
jdbc:postgresql://localhost:5432/mydb

// Parametrlar bilan:
jdbc:postgresql://localhost:5432/mydb?user=postgres&password=123&ssl=false
```

---

## 1.4 JDBC Asosiy Interfacelari

| Interface | Vazifasi |
|-----------|----------|
| **DriverManager** | JDBC driver'larini boshqaradi va Connection obyektini yaratadi |
| **Connection** | Ma'lumotlar bazasi bilan aloqani ifodalaydi |
| **Statement** | SQL so'rovlarni yuborish uchun ishlatiladi |
| **PreparedStatement** | Parametrli SQL so'rovlarni tayyorlash va bajarish |
| **CallableStatement** | Stored procedure'larni chaqirish |
| **ResultSet** | SQL so'rov natijalarini ifodalaydi |
| **ResultSetMetaData** | ResultSet haqida metama'lumot |
| **DatabaseMetaData** | Ma'lumotlar bazasi haqida metama'lumot |

---

## 1.5 JDBC bilan Ishlas Bosqichlari

```
1. Driver ni yuklash (optional, JDBC 4+ da avtomatik)
2. Connection yaratish
3. Statement yaratish
4. SQL so'rovni bajarish
5. ResultSet ni qayta ishlash
6. Resurslarni yopish
```

### To'liq Misol: Database bilan Ishlas

```java
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class JDBCExample {
    
    // Database connection parameters
    private static final String URL = "jdbc:postgresql://localhost:5432/school_db";
    private static final String USER = "postgres";
    private static final String PASSWORD = "password";
    
    public static void main(String[] args) {
        
        // 1. Driver ni yuklash (JDBC 4+ da automatic)
        // Class.forName("org.postgresql.Driver"); // Java 6 dan oldin kerak edi
        
        // 2. Connection yaratish
        try (Connection conn = DriverManager.getConnection(URL, USER, PASSWORD)) {
            
            System.out.println("Database ga ulanish muvaffaqiyatli!");
            
            // 3. Table yaratish
            createTable(conn);
            
            // 4. Ma'lumot qo'shish (INSERT)
            insertStudent(conn, "Ali Valiyev", 20, "ali@example.com");
            insertStudent(conn, "Guli Karimova", 22, "guli@example.com");
            insertStudent(conn, "Soli Ortiqov", 21, "soli@example.com");
            
            // 5. Ma'lumotlarni o'qish (SELECT)
            List<Student> students = getAllStudents(conn);
            System.out.println("\n=== Barcha talabalar ===");
            students.forEach(System.out::println);
            
            // 6. Ma'lumot yangilash (UPDATE)
            updateStudentEmail(conn, 1, "ali.valiyev@example.com");
            
            // 7. Ma'lumot o'chirish (DELETE)
            deleteStudent(conn, 3);
            
            // 8. Yangilangan ma'lumotlarni ko'rish
            students = getAllStudents(conn);
            System.out.println("\n=== Yangilangan talabalar ===");
            students.forEach(System.out::println);
            
        } catch (SQLException e) {
            System.err.println("Database xatosi: " + e.getMessage());
            e.printStackTrace();
        }
    }
    
    private static void createTable(Connection conn) throws SQLException {
        String sql = """
            CREATE TABLE IF NOT EXISTS students (
                id SERIAL PRIMARY KEY,
                name VARCHAR(100) NOT NULL,
                age INT,
                email VARCHAR(100) UNIQUE,
                created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
            )
            """;
        
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(sql);
            System.out.println("Table yaratildi yoki mavjud");
        }
    }
    
    private static void insertStudent(Connection conn, String name, int age, String email) 
            throws SQLException {
        String sql = "INSERT INTO students (name, age, email) VALUES (?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, name);
            pstmt.setInt(2, age);
            pstmt.setString(3, email);
            
            int affectedRows = pstmt.executeUpdate();
            System.out.printf("Qo'shildi: %d qator (%s)%n", affectedRows, name);
        }
    }
    
    private static List<Student> getAllStudents(Connection conn) throws SQLException {
        List<Student> students = new ArrayList<>();
        String sql = "SELECT id, name, age, email, created_at FROM students ORDER BY id";
        
        try (Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                Student student = new Student();
                student.setId(rs.getInt("id"));
                student.setName(rs.getString("name"));
                student.setAge(rs.getInt("age"));
                student.setEmail(rs.getString("email"));
                student.setCreatedAt(rs.getTimestamp("created_at"));
                students.add(student);
            }
        }
        return students;
    }
    
    private static void updateStudentEmail(Connection conn, int id, String newEmail) 
            throws SQLException {
        String sql = "UPDATE students SET email = ? WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setString(1, newEmail);
            pstmt.setInt(2, id);
            
            int affectedRows = pstmt.executeUpdate();
            System.out.printf("Yangilandi: %d qator (id=%d)%n", affectedRows, id);
        }
    }
    
    private static void deleteStudent(Connection conn, int id) throws SQLException {
        String sql = "DELETE FROM students WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            pstmt.setInt(1, id);
            
            int affectedRows = pstmt.executeUpdate();
            System.out.printf("O'chirildi: %d qator (id=%d)%n", affectedRows, id);
        }
    }
}

class Student {
    private int id;
    private String name;
    private int age;
    private String email;
    private Timestamp createdAt;
    
    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }
    
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    
    public int getAge() { return age; }
    public void setAge(int age) { this.age = age; }
    
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    
    public Timestamp getCreatedAt() { return createdAt; }
    public void setCreatedAt(Timestamp createdAt) { this.createdAt = createdAt; }
    
    @Override
    public String toString() {
        return String.format("Student{id=%d, name='%s', age=%d, email='%s', createdAt=%s}", 
                            id, name, age, email, createdAt);
    }
}
```

---

## 1.6 PreparedStatement

`PreparedStatement` - SQL so'rovni tayyorlab, parametrlarni keyinroq o'rnatish imkonini beradi. Bu:
- **Xavfsizlik** - SQL injection'dan himoya qiladi
- **Performance** - So'rov bir marta compile qilinadi, ko'p marta bajariladi
- **Qulaylik** - Java tiplarini avtomatik SQL tiplariga o'tkazadi

```java
public class PreparedStatementExample {
    
    public static void insertProduct(Connection conn, Product product) throws SQLException {
        String sql = "INSERT INTO products (name, price, quantity, category) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, product.getName());
            pstmt.setDouble(2, product.getPrice());
            pstmt.setInt(3, product.getQuantity());
            pstmt.setString(4, product.getCategory());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        product.setId(rs.getInt(1));
                    }
                }
            }
        }
    }
    
    public static List<Product> searchProducts(Connection conn, String namePattern, 
                                                Double minPrice, Double maxPrice) 
            throws SQLException {
        
        List<Product> products = new ArrayList<>();
        
        // Dinamik WHERE clause
        StringBuilder sql = new StringBuilder("SELECT * FROM products WHERE 1=1");
        List<Object> params = new ArrayList<>();
        
        if (namePattern != null && !namePattern.isEmpty()) {
            sql.append(" AND name LIKE ?");
            params.add("%" + namePattern + "%");
        }
        
        if (minPrice != null) {
            sql.append(" AND price >= ?");
            params.add(minPrice);
        }
        
        if (maxPrice != null) {
            sql.append(" AND price <= ?");
            params.add(maxPrice);
        }
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql.toString())) {
            for (int i = 0; i < params.size(); i++) {
                pstmt.setObject(i + 1, params.get(i));
            }
            
            try (ResultSet rs = pstmt.executeQuery()) {
                while (rs.next()) {
                    products.add(mapToProduct(rs));
                }
            }
        }
        
        return products;
    }
    
    private static Product mapToProduct(ResultSet rs) throws SQLException {
        Product product = new Product();
        product.setId(rs.getInt("id"));
        product.setName(rs.getString("name"));
        product.setPrice(rs.getDouble("price"));
        product.setQuantity(rs.getInt("quantity"));
        product.setCategory(rs.getString("category"));
        product.setCreatedAt(rs.getTimestamp("created_at"));
        return product;
    }
}
```

---

## 1.7 ResultSet bilan Ishlas

### ResultSet Turlari

```java
// 1. ResultSet turlari
Statement stmt = conn.createStatement(
    ResultSet.TYPE_FORWARD_ONLY,    // Faqat oldinga (default)
    ResultSet.CONCUR_READ_ONLY      // Faqat o'qish (default)
);

Statement stmt = conn.createStatement(
    ResultSet.TYPE_SCROLL_INSENSITIVE,  // Har ikki tomonga, o'zgarishlar sezilmaydi
    ResultSet.CONCUR_UPDATABLE          // Yangilash mumkin
);

Statement stmt = conn.createStatement(
    ResultSet.TYPE_SCROLL_SENSITIVE,    // Har ikki tomonga, o'zgarishlar seziladi
    ResultSet.CONCUR_UPDATABLE
);
```

### ResultSet Metodlari

```java
public class ResultSetExample {
    
    public static void navigateResultSet(ResultSet rs) throws SQLException {
        // Oldinga harakat
        rs.next();           // keyingi qator
        rs.previous();       // oldingi qator
        rs.first();          // birinchi qator
        rs.last();           // oxirgi qator
        rs.absolute(5);      // 5-qatorga o'tish
        rs.relative(-2);     // 2 qator orqaga
        rs.beforeFirst();    // birinchi qatordan oldin
        rs.afterLast();      // oxirgi qatordan keyin
        
        // Holatni tekshirish
        rs.isFirst();        // birinchi qatormi?
        rs.isLast();         // oxirgi qatormi?
        rs.isBeforeFirst();  // birinchi qatordan oldinmi?
        rs.isAfterLast();    // oxirgi qatordan keyinmi?
        
        // Qator soni
        rs.getRow();         // joriy qator raqami
    }
    
    public static void updateResultSet(ResultSet rs) throws SQLException {
        // Yangilash mumkin bo'lgan ResultSet
        while (rs.next()) {
            double salary = rs.getDouble("salary");
            if (salary < 3000) {
                rs.updateDouble("salary", salary * 1.1); // 10% oshirish
                rs.updateRow(); // O'zgarishni bazaga yozish
            }
        }
    }
    
    public static void insertViaResultSet(ResultSet rs) throws SQLException {
        rs.moveToInsertRow();
        rs.updateString("name", "Yangi Mahsulot");
        rs.updateDouble("price", 99.99);
        rs.updateInt("quantity", 10);
        rs.insertRow();
        rs.moveToCurrentRow();
    }
    
    public static void deleteViaResultSet(ResultSet rs) throws SQLException {
        while (rs.next()) {
            int quantity = rs.getInt("quantity");
            if (quantity == 0) {
                rs.deleteRow();
            }
        }
    }
}
```

### ResultSetMetaData

```java
public class ResultSetMetaDataExample {
    
    public static void printResultSetInfo(ResultSet rs) throws SQLException {
        ResultSetMetaData meta = rs.getMetaData();
        
        // Kolonkalar soni
        int columnCount = meta.getColumnCount();
        System.out.println("Kolonkalar soni: " + columnCount);
        
        // Har bir kolonka haqida ma'lumot
        for (int i = 1; i <= columnCount; i++) {
            System.out.println("\n=== Kolonka " + i + " ===");
            System.out.println("Nomi: " + meta.getColumnName(i));
            System.out.println("Label: " + meta.getColumnLabel(i));
            System.out.println("Tipi: " + meta.getColumnTypeName(i));
            System.out.println("Hajmi: " + meta.getColumnDisplaySize(i));
            System.out.println("Precision: " + meta.getPrecision(i));
            System.out.println("Scale: " + meta.getScale(i));
            System.out.println("Nullable: " + meta.isNullable(i));
            System.out.println("Auto-increment: " + meta.isAutoIncrement(i));
        }
    }
}
```

---

## 1.8 Transaction Management

### Transaction (Tranzaksiya) nima?

Transaction - bir nechta SQL operatsiyalarini bitta atomik birlik sifatida bajarish. Agar bitta operatsiya muvaffaqiyatsiz bo'lsa, hammasi bekor qilinadi (rollback).

### ACID Printsipi

| Xususiyat | Tavsifi |
|-----------|---------|
| **Atomicity** | Hammasi yoki hech narsa |
| **Consistency** | Ma'lumotlar bazasi doim to'g'ri holatda |
| **Isolation** | Tranzaksiyalar bir-biridan mustaqil |
| **Durability** | Muvaffaqiyatli tranzaksiya saqlanadi |

```java
public class TransactionExample {
    
    // Bank pul o'tkazish misoli
    public static void transferMoney(Connection conn, int fromAccount, int toAccount, 
                                     double amount) throws SQLException {
        
        // Auto-commit ni o'chirish
        conn.setAutoCommit(false);
        
        try {
            // 1. Yuboruvchi hisobdan pul yechish
            String withdrawSql = "UPDATE accounts SET balance = balance - ? WHERE id = ? AND balance >= ?";
            try (PreparedStatement pstmt = conn.prepareStatement(withdrawSql)) {
                pstmt.setDouble(1, amount);
                pstmt.setInt(2, fromAccount);
                pstmt.setDouble(3, amount);
                
                int affectedRows = pstmt.executeUpdate();
                if (affectedRows == 0) {
                    throw new SQLException("Hisobda yetarli mablag' yo'q");
                }
            }
            
            // 2. Qabul qiluvchi hisobga pul qo'shish
            String depositSql = "UPDATE accounts SET balance = balance + ? WHERE id = ?";
            try (PreparedStatement pstmt = conn.prepareStatement(depositSql)) {
                pstmt.setDouble(1, amount);
                pstmt.setInt(2, toAccount);
                pstmt.executeUpdate();
            }
            
            // 3. Transaction log yozish
            String logSql = "INSERT INTO transactions (from_account, to_account, amount, status) VALUES (?, ?, ?, 'SUCCESS')";
            try (PreparedStatement pstmt = conn.prepareStatement(logSql)) {
                pstmt.setInt(1, fromAccount);
                pstmt.setInt(2, toAccount);
                pstmt.setDouble(3, amount);
                pstmt.executeUpdate();
            }
            
            // 4. Hammasi muvaffaqiyatli - commit
            conn.commit();
            System.out.println("Pul o'tkazmasi muvaffaqiyatli!");
            
        } catch (SQLException e) {
            // Xatolik yuz bersa - rollback
            conn.rollback();
            System.err.println("Pul o'tkazmasi bekor qilindi: " + e.getMessage());
            throw e;
        } finally {
            // Auto-commit ni qayta yoqish
            conn.setAutoCommit(true);
        }
    }
    
    // Transaction isolation level
    public static void demonstrateIsolationLevels(Connection conn) throws SQLException {
        
        // Isolation level'larni sozlash
        conn.setTransactionIsolation(Connection.TRANSACTION_READ_UNCOMMITTED);
        conn.setTransactionIsolation(Connection.TRANSACTION_READ_COMMITTED);
        conn.setTransactionIsolation(Connection.TRANSACTION_REPEATABLE_READ);
        conn.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
        
        // Joriy isolation level ni olish
        int level = conn.getTransactionIsolation();
        String levelName = "";
        
        switch (level) {
            case Connection.TRANSACTION_READ_UNCOMMITTED:
                levelName = "READ_UNCOMMITTED";
                break;
            case Connection.TRANSACTION_READ_COMMITTED:
                levelName = "READ_COMMITTED";
                break;
            case Connection.TRANSACTION_REPEATABLE_READ:
                levelName = "REPEATABLE_READ";
                break;
            case Connection.TRANSACTION_SERIALIZABLE:
                levelName = "SERIALIZABLE";
                break;
            default:
                levelName = "UNKNOWN";
        }
        
        System.out.println("Transaction isolation level: " + levelName);
    }
    
    // Savepoint bilan ishlash
    public static void useSavepoint(Connection conn) throws SQLException {
        conn.setAutoCommit(false);
        
        Savepoint savepoint = null;
        
        try {
            // 1. Birinchi operatsiya
            executeUpdate(conn, "INSERT INTO logs (message) VALUES ('Step 1 completed')");
            
            // Savepoint yaratish
            savepoint = conn.setSavepoint("AFTER_STEP_1");
            
            // 2. Ikkinchi operatsiya
            executeUpdate(conn, "INSERT INTO logs (message) VALUES ('Step 2 completed')");
            
            // 3. Uchinchi operatsiya (xatolik bo'lishi mumkin)
            executeUpdate(conn, "INSERT INTO logs (message) VALUES ('Step 3 attempted')");
            
            conn.commit();
            
        } catch (SQLException e) {
            if (savepoint != null) {
                // Faqat savepoint'dan keyingi operatsiyalarni bekor qilish
                conn.rollback(savepoint);
                System.out.println("Savepoint'ga qaytildi");
                
                // Qolgan operatsiyalarni bajarish
                executeUpdate(conn, "INSERT INTO logs (message) VALUES ('Recovery action')");
                conn.commit();
            } else {
                conn.rollback();
                System.out.println("Hamma operatsiyalar bekor qilindi");
            }
        } finally {
            conn.setAutoCommit(true);
        }
    }
    
    private static void executeUpdate(Connection conn, String sql) throws SQLException {
        try (Statement stmt = conn.createStatement()) {
            stmt.executeUpdate(sql);
        }
    }
}
```

---

## 1.9 Batch Processing

Ko'p sonli SQL so'rovlarni bir marta yuborish.

```java
public class BatchProcessingExample {
    
    // Batch INSERT
    public static void batchInsertProducts(Connection conn, List<Product> products) 
            throws SQLException {
        
        String sql = "INSERT INTO products (name, price, quantity, category) VALUES (?, ?, ?, ?)";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (Product product : products) {
                pstmt.setString(1, product.getName());
                pstmt.setDouble(2, product.getPrice());
                pstmt.setInt(3, product.getQuantity());
                pstmt.setString(4, product.getCategory());
                
                pstmt.addBatch();
            }
            
            // Barcha so'rovlarni bir marta yuborish
            int[] result = pstmt.executeBatch();
            
            int total = 0;
            for (int rows : result) {
                total += rows;
            }
            System.out.println("Jami " + total + " ta qator qo'shildi");
        }
    }
    
    // Batch UPDATE
    public static void batchUpdatePrices(Connection conn, Map<Integer, Double> priceUpdates) 
            throws SQLException {
        
        String sql = "UPDATE products SET price = ? WHERE id = ?";
        
        try (PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            for (Map.Entry<Integer, Double> entry : priceUpdates.entrySet()) {
                pstmt.setDouble(1, entry.getValue());
                pstmt.setInt(2, entry.getKey());
                pstmt.addBatch();
            }
            
            int[] result = pstmt.executeBatch();
            System.out.println("Yangilangan qatorlar: " + result.length);
        }
    }
    
    // Batch with transaction
    public static void batchWithTransaction(Connection conn, List<String> sqlStatements) 
            throws SQLException {
        
        conn.setAutoCommit(false);
        
        try (Statement stmt = conn.createStatement()) {
            
            for (String sql : sqlStatements) {
                stmt.addBatch(sql);
            }
            
            int[] result = stmt.executeBatch();
            
            // Tekshirish
            boolean hasError = false;
            for (int rows : result) {
                if (rows == Statement.EXECUTE_FAILED) {
                    hasError = true;
                    break;
                }
            }
            
            if (hasError) {
                conn.rollback();
                System.out.println("Batch bekor qilindi - xatolik bor");
            } else {
                conn.commit();
                System.out.println("Batch muvaffaqiyatli bajarildi");
            }
            
        } catch (SQLException e) {
            conn.rollback();
            throw e;
        } finally {
            conn.setAutoCommit(true);
        }
    }
}
```

---

## 1.10 Connection Pool

Connection pool - oldindan tayyorlangan database ulanishlar havzasi.

### HikariCP (Performance)

```xml
<dependency>
    <groupId>com.zaxxer</groupId>
    <artifactId>HikariCP</artifactId>
    <version>5.0.1</version>
</dependency>
```

```java
import com.zaxxer.hikari.HikariConfig;
import com.zaxxer.hikari.HikariDataSource;
import javax.sql.DataSource;

public class ConnectionPoolExample {
    
    private static HikariDataSource dataSource;
    
    static {
        HikariConfig config = new HikariConfig();
        config.setJdbcUrl("jdbc:postgresql://localhost:5432/school_db");
        config.setUsername("postgres");
        config.setPassword("password");
        config.setMaximumPoolSize(10);
        config.setMinimumIdle(5);
        config.setConnectionTimeout(30000);      // 30 sekund
        config.setIdleTimeout(600000);           // 10 minut
        config.setMaxLifetime(1800000);          // 30 minut
        config.setConnectionTestQuery("SELECT 1");
        
        dataSource = new HikariDataSource(config);
    }
    
    public static Connection getConnection() throws SQLException {
        return dataSource.getConnection();
    }
    
    public static DataSource getDataSource() {
        return dataSource;
    }
    
    public static void closePool() {
        if (dataSource != null && !dataSource.isClosed()) {
            dataSource.close();
        }
    }
}

// Foydalanish
public class UserDAO {
    
    public List<User> getAllUsers() throws SQLException {
        List<User> users = new ArrayList<>();
        
        try (Connection conn = ConnectionPoolExample.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery("SELECT * FROM users")) {
            
            while (rs.next()) {
                users.add(mapToUser(rs));
            }
        }
        
        return users;
    }
}
```

---

## 1.11 DAO Pattern

DAO (Data Access Object) - ma'lumotlar bazasi operatsiyalarini alohida qatlamga ajratish.

```java
// Entity
public class User {
    private int id;
    private String username;
    private String email;
    private String passwordHash;
    private LocalDateTime createdAt;
    
    // constructors, getters, setters
}

// DAO Interface
public interface UserDAO {
    User findById(int id) throws SQLException;
    User findByUsername(String username) throws SQLException;
    List<User> findAll() throws SQLException;
    User save(User user) throws SQLException;
    User update(User user) throws SQLException;
    boolean delete(int id) throws SQLException;
    boolean existsByEmail(String email) throws SQLException;
}

// DAO Implementation
public class UserDAOImpl implements UserDAO {
    
    private final DataSource dataSource;
    
    public UserDAOImpl(DataSource dataSource) {
        this.dataSource = dataSource;
    }
    
    @Override
    public User findById(int id) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, created_at FROM users WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapToUser(rs);
                }
            }
        }
        
        return null;
    }
    
    @Override
    public User findByUsername(String username) throws SQLException {
        String sql = "SELECT id, username, email, password_hash, created_at FROM users WHERE username = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, username);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return mapToUser(rs);
                }
            }
        }
        
        return null;
    }
    
    @Override
    public List<User> findAll() throws SQLException {
        List<User> users = new ArrayList<>();
        String sql = "SELECT id, username, email, password_hash, created_at FROM users ORDER BY id";
        
        try (Connection conn = dataSource.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            
            while (rs.next()) {
                users.add(mapToUser(rs));
            }
        }
        
        return users;
    }
    
    @Override
    public User save(User user) throws SQLException {
        String sql = "INSERT INTO users (username, email, password_hash) VALUES (?, ?, ?)";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPasswordHash());
            
            int affectedRows = pstmt.executeUpdate();
            
            if (affectedRows > 0) {
                try (ResultSet rs = pstmt.getGeneratedKeys()) {
                    if (rs.next()) {
                        user.setId(rs.getInt(1));
                        user.setCreatedAt(LocalDateTime.now());
                    }
                }
            }
        }
        
        return user;
    }
    
    @Override
    public User update(User user) throws SQLException {
        String sql = "UPDATE users SET username = ?, email = ?, password_hash = ? WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, user.getUsername());
            pstmt.setString(2, user.getEmail());
            pstmt.setString(3, user.getPasswordHash());
            pstmt.setInt(4, user.getId());
            
            pstmt.executeUpdate();
        }
        
        return user;
    }
    
    @Override
    public boolean delete(int id) throws SQLException {
        String sql = "DELETE FROM users WHERE id = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setInt(1, id);
            int affectedRows = pstmt.executeUpdate();
            return affectedRows > 0;
        }
    }
    
    @Override
    public boolean existsByEmail(String email) throws SQLException {
        String sql = "SELECT COUNT(*) FROM users WHERE email = ?";
        
        try (Connection conn = dataSource.getConnection();
             PreparedStatement pstmt = conn.prepareStatement(sql)) {
            
            pstmt.setString(1, email);
            
            try (ResultSet rs = pstmt.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1) > 0;
                }
            }
        }
        
        return false;
    }
    
    private User mapToUser(ResultSet rs) throws SQLException {
        User user = new User();
        user.setId(rs.getInt("id"));
        user.setUsername(rs.getString("username"));
        user.setEmail(rs.getString("email"));
        user.setPasswordHash(rs.getString("password_hash"));
        
        Timestamp timestamp = rs.getTimestamp("created_at");
        if (timestamp != null) {
            user.setCreatedAt(timestamp.toLocalDateTime());
        }
        
        return user;
    }
}
```

### Service Layer

```java
public class UserService {
    
    private final UserDAO userDAO;
    
    public UserService(UserDAO userDAO) {
        this.userDAO = userDAO;
    }
    
    public User registerUser(String username, String email, String password) 
            throws SQLException, IllegalArgumentException {
        
        // Validatsiya
        if (username == null || username.trim().isEmpty()) {
            throw new IllegalArgumentException("Username bo'sh bo'lishi mumkin emas");
        }
        
        if (!email.contains("@")) {
            throw new IllegalArgumentException("Email noto'g'ri formatda");
        }
        
        if (password == null || password.length() < 6) {
            throw new IllegalArgumentException("Parol kamida 6 belgi bo'lishi kerak");
        }
        
        // Email mavjudligini tekshirish
        if (userDAO.existsByEmail(email)) {
            throw new IllegalArgumentException("Bu email allaqachon ro'yxatdan o'tgan");
        }
        
        // Parolni hash qilish
        String passwordHash = hashPassword(password);
        
        // Foydalanuvchini yaratish
        User user = new User();
        user.setUsername(username);
        user.setEmail(email);
        user.setPasswordHash(passwordHash);
        
        return userDAO.save(user);
    }
    
    public User login(String email, String password) throws SQLException {
        // Email bo'yicha topish (simplified)
        // Aslida findByEmail metodi kerak
        
        // Parolni tekshirish
        // ...
        
        return null;
    }
    
    private String hashPassword(String password) {
        // SHA-256 yoki bcrypt
        return password; // For demo only
    }
}
```

---

## 1.12 JSTL SQL Tags

JSP sahifalarida to'g'ridan-to'g'ri SQL so'rovlar yuborish (tavsiya etilmaydi, faqat simple prototiplar uchun).

```jsp
<%@ taglib prefix="sql" uri="jakarta.tags.sql" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>

<!-- DataSource ni sozlash -->
<sql:setDataSource
    var="dataSource"
    driver="org.postgresql.Driver"
    url="jdbc:postgresql://localhost:5432/school_db"
    user="postgres"
    password="password"/>

<!-- SELECT so'rov -->
<sql:query var="result" dataSource="${dataSource}">
    SELECT id, name, age, email FROM students ORDER BY id
</sql:query>

<!-- Natijalarni chiqarish -->
<table border="1">
    <tr>
        <th>ID</th>
        <th>Name</th>
        <th>Age</th>
        <th>Email</th>
    </tr>
    <c:forEach var="row" items="${result.rows}">
        <tr>
            <td>${row.id}</td>
            <td>${row.name}</td>
            <td>${row.age}</td>
            <td>${row.email}</td>
        </tr>
    </c:forEach>
</table>

<!-- INSERT so'rov (parametrli) -->
<sql:update dataSource="${dataSource}" var="updateCount">
    INSERT INTO students (name, age, email) VALUES (?, ?, ?)
    <sql:param value="${param.name}"/>
    <sql:param value="${param.age}"/>
    <sql:param value="${param.email}"/>
</sql:update>

<!-- Transaction -->
<sql:transaction dataSource="${dataSource}">
    <sql:update>
        UPDATE accounts SET balance = balance - ? WHERE id = ?
        <sql:param value="${amount}"/>
        <sql:param value="${fromAccount}"/>
    </sql:update>
    <sql:update>
        UPDATE accounts SET balance = balance + ? WHERE id = ?
        <sql:param value="${amount}"/>
        <sql:param value="${toAccount}"/>
    </sql:update>
</sql:transaction>
```

---

## Tekshiruv Savollari

1. **JDBC nima va u qanday vazifalarni bajaradi?**
2. **JDBC driver turlari qanday?**
3. **Connection, Statement, PreparedStatement, ResultSet o'rtasidagi farq nima?**
4. **PreparedStatement nima uchun Statement'dan afzal?**
5. **ResultSet turlari qanday?**
6. **Transaction nima va ACID printsipi nimalardan iborat?**
7. **commit() va rollback() metodlari nima vazifani bajaradi?**
8. **Savepoint nima va qachon ishlatiladi?**
9. **Batch processing nima va qachon foydali?**
10. **Connection pool nima va nima uchun kerak?**
11. **DAO pattern nima va u qanday afzalliklarga ega?**
12. **SQL injection'dan qanday himoyalanish mumkin?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega JDBC ilovasini yarating:

1. **User CRUD** - foydalanuvchi qo'shish, o'qish, yangilash, o'chirish
2. **Product CRUD** - mahsulotlar bilan ishlash
3. **Order CRUD** - buyurtmalar (user va product bilan bog'langan)
4. **Transaction** - buyurtma yaratishda product stock'ini kamaytirish va buyurtma yozish
5. **Connection Pool** - HikariCP dan foydalanish
6. **Search** - mahsulotlarni nomi va narx oralig'i bo'yicha qidirish
7. **Pagination** - sahifalash (LIMIT va OFFSET)
8. **Reporting** - buyurtmalar bo'yicha statistika (jami summa, eng ko'p sotilgan mahsulot)

---

**Keyingi mavzu:** [Session, Cookie, Events, Init Parameters, Filter](./05_Session_Cookie_Filter.md)  
**[Mundarijaga qaytish](../README.md)**

> JDBC - Java va ma'lumotlar bazasi o'rtasidagi asosiy aloqa vositasi. Uni o'rganish orqali ma'lumotlarni saqlash va boshqarishni o'zlashtirasiz. 🚀
