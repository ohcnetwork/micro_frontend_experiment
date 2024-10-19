import React from "react";
import ReactDOM from "react-dom";
import PluginAPage from "./PluginAPage";

const PluginA = {
  name: "PluginA",
  component: () => React.createElement("div", null, "Plugin A Component"),
  PluginAPage: PluginAPage,
};

(window as any).PluginA = PluginA;
(window as any).React = React;
(window as any).ReactDOM = ReactDOM;

export default PluginA;
