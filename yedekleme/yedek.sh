#!/bin/bash

#kullanacağım değişkenleri dahil ediyorum
source ./yedek.conf

#crontab ta tanımlama yapılmamışsa çalıştırılacak fonksyon
cronOlustur() {
    # 2>/dev/null kullanmamın sebebi hata mesajı oluşursa konsolda
    # göstermemek, daha sonrasında yazılacak işi crontab a aktarıyorum
    (crontab -l 2>/dev/null; echo "$job") | crontab -
    read -r -p 'oluşturuldu. hemen yedekleme yapılsın mı ? [y, n] : ' answer
    case $answer in
      [Yy]* ) run;;
      [Nn]* ) exit 0;;
      * ) echo 'geçersiz argüman';;
     esac
}

#yedekleme yapacak fonksyon
run() {
    #her bir userı alacak şekilde döngü oluşturuyorum
    for user in ${users[@]}; do
        cd $backupPath
        tar -czf ./${user}_$backupName /home/${user} 2>/dev/null
        md5sum ${user}_$backupName > ${user}_$backupName.md5.txt
        echo $time >> /tmp/${user}_son_calisma.log
        echo "$user için yedekleme yapıldı"
    done
    echo 'bitti.'
}

#ilk argümanı kontrol ediyorum, m ise yedeklemeyi başlatıyorum
if [ -n "$1" ] && [[ $1 == '-m' ]]; then
    echo 'yedekleme başladı'
    run
    exit 0 # program sorunsuz çalıştı
elif [ -n "$1" ]; then
    echo 'geçersiz argüman'
    exit 1; #programın hatalı çıktığını belirtiyorum
fi

echo "crontab kontrolü yapılıyor..."

# eğer crontab dosyasında bu script yoksa eklenecek
# scriptin dosya yolunu kontrol ediyorum
if [ -z "$control" ]; then
    echo 'cron oluşturuluyor...'
    cronOlustur  
else #varsa manuel olarak bir yedekleme yapacak
    echo "cron job zaten yüklü, manuel yedekleme için lütfen '-m' kullanın"
fi
