# Freshwater eDNA Biodiversity
# Analysis 01: Taxon richness by land use

# 1. Load data
edna <- read.csv("data/edna_lg_clean.csv")

# 2. Calculate detected taxon richness per sample
richness <- aggregate(
  count ~ site + region + landuse + year + round,
  data = transform(edna, count = as.integer(count > 0)),
  FUN = sum
)

names(richness)[names(richness) == "count"] <- "richness"

# 3. Summary statistics
print(summary(richness$richness))

# 4. Save figure
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

png(
  "outputs/figures/01_taxon_richness_by_landuse.png",
  width = 1400,
  height = 1000,
  res = 150
)

par(mar = c(11, 5, 4, 2))

boxplot(
  richness ~ landuse,
  data = richness,
  las = 2,
  col = "lightblue",
  main = "eDNA taxon richness by land use",
  xlab = "",
  ylab = "Detected taxa per sample"
)

dev.off()