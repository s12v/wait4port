# wait4port

Wait unit given port is available.

Example usage:

```
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root mysql:5.7
docker run -d -p 9200:9200 elasticsearch:2.3
bash <(curl -s https://raw.githubusercontent.com/s12v/wait4port/master/wait4port.sh) localhost:3306 localhost:9200
```
output:

<img width="730" alt="screenshot 2016-04-29 23 26 04 copy" src="https://cloud.githubusercontent.com/assets/1462574/14930194/53be7368-0e62-11e6-905f-c579efd0b3ff.png">
