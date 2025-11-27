import { Check } from "lucide-react";

const benefits = [
  {
    title: "COBERTURA COMPLETA",
    items: [
      "Roubo e Furto 100% FIPE",
      "Colisão Total ou Parcial",
      "Incêndio e Explosão",
      "Fenômenos Naturais",
      "Proteção de Vidros e Faróis",
      "Danos a Terceiros"
    ]
  },
  {
    title: "ASSISTÊNCIAS 24H",
    items: [
      "Guincho Ilimitado Nacional",
      "Carro Reserva",
      "Chaveiro 24h",
      "Troca de Pneus",
      "Pane Seca e Elétrica",
      "Reboque em Acidentes"
    ]
  },
  {
    title: "VANTAGENS EXCLUSIVAS",
    items: [
      "Sem Análise de Perfil",
      "Sem Burocracia",
      "Aprovação Imediata",
      "Cobertura Nacional",
      "Preço Fixo Sem Surpresas",
      "Cancelamento Sem Multa"
    ]
  }
];

export const BenefitsSection = () => {
  return (
    <section className="py-20 bg-background">
      <div className="container px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-black text-foreground mb-4 font-['Montserrat']">
            POR QUE ESCOLHER O <span className="text-primary">GRUPO WIN?</span>
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Proteção completa para seu veículo sem as complicações das seguradoras tradicionais
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {benefits.map((benefit, index) => (
            <div 
              key={index}
              className="bg-card border-2 border-border rounded-2xl p-8 hover:border-primary transition-all duration-300 hover:shadow-strong"
            >
              <h3 className="text-2xl font-bold text-primary mb-6 font-['Montserrat']">
                {benefit.title}
              </h3>
              <ul className="space-y-4">
                {benefit.items.map((item, itemIndex) => (
                  <li key={itemIndex} className="flex items-start gap-3">
                    <Check className="w-6 h-6 text-primary flex-shrink-0 mt-0.5" />
                    <span className="text-foreground font-medium">{item}</span>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>
      </div>
    </section>
  );
};
