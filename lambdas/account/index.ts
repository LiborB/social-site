import express, {Router} from "express"
import serverlessExpress from "@vendia/serverless-express"

export const app = express()
const router = Router()

router.get("/account", (req, res) => {
    return res.status(200).json("Hello World")
})

router.get("/", (req, res) => {
    return res.status(200).json("wtf is this")
})

router.get("/v1/account", (req, res) => {
    return res.status(200).json("v1 account")
})

app.use("/v1", router)

export const handler = serverlessExpress({
    app: app
})

