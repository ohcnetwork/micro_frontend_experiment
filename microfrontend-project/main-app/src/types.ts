import React from "react";

export interface PluginProps {
  name: string;
}

export interface Plugin {
  name: string;
  component: React.ComponentType<PluginProps>;
  routes: Array<{
    path: string;
    component: React.ComponentType<any>;
  }>;
}

export interface PluginConfig {
  name: string;
  url: string;
  entry: string;
  routes: Array<{
    path: string;
    component: string;
  }>;
}
