import { Phone, Mail, MapPin, Instagram, Facebook } from "lucide-react";
import logoHorizontal from "@/assets/logo-horizontal.png";

export const Footer = () => {
  return (
    <footer className="bg-gradient-dark py-16 border-t border-primary/20">
      <div className="container px-4">
        <div className="grid grid-cols-1 md:grid-cols-4 gap-12 mb-12">
          {/* Logo & Description */}
          <div className="md:col-span-2 space-y-4">
            <img 
              src={logoHorizontal} 
              alt="Grupo Win" 
              className="h-12"
            />
            <p className="text-gray-400 max-w-md">
              Proteção veicular completa e acessível. Economize até 50% comparado ao seguro tradicional com toda segurança e tranquilidade que você merece.
            </p>
            <div className="flex gap-4">
              <a 
                href="https://instagram.com" 
                target="_blank" 
                rel="noopener noreferrer"
                className="w-10 h-10 bg-primary/10 hover:bg-primary rounded-full flex items-center justify-center transition-all duration-300 hover:scale-110"
              >
                <Instagram className="w-5 h-5 text-primary hover:text-white" />
              </a>
              <a 
                href="https://facebook.com" 
                target="_blank" 
                rel="noopener noreferrer"
                className="w-10 h-10 bg-primary/10 hover:bg-primary rounded-full flex items-center justify-center transition-all duration-300 hover:scale-110"
              >
                <Facebook className="w-5 h-5 text-primary hover:text-white" />
              </a>
            </div>
          </div>
          
          {/* Contact */}
          <div>
            <h3 className="text-white font-bold text-lg mb-4 font-['Montserrat']">CONTATO</h3>
            <ul className="space-y-3">
              <li>
                <a 
                  href="tel:+5511999999999" 
                  className="flex items-center gap-3 text-gray-400 hover:text-primary transition-colors"
                >
                  <Phone className="w-5 h-5" />
                  <span>(11) 99999-9999</span>
                </a>
              </li>
              <li>
                <a 
                  href="mailto:contato@grupowin.com.br" 
                  className="flex items-center gap-3 text-gray-400 hover:text-primary transition-colors"
                >
                  <Mail className="w-5 h-5" />
                  <span>contato@grupowin.com.br</span>
                </a>
              </li>
              <li className="flex items-start gap-3 text-gray-400">
                <MapPin className="w-5 h-5 flex-shrink-0 mt-1" />
                <span>São Paulo - SP<br/>Brasil</span>
              </li>
            </ul>
          </div>
          
          {/* Quick Links */}
          <div>
            <h3 className="text-white font-bold text-lg mb-4 font-['Montserrat']">LINKS RÁPIDOS</h3>
            <ul className="space-y-3">
              <li>
                <a href="#planos" className="text-gray-400 hover:text-primary transition-colors">
                  Nossos Planos
                </a>
              </li>
              <li>
                <a href="#beneficios" className="text-gray-400 hover:text-primary transition-colors">
                  Benefícios
                </a>
              </li>
              <li>
                <a href="#comparacao" className="text-gray-400 hover:text-primary transition-colors">
                  Comparação
                </a>
              </li>
              <li>
                <a href="https://wa.me/5511999999999" className="text-gray-400 hover:text-primary transition-colors" target="_blank" rel="noopener noreferrer">
                  Fale Conosco
                </a>
              </li>
            </ul>
          </div>
        </div>
        
        {/* Bottom Bar */}
        <div className="pt-8 border-t border-primary/20 text-center text-gray-400 text-sm">
          <p>&copy; {new Date().getFullYear()} Grupo Win - Proteção Veicular. Todos os direitos reservados.</p>
          <p className="mt-2">CNPJ: 00.000.000/0000-00</p>
        </div>
      </div>
    </footer>
  );
};
