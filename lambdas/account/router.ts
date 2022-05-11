import {Router} from "express";
import {AuthRequest, LoginRequest} from "./types";
import jwt from "jsonwebtoken";
import {expressjwt} from "express-jwt";

const authMiddleware = () => expressjwt({
    secret: process.env.ACCESS_TOKEN_SECRET!,
    algorithms: ["HS256"]
})

export const router = Router();

router.get("/", authMiddleware(), (req, res) => {
    return res.status(200).json("Hello World")
})

router.post("/login", (req, res) => {
    const body = LoginRequest.safeParse(req.body)

    if (!body.success) {
        return res.status(400).json(body.error)
    }

    const token = jwt.sign(body.data, process.env.ACCESS_TOKEN_SECRET!, {
        expiresIn: "1h",
    })
    const refreshToken = jwt.sign(body.data, process.env.REFRESH_TOKEN_SECRET!, {expiresIn: "3000d"})

    return res.status(200).json({
        token,
        refreshToken,
    })
})

router.post("/auth", (req, res) => {
    const body = AuthRequest.safeParse(req.body)

    if (!body.success) {
        return res.status(400).json(body.error)
    }

    const newToken = jwt.sign(body.data, process.env.ACCESS_TOKEN_SECRET!, {
        expiresIn: "1h",
    })

    return res.status(200).json({
        token: newToken,
        refreshToken: body.data.refreshToken
    })
})
