# 1-Modul: Jakarta Persistence API (JPA) - II Qism

## 1.8 Jakarta Persistence Query Language (JPQL)

### JPQL nima?

**JPQL (Jakarta Persistence Query Language)** - JPA da ma'lumotlar bazasiga SQL o'rniga Java obyektlari ustida so'rovlar yozish imkonini beruvchi query tili. JPQL SQL dan farqli ravishda jadvallar (tables) o'rniga entity class'lar va ularning field'lariga murojaat qiladi.

```java
// SQL - jadvallarga murojaat
SELECT * FROM employees WHERE age > 30

// JPQL - entity class'larga murojaat
SELECT e FROM Employee e WHERE e.age > 30
```

### JPQL vs SQL

| Xususiyat | SQL | JPQL |
|-----------|-----|------|
| **Target** | Ma'lumotlar bazasi jadvallari | Entity class'lar |
| **Syntax** | `SELECT * FROM table` | `SELECT e FROM Entity e` |
| **Joins** | `JOIN table ON condition` | `JOIN e.relatedEntity` |
| **Polymorphism** | Yo'q | Ha (inheritance) |
| **Database independence** | Database-ga bog'liq | Database-dan mustaqil |

### Named Query

```java
import jakarta.persistence.*;
import java.util.List;

@Entity
@NamedQueries({
    @NamedQuery(
        name = "User.findByEmail",
        query = "SELECT u FROM User u WHERE u.email = :email"
    ),
    @NamedQuery(
        name = "User.findByAgeGreaterThan",
        query = "SELECT u FROM User u WHERE u.age > :age"
    ),
    @NamedQuery(
        name = "User.findByRole",
        query = "SELECT u FROM User u WHERE u.role = :role ORDER BY u.createdAt DESC"
    ),
    @NamedQuery(
        name = "User.countByRole",
        query = "SELECT COUNT(u) FROM User u WHERE u.role = :role"
    )
})
public class User {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String email;
    private Integer age;
    private String role;
    private LocalDateTime createdAt;
    
    // constructors, getters, setters
}

// Named Query'ni ishlatish
@Stateless
public class UserService {
    
    @PersistenceContext
    private EntityManager em;
    
    public User findByEmail(String email) {
        try {
            return em.createNamedQuery("User.findByEmail", User.class)
                .setParameter("email", email)
                .getSingleResult();
        } catch (NoResultException e) {
            return null;
        }
    }
    
    public List<User> findByAgeGreaterThan(int age) {
        return em.createNamedQuery("User.findByAgeGreaterThan", User.class)
            .setParameter("age", age)
            .getResultList();
    }
    
    public List<User> findByRole(String role) {
        return em.createNamedQuery("User.findByRole", User.class)
            .setParameter("role", role)
            .getResultList();
    }
    
    public long countByRole(String role) {
        return em.createNamedQuery("User.countByRole", Long.class)
            .setParameter("role", role)
            .getSingleResult();
    }
}
```

---

## 1.9 Relationship Turlari

### A) One-to-One (1:1) Relationship

Bir entity boshqa bir entity bilan aniq bir bog'lanishga ega bo'lganda ishlatiladi.

```java
// Unidirectional One-to-One
@Entity
public class Person {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @OneToOne(cascade = CascadeType.ALL)
    @JoinColumn(name = "passport_id", unique = true)
    private Passport passport;
    
    // getters, setters
}

@Entity
public class Passport {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String passportNumber;
    private LocalDate issueDate;
    private LocalDate expiryDate;
    
    // getters, setters
}

// Bidirectional One-to-One
@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @OneToOne(mappedBy = "employee", cascade = CascadeType.ALL)
    private Desk desk;
    
    // getters, setters
}

@Entity
public class Desk {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String deskNumber;
    private String location;
    
    @OneToOne
    @JoinColumn(name = "employee_id")
    private Employee employee;
    
    // getters, setters
}

// Ishlatish
@Stateless
public class EmployeeService {
    
    @PersistenceContext
    private EntityManager em;
    
    public void createEmployeeWithDesk() {
        Employee employee = new Employee();
        employee.setName("Ali Valiyev");
        
        Desk desk = new Desk();
        desk.setDeskNumber("A-101");
        desk.setLocation("Floor 1");
        desk.setEmployee(employee);
        
        employee.setDesk(desk);
        
        em.persist(employee);
    }
    
    public Desk getEmployeeDesk(Long employeeId) {
        Employee employee = em.find(Employee.class, employeeId);
        return employee != null ? employee.getDesk() : null;
    }
}
```

### B) One-to-Many (1:N) va Many-to-One (N:1)

Bir entity bir nechta boshqa entity'larga ega bo'lganda ishlatiladi.

```java
// One-to-Many (owner)
@Entity
public class Department {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String location;
    
    @OneToMany(mappedBy = "department", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    private List<Employee> employees = new ArrayList<>();
    
    // Helper methods
    public void addEmployee(Employee employee) {
        employees.add(employee);
        employee.setDepartment(this);
    }
    
    public void removeEmployee(Employee employee) {
        employees.remove(employee);
        employee.setDepartment(null);
    }
    
    // getters, setters
}

// Many-to-One (owned)
@Entity
public class Employee {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String email;
    private Double salary;
    
    @ManyToOne
    @JoinColumn(name = "department_id")
    private Department department;
    
    // getters, setters
}

// Ishlatish
@Stateless
public class DepartmentService {
    
    @PersistenceContext
    private EntityManager em;
    
    public Department createDepartmentWithEmployees() {
        Department dept = new Department();
        dept.setName("IT Department");
        dept.setLocation("Floor 3");
        
        Employee emp1 = new Employee();
        emp1.setName("Ali Valiyev");
        emp1.setEmail("ali@example.com");
        emp1.setSalary(5000.0);
        
        Employee emp2 = new Employee();
        emp2.setName("Guli Karimova");
        emp2.setEmail("guli@example.com");
        emp2.setSalary(5500.0);
        
        dept.addEmployee(emp1);
        dept.addEmployee(emp2);
        
        em.persist(dept);
        return dept;
    }
    
    public List<Employee> getDepartmentEmployees(Long deptId) {
        Department dept = em.find(Department.class, deptId);
        return dept != null ? dept.getEmployees() : new ArrayList<>();
    }
    
    public void transferEmployee(Long employeeId, Long newDeptId) {
        Employee employee = em.find(Employee.class, employeeId);
        Department newDept = em.find(Department.class, newDeptId);
        
        if (employee != null && newDept != null) {
            Department oldDept = employee.getDepartment();
            if (oldDept != null) {
                oldDept.removeEmployee(employee);
            }
            newDept.addEmployee(employee);
        }
    }
}
```

### C) Many-to-Many (N:N)

Bir entity bir nechta boshqa entity'lar bilan, ular ham bir nechta entity'lar bilan bog'langan bo'lsa ishlatiladi.

```java
// Many-to-Many (owning side)
@Entity
public class Student {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String studentNumber;
    
    @ManyToMany(cascade = {CascadeType.PERSIST, CascadeType.MERGE})
    @JoinTable(
        name = "student_course",
        joinColumns = @JoinColumn(name = "student_id"),
        inverseJoinColumns = @JoinColumn(name = "course_id")
    )
    private Set<Course> courses = new HashSet<>();
    
    // Helper methods
    public void enrollCourse(Course course) {
        courses.add(course);
        course.getStudents().add(this);
    }
    
    public void dropCourse(Course course) {
        courses.remove(course);
        course.getStudents().remove(this);
    }
    
    // getters, setters
}

// Many-to-Many (non-owning side)
@Entity
public class Course {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    private String code;
    private Integer credits;
    
    @ManyToMany(mappedBy = "courses")
    private Set<Student> students = new HashSet<>();
    
    // getters, setters
}

// Ishlatish
@Stateless
public class EnrollmentService {
    
    @PersistenceContext
    private EntityManager em;
    
    public void enrollStudentToCourse(Long studentId, Long courseId) {
        Student student = em.find(Student.class, studentId);
        Course course = em.find(Course.class, courseId);
        
        if (student != null && course != null) {
            student.enrollCourse(course);
            em.merge(student);
        }
    }
    
    public List<Course> getStudentCourses(Long studentId) {
        Student student = em.find(Student.class, studentId);
        return student != null ? new ArrayList<>(student.getCourses()) : new ArrayList<>();
    }
    
    public List<Student> getCourseStudents(Long courseId) {
        Course course = em.find(Course.class, courseId);
        return course != null ? new ArrayList<>(course.getStudents()) : new ArrayList<>();
    }
}
```

### Relationship Annotatsiyalari

| Annotation | Tavsifi | Muhim atributlar |
|------------|---------|------------------|
| `@OneToOne` | Bir-bir bog'lanish | `cascade`, `fetch`, `mappedBy`, `optional` |
| `@OneToMany` | Bir-ko'p bog'lanish | `cascade`, `fetch`, `mappedBy`, `orphanRemoval` |
| `@ManyToOne` | Ko'p-bir bog'lanish | `cascade`, `fetch`, `optional` |
| `@ManyToMany` | Ko'p-ko'p bog'lanish | `cascade`, `fetch`, `mappedBy` |

### Cascade Types

| Cascade Type | Tavsifi |
|--------------|---------|
| `CascadeType.PERSIST` | Parent persist qilinganda child ham persist qilinadi |
| `CascadeType.MERGE` | Parent merge qilinganda child ham merge qilinadi |
| `CascadeType.REMOVE` | Parent remove qilinganda child ham remove qilinadi |
| `CascadeType.REFRESH` | Parent refresh qilinganda child ham refresh qilinadi |
| `CascadeType.DETACH` | Parent detach qilinganda child ham detach qilinadi |
| `CascadeType.ALL` | Barcha cascade operatsiyalari |

### Fetch Types

| Fetch Type | Tavsifi |
|------------|---------|
| `FetchType.EAGER` | Parent yuklanganda child ham darhol yuklanadi |
| `FetchType.LAZY` | Child faqat kerak bo'lganda yuklanadi (proxied) |

---

## 1.10 JPQL Aggregate Functions

```java
@Stateless
public class ReportService {
    
    @PersistenceContext
    private EntityManager em;
    
    // COUNT - qatorlar soni
    public long getTotalEmployeeCount() {
        Query query = em.createQuery("SELECT COUNT(e) FROM Employee e");
        return (Long) query.getSingleResult();
    }
    
    public long getEmployeesByDepartmentCount(Long deptId) {
        Query query = em.createQuery(
            "SELECT COUNT(e) FROM Employee e WHERE e.department.id = :deptId"
        );
        query.setParameter("deptId", deptId);
        return (Long) query.getSingleResult();
    }
    
    // MAX - maksimal qiymat
    public Double getMaxSalary() {
        Query query = em.createQuery("SELECT MAX(e.salary) FROM Employee e");
        return (Double) query.getSingleResult();
    }
    
    public Double getMaxSalaryByDepartment(Long deptId) {
        Query query = em.createQuery(
            "SELECT MAX(e.salary) FROM Employee e WHERE e.department.id = :deptId"
        );
        query.setParameter("deptId", deptId);
        return (Double) query.getSingleResult();
    }
    
    // MIN - minimal qiymat
    public Double getMinSalary() {
        Query query = em.createQuery("SELECT MIN(e.salary) FROM Employee e");
        return (Double) query.getSingleResult();
    }
    
    // AVG - o'rtacha qiymat
    public Double getAverageSalary() {
        Query query = em.createQuery("SELECT AVG(e.salary) FROM Employee e");
        return (Double) query.getSingleResult();
    }
    
    public Double getAverageSalaryByDepartment(Long deptId) {
        Query query = em.createQuery(
            "SELECT AVG(e.salary) FROM Employee e WHERE e.department.id = :deptId"
        );
        query.setParameter("deptId", deptId);
        return (Double) query.getSingleResult();
    }
    
    // SUM - yig'indi
    public Double getTotalSalary() {
        Query query = em.createQuery("SELECT SUM(e.salary) FROM Employee e");
        Double result = (Double) query.getSingleResult();
        return result != null ? result : 0.0;
    }
    
    // Multiple aggregates
    public Object[] getSalaryStatistics() {
        Query query = em.createQuery(
            "SELECT COUNT(e), AVG(e.salary), MIN(e.salary), MAX(e.salary), SUM(e.salary) FROM Employee e"
        );
        return (Object[]) query.getSingleResult();
    }
    
    // Group By
    public List<Object[]> getSalaryStatsByDepartment() {
        Query query = em.createQuery(
            "SELECT d.name, COUNT(e), AVG(e.salary), MIN(e.salary), MAX(e.salary) " +
            "FROM Employee e JOIN e.department d " +
            "GROUP BY d.name " +
            "ORDER BY AVG(e.salary) DESC"
        );
        return query.getResultList();
    }
    
    // Having
    public List<Object[]> getDepartmentsWithAvgSalaryAbove(double threshold) {
        Query query = em.createQuery(
            "SELECT d.name, COUNT(e), AVG(e.salary) " +
            "FROM Employee e JOIN e.department d " +
            "GROUP BY d.name " +
            "HAVING AVG(e.salary) > :threshold " +
            "ORDER BY AVG(e.salary) DESC"
        );
        query.setParameter("threshold", threshold);
        return query.getResultList();
    }
}
```

---

## 1.11 JPQL Functional Expressions

```java
@Stateless
public class QueryService {
    
    @PersistenceContext
    private EntityManager em;
    
    // CONCAT - string birlashtirish
    public List<String> getFullNames() {
        Query query = em.createQuery(
            "SELECT CONCAT(e.firstName, ' ', e.lastName) FROM Employee e"
        );
        return query.getResultList();
    }
    
    public List<String> getEmployeeInfo() {
        Query query = em.createQuery(
            "SELECT CONCAT(e.name, ' (', e.email, ')') FROM Employee e"
        );
        return query.getResultList();
    }
    
    // SUBSTRING - string dan qism olish
    public List<String> getEmailDomains() {
        Query query = em.createQuery(
            "SELECT SUBSTRING(e.email, POSITION('@' IN e.email) + 1) FROM Employee e"
        );
        return query.getResultList();
    }
    
    // TRIM - bo'shliqlarni tozalash
    public List<String> getTrimmedNames() {
        Query query = em.createQuery(
            "SELECT TRIM(e.name) FROM Employee e"
        );
        return query.getResultList();
    }
    
    // LOWER / UPPER - harflarni kichik/katta qilish
    public List<Employee> findEmployeesByNameIgnoreCase(String name) {
        Query query = em.createQuery(
            "SELECT e FROM Employee e WHERE LOWER(e.name) = LOWER(:name)",
            Employee.class
        );
        query.setParameter("name", name);
        return query.getResultList();
    }
    
    // LENGTH - string uzunligi
    public List<Object[]> getEmployeeNameLengths() {
        Query query = em.createQuery(
            "SELECT e.name, LENGTH(e.name) FROM Employee e ORDER BY LENGTH(e.name) DESC"
        );
        return query.getResultList();
    }
    
    // POSITION - string ichidan qidirish
    public List<Object[]> getEmailAtPositions() {
        Query query = em.createQuery(
            "SELECT e.email, POSITION('@' IN e.email) FROM Employee e"
        );
        return query.getResultList();
    }
    
    // LOCATE - string ichidan qidirish (position bilan bir xil)
    public List<Object[]> getEmailAtPositionsLocate() {
        Query query = em.createQuery(
            "SELECT e.email, LOCATE('@', e.email) FROM Employee e"
        );
        return query.getResultList();
    }
    
    // ABS, SQRT, MOD - matematik funksiyalar
    public List<Object[]> getSalaryMathOperations() {
        Query query = em.createQuery(
            "SELECT e.name, e.salary, ABS(e.salary), SQRT(e.salary), MOD(e.salary, 1000) " +
            "FROM Employee e WHERE e.salary > 0"
        );
        return query.getResultList();
    }
    
    // CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP
    public List<Object[]> getDateQueries() {
        Query query = em.createQuery(
            "SELECT CURRENT_DATE, CURRENT_TIME, CURRENT_TIMESTAMP FROM Employee e"
        );
        return query.getResultList();
    }
    
    // YEAR, MONTH, DAY, HOUR, MINUTE, SECOND
    public List<Object[]> getDateParts() {
        Query query = em.createQuery(
            "SELECT YEAR(e.hireDate), MONTH(e.hireDate), DAY(e.hireDate) FROM Employee e"
        );
        return query.getResultList();
    }
}
```

---

## 1.12 Pagination (Sahifalash)

```java
@Stateless
public class PaginationService {
    
    @PersistenceContext
    private EntityManager em;
    
    // Basic pagination
    public List<Employee> getEmployeesPage(int page, int pageSize) {
        return em.createQuery("SELECT e FROM Employee e ORDER BY e.id", Employee.class)
            .setFirstResult((page - 1) * pageSize)
            .setMaxResults(pageSize)
            .getResultList();
    }
    
    // Pagination with total count
    public PageResult<Employee> getEmployeesPageWithTotal(int page, int pageSize) {
        // Get total count
        Query countQuery = em.createQuery("SELECT COUNT(e) FROM Employee e");
        long total = (Long) countQuery.getSingleResult();
        
        // Get paginated results
        List<Employee> content = em.createQuery("SELECT e FROM Employee e ORDER BY e.id", Employee.class)
            .setFirstResult((page - 1) * pageSize)
            .setMaxResults(pageSize)
            .getResultList();
        
        return new PageResult<>(content, page, pageSize, total);
    }
    
    // Pagination with filters
    public PageResult<Employee> searchEmployees(String namePattern, Double minSalary, 
                                                 Double maxSalary, int page, int pageSize) {
        
        StringBuilder jpql = new StringBuilder("SELECT e FROM Employee e WHERE 1=1");
        StringBuilder countJpql = new StringBuilder("SELECT COUNT(e) FROM Employee e WHERE 1=1");
        
        if (namePattern != null && !namePattern.isEmpty()) {
            jpql.append(" AND LOWER(e.name) LIKE LOWER(:namePattern)");
            countJpql.append(" AND LOWER(e.name) LIKE LOWER(:namePattern)");
        }
        
        if (minSalary != null) {
            jpql.append(" AND e.salary >= :minSalary");
            countJpql.append(" AND e.salary >= :minSalary");
        }
        
        if (maxSalary != null) {
            jpql.append(" AND e.salary <= :maxSalary");
            countJpql.append(" AND e.salary <= :maxSalary");
        }
        
        jpql.append(" ORDER BY e.id");
        
        // Count query
        Query countQuery = em.createQuery(countJpql.toString());
        if (namePattern != null && !namePattern.isEmpty()) {
            countQuery.setParameter("namePattern", "%" + namePattern + "%");
        }
        if (minSalary != null) {
            countQuery.setParameter("minSalary", minSalary);
        }
        if (maxSalary != null) {
            countQuery.setParameter("maxSalary", maxSalary);
        }
        long total = (Long) countQuery.getSingleResult();
        
        // Data query
        TypedQuery<Employee> query = em.createQuery(jpql.toString(), Employee.class);
        if (namePattern != null && !namePattern.isEmpty()) {
            query.setParameter("namePattern", "%" + namePattern + "%");
        }
        if (minSalary != null) {
            query.setParameter("minSalary", minSalary);
        }
        if (maxSalary != null) {
            query.setParameter("maxSalary", maxSalary);
        }
        List<Employee> content = query
            .setFirstResult((page - 1) * pageSize)
            .setMaxResults(pageSize)
            .getResultList();
        
        return new PageResult<>(content, page, pageSize, total);
    }
}

// PageResult class
public class PageResult<T> {
    private List<T> content;
    private int pageNumber;
    private int pageSize;
    private long totalElements;
    private int totalPages;
    
    public PageResult(List<T> content, int pageNumber, int pageSize, long totalElements) {
        this.content = content;
        this.pageNumber = pageNumber;
        this.pageSize = pageSize;
        this.totalElements = totalElements;
        this.totalPages = (int) Math.ceil((double) totalElements / pageSize);
    }
    
    // getters
    public List<T> getContent() { return content; }
    public int getPageNumber() { return pageNumber; }
    public int getPageSize() { return pageSize; }
    public long getTotalElements() { return totalElements; }
    public int getTotalPages() { return totalPages; }
    public boolean hasNext() { return pageNumber < totalPages; }
    public boolean hasPrevious() { return pageNumber > 1; }
}
```

---

## 1.13 Embedded va Embeddable

Embedded type'lar - bir entity ichida boshqa entity'ni "guruhlash" uchun ishlatiladi.

```java
// Embeddable class (value object)
@Embeddable
public class Address {
    private String street;
    private String city;
    private String state;
    private String zipCode;
    private String country;
    
    // constructors, getters, setters
}

@Embeddable
public class ContactInfo {
    private String phone;
    private String email;
    private String website;
    
    // constructors, getters, setters
}

// Entity using embedded types
@Entity
public class Customer {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    @Embedded
    private Address address;
    
    @Embedded
    @AttributeOverrides({
        @AttributeOverride(name = "phone", column = @Column(name = "contact_phone")),
        @AttributeOverride(name = "email", column = @Column(name = "contact_email")),
        @AttributeOverride(name = "website", column = @Column(name = "contact_website"))
    })
    private ContactInfo contactInfo;
    
    // Nested embedded (multiple addresses)
    @ElementCollection
    @CollectionTable(name = "customer_addresses", joinColumns = @JoinColumn(name = "customer_id"))
    @AttributeOverrides({
        @AttributeOverride(name = "street", column = @Column(name = "address_street")),
        @AttributeOverride(name = "city", column = @Column(name = "address_city")),
        @AttributeOverride(name = "zipCode", column = @Column(name = "address_zip"))
    })
    private List<Address> shippingAddresses = new ArrayList<>();
    
    // constructors, getters, setters
}

// Ishlatish
@Stateless
public class CustomerService {
    
    @PersistenceContext
    private EntityManager em;
    
    public Customer createCustomer() {
        Customer customer = new Customer();
        customer.setName("Ali Valiyev");
        
        Address address = new Address();
        address.setStreet("Amir Temur 15");
        address.setCity("Tashkent");
        address.setZipCode("100000");
        address.setCountry("Uzbekistan");
        customer.setAddress(address);
        
        ContactInfo contact = new ContactInfo();
        contact.setPhone("+998901234567");
        contact.setEmail("ali@example.com");
        contact.setWebsite("https://ali.dev");
        customer.setContactInfo(contact);
        
        // Add shipping addresses
        Address shipping1 = new Address();
        shipping1.setStreet("Business Center, Floor 5");
        shipping1.setCity("Tashkent");
        shipping1.setZipCode("100000");
        shipping1.setCountry("Uzbekistan");
        customer.getShippingAddresses().add(shipping1);
        
        em.persist(customer);
        return customer;
    }
    
    public Customer getCustomerWithAddresses(Long id) {
        // JPQL with embedded fields
        TypedQuery<Customer> query = em.createQuery(
            "SELECT c FROM Customer c WHERE c.address.city = :city",
            Customer.class
        );
        query.setParameter("city", "Tashkent");
        return query.getSingleResult();
    }
}
```

---

## 1.14 Attribute Converter

Custom attribute converter - entity field'larini ma'lumotlar bazasida boshqa turda saqlash uchun.

```java
import jakarta.persistence.*;

// Converter for storing LocalDate as String (YYYY-MM-DD)
@Converter(autoApply = true)
public class LocalDateConverter implements AttributeConverter<LocalDate, String> {
    
    private static final DateTimeFormatter FORMATTER = DateTimeFormatter.ISO_LOCAL_DATE;
    
    @Override
    public String convertToDatabaseColumn(LocalDate attribute) {
        if (attribute == null) {
            return null;
        }
        return attribute.format(FORMATTER);
    }
    
    @Override
    public LocalDate convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return null;
        }
        return LocalDate.parse(dbData, FORMATTER);
    }
}

// Converter for storing List<String> as JSON
@Converter
public class StringListConverter implements AttributeConverter<List<String>, String> {
    
    private static final ObjectMapper mapper = new ObjectMapper();
    
    @Override
    public String convertToDatabaseColumn(List<String> attribute) {
        if (attribute == null || attribute.isEmpty()) {
            return "[]";
        }
        try {
            return mapper.writeValueAsString(attribute);
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to convert list to JSON", e);
        }
    }
    
    @Override
    public List<String> convertToEntityAttribute(String dbData) {
        if (dbData == null || dbData.isEmpty()) {
            return new ArrayList<>();
        }
        try {
            return mapper.readValue(dbData, new TypeReference<List<String>>() {});
        } catch (JsonProcessingException e) {
            throw new RuntimeException("Failed to convert JSON to list", e);
        }
    }
}

// Converter for storing Enum as String
@Converter
public class RoleConverter implements AttributeConverter<Role, String> {
    
    @Override
    public String convertToDatabaseColumn(Role attribute) {
        if (attribute == null) {
            return null;
        }
        return attribute.getCode();
    }
    
    @Override
    public Role convertToEntityAttribute(String dbData) {
        if (dbData == null) {
            return null;
        }
        return Role.fromCode(dbData);
    }
}

// Entity using converters
@Entity
public class Product {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    private String name;
    
    // Auto-applied converter (autoApply = true)
    private LocalDate manufacturedDate;
    
    // Explicit converter
    @Convert(converter = StringListConverter.class)
    private List<String> tags = new ArrayList<>();
    
    // Enum converter
    @Convert(converter = RoleConverter.class)
    private Role role;
    
    // getters, setters
}
```

---

## Tekshiruv Savollari

1. **JPQL nima va u SQL dan qanday farq qiladi?**
2. **NamedQuery qanday yaratiladi va ishlatiladi?**
3. **@OneToOne, @OneToMany, @ManyToOne, @ManyToMany annotatsiyalari qachon ishlatiladi?**
4. **Cascade turlari qanday va ular nima vazifani bajaradi?**
5. **FetchType.EAGER va FetchType.LAZY o'rtasidagi farq nima?**
6. **JPQL da aggregate funksiyalar qanday ishlatiladi?**
7. **JPQL da functional expressions (CONCAT, SUBSTRING, etc.) qanday ishlatiladi?**
8. **Pagination qanday amalga oshiriladi?**
9. **@Embedded va @Embeddable nima uchun kerak?**
10. **Attribute converter nima va qachon ishlatiladi?**

---

## Amaliy Topshiriq

Quyidagi imkoniyatlarga ega JPA ilovasini yarating:

1. **Entity'lar** - User, Order, Product, Category (munosabatlar bilan)
2. **NamedQuery'lar** - turli so'rovlar uchun named query'lar
3. **Aggregate queries** - hisobotlar (jami summa, o'rtacha, maksimal, minimal)
4. **Pagination** - mahsulotlarni sahifalash
5. **Embedded types** - Address, ContactInfo
6. **Attribute converters** - LocalDate, Enum, List<String> converter'lar

---

**Keyingi mavzu:** [Jakarta Bean Validation](./07_Bean_Validation.md)  
**[Mundarijaga qaytish](../README.md)**

> JPA va JPQL - ma'lumotlar bazasi bilan ishlashning standart usuli. Ularni o'rganish orqali ORM (Object-Relational Mapping) texnologiyasini to'liq o'zlashtirasiz. 🚀
