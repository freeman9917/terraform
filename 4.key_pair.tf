resource "aws_key_pair" "my_key"{
    key_name = "my-key"
    public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
    algorithm = "RSA"
    rsa_bits = 4096
}

resource "local_file" "my-priv-key" {
    content = tls_private_key.rsa.private_key_pem
    filename = "my-priv-key"

}