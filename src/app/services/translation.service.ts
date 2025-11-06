import { Injectable } from '@angular/core';
import { BehaviorSubject } from 'rxjs';

export interface Translations {
  [key: string]: any;
}

@Injectable({
  providedIn: 'root'
})
export class TranslationService {
  private currentLang = 'en';
  private translations: { [lang: string]: Translations } = {};
  private langChangeSubject = new BehaviorSubject<string>(this.currentLang);
  
  public onLangChange = this.langChangeSubject.asObservable();

  constructor() {
    this.loadTranslations();
  }

  private loadTranslations() {
    // English translations
    this.translations['en'] = {
      HEADER: {
        TITLE: "Service Business",
        HOME: "Home",
        SERVICES: "Services",
        CONTACT: "Contact"
      },
      HOME: {
        TITLE: "Welcome to Service Business",
        SUBTITLE: "We offer top-notch services tailored to your needs.",
        SERVICE_HIGHLIGHTS: "Our Service Highlights",
        CONSULTING: "Consulting",
        CONSULTING_DESC: "Expert advice to help your business grow and succeed.",
        MAINTENANCE: "Maintenance",
        MAINTENANCE_DESC: "Keep your systems running smoothly with our maintenance services.",
        SUPPORT: "Support",
        SUPPORT_DESC: "24/7 support to ensure your business never stops."
      },
      SERVICES: {
        TITLE: "Our Services",
        CONSULTING: "Consulting",
        CONSULTING_DESC: "Our experienced consultants provide strategic guidance to help your business achieve its goals. We analyze your current operations and identify opportunities for improvement and growth.",
        MAINTENANCE: "Maintenance",
        MAINTENANCE_DESC: "We offer comprehensive maintenance services to keep your systems running at peak performance. Regular maintenance prevents costly downtime and ensures operational efficiency.",
        SUPPORT: "Support",
        SUPPORT_DESC: "Our dedicated support team is available 24/7 to address your concerns and resolve issues quickly. We're committed to keeping your business running smoothly without interruption."
      },
      CONTACT: {
        TITLE: "Contact Us",
        ADDRESS_TITLE: "Our Address",
        PHONE: "Phone",
        EMAIL: "Email",
        MAP_TITLE: "Find Us on the Map",
        MAP_VIEW: "Map View",
        MAP_NOTE: "Integration with Google Maps or similar mapping service would go here"
      },
      FOOTER: {
        COPYRIGHT: "© 2025 Service Business. All rights reserved.",
        LOCATION: "Montreal, QC, Canada"
      }
    };

    // French translations
    this.translations['fr'] = {
      HEADER: {
        TITLE: "Entreprise de Services",
        HOME: "Accueil",
        SERVICES: "Services",
        CONTACT: "Contact"
      },
      HOME: {
        TITLE: "Bienvenue chez Entreprise de Services",
        SUBTITLE: "Nous offrons des services de qualité supérieure adaptés à vos besoins.",
        SERVICE_HIGHLIGHTS: "Nos Services en Vedette",
        CONSULTING: "Consultation",
        CONSULTING_DESC: "Des conseils d'experts pour aider votre entreprise à croître et à réussir.",
        MAINTENANCE: "Maintenance",
        MAINTENANCE_DESC: "Maintenez vos systèmes en bon état de fonctionnement avec nos services de maintenance.",
        SUPPORT: "Support",
        SUPPORT_DESC: "Support 24/7 pour garantir que votre entreprise ne s'arrête jamais."
      },
      SERVICES: {
        TITLE: "Nos Services",
        CONSULTING: "Consultation",
        CONSULTING_DESC: "Nos consultants expérimentés fournissent des conseils stratégiques pour aider votre entreprise à atteindre ses objectifs. Nous analysons vos opérations actuelles et identifions les opportunités d'amélioration et de croissance.",
        MAINTENANCE: "Maintenance",
        MAINTENANCE_DESC: "Nous offrons des services de maintenance complets pour maintenir vos systèmes à leur performance maximale. La maintenance régulière prévient les temps d'arrêt coûteux et assure l'efficacité opérationnelle.",
        SUPPORT: "Support",
        SUPPORT_DESC: "Notre équipe de support dédiée est disponible 24/7 pour répondre à vos préoccupations et résoudre les problèmes rapidement. Nous nous engageons à maintenir votre entreprise en fonctionnement sans interruption."
      },
      CONTACT: {
        TITLE: "Contactez-nous",
        ADDRESS_TITLE: "Notre Adresse",
        PHONE: "Téléphone",
        EMAIL: "Courriel",
        MAP_TITLE: "Trouvez-nous sur la Carte",
        MAP_VIEW: "Vue de la Carte",
        MAP_NOTE: "L'intégration avec Google Maps ou un service de cartographie similaire serait ici"
      },
      FOOTER: {
        COPYRIGHT: "© 2025 Entreprise de Services. Tous droits réservés.",
        LOCATION: "Montréal, QC, Canada"
      }
    };

    // Spanish translations
    this.translations['es'] = {
      HEADER: {
        TITLE: "Empresa de Servicios",
        HOME: "Inicio",
        SERVICES: "Servicios",
        CONTACT: "Contacto"
      },
      HOME: {
        TITLE: "Bienvenido a Empresa de Servicios",
        SUBTITLE: "Ofrecemos servicios de primera clase adaptados a sus necesidades.",
        SERVICE_HIGHLIGHTS: "Nuestros Servicios Destacados",
        CONSULTING: "Consultoría",
        CONSULTING_DESC: "Asesoramiento experto para ayudar a su empresa a crecer y tener éxito.",
        MAINTENANCE: "Mantenimiento",
        MAINTENANCE_DESC: "Mantenga sus sistemas funcionando sin problemas con nuestros servicios de mantenimiento.",
        SUPPORT: "Soporte",
        SUPPORT_DESC: "Soporte 24/7 para asegurar que su negocio nunca se detenga."
      },
      SERVICES: {
        TITLE: "Nuestros Servicios",
        CONSULTING: "Consultoría",
        CONSULTING_DESC: "Nuestros consultores experimentados brindan orientación estratégica para ayudar a su empresa a alcanzar sus objetivos. Analizamos sus operaciones actuales e identificamos oportunidades de mejora y crecimiento.",
        MAINTENANCE: "Mantenimiento",
        MAINTENANCE_DESC: "Ofrecemos servicios de mantenimiento integrales para mantener sus sistemas funcionando al máximo rendimiento. El mantenimiento regular previene costosos tiempos de inactividad y garantiza la eficiencia operativa.",
        SUPPORT: "Soporte",
        SUPPORT_DESC: "Nuestro equipo de soporte dedicado está disponible 24/7 para atender sus inquietudes y resolver problemas rápidamente. Estamos comprometidos a mantener su negocio funcionando sin problemas y sin interrupciones."
      },
      CONTACT: {
        TITLE: "Contáctenos",
        ADDRESS_TITLE: "Nuestra Dirección",
        PHONE: "Teléfono",
        EMAIL: "Correo Electrónico",
        MAP_TITLE: "Encuéntrenos en el Mapa",
        MAP_VIEW: "Vista del Mapa",
        MAP_NOTE: "La integración con Google Maps o un servicio de mapas similar iría aquí"
      },
      FOOTER: {
        COPYRIGHT: "© 2025 Empresa de Servicios. Todos los derechos reservados.",
        LOCATION: "Montreal, QC, Canadá"
      }
    };
  }

  setDefaultLang(lang: string): void {
    this.currentLang = lang;
  }

  use(lang: string): void {
    this.currentLang = lang;
    this.langChangeSubject.next(lang);
  }

  get(key: string, lang?: string): string {
    const language = lang || this.currentLang;
    const keys = key.split('.');
    let value: any = this.translations[language];
    
    for (const k of keys) {
      value = value?.[k];
    }
    
    return value || key;
  }

  getCurrentLang(): string {
    return this.currentLang;
  }

  getBrowserLang(): string | undefined {
    if (typeof window !== 'undefined' && window.navigator) {
      return window.navigator.language.substring(0, 2);
    }
    return undefined;
  }
}