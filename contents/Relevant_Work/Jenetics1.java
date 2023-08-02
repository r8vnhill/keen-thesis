public class OneMax {
  public static void main(String[] args) {
    RandomRegistry.random(new Random(11));
    final var engine =
        Engine.builder((Genotype<BitGene> gt) ->
                          gt.chromosome().as(BitChromosome.class).bitCount(),
                      BitChromosome.of(20, 0.5))
              .maximizing()
              .populationSize(20)
              .alterers(new Mutator<>(0.05), new SinglePointCrossover<>(0.5))
              .build();
    Phenotype<BitGene, Integer> best = engine.stream()
                                             .limit(Limits.byFitnessThreshold(19))
                                             .collect(EvolutionResult.toBestPhenotype());
    System.out.println("Target fitness reached at generation: " + best.generation());
    System.out.println("Best individual is: " + best.genotype());
    System.out.println("with fitness: " + best.fitness());
  }
}