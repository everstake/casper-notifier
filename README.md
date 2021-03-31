# Casper Notification Bot
This script monitors the status of the Casper node node and notifies the Telegram Bot if the node stops syncing or goes down.

### Prerequisites

* curl
* jq
```
sudo apt-get install curl jq
```
### Installing

```sh
git clone https://github.com/everstake/casper-notifier.git
cd casper-notifier
chmod +x notifier.sh
```
### Configuration

Edit configuration file `config.ini`.

## Running
Run a command
```sh
./notifier.sh
```

