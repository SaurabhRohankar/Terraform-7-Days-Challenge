#!/bin/bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
sudo systemctl enable httpd
cat <<EOF > /var/www/html/index.html
<h1>Hello from $(hostname -f)</h1>
<p>This is ${greeter_name}</p>
EOF

