# 5-Modul: Maven - Build Tool

## Maven nima?

**Maven** - Apache Group tomonidan ishlab chiqilgan ochiq kodli build tool (qurish vositasi). Bir nechta loyihalarni bir vaqtda build qilish, publish qilish va deploy qilish imkonini beradi.

```xml
<!-- Maven pom.xml - loyihaning asosiy fayli -->
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>uz.pdp</groupId>
    <artifactId>my-app</artifactId>
    <version>1.0-SNAPSHOT</version>
</project>
```

### Maven nima uchun kerak?

1. **Dependency management** - Kutubxonalarni avtomatik boshqarish
2. **Build automation** - Loyihani build qilishni avtomatlashtirish
3. **Project structure** - Standart loyiha strukturasi
4. **Documentation** - Avtomatik dokumentatsiya yaratish
5. **Reporting** - Hisobotlar yaratish
6. **Deployment** - Loyihani deploy qilish

```bash
# ❌ Yomon: JAR larni qo'lda yuklab, classpath ga qo'shish
javac -cp lib/library1.jar:lib/library2.jar Main.java
java -cp .:lib/library1.jar:lib/library2.jar Main

# ✅ Yaxshi: Maven dependency'larini pom.xml ga yozish
# mvn compile
# mvn exec:java -Dexec.mainClass="uz.pdp.Main"
```

---

## 5.1 - Project Object Model (POM)

### POM nima?

**POM (Project Object Model)** - loyiha haqidagi barcha ma'lumotlarni o'z ichiga olgan XML fayl. Loyihaning asosiy katalogida (`pom.xml`) joylashgan.

```xml
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    <!-- POM model version -->
    <modelVersion>4.0.0</modelVersion>
    
    <!-- Project coordinates -->
    <groupId>uz.pdp</groupId>
    <artifactId>maven-lesson</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>jar</packaging> <!-- jar, war, ear, pom -->
    
    <!-- Project metadata -->
    <name>Maven Lesson</name>
    <description>Maven o'rganish uchun loyiha</description>
    <url>https://pdp.uz</url>
    
    <!-- Properties -->
    <properties>
        <maven.compiler.source>17</maven.compiler.source>
        <maven.compiler.target>17</maven.compiler.target>
        <project.build.sourceEncoding>UTF-8</project.build.sourceEncoding>
    </properties>
    
    <!-- Dependencies -->
    <dependencies>
        <!-- JUnit for testing -->
        <dependency>
            <groupId>org.junit.jupiter</groupId>
            <artifactId>junit-jupiter-api</artifactId>
            <version>5.9.2</version>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <!-- Build configuration -->
    <build>
        <plugins>
            <plugin>
                <groupId>org.apache.maven.plugins</groupId>
                <artifactId>maven-compiler-plugin</artifactId>
                <version>3.11.0</version>
            </plugin>
        </plugins>
    </build>
</project>
```

### Pom.xml asosiy elementlari

| Element | Vazifasi | Misol |
|---------|----------|-------|
| **groupId** | Loyiha guruhi identifikatori | `uz.pdp`, `com.google` |
| **artifactId** | Loyiha nomi | `my-app`, `guava` |
| **version** | Loyiha versiyasi | `1.0.0`, `2.5.3-SNAPSHOT` |
| **packaging** | Paket turi | `jar`, `war`, `pom` |
| **properties** | O'zgaruvchilar | Java versiyasi, encoding |
| **dependencies** | Bog'liqliklar | Kutubxonalar ro'yxati |
| **build** | Build sozlamalari | Pluginlar, resources |

---

## 5.2 - Maven o'rnatish

### 1. Download Maven

```bash
# Windows
# https://maven.apache.org/download.cgi

# Ubuntu/Debian
sudo apt update
sudo apt install maven

# macOS
brew install maven

# Check installation
mvn --version
# Apache Maven 3.8.7
# Java version: 17.0.2
```

### 2. Environment variables

```bash
# Linux/macOS (.bashrc yoki .zshrc ga qo'shing)
export MAVEN_HOME=/opt/maven
export PATH=$MAVEN_HOME/bin:$PATH

# Windows (System Properties -> Environment Variables)
# MAVEN_HOME = C:\apache-maven-3.8.7
# PATH ga %MAVEN_HOME%\bin qo'shing
```

### 3. Settings.xml

Maven konfiguratsiya fayli: `~/.m2/settings.xml`

```xml
<settings>
    <!-- Local repository location -->
    <localRepository>${user.home}/.m2/repository</localRepository>
    
    <!-- Proxy settings -->
    <proxies>
        <proxy>
            <id>example-proxy</id>
            <active>true</active>
            <protocol>http</protocol>
            <host>proxy.example.com</host>
            <port>8080</port>
        </proxy>
    </proxies>
    
    <!-- Mirrors -->
    <mirrors>
        <mirror>
            <id>maven-central</id>
            <name>Maven Central</name>
            <url>https://repo.maven.apache.org/maven2</url>
            <mirrorOf>central</mirrorOf>
        </mirror>
    </mirrors>
</settings>
```

---

## 5.3 - Maven loyiha yaratish

### 1. Archetip orqali loyiha yaratish

```bash
# Asosiy archetype: maven-archetype-quickstart
mvn archetype:generate \
    -DgroupId=uz.pdp \
    -DartifactId=maven-lesson \
    -DarchetypeArtifactId=maven-archetype-quickstart \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false

# Natija:
# maven-lesson/
# ├── pom.xml
# ├── src/
# │   ├── main/
# │   │   └── java/
# │   │       └── uz/pdp/App.java
# │   └── test/
# │       └── java/
# │           └── uz/pdp/AppTest.java
```

### 2. Web application archetype

```bash
# Web app archetype
mvn archetype:generate \
    -DgroupId=uz.pdp \
    -DartifactId=web-app \
    -DarchetypeArtifactId=maven-archetype-webapp \
    -DarchetypeVersion=1.4 \
    -DinteractiveMode=false

# Natija:
# web-app/
# ├── pom.xml
# ├── src/
# │   └── main/
# │       ├── resources/
# │       └── webapp/
# │           ├── WEB-INF/
# │           │   └── web.xml
# │           └── index.jsp
```

### 3. Multi-module project

```bash
# Parent project
mvn archetype:generate \
    -DgroupId=uz.pdp \
    -DartifactId=parent-project \
    -DarchetypeArtifactId=maven-archetype-site-simple \
    -DinteractiveMode=false

# Module qo'shish
cd parent-project
mkdir module-a module-b
```

Parent `pom.xml`:

```xml
<project>
    <modelVersion>4.0.0</modelVersion>
    <groupId>uz.pdp</groupId>
    <artifactId>parent-project</artifactId>
    <version>1.0-SNAPSHOT</version>
    <packaging>pom</packaging>
    
    <modules>
        <module>module-a</module>
        <module>module-b</module>
    </modules>
</project>
```

---

## 5.4 - Asosiy Maven komandalari

### Clean va Compile

```bash
# 1. Clean - target directory ni o'chiradi
mvn clean
# target/ papkasi o'chadi

# 2. Compile - source code ni kompilyatsiya qiladi
mvn compile
# target/classes/ papkasiga .class fayllar yoziladi

# 3. Test compile - test classlarini kompilyatsiya qiladi
mvn test-compile
# target/test-classes/ papkasiga test .class fayllar yoziladi

# 4. Clean + Compile
mvn clean compile
```

### Test va Package

```bash
# 1. Test - testlarni ishga tushiradi
mvn test
# target/surefire-reports/ ga test natijalari yoziladi

# 2. Package - JAR/WAR paket yaratadi
mvn package
# target/ papkasida artifact yaratiladi (my-app-1.0-SNAPSHOT.jar)

# 3. Test skip qilish
mvn package -DskipTests
mvn package -Dmaven.test.skip=true

# 4. Package + install
mvn install
# Local repository ga (~/.m2/repository) o'rnatadi
```

### Install va Deploy

```bash
# 1. Install local repository ga
mvn install
# ~/.m2/repository/uz/pdp/my-app/1.0-SNAPSHOT/my-app-1.0-SNAPSHOT.jar

# 2. Deploy remote repository ga (settings.xml da sozlangan bo'lishi kerak)
mvn deploy
# Nexus/Artifactory kabi remote repository ga yuklaydi

# 3. Clean + Install
mvn clean install
```

### Validate va Verify

```bash
# 1. Validate - loyiha to'g'riligini tekshiradi
mvn validate
# pom.xml validligi, dependency'lar mavjudligi tekshiriladi

# 2. Verify - integration testlarni tekshiradi
mvn verify
# Package + test + integration test + quality checks
```

### Dependency management

```bash
# 1. Dependency tree - bog'liqliklar daraxtini ko'rsatadi
mvn dependency:tree

# Output:
# uz.pdp:my-app:jar:1.0-SNAPSHOT
# +- org.junit.jupiter:junit-jupiter-api:jar:5.9.2:test
# |  +- org.junit:junit-bom:jar:5.9.2:test
# |  \- org.apiguardian:apiguardian-api:jar:1.1.2:test
# \- org.junit.jupiter:junit-jupiter-engine:jar:5.9.2:test

# 2. Analyze - foydalanilmagan dependency'larni aniqlaydi
mvn dependency:analyze

# 3. Dependency list
mvn dependency:list

# 4. Copy dependencies
mvn dependency:copy-dependencies -DoutputDirectory=lib
```

### Site generation

```bash
# 1. Site yaratish
mvn site

# 2. Site deploy qilish
mvn site-deploy

# 3. Site generate + package
mvn site:site
# target/site/ papkasida HTML dokumentatsiya yaratiladi
```

---

## 5.5 - Extended Maven commands

### Build options

```bash
# 1. Offline mode (internetsiz)
mvn -o package
# Faqat local repository dagi dependency'lardan foydalanadi

# 2. Quiet mode (minimal output)
mvn -q package
# Faqat xatolar va test natijalari ko'rsatiladi

# 3. Debug mode (batafsil output)
mvn -X package
# Stack trace, debug ma'lumotlari

# 4. Parallel builds
mvn -T 4 package
# 4 ta thread bilan parallel build

# 5. Specific module
mvn -pl module-a package
# Faqat module-a ni build qiladi

# 6. Also make dependencies
mvn -am -pl module-a package
# module-a va unga bog'liq modullarni build qiladi
```

### Profile activation

```bash
# 1. Profile bilan build
mvn package -Pproduction

# 2. Multiple profiles
mvn package -Pproduction,deploy

# 3. Profile list
mvn help:all-profiles
```

```xml
<!-- pom.xml da profile -->
<profiles>
    <profile>
        <id>development</id>
        <properties>
            <environment>dev</environment>
            <skipTests>true</skipTests>
        </properties>
    </profile>
    <profile>
        <id>production</id>
        <properties>
            <environment>prod</environment>
        </properties>
    </profile>
</profiles>
```

### Help commands

```bash
# 1. Help
mvn -help
# Barcha option'lar ro'yxati

# 2. Version
mvn -version
# mvn -v

# 3. Effective POM
mvn help:effective-pom
# Barcha parent POM larni birlashtirgan POM ni ko'rsatadi

# 4. System properties
mvn help:system
```

---

## 5.6 - Amaliy misollar

### Misol 1: To'liq build cycle

```bash
# Development build
mvn clean compile test package

# Production build
mvn clean compile test package -Pproduction

# Deploy build
mvn clean verify deploy

# CI/CD build
mvn clean verify site-deploy
```

### Misol 2: Dependency'lar bilan ishlash

```xml
<!-- pom.xml da dependency'lar -->
<dependencies>
    <!-- Logging -->
    <dependency>
        <groupId>org.slf4j</groupId>
        <artifactId>slf4j-api</artifactId>
        <version>2.0.7</version>
    </dependency>
    <dependency>
        <groupId>ch.qos.logback</groupId>
        <artifactId>logback-classic</artifactId>
        <version>1.4.8</version>
    </dependency>
    
    <!-- Database -->
    <dependency>
        <groupId>org.postgresql</groupId>
        <artifactId>postgresql</artifactId>
        <version>42.6.0</version>
    </dependency>
    
    <!-- Jackson for JSON -->
    <dependency>
        <groupId>com.fasterxml.jackson.core</groupId>
        <artifactId>jackson-databind</artifactId>
        <version>2.15.2</version>
    </dependency>
    
    <!-- Lombok -->
    <dependency>
        <groupId>org.projectlombok</groupId>
        <artifactId>lombok</artifactId>
        <version>1.18.28</version>
        <scope>provided</scope>
    </dependency>
</dependencies>
```

```bash
# Dependency tree
mvn dependency:tree

# Dependency analyze
mvn dependency:analyze

# Copy all dependencies
mvn dependency:copy-dependencies -DoutputDirectory=target/lib

# Build with dependencies
mvn package
```

### Misol 3: Executable JAR yaratish

```xml
<!-- pom.xml da plugin -->
<build>
    <plugins>
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.11.0</version>
            <configuration>
                <source>17</source>
                <target>17</target>
            </configuration>
        </plugin>
        
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-shade-plugin</artifactId>
            <version>3.4.1</version>
            <executions>
                <execution>
                    <phase>package</phase>
                    <goals>
                        <goal>shade</goal>
                    </goals>
                    <configuration>
                        <transformers>
                            <transformer implementation="org.apache.maven.plugins.shade.resource.ManifestResourceTransformer">
                                <mainClass>uz.pdp.Main</mainClass>
                            </transformer>
                        </transformers>
                    </configuration>
                </execution>
            </executions>
        </plugin>
    </plugins>
</build>
```

```bash
# Build
mvn clean package

# Run
java -jar target/my-app-1.0-SNAPSHOT.jar
```

### Misol 4: Multi-module project

```xml
<!-- parent/pom.xml -->
<project>
    <groupId>uz.pdp</groupId>
    <artifactId>parent</artifactId>
    <version>1.0</version>
    <packaging>pom</packaging>
    
    <modules>
        <module>common</module>
        <module>service</module>
        <module>web</module>
    </modules>
    
    <dependencyManagement>
        <dependencies>
            <dependency>
                <groupId>org.junit</groupId>
                <artifactId>junit-bom</artifactId>
                <version>5.9.2</version>
                <type>pom</type>
                <scope>import</scope>
            </dependency>
        </dependencies>
    </dependencyManagement>
</project>
```

```xml
<!-- common/pom.xml -->
<project>
    <parent>
        <groupId>uz.pdp</groupId>
        <artifactId>parent</artifactId>
        <version>1.0</version>
    </parent>
    
    <artifactId>common</artifactId>
    
    <dependencies>
        <!-- common dependencies -->
    </dependencies>
</project>
```

```bash
# Build all modules
cd parent
mvn clean install

# Build specific module
mvn -pl common clean install

# Build module with dependencies
mvn -pl service -am clean install
```

### Misol 5: Spring Boot application

```xml
<!-- Spring Boot pom.xml -->
<?xml version="1.0" encoding="UTF-8"?>
<project xmlns="http://maven.apache.org/POM/4.0.0"
         xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
         xsi:schemaLocation="http://maven.apache.org/POM/4.0.0 
         http://maven.apache.org/xsd/maven-4.0.0.xsd">
    
    <modelVersion>4.0.0</modelVersion>
    
    <parent>
        <groupId>org.springframework.boot</groupId>
        <artifactId>spring-boot-starter-parent</artifactId>
        <version>3.1.0</version>
    </parent>
    
    <groupId>uz.pdp</groupId>
    <artifactId>spring-app</artifactId>
    <version>1.0.0</version>
    <packaging>jar</packaging>
    
    <properties>
        <java.version>17</java.version>
    </properties>
    
    <dependencies>
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-web</artifactId>
        </dependency>
        
        <dependency>
            <groupId>org.springframework.boot</groupId>
            <artifactId>spring-boot-starter-test</artifactId>
            <scope>test</scope>
        </dependency>
    </dependencies>
    
    <build>
        <plugins>
            <plugin>
                <groupId>org.springframework.boot</groupId>
                <artifactId>spring-boot-maven-plugin</artifactId>
            </plugin>
        </plugins>
    </build>
</project>
```

```bash
# Build
mvn clean package

# Run
mvn spring-boot:run
# yoki
java -jar target/spring-app-1.0.0.jar
```

---

## 5.7 - Maven Lifecycle

### Build Lifecycle phases

```
validate → compile → test → package → verify → install → deploy
```

| Phase | Description |
|-------|-------------|
| **validate** | Loyiha to'g'riligini tekshiradi |
| **compile** | Source code ni kompilyatsiya qiladi |
| **test** | Unit testlarni ishga tushiradi |
| **package** | Kompilyatsiya qilingan kodni JAR/WAR ga paketlaydi |
| **verify** | Integration testlarni ishga tushiradi |
| **install** | Paketni local repository ga o'rnatadi |
| **deploy** | Paketni remote repository ga yuklaydi |

### Default lifecycle goals

```bash
# Validate phase
mvn validate

# Compile phase (validate + compile)
mvn compile

# Test phase (validate + compile + test)
mvn test

# Package phase (validate + compile + test + package)
mvn package

# Verify phase (validate + compile + test + package + verify)
mvn verify

# Install phase (full lifecycle except deploy)
mvn install

# Deploy phase (full lifecycle)
mvn deploy
```

### Clean lifecycle

```bash
# Clean phase
mvn clean

# Pre-clean
mvn pre-clean

# Post-clean
mvn post-clean
```

### Site lifecycle

```bash
# Site phase
mvn site

# Site-deploy phase
mvn site-deploy
```

---

## 5.8 - Maven plugins

### Popular plugins

| Plugin | Purpose | Example |
|--------|---------|---------|
| **maven-compiler-plugin** | Java kompilyatsiya | `mvn compiler:compile` |
| **maven-surefire-plugin** | Testlarni ishga tushirish | `mvn surefire:test` |
| **maven-failsafe-plugin** | Integration testlar | `mvn failsafe:integration-test` |
| **maven-jar-plugin** | JAR yaratish | `mvn jar:jar` |
| **maven-war-plugin** | WAR yaratish | `mvn war:war` |
| **maven-shade-plugin** | Uber-JAR yaratish | `mvn shade:shade` |
| **maven-source-plugin** | Source JAR | `mvn source:jar` |
| **maven-javadoc-plugin** | Javadoc yaratish | `mvn javadoc:javadoc` |
| **maven-deploy-plugin** | Deploy qilish | `mvn deploy:deploy` |
| **maven-install-plugin** | Install qilish | `mvn install:install` |

### Plugin configuration

```xml
<build>
    <plugins>
        <!-- Compiler plugin -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-compiler-plugin</artifactId>
            <version>3.11.0</version>
            <configuration>
                <source>17</source>
                <target>17</target>
                <encoding>UTF-8</encoding>
            </configuration>
        </plugin>
        
        <!-- Surefire plugin for tests -->
        <plugin>
            <groupId>org.apache.maven.plugins</groupId>
            <artifactId>maven-surefire-plugin</artifactId>
            <version>3.0.0</version>
            <configuration>
                <skipTests>${skipTests}</skipTests>
                <includes>
                    <include>**/*Test.java</include>
                </includes>
            </configuration>
        </plugin>
    </plugins>
</build>
```

---

## 5.9 - Maven command cheat sheet

### Asosiy komandalar

| Command | Description |
|---------|-------------|
| `mvn clean` | target directory ni tozalaydi |
| `mvn compile` | Java source code ni kompilyatsiya qiladi |
| `mvn test` | Testlarni ishga tushiradi |
| `mvn package` | JAR/WAR paket yaratadi |
| `mvn install` | Local repository ga o'rnatadi |
| `mvn deploy` | Remote repository ga yuklaydi |
| `mvn site` | Dokumentatsiya yaratadi |

### Extended komandalar

| Command | Description |
|---------|-------------|
| `mvn clean package` | Clean + package |
| `mvn clean install` | Clean + install |
| `mvn dependency:tree` | Dependency tree |
| `mvn dependency:analyze` | Dependency analyze |
| `mvn help:effective-pom` | Effective POM |
| `mvn archetype:generate` | Yangi loyiha yaratish |
| `mvn -o package` | Offline mode |
| `mvn -X package` | Debug mode |
| `mvn -q package` | Quiet mode |
| `mvn -T 4 package` | Parallel build |
| `mvn -pl module package` | Specific module |
| `mvn -am package` | With dependencies |

### Options

| Option | Description |
|--------|-------------|
| `-DskipTests` | Testlarni skip qilish |
| `-Dmaven.test.skip=true` | Testlarni compile ham qilmaydi |
| `-Pprofile` | Profile aktivlash |
| `-f pom.xml` | Specific POM fayl |
| `-U` | Force update snapshots |
| `-B` | Batch mode |
| `-e` | Exception trace |
| `-V` | Show version |

---

## Tekshiruv Savollari

1. **Maven nima va u nima uchun ishlatiladi?**
2. **POM (Project Object Model) nima?**
3. **Maven qanday o'rnatiladi?**
4. **Maven lifecycle qanday fazalardan iborat?**
5. **mvn clean compile package komandasi nima qiladi?**
6. **Dependency scope turlari qanday?**
7. **Local repository qayerda joylashgan?**
8. **Maven plugin nima va qanday ishlatiladi?**
9. **Multi-module project qanday yaratiladi?**
10. **mvn install va mvn deploy farqi nima?**

---

## Amaliy topshiriq

Quyidagi imkoniyatlarga ega Maven loyihasini yarating:

1. **Multi-module** project (common, service, web)
2. **Dependencies** (logging, database, testing)
3. **Executable JAR** (shade plugin bilan)
4. **Unit tests** (JUnit 5)
5. **Custom properties** (Java version, encoding)
6. **Profiles** (dev, prod)
7. **Resource filtering** (environment specific configs)

```bash
# Loyiha strukturasi:
# my-project/
# ├── pom.xml
# ├── common/
# │   └── pom.xml
# ├── service/
# │   └── pom.xml
# └── web/
#     └── pom.xml
```

---

## Xulosa

Maven - Java ekosistemasida eng ko'p ishlatiladigan build tool:

| Afzallik | Tavsif |
|----------|--------|
| **Convention over configuration** | Standart struktura |
| **Dependency management** | Avtomatik dependency'lar |
| **Build automation** | Lifecycle orqali build |
| **Extensibility** | Pluginlar orqali kengaytirish |
| **Ecosystem** | Katta pluginlar ekosistemasi |

```bash
# Tez boshlash:
mvn archetype:generate -DgroupId=uz.pdp -DartifactId=my-app
cd my-app
mvn package
java -jar target/my-app-1.0-SNAPSHOT.jar
```

---

**Keyingi mavzu:** [Gradle Build Tool](./06_Gradle.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
