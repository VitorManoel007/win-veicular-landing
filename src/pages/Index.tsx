import { HeroSection } from "@/components/HeroSection";
import { BenefitsSection } from "@/components/BenefitsSection";
import { ComparisonSection } from "@/components/ComparisonSection";
import { UrgencySection } from "@/components/UrgencySection";
import { PlansSection } from "@/components/PlansSection";
import { Footer } from "@/components/Footer";
import { WhatsAppButton } from "@/components/WhatsAppButton";

const Index = () => {
  return (
    <div className="min-h-screen">
      <HeroSection />
      <BenefitsSection />
      <ComparisonSection />
      <UrgencySection />
      <PlansSection />
      <Footer />
      <WhatsAppButton />
    </div>
  );
};

export default Index;
