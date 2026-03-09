# 09 - Git va GitHub (Versiya Nazorat Tizimi)

## 9.1 - Git (Versiya Nazorat Tizimi)

### Version Control nima?

**Version Control (Versiya Nazorati)** - fayllardagi o'zgarishlarni qayd qiluvchi tizim. Bu tizim orqali siz istalgan versiyaga qaytishingiz mumkin.

```bash
# Version Control System (VCS) muammolarni hal qiladi:
# - Kim, qachon, nima o'zgartirdi?
# - Eski versiyaga qaytish
# - Bir vaqtda bir necha odam ishlashi
# - O'zgarishlarni birlashtirish
```

### Git nima?

**Git** - eng mashhur version control tizimi. 2005 yilda Linus Torvalds tomonidan yaratilgan.

```bash
# Git statistikasi:
# - Dasturchilarning 70%+ Git ishlatadi
# - Dunyodagi eng katta kod bazalari Git da
# - Linux kernel, Android, VLC, PHP va boshqalar
```

### Nima uchun Git?

1. **Kod o'zgarishlarini kuzatish** - Kim, qachon, nima o'zgartirgan?
2. **Hamkorlikda ishlash** - Dunyoning istalgan nuqtasidan
3. **To'liq tarix** - Barcha o'zgarishlar tarixi
4. **Qaytish imkoniyati** - Eski versiyalarga qaytish

### Git o'rnatish

```bash
# Windows
# https://git-scm.com/download/win

# macOS
# Terminal orqali: xcode-select --install

# Ubuntu/Debian
sudo apt update
sudo apt install git

# Tekshirish
git --version
# git version 2.25.1
```

### Git Sozlash (Configuration)

```bash
# Global sozlash (barcha repository'lar uchun)
git config --global user.name "Ismingiz"
git config --global user.email "email@example.com"
git config --global init.defaultBranch main
git config --global core.editor "code --wait"

# Sozlamalarni ko'rish
git config --list

# Sozlamalarni tahrirlash
git config --global --edit

# Local sozlash (faqat joriy repository uchun)
git config user.name "Local Name"
```

### Git Workflow (Ish Jarayoni)

```
Working Directory    →    Staging Area    →    Git Directory
     (ishchi)              (tayyor)             (repository)
         ↓                      ↓                      ↓
    git add               git commit             git push
    (qo'shish)            (saqlash)              (yuklash)
```

```bash
# 1. Fayllarni o'zgartirish (Working Directory)
echo "Hello Git" > file.txt

# 2. Staging Area ga qo'shish
git add file.txt
# yoki barchasini qo'shish
git add .
git add -A
git add --all

# 3. Commit qilish (saqlash)
git commit -m "Birinchi commit"
```

### Git Status va Log

```bash
# Status tekshirish
git status
git status --short  # Qisqa format

# Log (tarix) ko'rish
git log             # To'liq log
git log --oneline   # Bir qatorli
git log --graph     # Graf ko'rinishida
git log --follow file.txt  # Fayl tarixi
git log --author="Ism"     # Muallif bo'yicha

# Muayyan commit ni ko'rish
git show commit_id
git show HEAD       # Oxirgi commit
```

### Git Commit va Checksums

```bash
# Git har bir commit uchun SHA-1 hash yaratadi
# Masalan: 258efa7a4f4a3b5c6d7e8f9a0b1c2d3e4f5a6b7c

git commit -m "Added new feature"
# [main 258efa7] Added new feature
# 1 file changed, 2 insertions(+)

# Odatda birinchi 7 belgi ishlatiladi
git show 258efa7
```

### Git Branch (Tarmoqlar)

```bash
# Branch lar - asosiy loyihadan ajralgan versiya
# Bu branch'da ishlab, keyin asosiyga qo'shish mumkin

# Branch lar ro'yxati
git branch
git branch -v      # Oxirgi commit bilan

# Yangi branch yaratish
git branch develop
git branch feature/login

# Branch ga o'tish
git checkout develop
git switch develop  # Yangi usul (Git 2.23+)

# Branch yaratib o'tish
git checkout -b feature/new
git switch -c feature/new  # Yangi usul

# Branch larni birlashtirish (merge)
git checkout main
git merge develop

# Branch o'chirish
git branch -d develop        # Safe delete
git branch -D feature/bug    # Force delete
```

### Branch Merge (Birlashtirish)

```bash
# Fast-forward merge
git checkout main
git merge feature

# 3-way merge
git checkout main
git merge develop
# Agar conflict bo'lsa, manual hal qilish kerak
```

### Git Stash (Vaqtinchalik saqlash)

```bash
# Hozirgi o'zgarishlarni vaqtinchalik saqlash
git stash
git stash save "WIP: login feature"

# Stash lar ro'yxati
git stash list

# Stash ni qaytarish
git stash pop     # Oxirgi stash ni qaytarib o'chirish
git stash apply   # Qaytarib saqlab qolish
git stash apply stash@{2}  # Specific stash

# Stash o'chirish
git stash drop stash@{1}
git stash clear   # Hammasini o'chirish
```

### Git Diff (Farqlarni ko'rish)

```bash
# Working directory va staging area farqi
git diff

# Staging va last commit farqi
git diff --staged

# Ikki commit orasidagi farq
git diff commit1 commit2

# Branch lar orasidagi farq
git diff main develop
```

### Git Reset va Revert

```bash
# ===== Git Reset (Commit ni butunlay o'chirish) =====

# Soft reset - staging area ga qaytaradi
git reset --soft HEAD~1

# Mixed reset (default) - working directory ga qaytaradi
git reset HEAD~1

# Hard reset - butunlay o'chiradi (xavfli!)
git reset --hard HEAD~1

# Specific commit ga qaytish
git reset --hard commit_id

# ===== Git Revert (Yangi commit bilan qaytarish) =====

# Oxirgi commit ni qaytarish
git revert HEAD
git revert HEAD --no-edit  # Default message bilan

# Specific commit ni qaytarish
git revert commit_id

# Revert log da ko'rinadi, reset esa o'chiradi
git log --oneline
# 258efa7 Revert "Added feature"  (revert)
# 0e52da7 Added feature            (original)
```

### Git Reset Turlari

```bash
# SOFT - faqat HEAD ni o'zgartiradi
git reset --soft HEAD~1
# O'zgarishlar staging area da qoladi

# MIXED (default) - HEAD va index ni o'zgartiradi
git reset HEAD~1
# O'zgarishlar working directory da qoladi

# HARD - hammasini o'chiradi
git reset --hard HEAD~1
# O'zgarishlar butunlay yo'qoladi!
```

### Git Clean

```bash
# Untracked fayllarni ko'rsatish
git clean -n

# Untracked fayllarni o'chirish
git clean -f

# Kataloglarni ham o'chirish
git clean -fd
```

---

## 9.2 - GitHub

### GitHub nima?

**GitHub** - Git repository'lar uchun hosting xizmati. Git bilan birga ishlaydi, lekin ular boshqa narsalar.

```bash
# Git vs GitHub
# Git      - version control tizimi (lokal)
# GitHub   - Git repository'lar uchun cloud hosting
```

### GitHub Xususiyatlari

1. **Repository hosting** - Kodlarni cloud'da saqlash
2. **Collaboration** - Hamkorlikda ishlash
3. **Pull Requests** - Kod review
4. **Issues** - Bug tracking
5. **Actions** - CI/CD
6. **Pages** - Static website hosting

### Local Repository ni GitHub ga ulash

```bash
# 1. Repository yaratish (GitHub da)

# 2. Local repository ni main branch ga o'zgartirish
git branch -M main

# 3. Remote qo'shish
git remote add origin https://github.com/username/repo.git

# 4. Push qilish
git push -u origin main

# Agar token kerak bo'lsa:
git remote set-url origin https://token@github.com/username/repo.git
```

### Remote Repository bilan ishlash

```bash
# Clone - repository ni ko'chirib olish
git clone https://github.com/username/repo.git
git clone git@github.com:username/repo.git  # SSH

# Pull - o'zgarishlarni olish
git pull
git pull origin main

# Push - o'zgarishlarni yuborish
git push
git push origin main
git push --all  # Barcha branch larni

# Remote ma'lumotlarni ko'rish
git remote -v
git remote show origin

# Remote o'zgartirish
git remote rename origin upstream
git remote remove origin
```

### Git Clone

```bash
# Repository ni clone qilish
git clone https://github.com/user/repo.git
git clone https://github.com/user/repo.git myfolder

# Specific branch ni clone
git clone -b develop https://github.com/user/repo.git

# Shallow clone (faqat oxirgi commit)
git clone --depth 1 https://github.com/user/repo.git
```

### Git Pull vs Fetch

```bash
# Fetch - o'zgarishlarni yuklab oladi, lekin merge qilmaydi
git fetch origin
git fetch --all

# Pull = fetch + merge
git pull origin main

# Pull with rebase
git pull --rebase origin main
```

### Git Push va Pull Request

```bash
# Push - lokal o'zgarishlarni remote ga yuborish
git push origin feature/login

# Pull Request (PR) - GitHub da feature branch ni main ga qo'shish so'rovi
# 1. Feature branch yaratish
git checkout -b feature/new
# 2. O'zgarishlar qilish
git add .
git commit -m "Add new feature"
# 3. Push qilish
git push origin feature/new
# 4. GitHub da Pull Request yaratish
```

### .gitignore Fayli

```bash
# .gitignore - Git ignore qiladigan fayllar

# Misol .gitignore:
```
# Compiled files
*.class
*.jar
*.war

# IDE files
.idea/
*.iml
.vscode/

# Build directories
target/
build/
out/

# Log files
*.log

# Environment files
.env
application.properties

# OS files
.DS_Store
Thumbs.db

# Dependency directories
node_modules/
vendor/

# Temporary files
*.tmp
*.temp
```

### Git Status Codes

```bash
git status --short
# ?? new.txt     # Untracked (yangi fayl)
#  A staged.txt  # Added to staging
#  M modified.txt # Modified in working dir
# M  staged.txt   # Modified in staging
# D  deleted.txt  # Deleted from staging
#  D working.txt  # Deleted in working dir
# R  renamed.txt  # Renamed
```

### Git Aliases (Qisqa komandalar)

```bash
# Qulay alias lar
git config --global alias.co checkout
git config --global alias.br branch
git config --global alias.ci commit
git config --global alias.st status
git config --global alias.unstage 'reset HEAD --'
git config --global alias.last 'log -1 HEAD'
git config --global alias.graph 'log --graph --oneline --all'

# Ishlatish
git st        # git status
git co main   # git checkout main
git last      # Oxirgi commit
```

### Git Tag (Teglar)

```bash
# Tag yaratish (versiyalar uchun)
git tag v1.0.0
git tag -a v1.0.0 -m "Version 1.0.0"  # Annotated tag

# Tag larni ko'rish
git tag
git tag -l "v1.*"

# Tag push qilish
git push origin v1.0.0
git push --tags

# Tag checkout
git checkout v1.0.0
```

---

## Amaliy Misollar

### 1. Yangi Loyiha Boshlash

```bash
# 1. Katalog yaratish
mkdir myproject
cd myproject

# 2. Git init
git init
# Initialized empty Git repository in /path/myproject/.git/

# 3. .gitignore yaratish
echo "*.log" > .gitignore
echo "target/" >> .gitignore

# 4. README yaratish
echo "# My Project" > README.md

# 5. Birinchi commit
git add .
git commit -m "Initial commit"

# 6. GitHub repository bilan ulash
git remote add origin https://github.com/username/myproject.git
git push -u origin main
```

### 2. Feature Development

```bash
# 1. Yangi branch
git checkout -b feature/login

# 2. O'zgarishlar qilish
echo "login feature" > login.java
git add login.java
git commit -m "Add login feature"

# 3. Main branch ga o'tish
git checkout main

# 4. O'zgarishlarni olish (team members dan)
git pull origin main

# 5. Feature branch ni merge
git merge feature/login

# 6. Push qilish
git push origin main

# 7. Branch ni tozalash
git branch -d feature/login
```

### 3. Conflict Resolution

```bash
# Conflict scenario
# Two developers change same file

# Developer A
git checkout -b feature/a
echo "Line from A" > file.txt
git add file.txt
git commit -m "A's change"
git push origin feature/a

# Developer B
git checkout -b feature/b
echo "Line from B" > file.txt
git add file.txt
git commit -m "B's change"

# Merge qilishda conflict
git checkout main
git merge feature/a  # OK
git merge feature/b  # CONFLICT!

# Conflict ni manual hal qilish
# file.txt ni ochib, conflict ni hal qilish:
<<<<<<< HEAD
Line from A
=======
Line from B
>>>>>>> feature/b

# Hal qilingach:
git add file.txt
git commit -m "Merge feature/b"
```

### 4. Hotfix Branch

```bash
# Production bug fix
git checkout -b hotfix/production main

# Fix qilish
echo "bug fixed" > fix.txt
git add fix.txt
git commit -m "Fix critical bug"

# Test qilish
git checkout main
git merge hotfix/production
git tag v1.0.1

# Push qilish
git push origin main --tags

# Branch ni o'chirish
git branch -d hotfix/production
```

### 5. Git Flow (Branching Strategy)

```bash
# Main branch - production ready
# Develop branch - development
# Feature branches - new features
# Release branches - release preparation
# Hotfix branches - production fixes

# Git Flow model
git checkout -b develop main
git checkout -b feature/login develop
git checkout -b release/v1.0 develop
git checkout -b hotfix/v1.0.1 main
```

---

## Git Commands Cheat Sheet

```bash
# ===== BASIC =====
git init                    # Yangi repository
git clone url              # Repository ni clone
git status                 # Status tekshirish
git add file               # Staging ga qo'shish
git commit -m "msg"        # Commit qilish
git log                    # Log ko'rish

# ===== BRANCHING =====
git branch                 # Branch lar ro'yxati
git branch name           # Yangi branch
git checkout name         # Branch ga o'tish
git checkout -b name      # Yaratib o'tish
git merge name            # Branch ni merge
git branch -d name        # Branch o'chirish

# ===== REMOTE =====
git remote -v             # Remote ko'rish
git push origin main      # Push qilish
git pull origin main      # Pull qilish
git fetch origin          # Fetch qilish
git clone url             # Clone qilish

# ===== UNDO =====
git reset HEAD~1          # Oxirgi commit ni bekor qilish
git revert HEAD           # Yangi commit bilan qaytarish
git checkout -- file      # Faylni qaytarish
git reset --hard HEAD     # Hammasini qaytarish

# ===== STASH =====
git stash                 # Saqlash
git stash pop            # Qaytarish
git stash list           # Ro'yxat

# ===== TAG =====
git tag v1.0              # Tag yaratish
git push --tags          # Tag larni push
```

---

## Tekshiruv Savollari

### Lesson 9.1 - Git

1. **Git nima? Uni qanday ishlatishimiz mumkin?**
2. **Version control nima?**
3. **Git bizga nima uchun kerak?**
4. **git pull request va git push request larni o'rtasida nima farq bor?**
5. **Git commit checksum nima va nima uchun kerak?**
6. **Git reset va revert o'rtasidagi farq?**
7. **Git branch nima va nima uchun kerak?**

### Lesson 9.2 - GitHub

1. **GitHub nima?**
2. **Git va GitHub o'rtasidagi farq?**
3. **Gitda merge qilish nima?**
4. **Git repository nima?**
5. **Git clone nima qiladi?**
6. **Pull Request nima va qanday ishlaydi?**
7. **.gitignore fayli nima uchun kerak?**

---

## Qo'shimcha Resurslar

- **[Git Documentation](https://git-scm.com/doc)** - Rasmiy dokumentatsiya
- **[GitHub Guides](https://guides.github.com/)** - GitHub qo'llanmalari
- **[Git Cheat Sheet](https://education.github.com/git-cheat-sheet-education.pdf)** - Git komandalari
- **[Oh Shit, Git!?!](https://ohshitgit.com/)** - Git xatolarini tuzatish
- **[Learn Git Branching](https://learngitbranching.js.org/)** - Interaktiv o'rganish

---

**Keyingi mavzu:** [Build Tools (Maven/Gradle)](./10%20-%20Logging%20API.md)  
**[Mundarijaga qaytish](../README.md)**

> O'rganishda davom etamiz! 🚀
