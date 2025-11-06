import { Component } from '@angular/core';
import { RouterOutlet } from '@angular/router';
import { HeaderComponent } from './components/header/header.component';
import { FooterComponent } from './components/footer/footer.component';
import { TranslationService } from './services/translation.service';

@Component({
  selector: 'app-root',
  standalone: true,
  imports: [RouterOutlet, HeaderComponent, FooterComponent],
  templateUrl: './app.component.html',
  styleUrl: './app.component.scss'
})
export class AppComponent {
  title = 'service-business';

  constructor(private translate: TranslationService) {
    // Set default language
    this.translate.setDefaultLang('en');
    
    // Use the browser's language if available, otherwise default to 'en'
    const browserLang = this.translate.getBrowserLang();
    const supportedLangs = ['en', 'fr', 'es'];
    const langToUse = browserLang && supportedLangs.includes(browserLang) ? browserLang : 'en';
    this.translate.use(langToUse);
  }
}
