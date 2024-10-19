# Microfrontend Project

This project demonstrates a microfrontend architecture using a main app and dynamically loaded plugins.

## Project Structure

- `main-app/`: The core application that loads and manages plugins
- `plugin-a/`: An example plugin
- `config-server/`: A simple server to provide plugin configurations

## Setup and Running

### Main App

1. Navigate to the `main-app` directory:

   ```
   cd main-app
   ```

2. Install dependencies:

   ```
   npm install
   ```

3. Start the development server:
   ```
   npm run dev
   ```

The main app will be available at `http://localhost:3000`.

### Plugin A

1. Navigate to the `plugin-a` directory:

   ```
   cd plugin-a
   ```

2. Install dependencies:

   ```
   npm install
   ```

3. Build the plugin:

   ```
   npm run build
   ```

4. Serve the built plugin:
   ```
   npm run serve
   ```

The plugin will be served at `http://localhost:5000/plugin-a.js`.

### Config Server

1. Navigate to the `config-server` directory:

   ```
   cd config-server
   ```

2. Install dependencies:

   ```
   npm install
   ```

3. Start the server:
   ```
   npm start
   ```

The config server will run on `http://localhost:3001`.

## Adding New Plugins

To add a new plugin:

1. Create a new directory for your plugin (e.g., `plugin-b`)
2. Implement the plugin following the structure of `plugin-a`
3. Update the config server to include the new plugin's configuration
4. Build and serve the new plugin
5. Restart the main app to load the new plugin

## Project Features

- Dynamic loading of plugins
- React-based main app and plugins
- TypeScript support
- Vite for fast development and building

## Notes

- Ensure all servers (main app, plugins, and config server) are running for the full functionality
- The main app fetches plugin configurations from the config server on startup
- Plugins are loaded dynamically based on the configurations
