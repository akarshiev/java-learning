# 1-Modul: Object-Relational Mapping (ORM) va Jakarta Persistence API (JPA)

## 1.1 ORM (Object-Relational Mapping) Nima?

**ORM (Object-Relational Mapping)** - Java obyektlari va ma'lumotlar bazasi jadvallari o'rtasidagi bog'liqlikni avtomatik boshqarish texnologiyasidir.

**Oddiy qilib aytganda:** JDBC da SQL so'rovlarni qo'lda yozib, natijalarni Java obyektlariga o'tkazish kerak edi. ORM esa bu ishni avtomatik bajaradi, siz faqat Java obyektlari bilan ishlaysiz, SQL bilan emas.

```
JDBC Approach:                 ORM Approach:

Java Object                     Java Object
     ↓                               ↓
   SQL String                     Entity (JPA)
     ↓                               ↓
  JDBC API                        ORM Provider
     ↓                               ↓
  ResultSet → Java Object        Database Table
     ↓
  Database Table
```

### Nima uchun ORM kerak?

| JDBC | ORM (JPA) |
|------|-----------|
| SQL yozish kerak | Faqat Java kodi yoziladi |
| ResultSet dan obyektga o'tkazish qo'lda | Avtomatik mapping |
| Connection, Statement, ResultSet boshqaruvi | EntityManager boshqaradi |
| Transaction qo'lda boshqarish | Avtomatik transaction |
| Database vendor'ga bog'liq SQL | Database independent |

### Mashhur ORM Tool'lar

| ORM Tool | Tavsifi |
|----------|---------|
| **Hibernate** | Eng mashhur ORM tool, Java EE da keng qo'llaniladi |
| **EclipseLink** | Jakarta EE ning default JPA implementatsiyasi |
| **OpenJPA** | Apache tomonidan ochiq manba implementatsiya |
| **MyBatis** | SQL mapper (to'liq ORM emas, ko'proq SQL ni boshqarish) |
| **Oracle TopLink** | Oracle tomonidan tijorat ORM tool |

---

## 1.2 Jakarta Persistence API (JPA)

### JPA nima?

**Jakarta Persistence API (JPA)** - ORM uchun standart API. JPA turli ORM provider'lar (Hibernate, EclipseLink) uchun umumiy interfeys bo'lib xizmat qiladi.

### JPA Arkitekturasi

```
┌─────────────────────────────────────────────────────────────┐
│                    Java Application                          │
├─────────────────────────────────────────────────────────────┤
│                    JPA API (jakarta.persistence)             │
│  ┌─────────────────────────────────────────────────────┐    │
│  │ EntityManager | EntityTransaction | Query | Criteria │    │
│  └─────────────────────────────────────────────────────┘    │
├─────────────────────────────────────────────────────────────┤
│                  JPA Provider (Hibernate/EclipseLink)        │
├─────────────────────────────────────────────────────────────┤
│                    JDBC Driver                               │
├─────────────────────────────────────────────────────────────┤
│                    Database                                  │
└─────────────────────────────────────────────────────────────┘
```

### JPA Provider'lar

| Provider | Tavsifi |
|----------|---------|
| **Hibernate** | Eng ko'p ishlatiladigan, JBoss/WildFly default |
| **EclipseLink** | Jakarta EE ning referent implementatsiyasi, GlassFish/Payara default |
| **OpenJPA** | Apache tomonidan, Geronimo, WebLogic da ishlatiladi |
| **TopLink** | Oracle tomonidan (eski) |

---

## 1.3 Entity (Ob'ekt) Yaratish

### Asosiy Entity

```java
import jakarta.persistence.*;
import jakarta.validation.constraints.*;
import java.time.LocalDateTime;
import java.util.Objects;

@Entity
@Table(name = "books")
public class Book {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(name = "title", nullable = false, length = 200)
    @NotNull
    @Size(min = 1, max = 200)
    private String title;
    
    @Column(name = "isbn", unique = true, length = 20)
    private String isbn;
    
    @Column(name = "price")
    private Double price;
    
    @Column(name = "published_date")
    private LocalDateTime publishedDate;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // Constructors
    public Book() {
        // JPA uchun default constructor kerak
    }
    
    public Book(String title, String isbn, Double price) {
        this.title = title;
        this.isbn = isbn;
        this.price = price;
        this.createdAt = LocalDateTime.now();
        this.updatedAt = LocalDateTime.now();
    }
    
    // Getters and Setters
    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    
    public String getTitle() { return title; }
    public void setTitle(String title) { this.title = title; }
    
    public String getIsbn() { return isbn; }
    public void setIsbn(String isbn) { this.isbn = isbn; }
    
    public Double getPrice() { return price; }
    public void setPrice(Double price) { this.price = price; }
    
    public LocalDateTime getPublishedDate() { return publishedDate; }
    public void setPublishedDate(LocalDateTime publishedDate) { this.publishedDate = publishedDate; }
    
    public LocalDateTime getCreatedAt() { return createdAt; }
    public void setCreatedAt(LocalDateTime createdAt) { this.createdAt = createdAt; }
    
    public LocalDateTime getUpdatedAt() { return updatedAt; }
    public void setUpdatedAt(LocalDateTime updatedAt) { this.updatedAt = updatedAt; }
    
    // equals va hashCode
    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (!(o instanceof Book)) return false;
        Book book = (Book) o;
        return Objects.equals(id, book.id);
    }
    
    @Override
    public int hashCode() {
        return Objects.hash(id);
    }
    
    @Override
    public String toString() {
        return String.format("Book{id=%d, title='%s', isbn='%s', price=%.2f}", 
                            id, title, isbn, price);
    }
}
```

### JPA Annotatsiyalari

| Annotation | Tavsifi | Misol |
|------------|---------|-------|
| `@Entity` | Class entity ekanligini belgilaydi | `@Entity` |
| `@Table` | Database jadval nomi | `@Table(name = "books")` |
| `@Id` | Primary key | `@Id` |
| `@GeneratedValue` | ID avtomatik generatsiya | `@GeneratedValue(strategy = GenerationType.IDENTITY)` |
| `@Column` | Kolonka xususiyatlari | `@Column(name = "title", nullable = false)` |
| `@Transient` | Database da saqlanmaydigan field | `@Transient` |
| `@Temporal` | Vaqt tipi (eski Java Date uchun) | `@Temporal(TemporalType.DATE)` |
| `@Lob` | Katta obyekt (BLOB/CLOB) | `@Lob` |
| `@Enumerated` | Enum tipi | `@Enumerated(EnumType.STRING)` |

### Relationship Annotatsiyalari

| Annotation | Tavsifi | Misol |
|------------|---------|-------|
| `@OneToOne` | Bir-bir bog'lanish | `@OneToOne(mappedBy = "address")` |
| `@OneToMany` | Bir-ko'p bog'lanish | `@OneToMany(mappedBy = "user")` |
| `@ManyToOne` | Ko'p-bir bog'lanish | `@ManyToOne @JoinColumn(name = "user_id")` |
| `@ManyToMany` | Ko'p-ko'p bog'lanish | `@ManyToMany @JoinTable(...)` |
| `@JoinColumn` | Foreign key | `@JoinColumn(name = "author_id")` |
| `@JoinTable` | Ko'p-ko'p uchun intermediate table | `@JoinTable(name = "book_category")` |

---

## 1.4 Persistence Unit

### persistence.xml fayli

`src/main/resources/META-INF/persistence.xml`:

```xml
<?xml version="1.0" encoding="UTF-8"?>
<persistence xmlns="https://jakarta.ee/xml/ns/persistence"
             xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
             xsi:schemaLocation="https://jakarta.ee/xml/ns/persistence 
             https://jakarta.ee/xml/ns/persistence/persistence_3_0.xsd"
             version="3.0">
    
    <!-- Persistence Unit -->
    <persistence-unit name="myappPU" transaction-type="RESOURCE_LOCAL">
        
        <!-- JPA Provider -->
        <provider>org.hibernate.jpa.HibernatePersistenceProvider</provider>
        
        <!-- Entity class'lar -->
        <class>com.example.entity.Book</class>
        <class>com.example.entity.Author</class>
        <class>com.example.entity.Category</class>
        
        <!-- Properties -->
        <properties>
            <!-- JDBC Connection -->
            <property name="jakarta.persistence.jdbc.driver" value="org.postgresql.Driver"/>
            <property name="jakarta.persistence.jdbc.url" value="jdbc:postgresql://localhost:5432/library_db"/>
            <property name="jakarta.persistence.jdbc.user" value="postgres"/>
            <property name="jakarta.persistence.jdbc.password" value="password"/>
            
            <!-- Hibernate specific properties -->
            <property name="hibernate.dialect" value="org.hibernate.dialect.PostgreSQLDialect"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.format_sql" value="true"/>
            <property name="hibernate.hbm2ddl.auto" value="update"/>
            
            <!-- Connection Pool -->
            <property name="hibernate.c3p0.min_size" value="5"/>
            <property name="hibernate.c3p0.max_size" value="20"/>
            <property name="hibernate.c3p0.timeout" value="300"/>
            <property name="hibernate.c3p0.max_statements" value="50"/>
            
            <!-- Second-level cache -->
            <property name="hibernate.cache.use_second_level_cache" value="true"/>
            <property name="hibernate.cache.region.factory_class" 
                      value="org.hibernate.cache.jcache.JCacheRegionFactory"/>
        </properties>
    </persistence-unit>
    
    <!-- JTA transaction type (Java EE application server'da) -->
    <persistence-unit name="myappPU-jta" transaction-type="JTA">
        <jta-data-source>java:/jdbc/libraryDS</jta-data-source>
        <properties>
            <property name="hibernate.dialect" value="org.hibernate.dialect.PostgreSQLDialect"/>
            <property name="hibernate.show_sql" value="true"/>
            <property name="hibernate.hbm2ddl.auto" value="validate"/>
        </properties>
    </persistence-unit>
    
</persistence>
```

### Schema Generation (Avtomatik Jadvallar Yaratish)

```xml
<properties>
    <!-- create: Jadvallarni yaratadi, eski jadvallarni o'chiradi -->
    <property name="jakarta.persistence.schema-generation.database.action" value="create"/>
    
    <!-- create-drop: create + application tugaganda o'chiradi -->
    <property name="jakarta.persistence.schema-generation.database.action" value="create-drop"/>
    
    <!-- update: Jadvallarni yangilaydi (o'chirmaydi) -->
    <property name="jakarta.persistence.schema-generation.database.action" value="update"/>
    
    <!-- validate: Jadvallarni tekshiradi, o'zgartirmaydi -->
    <property name="jakarta.persistence.schema-generation.database.action" value="validate"/>
    
    <!-- none: Hech narsa qilmaydi -->
    <property name="jakarta.persistence.schema-generation.database.action" value="none"/>
    
    <!-- SQL script orqali schema generatsiya -->
    <property name="jakarta.persistence.schema-generation.create-source" value="script"/>
    <property name="jakarta.persistence.schema-generation.create-script-source" 
              value="META-INF/create.sql"/>
    <property name="jakarta.persistence.schema-generation.drop-source" value="script"/>
    <property name="jakarta.persistence.schema-generation.drop-script-source" 
              value="META-INF/drop.sql"/>
</properties>
```

---

## 1.5 EntityManager bilan Ishlas

### EntityManager yaratish

```java
import jakarta.persistence.*;

public class EntityManagerUtil {
    
    private static final EntityManagerFactory emf;
    
    static {
        try {
            // Persistence unit nomi bilan EntityManagerFactory yaratish
            emf = Persistence.createEntityManagerFactory("myappPU");
        } catch (Throwable ex) {
            System.err.println("EntityManagerFactory creation failed: " + ex);
            throw new ExceptionInInitializerError(ex);
        }
    }
    
    public static EntityManager getEntityManager() {
        return emf.createEntityManager();
    }
    
    public static void close() {
        if (emf != null && emf.isOpen()) {
            emf.close();
        }
    }
}
```

### CRUD Operatsiyalari

```java
import jakarta.persistence.*;

public class BookDAO {
    
    // CREATE - Yangi kitob qo'shish
    public Book createBook(Book book) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            em.persist(book);
            tx.commit();
            return book;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Book creation failed", e);
        } finally {
            em.close();
        }
    }
    
    // READ - ID bo'yicha kitob o'qish
    public Book findBook(Long id) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            return em.find(Book.class, id);
        } finally {
            em.close();
        }
    }
    
    // READ - Barcha kitoblarni o'qish
    public List<Book> findAllBooks() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        try {
            TypedQuery<Book> query = em.createQuery(
                "SELECT b FROM Book b ORDER BY b.id", Book.class);
            return query.getResultList();
        } finally {
            em.close();
        }
    }
    
    // UPDATE - Kitobni yangilash
    public Book updateBook(Book book) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            Book managed = em.merge(book);
            tx.commit();
            return managed;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Book update failed", e);
        } finally {
            em.close();
        }
    }
    
    // DELETE - Kitobni o'chirish
    public boolean deleteBook(Long id) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            Book book = em.find(Book.class, id);
            if (book != null) {
                em.remove(book);
                tx.commit();
                return true;
            }
            tx.commit();
            return false;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Book deletion failed", e);
        } finally {
            em.close();
        }
    }
    
    // DELETE by JPQL
    public int deleteBooksByPrice(double maxPrice) {
        EntityManager em = EntityManagerUtil.getEntityManager();
        EntityTransaction tx = em.getTransaction();
        
        try {
            tx.begin();
            int deletedCount = em.createQuery(
                    "DELETE FROM Book b WHERE b.price <= :maxPrice")
                    .setParameter("maxPrice", maxPrice)
                    .executeUpdate();
            tx.commit();
            return deletedCount;
        } catch (Exception e) {
            if (tx.isActive()) {
                tx.rollback();
            }
            throw new RuntimeException("Batch deletion failed", e);
        } finally {
            em.close();
        }
    }
}
```

---

## 1.6 Entity States (Ob'ekt Holatlari)

JPA da entity 4 xil holatda bo'lishi mumkin:

```
┌─────────────────────────────────────────────────────────────┐
│                      Entity States                           │
├─────────────────────────────────────────────────────────────┤
│                                                              │
│   ┌──────────┐    persist()    ┌──────────┐                 │
│   │  NEW     │ ───────────────> │ MANAGED  │                 │
│   │(transient)│                 │          │                 │
│   └──────────┘                  └────┬─────┘                 │
│        ↑                            │                        │
│        │                            │ merge()                │
│        │                            ▼                        │
│   ┌──────────┐    clear()     ┌──────────┐                 │
│   │ DETACHED │ <───────────── │ MANAGED  │                 │
│   │          │    evict()      │          │                 │
│   └──────────┘                 └────┬─────┘                 │
│        │                            │                        │
│        │                            │ remove()               │
│        │                            ▼                        │
│   ┌──────────┐                 ┌──────────┐                 │
│   │ DETACHED │                 │ REMOVED  │                 │
│   │          │                 │          │                 │
│   └──────────┘                 └──────────┘                 │
│                                                              │
└─────────────────────────────────────────────────────────────┘
```

```java
public class EntityStateExample {
    
    public void demonstrateStates() {
        EntityManager em = EntityManagerUtil.getEntityManager();
        
        // 1. NEW (Transient) - Entity yaratilgan, JPA bilmaydi
        Book newBook = new Book("New Book", "123-456", 29.99);
        // newBook JPA tomonidan bilinmaydi
        
        // 2. MANAGED - persist() dan keyin
        em.getTransaction().begin();
        em.persist(newBook);  // newBook MANAGED holatga o'tadi
        // O'zgarishlar commit() da bazaga yoziladi
        em.getTransaction().commit();
        // newBook hali MANAGED (ID bor, entity manager biladi)
        
        // 3. DETACHED - clear(), evict() yoki close() dan keyin
        em.clear();  // Barcha entity'larni MANAGED dan DETACHED ga o'tkazadi
        // newBook DETACHED - JPA bilmaydi, o'zgarishlar avtomatik saqlanmaydi
        
        // 4. MERGE - DETACHED ni MANAGED ga qaytarish
        newBook.setPrice(39.99);  // DETACHED, o'zgarish saqlanmaydi
        
        em.getTransaction().begin();
        Book merged = em.merge(newBook);  // DETACHED -> MANAGED
        em.getTransaction().commit();
        // O'zgarishlar bazaga yoziladi
        
        // 5. REMOVED - remove() dan keyin
        em.getTransaction().begin();
        em.remove(merged);  // REMOVED holat
        em.getTransaction().commit();  // Bazadan o'chiriladi
        // merged REMOVED, transaction commit dan keyin DETACHED
    }
}
```

---

## 1.7 Relationship Mapping (Bog'lanishlar)

### @OneToMany va @ManyToOne

```java
// Author.java
@Entity
@Table(name = "authors")
public class Author {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false)
    private String name;
    
    private String email;
    
    // One-to-Many relationship (bir author ko'p kitob yozishi mumkin)
    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Book> books = new ArrayList<>();
    
    // Helper method
    public void addBook(Book book) {
        books.add(book);
        book.setAuthor(this);
    }
    
    public void removeBook(Book book) {
        books.remove(book);
        book.setAuthor(null);
    }
    
    // getters, setters
}

// Book.java (yangilangan)
@Entity
@Table(name = "books")
public class Book {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String title;
    
    private Double price;
    
    // Many-to-One relationship (ko'p kitob bitta author'ga tegishli)
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id")
    private Author author;
    
    // getters, setters
}
```

### @OneToOne

```java
// Address.java
@Entity
@Table(name = "addresses")
public class Address {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String street;
    private String city;
    private String country;
    private String zipCode;
    
    @OneToOne(mappedBy = "address")
    private User user;
}

// User.java
@Entity
@Table(name = "users")
public class User {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String username;
    private String email;
    
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "address_id")
    private Address address;
}
```

### @ManyToMany

```java
// Category.java
@Entity
@Table(name = "categories")
public class Category {
    
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String description;
    
    // Many-to-Many relationship
    @ManyToMany(mappedBy = "categories")
    private List<Book> books = new ArrayList<>();
}

// Book.java (yangilangan)
@Entity
@Table(name = "books")
public class Book {
    
    // ... other fields
    
    @ManyToMany
    @JoinTable(
        name = "book_category",
        joinColumns = @JoinColumn(name = "book_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private List<Category> categories = new ArrayList<>();
    
    // Helper methods
    public void addCategory(Category category) {
        categories.add(category);
        category.getBooks().add(this);
    }
    
    public void removeCategory(Category category) {
        categories.remove(category);
        category.getBooks().remove(this);
    }
}
```

### Cascade Types

```java
// Cascade turlari
public enum CascadeType {
    ALL,      // Barcha operatsiyalar
    PERSIST,  // Faqat persist
    MERGE,    // Faqat merge
    REMOVE,   // Faqat remove
    REFRESH,  // Faqat refresh
    DETACH    // Faqat detach
}

// Ishlatish
@OneToMany(mappedBy = "author", cascade = CascadeType.ALL, orphanRemoval = true)
private List<Book> books = new ArrayList<>();

// orphanRemoval = true - parent o'chirilsa, children ham o'chadi
```

### Fetch Types

```java
// Fetch turlari
public enum FetchType {
    LAZY,   // Kerak bo'lganda yuklanadi (default @OneToMany, @ManyToMany)
    EAGER   // Darhol yuklanadi (default @ManyToOne, @OneToOne)
}

// Ishlatish
@ManyToOne(fetch = FetchType.LAZY)
@JoinColumn(name = "author_id")
private Author author;
```

---

## 1.8 JPQL (Jakarta Persistence Query Language)

### JPQL Asoslari

JPQL - SQL ga o'xshash, lekin jadvallar o'rniga entity class'lar va field'lar bilan ishlaydi.

```java
public class JPQLExamples {
    
    private final EntityManager em;
    
    public JPQLExamples(EntityManager em) {
        this.em = em;
    }
    
    // 1. SELECT query - barcha kitoblar
    public List<Book> getAllBooks() {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b ORDER BY b.id", Book.class);
        return query.getResultList();
    }
    
    // 2. SELECT with WHERE
    public List<Book> getBooksByPrice(double minPrice) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b WHERE b.price > :minPrice", Book.class);
        query.setParameter("minPrice", minPrice);
        return query.getResultList();
    }
    
    // 3. SELECT with LIKE
    public List<Book> searchBooksByTitle(String keyword) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b WHERE LOWER(b.title) LIKE LOWER(:keyword)", 
            Book.class);
        query.setParameter("keyword", "%" + keyword + "%");
        return query.getResultList();
    }
    
    // 4. SELECT with JOIN
    public List<Book> getBooksByAuthor(String authorName) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b JOIN b.author a WHERE a.name = :authorName", 
            Book.class);
        query.setParameter("authorName", authorName);
        return query.getResultList();
    }
    
    // 5. SELECT with aggregate functions
    public double getAveragePrice() {
        Query query = em.createQuery(
            "SELECT AVG(b.price) FROM Book b");
        return (Double) query.getSingleResult();
    }
    
    // 6. SELECT with GROUP BY
    public List<Object[]> getBookCountByAuthor() {
        Query query = em.createQuery(
            "SELECT a.name, COUNT(b) FROM Author a LEFT JOIN a.books b " +
            "GROUP BY a.name ORDER BY COUNT(b) DESC");
        return query.getResultList();
    }
    
    // 7. SELECT with pagination
    public List<Book> getBooksWithPagination(int page, int pageSize) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b ORDER BY b.id", Book.class);
        query.setFirstResult((page - 1) * pageSize);
        query.setMaxResults(pageSize);
        return query.getResultList();
    }
    
    // 8. SELECT with named query
    public List<Book> getExpensiveBooks() {
        TypedQuery<Book> query = em.createNamedQuery("Book.findExpensive", Book.class);
        query.setParameter("minPrice", 50.0);
        return query.getResultList();
    }
    
    // 9. UPDATE query
    public int applyDiscount(double percentage) {
        Query query = em.createQuery(
            "UPDATE Book b SET b.price = b.price * (1 - :percentage) " +
            "WHERE b.price > 0");
        query.setParameter("percentage", percentage);
        return query.executeUpdate();
    }
    
    // 10. DELETE query
    public int deleteOldBooks() {
        Query query = em.createQuery(
            "DELETE FROM Book b WHERE b.publishedDate < :date");
        query.setParameter("date", LocalDateTime.now().minusYears(10));
        return query.executeUpdate();
    }
    
    // 11. Projection - faqat kerakli field'lar
    public List<Object[]> getBookTitlesAndPrices() {
        Query query = em.createQuery(
            "SELECT b.title, b.price FROM Book b");
        return query.getResultList();
    }
    
    // 12. Constructor expression
    public List<BookSummary> getBookSummaries() {
        TypedQuery<BookSummary> query = em.createQuery(
            "SELECT new com.example.dto.BookSummary(b.id, b.title, a.name) " +
            "FROM Book b JOIN b.author a", BookSummary.class);
        return query.getResultList();
    }
    
    // 13. IN operator
    public List<Book> getBooksInCategories(List<String> categoryNames) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT DISTINCT b FROM Book b JOIN b.categories c " +
            "WHERE c.name IN :categories", Book.class);
        query.setParameter("categories", categoryNames);
        return query.getResultList();
    }
    
    // 14. BETWEEN operator
    public List<Book> getBooksInPriceRange(double min, double max) {
        TypedQuery<Book> query = em.createQuery(
            "SELECT b FROM Book b WHERE b.price BETWEEN :min AND :max", 
            Book.class);
        query.setParameter("min", min);
        query.setParameter("max", max);
        return query.getResultList();
    }
    
    // 15. EXISTS
    public List<Author> getAuthorsWithBooks() {
        TypedQuery<Author> query = em.createQuery(
            "SELECT a FROM Author a WHERE EXISTS " +
            "(SELECT b FROM Book b WHERE b.author = a)", 
            Author.class);
        return query.getResultList();
    }
}
```

### Named Queries

```java
// Entity'da named query'lar
@Entity
@Table(name = "books")
@NamedQueries({
    @NamedQuery(
        name = "Book.findAll",
        query = "SELECT b FROM Book b ORDER BY b.id"
    ),
    @NamedQuery(
        name = "Book.findByPrice",
        query = "SELECT b FROM Book b WHERE b.price > :price"
    ),
    @NamedQuery(
        name = "Book.findByTitle",
        query = "SELECT b FROM Book b WHERE b.title LIKE :title"
    ),
    @NamedQuery(
        name = "Book.findExpensive",
        query = "SELECT b FROM Book b WHERE b.price > :minPrice"
    ),
    @NamedQuery(
        name = "Book.count",
        query = "SELECT COUNT(b) FROM Book b"
    )
})
public class Book {
    // ...
}

// Ishlatish
public class NamedQueryExample {
    
    public List<Book> findAllBooks(EntityManager em) {
        return em.createNamedQuery("Book.findAll", Book.class)
                 .getResultList();
    }
    
    public List<Book> findByPrice(EntityManager em, double price) {
        return em.createNamedQuery("Book.findByPrice", Book.class)
                 .setParameter("price", price)
                 .getResultList();
    }
    
    public long getBookCount(EntityManager em) {
        return em.createNamedQuery("Book.count", Long.class)
                 .getSingleResult();
    }
}
```

### Native SQL Queries

```java
public class NativeSQLExample {
    
    private final EntityManager em;
    
    public NativeSQLExample(EntityManager em) {
        this.em = em;
    }
    
    // Native SQL query
    public List<Book> findBooksByPriceNative(double minPrice) {
        Query query = em.createNativeQuery(
            "SELECT * FROM books WHERE price > ?1", Book.class);
        query.setParameter(1, minPrice);
        return query.getResultList();
    }
    
    // Native SQL with result mapping
    @SuppressWarnings("unchecked")
    public List<Object[]> getAuthorStats() {
        Query query = em.createNativeQuery(
            "SELECT a.name, COUNT(b.id), AVG(b.price) " +
            "FROM authors a LEFT JOIN books b ON a.id = b.author_id " +
            "GROUP BY a.name");
        return query.getResultList();
    }
    
    // Native SQL update
    public int updatePricesNative(double percentage) {
        Query query = em.createNativeQuery(
            "UPDATE books SET price = price * ?1");
        query.setParameter(1, 1 - percentage);
        return query.executeUpdate();
    }
}
```

---

## 1.9 Criteria API

```java
import jakarta.persistence.criteria.*;

public class CriteriaAPIExample {
    
    private final EntityManager em;
    private final CriteriaBuilder cb;
    
    public CriteriaAPIExample(EntityManager em) {
        this.em = em;
        this.cb = em.getCriteriaBuilder();
    }
    
    // 1. Simple select
    public List<Book> getAllBooks() {
        CriteriaQuery<Book> query = cb.createQuery(Book.class);
        Root<Book> book = query.from(Book.class);
        query.select(book);
        query.orderBy(cb.asc(book.get("id")));
        return em.createQuery(query).getResultList();
    }
    
    // 2. Select with conditions
    public List<Book> getExpensiveBooks(double minPrice) {
        CriteriaQuery<Book> query = cb.createQuery(Book.class);
        Root<Book> book = query.from(Book.class);
        
        Predicate priceCondition = cb.gt(book.get("price"), minPrice);
        query.select(book).where(priceCondition);
        
        return em.createQuery(query).getResultList();
    }
    
    // 3. Select with multiple conditions
    public List<Book> searchBooks(String titleKeyword, Double minPrice, Double maxPrice) {
        CriteriaQuery<Book> query = cb.createQuery(Book.class);
        Root<Book> book = query.from(Book.class);
        
        List<Predicate> predicates = new ArrayList<>();
        
        if (titleKeyword != null && !titleKeyword.isEmpty()) {
            predicates.add(cb.like(cb.lower(book.get("title")), 
                                  "%" + titleKeyword.toLowerCase() + "%"));
        }
        if (minPrice != null) {
            predicates.add(cb.ge(book.get("price"), minPrice));
        }
        if (maxPrice != null) {
            predicates.add(cb.le(book.get("price"), maxPrice));
        }
        
        query.select(book).where(predicates.toArray(new Predicate[0]));
        return em.createQuery(query).getResultList();
    }
    
    // 4. Join query
    public List<Book> getBooksByAuthor(String authorName) {
        CriteriaQuery<Book> query = cb.createQuery(Book.class);
        Root<Book> book = query.from(Book.class);
        Join<Book, Author> author = book.join("author");
        
        Predicate condition = cb.equal(author.get("name"), authorName);
        query.select(book).where(condition);
        
        return em.createQuery(query).getResultList();
    }
    
    // 5. Aggregate functions
    public double getAveragePrice() {
        CriteriaQuery<Double> query = cb.createQuery(Double.class);
        Root<Book> book = query.from(Book.class);
        query.select(cb.avg(book.get("price")));
        return em.createQuery(query).getSingleResult();
    }
    
    // 6. Group by
    public List<Object[]> getBookCountByAuthor() {
        CriteriaQuery<Object[]> query = cb.createQuery(Object[].class);
        Root<Book> book = query.from(Book.class);
        Join<Book, Author> author = book.join("author");
        
        query.multiselect(author.get("name"), cb.count(book));
        query.groupBy(author.get("name"));
        query.orderBy(cb.desc(cb.count(book)));
        
        return em.createQuery(query).getResultList();
    }
    
    // 7. Dynamic query builder
    public List<Book> dynamicSearch(BookSearchCriteria criteria) {
        CriteriaQuery<Book> query = cb.createQuery(Book.class);
        Root<Book> book = query.from(Book.class);
        
        List<Predicate> predicates = new ArrayList<>();
        
        if (criteria.getTitle() != null) {
            predicates.add(cb.like(book.get("title"), "%" + criteria.getTitle() + "%"));
        }
        
        if (criteria.getMinPrice() != null) {
            predicates.add(cb.ge(book.get("price"), criteria.getMinPrice()));
        }
        
        if (criteria.getMaxPrice() != null) {
            predicates.add(cb.le(book.get("price"), criteria.getMaxPrice()));
        }
        
        if (criteria.getAuthorName() != null) {
            Join<Book, Author> author = book.join("author");
            predicates.add(cb.equal(author.get("name"), criteria.getAuthorName()));
        }
        
        query.select(book).where(predicates.toArray(new Predicate[0]));
        
        if (criteria.getSortBy() != null) {
            if (criteria.isAscending()) {
                query.orderBy(cb.asc(book.get(criteria.getSortBy())));
            } else {
                query.orderBy(cb.desc(book.get(criteria.getSortBy())));
            }
        }
        
        return em.createQuery(query)
                 .setFirstResult(criteria.getOffset())
                 .setMaxResults(criteria.getLimit())
                 .getResultList();
    }
}

// Search criteria class
class BookSearchCriteria {
    private String title;
    private Double minPrice;
    private Double maxPrice;
    private String authorName;
    private String sortBy;
    private boolean ascending = true;
    private int offset = 0;
    private int limit = 10;
    
    // getters and setters
}
```

---

## 1.10 To'liq Misol: Library Management System

### Entity Class'lar

```java
// Author.java
@Entity
@Table(name = "authors")
@NamedQueries({
    @NamedQuery(name = "Author.findAll", query = "SELECT a FROM Author a"),
    @NamedQuery(name = "Author.findByName", query = "SELECT a FROM Author a WHERE a.name LIKE :name")
})
public class Author {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 100)
    private String name;
    
    @Column(length = 100)
    private String email;
    
    @OneToMany(mappedBy = "author", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Book> books = new ArrayList<>();
    
    // constructors, getters, setters
    // helper methods
    public void addBook(Book book) {
        books.add(book);
        book.setAuthor(this);
    }
}

// Category.java
@Entity
@Table(name = "categories")
public class Category {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(unique = true, nullable = false, length = 50)
    private String name;
    
    private String description;
    
    @ManyToMany(mappedBy = "categories")
    private List<Book> books = new ArrayList<>();
    
    // constructors, getters, setters
}

// Book.java
@Entity
@Table(name = "books")
@NamedQueries({
    @NamedQuery(name = "Book.findAll", query = "SELECT b FROM Book b ORDER BY b.id"),
    @NamedQuery(name = "Book.findByTitle", query = "SELECT b FROM Book b WHERE b.title LIKE :title"),
    @NamedQuery(name = "Book.findByPriceRange", 
                query = "SELECT b FROM Book b WHERE b.price BETWEEN :min AND :max"),
    @NamedQuery(name = "Book.findByAuthorId", 
                query = "SELECT b FROM Book b WHERE b.author.id = :authorId"),
    @NamedQuery(name = "Book.countByCategory", 
                query = "SELECT c.name, COUNT(b) FROM Category c LEFT JOIN c.books b GROUP BY c.name")
})
public class Book {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @Column(nullable = false, length = 200)
    private String title;
    
    @Column(unique = true, length = 20)
    private String isbn;
    
    private Double price;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "author_id")
    private Author author;
    
    @ManyToMany
    @JoinTable(
        name = "book_category",
        joinColumns = @JoinColumn(name = "book_id"),
        inverseJoinColumns = @JoinColumn(name = "category_id")
    )
    private List<Category> categories = new ArrayList<>();
    
    @Column(name = "published_date")
    private LocalDate publishedDate;
    
    @Column(name = "created_at")
    private LocalDateTime createdAt;
    
    @Column(name = "updated_at")
    private LocalDateTime updatedAt;
    
    // constructors, getters, setters
    // helper methods
    public void addCategory(Category category) {
        categories.add(category);
        category.getBooks().add(this);
    }
}
```

### Repository Class

```java
// BookRepository.java
@Repository
public class BookRepository {
    
    @PersistenceContext
    private EntityManager em;
    
    // CRUD
    public Book save(Book book) {
        if (book.getId() == null) {
            book.setCreatedAt(LocalDateTime.now());
            em.persist(book);
            return book;
        } else {
            book.setUpdatedAt(LocalDateTime.now());
            return em.merge(book);
        }
    }
    
    public Optional<Book> findById(Long id) {
        Book book = em.find(Book.class, id);
        return Optional.ofNullable(book);
    }
    
    public List<Book> findAll() {
        return em.createNamedQuery("Book.findAll", Book.class)
                 .getResultList();
    }
    
    public List<Book> findByTitle(String title) {
        return em.createNamedQuery("Book.findByTitle", Book.class)
                 .setParameter("title", "%" + title + "%")
                 .getResultList();
    }
    
    public List<Book> findByPriceRange(double min, double max) {
        return em.createNamedQuery("Book.findByPriceRange", Book.class)
                 .setParameter("min", min)
                 .setParameter("max", max)
                 .getResultList();
    }
    
    public List<Book> findByAuthorId(Long authorId) {
        return em.createNamedQuery("Book.findByAuthorId", Book.class)
                 .setParameter("authorId", authorId)
                 .getResultList();
    }
    
    public void delete(Book book) {
        em.remove(em.contains(book) ? book : em.merge(book));
    }
    
    public void deleteById(Long id) {
        findById(id).ifPresent(this::delete);
    }
    
    // JPQL methods
    public long count() {
        return em.createNamedQuery("Book.count", Long.class)
                 .getSingleResult();
    }
    
    public List<Object[]> countByCategory() {
        return em.createNamedQuery("Book.countByCategory", Object[].class)
                 .getResultList();
    }
    
    public double getAveragePrice() {
        return em.createQuery("SELECT AVG(b.price) FROM Book b", Double.class)
                 .getSingleResult();
    }
    
    public List<Book> getRecentlyAdded(int limit) {
        return em.createQuery(
            "SELECT b FROM Book b ORDER BY b.createdAt DESC", Book.class)
                 .setMaxResults(limit)
                 .getResultList();
    }
}
```

### Service Class

```java
// BookService.java
@Service
@Transactional
public class BookService {
    
    @Autowired
    private BookRepository bookRepository;
    
    @Autowired
    private AuthorRepository authorRepository;
    
    @Autowired
    private CategoryRepository categoryRepository;
    
    public Book createBook(BookDTO dto) {
        Book book = new Book();
        book.setTitle(dto.getTitle());
        book.setIsbn(dto.getIsbn());
        book.setPrice(dto.getPrice());
        book.setPublishedDate(dto.getPublishedDate());
        
        // Set author
        if (dto.getAuthorId() != null) {
            Author author = authorRepository.findById(dto.getAuthorId())
                .orElseThrow(() -> new EntityNotFoundException("Author not found"));
            book.setAuthor(author);
        }
        
        // Set categories
        if (dto.getCategoryIds() != null) {
            for (Long categoryId : dto.getCategoryIds()) {
                Category category = categoryRepository.findById(categoryId)
                    .orElseThrow(() -> new EntityNotFoundException("Category not found"));
                book.addCategory(category);
            }
        }
        
        return bookRepository.save(book);
    }
    
    public Book updateBook(Long id, BookDTO dto) {
        Book book = bookRepository.findById(id)
            .orElseThrow(() -> new EntityNotFoundException("Book not found"));
        
        book.setTitle(dto.getTitle());
        book.setIsbn(dto.getIsbn());
        book.setPrice(dto.getPrice());
        book.setPublishedDate(dto.getPublishedDate());
        
        return bookRepository.save(book);
    }
    
    public List<Book> searchBooks(String title, Double minPrice, Double maxPrice, Long authorId) {
        return bookRepository.searchBooks(title, minPrice, maxPrice, authorId);
    }
    
    public void deleteBook(Long id) {
        bookRepository.deleteById(id);
    }
    
    public List<Book> getRecentBooks(int count) {
        return bookRepository.getRecentlyAdded(count);
    }
    
    public Map<String, Object> getStatistics() {
        Map<String, Object> stats = new HashMap<>();
        stats.put("totalBooks", bookRepository.count());
        stats.put("averagePrice", bookRepository.getAveragePrice());
        stats.put("booksByCategory", bookRepository.countByCategory());
        return stats;
    }
}
```

---

## Tekshiruv Savollari

1. **ORM nima va u qanday muammolarni hal qiladi?**
2. **JPA nima va u ORM dan qanday farq qiladi?**
3. **Entity nima? Entity class qanday shartlarni qanoatlantirishi kerak?**
4. **@Id va @GeneratedValue annotatsiyalari nima vazifani bajaradi?**
5. **@OneToMany, @ManyToOne, @OneToOne, @ManyToMany annotatsiyalarini tushuntiring.**
6. **CascadeType va FetchType turlari qanday?**
7. **EntityManager nima va u qanday vazifalarni bajaradi?**
8. **Entity holatlari (states) qanday?**
9. **JPQL nima va SQL dan qanday farq qiladi?**
10. **NamedQuery nima va qanday afzalliklari bor?**
11. **Criteria API nima va qachon ishlatiladi?**
12. **Persistence unit nima va qanday konfiguratsiya qilinadi?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega JPA asosidagi ilova yarating:

1. **Entity class'lar** - Student, Course, Enrollment (ko'p-ko'p bog'lanish)
2. **CRUD operatsiyalari** - har bir entity uchun
3. **JPQL queries** - turli xil so'rovlar (filter, search, aggregation)
4. **Named queries** - entity class'ida belgilash
5. **Criteria API** - dinamik qidiruv
6. **Transaction management** - to'g'ri transaction boshqaruvi
7. **Relationship mapping** - barcha bog'lanish turlari

---

**Keyingi mavzu:** [Jakarta Persistence API Part II](./08_JPA_Part2.md)  
**[Mundarijaga qaytish](../README.md)**

> JPA - Java va ma'lumotlar bazasi o'rtasidagi eng kuchli abstraktsiya. Uni o'rganish orqali ma'lumotlar bilan ishlashni ancha soddalashtirasiz. 🚀
