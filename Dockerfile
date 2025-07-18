# Python 3.10-slim bazaviy imiji
FROM python:3.10-slim

# .pyc fayllar yozilmasin va loglar bir zumda chiqsin
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Render sizga beradigan PORT o‘zgaruvchisini oladi,
# bo‘lmasa default 5000
ENV PORT=5000

# Ishlaydigan papka
WORKDIR /app

# Sistemaga kerakli build-essential paketini o‘rnatib,
# cache papkalarni tozalaymiz
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

# requirements.txt ni konteynerga ko‘chirib,
# Python paketlarini o‘rnatamiz
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install gunicorn

# Loyihaning qolgan fayllarini ham ko‘chiramiz
COPY . .

# Render va Docker uchun port deklaratsiyasi
EXPOSE 5000

# Gunicorn yordamida production‑ready serverni ishga tushiramiz;
# PORT muhit o‘zgaruvchisidan foydalanamiz
CMD ["gunicorn", "app:app", "--bind", "0.0.0.0:${PORT}", "--timeout", "120"]
