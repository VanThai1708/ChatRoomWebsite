# Sử dụng Python 3.10 làm base image
FROM python:3.10-slim

# Thiết lập biến môi trường
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

# Cập nhật hệ thống và cài đặt các gói cần thiết
RUN apt-get update && apt-get install -y --no-install-recommends \
    build-essential

# Tạo thư mục làm việc trong container
WORKDIR /code

# Sao chép tệp requirements.txt vào thư mục làm việc
COPY requirements.txt /code/

# Cài đặt các dependencies từ requirements.txt
RUN pip install --no-cache-dir -r requirements.txt

# Sao chép toàn bộ mã nguồn của ứng dụng vào thư mục làm việc
COPY . /code/

# Chạy collectstatic để thu thập các tệp tĩnh
RUN python manage.py collectstatic --noinput

# Chạy lệnh để khởi động ứng dụng
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "studybud.wsgi:application"]
