# Freshwater eDNA Biodiversity
# Analysis 03: Paired comparison, 2019 vs 2022

# 1. Load original data
edna <- read.csv("data/edna_lg_clean.csv")

# 2. Calculate taxon richness per sample
richness <- aggregate(
  count ~ site + region + landuse + year + round,
  data = transform(edna, count = as.integer(count > 0)),
  FUN = sum
)

names(richness)[names(richness) == "count"] <- "richness"

# 3. Find sites sampled in both years during ROUND1
sites_2019 <- unique(richness$site[
  richness$year == 2019 & richness$round == "ROUND1"
])

sites_2022 <- unique(richness$site[
  richness$year == 2022 & richness$round == "ROUND1"
])

common_sites <- intersect(sites_2019, sites_2022)

# 4. Create paired dataset
paired_data <- subset(
  richness,
  site %in% common_sites & round == "ROUND1"
)

paired_wide <- reshape(
  paired_data[, c("site", "year", "richness")],
  idvar = "site",
  timevar = "year",
  direction = "wide"
)

paired_wide$change <- paired_wide$richness.2022 -
  paired_wide$richness.2019

print(paired_wide)

# 5. Save paired comparison figure
dir.create("outputs/figures", recursive = TRUE, showWarnings = FALSE)

png(
  "outputs/figures/03_paired_richness_2019_2022.png",
  width = 1400,
  height = 1000,
  res = 150
)

matplot(
  x = c(2019, 2022),
  y = t(as.matrix(paired_wide[, c("richness.2019", "richness.2022")])),
  type = "l",
  lty = 1,
  lwd = 2,
  col = "gray60",
  xaxt = "n",
  xlab = "Year",
  ylab = "Detected taxa per site",
  main = "eDNA taxon richness: paired sites (2019 vs 2022)"
)

axis(1, at = c(2019, 2022))

points(
  rep(2019, nrow(paired_wide)),
  paired_wide$richness.2019,
  pch = 16,
  col = "steelblue"
)

points(
  rep(2022, nrow(paired_wide)),
  paired_wide$richness.2022,
  pch = 16,
  col = "darkgreen"
)

dev.off()

# 6. Paired Wilcoxon signed-rank test
wilcox_result <- wilcox.test(
  paired_wide$richness.2022,
  paired_wide$richness.2019,
  paired = TRUE,
  exact = FALSE
)

# 7. Export paired richness results
dir.create("outputs/tables", recursive = TRUE, showWarnings = FALSE)

write.csv(
  paired_wide,
  "outputs/tables/01_paired_richness_2019_2022.csv",
  row.names = FALSE
)
print(wilcox_result)