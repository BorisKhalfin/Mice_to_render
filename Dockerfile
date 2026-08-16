FROM python:3.11-slim

# Install Nginx и Supervisor
RUN apt-get update && apt-get install -y nginx supervisor && rm -rf /var/lib/apt/lists/*

# Install Python
WORKDIR /app
RUN pip install --no-cache-dir fastapi uvicorn

# Config
COPY api/main.py /app/main.py
COPY html /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf

# Run the Supervisor
RUN echo '[supervisord]\nnodaemon=true\n\n[program:fastapi]\ncommand=uvicorn main:app --host 127.0.0.1 --port 8000\n\n[program:nginx]\ncommand=nginx -g "daemon off;"' > /etc/supervisor/conf.d/supervisord.conf

EXPOSE 80

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
