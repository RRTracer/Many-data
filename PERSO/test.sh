password="root"
crypt_passwd=$( openssl passwd -1 "$password")
sudo useradd -p $crypt_passwd -m test
