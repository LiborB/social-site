import express from "express"
import serverlessExpress from "@vendia/serverless-express"

export const app = express()

app.get("/account", (req, res) => {
    return res.status(200).json("Hello World")
})

app.get("/", (req, res) => {
    return res.status(200).json("wtf is this")
})

export const handler = serverlessExpress({
    app: app
})

