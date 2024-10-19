import React from "react";
import PluginAPage from "./PluginAPage";

const PluginA = {
  name: "PluginA",
  component: () => React.createElement("div", null, "Plugin A Component"),
  PluginAPage: PluginAPage,
};

(window as any).PluginA = PluginA;

export default PluginA;
