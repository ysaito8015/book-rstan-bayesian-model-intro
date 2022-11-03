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


