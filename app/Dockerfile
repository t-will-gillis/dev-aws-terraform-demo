FROM python:3.11-slim
WORKDIR /app
COPY app.py .
COPY requirements.txt .
RUN pip install --upgrade pip && pip install -r requirements.txt
CMD ["python", "app.py"]