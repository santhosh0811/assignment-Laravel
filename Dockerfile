# Stage 1: Build (install dependencies in virtual env)
FROM python:3.11-slim AS builder

WORKDIR /app
COPY requirements.txt .

# Install dependencies into a temporary directory
RUN python -m venv /venv && \
    . /venv/bin/activate && \
    pip install --upgrade pip && \
    pip install --no-cache-dir -r requirements.txt

COPY . .

# Stage 2: Production image
FROM python:3.11-slim

# Copy venv from builder stage
COPY --from=builder /venv /venv
COPY --from=builder /app /app

WORKDIR /app
ENV PATH="/venv/bin:$PATH"

# Port exposed by the app
EXPOSE 8000

CMD ["gunicorn", "main:app", "-b", "0.0.0.0:8000"]
