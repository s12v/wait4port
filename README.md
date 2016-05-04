# wait4port

Wait for an open port with 60 seconds timeout. Uses `curl` for http/https and `nc` for arbitrary TCP and UDP connections.

## Usage

```
bash <(curl -s https://raw.githubusercontent.com/s12v/wait4port/master/wait4port.sh) [http://]host:port
```

## Return codes

* `0` - success
* `1` - timeout

### Example usecase:

<img width="874" alt="screenshot 2016-05-04 23 10 32" src="https://cloud.githubusercontent.com/assets/1462574/15029362/76b0d3f4-124d-11e6-9939-42578aba9538.png">
