import express from "express"
import serverless from "serverless-http"

export const app = express()

app.get("/", (req, res) => {
    return res.status(200).json("Hello World")
})

module.exports.handler = serverless(app)

