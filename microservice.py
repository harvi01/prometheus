from flask import Flask, Response
from prometheus_client import Counter, generate_latest
import platform
import os

app = Flask(__name__)

# Счётчик для HTTP запросов
REQUESTS = Counter("http_requests_total", "Total HTTP requests")

# Функция для определения типа хоста (виртуальная машина, контейнер или физический сервер)
def detect_environment():
    if os.path.exists("/.dockerenv"):
        return "container"
    elif os.path.exists("/sys/class/dmi/id/product_name"):
        with open("/sys/class/dmi/id/product_name") as f:
            name = f.read().lower()
            if "virtual" in name or "vmware" in name:
                return "virtual_machine"
            elif "mac" in name or "dell" in name:
                return "physical_machine"
    return "unknown"

# Маршрут для метрик
@app.route("/metrics")
def metrics():
    REQUESTS.inc()
    env_type = detect_environment()
    env_metric = f'# TYPE host_environment gauge\nhost_environment{{type="{env_type}"}} 1\n'
    return Response(generate_latest() + env_metric.encode(), mimetype="text/plain")

@app.route("/")
def home():
    return "Prometheus metrics available at /metrics"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=8080)
