data {
  int<lower=0> N1;  // number of observations (group 1)
  int<lower=0> N2;  // number of observations (group 2)
  vector<lower=0>[N1] y1;  // response time (group 1);
  vector<lower=0>[N2] y2;  // response time (group 2);
}
parameters {
  real mu1;  // mean of log(RT) (group 1)
  real<lower=0> sigma;  // SD of log(RT) (shared across groups)
  real dmu;  // mean diff of log(RT) (group 2 - group 1)
}
model {
  // model
  y1 ~ lognormal(mu1, sigma);
  y2 ~ lognormal(mu1 + dmu, sigma);
  // prior
  mu1 ~ normal(0, 1);
  dmu ~ normal(0, 1);
  sigma ~ normal(0, 0.5);
}
generated quantities {
  real mu2 = mu1 + dmu;  // mean of log(RT) (group 2)
  vector<lower=0>[N1] y1_rep;  // place holder
  vector<lower=0>[N2] y2_rep;  // place holder
  for (n in 1:N1)
    y1_rep[n] = lognormal_rng(mu1, sigma);
  for (n in 1:N2)
    y2_rep[n] = lognormal_rng(mu2, sigma);
}
