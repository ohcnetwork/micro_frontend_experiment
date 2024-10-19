import React, { useEffect, useState } from "react";
import { BrowserRouter as Router, Route, Link, Routes } from "react-router-dom";
import Home from "./Home";
import About from "./About";
import { PluginLoader } from "./PluginLoader";
import { pluginRegistry } from "./PluginRegistry";
import { loadConfig } from "./ConfigLoader";
import { Plugin } from "./types";

const App: React.FC = () => {
  const [plugins, setPlugins] = useState<Plugin[]>([]);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    const initPlugins = async () => {
      try {
        const configs = await loadConfig();
        await pluginRegistry.loadPlugins(configs);
        setPlugins(pluginRegistry.getAll());
      } catch (err) {
        console.error("Failed to initialize plugins:", err);
        setError(
          "Failed to load plugins. Please check the console for more details."
        );
      }
    };

    initPlugins();
  }, []);

  if (error) {
    return <div>Error: {error}</div>;
  }

  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li>
              <Link to="/">Home</Link>
            </li>
            <li>
              <Link to="/about">About</Link>
            </li>
            {plugins.map((plugin) =>
              plugin.routes?.map((route) => (
                <li key={route.path}>
                  <Link to={route.path}>{plugin.name}</Link>
                </li>
              ))
            )}
          </ul>
        </nav>

        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          {plugins.map((plugin) =>
            plugin.routes?.map((route) => (
              <Route
                key={route.path}
                path={route.path}
                element={<route.component />}
              />
            ))
          )}
        </Routes>
      </div>
    </Router>
  );
};

export default App;
