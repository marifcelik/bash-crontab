#!/bin/bash

source alert.conf

# df ile diskler hakkında bilgi alıyorum, grep ile diski göstermeyen kısımları çıkartıyorum
# awk ile gerekli bölümleri bastıktan sonra while döngüsüyle her bir bölüm için kontrol
# sağlıyorum
run() {
    df -H | grep -vE 'Filesystem|tmpfs|cdrom|snap' | awk '{ print $5 " " $1}' | \
        while read output; do
            rate=$(echo $output | awk '{ print $1 }' | cut -d'%' -f1) #kullanım oranını alıyorum
            if [ $rate -ge $limit ]; then                             # 90 dan fazla ise
                part=$(echo $output | awk '{ print $2  }')            # partition adını alıyorum
                # mesajı yazdırıp mail e aktarıyorum ve maili gönderiyorum
                echo "The partition '$part' on $(hostname) has used %$rate at $(date)" | \
                mail -s "$(hostname) disk usage alert: %$rate used" alert@mail.com
            fi
        done
}

# eğer crontab dosyasında bu script yoksa eklenecek
# scriptin dosya yolunu kontrol ediyorum
if [ -z "$control" ]; then
    echo 'cron oluşturuluyor...'
    (crontab -l 2>/dev/null; echo "$job") | crontab -
else #varsa manuel olarak bir yedekleme yapacak
    run
fi
