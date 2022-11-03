# load packages
pacman::p_load(rstan)

# accerate culculation
rstan_options(auto_write = TRUE) # .rds ファイルへの保存
options(mc.cores = parallel::detectCores()) # 並列計算用のコアの自動指定

# compare models
animal_num <- read.csv("./data/2-5-1-animal-num.csv")
head(animal_num)

sample_size <- nrow(animal_num)

data_list <- list(animal_num = animal_num$animal_num, N = sample_size)

mcmc_normal <- stan(
    file = "./stan/2-5-1-normal-dist.stan",
    data = data_list,
    seed = 1
)

mcmc_poisson <- stan(
    file = "./stan/2-5-1-poisson-dist.stan",
    data = data_list,
    seed = 1
)

## check posterior
y_rep_normal <- rstan::extract(mcmc_normal)$pred
y_rep_poisson <- rstan::extract(mcmc_poisson)$pred

dim(y_rep_normal)
head(y_rep_normal[1,])
head(y_rep_poisson[1,])

hist(animal_num$animal_num)
hist(y_rep_normal[1,])
hist(y_rep_poisson[1,])

ppc_hist(
    y = animal_num$animal_num,
    yrep = y_rep_normal[1:5, ]
)
ppc_hist(
    y = animal_num$animal_num,
    yrep = y_rep_poisson[1:5, ]
)
