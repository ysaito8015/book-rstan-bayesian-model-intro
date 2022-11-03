data {
    int N;             // sample size
    vector[N] sales;   // データ
}

parameters {
    real mu;             // Mean
    real<lower=0> sigma; // standard deviation
}

model {
    for (i in 1:N) {
        sales[i] ~ normal(mu, sigma);
    }
}
