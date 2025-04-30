FROM python:3.9-slim

RUN pip install flask prometheus_client

COPY microservice.py /app/microservice.py

EXPOSE 8080

CMD ["python3", "/app/microservice.py"]
