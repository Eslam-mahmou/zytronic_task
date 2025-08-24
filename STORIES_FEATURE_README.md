# 📸 ميزة الستوريز - Stories Feature

## نظرة عامة
تم تطوير ميزة الستوريز لتكون مطابقة تماماً لـ WhatsApp، مع إمكانية رفع الصور والفيديوهات ومشاهدتها مع تايمر تفاعلي.

## 🎯 المميزات الرئيسية

### ✅ رفع الستوريز
- **اختيار الصور**: من معرض الصور مع إمكانية إضافة تعليق
- **اختيار الفيديوهات**: حد أقصى 30 ثانية مع إمكانية إضافة تعليق  
- **رفع تلقائي**: إلى Firebase Storage بشكل آمن
- **انتهاء صلاحية**: تلقائياً بعد 24 ساعة

### ✅ عرض الستوريز
- **"My Status"**: قسم خاص لإضافة ومشاهدة ستوريز المستخدم الحالي
- **دائرة ملونة**: للستوريز غير المُشاهدة (أخضر)
- **دائرة رمادية**: للستوريز المُشاهدة
- **ترتيب ذكي**: أحدث الستوريز في الأعلى

### ✅ مشاهدة الستوريز
- **واجهة تفاعلية**: مثل WhatsApp تماماً
- **شريط التقدم**: لكل ستوري منفرد
- **تايمر تلقائي**: 5 ثوانِ للصور، مدة الفيديو للفيديوهات
- **التنقل**: بالضغط على الجانبين أو السحب
- **إيقاف مؤقت**: بالضغط المطول على الشاشة
- **معلومات المُرسِل**: الاسم والوقت
- **عرض التعليق**: إن وُجد

## 🚀 كيفية الاستخدام

### إضافة ستوري جديد

#### الطريقة الأولى: من تبويب Status
1. انتقل إلى تبويب "Status" من الشريط السفلي
2. اضغط على "My status" أو الدائرة الخضراء بعلامة +
3. اختر "Photo" أو "Video"
4. اختر الملف من المعرض
5. أضف تعليق (اختياري)
6. اضغط "Upload"

#### الطريقة الثانية: من أيقونة الكاميرا
1. في تبويب "Status"، اضغط على أيقونة الكاميرا في الشريط العلوي
2. اختر "Photo" أو "Video"
3. اختر الملف من المعرض
4. أضف تعليق (اختياري)
5. اضغط "Upload"

### مشاهدة الستوريز

#### مشاهدة ستوريز الآخرين
1. في تبويب "Status"، اضغط على أي ستوري في قسم "Recent updates"
2. الستوري سيفتح في شاشة مخصصة
3. استخدم الضغط على الجانبين للتنقل
4. اضغط مطولاً لإيقاف الستوري مؤقتاً

#### مشاهدة ستوريز الخاصة بك
1. اضغط على "My status" أو "Tap to view your status"
2. ستفتح جميع ستوريزك بنفس الواجهة التفاعلية

## 🛠️ التقنيات المستخدمة

### Backend & Storage
- **Firebase Firestore**: تخزين بيانات الستوريز وبيانات المستخدمين
- **Firebase Storage**: تخزين الصور والفيديوهات
- **Clean Architecture**: تنظيم الكود بطبقات منفصلة

### UI & Navigation  
- **Flutter BLoC**: إدارة الحالة
- **Video Player**: تشغيل الفيديوهات
- **Cached Network Image**: عرض الصور مع تخزين مؤقت
- **Image Picker**: اختيار الصور والفيديوهات

### Permissions
- **Android**: Camera, Storage, Media permissions
- **iOS**: Camera, Photo Library, Microphone permissions

## 📱 المتطلبات

### Dependencies المضافة
```yaml
firebase_storage: ^11.7.0
image_picker: ^1.0.4
video_player: ^2.8.1
permission_handler: ^11.0.1
path: ^1.8.3
```

### قاعدة البيانات
#### Collection: `stories`
```json
{
  "userId": "string",
  "userName": "string", 
  "mediaUrl": "string",
  "type": "image|video",
  "createdAt": "timestamp",
  "expiresAt": "timestamp", 
  "isViewed": "boolean",
  "caption": "string?"
}
```

## 🔧 الإعدادات المطلوبة

### Android Permissions
في `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.READ_EXTERNAL_STORAGE" />
<uses-permission android:name="android.permission.READ_MEDIA_IMAGES" />
<uses-permission android:name="android.permission.READ_MEDIA_VIDEO" />
```

### iOS Permissions
في `ios/Runner/Info.plist`:
```xml
<key>NSCameraUsageDescription</key>
<string>This app needs access to camera to take photos for stories</string>
<key>NSPhotoLibraryUsageDescription</key>
<string>This app needs access to photo library to select images and videos for stories</string>
```

## 🎨 التصميم

### ألوان WhatsApp
- **اللون الأساسي**: `#25D366` (أخضر WhatsApp)
- **ستوري غير مُشاهد**: دائرة خضراء
- **ستوري مُشاهد**: دائرة رمادية فاتحة
- **خلفية المشاهدة**: أسود
- **شريط التقدم**: أبيض

### مكونات الواجهة
- **قسم "My Status"**: صورة شخصية مع زر + أخضر صغير
- **Recent Updates**: قائمة عمودية بالستوريز
- **Story Viewer**: شاشة ملء الشاشة مع تحكم تفاعلي

## 🔍 استكشاف الأخطاء

### مشاكل شائعة وحلولها

#### لا تظهر الستوريز
- تأكد من وجود اتصال بالإنترنت
- تحقق من إعدادات Firebase
- راجع console للرسائل التشخيصية

#### لا يمكن رفع الصور/الفيديوهات
- تأكد من منح الأذونات المطلوبة
- تحقق من حجم الملف (يجب أن يكون أقل من 10MB)
- تأكد من إعداد Firebase Storage بشكل صحيح

#### مشاكل في تشغيل الفيديو
- تأكد من أن الفيديو بصيغة مدعومة (MP4)
- تحقق من سرعة الإنترنت
- تأكد من أن مدة الفيديو أقل من 30 ثانية

## 🔮 ميزات مستقبلية

### تحسينات مخططة
- [ ] إمكانية إضافة نص على الصور
- [ ] فلاتر وتأثيرات للصور
- [ ] إشعارات للستوريز الجديدة
- [ ] إحصائيات مشاهدة الستوريز
- [ ] حفظ الستوريز كصور/فيديوهات

### تحسينات الأداء
- [ ] ضغط الصور قبل الرفع
- [ ] تحميل تدريجي للستوريز
- [ ] تحسين استهلاك الذاكرة
- [ ] دعم الوضع المظلم بشكل كامل

## 📞 الدعم التقني

### معلومات تشخيصية
التطبيق يعرض رسائل مفصلة في console تساعد في تشخيص المشاكل:
- `📱` رسائل معلوماتية عامة
- `✅` عمليات نجحت
- `❌` أخطاء يجب حلها
- `⚠️` تحذيرات لا تؤثر على الوظيفة

### ملفات مهمة للدعم
- `lib/data/data_source/stories_data_source.dart` - تفاعل مع Firebase
- `lib/presentaion/layout/tabs/story_screen.dart` - الواجهة الرئيسية
- `lib/presentaion/layout/tabs/widgets/story_viewer_screen.dart` - مشاهدة الستوريز

---

**تم تطوير هذه الميزة لتكون مطابقة تماماً لتجربة WhatsApp مع إضافات تحسن تجربة المستخدم** ✨