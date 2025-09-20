import { defineConfig } from "vite";
import vue from "@vitejs/plugin-vue";
import { alphaTab } from "@coderline/alphatab/vite";

// https://vite.dev/config/
export default defineConfig({
    plugins: [
        vue(),
        alphaTab({
            alphaTabSourceDir: "node_modules/@coderline/alphatab/dist",
        }),
    ],
});
