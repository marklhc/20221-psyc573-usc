library(here)
library(magrittr)
library(dplyr)
library(tidyr)
library(ggplot2)
library(brms)

datfile <- here("data_files", "ENDFILE.xlsx")
if (!file.exists(datfile)) {
    dir.create(here("data_files"))
    download.file("https://osf.io/gtjf6/download",
        destfile = datfile
    )
}

lies <- readxl::read_excel(here("data_files", "ENDFILE.xlsx"))

# Rescale response time from ms to sec
lies <- lies %>%
    mutate_at(vars(LDMRT:TEMRT), ~ . / 1000)
# Describe the data
psych::describe(lies %>% select(Age, LDMRT:TEMRT))

lies_long <- lies %>%
    select(PP, Gender, LDMRT:TEMRT) %>%
    pivot_longer(
        LDMRT:TEMRT,
        names_to = c("veracity", "language"),
        names_pattern = "(L|T)(D|E)MRT",
        values_to = "RT"
    )
m3_brm <- brm(
    RT ~ 0 + Intercept + language * veracity + (1 | PP),
    data = lies_long,
    family = student(),
    prior = c(
        prior(normal(0, 1), class = "b"),
        prior(student_t(4, 0, 2.5), class = "sd"),
        prior(student_t(4, 0, 2.5), class = "sigma")
    ),
    sample_prior = TRUE,
    backend = "cmdstanr",
    iter = 2000,
    cores = 2
)

p_int <- conditional_effects(m3_brm,
    effects = "veracity:language",
    plot = FALSE
)

h123 <- hypothesis(m3_brm,
    hypothesis = c(
        `Language (Main)` =
            "Intercept + veracityT = languageE + languageE:veracityT",
        `Veracity (Main)` =
            "Intercept + languageE = veracityT + languageE:veracityT",
        `Interaction` = "languageE:veracityT = 0"
    )
)

pp_dens <- pp_check(m3_brm,
    type = "dens_overlay_grouped",
    ndraws = 50,
    group = "veracity"
)

pp_cond <- posterior_epred(m3_brm,
    newdata = distinct(lies_long, language, veracity),
    re_formula = NA
) %>%
    `colnames<-`(c("LD", "TD", "LE", "TE")) %>%
    bayesplot::mcmc_dens(
        facet_args = list(scales = "fixed")
    )

mcmc_diff <-
    mcmc_plot(m3_brm, type = "dens", variable = "b_languageE") +
    xlim(-1, 1) +
    labs(x = "E - D for lies (second)") +
    bayesplot::vline_at(c(-0.1, 0.1), col = "red")
