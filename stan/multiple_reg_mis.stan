data {
  int<lower=0> N_obs;  // number of observations
  int<lower=0> N_mis;  // number of observations missing Y
  int<lower=0> p;  // number of predictors
  vector[N_obs] y_obs;  // outcome observed;
  matrix[N_obs, p] x_obs;  // predictor matrix (observed);
  matrix[N_mis, p] x_mis;  // predictor matrix (missing);
}
parameters {
  real beta0;  // regression intercept
  vector[p] beta;  // regression coefficients
  real<lower=0> sigma;  // SD of prediction error
  vector[N_mis] y_mis;  // outcome missing;
}
model {
  // model
  y_obs ~ normal_id_glm(x_obs, beta0, beta, sigma);
  y_mis ~ normal_id_glm(x_mis, beta0, beta, sigma);
  // prior
  beta0 ~ normal(0, 5);
  beta ~ normal(0, 2);
  sigma ~ student_t(4, 0, 5);
}
generated quantities {
  vector[N_obs] y_rep;  // place holder
  for (n in 1:N_obs)
    y_rep[n] = normal_rng(beta0 + dot_product(beta, x_obs[n]), sigma);
}
