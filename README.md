## Yedekleme

Bu script sistemdeki kullanıcıların home dizinini her gün 23:05' te /mnt dizininin altına yedekler. 
> Script şu anlık sadece /home dizininin altındaki klasörleri kopyalıyor. İlerde bunu düzeteceğim.

Yedek adları 'username_date' şeklindedir. Her yedekleme için md5 doğrulama dosyası oluşturulur ve /tmp altında scriptin çalışma logları tutulur.
> Scriptin aktif olması için sadece çalıştırmak yeterli, kendisi crontab yardımıyla cronbjob' ı oluşturuyor.

Belirlenen saat dışında tekrar çalıştırılırsa manuel olarak yedek alınabilir.

## Alarm

Bu script mevcut disklerin ve partitionların kullanımını her dakika kontrol eder. Kullanımı %90' ın üzerinde olan kısmı mail ile bildirir. 
> Scriptin aktif olması için sadece çalıştırmak yeterli, kendisi crontab yardımıyla cronbjob' ı oluşturuyor.