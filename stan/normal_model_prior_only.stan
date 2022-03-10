data {
  int<lower=0> N;  // number of observations
  vector[N] y;  // data vector y
}
parameters {
  real mu;  // mean parameter
  real<lower=0> sigma;  // non-negative SD parameter
}
model {
  // model
  // y ~ normal(mu, sigma);  // use vectorization
  // prior
  mu ~ normal(5, 10);
  sigma ~ student_t(4, 0, 3);
}
generated quantities {
  vector[N] y_rep;  // place holder
  for (n in 1:N)
    y_rep[n] = normal_rng(mu, sigma);
}
