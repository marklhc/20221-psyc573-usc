data {
  int<lower=0> N;  // number of observations
  vector[N] y;  // outcome;
  vector[N] x;  // predictor;
}
parameters {
  real beta0;  // regression intercept
  real beta1;  // regression coefficient
  real<lower=0> sigma;  // SD of prediction error
}
model {
  // model
  y ~ normal(beta0 + beta1 * x, sigma);
  // prior
  beta0 ~ normal(45, 10);
  beta1 ~ normal(0, 10);
  sigma ~ student_t(4, 0, 5);
}
generated quantities {
  vector[N] y_rep;  // place holder
  for (n in 1:N)
    y_rep[n] = normal_rng(beta0 + beta1 * x[n], sigma);
}
