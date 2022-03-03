data {
  int<lower=0> J;          // number of schools 
  real y[J];               // estimated treatment effects
  real<lower=0> sigma[J];  // s.e. of effect estimates 
}
parameters {
  real mu;                 // overall mean
  real<lower=0> tau;       // between-school SD
  vector[J] eta;           // standardized deviation (z score)
}
transformed parameters {
  vector[J] theta;
  theta = mu + tau * eta;   // non-centered parameterization
}
model {
  eta ~ std_normal();       // same as eta ~ normal(0, 1);
  y ~ normal(theta, sigma);
  // priors
  mu ~ normal(0, 100);
  tau ~ student_t(4, 0, 100);
}
