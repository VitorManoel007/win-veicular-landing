import { AlertTriangle } from "lucide-react";
import { Button } from "@/components/ui/button";
import accidentScene from "@/assets/accident-scene.jpg";

export const UrgencySection = () => {
  return (
    <section className="py-20 bg-background relative overflow-hidden">
      <div className="container px-4">
        <div className="max-w-6xl mx-auto">
          <div className="grid grid-cols-1 lg:grid-cols-2 gap-12 items-center">
            {/* Image Side */}
            <div className="relative">
              <div className="absolute inset-0 bg-gradient-orange opacity-20 blur-3xl rounded-full" />
              <img 
                src={accidentScene}
                alt="Acidente de Trânsito"
                className="relative rounded-2xl shadow-strong w-full h-auto"
              />
            </div>
            
            {/* Content Side */}
            <div className="space-y-6">
              <div className="inline-flex items-center gap-2 bg-destructive/10 border border-destructive/30 px-4 py-2 rounded-full">
                <AlertTriangle className="w-5 h-5 text-destructive" />
                <span className="text-destructive font-bold text-sm">ALERTA URGENTE</span>
              </div>
              
              <h2 className="text-4xl md:text-5xl font-black text-foreground leading-tight font-['Montserrat']">
                NÃO SEJA A PRÓXIMA <span className="text-primary">VÍTIMA!</span>
              </h2>
              
              <div className="space-y-4 text-lg text-muted-foreground">
                <p className="font-semibold text-foreground">
                  Você sabia que a cada <span className="text-primary font-bold">10 minutos</span> um veículo é roubado no Brasil?
                </p>
                
                <p>
                  Mais de <span className="text-primary font-bold">400 mil acidentes</span> acontecem anualmente nas estradas brasileiras. 
                  <span className="text-foreground font-semibold"> Seu veículo está protegido?</span>
                </p>
                
                <p>
                  Acidentes, roubos e imprevistos <span className="font-semibold text-foreground">não avisam quando vão acontecer</span>. 
                  O prejuízo pode chegar a <span className="text-primary font-bold">centenas de milhares de reais</span>.
                </p>
                
                <div className="bg-primary/10 border-l-4 border-primary p-6 rounded-lg mt-6">
                  <p className="text-foreground font-bold text-xl">
                    Não espere o pior acontecer para se arrepender!
                  </p>
                  <p className="text-muted-foreground mt-2">
                    Proteja seu patrimônio agora e tenha tranquilidade para dirigir.
                  </p>
                </div>
              </div>
              
              <Button 
                size="lg"
                className="text-lg font-bold px-10 py-6 bg-gradient-orange hover:shadow-glow transition-all duration-300 hover:scale-105 w-full sm:w-auto"
                asChild
              >
                <a href="https://wa.me/5511999999999" target="_blank" rel="noopener noreferrer">
                  PROTEGER MEU VEÍCULO AGORA!
                </a>
              </Button>
            </div>
          </div>
        </div>
      </div>
    </section>
  );
};
