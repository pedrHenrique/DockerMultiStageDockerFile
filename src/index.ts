import express from 'express';
// const express = require('express);
const app = express();
const port = process.env.PORT

app.get('/', (req, res) => res.send("Hello from Express\n"))

app.listen(process.env.PORT, () => {
    console.log(`Listening on port: ${port}`)
})