import "dotenv/config";
import express, {Router} from "express"
import serverlessExpress from "@vendia/serverless-express"
import {AuthRequest, LoginRequest} from "./types";
import {expressjwt} from "express-jwt";
import cors from "cors"
import {router} from "./router";

export const app = express()
app.use(cors())
app.use(express.json())

app.use("/v1/account", router)

export const handler = serverlessExpress({
    app: app
})

