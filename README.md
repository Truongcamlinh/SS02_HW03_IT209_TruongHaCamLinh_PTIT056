# SS02_HW03 - Basic Nginx Web Server

## Nội dung bài làm

Các tệp cần nộp nằm đúng đường dẫn đề bài:

```text
homework/session_02/ex3/
├── index.html
├── install.sh
└── ptit-web.conf
```

- `index.html`: trang tĩnh hiển thị đúng câu `Welcome to PTIT DevOps Course - Session 02`.
- `ptit-web.conf`: Server Block lắng nghe HTTP cổng 80, phục vụ `/var/www/ptit-web/html`.
- `install.sh`: cài Nginx, chép tệp, tạo symlink, tắt site mặc định, kiểm tra cấu hình và reload.

## Cài đặt trên Ubuntu Droplet

```bash
cd homework/session_02/ex3
chmod +x install.sh
sudo ./install.sh
```

Script thực hiện tương đương các lệnh:

```bash
sudo apt update
sudo apt install -y nginx
sudo mkdir -p /var/www/ptit-web/html
sudo cp index.html /var/www/ptit-web/html/index.html
sudo cp ptit-web.conf /etc/nginx/sites-available/ptit-web.conf
sudo ln -sfn /etc/nginx/sites-available/ptit-web.conf \
  /etc/nginx/sites-enabled/ptit-web.conf
sudo unlink /etc/nginx/sites-enabled/default
sudo nginx -t
sudo systemctl reload nginx
```

`set -e` làm script dừng nếu `nginx -t` báo lỗi, vì vậy cấu hình sai sẽ không bị reload.

## Kiểm tra

Trên Droplet:

```bash
sudo nginx -t
sudo systemctl status nginx --no-pager
curl -i http://localhost
```

Kết quả `nginx -t` mong đợi:

```text
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
```

Từ máy cá nhân, mở:

```text
http://<IP_ADDRESS_DROPLET>
```

Trang web phải hiển thị: **Welcome to PTIT DevOps Course - Session 02**.

Nếu Droplet bật UFW, mở cổng HTTP bằng:

```bash
sudo ufw allow 'Nginx HTTP'
```

## Giải thích cấu hình

- `listen 80` và `listen [::]:80`: nhận kết nối HTTP qua IPv4 và IPv6.
- `server_name _`: nhận request theo IP Droplet khi chưa có domain.
- `root`: trỏ đến đúng thư mục mã nguồn theo yêu cầu.
- `try_files`: chỉ trả tệp tồn tại, nếu không có thì trả HTTP 404.
- Cấu hình mặc định bị unlink để tránh hai site cùng đóng vai trò mặc định trên cổng 80.
