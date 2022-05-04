import express from "express"
import serverlessExpress from "@vendia/serverless-express"

export const app = express()

app.get("/account", (req, res) => {
    return res.status(200).json("Hello World")
})

export const handler = serverlessExpress({
    app: app
})

