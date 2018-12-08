import {Injectable} from '@angular/core';
import {Geofence} from '@ionic-native/geofence/ngx';
import {Storage} from '@ionic/storage';
import * as moment from 'moment';

@Injectable({
  providedIn: 'root'
})
export class GeofenceService {

  // TODO: http://invisibleloop.com/troubleshooting-ionic-native-geofence-plugin-build-issues/

  constructor(private geofence: Geofence, private storage: Storage) {
    this.geofence.initialize().then(
      // resolved promise does not return a value
      () => console.log('Geofence Plugin Ready'),
      (err) => console.log(err)
    );
  }

  async addLocation(location: { id: string, latitude: number, longitude: number }) {
    await this.geofence.addOrUpdate({
      ...location, radius: 100, transitionType: 3
    });
    this.geofence.onTransitionReceived().subscribe((geofences: any[]) =>
      geofences.forEach(geofence => this.transitionReceived(geofence)));
  }

  private async transitionReceived(geofence: {transitionType: number}) {
    const log = await this.storage.get('log');
    const time = moment().format('dd DD MMM HH:mm');
    const status = geofence.transitionType === 1 ? 'Entered' : 'Exited';
    this.storage.set('log', `${log}\n${time} ${status}`);
  }
}
