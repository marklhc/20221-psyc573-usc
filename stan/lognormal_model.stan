data {
  int<lower=0> N;  // number of observations
  vector<lower=0>[N] y;  // response time
}
parameters {
  real mu;  // mean for the lognormal component component
  real<lower=0> sigma;  // standard deviation for lognormal
}
model {
  // model
  y ~ lognormal(mu, sigma);
  // priors
  sigma ~ student_t(4, 0, 1);
  mu ~ std_normal();
}
generated quantities {
  vector<lower=0>[N] y_rep;  // place holder
  for (n in 1:N)
    y_rep[n] = lognormal_rng(mu, sigma);
}
