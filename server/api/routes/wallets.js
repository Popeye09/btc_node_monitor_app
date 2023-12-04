const express = require('express');
const bitcoinNode = require('../../bitcoin-node-client');
const router = express.Router();

router.get('/loadwallet/:walletName', (req, res, next) => {
    let walletName = req.params.walletName;

    bitcoinNode.loadwallet(walletName).then((data) => {

        res.status(200).json(JSON.parse(data));
    });
});

router.get('/', (req, res, next) => {
    let walletName = req.params.walletName;

    bitcoinNode.listwallets().then((data) => {

        res.status(200).json(JSON.parse(data).result);
    });
});

router.get('/:walletName', (req, res, next) => {
    let walletName = req.params.walletName;
    console.log("getwalletinfo");
    if (bitcoinNode.loadedWallet !== walletName) {
        bitcoinNode.loadwallet(walletName).then((data) => {

            bitcoinNode.getwalletinfo(walletName).then((data) => {

                res.status(200).json(JSON.parse(data));
            });
        });
    }
    else {
        bitcoinNode.getwalletinfo(walletName).then((data) => {

            res.status(200).json(JSON.parse(data));
        });
    }
});

module.exports = router;