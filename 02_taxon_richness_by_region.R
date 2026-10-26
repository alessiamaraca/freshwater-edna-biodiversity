# Freshwater eDNA Biodiversity
# Analysis 02: Taxon richness by region
# Data subset: 2022, ROUND1

# 1. Load original data
edna <- read.csv("data/edna_lg_clean.csv")

# 2. Calculate detected taxon richness per sample
richness <- aggregate(
  count ~ site + region + landuse + year + round,
  data = transform(edna, count = as.integer(count > 0)),
  FUN = sum
)

names(richness)[names(richness) == "count"] <- "richness"

# 3. Select comparable samples
richness_2022 <- subset(
  richness,
  year == 2022 & round == "ROUND1"
)

# 4. Check sample sizes
print(table(richness_2022$region))

# 5. Save figure
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

png(
  "outputs/figures/02_taxon_richness_by_region.png",
  width = 1400,
  height = 1000,
  res = 150
)

par(mar = c(10, 5, 4, 2))

boxplot(
  richness ~ region,
  data = richness_2022,
  col = "lightgreen",
  las = 2,
  main = "eDNA taxon richness by region (2022, Round 1)",
  xlab = "",
  ylab = "Detected taxa per sample"
)

stripchart(
  richness ~ region,
  data = richness_2022,
  vertical = TRUE,
  method = "jitter",
  pch = 16,
  col = "darkgreen",
  add = TRUE
)

dev.off()
