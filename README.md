# 🐧 LinxGo

**Linux Desktop Environment for Android — Flutter + VNC**

<div align="center">

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Debian](https://img.shields.io/badge/Debian-A81D33?style=for-the-badge&logo=debian&logoColor=white)
![VNC](https://img.shields.io/badge/VNC-0078D4?style=for-the-badge&logoColor=white)
![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)

</div>

---

## 📖 ما هو LinxGo؟

**LinxGo** هو تطبيق أندرويد يتيح لك تشغيل **سطح مكتب لينكس كامل** على جهازك بدون روت (Root). يجمع بين واجهة Flutter جميلة وقوة Linux الحقيقية.

### ✨ لماذا LinxGo؟

| الميزة | الوصف |
|--------|-------|
| 🖥️ **سطح مكتب كامل** | ليس مجرد terminal — سطح مكتب حقيقي مع نوافذ وقائمة وبرامج |
| 🌐 **متصفح كامل** | Firefox, Chromium يعملان داخل لينكس |
| 💻 **VS Code** | محرر أكواد كامل داخل التطبيق |
| 🎮 **تحكم متقدم** | ماوس + كيبورد + جويستيك — مثل Winlator |
| 📁 **إدارة ملفات** | تنقل ملفات بين Android ↔ Linux |
| 🔒 **بدون روت** | يعمل على أي جهاز أندرويد |
| ⚡ **خفيف** | Debian minimal + XFCE — سريع حتى على الأجهزة الضعيفة |

---

## 🏗️ المعمارية

```
┌─────────────────────────────────────────────────────────┐
│                    LinxGo App (Flutter)                  │
├─────────────────────────────────────────────────────────┤
│  🌐 Desktop View (noVNC)  │  ⌨️ Terminal  │  📁 Files   │
├─────────────────────────────────────────────────────────┤
│              Connection Manager / Settings               │
└─────────────────────────────────────────────────────────┘
                           │
                           │ WebSocket (VNC)
                           ▼
┌─────────────────────────────────────────────────────────┐
│                    Termux (Backend)                      │
├─────────────────────────────────────────────────────────┤
│  🐯 TigerVNC Server  │  🔄 websockify  │  📦 proot-distro│
├─────────────────────────────────────────────────────────┤
│              Debian Linux (XFCE Desktop)                 │
│  ┌─────────┐ ┌─────────┐ ┌─────────┐ ┌─────────┐       │
│  │ Firefox │ │VS Code  │ │Terminal │ │  Gimp   │       │
│  └─────────┘ └─────────┘ └─────────┘ └─────────┘       │
└─────────────────────────────────────────────────────────┘
```

---

## 🎮 التحكم

### التحكم باللمس (Touch Mode)

| الحركة | الوظيفة |
|--------|---------|
| **نقرة واحدة** | نقرة يسار (Left Click) |
| **نقرة مطولة** | نقرة يمين (Right Click) |
| **سحب بإصبع** | سحب النافذة (Drag) |
| **Pinch** | تكبير/تصغير (Zoom) |
| **سحب بإصبعين** | تمرير (Scroll) |

### لوحة المفاتيح الافتراضية

| المفتاح | الوظيفة |
|---------|---------|
| `Ctrl` | نسخ / لصق / اختصارات |
| `Alt` | تبديل النوافذ / قوائم |
| `Tab` | التنقل بين الحقول |
| `Esc` | إغلاق / رجوع |
| `F1-F12` | مفاتيح الوظائف |
| `↑↓←→` | أسهم التنقل |

### أزرار الماوس الإضافية

| الزر | الوظيفة |
|------|---------|
| `Right Click` | قائمة السياق |
| `Middle Click` | لصق / إغلاق تبويب |
| `Scroll Up` | تمرير لأعلى |
| `Scroll Down` | تمرير لأسفل |

---

## 📋 المتطلبات

### على جهازك:
- **Android 8.0+**
- **Termux** (من F-Droid أو GitHub)
- **2GB RAM** كحد أدنى (4GB مفضل)
- **500MB** مساحة فارغة

### البرامج المطلوبة في Termux:
```bash
pkg install proot-distro
```

---

## 🚀 التثبيت

### الخطوة 1: تثبيت Termux

حمّل Termux من [F-Droid](https://f-droid.org/packages/com.termux/) (لا من Play Store — النسخة المهجورة).

### الخطوة 2: تثبيت Debian

```bash
pkg install proot-distro
proot-distro install debian
```

### الخطوة 3: إعداد سطح المكتب

```bash
proot-distro login debian
```

داخل Debian:
```bash
apt update && apt install -y \
    tigervnc-standalone-server \
    tigervnc-common \
    xfce4 \
    xfce4-goodies \
    websockify \
    novnc \
    firefox-esr \
    mousepad
```

### الخطوة 4: تشغيل VNC Server

```bash
# تعيين كلمة المرور
vncpasswd

# إنشاء ملف الإعدادات
mkdir -p ~/.vnc
echo "xfce4-session &" > ~/.vnc/xstartup
chmod +x ~/.vnc/xstartup

# تشغيل السيرفر
vncserver :1 -geometry 1280x720 -depth 24 -localhost yes
```

### الخطوة 5: تشغيل WebSocket Proxy

```bash
websockify -D 6080 localhost:5901
```

### الخطوة 6: افتح LinxGo واتصل!

---

## 📱 استخدام التطبيق

### الشاشة الرئيسية

```
┌─────────────────────────────────────────┐
│  🐧 LinxGo                    ⚙️  ⋮     │
├─────────────────────────────────────────┤
│                                         │
│     ┌─────────────────────────┐         │
│     │                         │         │
│     │   Linux Desktop View    │         │
│     │   (noVNC / WebView)     │         │
│     │                         │         │
│     │                         │         │
│     └─────────────────────────┘         │
│                                         │
├─────────────────────────────────────────┤
│ ⌨️ │ 🖱️ │ 📋 │ 🔍+ │ 🔍− │ 📁 │ 💻    │
└─────────────────────────────────────────┘
```

### شريط الأدوات السفلي

| الأيقونة | الوظيفة |
|----------|---------|
| ⌨️ | فتح/إغلاق لوحة المفاتيح الافتراضية |
| 🖱️ | تبديل وضع الماوس (Touch / Touchpad) |
| 📋 | مزامنة الحافظة (Clipboard) |
| 🔍+ | تكبير سطح المكتب |
| 🔍− | تصغير سطح المكتب |
| 📁 | فتح مدير الملفات |
| 💻 | فتح Terminal مدمج |

---

## ⚙️ الإعدادات

### إعدادات الاتصال

| الإعداد | القيمة الافتراضية | الوصف |
|---------|-------------------|-------|
| `Host` | `localhost` | عنوان السيرفر |
| `Port` | `6080` | منفذ WebSocket |
| `VNC Port` | `5901` | منفذ VNC |
| `Password` | `••••••` | كلمة مرور VNC |
| `Resolution` | `1280x720` | دقة سطح المكتب |
| `Color Depth` | `24-bit` | عمق الألوان |
| `Quality` | `Medium` | جودة الصورة |

### إعدادات التحكم

| الإعداد | القيمة الافتراضية | الوصف |
|---------|-------------------|-------|
| `Touch Mode` | `Direct` | وضع اللمس |
| `Mouse Sensitivity` | `50%` | حساسية الماوس |
| `Scroll Speed` | `3` | سرعة التمرير |
| `Keyboard Layout` | `QWERTY` | تخطيط الكيبورد |
| `Haptic Feedback` | `On` | الاهتزاز عند اللمس |

---

## 📂 هيكل المشروع

```
linxgo/
├── android/                    # Android configuration
├── ios/                        # iOS configuration
├── lib/
│   ├── main.dart               # App entry point
│   ├── core/
│   │   ├── constants/          # App constants
│   │   ├── theme/              # App theme
│   │   ├── utils/              # Utilities
│   │   └── services/           # Core services
│   ├── features/
│   │   ├── desktop/            # VNC Desktop View
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   ├── terminal/           # Terminal
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   ├── file_manager/       # File Manager
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   ├── settings/           # Settings
│   │   │   ├── screens/
│   │   │   ├── widgets/
│   │   │   └── controllers/
│   │   └── controls/           # Mouse/Keyboard Controls
│   │       ├── screens/
│   │       ├── widgets/
│   │       └── controllers/
│   └── shared/
│       ├── widgets/            # Shared widgets
│       └── models/             # Data models
├── assets/
│   ├── images/                 # App images
│   ├── icons/                  # App icons
│   └── novnc/                  # noVNC web files
├── scripts/
│   ├── setup_debian.sh         # Debian setup script
│   ├── start_vnc.sh            # VNC start script
│   └── install_proot.sh        # proot-distro install
├── pubspec.yaml
└── README.md
```

---

## 🛠️ التطوير

### المتطلبات:
- Flutter 3.24+
- Dart 3.5+
- Android Studio / VS Code

### التشغيل:

```bash
git clone https://github.com/Sulaiman507/LinxGo.git
cd LinxGo
flutter pub get
flutter run
```

### بناء APK:

```bash
flutter build apk --release
```

---

## 🤝 المساهمة

نرحب بالمساهمات! إذا تبي تساعد:

1. افork للمستودع
2. أنشئ branch جديد (`git checkout -b feature/amazing-feature`)
3. اعمل commit (`git commit -m 'Add amazing feature'`)
4. اعمل push (`git push origin feature/amazing-feature`)
5. افتح Pull Request

---

## 📜 الترخيص

هذا المشروع مرخص تحت [MIT License](LICENSE).

---

## 📬 التواصل

- **المطور:** سليمان الرمادي
- **GitHub:** [@Sulaiman507](https://github.com/Sulaiman507)

---

<div align="center">

**صُنع بـ ❤️ لينكس و Flutter**

⭐ إذا عجبك المشروع، لا تنسى النجمة!

</div>
