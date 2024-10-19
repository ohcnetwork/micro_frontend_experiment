const express = require("express");
const cors = require("cors");

const app = express();

app.use(cors());

const pluginConfigs = [
  {
    name: "PluginA",
    entry: "/plugin-a.js",
    routes: [
      {
        path: "/plugin-a",
        component: "PluginAPage",
      },
    ],
  },
  // Add more plugin configs here as needed
];

app.get("/config", (req, res) => {
  const configs = pluginConfigs.map((config) => ({
    ...config,
    url: `http://localhost:5000${config.entry}`,
  }));

  res.json(configs);
});

const PORT = 3001;
app.listen(PORT, () => {
  console.log(`Config server running on port ${PORT}`);
});
