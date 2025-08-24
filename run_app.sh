#!/bin/bash

# 🚀 سكريبت تشغيل تطبيق الستوريز
# نفذ هذا الملف على جهازك المحلي

echo "🚀 بدء تشغيل تطبيق الستوريز..."
echo "======================================"

# التحقق من وجود Flutter
echo "📱 التحقق من وجود Flutter..."
if ! command -v flutter &> /dev/null; then
    echo "❌ خطأ: Flutter غير مثبت!"
    echo "💡 قم بتحميل Flutter من: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter متوفر!"

# عرض إصدار Flutter
echo "📋 إصدار Flutter:"
flutter --version
echo ""

# التأكد من وجود الملفات المطلوبة
echo "📁 التحقق من ملفات المشروع..."
if [ ! -f "pubspec.yaml" ]; then
    echo "❌ خطأ: ملف pubspec.yaml غير موجود!"
    echo "💡 تأكد من أنك في مجلد المشروع الصحيح"
    exit 1
fi

if [ ! -d "lib" ]; then
    echo "❌ خطأ: مجلد lib غير موجود!"
    exit 1
fi

echo "✅ ملفات المشروع موجودة!"

# تنظيف المشروع
echo ""
echo "🧹 تنظيف المشروع..."
flutter clean

# تثبيت التبعيات
echo ""
echo "📦 تثبيت التبعيات..."
flutter pub get

# التحقق من وجود أجهزة متصلة
echo ""
echo "📱 البحث عن الأجهزة المتصلة..."
flutter devices

# عرض خيارات التشغيل
echo ""
echo "🎮 خيارات التشغيل المتاحة:"
echo "1️⃣  تشغيل على أي جهاز متاح: flutter run"
echo "2️⃣  تشغيل على Android: flutter run -d android"
echo "3️⃣  تشغيل على iOS: flutter run -d ios"
echo "4️⃣  تشغيل في وضع debug: flutter run --debug"
echo "5️⃣  تشغيل في وضع release: flutter run --release"

echo ""
echo "🚀 بدء تشغيل التطبيق..."
echo "======================================"

# تشغيل التطبيق
flutter run

echo ""
echo "🎉 تم تشغيل التطبيق بنجاح!"
echo "💡 اذهب لتبويب 'Status' لاختبار ميزة الستوريز الجديدة!"