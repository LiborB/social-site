"use strict";
var __importDefault = (this && this.__importDefault) || function (mod) {
    return (mod && mod.__esModule) ? mod : { "default": mod };
};
Object.defineProperty(exports, "__esModule", { value: true });
exports.handler = exports.app = void 0;
const express_1 = __importDefault(require("express"));
const serverless_express_1 = __importDefault(require("@vendia/serverless-express"));
exports.app = (0, express_1.default)();
exports.app.get("/account", (req, res) => {
    return res.status(200).json("Hello World");
});
exports.handler = (0, serverless_express_1.default)({
    app: exports.app
});
