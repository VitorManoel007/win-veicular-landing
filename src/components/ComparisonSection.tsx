import { X, Check } from "lucide-react";
import { Button } from "@/components/ui/button";

const comparisons = [
  { feature: "Custo Mensal", protection: "A partir de R$68", insurance: "A partir de R$150" },
  { feature: "Burocracia", protection: "Mínima", insurance: "Alta" },
  { feature: "Análise de Perfil", protection: "Não exige", insurance: "Obrigatória" },
  { feature: "Tempo de Aprovação", protection: "Imediato", insurance: "Até 7 dias" },
  { feature: "Guincho", protection: "Ilimitado", insurance: "Limitado" },
  { feature: "Franquia", protection: "R$0", insurance: "R$2.000+" },
  { feature: "Cobertura Nacional", protection: "Sim", insurance: "Depende do plano" },
  { feature: "Cancelamento", protection: "Sem multa", insurance: "Com multa" },
];

export const ComparisonSection = () => {
  return (
    <section className="py-20 bg-gradient-dark relative overflow-hidden">
      <div className="absolute bottom-0 left-0 w-1/2 h-1/2 bg-primary/10 blur-[150px] rounded-full" />
      
      <div className="container px-4 relative z-10">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-black text-white mb-4 font-['Montserrat']">
            PROTEÇÃO VEICULAR <span className="text-primary">VS</span> SEGURO TRADICIONAL
          </h2>
          <p className="text-xl text-gray-300 max-w-2xl mx-auto">
            Veja por que a proteção veicular é a escolha inteligente
          </p>
        </div>
        
        <div className="max-w-4xl mx-auto">
          <div className="bg-card/10 backdrop-blur-sm border-2 border-primary/20 rounded-2xl overflow-hidden">
            {/* Header */}
            <div className="grid grid-cols-3 gap-4 p-6 bg-secondary/50 border-b border-primary/20">
              <div className="text-white font-bold"></div>
              <div className="text-center">
                <div className="bg-gradient-orange px-4 py-2 rounded-lg inline-block">
                  <span className="text-white font-bold text-lg">PROTEÇÃO VEICULAR</span>
                </div>
              </div>
              <div className="text-center">
                <div className="bg-muted/20 px-4 py-2 rounded-lg inline-block">
                  <span className="text-gray-400 font-bold text-lg">SEGURO</span>
                </div>
              </div>
            </div>
            
            {/* Comparison Rows */}
            {comparisons.map((item, index) => (
              <div 
                key={index}
                className={`grid grid-cols-3 gap-4 p-6 ${
                  index % 2 === 0 ? 'bg-card/5' : 'bg-transparent'
                }`}
              >
                <div className="text-white font-semibold">{item.feature}</div>
                <div className="text-center flex items-center justify-center gap-2">
                  <Check className="w-5 h-5 text-primary flex-shrink-0" />
                  <span className="text-white font-medium">{item.protection}</span>
                </div>
                <div className="text-center flex items-center justify-center gap-2">
                  <X className="w-5 h-5 text-red-500 flex-shrink-0" />
                  <span className="text-gray-400 font-medium">{item.insurance}</span>
                </div>
              </div>
            ))}
          </div>
          
          <div className="text-center mt-12">
            <Button 
              size="lg"
              className="text-lg font-bold px-12 py-6 bg-gradient-orange hover:shadow-glow transition-all duration-300 hover:scale-105"
              asChild
            >
              <a href="https://wa.me/5511999999999" target="_blank" rel="noopener noreferrer">
                QUERO ECONOMIZAR AGORA!
              </a>
            </Button>
            <p className="text-sm text-gray-400 mt-4">
              ⏱️ Cotação em menos de 2 minutos
            </p>
          </div>
        </div>
      </div>
    </section>
  );
};
