data {
  int<lower=0> N;  // number of observations
  int<lower=0> p;  // number of predictors
  vector[N] y;  // outcome;
  matrix[N, p] x;  // predictor matrix;
}
parameters {
  real beta0;  // regression intercept
  vector[p] beta;  // regression coefficients
  real<lower=0> sigma;  // SD of prediction error
}
model {
  // model
  y ~ normal_id_glm(x, beta0, beta, sigma);
  // prior
  beta0 ~ normal(0, 5);
  beta ~ std_normal();
  sigma ~ student_t(4, 0, 5);
}
generated quantities {
  vector[N] y_rep;  // place holder
  for (n in 1:N)
    y_rep[n] = normal_rng(beta0 + dot_product(beta, x[n]), sigma);
}
