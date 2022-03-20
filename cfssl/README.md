# self signed CA + client certificate with cfssl

- <https://github.com/cloudflare/cfssl>
- <https://developers.cloudflare.com/cloudflare-one/identity/devices/mutual-tls-authentication/>
- <https://github.com/coreos/docs/blob/master/os/generate-self-signed-certificates.md>

## sample output

```bash
./certs.sh
+ CA=ca
+ CA_CSR=<PATH>/cfssl/ca-csr.json
+ CA_CONFIG=<PATH>/cfssl/ca-config.json
+ CLIENT=client
+ CLIENT_CONFIG=<PATH>/cfssl/client.json
+ mkdir cfssl-certs
+ pushd cfssl-certs
<PATH>/cfssl/cfssl-certs <PATH>/cfssl
+ cfssl gencert -initca <PATH>/cfssl/ca-csr.json
+ cfssljson -bare ca
2022/03/20 02:35:36 [INFO] generating a new CA key and certificate from CSR
2022/03/20 02:35:36 [INFO] generate received request
2022/03/20 02:35:36 [INFO] received CSR
2022/03/20 02:35:36 [INFO] generating key: rsa-4096
2022/03/20 02:35:36 [INFO] encoded CSR
2022/03/20 02:35:36 [INFO] signed certificate with serial number 4xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
+ cp ca.pem ca.cert
+ cfssl gencert -ca=ca.pem -ca-key=ca-key.pem -config=<PATH>/cfssl/ca-config.json -profile=client <PATH>/cfssl/client.json
+ cfssljson -bare client
2022/03/20 02:35:36 [INFO] generate received request
2022/03/20 02:35:36 [INFO] received CSR
2022/03/20 02:35:36 [INFO] generating key: rsa-4096
2022/03/20 02:35:38 [INFO] encoded CSR
2022/03/20 02:35:38 [INFO] signed certificate with serial number 3xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
+ openssl pkcs12 -export -inkey client-key.pem -in client.pem -password pass: -out client.p12
```

## check

```bash
openssl x509 -in cfssl-certs/ca.pem -text -noout
openssl x509 -in cfssl-certs/client.pem -text -noout

# or
cfssl certinfo -cert cfssl-certs/ca.pem
cfssl certinfo -cert cfssl-certs/client.pem
```
