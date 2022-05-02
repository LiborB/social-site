import express from "express"
import serverless from "serverless-http"

export const app = express()

app.get("/account", (req, res) => {
    return res.status(200).json("Hello World")
})

export const handler = serverless(app) 

