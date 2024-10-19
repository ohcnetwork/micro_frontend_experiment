#!/bin/bash

# Create project structure
mkdir -p microfrontend-project/{main-app/src,plugin-a/src,config-server}
cd microfrontend-project

# Create main-app files
cat << EOF > main-app/src/types.ts
import React from 'react';

export interface PluginProps {
  name: string;
}

export interface Plugin {
  name: string;
  component: React.ComponentType<PluginProps>;
  routes?: Array<{
    path: string;
    component: React.ComponentType<any>;
  }>;
}

export interface PluginConfig {
  name: string;
  url: string;
}
EOF

cat << EOF > main-app/src/ConfigLoader.ts
export async function loadConfig(): Promise<PluginConfig[]> {
  const response = await fetch('http://localhost:3001/config');
  if (!response.ok) {
    throw new Error('Failed to load config');
  }
  return response.json();
}
EOF

cat << EOF > main-app/src/PluginRegistry.ts
import { Plugin, PluginConfig } from './types';

class PluginRegistry {
  private plugins: Map<string, Plugin> = new Map();

  async loadPlugins(configs: PluginConfig[]) {
    for (const config of configs) {
      try {
        const module = await import(/* @vite-ignore */ config.url);
        const plugin: Plugin = module.default;
        this.register(plugin);
      } catch (error) {
        console.error(\`Failed to load plugin \${config.name}:\`, error);
      }
    }
  }

  register(plugin: Plugin) {
    this.plugins.set(plugin.name, plugin);
  }

  get(name: string): Plugin | undefined {
    return this.plugins.get(name);
  }

  getAll(): Plugin[] {
    return Array.from(this.plugins.values());
  }
}

export const pluginRegistry = new PluginRegistry();
EOF

cat << EOF > main-app/src/PluginLoader.tsx
import React, { useState, useEffect } from 'react';
import { Plugin, PluginProps } from './types';
import { pluginRegistry } from './PluginRegistry';

interface PluginLoaderProps {
  pluginName: string;
}

export const PluginLoader: React.FC<PluginLoaderProps> = ({ pluginName }) => {
  const [PluginComponent, setPluginComponent] = useState<React.ComponentType<PluginProps> | null>(null);

  useEffect(() => {
    const plugin = pluginRegistry.get(pluginName);
    if (plugin) {
      setPluginComponent(() => plugin.component);
    } else {
      console.error(\`Plugin \${pluginName} not found\`);
    }
  }, [pluginName]);

  if (!PluginComponent) {
    return <div>Loading plugin...</div>;
  }

  return <PluginComponent name={pluginName} />;
};
EOF

cat << EOF > main-app/src/Home.tsx
import React from 'react';

const Home: React.FC = () => (
  <div>
    <h1>Home Page</h1>
    <p>Welcome to the main application.</p>
  </div>
);

export default Home;
EOF

cat << EOF > main-app/src/About.tsx
import React from 'react';

const About: React.FC = () => (
  <div>
    <h1>About Page</h1>
    <p>This is the about page of the main application.</p>
  </div>
);

export default About;
EOF

cat << EOF > main-app/src/App.tsx
import React, { useEffect, useState } from 'react';
import { BrowserRouter as Router, Route, Link, Routes } from 'react-router-dom';
import Home from './Home';
import About from './About';
import { PluginLoader } from './PluginLoader';
import { pluginRegistry } from './PluginRegistry';
import { loadConfig } from './ConfigLoader';
import { Plugin } from './types';

const App: React.FC = () => {
  const [plugins, setPlugins] = useState<Plugin[]>([]);

  useEffect(() => {
    const initPlugins = async () => {
      const configs = await loadConfig();
      await pluginRegistry.loadPlugins(configs);
      setPlugins(pluginRegistry.getAll());
    };

    initPlugins();
  }, []);

  return (
    <Router>
      <div>
        <nav>
          <ul>
            <li><Link to="/">Home</Link></li>
            <li><Link to="/about">About</Link></li>
            {plugins.map(plugin => (
              plugin.routes?.map(route => (
                <li key={route.path}>
                  <Link to={route.path}>{plugin.name}</Link>
                </li>
              ))
            ))}
          </ul>
        </nav>

        <Routes>
          <Route path="/" element={<Home />} />
          <Route path="/about" element={<About />} />
          {plugins.map(plugin => (
            plugin.routes?.map(route => (
              <Route
                key={route.path}
                path={route.path}
                element={<route.component />}
              />
            ))
          ))}
        </Routes>
      </div>
    </Router>
  );
};

export default App;
EOF

cat << EOF > main-app/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
  },
});
EOF

cat << EOF > main-app/package.json
{
  "name": "main-app",
  "version": "1.0.0",
  "main": "src/App.tsx",
  "scripts": {
    "start": "vite",
    "build": "tsc && vite build",
    "serve": "vite preview"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0",
    "react-router-dom": "^6.10.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "@vitejs/plugin-react": "^3.1.0",
    "typescript": "^4.9.3",
    "vite": "^4.2.0"
  }
}
EOF

# Create plugin-a files
cat << EOF > plugin-a/src/PluginAPage.tsx
import React from 'react';

const PluginAPage: React.FC = () => (
  <div>
    <h1>Plugin A Page</h1>
    <p>This is a page added by Plugin A.</p>
  </div>
);

export default PluginAPage;
EOF

cat << EOF > plugin-a/src/index.ts
import React from 'react';
import PluginAPage from './PluginAPage';

const PluginA = {
  name: 'Plugin A',
  component: () => React.createElement('div', null, 'Plugin A Component'),
  routes: [
    {
      path: '/plugin-a',
      component: PluginAPage,
    },
  ],
};

export default PluginA;
EOF

cat << EOF > plugin-a/vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  build: {
    lib: {
      entry: 'src/index.ts',
      name: 'PluginA',
      fileName: 'plugin-a',
    },
    rollupOptions: {
      external: ['react', 'react-dom'],
    },
  },
});
EOF

cat << EOF > plugin-a/package.json
{
  "name": "plugin-a",
  "version": "1.0.0",
  "main": "src/index.ts",
  "scripts": {
    "build": "tsc && vite build",
    "serve": "vite preview --port 5000"
  },
  "dependencies": {
    "react": "^18.2.0",
    "react-dom": "^18.2.0"
  },
  "devDependencies": {
    "@types/react": "^18.0.28",
    "@types/react-dom": "^18.0.11",
    "@vitejs/plugin-react": "^3.1.0",
    "typescript": "^4.9.3",
    "vite": "^4.2.0"
  }
}
EOF

# Create config-server files
cat << EOF > config-server/server.js
const express = require('express');
const cors = require('cors');
const app = express();

app.use(cors());

app.get('/config', (req, res) => {
  res.json([
    {
      name: 'Plugin A',
      url: 'http://localhost:5000/plugin-a.js',
    },
  ]);
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(\`Config server running on port \${PORT}\`);
});
EOF

cat << EOF > config-server/package.json
{
  "name": "config-server",
  "version": "1.0.0",
  "main": "server.js",
  "scripts": {
    "start": "node server.js"
  },
  "dependencies": {
    "express": "^4.17.1",
    "cors": "^2.8.5"
  }
}
EOF

# Install dependencies
cd main-app && npm install && cd ..
cd plugin-a && npm install && cd ..
cd config-server && npm install && cd ..

echo "Microfrontend project setup complete!"
echo "To start the services:"
echo "1. In main-app directory: npm run start"
echo "2. In plugin-a directory: npm run build && npm run serve"
echo "3. In config-server directory: npm start"

cd ..
