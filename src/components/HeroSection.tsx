import { Button } from "@/components/ui/button";
import { Phone, MessageCircle, Shield } from "lucide-react";
import logoHorizontal from "@/assets/logo-horizontal.png";
import heroVehicles from "@/assets/hero-vehicles.jpg";

export const HeroSection = () => {
  return (
    <section className="relative min-h-screen flex items-center justify-center overflow-hidden bg-gradient-dark">
      {/* Background Image */}
      <div
        className="absolute inset-0 bg-cover bg-center opacity-30"
        style={{ backgroundImage: `url(${heroVehicles})` }} />

      
      {/* Orange Glow Effect */}
      <div className="absolute top-0 right-0 w-1/2 h-1/2 bg-primary/20 blur-[150px] rounded-full" />
      
      <div className="container relative z-10 px-4 py-20">
        <div className="max-w-4xl mx-auto text-center space-y-8">
          {/* Logo */}
          <div className="flex justify-center mb-8 animate-fade-in">
            <img
              src={logoHorizontal}
              alt="Grupo Win - Proteção Veicular"
              className="h-16 md:h-20" />

          </div>
          
          {/* Headline */}
          <div className="space-y-4 animate-fade-in" style={{ animationDelay: '0.1s' }}>
            <h1 className="text-4xl md:text-6xl lg:text-7xl font-black text-white leading-tight font-['Montserrat']">
              PROTEJA SEU VEÍCULO
              <span className="block text-primary mt-2">HOJE MESMO!</span>
            </h1>
            <p className="text-xl md:text-2xl text-gray-300 font-semibold">
              Economize até <span className="text-primary font-bold">50%</span> comparado ao seguro tradicional
            </p>
          </div>
          
          {/* Price Badge */}
          <div className="inline-block bg-gradient-orange p-1 rounded-2xl shadow-glow animate-scale-in" style={{ animationDelay: '0.2s' }}>
            <div className="bg-secondary px-8 py-4 rounded-xl">
              <p className="text-sm text-gray-400 font-medium">A PARTIR DE</p>
              <p className="text-5xl md:text-6xl font-black text-white font-['Montserrat']">R$99/mês
                <span className="text-2xl">/mês</span>
              </p>
              <p className="text-sm text-primary font-bold mt-1">Cobertura 100% FIPE</p>
            </div>
          </div>
          
          {/* Benefits Grid */}
          <div className="grid grid-cols-1 md:grid-cols-3 gap-4 max-w-3xl mx-auto mt-8 animate-fade-in" style={{ animationDelay: '0.3s' }}>
            {[
            { icon: Shield, text: "Roubo, Colisão e Incêndio" },
            { icon: Phone, text: "Assistência 24h" },
            { icon: MessageCircle, text: "Guincho Ilimitado" }].
            map((benefit, index) =>
            <div
              key={index}
              className="flex items-center gap-3 bg-card/50 backdrop-blur-sm px-4 py-3 rounded-lg border border-primary/20">

                <benefit.icon className="w-5 h-5 text-primary flex-shrink-0" />
                <span className="text-sm font-semibold text-white">{benefit.text}</span>
              </div>
            )}
          </div>
          
          {/* CTA Buttons */}
          <div className="flex flex-col sm:flex-row gap-4 justify-center items-center pt-6 animate-fade-in" style={{ animationDelay: '0.4s' }}>
            <Button
              size="lg"
              className="text-lg font-bold px-8 py-6 bg-gradient-orange hover:shadow-glow transition-all duration-300 hover:scale-105"
              asChild>

              <a href="https://wa.me/5511999999999" target="_blank" rel="noopener noreferrer">FAÇA SUA COTAÇÃO AGORA!
                <MessageCircle className="mr-2 h-5 w-5" />
                FAÇA SUA COTAÇÃO GRÁTIS
              </a>
            </Button>
            
            <Button
              size="lg"
              variant="outline"
              className="text-lg font-bold px-8 py-6 border-2 border-primary text-primary hover:bg-primary hover:text-white transition-all duration-300"
              asChild>

              <a className="shadow-sm text-left" href="+55 48 2013-3205">​​PEÇA SEU BOLETO
                <Phone className="mr-2 h-5 w-5" />
                LIGUE AGORA
              </a>
            </Button>
          </div>
          
          {/* Trust Badge */}
          <p className="text-sm text-gray-400 mt-6 animate-fade-in" style={{ animationDelay: '0.5s' }}>
            🔒 Mais de 10.000 veículos protegidos em todo Brasil
          </p>
        </div>
      </div>
    </section>);

};