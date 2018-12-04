import {Component} from '@angular/core';
import {AlertController} from '@ionic/angular';
import {Plugins} from '@capacitor/core';

const { Geolocation } = Plugins;

@Component({
  selector: 'app-home',
  templateUrl: 'home.page.html',
  styleUrls: ['home.page.scss'],
})
export class HomePage {

  constructor(private alertController: AlertController) {
  }

  async onVoegHuidigeLocatieToeClicked() {
    console.log('click');
    const coordinates = await Geolocation.getCurrentPosition();
    console.log(coordinates);
    const alert = await this.alertController.create({
      header: 'Coordinaten',
      message: `${coordinates.coords.latitude} / ${coordinates.coords.longitude}`
    });
    console.log('alert?');
    alert.present();
  }
}
