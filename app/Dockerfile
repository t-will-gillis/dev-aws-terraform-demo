FROM python:3.11-slim
WORKDIR /app
COPY app.py .
COPY requirements.txt .
RUN pip install --upgrade pip wheel "jaraco.context>=6.1.0" && pip install -r requirements.txt
CMD ["python", "app.py"]
Flask>=3.0.0