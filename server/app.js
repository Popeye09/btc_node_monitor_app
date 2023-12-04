const express = require('express');
const app = express();
const bitcoinNode = require('./bitcoin-node-client');

const walletRoutes = require('./api/routes/wallets');

//const controlRoutes = require('./api/routes/wallets');

app.use('/wallets', walletRoutes);

app.use('/uptime', (req, res, next) => {
    bitcoinNode.uptime().then((data) => {
        res.status(200).json({ uptime: JSON.parse(data).result });
    });
});

app.use('/stop', (req, res, next) => {
    bitcoinNode.stop().then((data) => {
        res.status(200).json({ response: JSON.parse(data) });
    });
});

app.use('/height', (req, res, next) => {
    bitcoinNode.getblockcount().then((data) => {
        res.status(200).json({ height: JSON.parse(data).result });
    });
});

app.use('/getblock/:blockHash', (req, res, next) => {
    const blockHash = req.params.blockHash;
    bitcoinNode.getblock(blockHash, 1).then((data) => {

        res.status(200).json(JSON.parse(data));
    });
});

app.use('/gettransactions/:blockHash', (req, res, next) => {
    const blockHash = req.params.blockHash;
    bitcoinNode.getblock(blockHash, 2).then((data) => {
        transactions = JSON.parse(data).result.tx;

        res.status(200).json(JSON.parse(data));
    });
});

app.use('/totaltransferamount/:blockHash', (req, res, next) => {
    const blockHash = req.params.blockHash;
    bitcoinNode.getblock(blockHash, 2).then((data) => {

        transactions = JSON.parse(data).result.tx; //[0].vout[0].value

        let sum = 0;
        let i = 0;
        let j = 0;
        while (true) {
            if (transactions[i] == undefined) {
                break;
            }
            j = 0;
            while (true) {
                if (transactions[i].vout[j] == undefined) {
                    break;
                }
                sum += transactions[i].vout[j].value;

                j++;
            }
            i++;
        }
        res.status(200).json({ sum: sum });
    });
});

module.exports = app;