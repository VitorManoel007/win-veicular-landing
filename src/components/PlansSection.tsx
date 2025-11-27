import { Check } from "lucide-react";
import { Button } from "@/components/ui/button";

const plans = [
  {
    name: "BÁSICO",
    price: "68",
    description: "Proteção essencial para seu veículo",
    features: [
      "Roubo e Furto 100% FIPE",
      "Incêndio e Explosão",
      "Assistência 24h",
      "Guincho até 300km",
      "Chaveiro 24h",
      "Cobertura Nacional"
    ]
  },
  {
    name: "COMPLETO",
    price: "128",
    description: "Proteção total com assistências premium",
    features: [
      "Tudo do Plano Básico",
      "Colisão Total ou Parcial",
      "Guincho Ilimitado",
      "Carro Reserva 15 dias",
      "Proteção de Vidros",
      "Proteção de Faróis",
      "Danos a Terceiros"
    ],
    popular: true
  },
  {
    name: "PREMIUM",
    price: "198",
    description: "Máxima proteção e benefícios exclusivos",
    features: [
      "Tudo do Plano Completo",
      "Fenômenos Naturais",
      "Carro Reserva 30 dias",
      "Proteção de Retrovisores",
      "Assistência Pet",
      "Desconto em Oficinas",
      "Sem Franquia"
    ]
  }
];

export const PlansSection = () => {
  return (
    <section className="py-20 bg-muted/30">
      <div className="container px-4">
        <div className="text-center mb-16">
          <h2 className="text-4xl md:text-5xl font-black text-foreground mb-4 font-['Montserrat']">
            ESCOLHA SEU <span className="text-primary">PLANO IDEAL</span>
          </h2>
          <p className="text-xl text-muted-foreground max-w-2xl mx-auto">
            Proteção completa com o melhor custo-benefício do mercado
          </p>
        </div>
        
        <div className="grid grid-cols-1 md:grid-cols-3 gap-8 max-w-6xl mx-auto">
          {plans.map((plan, index) => (
            <div 
              key={index}
              className={`relative bg-card border-2 rounded-2xl p-8 hover:shadow-strong transition-all duration-300 ${
                plan.popular 
                  ? 'border-primary shadow-glow transform scale-105' 
                  : 'border-border hover:border-primary'
              }`}
            >
              {plan.popular && (
                <div className="absolute -top-4 left-1/2 transform -translate-x-1/2">
                  <div className="bg-gradient-orange px-6 py-2 rounded-full">
                    <span className="text-white font-bold text-sm">MAIS ESCOLHIDO</span>
                  </div>
                </div>
              )}
              
              <div className="text-center mb-6">
                <h3 className="text-2xl font-black text-foreground mb-2 font-['Montserrat']">
                  {plan.name}
                </h3>
                <p className="text-sm text-muted-foreground mb-4">{plan.description}</p>
                <div className="flex items-baseline justify-center gap-2">
                  <span className="text-5xl font-black text-primary">R${plan.price}</span>
                  <span className="text-lg text-muted-foreground">/mês</span>
                </div>
              </div>
              
              <ul className="space-y-4 mb-8">
                {plan.features.map((feature, featureIndex) => (
                  <li key={featureIndex} className="flex items-start gap-3">
                    <Check className="w-5 h-5 text-primary flex-shrink-0 mt-0.5" />
                    <span className="text-foreground font-medium text-sm">{feature}</span>
                  </li>
                ))}
              </ul>
              
              <Button 
                className={`w-full font-bold py-6 transition-all duration-300 ${
                  plan.popular
                    ? 'bg-gradient-orange hover:shadow-glow hover:scale-105'
                    : 'bg-secondary hover:bg-primary'
                }`}
                asChild
              >
                <a href="https://wa.me/5511999999999" target="_blank" rel="noopener noreferrer">
                  CONTRATAR AGORA
                </a>
              </Button>
            </div>
          ))}
        </div>
        
        <p className="text-center text-sm text-muted-foreground mt-8">
          💳 Parcelamento em até 12x no cartão | 🔒 Pagamento 100% seguro
        </p>
      </div>
    </section>
  );
};
