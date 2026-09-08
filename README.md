# Groser Railway Reverb Socket

This is a standalone Laravel Reverb service for the Groser admin + website.
It speaks the Pusher protocol expected by the existing `pusher-js` client.

## 1. Generate credentials

Run locally:

```bash
php scripts/generate-credentials.php
```

Copy all four values somewhere safe.

## 2. Deploy to Railway

1. Put this folder in a GitHub repository, or deploy it with the Railway CLI.
2. Railway -> New Project -> Deploy from GitHub repo.
3. Add the generated `APP_KEY`, `REVERB_APP_ID`, `REVERB_APP_KEY`, and `REVERB_APP_SECRET` under Variables.
4. Add:

```env
APP_ENV=production
APP_DEBUG=false
LOG_CHANNEL=stderr
REVERB_PORT=443
REVERB_SCHEME=https
REVERB_SERVER_HOST=0.0.0.0
REVERB_ALLOWED_ORIGINS=https://groser.co,https://www.groser.co,https://admin.groser.co
```

5. Deploy.
6. Railway -> Service -> Settings -> Networking -> Generate Domain.
7. Copy only the hostname, e.g. `groser-socket-production.up.railway.app`.
8. Add/update `REVERB_HOST` in Railway to that hostname and redeploy once.

The Docker command automatically binds Reverb to Railway's injected `$PORT`.

## 3. Configure the Hostinger Laravel admin

The Hostinger admin is the broadcaster and private-channel auth server. Set:

```env
BROADCAST_DRIVER=reverb
REVERB_APP_ID=THE_SAME_ID_AS_RAILWAY
REVERB_APP_KEY=THE_SAME_KEY_AS_RAILWAY
REVERB_APP_SECRET=THE_SAME_SECRET_AS_RAILWAY
REVERB_HOST=groser-socket-production.up.railway.app
REVERB_PORT=443
REVERB_SCHEME=https
```

Do NOT include `https://` in `REVERB_HOST`.

Then run on Hostinger with PHP 8.3:

```bash
/opt/alt/php83/usr/bin/php artisan optimize:clear
```

If you configure broadcasting from the admin UI instead, choose `Reverb` and enter the same app ID/key/secret/host, port `443`, scheme `https`.

## 4. Website configuration

The current Groser website reads `broadcast_driver` and `broadcast_config` from the admin settings API. It does not need a separate Socket.IO server.

Expected browser WebSocket URL:

```text
wss://groser-socket-production.up.railway.app:443/app/REVERB_APP_KEY
```

Private chat authorization still goes to the Laravel admin customer endpoint:

```text
https://admin.groser.co/customer/broadcasting/auth
```

(or the API host configured by `NEXT_PUBLIC_API_URL` + `NEXT_PUBLIC_API_SUBURL`).

## 5. Verify

Open the Groser website -> F12 -> Console. You should see logs similar to:

```text
[chatWs] connecting -> <railway-host>:443 driver: reverb
[chatWs] connection: connecting -> connected
[chatWs] connected ✓ socket_id: ...
```

If connection fails, verify:

- Railway public domain exists.
- Reverb service is listening on Railway `$PORT`.
- Railway and Hostinger use exactly the same Reverb app ID/key/secret.
- Hostinger has `BROADCAST_DRIVER=reverb`.
- `REVERB_HOST` contains only the Railway hostname, no protocol or slash.
- `REVERB_PORT=443` and `REVERB_SCHEME=https`.
- The browser origin is present in `REVERB_ALLOWED_ORIGINS`.

## Optional Redis scaling

For one Railway Reverb replica, leave `REVERB_SCALING_ENABLED=false`.
Only add Railway Redis and enable scaling if you later run multiple Reverb replicas.
