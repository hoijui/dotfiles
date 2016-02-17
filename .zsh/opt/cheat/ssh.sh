```
ssh -R -f -N 80:example.com:9999 username@example.com
```
    -R : リモートフォワードを有効 80:example.com:9999 でexample.com:9876->localhost:80転送
    -f : バックグランドで実行
    -N : コマンド実行をしない(ログインだけしてシェルも立ち上げない)
Host example.com
  RemoteForward 9999 localhost:80
# うまく動作しない場合 sshd_config の GatewayPorts を確認する

## socks proxy
```
ssh -f -N -D 1080 user@example.com
ssh -N -D 1080 user@example.com
```

# 鍵の登録
ssh-keygen -t rsa
ssh-copy-id -i .ssh/id_dsa.pub user@192.168.1.16

# PEMパスフレーズ解除
openssl rsa -in ssl.pem -out ssl-nopass.pem
chmod 600 ssl-nopass.pem

