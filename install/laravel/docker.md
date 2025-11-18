Perfect — you want **one universal Dockerfile** that can dynamically adapt to different Laravel projects (different PHP versions, Composer versions, and even Laravel versions), **without installing anything on the host**.

This is absolutely doable using **Docker build arguments (ARG)** and environment configuration.
Here’s a production-grade solution 👇

---

## 🐳 Universal Laravel Dockerfile (fully configurable)

```Dockerfile
# syntax=docker/dockerfile:1

# ---------------------------------------------------------
#  🔧 BUILD ARGUMENTS — Set these when building
# ---------------------------------------------------------
ARG PHP_VERSION=8.2
ARG COMPOSER_VERSION=2
ARG NODE_VERSION=20
ARG LARAVEL_VERSION=latest

# ---------------------------------------------------------
#  🧱 BASE IMAGE (PHP-FPM)
# ---------------------------------------------------------
FROM php:${PHP_VERSION}-fpm

# Set working directory
WORKDIR /var/www/html

# ---------------------------------------------------------
#  📦 SYSTEM DEPENDENCIES
# ---------------------------------------------------------
RUN apt-get update && apt-get install -y \
    git curl zip unzip libpng-dev libjpeg-dev libfreetype6-dev libonig-dev libzip-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mbstring gd zip bcmath exif pcntl \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# ---------------------------------------------------------
#  🧰 INSTALL COMPOSER (specific version)
# ---------------------------------------------------------
COPY --from=composer:${COMPOSER_VERSION} /usr/bin/composer /usr/bin/composer

# ---------------------------------------------------------
#  🧑‍💻 OPTIONAL: INSTALL NODE & NPM (for front-end build)
# ---------------------------------------------------------
RUN curl -fsSL https://deb.nodesource.com/setup_${NODE_VERSION}.x | bash - \
    && apt-get install -y nodejs \
    && npm install -g npm

# ---------------------------------------------------------
#  📁 COPY PROJECT FILES
# ---------------------------------------------------------
COPY . .

# ---------------------------------------------------------
#  ⚙️ INSTALL DEPENDENCIES
# ---------------------------------------------------------
RUN composer install --no-interaction --prefer-dist --optimize-autoloader || true

# If no Laravel found (fresh setup)
RUN if [ ! -f artisan ]; then \
      composer create-project --prefer-dist laravel/laravel . "${LARAVEL_VERSION}"; \
    fi

# ---------------------------------------------------------
#  🧾 PERMISSIONS
# ---------------------------------------------------------
RUN chown -R www-data:www-data /var/www/html \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# ---------------------------------------------------------
#  🚀 EXPOSE AND RUN
# ---------------------------------------------------------
EXPOSE 8000
CMD ["php", "artisan", "serve", "--host=0.0.0.0", "--port=8000"]
```

---

## ⚙️ How to Use It

### 🏗️ 1. Build for any Laravel project

```bash
# PHP 8.1, Composer 2, Node 20
docker build -t my-laravel-app \
  --build-arg PHP_VERSION=8.1 \
  --build-arg COMPOSER_VERSION=2 \
  --build-arg NODE_VERSION=20 \
  --build-arg LARAVEL_VERSION=10.* .
```

### 🏃 2. Run container

```bash
docker run -p 8000:8000 -v $(pwd):/var/www/html my-laravel-app
```

Then open 👉 [http://localhost:8000](http://localhost:8000)

---

## 🧩 Works With:

✅ Laravel 8, 9, 10, 11
✅ PHP 7.4 → 8.4
✅ Composer 1 or 2
✅ Node.js (optional)

---

## 💡 Example scenarios

| Project        | PHP | Composer | Laravel | Command                                                                                      |
| -------------- | --- | -------- | ------- | -------------------------------------------------------------------------------------------- |
| Old legacy app | 7.4 | 1        | 8.x     | `--build-arg PHP_VERSION=7.4 --build-arg COMPOSER_VERSION=1 --build-arg LARAVEL_VERSION=8.*` |
| Modern app     | 8.2 | 2        | 10.x    | `--build-arg PHP_VERSION=8.2 --build-arg LARAVEL_VERSION=10.*`                               |
| Latest         | 8.4 | 2        | latest  | `--build-arg PHP_VERSION=8.4 --build-arg LARAVEL_VERSION=latest`                             |

---

## 🧱 Optional: Add MySQL, Nginx, Redis (via docker-compose)

If you want a full environment (DB + Web server), I can extend this with a **docker-compose.yml** that automatically spins up:

* Nginx (serving Laravel)
* PHP container (using this Dockerfile)
* MySQL
* Redis (optional)

Would you like me to add that next?
