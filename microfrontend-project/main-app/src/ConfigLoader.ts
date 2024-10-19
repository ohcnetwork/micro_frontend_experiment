import { PluginConfig } from "./types";

export async function loadConfig(): Promise<PluginConfig[]> {
  const response = await fetch("http://localhost:3001/config");
  if (!response.ok) {
    throw new Error("Failed to load config");
  }
  return response.json();
}
