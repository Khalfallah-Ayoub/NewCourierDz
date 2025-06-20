# استخدم صورة PHP الرسمية مع Apache
FROM php:8.2-apache

# تثبيت الاعتمادات اللازمة
RUN apt-get update && apt-get install -y \
    unzip \
    git \
    libzip-dev \
    && docker-php-ext-install zip \
    && curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer

# تحديد مجلد العمل
WORKDIR /var/www/html

# نسخ ملفات composer أولاً لتقليل وقت البناء في حالة التغييرات
COPY composer.json composer.lock ./ 

# تثبيت الاعتمادات بدون تشغيل السكريبتات أو التحميل المسبق
RUN composer install --no-scripts --no-autoloader

# نسخ باقي ملفات المشروع (كل شيء)
COPY . .

# إنشاء ملفات autoload وتحسينها
RUN composer dump-autoload --optimize

# تكوين Apache ليستخدم مجلد public كجذر للويب
RUN sed -i 's|/var/www/html|/var/www/html/public|g' /etc/apache2/sites-available/000-default.conf

# تفعيل mod_rewrite
RUN a2enmod rewrite

# إعطاء صلاحيات للـ Apache
RUN chown -R www-data:www-data /var/www/html

# تفعيل إعدادات php للـ production
RUN mv "$PHP_INI_DIR/php.ini-production" "$PHP_INI_DIR/php.ini"

# فتح منفذ 80
EXPOSE 80


#ah hkdj khkhkh jdmkqfhpdslkjhfja
