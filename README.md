# Xray VLESS WebSocket TLS Otomatik Kurulum Scripti

Bu script, Ubuntu/Debian tabanlı bir VPS üzerine **Xray (V2Ray fork)** ile şu özelliklerde otomatik kurulum yapar:

- **VLESS protokolü**  
- **WebSocket (WS) taşıma katmanı**  
- **TLS (Let's Encrypt ile otomatik SSL sertifikası)**  
- **Cloudflare veya benzeri CDN ile uyumlu yapı**  
- **SOCKS5 proxy inbound'u (127.0.0.1 üzerinde, kimlik doğrulamasız)**  
  - Bu proxy, özellikle Discord botları gibi uygulamaların trafiğini Xray tüneli üzerinden geçirmesi için kullanılır.  

---

## Özellikler

- Kolay ve hızlı kurulum  
- Güncel Xray çekirdeği kullanımı  
- Otomatik SSL sertifikası alımı ve yenileme  
- Discord ve benzeri servislerde DPI engellerini aşmak için ideal  
- Bot veya uygulamalar için lokal SOCKS5 proxy sunar  

---

## Gereksinimler

- Ubuntu 20.04 / Debian 10 veya üzeri (GLIBC 2.31 uyumlu)  
- Kendi domain adınız (ör. `ornekdomain.com`)  
- Alan adının DNS ayarlarında VPS IP'sine işaret eden bir **A kaydı**  
- Alan adınızın Cloudflare gibi bir CDN servisi üzerinde **proxy (turuncu bulut) açık** olması önerilir  

---

## Kurulum

1. Script dosyasını indirin veya oluşturun (örneğin `install_xray.sh`)  
2. Script içindeki `domain` değişkenini kendi domaininize göre düzenleyin  
3. Aşağıdaki komutları çalıştırın:

```bash
chmod +x install_xray.sh
./install_xray.sh
