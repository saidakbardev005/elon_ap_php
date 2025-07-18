# Python 3.10‑slim bazaviy imiji
FROM python:3.10-slim

# .pyc fayllar yozilmasin, loglar bir zumda chiqsin
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# Render / Compose PORT o‘zgaruvchisini olamiz (bo‘lmasa 5000)
ENV PORT=5000

WORKDIR /app

# build‑essential paketini o‘rnatib, cache’ni tozalaymiz
RUN apt-get update \
 && apt-get install -y --no-install-recommends build-essential \
 && rm -rf /var/lib/apt/lists/*

# Dependency’larni o‘rnatamiz
COPY requirements.txt .
RUN pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt \
 && pip install gunicorn

# Barcha kodni ko‘chiramiz
COPY . .

# Portni deklaratsiya qilamiz
EXPOSE 5000

# **Eslatma:** JSON‑aray (`["gunicorn", ...]`) muhit o‘zgaruvchilarni
# kengaytirmaydi — shuning uchun shell‐form ishlatamiz:
CMD gunicorn app:app --bind 0.0.0.0:$PORT --timeout 120
