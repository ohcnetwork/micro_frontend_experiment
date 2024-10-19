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
      console.error(`Plugin ${pluginName} not found`);
    }
  }, [pluginName]);

  if (!PluginComponent) {
    return <div>Loading plugin...</div>;
  }

  return <PluginComponent name={pluginName} />;
};
