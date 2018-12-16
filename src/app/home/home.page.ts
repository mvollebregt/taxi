import {Component} from '@angular/core';
import {AlertController} from '@ionic/angular';
import {Plugins} from '@capacitor/core';
import 'native/capacitor-geofence-tracker/src';

const {Geolocation, GeofenceTracker} = Plugins;

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {

  log: string[] = ['Druk op refresh op te refreshen'];

  constructor(
    private alertController: AlertController) {
  }

  async onRefreshClicked() {
    const presences = await GeofenceTracker.getTrackedPresences();
    this.log = [
      'Gevonden: ',
      ...presences.presences.map(presence => `${presence.id} ${presence.start} - ${presence.end}]n`)
    ];
  }

  async onVoegHuidigeLocatieToeClicked() {
    const coordinates = await Geolocation.getCurrentPosition();
    console.log(coordinates);
    await GeofenceTracker.registerLocation({id: 'locatie', ...coordinates.coords, radius: 500});
    const alert = await this.alertController.create({
      header: 'Toegevoegd',
      message: `Locatie is toegevoegd`
    });
    alert.present();
  }
}
