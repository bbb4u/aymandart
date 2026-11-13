# واجب الأسبوع 3: تطبيق العداد وإدارة الحالة بنسختين متطابقتين (GetX و Riverpod)

هذا المستودع يحتوي على التطبيق الكامل لواجب الأسبوع الثالث لمقرر تطوير تطبيقات الهاتف المحمول باستخدام **Flutter**، حيث تم تنفيذ تطبيق العداد التفاعلي مع التحكم بالمؤقت وتحليل دورة الحياة مرتين بنسختين متطابقتين تماماً من حيث الوظائف والشاشات لمقارنة أساليب إدارة الحالة الحديثة.

---

## 📁 هيكلية المشروع (Project Structure)

```text
lib/
├── main.dart                          # نقطة الانطلاق + ProviderScope + شاشة التنقل الرئيسية
├── models/
│   └── timer_state.dart              # حالة المؤقت المشتركة (TimerStatus Enum)
├── getx_version/                      # 1. المجلد الخاص بتطبيق GetX
│   ├── counter_controller.dart        # GetxController + Rx variables + Lifecycle + Timer
│   └── counter_screen_getx.dart       # واجهة GetX باستخدام Obx()
└── riverpod_version/                  # 2. المجلد الخاص بتطبيق Riverpod 2.x
    ├── counter_state.dart             # كلاس الحالة غير القابلة للتعديل (Immutable State)
    ├── counter_notifier.dart          # Notifier + NotifierProvider + Lifecycle (ref.onDispose)
    └── counter_screen_riverpod.dart   # واجهة Riverpod باستخدام ConsumerWidget / ref.watch
```

---

## ⚡ 1. نسخة GetX (`lib/getx_version/`)

- **المتحكم (`CounterGetxController`)**:
  - يرث من `GetxController` مع دمج `WidgetsBindingObserver`.
  - إدارة المتغيرات التفاعلية باستخدام `.obs` (`counter`, `timerStatus`, `secondsElapsed`, `lifecycleLogs`).
  - دوال التحكم بالعداد: `increment()`, `decrement()`, `reset()`.
  - دوال التحكم بالمؤقت: `startTimer()`, `pauseTimer()`, `resumeTimer()`, `stopTimer()`.
- **تحليل دورة الحياة (Lifecycle Hooks)**:
  - `onInit()`: تهيئة المتحكم وربط مراقب التطبيق.
  - `onReady()`: استدعاء عند جهوزية الـ Widget على الشاشة.
  - `onClose()`: إلغاء المؤقت وإلغاء المراقب لمنع تسريب الذاكرة (Memory Leak Prevention).
  - `didChangeAppLifecycleState()`: مراقبة حالة التطبيق عند الانتقال إلى الخلفية (Paused) واستئنافه تلقائياً.
- **استهلاك الحالة (`CounterScreenGetX`)**:
  - استخدام ودجة `Obx(() => ...)` لإعادة بناء الأجزاء المتغيرة فقط بدقة وكفاءة عالية.

---

## 🌊 2. نسخة Modern Riverpod 2.x (`lib/riverpod_version/`)

- **نموذج الحالة (`CounterState`)**:
  - كلاس غير قابل للتعديل المباشر (Immutable State) مع ميثود `copyWith` لإنشاء حالات جديدة نقية.
- **المزوّد والمتحكم (`CounterNotifier` & `counterProvider`)**:
  - استخدام معيار Riverpod 2.x الحديث: `Notifier<CounterState>` و `NotifierProvider`.
  - دورة الحياة وتنظيف الموارد من خلال ميثود `ref.onDispose()` المدمجة لإلغاء المؤقت تلقائياً عند انتهاء الحاجة للـ Provider.
- **استهلاك الحالة (`CounterScreenRiverpod`)**:
  - استخدام `ConsumerStatefulWidget` و `ConsumerWidget` مع `ref.watch(counterProvider)` للإنصات للتغييرات والتحديث التلقائي للواجهة.
  - مراقبة دورة حياة التطبيق عبر `WidgetsBindingObserver` وتسجيل الأحداث.

---

## 📊 جدول مقارنة بين النسختين (Comparison Table)

| وجه المقارنة | نسخة GetX | نسخة Riverpod 2.x |
| :--- | :--- | :--- |
| **نوع إدارة الحالة** | Reactive State Management (Rx) | Immutable State & Declarative Providers |
| **تعريف المتحكم** | يرث `GetxController` | يرث `Notifier<T>` |
| **بناء الواجهة** | `Obx(() => Widget)` | `ref.watch(provider)` مع `Consumer` |
| **تنظيف الموارد** | عبر ميثود `onClose()` | عبر كولباك `ref.onDispose()` |
| **حقن الاعتماديات** | `Get.put(Controller())` | `ref.read(provider.notifier)` بدون سياق شجري مقيد |
| **الأمان ضد الأخطاء** | Runtime lookup | Compile-time safe (لا تحدث أخطاء ProviderNotFound) |

---

## 🚀 كيفية تشغيل المشروع (How to Run)

```bash
# 1. استيراد الحزم
flutter pub get

# 2. تشغيل التطبيق على المحاكي أو جهاز حقيقي
flutter run
```
