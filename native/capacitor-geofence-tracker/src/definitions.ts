declare global {
  interface PluginRegistry {
    GeofenceTracker?: GeofenceTrackerPlugin;
  }
}

export interface GeofenceTrackerPlugin {

  registerLocation(location: GeofenceLocation): Promise<void>;

  getTrackedPresences(): Promise<{ presences: GeofencePresence[] }>;
}

export interface GeofenceLocation {
  id: string,    // A unique identifier of geofence
  latitude: number, // Geo latitude of geofence
  longitude: number, // Geo longitude of geofence
  radius: number, // Radius of geofence in meters
}

export interface GeofencePresence {
  id: string;
  start: string;
  end: string;
}
