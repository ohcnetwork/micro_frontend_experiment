import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";

export default defineConfig({
  plugins: [react()],
  build: {
    lib: {
      entry: path.resolve(__dirname, "src/index.ts"),
      name: "PluginA",
      formats: ["umd"],
      fileName: () => "plugin-a.js",
    },
    rollupOptions: {
      external: ["react", "react-dom"],
      output: {
        globals: {
          react: "React",
          "react-dom": "ReactDOM",
        },
      },
    },
    outDir: "dist",
  },
  define: {
    "process.env.NODE_ENV": JSON.stringify("development"),
  },
  server: {
    port: 5000,
  },
  preview: {
    port: 5000,
  },
});
