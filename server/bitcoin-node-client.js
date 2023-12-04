const http = require('http');
class BitcoinNode {
    constructor({ username, password, host, port }) {
        this.username = username;
        this.password = password;
        this.host = host;
        this.port = port;
        this.rpc_endpoint_uri = `http://${this.username}:${this.password}@${this.host}:${this.port}`;
        this.loadedWallet = "";
        this.options = {
            method: 'POST',
            headers: {
                'Content-Type': 'text/plain',
            },
        };
    }

    uptime() {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "uptime"}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });

    }

    stop() {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "stop"}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });

    }
    getblockcount() {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "getblockcount"}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });
    }

    getblock(blockHash, verbosity) {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "getblock", "params": ["' + blockHash + '", ' + verbosity + ']}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });
    }

    listwallets() {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "listwallets"}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });
    }


    loadwallet(walletName) {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "loadwallet", "params": ["' + walletName + '"]}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();

            this.loadedWallet = walletName;
        });
    }

    getwalletinfo(walletName) {
        return new Promise((resolve, reject) => {
            const postData = '{"method": "getwalletinfo"}';

            const req = http.request(this.rpc_endpoint_uri, this.options, (res) => {
                let data = '';
                res.on('data', (chunk) => {
                    data += chunk;
                });
                res.on('end', () => {
                    resolve(data);
                });
            });

            req.on('error', (e) => {
                console.error(`problem with request: ${e.message}`);
            });

            req.write(postData);
            req.end();
        });
    }
}


const bitcoinNode = new BitcoinNode({ username: 'bitcoincore', password: 'bitcoincore-onlab', host: '192.168.1.191', port: '8332' });

module.exports = bitcoinNode;