import {z} from "zod";

export const LoginRequest = z.object({
    username: z.string(),
    password: z.string(),
})

export type LoginRequest = z.infer<typeof LoginRequest>

export const AuthRequest = z.object({
    refreshToken: z.string(),
})

export type AuthRequest = z.infer<typeof AuthRequest>
