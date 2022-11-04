pacman::p_load(rstan, ggplot2)

rstan::rstan_options(auto_write = TRUE)
options(mc.cores = parallel::detectCores())

# load data
file_beer_sales_ab <- read.csv("./data/2-6-1-beer-sales-ab.csv")
head(file_beer_sales_ab)

# plot histogram
ggplot(
    data = file_beer_sales_ab,
    mapping = aes(
        x = sales,
        y = ..density..,
        color = beer_name,
        fill = beer_name
    )
) +
geom_histogram(
    alpha = 0.5,
    position = "identity",
) +
geom_density(
    alpha = 0.5,
    size = 0
)

# make list type from data
sales_a <- file_beer_sales_ab$sales[1:100]
sales_b <- file_beer_sales_ab$sales[101:200]

data_list_ab <- list(
    sales_a = sales_a,
    sales_b = sales_b,
    N = 100
)

# run mcmc
mcmc_result_6 <- stan(
    file = "./stan/2-6-5-difference-mean.stan",
    data = data_list_ab,
    seed = 1
)

# print result
print(
    mcmc_result_6,
    probs = c(0.025, 0.5, 0.975)
)

# plot posterior distoribution
mcmc_sample <- rstan::extract(mcmc_result_6, permuted = FALSE)
bayesplot::mcmc_dens(mcmc_sample, pars = "diff")
