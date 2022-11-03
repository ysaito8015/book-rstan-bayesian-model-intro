# load packages
pacman::p_load(rstan)

# accerate culculation
rstan_options(auto_write = TRUE) # .rds ファイルへの保存
options(mc.cores = parallel::detectCores()) # 並列計算用のコアの自動指定

# file 読み込み
file_beer_sales_1 <- read.csv("./data/2-4-1-beer-sales-1.csv")

# head
head(file_beer_sales_1)

# cast to list type
sample_size <- nrow(file_beer_sales_1)
data_list <- list(sales = file_beer_sales_1$sales, N = sample_size)

mcmc_result <- stan(
    file = "./stan/2-4-1-calc-mean-variance.stan",
    data = data_list,
    seed = 1,
    chains = 4,
    iter = 2000,
    warmup = 1000,
    thin = 1
)

# check result
print(
      mcmc_result,
      probe = c(0.025, 0.5, 0.975)
)

# plot trace
traceplot(mcmc_result)

# sampling from mcmc_result
mcmc_sample <- rstan:;extract(mcm_result, permuted = FALSE)
class(mcmc_sample)
dim(mcmc_sample)
dimnames(mcmc_sample)

# mean of first colums of chains
mcmc_sample[1, "chain:1", "mu"]

# samples of parameter mu in the first chain
mcmc_sample[, "chain:1", "mu"]
length(mcmc_sample[, "chain:1", "mu"])

# mcmc samples from all chains
length(mcmc_sample[, , "mu"])
dim(mcmc_sample[, , "mu"])
class(mcmc_sample[, , "mu"])

# vectorize
mu_mcmc_vec <- as.vector(mcmc_sample[, ,"mu"])

# median from posterior distribution of mu
median(mu_mcmc_vec)

# mean from posterior distribution of mu
mean(mu_mcmc_vec)

# credible interval from posterior distribution of mu
quantile(mu_mcmc_vec, probs = c(0.025, 0.975))

## ploting traceplot
autoplot(ts(mcmc_sample[, ,"mu"]),
         facets = FALSE,
         ylab = "mu",
         main = "trace plot")

quantile(mu_mcmc_vec, probs = c(0.025, 0.975))

# calculate median, mean...
median(mu_mcmc_vec)
mean(mu_mcmc_vec)
quantile(mu_mcmc_vec, probs = c(0.025, 0.975))

## ploting trace plot
pacman::p_load(ggfortify)
autoplot(ts(mcmc_sample[, ,"mu"]),
    facets = FALSE,
    ylab = "mu",
    main = "trace plot")

## ploting postrior distribution
mu_df <- data.frame(
    mu_mcmc_sample = mu_mcmc_vec
)

pacman::p_load(ggplot2)
ggplot(data = mu_df, mapping = aes(x = mu_mcmc_sample))
    + geom_density(size = 1.5)

pacman::p_load(bayesplot)
mcmc_hist(mcmc_sample, pars = c("mu", "sigma")) # histogram
mcmc_dens(mcmc_sample, pars = c("mu", "sigma")) # kernel density
mcmc_combo(mcmc_sample, pars = c("mu", "sigma"))


# compare to range of posterior distributions
mcmc_intervals(
    mcmc_sample, pars = c("mu", "sigma"),
    prob = 0.8,
    prob_outer = 0.95
)

mcmc_areas(
    mcmc_sample,
    pars = c("mu", "sigma"),
    prob = 0.6,
    prob_outer = 0.99
)

# autocorrelations
mcmc_acf_bar(
    mcmc_sample,
    pars = c("mu", "sigma")
)
