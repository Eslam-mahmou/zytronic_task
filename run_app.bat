@echo off
chcp 65001 >nul

REM 🚀 سكريبت تشغيل تطبيق الستوريز - إصدار Windows
REM نفذ هذا الملف على جهازك Windows

echo 🚀 بدء تشغيل تطبيق الستوريز...
echo ======================================

REM التحقق من وجود Flutter
echo 📱 التحقق من وجود Flutter...
where flutter >nul 2>nul
if %ERRORLEVEL% NEQ 0 (
    echo ❌ خطأ: Flutter غير مثبت!
    echo 💡 قم بتحميل Flutter من: https://flutter.dev/docs/get-started/install
    pause
    exit /b 1
)

echo ✅ Flutter متوفر!

REM عرض إصدار Flutter
echo 📋 إصدار Flutter:
flutter --version
echo.

REM التأكد من وجود الملفات المطلوبة
echo 📁 التحقق من ملفات المشروع...
if not exist "pubspec.yaml" (
    echo ❌ خطأ: ملف pubspec.yaml غير موجود!
    echo 💡 تأكد من أنك في مجلد المشروع الصحيح
    pause
    exit /b 1
)

if not exist "lib" (
    echo ❌ خطأ: مجلد lib غير موجود!
    pause
    exit /b 1
)

echo ✅ ملفات المشروع موجودة!

REM تنظيف المشروع
echo.
echo 🧹 تنظيف المشروع...
flutter clean

REM تثبيت التبعيات
echo.
echo 📦 تثبيت التبعيات...
flutter pub get

REM التحقق من وجود أجهزة متصلة
echo.
echo 📱 البحث عن الأجهزة المتصلة...
flutter devices

REM عرض خيارات التشغيل
echo.
echo 🎮 خيارات التشغيل المتاحة:
echo 1️⃣  تشغيل على أي جهاز متاح: flutter run
echo 2️⃣  تشغيل على Android: flutter run -d android
echo 3️⃣  تشغيل على Windows: flutter run -d windows
echo 4️⃣  تشغيل في وضع debug: flutter run --debug
echo 5️⃣  تشغيل في وضع release: flutter run --release

echo.
echo 🚀 بدء تشغيل التطبيق...
echo ======================================

REM تشغيل التطبيق
flutter run

echo.
echo 🎉 تم تشغيل التطبيق بنجاح!
echo 💡 اذهب لتبويب 'Status' لاختبار ميزة الستوريز الجديدة!
pause