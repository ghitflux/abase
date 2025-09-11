# 🚀 Instruções de Deploy - Sistema ABASE

## 📋 Pré-requisitos para Deploy

### Ambiente de Produção
- **Servidor:** Ubuntu 20.04+ ou similar
- **Python:** 3.12+
- **PostgreSQL:** 14+
- **Nginx:** 1.18+
- **Node.js:** 18+ (para compilar CSS)
- **Git:** Para clonagem do repositório

### Variáveis de Ambiente
Configurar as seguintes variáveis no servidor:

```bash
# Aplicação
SECRET_KEY=sua-chave-super-secreta-aqui
DEBUG=False
ENVIRONMENT=production

# Banco de Dados
DB_NAME=abase_production
DB_USER=abase_user
DB_PASS=senha-super-forte
DB_HOST=localhost
DB_PORT=5432

# Segurança
ALLOWED_HOSTS=seu-dominio.com,www.seu-dominio.com
CORS_ALLOWED_ORIGINS=https://seu-dominio.com

# Email (opcional)
EMAIL_HOST=smtp.gmail.com
EMAIL_HOST_USER=seu-email@gmail.com
EMAIL_HOST_PASSWORD=sua-senha-app
EMAIL_PORT=587
EMAIL_USE_TLS=True
```

## 🛠️ Processo de Deploy

### 1. Preparação do Servidor

```bash
# Atualizar sistema
sudo apt update && sudo apt upgrade -y

# Instalar dependências
sudo apt install -y python3.12 python3.12-venv python3-pip postgresql postgresql-contrib nginx git nodejs npm

# Criar usuário para aplicação
sudo useradd -m -s /bin/bash abase
sudo usermod -aG sudo abase
```

### 2. Configuração do Banco de Dados

```bash
# Conectar como postgres
sudo -u postgres psql

-- Criar banco e usuário
CREATE DATABASE abase_production;
CREATE USER abase_user WITH PASSWORD 'senha-super-forte';
GRANT ALL PRIVILEGES ON DATABASE abase_production TO abase_user;
ALTER USER abase_user CREATEDB;
\q
```

### 3. Deploy da Aplicação

```bash
# Mudar para usuário abase
sudo su - abase

# Clonar repositório
git clone https://github.com/seu-usuario/abase.git
cd abase

# Criar ambiente virtual
python3.12 -m venv venv
source venv/bin/activate

# Instalar dependências Python
pip install -r requirements.txt

# Instalar dependências Node.js
npm install

# Compilar CSS
npm run build-css-prod

# Configurar variáveis de ambiente
cp .env.example .env.production
# Editar .env.production com as variáveis corretas
nano .env.production

# Executar migrações
python manage.py migrate --settings=core.settings_production

# Coletar arquivos estáticos
python manage.py collectstatic --noinput --settings=core.settings_production

# Criar superusuário
python manage.py createsuperuser --settings=core.settings_production
```

### 4. Configuração do Gunicorn

```bash
# Criar arquivo de configuração do Gunicorn
nano /home/abase/abase/gunicorn.conf.py
```

```python
# gunicorn.conf.py
import multiprocessing

bind = "127.0.0.1:8000"
workers = multiprocessing.cpu_count() * 2 + 1
worker_class = "gevent"
worker_connections = 1000
max_requests = 1000
max_requests_jitter = 100
timeout = 30
keepalive = 2
preload_app = True
```

### 5. Configuração do Systemd

```bash
# Criar arquivo de serviço
sudo nano /etc/systemd/system/abase.service
```

```ini
[Unit]
Description=ABASE Django Application
After=network.target

[Service]
User=abase
Group=abase
WorkingDirectory=/home/abase/abase
Environment="PATH=/home/abase/abase/venv/bin"
EnvironmentFile=/home/abase/abase/.env.production
ExecStart=/home/abase/abase/venv/bin/gunicorn --config gunicorn.conf.py core.wsgi:application
ExecReload=/bin/kill -s HUP $MAINPID
KillMode=mixed
TimeoutStopSec=5
PrivateTmp=true
Restart=on-failure

[Install]
WantedBy=multi-user.target
```

```bash
# Habilitar e iniciar serviço
sudo systemctl daemon-reload
sudo systemctl enable abase
sudo systemctl start abase
sudo systemctl status abase
```

### 6. Configuração do Nginx

```bash
# Criar configuração do site
sudo nano /etc/nginx/sites-available/abase
```

```nginx
server {
    listen 80;
    server_name seu-dominio.com www.seu-dominio.com;
    
    # Redirecionar HTTP para HTTPS
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name seu-dominio.com www.seu-dominio.com;
    
    # SSL Configuration (configurar certificados)
    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;
    
    # SSL Settings
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers ECDHE-RSA-AES256-GCM-SHA512:DHE-RSA-AES256-GCM-SHA512:ECDHE-RSA-AES256-GCM-SHA384;
    ssl_prefer_server_ciphers off;
    ssl_session_cache shared:SSL:10m;
    
    # Gzip
    gzip on;
    gzip_vary on;
    gzip_min_length 10240;
    gzip_proxied expired no-cache no-store private auth;
    gzip_types text/plain text/css text/xml text/javascript application/javascript application/xml+rss application/json;
    
    # Security Headers
    add_header X-Content-Type-Options nosniff;
    add_header X-Frame-Options DENY;
    add_header X-XSS-Protection "1; mode=block";
    add_header Strict-Transport-Security "max-age=31536000; includeSubDomains" always;
    
    # Static files
    location /static/ {
        alias /home/abase/abase/staticfiles/;
        expires 1y;
        add_header Cache-Control "public, immutable";
    }
    
    # Media files
    location /media/ {
        alias /home/abase/abase/media/;
        expires 1y;
        add_header Cache-Control "public";
    }
    
    # Django application
    location / {
        proxy_set_header Host $http_host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        proxy_pass http://127.0.0.1:8000;
    }
    
    # Error pages
    error_page 500 502 503 504 /50x.html;
    location = /50x.html {
        root /var/www/html;
    }
}
```

```bash
# Habilitar site e remover default
sudo ln -s /etc/nginx/sites-available/abase /etc/nginx/sites-enabled/
sudo rm /etc/nginx/sites-enabled/default

# Testar configuração e reiniciar
sudo nginx -t
sudo systemctl restart nginx
```

### 7. SSL com Let's Encrypt (Certbot)

```bash
# Instalar Certbot
sudo apt install certbot python3-certbot-nginx

# Obter certificado
sudo certbot --nginx -d seu-dominio.com -d www.seu-dominio.com

# Configurar renovação automática
sudo crontab -e
# Adicionar linha:
0 2 * * * /usr/bin/certbot renew --quiet
```

## 🔄 Processo de Atualização

### Script de Update Automatizado

```bash
# Criar script de update
nano /home/abase/update_abase.sh
```

```bash
#!/bin/bash
set -e

echo "=== ATUALIZANDO SISTEMA ABASE ==="

# Navegar para diretório
cd /home/abase/abase

# Fazer backup do banco
echo "Fazendo backup do banco..."
pg_dump -h localhost -U abase_user abase_production > backup_$(date +%Y%m%d_%H%M%S).sql

# Ativar ambiente virtual
source venv/bin/activate

# Atualizar código
echo "Atualizando código..."
git pull origin main

# Instalar dependências
echo "Atualizando dependências..."
pip install -r requirements.txt
npm install

# Compilar CSS
echo "Compilando CSS..."
npm run build-css-prod

# Executar migrações
echo "Executando migrações..."
python manage.py migrate --settings=core.settings_production

# Coletar arquivos estáticos
echo "Coletando arquivos estáticos..."
python manage.py collectstatic --noinput --settings=core.settings_production

# Reiniciar serviços
echo "Reiniciando serviços..."
sudo systemctl restart abase
sudo systemctl reload nginx

echo "=== ATUALIZAÇÃO CONCLUÍDA ==="
```

```bash
# Tornar executável
chmod +x /home/abase/update_abase.sh
```

## 📊 Monitoramento

### 1. Logs do Sistema

```bash
# Logs da aplicação
sudo journalctl -u abase -f

# Logs do Nginx
sudo tail -f /var/log/nginx/access.log
sudo tail -f /var/log/nginx/error.log

# Logs do PostgreSQL
sudo tail -f /var/log/postgresql/postgresql-14-main.log
```

### 2. Configuração de Backup

```bash
# Script de backup diário
nano /home/abase/backup_daily.sh
```

```bash
#!/bin/bash
BACKUP_DIR="/home/abase/backups"
DATE=$(date +%Y%m%d_%H%M%S)

# Criar diretório se não existir
mkdir -p $BACKUP_DIR

# Backup do banco
pg_dump -h localhost -U abase_user abase_production | gzip > $BACKUP_DIR/db_backup_$DATE.sql.gz

# Backup de arquivos de mídia
tar -czf $BACKUP_DIR/media_backup_$DATE.tar.gz /home/abase/abase/media/

# Manter apenas últimos 7 dias
find $BACKUP_DIR -name "*.gz" -mtime +7 -delete

echo "Backup concluído: $DATE"
```

```bash
# Configurar cron para backup diário
crontab -e
# Adicionar:
0 2 * * * /home/abase/backup_daily.sh >> /home/abase/backup.log 2>&1
```

## 🔧 Troubleshooting

### Problemas Comuns

1. **Erro 502 Bad Gateway**
   ```bash
   # Verificar se Gunicorn está rodando
   sudo systemctl status abase
   
   # Verificar logs
   sudo journalctl -u abase -n 50
   ```

2. **CSS não carrega**
   ```bash
   # Recompilar CSS
   cd /home/abase/abase
   npm run build-css-prod
   python manage.py collectstatic --noinput
   ```

3. **Erro de permissões**
   ```bash
   # Corrigir permissões
   sudo chown -R abase:abase /home/abase/abase/
   sudo chmod -R 755 /home/abase/abase/static/
   sudo chmod -R 755 /home/abase/abase/media/
   ```

## 🛡️ Segurança

### Checklist de Segurança

- [ ] Firewall configurado (ufw)
- [ ] SSH com chaves públicas
- [ ] Fail2ban configurado
- [ ] PostgreSQL com senha forte
- [ ] SSL/TLS configurado
- [ ] Headers de segurança no Nginx
- [ ] Backups automatizados
- [ ] Logs sendo monitorados
- [ ] Atualizações automáticas do SO

### Configuração do Firewall

```bash
# Configurar ufw
sudo ufw default deny incoming
sudo ufw default allow outgoing
sudo ufw allow ssh
sudo ufw allow 'Nginx Full'
sudo ufw enable
```

---

**Última atualização:** 11/09/2025  
**Versão:** 1.0  
**Responsável:** Equipe ABASE