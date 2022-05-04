import express, {Router} from "express"
import serverlessExpress from "@vendia/serverless-express"

export const app = express()
const router = Router()

router.get("/account", (req, res) => {
    return res.status(200).json("Hello World")
})

app.use("/v1", router)

export const handler = serverlessExpress({
    app: app
})

